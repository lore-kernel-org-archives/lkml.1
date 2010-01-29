Return-Path: <linux-kernel-owner+w=401wt.eu-S932200Ab0A2PPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab0A2PPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 10:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972Ab0A2PPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 10:15:06 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58903 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab0A2PPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 10:15:02 -0500
Date: Fri, 29 Jan 2010 10:14:58 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jmoskovc@redhat.com, mingo@redhat.com,
       drbd-dev@lists.linbit.com, benh@kernel.crashing.org,
       t.sailer@alumni.ethz.ch, abelay@mit.edu, gregkh@suse.de,
       spock@gentoo.org, viro@zeniv.linux.org.uk, neilb@suse.de,
       mfasheh@suse.com, menage@google.com, shemminger@linux-foundation.org,
       takedakn@nttdata.co.jp, oleg@redhat.com
Subject: Re: [PATCH 2/2] exec: allow core_pipe recursion check to look for a
 value of 1 rather than 0 (v2)
Message-ID: <20100129151458.GC19249@hmsreliant.think-freely.org>
References: <20100121200806.GA29801@shamino.rdu.redhat.com>
 <20100129151024.GA19249@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129151024.GA19249@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace call_usermodehelper_pipe with use of umh init function and resolve limit

The first patch in this series introduced an init function to the
call_usermodehelper api so that processes could be customized by caller.  This
patch takes advantage of that fact, by customizing the helper in do_coredump to
create the pipe and set its core limit to one (for our recusrsion check).  This
lets us clean up the previous uglyness in the usermodehelper internals and
factor call_usermodehelper out entirely.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 fs/exec.c            |   63 ++++++++++++++++++++++++++++++++++----
 include/linux/kmod.h |    4 --
 kernel/kmod.c        |   83 ---------------------------------------------------
 3 files changed, 56 insertions(+), 94 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 1a0b921..428ea6f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1762,6 +1762,50 @@ static void wait_for_dump_helpers(struct file *file)
 }
 
 
