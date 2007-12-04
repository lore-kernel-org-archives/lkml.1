Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbXLDU6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbXLDU6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXLDU60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:58:26 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:53481 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbXLDU6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:58:25 -0500
Subject: [PATCH] fix for futex_wait signal stack corruption
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       David Holmes - Sun Microsystems <David.Holmes@Sun.COM>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 15:57:38 -0500
Message-Id: <1196801858.1645.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Holmes found a bug in the RT patch with respect to
pthread_cond_timedwait. After trying his test program on the latest git
from mainline, I found the bug was there too.  The bug he was seeing
that his test program showed, was that if one were to do a "Ctrl-Z" on a
process that was in the pthread_cond_timedwait, and then did a "bg" on
that process, it would return with a "-ETIMEDOUT" but early. That is,
the timer would go off early.

Looking into this, I found the source of the problem. And it is a rather
nasty bug at that.

Here's the relevant code from kernel/futex.c: (not in order in the file)

[...]
smlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
                          struct timespec __user *utime, u32 __user *uaddr2,
                          u32 val3)
{
        struct timespec ts;
        ktime_t t, *tp = NULL;
        u32 val2 = 0;
        int cmd = op & FUTEX_CMD_MASK;

        if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI)) {
                if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
                        return -EFAULT;
                if (!timespec_valid(&ts))
                        return -EINVAL;

                t = timespec_to_ktime(ts);
                if (cmd == FUTEX_WAIT)
                        t = ktime_add(ktime_get(), t);
                tp = &t;
        }
[...]
        return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
}

[...]

long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
                u32 __user *uaddr2, u32 val2, u32 val3)
{
        int ret;
        int cmd = op & FUTEX_CMD_MASK;
        struct rw_semaphore *fshared = NULL;

        if (!(op & FUTEX_PRIVATE_FLAG))
                fshared = &current->mm->mmap_sem;

        switch (cmd) {
        case FUTEX_WAIT:
                ret = futex_wait(uaddr, fshared, val, timeout);

[...]

static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
                      u32 val, ktime_t *abs_time)
{
[...]
               struct restart_block *restart;
                restart = &current_thread_info()->restart_block;
                restart->fn = futex_wait_restart;
                restart->arg0 = (unsigned long)uaddr;
                restart->arg1 = (unsigned long)val;
                restart->arg2 = (unsigned long)abs_time;
                restart->arg3 = 0;
                if (fshared)
                        restart->arg3 |= ARG3_SHARED;
                return -ERESTART_RESTARTBLOCK;
[...]

static long futex_wait_restart(struct restart_block *restart)
{
        u32 __user *uaddr = (u32 __user *)restart->arg0;
        u32 val = (u32)restart->arg1;
        ktime_t *abs_time = (ktime_t *)restart->arg2;
        struct rw_semaphore *fshared = NULL;

        restart->fn = do_no_restart_syscall;
        if (restart->arg3 & ARG3_SHARED)
                fshared = &current->mm->mmap_sem;
        return (long)futex_wait(uaddr, fshared, val, abs_time);
}


So when the futex_wait is interrupt by a signal we break out of the
hrtimer code and set up or return from signal. This code does not return
back to userspace, so we set up a RESTARTBLOCK.  The bug here is that we
save the "abs_time" which is a pointer to the stack variable "ktime_t t"
from sys_futex.

This returns and unwinds the stack before we get to call our signal. On
return from the signal we go to futex_wait_restart, where we update all
the parameters for futex_wait and call it. But here we have a problem
where abs_time is no longer valid.

I verified this with print statements, and sure enough, what abs_time
was set to ends up being garbage when we get to futex_wait_restart.

The solution I did to solve this is to allocate a temporary buffer when
setting up the block and free it in futex_wait_restart. This patch
allows David's test program to actually pass.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/futex.c b/kernel/futex.c
index 9dc591a..74be1cb 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1288,11 +1288,27 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 		return -ERESTARTSYS;
 	else {
 		struct restart_block *restart;
+		ktime_t *tmp_time = NULL;
+
+		/*
+		 * abs_time is on the stack and is not a parameter.
+		 * If we save it, it will be overridden on return and
+		 * what is sent to futex_wait_restart will be corrupted.
+		 */
+		if (abs_time) {
+			tmp_time = kmalloc(sizeof(*tmp_time), GFP_KERNEL);
+			if (unlikely(!tmp_time))
+				/* Ahh, what else can we do?? */
+				printk(KERN_WARNING
+				       "Can't allocate temp timer storage\n");
+			else
+				*tmp_time = *abs_time;
+		}
 		restart = &current_thread_info()->restart_block;
 		restart->fn = futex_wait_restart;
 		restart->arg0 = (unsigned long)uaddr;
 		restart->arg1 = (unsigned long)val;
-		restart->arg2 = (unsigned long)abs_time;
+		restart->arg2 = (unsigned long)tmp_time;
 		restart->arg3 = 0;
 		if (fshared)
 			restart->arg3 |= ARG3_SHARED;
@@ -1312,13 +1328,19 @@ static long futex_wait_restart(struct restart_block *restart)
 {
 	u32 __user *uaddr = (u32 __user *)restart->arg0;
 	u32 val = (u32)restart->arg1;
-	ktime_t *abs_time = (ktime_t *)restart->arg2;
+	ktime_t *tmp_time = (ktime_t *)restart->arg2;
+	ktime_t t;
 	struct rw_semaphore *fshared = NULL;
 
+	if (tmp_time) {
+		t = *tmp_time;
+		kfree(tmp_time);
+		tmp_time = &t;
+	}
 	restart->fn = do_no_restart_syscall;
 	if (restart->arg3 & ARG3_SHARED)
 		fshared = &current->mm->mmap_sem;
-	return (long)futex_wait(uaddr, fshared, val, abs_time);
+	return (long)futex_wait(uaddr, fshared, val, tmp_time);
 }
 
 


