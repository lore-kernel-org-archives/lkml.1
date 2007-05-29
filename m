Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbXE2N75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbXE2N75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbXE2N7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:59:43 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:56272 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbXE2N7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:59:42 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 09:59:42 EDT
Date: Tue, 29 May 2007 06:48:16 -0700
From: Stephane Eranian <eranian@frankl.hpl.hp.com>
Message-Id: <200705291348.l4TDmG1Y019632@frankl.hpl.hp.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 02/22] 2.6.22-rc3 perfmon2 : generic kernel modifications
Cc: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@frankl.hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains all the modified generic files:

linux/include/linux/sched.h:
	- add pfm_context pointer to struct task_struct. This is used
	  to connect a perfmon2 context to a task when doing per-thread
	  monitoring.

linux/include/linux/syscalls.h:
	- declare prototypes of our new system calls

linux/kernel/sched.c:
	- add include perfmon.h to ensure pfm_ctxsw() has a defined prototype

linux/kernel/sys_ni.c:
	- add perfmon2 cond_syscall() definitions (when CONFIG_PERFMON is off)

drivers/oprofile/oprofile_files.c:
linux-2.6.22.base/drivers/oprofile/timer_int.c:
include/linux/oprofile.h:
	- add new implementation entry for oprofilefs. used to check if oprofile is
	  using perfmon vs. runs natively



