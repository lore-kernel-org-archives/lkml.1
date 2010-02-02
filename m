Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab0BBTVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:21:16 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44676 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab0BBTVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:21:03 -0500
Date: Tue, 2 Feb 2010 14:20:59 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jmoskovc@redhat.com, mingo@redhat.com,
       drbd-dev@lists.linbit.com, benh@kernel.crashing.org,
       t.sailer@alumni.ethz.ch, abelay@mit.edu, gregkh@suse.de,
       spock@gentoo.org, viro@zeniv.linux.org.uk, neilb@suse.de,
       mfasheh@suse.com, menage@google.com, shemminger@linux-foundation.org,
       takedakn@nttdata.co.jp, oleg@redhat.com
Subject: Re: [PATCH 1/2] exec: refactor how call_usermodehelper works, and
 update the sense of the core_pipe recursion check (v3)
Message-ID: <20100202192059.GC12697@hmsreliant.think-freely.org>
References: <20100121200806.GA29801@shamino.rdu.redhat.com>
 <20100202191940.GB12697@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202191940.GB12697@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add init function to usermodehelper

Convert call_usermodehelper_cleanup to usermodehelper_fns and allow it to assign
both an init function and a cleanup function.  The init function is called from
the context of the forked process and allows for customization of the helper
process prior to calling exec.  Its return code gates the continuation of the
process, or causes its exit.  Also add an arbitrary data pointer to the
subprocess_info struct allowing for data to be passed from the caller to the new
process, and the subsequent cleanup process

Also, use this patch to cleanup the cleanup function.  It currently takes an
argp and envp pointer for freeing, which is ugly.  Lets instead just make the
subprocess_info structure public, and pass that to the cleanup and init routines

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 25d227c..2f3efdc 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -44,7 +44,27 @@ static inline int request_module_nowait(const char *name, ...) { return -ENOSYS;
 
 struct key;
 struct file;
-struct subprocess_info;
+
+enum umh_wait {
+	UMH_NO_WAIT = -1,	/* don't wait at all */
+	UMH_WAIT_EXEC = 0,	/* wait for the exec, but not the process */
+	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
+};
+
+struct subprocess_info {
+	struct work_struct work;
+	struct completion *complete;
+	struct cred *cred;
+	char *path;
+	char **argv;
+	char **envp;
+	enum umh_wait wait;
+	int retval;
+	struct file *stdin;
+	int (*init)(struct subprocess_info *info);
+	void (*cleanup)(struct subprocess_info *info);
+	void *data;
+};
 
 /* Allocate a subprocess_info structure */
 struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
@@ -55,14 +75,10 @@ void call_usermodehelper_setkeys(struct subprocess_info *info,
 				 struct key *session_keyring);
 int call_usermodehelper_stdinpipe(struct subprocess_info *sub_info,
 				  struct file **filp);
-void call_usermodehelper_setcleanup(struct subprocess_info *info,
-				    void (*cleanup)(char **argv, char **envp));
-
-enum umh_wait {
-	UMH_NO_WAIT = -1,	/* don't wait at all */
-	UMH_WAIT_EXEC = 0,	/* wait for the exec, but not the process */
-	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
-};
+void call_usermodehelper_setfns(struct subprocess_info *info,
+		    int (*init)(struct subprocess_info *info),
+		    void (*cleanup)(struct subprocess_info *info),
+		    void *data);
 
 /* Actually execute the sub-process */
 int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
@@ -72,8 +88,10 @@ int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
 void call_usermodehelper_freeinfo(struct subprocess_info *info);
 
 static inline int
-call_usermodehelper_cleanup(char *path, char **argv, char **envp, enum umh_wait wait,
-			    void (*cleanup)(char **, char **))
+call_usermodehelper_fns(char *path, char **argv, char **envp,
+		    enum umh_wait wait,
+		    int (*init)(struct subprocess_info *info),
+		    void (*cleanup)(struct subprocess_info *), void *data)
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
@@ -81,15 +99,15 @@ call_usermodehelper_cleanup(char *path, char **argv, char **envp, enum umh_wait
 	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
-	if (cleanup)
-		call_usermodehelper_setcleanup(info, cleanup);
+	call_usermodehelper_setfns(info, init, cleanup, data);
 	return call_usermodehelper_exec(info, wait);
 }
 
 static inline int
 call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
 {
-	return call_usermodehelper_cleanup(path, argv, envp, wait, NULL);
+	return call_usermodehelper_fns(path, argv, envp,
+				       wait, NULL, NULL, NULL);
 }
 
 static inline int
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 2db0689..1094b41 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -51,9 +51,9 @@ static struct workqueue_struct *khelper_wq;
 */
 char *modprobe_path = "/sbin/modprobe";
 
-static void free_arg(char **argv, char **env)
+static void free_arg(struct subprocess_info *info)
 {
-	kfree(argv[0]);
+	kfree(info->argv[0]);
 }
 
 /**
@@ -133,8 +133,9 @@ int __request_module(bool wait, const char *fmt, ...)
 
 	trace_module_request(module_name, wait, _RET_IP_);
 
-	ret = call_usermodehelper_cleanup(mp_copy, argv, envp,
-			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC, free_arg);
+	ret = call_usermodehelper_fns(mp_copy, argv, envp,
+			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC,
+			NULL, free_arg, NULL);
 	mp_copy = NULL; /* free_arg frees */
 	atomic_dec(&kmod_concurrent);
 error:
@@ -144,19 +145,6 @@ error:
 EXPORT_SYMBOL(__request_module);
 #endif /* CONFIG_MODULES */
 
-struct subprocess_info {
-	struct work_struct work;
-	struct completion *complete;
-	struct cred *cred;
-	char *path;
-	char **argv;
-	char **envp;
-	enum umh_wait wait;
-	int retval;
-	struct file *stdin;
-	void (*cleanup)(char **argv, char **envp);
-};
-
 /*
  * This is the task which runs the usermode application
  */
@@ -198,6 +186,12 @@ static int ____call_usermodehelper(void *data)
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed_ptr(current, cpu_all_mask);
 
+	if (sub_info->init) {
+		retval = sub_info->init(sub_info);
+		if (retval)
+			goto fail;
+	}
+
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
 	 * Avoid propagating that into the userspace child.
@@ -207,6 +201,7 @@ static int ____call_usermodehelper(void *data)
 	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
 
 	/* Exec failed? */
+fail:
 	sub_info->retval = retval;
 	do_exit(0);
 }
