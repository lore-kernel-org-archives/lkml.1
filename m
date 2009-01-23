Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbZAWSKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbZAWSKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZAWSKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:10:06 -0500
Received: from 12-130-157-75.attens.net ([12.130.157.75]:60035 "EHLO
	eng-pool-55.spikesource.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753023AbZAWSKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:10:03 -0500
Date: Fri, 23 Jan 2009 09:49:41 -0800
From: narendramind@spikesource.com
Message-Id: <200901231749.n0NHnfBb009072@eng-pool-55.spikesource.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/1] x86: syscalls: sys_setrlimit64/sys_getrlimit64 calls to provide FSIZE  limits > 2^32-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: syscalls: sys_setrlimit64/sys_getrlimit64 calls to provide FSIZE  limits > 2^32-1
Problem Description:
  The following issue affects the setrlimit() and getrlimit() system calls on
  Linux 2.6.13 (and earlier) on x86. The Problem is filed at kernel.org bug 5042
  (http://bugzilla.kernel.org/show_bug.cgi?id=5042)

  With setrlimit()/getrlimit(), resource limits can not be set > 2^32-1 on
  x86 as internally, resource limits are represented in the 'rlimit' structure 
  (defined in include/linux/resource.h) as unsigned longs, meaning 32 bits on
  x86.  The most pertinent limit here is RLIMIT_FSIZE, which specifies the
  maximum size to which a file can grow: to be useful, this limit must be
  represented using a type that is as wide as the type used to represent 
  file offsets, i.e., as wide as a 64-bit off_t.

  Current versions of glibc (e.g., 2.3.5) deal with this situation somewhat 
  strangely: if a program compiled with FILE_OFFSET_BITS set to 64 
  (i.e., off_t is thus 'long long' -- 64 bits) tries to set a resource
  limit to a value larger than can be represented in a 32-bit unsigned long,then
  the glibc wrapper for setrlimit() silently converts the limit value to 
  RLIM_INFINITY. In other words, the requested resource limit setting is
  silently ignored. One could argue that perhaps the glibc wrapper should
  give an error, rather than silently turning a very large limit into infinity;
  however, the glibc developers instead seem to have decided on the current
  behaviour as a means of dealing with what is fundamentally a kernel problem.)

  (NOTE: This problem is not merely a theoretical one facing programmers 
  developing new applications. Since many x86 distributions compile all file
  utilities with -D_FILE_OFFSET_BITS=64, this issue can bite end-users as well,
  if they expect to be able to set resource limits greater than 2^32-1.)

  The solution to this problem would require new setrlimit64() and 
  getrlimit64() system calls on x86, and the existing 32-bit system calls 
  would need to be retained so that existing binaries would still run.

Design Approach:
    Add two system calls sys_setrlimit64()/sys_getrlimit64().
    And a type 'struct rlimit64' to accomodate more no. of limits <= 2^64-1

Implementation Details:
    Inclusions: struct rlimit64, struct rlimit64 rlim64[RLIM64_NRLIMITS] to 
        task_struct

Test Results:
  Test results are posted as Comment#6 to 
      http://bugzilla.kernel.org/show_bug.cgi?id=5042
  System Info (uname -a): 
    Linux infinity 2.6.29-rc2rlim64 #2 SMP 
        Sat Jan 17 16:57:07 IST 2009 i686 GNU/Linux
    CPU: Intel Centrino Duo
getrlimit64: Limits in the Kernel ....
retval            : 0
rlim              | max64 = ffffffffffffffff
rlim              | cur64 = ffffffffffffffff

setrlimit64: setting the following limits ...
retval            : 0
rlim              | max64 = 1122334455667788
rlim              | cur64 = 1122334455667788

getrlimit64: Limits in the Kernel set ....
retval            : 0
rlim              | max64 = 1122334455667788
rlim              | cur64 = 1122334455667788

    Signed-off-by: Narendra Prasad Madanapalli <narendramind@gmail.com>
