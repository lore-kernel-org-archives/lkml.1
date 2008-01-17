Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYAQI3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYAQI3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 03:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYAQI32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 03:29:28 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59399 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbYAQI31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 03:29:27 -0500
Subject: [RFC] Per-thread getrusage
From: Vinay Sridhar <vinay@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Cc: drepper@redhat.com, wli@holomorphy.com, akpm@linux-foundation.org,
       sripathik@in.ibm.com
Content-Type: text/plain
Date: Thu, 17 Jan 2008 13:57:05 +0530
Message-Id: <1200558425.5992.17.camel@srivinay.in.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Last year, there was discussion about per-thread getrusage by adding
RUSAGE_THREAD flag to getrusage(). Please refer to the thread
http://lkml.org/lkml/2007/4/4/308. Ulrich had suggested that we should
design a better user-space API. Specifically, we need a
pthread_getrusage interface in the thread library, which accepts
pthread_t, converts pthread_t into the corresponding tid and passes it
down to the syscall.

There are two ways to implement this in the kernel:
1) Introduce an additional parameter 'tid' to sys_getrusage() and put
code in glibc to handle getrusage() and pthread_getrusage() calls
correctly.
2) Introduce a new system call to handle pthread_getrusage() and leave
sys_getrusage() untouched.

We implemented the second idea above, simply because it avoids touching
any existing code. We have implemented a new syscall, thread_getrusage()
and we have exposed pthread_getrusage() API to applications.

Could you please share your thoughts on this? Does the approach look
alright? The code is hardly complete. It is just a prototype that works
on IA32 at the moment.

kernel patch : 

signed-off by : Vinay Sridhar <vinay@linux.vnet.ibm.com>
signed-off by : Sripathi Kodi <sripathik@in.ibm.com>

diff -Nuarp linux-2.6.24-rc6_org/arch/x86/ia32/ia32entry.S linux-2.6.24-rc6/arch/x86/ia32/ia32entry.S
--- linux-2.6.24-rc6_org/arch/x86/ia32/ia32entry.S	2008-01-10 17:16:05.000000000 +0530
+++ linux-2.6.24-rc6/arch/x86/ia32/ia32entry.S	2008-01-14 15:54:54.000000000 +0530
@@ -726,4 +726,5 @@ ia32_sys_call_table:
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
 	.quad sys32_fallocate
+	.quad sys_thread_getrusage	/* 325 */
 ia32_syscall_end:
diff -Nuarp linux-2.6.24-rc6_org/arch/x86/kernel/syscall_table_32.S linux-2.6.24-rc6/arch/x86/kernel/syscall_table_32.S
--- linux-2.6.24-rc6_org/arch/x86/kernel/syscall_table_32.S	2008-01-10 17:16:05.000000000 +0530
+++ linux-2.6.24-rc6/arch/x86/kernel/syscall_table_32.S	2008-01-14 15:54:17.000000000 +0530
@@ -324,3 +324,5 @@ ENTRY(sys_call_table)
 	.long sys_timerfd
 	.long sys_eventfd
 	.long sys_fallocate
+	.long sys_thread_getrusage	/* 325 */
+
diff -Nuarp linux-2.6.24-rc6_org/include/asm-x86/unistd_32.h linux-2.6.24-rc6/include/asm-x86/unistd_32.h
--- linux-2.6.24-rc6_org/include/asm-x86/unistd_32.h	2008-01-10 17:16:13.000000000 +0530
+++ linux-2.6.24-rc6/include/asm-x86/unistd_32.h	2008-01-14 15:58:35.000000000 +0530
@@ -330,10 +330,11 @@
 #define __NR_timerfd		322
 #define __NR_eventfd		323
 #define __NR_fallocate		324
+#define __NR_thread_getrusage	325
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 325
+#define NR_syscalls 326
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -Nuarp linux-2.6.24-rc6_org/include/linux/syscalls.h linux-2.6.24-rc6/include/linux/syscalls.h
--- linux-2.6.24-rc6_org/include/linux/syscalls.h	2008-01-10 17:16:15.000000000 +0530
+++ linux-2.6.24-rc6/include/linux/syscalls.h	2008-01-14 15:59:12.000000000 +0530
@@ -611,7 +611,7 @@ asmlinkage long sys_timerfd(int ufd, int
 			    const struct itimerspec __user *utmr);
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
-
+asmlinkage long sys_thread_getrusage(int tid, struct rusage __user *ru);
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
 #endif
diff -Nuarp linux-2.6.24-rc6_org/kernel/sys.c linux-2.6.24-rc6/kernel/sys.c
--- linux-2.6.24-rc6_org/kernel/sys.c	2008-01-10 17:16:10.000000000 +0530
+++ linux-2.6.24-rc6/kernel/sys.c	2008-01-17 11:00:18.000000000 +0530
@@ -33,6 +33,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/seccomp.h>
 #include <linux/cpu.h>
