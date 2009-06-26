Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZFZSEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZFZSEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZFZSEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:04:02 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51382 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZFZSEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:04:00 -0400
Date: Fri, 26 Jun 2009 14:03:55 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern: wait for core collectors
Message-ID: <20090626180355.GE7337@hmsreliant.think-freely.org>
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


 Documentation/sysctl/kernel.txt |   22 ++++++++++++++++++++++
 fs/exec.c                       |   28 +++++++++++++++++++++++-----
 include/linux/kmod.h            |    9 +++++----
 kernel/kmod.c                   |   18 ++++++++++++------
 kernel/sys.c                    |    2 +-
 kernel/sysctl.c                 |    9 +++++++++
 6 files changed, 72 insertions(+), 16 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index a4ccdd1..bcd6a7c 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -20,6 +20,7 @@ show up in /proc/sys/kernel:
 - acct
 - core_pattern
 - core_uses_pid
+- core_pipe_limit
 - ctrl-alt-del
 - dentry-state
 - domainname
@@ -123,6 +124,27 @@ the filename.
 
 ==============================================================
 
+core_pipe_limit:
+
+This sysctl is only applicable when core_pattern is configured to pipe core
+files to user space helper a (Shen the first character of core_pattern is a '|',
+see above).  When collecting cores via a pipe to an application, it is
+occasionally usefull for the collecting application to gather data about the
+crashing process from its /proc/pid directory.  In order to do this safely, the
+kernel must wait for the collecting process to exit, so as not to remove the
+crashing processes proc files prematurely.  This in turn creates the possibiltiy
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
 ctrl-alt-del:
 
 When the value in this file is 0, ctrl-alt-del is trapped and
diff --git a/fs/exec.c b/fs/exec.c
index 163cfa7..9a5f40c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -64,6 +64,8 @@
 
 int core_uses_pid;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
+unsigned int core_pipe_limit;
+
 int suid_dumpable = 0;
 
 /* The maximal length of core_pattern is also specified in sysctl.c */
@@ -1735,7 +1737,9 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 	char **helper_argv = NULL;
 	int helper_argc = 0;
-	char *delimit;
+	pid_t pid = 0;
+	int dump_count;
+	static atomic_t core_dump_count = ATOMIC_INIT(0);
 
 	audit_core_dumps(signr);
 
@@ -1824,21 +1828,29 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
 
+		dump_count = atomic_inc_return(&core_dump_count);
+		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
+			printk(KERN_WARNING "Pid %d(%s) over core_pipe_limit\n",
+				     task_tgid_vnr(current), current->comm);
+			printk(KERN_WARNING "Skipping core dump\n");
+			goto fail_dropcount;
+		}
+
 		core_limit = RLIM_INFINITY;
 
 		/* SIGPIPE can happen, but it's just never processed */
- 		if (call_usermodehelper_pipe(corename+1, helper_argv, NULL,
-				&file)) {
+ 		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
+				&file, &pid) < 0) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
- 			goto fail_unlock;
+ 			goto fail_dropcount;
  		}
  	} else
  		file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
 	if (IS_ERR(file))
-		goto fail_unlock;
+		goto fail_dropcount;
 	inode = file->f_path.dentry->d_inode;
 	if (inode->i_nlink > 1)
 		goto close_fail;	/* multiple links - don't dump */
@@ -1864,10 +1876,16 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 
 	retval = binfmt->core_dump(signr, regs, file, core_limit);
 
+	if (ispipe && core_pipe_limit)
+		sys_wait4(pid, NULL, 0, NULL);
+
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
 close_fail:
 	filp_close(file, NULL);
+fail_dropcount:
+	if (ispipe)
+		atomic_dec(&core_dump_count);
 fail_unlock:
 	if (helper_argv)
 		argv_free(helper_argv);
diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 92213a9..4085ada 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -60,7 +60,8 @@ enum umh_wait {
 };
 
 /* Actually execute the sub-process */
-int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
+int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait,
+			     pid_t *pid);
 
 /* Free the subprocess_info. This is only needed if you're not going
    to call call_usermodehelper_exec */
