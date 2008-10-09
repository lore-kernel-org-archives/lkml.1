Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbYJIEad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbYJIEad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbYJIE3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:29:24 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:52195 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYJIE3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:29:19 -0400
Message-Id: <20081009042914.764918475@nttdata.co.jp>
References: <20081009042814.398846861@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Thu, 09 Oct 2008 13:28:16 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #10 (linux-next) 2/8] Add in_execve flag into task_struct.
X-OriginalArrivalTime: 09 Oct 2008 04:29:16.0585 (UTC) FILETIME=[97077990:01C929C7]
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
@@ -1357,6 +1357,7 @@ int compat_do_execve(char * filename,
 	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
 	if (retval < 0)
 		goto out_free;
+	current->in_execve = 1;
 
 	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
@@ -1409,6 +1410,7 @@ int compat_do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
@@ -1425,6 +1427,7 @@ out_file:
 	}
 
 out_unlock:
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 
 out_free:
--- linux-next.orig/fs/exec.c
+++ linux-next/fs/exec.c
@@ -1305,6 +1305,7 @@ int do_execve(char * filename,
 	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
 	if (retval < 0)
 		goto out_free;
+	current->in_execve = 1;
 
 	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
@@ -1358,6 +1359,7 @@ int do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
@@ -1376,6 +1378,7 @@ out_file:
 	}
 
 out_unlock:
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 
 out_free:
--- linux-next.orig/include/linux/sched.h
+++ linux-next/include/linux/sched.h
@@ -1052,6 +1052,8 @@ struct task_struct {
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
+	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
+				 * execve */
 	pid_t pid;
 	pid_t tgid;
 

--

