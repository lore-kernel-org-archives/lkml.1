Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbZJECt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbZJECt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 22:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758110AbZJECt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 22:49:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59492 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbZJECtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 22:49:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Timo Sirainen <tss@iki.fi>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20091005112314.5F89.A69D9226@jp.fujitsu.com>
References: <3e8340490910041921p315f3726me0143f2516022f66@mail.gmail.com> <20091005112314.5F89.A69D9226@jp.fujitsu.com>
Message-Id: <20091005114236.5F8C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  5 Oct 2009 11:48:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > No, the scenario is:
> > 
> > Process B: Enter proc_pid_cmdline(), read arg_start and arg_end into
> > CPU registers
> > Process A: prctl(PR_SET_PROCTITLE_AREA)....
> > Process A: free(old_arg_area);
> > Process A: char *foo = malloc(...);
> > Process A: strcpy(foo, super_secret_password);
> > Process B: access_process_vm - using an area overlapping foo
> > 
> > Process B now has process A's secrets. This cannot be avoided by
> > process A, as it cannot control when process B will complete
> > proc_pid_cmdline(), and so the kernel must protect against this
> > scenario.  The only way a userspace process could prevent this is by
> > only using PR_SET_PROCTITLE_AREA once, and never reusing that memory,
> > ever. This does not seem like an appropriate restriction to pass down
> > to userspace for me...
> > 
> > Anyway, I'm working on a patch that uses the generation-counter approach now :)
> 
> Ok, you are right.
> Plus, I've finished to made generation-counter approach patch :)

Updated version is here.
Changelog
 - since v2
      - use seqlock instead tasklock
  - since Timo's original
      - Added task_lock() to prctl(PR_SET_PROCTITLE_AREA)
      -  Added small input sanity check to prctl(PR_SET_PROCTITLE_AREA)


==============================================
Subject: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()

Currently, glibc2 doesn't have setproctitle(3). it lead userland daemon
to use brutal stack modification.

In the first implession, It seems no problem at all. however, carefully
inspection spot the weaknes of the way.

example:

 % ps -ef |grep avahi-daemon
 avahi     1679     1  0 09:20 ?        00:00:00 avahi-daemon: running [kosadesk.local]
 avahi     1680  1679  0 09:20 ?        00:00:00 avahi-daemon: chroot helper

 # cat /proc/1679/cmdline
 avahi-daemon: running [kosadesk.local]

ok. seems good.
but...

 # cat /proc/1679/environ
 adesk.local]

Doh, this daemon has overwritten envrionment string area.

Recently, many security folks is thinking information leak is
security risk. then many administrator unset almost environment
variable before starting the daemon.
  e.g.
    env - MINIMUM-NEED-VAR=foo /path/to/daemon

it mean, we don't have enough string space now.

Thus, this patch implement new prctl. prctl(PR_SET_PROCTITLE_AREA)
updates mm_struct->arg_start and arg_end to the given pointers,
which makes it possible for user space to implement
setproctitle(3) cleanly.

 test_setproctitle.c
 ================================================
 #define ERR(str) (perror(str), exit(1))

 void settitle(char* title){
         int err;

         err = prctl(34, title, strlen(title)+1);
         if (err < 0)
                 ERR("prctl ");
 }

 void main(void){
         long i;
         char buf[1024];

         for (i = 0; i < 10000000000LL; i++){
                 sprintf(buf, "loooooooooooooooooooooooong string %d",i);
                 settitle(buf);
         }
 }
 ==================================================

Cc: Bryan Donlan <bdonlan@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Timo Sirainen <tss@iki.fi>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/base.c           |   57 +++++++++++++++++++++++++++++-----------------
 include/linux/mm_types.h |    2 +
 include/linux/prctl.h    |    4 +++
 kernel/fork.c            |    1 +
 kernel/sys.c             |   23 ++++++++++++++++++
 5 files changed, 66 insertions(+), 21 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6f742f6..2f48440 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -255,32 +255,47 @@ static int proc_pid_cmdline(struct task_struct *task, char * buffer)
 	int res = 0;
 	unsigned int len;
 	struct mm_struct *mm = get_task_mm(task);