diff -uNrp -X linux-2.6.29-rc2/Documentation/dontdiff linux-2.6.29-rc2/arch/x86/kernel/syscall_table_32.S linux-2.6.29-rc2-rlim64/arch/x86/kernel/syscall_table_32.S
--- linux-2.6.29-rc2/arch/x86/kernel/syscall_table_32.S	2009-01-17 09:54:06.000000000 +0530
+++ linux-2.6.29-rc2-rlim64/arch/x86/kernel/syscall_table_32.S	2009-01-17 19:15:52.000000000 +0530
@@ -332,3 +332,5 @@ ENTRY(sys_call_table)
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_setrlimit64
+	.long sys_getrlimit64
diff -uNrp -X linux-2.6.29-rc2/Documentation/dontdiff linux-2.6.29-rc2/include/asm-generic/resource.h linux-2.6.29-rc2-rlim64/include/asm-generic/resource.h
--- linux-2.6.29-rc2/include/asm-generic/resource.h	2009-01-17 09:54:59.000000000 +0530
+++ linux-2.6.29-rc2-rlim64/include/asm-generic/resource.h	2009-01-17 19:16:48.000000000 +0530
@@ -46,6 +46,7 @@
 #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
 #define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
 #define RLIM_NLIMITS		16
+#define RLIM64_NLIMITS		2
 
 /*
  * SuS says limits have to be unsigned.
@@ -56,6 +57,9 @@
 #ifndef RLIM_INFINITY
 # define RLIM_INFINITY		(~0UL)
 #endif
+#ifndef RLIM64_INFINITY
+# define RLIM64_INFINITY        (~0ULL)
+#endif
 
 /*
  * RLIMIT_STACK default maximum - some architectures override it:
@@ -89,6 +93,12 @@
 	[RLIMIT_RTTIME]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
 }
 
+#define INIT_RLIMITS64                                                    \
+{                                                                         \
+	[0]                     = {  RLIM64_INFINITY,  RLIM64_INFINITY }, \
+	[RLIMIT_FSIZE]          = {  RLIM64_INFINITY,  RLIM64_INFINITY }, \
+}
+
 #endif	/* __KERNEL__ */
 
 #endif
diff -uNrp -X linux-2.6.29-rc2/Documentation/dontdiff linux-2.6.29-rc2/include/linux/init_task.h linux-2.6.29-rc2-rlim64/include/linux/init_task.h
--- linux-2.6.29-rc2/include/linux/init_task.h	2009-01-17 09:55:08.000000000 +0530
+++ linux-2.6.29-rc2-rlim64/include/linux/init_task.h	2009-01-17 19:16:55.000000000 +0530
@@ -48,6 +48,7 @@ extern struct fs_struct init_fs;
 	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
+	.rlim64         = INIT_RLIMITS64,                               \
 }
 
 extern struct nsproxy init_nsproxy;
diff -uNrp -X linux-2.6.29-rc2/Documentation/dontdiff linux-2.6.29-rc2/include/linux/resource.h linux-2.6.29-rc2-rlim64/include/linux/resource.h
--- linux-2.6.29-rc2/include/linux/resource.h	2009-01-17 09:55:04.000000000 +0530
+++ linux-2.6.29-rc2-rlim64/include/linux/resource.h	2009-01-17 19:16:52.000000000 +0530
@@ -45,6 +45,11 @@ struct rlimit {
 	unsigned long	rlim_max;
 };
 
+struct rlimit64 {
+	u64   rlim64_cur;
+	u64   rlim64_max;
+};
+
 #define	PRIO_MIN	(-20)
 #define	PRIO_MAX	20
 
