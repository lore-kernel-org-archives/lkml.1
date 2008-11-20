Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYKTLhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYKTLhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYKTLgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:36:19 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54865 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbYKTLgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:36:14 -0500
Message-Id: <20081120112731.333210606@I-love.SAKURA.ne.jp>
References: <20081120112543.799450455@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 20:25:45 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       David Howells <dhowells@redhat.com>
Subject: [TOMOYO #13 (mmotm 2008-11-19-02-19) 02/11] Add in_execve flag into task_struct.
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

--- linux-2.6.28-rc5-mm1.orig/fs/compat.c
+++ linux-2.6.28-rc5-mm1/fs/compat.c
@@ -1396,6 +1396,7 @@ int compat_do_execve(char * filename,
 	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
 	if (retval < 0)
 		goto out_free;
+	current->in_execve = 1;
 
 	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
@@ -1448,6 +1449,7 @@ int compat_do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
@@ -1464,6 +1466,7 @@ out_file:
 	}
 
 out_unlock:
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 
 out_free:
--- linux-2.6.28-rc5-mm1.orig/fs/exec.c
+++ linux-2.6.28-rc5-mm1/fs/exec.c
@@ -1293,6 +1293,7 @@ int do_execve(char * filename,
 	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
 	if (retval < 0)
 		goto out_free;
+	current->in_execve = 1;
 
 	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
@@ -1346,6 +1347,7 @@ int do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
@@ -1364,6 +1366,7 @@ out_file:
 	}
 
 out_unlock:
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 
 out_free:
--- linux-2.6.28-rc5-mm1.orig/include/linux/sched.h
+++ linux-2.6.28-rc5-mm1/include/linux/sched.h
@@ -1095,6 +1095,8 @@ struct task_struct {
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
+	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
+				 * execve */
 	pid_t pid;
 	pid_t tgid;
 

-- 