+	unsigned seq;
+
 	if (!mm)
 		goto out;
+
+	/* The process was not constructed yet? */
 	if (!mm->arg_end)
-		goto out_mm;	/* Shh! No looking before we're done */
+		goto out_mm;
 
- 	len = mm->arg_end - mm->arg_start;
- 
-	if (len > PAGE_SIZE)
-		len = PAGE_SIZE;
- 
-	res = access_process_vm(task, mm->arg_start, buffer, len, 0);
-
-	// If the nul at the end of args has been overwritten, then
-	// assume application is using setproctitle(3).
-	if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
-		len = strnlen(buffer, res);
-		if (len < res) {
-		    res = len;
-		} else {
-			len = mm->env_end - mm->env_start;
-			if (len > PAGE_SIZE - res)
-				len = PAGE_SIZE - res;
-			res += access_process_vm(task, mm->env_start, buffer+res, len, 0);
+	do {
+		seq = read_seqbegin(&mm->arg_lock);
+
+		len = mm->arg_end - mm->arg_start;
+		if (len > PAGE_SIZE)
+			len = PAGE_SIZE;
+
+		res = access_process_vm(task, mm->arg_start, buffer, len, 0);
+
+		if (mm->arg_end != mm->env_start)
+			/* PR_SET_PROCTITLE_AREA used */
 			res = strnlen(buffer, res);
+		else if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
+			/*
+			 * If the nul at the end of args has been overwritten,
+			 * then assume application is using sendmail's
+			 * SPT_REUSEARGV style argv override.
+			 */
+			len = strnlen(buffer, res);
+			if (len < res) {
+				res = len;
+			} else {
+				len = mm->env_end - mm->env_start;
+				if (len > PAGE_SIZE - res)
+					len = PAGE_SIZE - res;
+				res += access_process_vm(task, mm->env_start,
+							 buffer+res, len, 0);
+				res = strnlen(buffer, res);
+			}
 		}
-	}
+	} while (read_seqretry(&mm->arg_lock, seq));
+
 out_mm:
 	mmput(mm);
 out:
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 0042090..9daa1fa 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -12,6 +12,7 @@
 #include <linux/completion.h>
 #include <linux/cpumask.h>
 #include <linux/page-debug-flags.h>
+#include <linux/seqlock.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 
@@ -236,6 +237,7 @@ struct mm_struct {
 	unsigned long stack_vm, reserved_vm, def_flags, nr_ptes;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long start_brk, brk, start_stack;
+	seqlock_t arg_lock;
 	unsigned long arg_start, arg_end, env_start, env_end;
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index b00df4c..feffb17 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -88,4 +88,8 @@
 #define PR_TASK_PERF_COUNTERS_DISABLE		31
 #define PR_TASK_PERF_COUNTERS_ENABLE		32
 
+
+/* Set process title memory area for setproctitle() */
+#define PR_SET_PROCTITLE_AREA 34
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index bfee931..9eaa1cb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -435,6 +435,7 @@ static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
 	mm->free_area_cache = TASK_UNMAPPED_BASE;
 	mm->cached_hole_size = ~0UL;
 	mm_init_owner(mm, p);
+	seqlock_init(&mm->arg_lock);
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index b3f1097..e26c687 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1528,6 +1528,29 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 				current->timer_slack_ns = arg2;
 			error = 0;
 			break;
+		case PR_SET_PROCTITLE_AREA: {
+			struct mm_struct *mm = current->mm;
+			unsigned long addr = arg2;
+			unsigned long len = arg3;
+			unsigned long end = arg2 + arg3;
+
+			if (len > PAGE_SIZE)
+				return -EINVAL;
+
+			if (addr >= end)
+				return -EINVAL;
+
+			if (!access_ok(VERIFY_READ, addr, len)) {
+				return -EFAULT;
+			}
+
+			write_seqlock(&mm->arg_lock);
+			mm->arg_start = addr;
+			mm->arg_end = addr + len;
+			write_sequnlock(&mm->arg_lock);
+
+			return 0;
+		}
 		default:
 			error = -EINVAL;
 			break;
-- 
1.6.2.5



