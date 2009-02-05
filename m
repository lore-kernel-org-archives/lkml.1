Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbZBEJHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbZBEJHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbZBEJEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:04:47 -0500
Received: from ms0.nttdata.co.jp ([163.135.193.231]:53381 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbZBEJEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:04:45 -0500
Message-Id: <20090205082224.360343106@nttdata.co.jp>
References: <20090205081810.331987920@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Thu, 05 Feb 2009 17:18:11 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       David Howells <dhowells@redhat.com>
Subject: [TOMOYO #15 1/8] Add in_execve flag into task_struct.
X-OriginalArrivalTime: 05 Feb 2009 08:22:25.0808 (UTC) FILETIME=[E069C100:01C9876A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows LSM modules to determine whether current process is in an
execve operation or not so that they can behave differently while an execve
operation is in progress.

This patch is needed by TOMOYO. Please see another patch titled "LSM adapter
functions." for backgrounds.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 fs/compat.c           |    3 +++
 fs/exec.c             |    3 +++
 include/linux/sched.h |    2 ++
 3 files changed, 8 insertions(+)

--- security-testing-2.6.git.orig/fs/compat.c
+++ security-testing-2.6.git/fs/compat.c
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
--- security-testing-2.6.git.orig/fs/exec.c
+++ security-testing-2.6.git/fs/exec.c
@@ -1268,6 +1268,7 @@ int do_execve(char * filename,
 	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
 	if (retval < 0)
 		goto out_free;
+	current->in_execve = 1;
 
 	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
@@ -1321,6 +1322,7 @@ int do_execve(char * filename,
 		goto out;
 
 	/* execve succeeded */
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
@@ -1339,6 +1341,7 @@ out_file:
 	}
 
 out_unlock:
+	current->in_execve = 0;
 	mutex_unlock(&current->cred_exec_mutex);
 
 out_free:
--- security-testing-2.6.git.orig/include/linux/sched.h
+++ security-testing-2.6.git/include/linux/sched.h
@@ -1157,6 +1157,8 @@ struct task_struct {
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
+	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
+				 * execve */
 	pid_t pid;
 	pid_t tgid;
 

--

