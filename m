Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbZAAFV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbZAAFV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 00:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZAAFUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 00:20:47 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:58182 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZAAFUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 00:20:44 -0500
Message-Id: <20090101050938.558328702@I-love.SAKURA.ne.jp>
References: <20090101050741.372438529@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 2009 14:07:42 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       David Howells <dhowells@redhat.com>
Subject: [TOMOYO #14 (mmotm 2008-12-30-16-05) 01/10] Add in_execve flag into task_struct.
Content-Disposition: inline; filename=add-in_execve-flag-into-task_struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows LSM modules to determine whether current process is in an
execve operation or not so that they can behave differently while an execve
operation is in progress.

This allows TOMOYO to dispense with a readability check on a file to be
executed under the process's current credentials, and to do it instead under
the proposed credentials.

This is required with the new COW credentials because TOMOYO is no longer
allowed to mark the state temporarily in the security struct attached to the
task_struct.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 fs/compat.c           |    3 +++
 fs/exec.c             |    3 +++
 include/linux/sched.h |    2 ++
 3 files changed, 8 insertions(+)

--- linux-2.6.28-mm1.orig/fs/compat.c
+++ linux-2.6.28-mm1/fs/compat.c
@@ -1402,6 +1402,7 @@ int compat_do_execve(char * filename,
 	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
 	if (retval < 0)
 		goto out_free;
+	current->in_execve = 1;
 
 	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
@@ -1454,6 +1455,7 @@ int compat_do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
@@ -1470,6 +1472,7 @@ out_file:
 	}
 
 out_unlock:
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 
 out_free:
--- linux-2.6.28-mm1.orig/fs/exec.c
+++ linux-2.6.28-mm1/fs/exec.c
@@ -1306,6 +1306,7 @@ int do_execve(char * filename,
 	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
 	if (retval < 0)
 		goto out_free;
+	current->in_execve = 1;
 
 	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
@@ -1359,6 +1360,7 @@ int do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
@@ -1377,6 +1379,7 @@ out_file:
 	}
 
 out_unlock:
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 
 out_free:
--- linux-2.6.28-mm1.orig/include/linux/sched.h
+++ linux-2.6.28-mm1/include/linux/sched.h
@@ -1155,6 +1155,8 @@ struct task_struct {
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
+	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
+				 * execve */
 	pid_t pid;
 	pid_t tgid;
 

-- 
