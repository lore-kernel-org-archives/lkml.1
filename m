Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936207Ab0COMeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 08:34:00 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46687 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936092Ab0COMd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 08:33:59 -0400
Date: Mon, 15 Mar 2010 08:33:55 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com, andi@firstfloor.org
Subject: Re: [PATCH 1/2] kmod: add init function to usermodehelper
Message-ID: <20100315123355.GC16175@hmsreliant.think-freely.org>
References: <20100315122908.GB16175@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315122908.GB16175@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.2 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rediff of the usermodehelper changes after all the wreckage.  This patch
encompasses the patches that were formally in -mm as:
kmod-add-init-function-to-usermodehelper.patch
kmod-add-init-function-to-usermodehelper-fix.patch

I also rolled in changes from Oleg, moving the call of the init method down in
____call_usermodehelper, so the init function could override the nice level on
the process.

Create new function call_usermodehelper_fns() and allow it
to assign both an init and cleanup function, as we'll as arbitrary data.

The init function is called from the context of the forked process and
allows for customization of the helper process prior to calling exec.  Its
return code gates the continuation of the process, or causes its exit.
Also add an arbitrary data pointer to the subprocess_info struct allowing
for data to be passed from the caller to the new process, and the
subsequent cleanup process

Also, use this patch to cleanup the cleanup function.  It currently takes
an argp and envp pointer for freeing, which is ugly.  Lets instead just
make the subprocess_info structure public, and pass that to the cleanup
and init routines

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>


 include/linux/kmod.h |   51 +++++++++++++++++++++++++++++++++++++++++----------
 kernel/kmod.c        |   51 +++++++++++++++++++++++++++++----------------------
 kernel/sys.c         |    6 +++---
 3 files changed, 73 insertions(+), 35 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index facb27f..f9edf63 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -23,6 +23,7 @@
 #include <linux/stddef.h>
 #include <linux/errno.h>
 #include <linux/compiler.h>
+#include <linux/workqueue.h>
 
 #define KMOD_PATH_LEN 256
 
@@ -45,7 +46,27 @@ static inline int request_module_nowait(const char *name, ...) { return -ENOSYS;
 
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
@@ -56,14 +77,10 @@ void call_usermodehelper_setkeys(struct subprocess_info *info,
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
@@ -73,18 +90,32 @@ int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
 void call_usermodehelper_freeinfo(struct subprocess_info *info);
 
 static inline int
-call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
+call_usermodehelper_fns(char *path, char **argv, char **envp,
+			enum umh_wait wait,
+			int (*init)(struct subprocess_info *info),
+			void (*cleanup)(struct subprocess_info *), void *data)
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
 	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
+
 	if (info == NULL)
 		return -ENOMEM;
+
+	call_usermodehelper_setfns(info, init, cleanup, data);
+
 	return call_usermodehelper_exec(info, wait);
 }
 
 static inline int
+call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
+{
+	return call_usermodehelper_fns(path, argv, envp, wait,
+				       NULL, NULL, NULL);
+}
+
+static inline int
 call_usermodehelper_keys(char *path, char **argv, char **envp,
 			 struct key *session_keyring, enum umh_wait wait)
 {
diff --git a/kernel/kmod.c b/kernel/kmod.c
index bf0e231..531ef62 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -116,27 +116,16 @@ int __request_module(bool wait, const char *fmt, ...)
 
 	trace_module_request(module_name, wait, _RET_IP_);
 
-	ret = call_usermodehelper(modprobe_path, argv, envp,
-			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
+	ret = call_usermodehelper_fns(modprobe_path, argv, envp,
+			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC,
+			NULL, NULL, NULL);
+
 	atomic_dec(&kmod_concurrent);
 	return ret;
 }
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
@@ -184,9 +173,16 @@ static int ____call_usermodehelper(void *data)
 	 */
 	set_user_nice(current, 0);
 
+	if (sub_info->init) {
+		retval = sub_info->init(sub_info);
+		if (retval)
+			goto fail;
+	}
+
 	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
 
 	/* Exec failed? */
+fail:
 	sub_info->retval = retval;
 	do_exit(0);
 }
@@ -194,7 +190,7 @@ static int ____call_usermodehelper(void *data)
 void call_usermodehelper_freeinfo(struct subprocess_info *info)
 {
 	if (info->cleanup)
-		(*info->cleanup)(info->argv, info->envp);
+		(*info->cleanup)(info);
 	if (info->cred)
 		put_cred(info->cred);
 	kfree(info);
@@ -406,21 +402,31 @@ void call_usermodehelper_setkeys(struct subprocess_info *info,
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
@@ -515,7 +521,8 @@ int call_usermodehelper_pipe(char *path, char **argv, char **envp,
 	struct subprocess_info *sub_info;
 	int ret;
 
-	sub_info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL);
+	sub_info = call_usermodehelper_setup(path, argv, envp,
+					     GFP_KERNEL);
 	if (sub_info == NULL)
 		return -ENOMEM;
 
diff --git a/kernel/sys.c b/kernel/sys.c
index ee25411..66b9edc 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1765,9 +1765,9 @@ SYSCALL_DEFINE3(getcpu, unsigned __user *, cpup, unsigned __user *, nodep,
 
 char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
 
-static void argv_cleanup(char **argv, char **envp)
+static void argv_cleanup(struct subprocess_info *info)
 {
-	argv_free(argv);
+	argv_free(info->argv);
 }
 
 /**
@@ -1801,7 +1801,7 @@ int orderly_poweroff(bool force)
 		goto out;
 	}
 
-	call_usermodehelper_setcleanup(info, argv_cleanup);
+	call_usermodehelper_setfns(info, NULL, argv_cleanup, NULL);
 
 	ret = call_usermodehelper_exec(info, UMH_NO_WAIT);
 