+#include <linux/sched.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -1570,6 +1571,16 @@ static void k_getrusage(struct task_stru
 	}
 
 	switch (who) {
+		case RUSAGE_THREAD:
+			utime = p->utime;
+			stime = p->stime;
+			r->ru_nvcsw = p->nvcsw;
+			r->ru_nivcsw = p->nivcsw;
+			r->ru_minflt = p->min_flt;
+			r->ru_majflt = p->maj_flt;
+			r->ru_inblock = task_io_get_inblock(p);
+			r->ru_oublock = task_io_get_oublock(p);
+			break;
 		case RUSAGE_BOTH:
 		case RUSAGE_CHILDREN:
 			utime = p->signal->cutime;
@@ -1627,11 +1638,19 @@ int getrusage(struct task_struct *p, int
 
 asmlinkage long sys_getrusage(int who, struct rusage __user *ru)
 {
-	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN)
+	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
+					who != RUSAGE_THREAD)
 		return -EINVAL;
 	return getrusage(current, who, ru);
 }
 
+asmlinkage long sys_thread_getrusage(int tid, struct rusage __user *ru)
+{
+	struct task_struct *tsk;
+	tsk = find_task_by_pid(tid);
+	return getrusage(tsk, RUSAGE_THREAD, ru);
+}
+	
 asmlinkage long sys_umask(int mask)
 {
 	mask = xchg(&current->fs->umask, mask & S_IRWXUGO);


glibc patch : 

signed-off by : Vinay Sridhar <vinay@linux.vnet.ibm.com>
signed-off by : Sripathi Kodi <sripathik@in.ibm.com>

diff -Nuarp glibc_cvs_20sep.orig/abilist/libpthread.abilist glibc_cvs_20sep/abilist/libpthread.abilist
--- glibc_cvs_20sep.orig/abilist/libpthread.abilist	2008-01-16 11:31:32.000000000 +0530
+++ glibc_cvs_20sep/abilist/libpthread.abilist	2008-01-16 11:26:37.000000000 +0530
@@ -102,6 +102,7 @@ GLIBC_2.0 i.86-.*-linux.*/notls i.86-.*-
  pthread_key_create F
  pthread_key_delete F
  pthread_kill F
+ pthread_getrusage F
  pthread_kill_other_threads_np F
  pthread_mutex_destroy F
  pthread_mutex_init F
diff -Nuarp glibc_cvs_20sep.orig/nptl/Makefile glibc_cvs_20sep/nptl/Makefile
--- glibc_cvs_20sep.orig/nptl/Makefile	2008-01-16 11:31:32.000000000 +0530
+++ glibc_cvs_20sep/nptl/Makefile	2008-01-16 11:28:10.000000000 +0530
@@ -85,7 +85,7 @@ libpthread-routines = init vars events v
 		      pthread_barrierattr_setpshared \
 		      pthread_key_create pthread_key_delete \
 		      pthread_getspecific pthread_setspecific \
-		      pthread_sigmask pthread_kill \
+		      pthread_sigmask pthread_kill pthread_getrusage \
 		      pthread_cancel pthread_testcancel \
 		      pthread_setcancelstate pthread_setcanceltype \
 		      pthread_once \
diff -Nuarp glibc_cvs_20sep.orig/nptl/sysdeps/unix/sysv/linux/pthread_getrusage.c glibc_cvs_20sep/nptl/sysdeps/unix/sysv/linux/pthread_getrusage.c
--- glibc_cvs_20sep.orig/nptl/sysdeps/unix/sysv/linux/pthread_getrusage.c	1970-01-01 05:30:00.000000000 +0530
+++ glibc_cvs_20sep/nptl/sysdeps/unix/sysv/linux/pthread_getrusage.c	2008-01-16 11:34:56.000000000 +0530
@@ -0,0 +1,29 @@
+#include <sys/resource.h>
+#include <errno.h>
+#include <pthreadP.h>
+#include <tls.h>
+#include <sysdep.h>
+#include <kernel-features.h>
+#define __NR_pthread_getrusage 325
+
+
+int
+__pthread_getrusage (threadid, usage)
+     pthread_t threadid;
+     struct rusage *usage;
+{
+  int val;
+  pid_t tid;
+  struct pthread *pd = (const struct pthread *) threadid;
+  tid = atomic_forced_read (pd->tid);
+  if (__builtin_expect (tid <= 0, 0))
+    /* Not a valid thread handle.  */
+    return ESRCH;
+  INTERNAL_SYSCALL_DECL (err);
+  val = INTERNAL_SYSCALL (pthread_getrusage, err, 2, tid, usage);
+  return (INTERNAL_SYSCALL_ERROR_P (val, err)
+          ? INTERNAL_SYSCALL_ERRNO (val, err) : 0);
+}
+
+strong_alias (__pthread_getrusage, pthread_getrusage)
+
diff -Nuarp glibc_cvs_20sep.orig/nptl/Versions glibc_cvs_20sep/nptl/Versions
--- glibc_cvs_20sep.orig/nptl/Versions	2008-01-16 11:31:32.000000000 +0530
+++ glibc_cvs_20sep/nptl/Versions	2008-01-16 11:27:37.000000000 +0530
@@ -60,7 +60,7 @@ libpthread {
     pthread_cancel; pthread_testcancel;
     pthread_setcancelstate; pthread_setcanceltype;
 
-    pthread_sigmask; pthread_kill;
+    pthread_sigmask; pthread_kill; pthread_getrusage;
 
     pthread_key_create; pthread_key_delete;
     pthread_getspecific; pthread_setspecific;


