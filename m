Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYJTHho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYJTHho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbYJTHgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:36:54 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:49581 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYJTHgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:36:52 -0400
Message-Id: <20081020073645.488058369@nttdata.co.jp>
References: <20081020073423.024299308@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Mon, 20 Oct 2008 16:34:25 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       David Howells <dhowells@redhat.com>
Subject: [TOMOYO #11 (linux-next) 02/11] Add in_execve flag into task_struct.
X-OriginalArrivalTime: 20 Oct 2008 07:36:49.0253 (UTC) FILETIME=[9CAF9950:01C93286]
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

--- linux-next.orig/fs/compat.c
+++ linux-next/fs/compat.c
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
--- linux-next.orig/fs/exec.c
+++ linux-next/fs/exec.c
@@ -1303,6 +1303,7 @@ int do_execve(char * filename,
 	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
 	if (retval < 0)
 		goto out_free;
+	current->in_execve = 1;
 
 	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
@@ -1356,6 +1357,7 @@ int do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
@@ -1374,6 +1376,7 @@ out_file:
 	}
 
 out_unlock:
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 
 out_free:
--- linux-next.orig/include/linux/sched.h
+++ linux-next/include/linux/sched.h
@@ -1089,6 +1089,8 @@ struct task_struct {
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
+	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
+				 * execve */
 	pid_t pid;
 	pid_t tgid;
 

--