+/*
+ * uhm_pipe_setup
+ * helper function to customize the process used
+ * to collect the core in userspace.  Specifically
+ * it sets up a pipe and installs it as fd 0 (stdin)
+ * for the process.  Returns 0 on success, or
+ * PTR_ERR on failure.
+ * Note that it also sets the core limit to 1.  This
+ * is a special value that we use to trap recursive
+ * core dumps
+ */
+static int umh_pipe_setup(void *data)
+{
+	struct file *rp, *wp;
+	struct fdtable *fdt;
+	struct coredump_params *cp = (struct coredump_params *)data;
+	struct files_struct *cf = current->files;
+
+	wp = create_write_pipe(0);
+	if (IS_ERR(wp))
+		return PTR_ERR(wp);
+
+	rp = create_read_pipe(wp, 0);
+	if (IS_ERR(rp)) {
+		free_write_pipe(wp);
+		return PTR_ERR(rp);
+	}
+
+	cp->file = wp;
+
+	sys_close(0);
+	fd_install(0, rp);
+	spin_lock(&cf->file_lock);
+	fdt = files_fdtable(cf);
+	FD_SET(0, fdt->open_fds);
+	FD_CLR(0, fdt->close_on_exec);
+	spin_unlock(&cf->file_lock);
+
+	/* and disallow core files too */
+	current->signal->rlim[RLIMIT_CORE] = (struct rlimit){1, 1};
+
+	return 0;
+}
+
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
@@ -1848,15 +1892,15 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		goto fail_unlock;
 
  	if (ispipe) {
-		if (cprm.limit == 0) {
+		if (cprm.limit == 1) {
 			/*
 			 * Normally core limits are irrelevant to pipes, since
 			 * we're not writing to the file system, but we use
-			 * cprm.limit of 0 here as a speacial value. Any
-			 * non-zero limit gets set to RLIM_INFINITY below, but
+			 * cprm.limit of 1 here as a speacial value. Any
+			 * non-1 limit gets set to RLIM_INFINITY below, but
 			 * a limit of 0 skips the dump.  This is a consistent
 			 * way to catch recursive crashes.  We can still crash
-			 * if the core_pattern binary sets RLIM_CORE =  !0
+			 * if the core_pattern binary sets RLIM_CORE =  !1
 			 * but it runs as root, and can do lots of stupid things
 			 * Note that we use task_tgid_vnr here to grab the pid
 			 * of the process group leader.  That way we get the
@@ -1864,7 +1908,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 			 * core_pattern process dies.
 			 */
 			printk(KERN_WARNING
-				"Process %d(%s) has RLIMIT_CORE set to 0\n",
+				"Process %d(%s) has RLIMIT_CORE set to 1\n",
 				task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Aborting core\n");
 			goto fail_unlock;
@@ -1888,8 +1932,13 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		cprm.limit = RLIM_INFINITY;
 
 		/* SIGPIPE can happen, but it's just never processed */
-		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
-				&cprm.file)) {
+		cprm.file = NULL;
+		if (call_usermodehelper_fns(helper_argv[0], helper_argv, NULL,
+					    UMH_WAIT_EXEC, umh_pipe_setup,
+					    NULL, &cprm)) {
+			if (cprm.file)
+				filp_close(cprm.file, NULL);
+
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
 			goto fail_dropcount;
diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 54db3ff..4a2957d 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -116,10 +116,6 @@ call_usermodehelper_keys(char *path, char **argv, char **envp,
 
 extern void usermodehelper_init(void);
 
-struct file;
-extern int call_usermodehelper_pipe(char *path, char *argv[], char *envp[],
-				    struct file **filp);
-
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
 
diff --git a/kernel/kmod.c b/kernel/kmod.c
index cab23a8..85e2cc6 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -154,7 +154,6 @@ struct subprocess_info {
 	char **envp;
 	enum umh_wait wait;
 	int retval;
-	struct file *stdin;
 	int (*init)(void *data);
 	void (*cleanup)(char **argv, char **envp, void *data);
 	void *data;
@@ -181,23 +180,6 @@ static int ____call_usermodehelper(void *data)
 	commit_creds(sub_info->cred);
 	sub_info->cred = NULL;
 
-	/* Install input pipe when needed */
-	if (sub_info->stdin) {
-		struct files_struct *f = current->files;
-		struct fdtable *fdt;
-		/* no races because files should be private here */
-		sys_close(0);
-		fd_install(0, sub_info->stdin);
-		spin_lock(&f->file_lock);
-		fdt = files_fdtable(f);
-		FD_SET(0, fdt->open_fds);
-		FD_CLR(0, fdt->close_on_exec);
-		spin_unlock(&f->file_lock);
-
-		/* and disallow core files too */
-		current->signal->rlim[RLIMIT_CORE] = (struct rlimit){0, 0};
-	}
-
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed_ptr(current, cpu_all_mask);
 
@@ -477,35 +459,6 @@ void call_usermodehelper_setinit(struct subprocess_info *info,
 EXPORT_SYMBOL(call_usermodehelper_setinit);
 
 /**
- * call_usermodehelper_stdinpipe - set up a pipe to be used for stdin
- * @sub_info: a subprocess_info returned by call_usermodehelper_setup
- * @filp: set to the write-end of a pipe
- *
- * This constructs a pipe, and sets the read end to be the stdin of the
- * subprocess, and returns the write-end in *@filp.
- */
-int call_usermodehelper_stdinpipe(struct subprocess_info *sub_info,
-				  struct file **filp)
-{
-	struct file *f;
-
-	f = create_write_pipe(0);
-	if (IS_ERR(f))
-		return PTR_ERR(f);
-	*filp = f;
-
-	f = create_read_pipe(f, 0);
-	if (IS_ERR(f)) {
-		free_write_pipe(*filp);
-		return PTR_ERR(f);
-	}
-	sub_info->stdin = f;
-
-	return 0;
-}
-EXPORT_SYMBOL(call_usermodehelper_stdinpipe);
-
-/**
  * call_usermodehelper_exec - start a usermode application
  * @sub_info: information about the subprocessa
  * @wait: wait for the application to finish and return status.
@@ -552,42 +505,6 @@ unlock:
 }
 EXPORT_SYMBOL(call_usermodehelper_exec);
 
-/**
- * call_usermodehelper_pipe - call a usermode helper process with a pipe stdin
- * @path: path to usermode executable
- * @argv: arg vector for process
- * @envp: environment for process
- * @filp: set to the write-end of a pipe
- *
- * This is a simple wrapper which executes a usermode-helper function
- * with a pipe as stdin.  It is implemented entirely in terms of
- * lower-level call_usermodehelper_* functions.
- */
-int call_usermodehelper_pipe(char *path, char **argv, char **envp,
-			     struct file **filp)
-{
-	struct subprocess_info *sub_info;
-	int ret;
-
-	sub_info = call_usermodehelper_setup(path, argv, envp,
-					     NULL, GFP_KERNEL);
-	if (sub_info == NULL)
-		return -ENOMEM;
-
-	ret = call_usermodehelper_stdinpipe(sub_info, filp);
-	if (ret < 0) {
-		call_usermodehelper_freeinfo(sub_info);
-		return ret;
-	}
-
-	ret = call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
-	if (ret < 0)	/* Failed to execute helper, close pipe */
-		filp_close(*filp, NULL);
-
-	return ret;
-}
-EXPORT_SYMBOL(call_usermodehelper_pipe);
-
 void __init usermodehelper_init(void)
 {
 	khelper_wq = create_singlethread_workqueue("khelper");
