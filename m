Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbZF2Agq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbZF2Agq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbZF2AfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:35:25 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44644 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060AbZF2AfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:35:23 -0400
Date: Sun, 28 Jun 2009 20:35:14 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v3)
Message-ID: <20090629003514.GC2479@localhost.localdomain>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625163050.d6a71a13.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow for the kernel to wait for a core_pattern process to complete

One of the things core_pattern processes might do is interrogate the status of a
crashing process via its /proc/pid directory.  To ensure that that directory is
not removed prematurely, we wait for the process to exit prior to cleaning it
up.

Since the addition of this feature makes it possible to block the reaping of a
crashed process (if the collecting process never exits), Also introduce a new
sysctl: core_pipe_limit.  This sysctl, when non-zero, defined the maximum number
of crashing processes that can be collected in parallel.  Processes exceeding
this limit are noted in the kernel log buffer and their cores are skipped.  If
core_pipe_limit is zero (the default), this feature is disabled entirely.  In
other words, the number of cores which may be collected in parallel are
unlimited, but access to a crashing processes /proc/pid directory is not
guaranteed, as the kernel will not wait for the crashing process to exit.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Earl Chew <earl_chew@agilent.com>

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 322a00b..bb226ba 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -21,6 +21,7 @@ show up in /proc/sys/kernel:
 - acct
 - auto_msgmni
 - core_pattern
+- core_pipe_limit
 - core_uses_pid
 - ctrl-alt-del
 - dentry-state
@@ -119,6 +120,27 @@ core_pattern is used to specify a core dumpfile pattern name.
 
 ==============================================================
 
+core_pipe_limit:
+
+This sysctl is only applicable when core_pattern is configured to pipe core
+files to user space helper a (when the first character of core_pattern is a '|',
+see above).  When collecting cores via a pipe to an application, it is
+occasionally usefull for the collecting application to gather data about the
+crashing process from its /proc/pid directory.  In order to do this safely, the
+kernel must wait for the collecting process to exit, so as not to remove the
+crashing processes proc files prematurely.  This in turn creates the possibility
+that a misbehaving userspace collecting process can block the reaping of a
+crashed process simply by never exiting.  This sysctl defends against that.  It
+defines how many concurrent crashing processes may be piped to user space
+applications in parallel.  If this value is exceeded, then those crashing
+processes above that value are noted via the kernel log and their cores are
+skipped.  0 is a special value, indicating that unlimited processes may be
+captured in parallel, but that no waiting will take place (i.e. the collecting
+process is not guaranteed access to /proc/<crahing pid>/).  This value defaults
+to 0.
+
+==============================================================
+
 core_uses_pid:
 
 The default coredump filename is "core".  By setting
diff --git a/fs/exec.c b/fs/exec.c
index 9defd20..33d6db6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -55,6 +55,7 @@
 #include <linux/kmod.h>
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
+#include <linux/pipe_fs_i.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -63,6 +64,7 @@
 
 int core_uses_pid;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
+unsigned int core_pipe_limit;
 int suid_dumpable = 0;
 
 /* The maximal length of core_pattern is also specified in sysctl.c */
@@ -1716,7 +1718,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	char corename[CORENAME_MAX_SIZE + 1];
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
-	struct inode * inode;
+	struct inode * inode = NULL;
 	struct file * file;
 	const struct cred *old_cred;
 	struct cred *cred;
@@ -1726,7 +1728,8 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 	char **helper_argv = NULL;
 	int helper_argc = 0;
-	char *delimit;
+	int dump_count = 0;
+	static atomic_t core_dump_count = ATOMIC_INIT(0);
 
 	audit_core_dumps(signr);
 
@@ -1798,22 +1801,31 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 			goto fail_unlock;
 		}
 
+		dump_count = atomic_inc_return(&core_dump_count);
+		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
+			printk(KERN_WARNING "Pid %d(%s) over core_pipe_limit\n",
+			       task_tgid_vnr(current), current->comm);
+			printk(KERN_WARNING "Skipping core dump\n");
+			goto fail_dropcount;
+		}
+
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
-			goto fail_unlock;
+			goto fail_dropcount;
 		}
 
 		core_limit = RLIM_INFINITY;
 
 		/* SIGPIPE can happen, but it's just never processed */
- 		if (call_usermodehelper_pipe(corename+1, helper_argv, NULL,
+ 		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
 				&file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
- 			goto fail_unlock;
+ 			goto fail_dropcount;
  		}
+		inode = file->f_path.dentry->d_inode;
 	} else {
 		if (core_limit < binfmt->min_coredump)
 			goto fail_unlock;
@@ -1853,6 +1865,12 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 
 close_fail:
 	filp_close(file, NULL);
+fail_dropcount:
+	if (dump_count) {
+		while (core_pipe_limit && inode->i_pipe->readers)
+			pipe_wait(inode->i_pipe);
+		atomic_dec(&core_dump_count);
+	}
 fail_unlock:
 	if (helper_argv)
 		argv_free(helper_argv);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 62e4ff9..681052f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -77,6 +77,7 @@ extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
 extern char core_pattern[];
+extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
@@ -407,6 +408,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "core_pipe_limit",
+		.data		= &core_pipe_limit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #ifdef CONFIG_PROC_SYSCTL
 	{
 		.procname	= "tainted",