diff -uNrp -X linux-2.6.29-rc2/Documentation/dontdiff linux-2.6.29-rc2/include/linux/sched.h linux-2.6.29-rc2-rlim64/include/linux/sched.h
--- linux-2.6.29-rc2/include/linux/sched.h	2009-01-17 09:55:10.000000000 +0530
+++ linux-2.6.29-rc2-rlim64/include/linux/sched.h	2009-01-17 19:16:57.000000000 +0530
@@ -572,6 +572,7 @@ struct signal_struct {
 	 * have no need to disable irqs.
 	 */
 	struct rlimit rlim[RLIM_NLIMITS];
+	struct rlimit64 rlim64[RLIM64_NLIMITS];
 
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct pacct_struct pacct;	/* per-process accounting information */
diff -uNrp -X linux-2.6.29-rc2/Documentation/dontdiff linux-2.6.29-rc2/kernel/ChangeLog linux-2.6.29-rc2-rlim64/kernel/ChangeLog
--- linux-2.6.29-rc2/kernel/ChangeLog	1970-01-01 05:30:00.000000000 +0530
+++ linux-2.6.29-rc2-rlim64/kernel/ChangeLog	2009-01-17 19:15:50.000000000 +0530
@@ -0,0 +1,10 @@
+2008-01-17  Narendra Prasad <narendramind@gmail.com>
+    Problem Description:
+        The following issue affects the setrlimit() and getrlimit() system calls on Linux 2.6.13 (and earlier) on x86.
+        The Problem is filed at kernel.org bug 5042 (http://bugzilla.kernel.org/show_bug.cgi?id=5042)
+    Design Approach:
+        Add two system calls sys_setrlimit64()/sys_getrlimit64().
+        And a type 'struct rlimit64' to accomodate more no. of limits <= 2^64-1
+    Implementation Details:
+        Inclusions: struct rlimit64, struct rlimit64
+        rlim64[RLIM64_NRLIMITS] to task_struct
diff -uNrp -X linux-2.6.29-rc2/Documentation/dontdiff linux-2.6.29-rc2/kernel/fork.c linux-2.6.29-rc2-rlim64/kernel/fork.c
--- linux-2.6.29-rc2/kernel/fork.c	2009-01-17 09:54:04.000000000 +0530
+++ linux-2.6.29-rc2-rlim64/kernel/fork.c	2009-01-17 19:15:49.000000000 +0530
@@ -862,6 +862,7 @@ static int copy_signal(unsigned long clo
 
 	task_lock(current->group_leader);
 	memcpy(sig->rlim, current->signal->rlim, sizeof sig->rlim);
+	memcpy(sig->rlim64, current->signal->rlim64, sizeof sig->rlim64);
 	task_unlock(current->group_leader);
 
 	posix_cpu_timers_init_group(sig);
diff -uNrp -X linux-2.6.29-rc2/Documentation/dontdiff linux-2.6.29-rc2/kernel/sys.c linux-2.6.29-rc2-rlim64/kernel/sys.c
--- linux-2.6.29-rc2/kernel/sys.c	2009-01-17 09:54:04.000000000 +0530
+++ linux-2.6.29-rc2-rlim64/kernel/sys.c	2009-01-17 19:42:08.000000000 +0530
@@ -1577,6 +1577,132 @@ out:
 	return 0;
 }
 
+SYSCALL_DEFINE2(getrlimit64, unsigned int, resource,
+				struct rlimit64 __user *, rlim)
+{
+	struct rlimit64  value;
+
+	if (resource >= RLIM_NLIMITS)
+		return -EINVAL;
+
+	if (resource == RLIMIT_FSIZE) {
+		task_lock(current->group_leader);
+		value = current->signal->rlim64[resource];
+		task_unlock(current->group_leader);
+		return copy_to_user(rlim, &value, sizeof(*rlim)) ? -EFAULT : 0;
+	} else {
+		task_lock(current->group_leader);
+		value.rlim64_max = current->signal->rlim[resource].rlim_max;
+		value.rlim64_cur = current->signal->rlim[resource].rlim_cur;
+		task_unlock(current->group_leader);
+		if (value.rlim64_cur == RLIM_INFINITY)
+			value.rlim64_cur = RLIM64_INFINITY;
+		if (value.rlim64_max == RLIM_INFINITY)
+			value.rlim64_max = RLIM64_INFINITY;
+	/* XX: RLIM_SAVED_MAX ? RLIM_SAVED_CUR ? (See Large-File-Summit) */
+	}
+	return copy_to_user(rlim, &value, sizeof(*rlim)) ? -EFAULT : 0;
+}
+
+SYSCALL_DEFINE2(setrlimit64, unsigned int, resource,
+				struct rlimit64 __user *, rlim)
+{
+	struct rlimit64  new_rlim;
+	struct rlimit    *old_rlim, new_value;
+	unsigned long    it_prof_secs;
+	int              retval;
+
+	if (resource >= RLIM_NLIMITS)
+		return -EINVAL;
+	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
+		return -EFAULT;
+
+	if (resource == RLIMIT_FSIZE) {
+		struct rlimit64  *old_rlim;
+		struct rlimit    *old_value;
+
+		old_rlim = current->signal->rlim64 + resource;
+		if (((new_rlim.rlim64_cur > old_rlim->rlim64_max) ||
+			(new_rlim.rlim64_max > old_rlim->rlim64_max)) &&
+			!capable(CAP_SYS_RESOURCE))
+			return -EPERM;
+		*old_rlim = new_rlim;
+		if (new_rlim.rlim64_cur > RLIM_INFINITY)
+			new_rlim.rlim64_cur = RLIM_INFINITY;
+		if (new_rlim.rlim64_max > RLIM_INFINITY)
+			new_rlim.rlim64_max = RLIM_INFINITY;
+
+		task_lock(current->group_leader);
+		old_value = (current->signal->rlim + resource);
+		old_value->rlim_max = new_rlim.rlim64_max;
+		old_value->rlim_cur = new_rlim.rlim64_cur;
+		task_unlock(current->group_leader);
+
+		return 0;
+	}
+
+	old_rlim = current->signal->rlim + resource;
+	if (new_rlim.rlim64_cur > RLIM_INFINITY)
+		new_rlim.rlim64_cur = RLIM_INFINITY;
+	if (new_rlim.rlim64_max > RLIM_INFINITY)
+		new_rlim.rlim64_max = RLIM_INFINITY;
+	if (((new_rlim.rlim64_cur > old_rlim->rlim_max) ||
+		(new_rlim.rlim64_max > old_rlim->rlim_max)) &&
+		!capable(CAP_SYS_RESOURCE))
+		return -EPERM;
+	if (resource == RLIMIT_NOFILE) {
+		if (new_rlim.rlim64_cur > INR_OPEN ||
+			new_rlim.rlim64_max > INR_OPEN)
+			return -EPERM;
+	}
+	new_value.rlim_max = new_rlim.rlim64_max;
+	new_value.rlim_cur = new_rlim.rlim64_cur;
+	retval = security_task_setrlimit(resource, &new_value);
+	if (retval)
+		return retval;
+
+	if (resource == RLIMIT_CPU && new_value.rlim_cur == 0) {
+		/*
+		 * The caller is asking for an immediate RLIMIT_CPU
+		 * expiry.  But we use the zero value to mean "it was
+		 * never set".  So let's cheat and make it one second
+		 * instead
+		 */
+		new_value.rlim_cur = 1;
+	}
+
+	task_lock(current->group_leader);
+	*old_rlim = new_value;
+	task_unlock(current->group_leader);
+
+	if (resource != RLIMIT_CPU)
+		goto out;
+
+	/*
+	 * RLIMIT_CPU handling.   Note that the kernel fails to return an error
+	 * code if it rejected the user's attempt to set RLIMIT_CPU.  This is a
+	 * very long-standing error, and fixing it now risks breakage of
+	 * applications, so we live with it
+	 */
+	if (new_value.rlim_cur == RLIM_INFINITY)
+		goto out;
+
+	it_prof_secs = cputime_to_secs(current->signal->it_prof_expires);
+	if (it_prof_secs == 0 || new_value.rlim_cur <= it_prof_secs) {
+		unsigned long  rlim_cur = new_value.rlim_cur;
+		cputime_t      cputime;
+
+		cputime = secs_to_cputime(rlim_cur);
+		read_lock(&tasklist_lock);
+		spin_lock_irq(&current->sighand->siglock);
+		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
+		spin_unlock_irq(&current->sighand->siglock);
+		read_unlock(&tasklist_lock);
+	}
+out:
+	return 0;
+}
+
 /*
  * It would make sense to put struct rusage in the task_struct,
  * except that would make the task_struct be *really big*.  After