Only in linux-2.6.22/Documentation: perfmon2.txt
diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/Makefile linux-2.6.22/Makefile
--- linux-2.6.22.base/Makefile	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/Makefile	2007-05-29 03:24:14.000000000 -0700
@@ -553,7 +553,7 @@ export mod_strip_cmd
 
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ perfmon/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/drivers/oprofile/oprofile_files.c linux-2.6.22/drivers/oprofile/oprofile_files.c
--- linux-2.6.22.base/drivers/oprofile/oprofile_files.c	2007-05-29 03:17:41.000000000 -0700
+++ linux-2.6.22/drivers/oprofile/oprofile_files.c	2007-05-29 03:24:14.000000000 -0700
@@ -117,7 +117,17 @@ static ssize_t dump_write(struct file * 
 static const struct file_operations dump_fops = {
 	.write		= dump_write,
 };
- 
+
+static ssize_t implementation(struct file * file, char __user * buf, size_t count, loff_t * offset)
+{
+	return oprofilefs_str_to_user(oprofile_ops.implementation, buf, count, offset);
+}
+
+
+static struct file_operations implementation_fops = {
+	.read		= implementation,
+};
+
 void oprofile_create_files(struct super_block * sb, struct dentry * root)
 {
 	oprofilefs_create_file(sb, root, "enable", &enable_fops);
@@ -127,6 +137,7 @@ void oprofile_create_files(struct super_
 	oprofilefs_create_ulong(sb, root, "buffer_watershed", &fs_buffer_watershed);
 	oprofilefs_create_ulong(sb, root, "cpu_buffer_size", &fs_cpu_buffer_size);
 	oprofilefs_create_file(sb, root, "cpu_type", &cpu_type_fops); 
+	oprofilefs_create_file(sb, root, "implementation", &implementation_fops);
 	oprofilefs_create_file(sb, root, "backtrace_depth", &depth_fops);
 	oprofilefs_create_file(sb, root, "pointer_size", &pointer_size_fops);
 	oprofile_create_stats_files(sb, root);
diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/drivers/oprofile/timer_int.c linux-2.6.22/drivers/oprofile/timer_int.c
--- linux-2.6.22.base/drivers/oprofile/timer_int.c	2007-05-29 03:17:41.000000000 -0700
+++ linux-2.6.22/drivers/oprofile/timer_int.c	2007-05-29 03:24:14.000000000 -0700
@@ -43,4 +43,5 @@ void __init oprofile_timer_init(struct o
 	ops->start = timer_start;
 	ops->stop = timer_stop;
 	ops->cpu_type = "timer";
+	ops->implementation = "timer";
 }
diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/include/linux/oprofile.h linux-2.6.22/include/linux/oprofile.h
--- linux-2.6.22.base/include/linux/oprofile.h	2007-05-29 03:17:57.000000000 -0700
+++ linux-2.6.22/include/linux/oprofile.h	2007-05-29 03:24:14.000000000 -0700
@@ -39,6 +39,8 @@ struct oprofile_operations {
 	void (*backtrace)(struct pt_regs * const regs, unsigned int depth);
 	/* CPU identification string. */
 	char * cpu_type;
+	/* Identify method of  string. */
+	char * implementation;
 };
 
 /**
Only in linux-2.6.22/include/linux: perfmon.h
Only in linux-2.6.22/include/linux: perfmon_dfl_smpl.h
Only in linux-2.6.22/include/linux: perfmon_fmt.h
Only in linux-2.6.22/include/linux: perfmon_pmu.h
diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/include/linux/sched.h linux-2.6.22/include/linux/sched.h
--- linux-2.6.22.base/include/linux/sched.h	2007-05-29 03:17:57.000000000 -0700
+++ linux-2.6.22/include/linux/sched.h	2007-05-29 03:24:14.000000000 -0700
@@ -89,6 +89,7 @@ struct sched_param {
 struct exec_domain;
 struct futex_pi_state;
 struct bio;
+struct pfm_context;
 
 /*
  * List of flags we want to share for kernel threads,
@@ -1076,6 +1077,9 @@ struct task_struct {
 #ifdef CONFIG_FAULT_INJECTION
 	int make_it_fail;
 #endif
+#ifdef CONFIG_PERFMON
+	struct pfm_context *pfm_context;
+#endif
 };
 
 static inline pid_t process_group(struct task_struct *tsk)
diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/include/linux/syscalls.h linux-2.6.22/include/linux/syscalls.h
--- linux-2.6.22.base/include/linux/syscalls.h	2007-05-29 03:17:57.000000000 -0700
+++ linux-2.6.22/include/linux/syscalls.h	2007-05-29 03:24:14.000000000 -0700
@@ -29,6 +29,13 @@ struct msqid_ds;
 struct new_utsname;
 struct nfsctl_arg;
 struct __old_kernel_stat;
+struct pfarg_ctx;
+struct pfarg_pmc;
+struct pfarg_pmd;
+struct pfarg_start;
+struct pfarg_load;
+struct pfarg_setinfo;
+struct pfarg_setdesc;
 struct pollfd;
 struct rlimit;
 struct rusage;
@@ -611,4 +618,27 @@ asmlinkage long sys_eventfd(unsigned int
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+asmlinkage long sys_pfm_create_context(struct pfarg_ctx __user *ureq,
+				       void __user *uarg, size_t smpl_size);
+asmlinkage long sys_pfm_write_pmcs(int fd, struct pfarg_pmc __user *ureq,
+				   int count);
+asmlinkage long sys_pfm_write_pmds(int fd, struct pfarg_pmd __user *ureq,
+				   int count);
+asmlinkage long sys_pfm_read_pmds(int fd, struct pfarg_pmd __user *ureq,
+				  int count);
+asmlinkage long sys_pfm_restart(int fd);
+asmlinkage long sys_pfm_stop(int fd);
+asmlinkage long sys_pfm_start(int fd, struct pfarg_start __user *ureq);
+asmlinkage long sys_pfm_load_context(int fd, struct pfarg_load __user *ureq);
+asmlinkage long sys_pfm_unload_context(int fd);
+asmlinkage long sys_pfm_delete_evtsets(int fd,
+				       struct pfarg_setinfo __user *ureq,
+				       int count);
+asmlinkage long sys_pfm_create_evtsets(int fd,
+				       struct pfarg_setdesc __user *ureq,
+				       int count);
+asmlinkage long sys_pfm_getinfo_evtsets(int fd,
+					struct pfarg_setinfo __user *ureq,
+					int count);
+
 #endif
diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/kernel/sched.c linux-2.6.22/kernel/sched.c
--- linux-2.6.22.base/kernel/sched.c	2007-05-29 03:17:57.000000000 -0700
+++ linux-2.6.22/kernel/sched.c	2007-05-29 03:24:14.000000000 -0700
@@ -53,6 +53,7 @@
 #include <linux/kprobes.h>
 #include <linux/delayacct.h>
 #include <linux/reciprocal_div.h>
+#include <linux/perfmon.h>
 
 #include <asm/tlb.h>
 #include <asm/unistd.h>
diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/kernel/sys_ni.c linux-2.6.22/kernel/sys_ni.c
--- linux-2.6.22.base/kernel/sys_ni.c	2007-05-29 03:17:57.000000000 -0700
+++ linux-2.6.22/kernel/sys_ni.c	2007-05-29 03:24:14.000000000 -0700
@@ -113,6 +113,19 @@ cond_syscall(sys_vm86);
 cond_syscall(compat_sys_ipc);
 cond_syscall(compat_sys_sysctl);
 
+cond_syscall(sys_pfm_create_context);
+cond_syscall(sys_pfm_write_pmcs);
+cond_syscall(sys_pfm_write_pmds);
+cond_syscall(sys_pfm_read_pmds);
+cond_syscall(sys_pfm_restart);
+cond_syscall(sys_pfm_start);
+cond_syscall(sys_pfm_stop);
+cond_syscall(sys_pfm_load_context);
+cond_syscall(sys_pfm_unload_context);
+cond_syscall(sys_pfm_create_evtsets);
+cond_syscall(sys_pfm_delete_evtsets);
+cond_syscall(sys_pfm_getinfo_evtsets);
+ 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
 cond_syscall(sys_pciconfig_write);
Only in linux-2.6.22: perfmon
