Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYJCEye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYJCEye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 00:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYJCEyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 00:54:25 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50807 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbYJCEyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 00:54:25 -0400
X-Greylist: delayed 3439 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2008 00:54:24 EDT
Message-Id: <200810030356.m933uYeX005874@www262.sakura.ne.jp>
Subject: Re: [PATCH] CRED: ptrace_attach() should use the target process\'s mutex
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 03 Oct 2008 12:56:34 +0900
References: <200810012000.CGG73421.FQOHtLOJFVMOSF@I-love.SAKURA.ne.jp> <20081001153823.9930.86648.stgit@warthog.procyon.org.uk> <200810021952.GFJ87098.VQFtMOHJOFFLSO@I-love.SAKURA.ne.jp>
In-Reply-To: <200810021952.GFJ87098.VQFtMOHJOFFLSO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David Howells wrote:
> Tetsuo Handa wrote:
> 
> > Thus, I'm trying to use
> > 
> >   struct execve_entry {
> >          struct list_head list;
> >          struct task_struct *task;
> >   };
> > ...
> 
> It might be better to see about setting a flag in the task_struct.  All you
> need is a single bit, and since it's process-local it doesn't need any funny
> locking stuff.

Indeed. If I can use one bit in the task_struct, I don't need to add
security_start_execve() / security_finish_execve() hooks.

Now, I cancel the previous patch and propose this patch.

Thanks.
----------
Subject: Add in_execve flag into task_struct.

This patch allows LSM modules determine whether current process is in an execve
operation or not so that they can behave differently while an execve operation
is in progress.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/compat.c           |    4 ++++
 fs/exec.c             |    4 ++++
 include/linux/sched.h |    1 +
 3 files changed, 9 insertions(+)

--- linux-2.6.27-rc8-mm1.orig/fs/compat.c
+++ linux-2.6.27-rc8-mm1/fs/compat.c
@@ -1387,6 +1387,8 @@ int compat_do_execve(char * filename,
 	struct linux_binprm *bprm;
 	struct file *file;
 	int retval;
+	struct task_struct *task = current;
+	task->in_execve = 1;
 
 	retval = -ENOMEM;
 	bprm = kzalloc(sizeof(*bprm), GFP_KERNEL);
@@ -1443,6 +1445,7 @@ int compat_do_execve(char * filename,
 		security_bprm_free(bprm);
 		acct_update_integrals(current);
 		free_bprm(bprm);
+		task->in_execve = 0;
 		return retval;
 	}
 
@@ -1464,6 +1467,7 @@ out_kfree:
 	free_bprm(bprm);
 
 out_ret:
+	task->in_execve = 0;
 	return retval;
 }
 
--- linux-2.6.27-rc8-mm1.orig/fs/exec.c
+++ linux-2.6.27-rc8-mm1/fs/exec.c
@@ -1275,6 +1275,8 @@ int do_execve(char * filename,
 	struct file *file;
 	struct files_struct *displaced;
 	int retval;
+	struct task_struct *task = current;
+	task->in_execve = 1;
 
 	retval = unshare_files(&displaced);
 	if (retval)
@@ -1338,6 +1340,7 @@ int do_execve(char * filename,
 		free_bprm(bprm);
 		if (displaced)
 			put_files_struct(displaced);
+		task->in_execve = 0;
 		return retval;
 	}
 
@@ -1361,6 +1364,7 @@ out_files:
 	if (displaced)
 		reset_files_struct(displaced);
 out_ret:
+	task->in_execve = 0;
 	return retval;
 }
 
--- linux-2.6.27-rc8-mm1.orig/include/linux/sched.h
+++ linux-2.6.27-rc8-mm1/include/linux/sched.h
@@ -1088,6 +1088,7 @@ struct task_struct {
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
+	unsigned in_execve:1;
 	pid_t pid;
 	pid_t tgid;
 