@@ -75,7 +76,7 @@ call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
 	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
-	return call_usermodehelper_exec(info, wait);
+	return call_usermodehelper_exec(info, wait, NULL);
 }
 
 static inline int
@@ -90,14 +91,14 @@ call_usermodehelper_keys(char *path, char **argv, char **envp,
 		return -ENOMEM;
 
 	call_usermodehelper_setkeys(info, session_keyring);
-	return call_usermodehelper_exec(info, wait);
+	return call_usermodehelper_exec(info, wait, NULL);
 }
 
 extern void usermodehelper_init(void);
 
 struct file;
 extern int call_usermodehelper_pipe(char *path, char *argv[], char *envp[],
-				    struct file **filp);
+				    struct file **filp, pid_t *pid);
 
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
diff --git a/kernel/kmod.c b/kernel/kmod.c
index c935b9b..8660ada 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -203,6 +203,7 @@ static int wait_for_helper(void *data)
 	allow_signal(SIGCHLD);
 
 	pid = kernel_thread(____call_usermodehelper, sub_info, SIGCHLD);
+
 	if (pid < 0) {
 		sub_info->retval = pid;
 	} else {
@@ -251,9 +252,11 @@ static void __call_usermodehelper(struct work_struct *work)
 	if (wait == UMH_WAIT_PROC || wait == UMH_NO_WAIT)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
-	else
+	else {
 		pid = kernel_thread(____call_usermodehelper, sub_info,
 				    CLONE_VFORK | SIGCHLD);
+		sub_info->retval = pid;
+	}
 
 	switch (wait) {
 	case UMH_NO_WAIT:
@@ -367,6 +370,7 @@ struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
 	sub_info->path = path;
 	sub_info->argv = argv;
 	sub_info->envp = envp;
+	sub_info->retval = 0;
 	sub_info->cred = prepare_usermodehelper_creds();
 	if (!sub_info->cred)
 		return NULL;
@@ -453,7 +457,7 @@ EXPORT_SYMBOL(call_usermodehelper_stdinpipe);
  * (ie. it runs with full root capabilities).
  */
 int call_usermodehelper_exec(struct subprocess_info *sub_info,
-			     enum umh_wait wait)
+			     enum umh_wait wait, pid_t *pid)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
@@ -477,7 +481,8 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info,
 		goto unlock;
 	wait_for_completion(&done);
 	retval = sub_info->retval;
-
+	if (retval > 0)
+		*pid = sub_info->retval;
 out:
 	call_usermodehelper_freeinfo(sub_info);
 unlock:
@@ -498,11 +503,11 @@ EXPORT_SYMBOL(call_usermodehelper_exec);
  * lower-level call_usermodehelper_* functions.
  */
 int call_usermodehelper_pipe(char *path, char **argv, char **envp,
-			     struct file **filp)
+			     struct file **filp, pid_t *pid)
 {
 	struct subprocess_info *sub_info;
 	int ret;
-
+	
 	sub_info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL);
 	if (sub_info == NULL)
 		return -ENOMEM;
@@ -511,7 +516,8 @@ int call_usermodehelper_pipe(char *path, char **argv, char **envp,
 	if (ret < 0)
 		goto out;
 
-	return call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
+	ret = call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC, pid);
+	return ret;
 
   out:
 	call_usermodehelper_freeinfo(sub_info);
diff --git a/kernel/sys.c b/kernel/sys.c
index 73b72a3..969b713 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1858,7 +1858,7 @@ int orderly_poweroff(bool force)
 
 	call_usermodehelper_setcleanup(info, argv_cleanup);
 
-	ret = call_usermodehelper_exec(info, UMH_NO_WAIT);
+	ret = call_usermodehelper_exec(info, UMH_NO_WAIT, NULL);
 
   out:
 	if (ret && force) {
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d14953a..3c0de70 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -75,6 +75,7 @@ extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
 extern char core_pattern[];
+extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
@@ -387,6 +388,14 @@ static struct ctl_table kern_table[] = {
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