@@ -214,7 +209,7 @@ static int ____call_usermodehelper(void *data)
 void call_usermodehelper_freeinfo(struct subprocess_info *info)
 {
 	if (info->cleanup)
-		(*info->cleanup)(info->argv, info->envp);
+		(*info->cleanup)(info);
 	if (info->cred)
 		put_cred(info->cred);
 	kfree(info);
@@ -426,21 +421,31 @@ void call_usermodehelper_setkeys(struct subprocess_info *info,
 EXPORT_SYMBOL(call_usermodehelper_setkeys);
 
 /**
- * call_usermodehelper_setcleanup - set a cleanup function
+ * call_usermodehelper_setfns - set a cleanup/init function
  * @info: a subprocess_info returned by call_usermodehelper_setup
  * @cleanup: a cleanup function
+ * @init: an init function
+ * @data: arbitrary context sensitive data
+ *
+ * The init function is used to customize the helper process prior to
+ * exec.  A non-zero return code causes the process to error out, exit,
+ * and return the failure to the calling process
  *
- * The cleanup function is just befor ethe subprocess_info is about to
+ * The cleanup function is just before ethe subprocess_info is about to
  * be freed.  This can be used for freeing the argv and envp.  The
  * Function must be runnable in either a process context or the
  * context in which call_usermodehelper_exec is called.
  */
-void call_usermodehelper_setcleanup(struct subprocess_info *info,
-				    void (*cleanup)(char **argv, char **envp))
+void call_usermodehelper_setfns(struct subprocess_info *info,
+		    int (*init)(struct subprocess_info *info),
+		    void (*cleanup)(struct subprocess_info *info),
+		    void *data)
 {
 	info->cleanup = cleanup;
+	info->init = init;
+	info->data = data;
 }
-EXPORT_SYMBOL(call_usermodehelper_setcleanup);
+EXPORT_SYMBOL(call_usermodehelper_setfns);
 
 /**
  * call_usermodehelper_stdinpipe - set up a pipe to be used for stdin
@@ -535,7 +540,8 @@ int call_usermodehelper_pipe(char *path, char **argv, char **envp,
 	struct subprocess_info *sub_info;
 	int ret;
 
-	sub_info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL);
+	sub_info = call_usermodehelper_setup(path, argv, envp,
+					     GFP_KERNEL);
 	if (sub_info == NULL)
 		return -ENOMEM;
 
diff --git a/kernel/sys.c b/kernel/sys.c
index ef286ab..71005f1 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1728,9 +1728,9 @@ SYSCALL_DEFINE3(getcpu, unsigned __user *, cpup, unsigned __user *, nodep,
 
 char *poweroff_cmd = "/sbin/poweroff";
 
-static void argv_cleanup(char **argv, char **envp)
+static void argv_cleanup(struct subprocess_info *info)
 {
-	argv_free(argv);
+	argv_free(info->argv);
 }
 
 /**
@@ -1768,7 +1768,7 @@ int orderly_poweroff(bool force)
 		goto out;
 	}
 
-	call_usermodehelper_setcleanup(info, argv_cleanup);
+	call_usermodehelper_setfns(info, NULL, argv_cleanup, NULL);
 
 	ret = call_usermodehelper_exec(info, UMH_NO_WAIT);
 
