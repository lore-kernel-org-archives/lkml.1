Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZJFC5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZJFC5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 22:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbZJFC5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 22:57:22 -0400
Received: from dovecot.org ([82.118.211.50]:33298 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115AbZJFC5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 22:57:21 -0400
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
From: Timo Sirainen <tss@iki.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Bryan Donlan <bdonlan@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20091005114236.5F8C.A69D9226@jp.fujitsu.com>
References: <3e8340490910041921p315f3726me0143f2516022f66@mail.gmail.com>
	 <20091005112314.5F89.A69D9226@jp.fujitsu.com>
	 <20091005114236.5F8C.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 05 Oct 2009 18:56:42 -0400
Message-Id: <1254783402.7406.48.camel@hurina>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 11:48 +0900, KOSAKI Motohiro wrote:
> Updated version is here.
> Changelog
>  - since v2
>       - use seqlock instead tasklock
>   - since Timo's original
>       - Added task_lock() to prctl(PR_SET_PROCTITLE_AREA)
>       -  Added small input sanity check to prctl(PR_SET_PROCTITLE_AREA)

I cleaned up the description somewhat as per Motohiro's request. The
actual patch is identical.

==============================================
Subject: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()

Currently glibc2 doesn't have setproctitle(3), so several userland 
daemons attempt to emulate it by doing some brutal stack modifications.
This works most of the time, but it has problems. For example:

 % ps -ef |grep avahi-daemon
 avahi     1679     1  0 09:20 ?        00:00:00 avahi-daemon: running [kosadesk.local]

 # cat /proc/1679/cmdline
 avahi-daemon: running [kosadesk.local]

This looks good, but the process has also overwritten its environment
area and made the environ file useless:

 # cat /proc/1679/environ
 adesk.local]

Another problem is that the process title length is limited by the size of
the environment. Security conscious people try to avoid potential information
leaks by clearing most of the environment before running a daemon:

 # env - MINIMUM_NEEDED_VAR=foo /path/to/daemon

The resulting environment size may be too small to fit the wanted process
titles.

This patch makes it possible for userspace to implement setproctitle()
cleanly. It adds a new PR_SET_PROCTITLE_AREA option for prctl(), which
updates task's mm_struct->arg_start and arg_end to the given area.

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
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Timo Sirainen <tss@iki.fi>
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


