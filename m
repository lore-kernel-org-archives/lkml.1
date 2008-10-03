Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYJCPdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYJCPdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYJCPdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:33:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58549 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbYJCPda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:33:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200810030356.m933uYeX005874@www262.sakura.ne.jp>
References: <200810030356.m933uYeX005874@www262.sakura.ne.jp> <200810012000.CGG73421.FQOHtLOJFVMOSF@I-love.SAKURA.ne.jp> <20081001153823.9930.86648.stgit@warthog.procyon.org.uk> <200810021952.GFJ87098.VQFtMOHJOFFLSO@I-love.SAKURA.ne.jp>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: ptrace_attach() should use the target process\'s mutex
Date: Fri, 03 Oct 2008 16:33:24 +0100
Message-ID: <25964.1223048004@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Subject: Add in_execve flag into task_struct.
> 
> This patch allows LSM modules determine whether current process is in an
> execve operation or not so that they can behave differently while an execve
> operation is in progress.

This doesn't apply on top of my patches.  How about the attached variant?

I've also:

 (1) Extended the patch description.  Please check that I've summed up TOMOYA's
     process correctly.

 (2) Used current directly rather than caching it in a variable.  I don't
     think it's worth doing that, given the amount you make use of it, but I
     can revert this change if you'd really prefer.

David
---
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

CRED: Add in_execve flag into task_struct.

This patch allows LSM modules to determine whether current process is in an
execve operation or not so that they can behave differently while an execve
operation is in progress.

This allows TOMOYA to dispense with a readability check on a file to be
executed under the process's current credentials, and to do it instead under
the proposed credentials.

This is required with the new COW credentials because TOMOYA is no longer
allowed to mark the state temporarily in the security struct attached to the
task_struct.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/compat.c           |    3 +++
 fs/exec.c             |    3 +++
 include/linux/sched.h |    2 ++
 3 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/fs/compat.c b/fs/compat.c
index 0c400ad..9e0dc12 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1355,6 +1355,7 @@ int compat_do_execve(char * filename,
 	struct file *file;
 	int retval;
 
+	current->in_execve = 1;
 	retval = -ENOMEM;
 	bprm = kzalloc(sizeof(*bprm), GFP_KERNEL);
 	if (!bprm)
@@ -1418,6 +1419,7 @@ int compat_do_execve(char * filename,
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
+	current->in_execve = 0;
 	return retval;
 
 out:
@@ -1437,6 +1439,7 @@ out_free:
 	free_bprm(bprm);
 
 out_ret:
+	current->in_execve = 0;
 	return retval;
 }
 
diff --git a/fs/exec.c b/fs/exec.c
index a03a435..c1aab0c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1296,6 +1296,7 @@ int do_execve(char * filename,
 	struct files_struct *displaced;
 	int retval;
 
+	current->in_execve = 1;
 	retval = unshare_files(&displaced);
 	if (retval)
 		goto out_ret;
@@ -1366,6 +1367,7 @@ int do_execve(char * filename,
 	free_bprm(bprm);
 	if (displaced)
 		put_files_struct(displaced);
+	current->in_execve = 0;
 	return retval;
 
 out:
@@ -1388,6 +1390,7 @@ out_files:
 	if (displaced)
 		reset_files_struct(displaced);
 out_ret:
+	current->in_execve = 0;
 	return retval;
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2ae6ef8..2648559 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1052,6 +1052,8 @@ struct task_struct {
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
+	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
+				 * execve */
 	pid_t pid;
 	pid_t tgid;
 
