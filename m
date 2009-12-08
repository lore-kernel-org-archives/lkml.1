Return-Path: <linux-kernel-owner+w=401wt.eu-S935128AbZLHDPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935128AbZLHDPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 22:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934571AbZLHDPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 22:15:11 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58376 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935077AbZLHDPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 22:15:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bryan Donlan <bdonlan@gmail.com>, Ulrich Drepper <drepper@redhat.com>,
       Timo Sirainen <tss@iki.fi>, WANG Cong <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v6] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20091208121145.B58D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Dec 2009 12:15:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog
  v5 -> v6
    - Remove arg_lock. Instead, use map_sem. [as Oleg pointed out]
    - Use access_process_vm_locked
    - Add some comment. [as Andrew pointed out]
  v4 -> v5
    - nit: kill duplicate calculation in prctl()
  v3 -> v4
    - Use mutex instead seq_lock.

========================================


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
 #include <string.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <stdio.h>
 #include <sys/prctl.h>

 #define ERR(str) (perror(str), exit(1))

 void settitle(char* title){
         int err;

         err = prctl(35, title, strlen(title)+1);
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
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/base.c        |   38 ++++++++++++++++++++++++++++----------
 include/linux/mm.h    |    2 ++
 include/linux/prctl.h |    3 +++
 kernel/sys.c          |   29 +++++++++++++++++++++++++++++
 mm/memory.c           |   40 +++++++++++++++++++++++++++-------------
 5 files changed, 89 insertions(+), 23 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8fbcc84..d4d8ac2 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -255,34 +255,52 @@ static int proc_pid_cmdline(struct task_struct *task, char * buffer)
 	int res = 0;
 	unsigned int len;
 	struct mm_struct *mm = get_task_mm(task);
+
 	if (!mm)
 		goto out;
+
+	/* The process was not constructed yet? */
 	if (!mm->arg_end)
 		goto out_mm;	/* Shh! No looking before we're done */
 
- 	len = mm->arg_end - mm->arg_start;
- 
+	down_read(&mm->mmap_sem);
+	len = mm->arg_end - mm->arg_start;
 	if (len > PAGE_SIZE)
 		len = PAGE_SIZE;
- 
-	res = access_process_vm(task, mm->arg_start, buffer, len, 0);
 
-	// If the nul at the end of args has been overwritten, then
-	// assume application is using setproctitle(3).
+	res = access_process_vm_locked(task, mm, mm->arg_start, buffer, len, 0);
+
+	/*
+	 * If argv and environ aren't continuous (i.e. the process used
+	 * prctl(PR_SET_PROCTITLE_AREA)), we don't care environ override.
+	 */
+	if (mm->arg_end != mm->env_start)
+		goto out_unlock;
+
+	/*
+	 * If the nul at the end of args has been overwritten, then assume
+	 * application is using sendmail's SPT_REUSEARGV style argv override.
+	 */
 	if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
 		len = strnlen(buffer, res);
-		if (len < res) {
-		    res = len;
-		} else {
+		if (len < res)
+			res = len;
+		else {
 			len = mm->env_end - mm->env_start;
 			if (len > PAGE_SIZE - res)
 				len = PAGE_SIZE - res;
-			res += access_process_vm(task, mm->env_start, buffer+res, len, 0);
+			res += access_process_vm_locked(task, mm, mm->env_start,
+							buffer+res, len, 0);
 			res = strnlen(buffer, res);
 		}
 	}
+
+out_unlock:
+	up_read(&mm->mmap_sem);
+
 out_mm:
 	mmput(mm);
+
 out:
 	return res;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 09eed6a..23170c5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -829,6 +829,8 @@ static inline int handle_mm_fault(struct mm_struct *mm,
 
 extern int make_pages_present(unsigned long addr, unsigned long end);
 extern int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write);
+extern int access_process_vm_locked(struct task_struct *tsk, struct mm_struct *mm,
+				    unsigned long addr, void *buf, int len, int write);
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			unsigned long start, int nr_pages, int write, int force,
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..385dafb 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,7 @@
 
 #define PR_MCE_KILL_GET 34
 
+/* Set process title memory area for setproctitle() */
+#define PR_SET_PROCTITLE_AREA 35
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 6309293..aeea3b1 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1607,6 +1607,35 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			else
 				error = PR_MCE_KILL_DEFAULT;
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
+			/*
+			 * If the process pass broken pointer, EFAULT is might better
+			 * than ps output zero-length proctitle. Plus if
+			 * the process pass kernel address (or something-else),
+			 * We have to block it. Oherwise, strange exploit
+			 * chance is there.
+			 */
+			if (!access_ok(VERIFY_READ, addr, len))
+				return -EFAULT;
+
+			down_write(&mm->mmap_sem);
+			mm->arg_start = addr;
+			mm->arg_end = end;
+			up_write(&mm->mmap_sem);
+
+			return 0;
+		}
 		default:
 			error = -EINVAL;
 			break;
diff --git a/mm/memory.c b/mm/memory.c
index aed45ea..6f8b8bc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3269,22 +3269,13 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 }
 #endif
 
-/*
- * Access another process' address space.
- * Source/target buffer must be kernel space,
- * Do not walk the page table directly, use get_user_pages
- */
-int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
+/* Similar to access_process_vm(), but mmap_sem held is required. */
+int access_process_vm_locked(struct task_struct *tsk, struct mm_struct *mm,
+			     unsigned long addr, void *buf, int len, int write)
 {
-	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	void *old_buf = buf;
 
-	mm = get_task_mm(tsk);
-	if (!mm)
-		return 0;
-
-	down_read(&mm->mmap_sem);
 	/* ignore errors, just check how much was successfully transferred */
 	while (len) {
 		int bytes, ret, offset;
@@ -3331,10 +3322,33 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 		buf += bytes;
 		addr += bytes;
 	}
+
+	return buf - old_buf;
+}
+
+/*
+ * Access another process' address space.
+ * Source/target buffer must be kernel space,
+ * Do not walk the page table directly, use get_user_pages
+ * ignore errors, just check how much was successfully transferred. IOW, this
+ * function always return >=0 value.
+ */
+int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
+{
+	int ret;
+	struct mm_struct *mm;
+
+	/* Probably tsk isn't current. We can't access tsk->mm directly. */
+	mm = get_task_mm(tsk);
+	if (!mm)
+		return 0;
+
+	down_read(&mm->mmap_sem);
+	ret = access_process_vm_locked(tsk, mm, addr, buf, len, write);
 	up_read(&mm->mmap_sem);
 	mmput(mm);
 
-	return buf - old_buf;
+	return ret;
 }
 
 /*
-- 
1.6.5.2



