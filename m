Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbXLEDSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbXLEDSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 22:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbXLEDSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 22:18:13 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:55206 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbXLEDSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 22:18:11 -0500
Date: Tue, 4 Dec 2007 22:17:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Holmes - Sun Microsystems <David.Holmes@Sun.COM>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -v2] fix for futex_wait signal stack corruption
In-Reply-To: <alpine.LFD.0.9999.0712041740490.13796@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0712042135030.18314@gandalf.stny.rr.com>
References: <1196801858.1645.37.camel@localhost.localdomain>
 <alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org>
 <20071204213924.GA14915@goodmis.org> <alpine.LFD.0.9999.0712041436100.13796@woody.linux-foundation.org>
 <Pine.LNX.4.58.0712042016540.18042@gandalf.stny.rr.com>
 <alpine.LFD.0.9999.0712041740490.13796@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

The solution I did to solve this (with input from Linus Torvalds)
was to add unions to the restart_block to allow system calls to
use the restart with specific parameters.  This way the futex code now
saves the time in a 64bit value in the restart block instead of storing
it on the stack.

Note: I'm a bit nervious to add "linux/types.h" and use u32 and u64
in thread_info.h, when there's a #ifdef __KERNEL__ just below that.
Not sure what that is there for.  If this turns out to be a problem, I've
tested this with using "unsigned int" for u32 and "unsigned long long" for
u64 and it worked just the same. I'm using u32 and u64 just to be
consistent with what the futex code uses.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

 include/linux/thread_info.h |   15 ++++++++++++++-
 kernel/futex.c              |   25 +++++++++++++------------
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 1c4eb41..d97c874 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -7,12 +7,25 @@
 #ifndef _LINUX_THREAD_INFO_H
 #define _LINUX_THREAD_INFO_H

+#include <linux/types.h>
+
 /*
  * System call restart block.
  */
 struct restart_block {
 	long (*fn)(struct restart_block *);
-	unsigned long arg0, arg1, arg2, arg3;
+	union {
+		struct {
+			unsigned long arg0, arg1, arg2, arg3;
+		};
+		/* For futex_wait */
+		struct {
+			u32 *uaddr;
+			u32 val;
+			u32 flags;
+			u64 time;
+		} fu;
+	};
 };

 extern long do_no_restart_syscall(struct restart_block *parm);
diff --git a/kernel/futex.c b/kernel/futex.c
index 9dc591a..ad3b6e3 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1149,9 +1149,9 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,

 /*
  * In case we must use restart_block to restart a futex_wait,
- * we encode in the 'arg3' shared capability
+ * we encode in the 'flags' shared capability
  */
-#define ARG3_SHARED  1
+#define FLAGS_SHARED  1

 static long futex_wait_restart(struct restart_block *restart);

@@ -1290,12 +1290,13 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 		struct restart_block *restart;
 		restart = &current_thread_info()->restart_block;
 		restart->fn = futex_wait_restart;
-		restart->arg0 = (unsigned long)uaddr;
-		restart->arg1 = (unsigned long)val;
-		restart->arg2 = (unsigned long)abs_time;
-		restart->arg3 = 0;
+		restart->fu.uaddr = (u32*)uaddr;
+		restart->fu.val = val;
+		restart->fu.time = abs_time->tv64;
+		restart->fu.flags = 0;
+
 		if (fshared)
-			restart->arg3 |= ARG3_SHARED;
+			restart->fu.flags |= FLAGS_SHARED;
 		return -ERESTART_RESTARTBLOCK;
 	}

@@ -1310,15 +1311,15 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,

 static long futex_wait_restart(struct restart_block *restart)
 {
-	u32 __user *uaddr = (u32 __user *)restart->arg0;
-	u32 val = (u32)restart->arg1;
-	ktime_t *abs_time = (ktime_t *)restart->arg2;
+	u32 __user *uaddr = (u32 __user *)restart->fu.uaddr;
 	struct rw_semaphore *fshared = NULL;
+	ktime_t t;

+	t.tv64 = restart->fu.time;
 	restart->fn = do_no_restart_syscall;
-	if (restart->arg3 & ARG3_SHARED)
+	if (restart->fu.flags & FLAGS_SHARED)
 		fshared = &current->mm->mmap_sem;
-	return (long)futex_wait(uaddr, fshared, val, abs_time);
+	return (long)futex_wait(uaddr, fshared, restart->fu.val, &t);
 }


