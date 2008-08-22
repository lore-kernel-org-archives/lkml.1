Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbYHVNrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbYHVNrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 09:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYHVNrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 09:47:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbYHVNrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 09:47:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Further fix execve cred_exec_mutex handling [ver #2]
To: jmorris@namei.org, a.beregalov@gmail.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Date: Fri, 22 Aug 2008 14:46:36 +0100
Message-ID: <20080822134636.5797.34406.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further fix the way cred_exec_mutex is handled by [compat_]do_execve().  The
mutex is now only unlocked by the function that locked it, and is no longer
unlocked by free_bprm() or install_exec_creds().  This means that PTRACE_ATTACH
may have to wait a little longer before being allowed to proceed.

This patch cleans up the order in which the mutex is locked and unlocked and
gets rid of a potential double unlock.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/compat.c |   14 ++++++++------
 fs/exec.c   |   29 +++++++++++++++--------------
 2 files changed, 23 insertions(+), 20 deletions(-)


diff --git a/fs/compat.c b/fs/compat.c
index af24b8a..0c400ad 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1411,12 +1411,14 @@ int compat_do_execve(char * filename,
 		goto out;
 
 	retval = search_binary_handler(bprm, regs);
-	if (retval >= 0) {
-		/* execve success */
-		acct_update_integrals(current);
-		free_bprm(bprm);
-		return retval;
-	}
+	if (retval < 0)
+		goto out;
+
+	/* execve succeeded */
+	mutex_unlock(&current->cred_exec_mutex);
+	acct_update_integrals(current);
+	free_bprm(bprm);
+	return retval;
 
 out:
 	if (bprm->mm)
diff --git a/fs/exec.c b/fs/exec.c
index 4b31a72..a03a435 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1047,11 +1047,12 @@ void install_exec_creds(struct linux_binprm *bprm)
 {
 	security_bprm_committing_creds(bprm);
 
-	/* we hold cred_exec_mutex this far to prevent ptrace_attach() from
-	 * altering our determination of the task's credentials */
 	commit_creds(bprm->cred);
 	bprm->cred = NULL;
-	mutex_unlock(&current->cred_exec_mutex);
+
+	/* cred_exec_mutex must be held at least to this point to prevent
+	 * ptrace_attach() from altering our determination of the task's
+	 * credentials; any time after this it may be unlocked */
 
 	security_bprm_committed_creds(bprm);
 }
@@ -1277,10 +1278,8 @@ EXPORT_SYMBOL(search_binary_handler);
 void free_bprm(struct linux_binprm *bprm)
 {
 	free_arg_pages(bprm);
-	if (bprm->cred) {
-		mutex_unlock(&current->cred_exec_mutex);
+	if (bprm->cred)
 		abort_creds(bprm->cred);
-	}
 	kfree(bprm);
 }
 
@@ -1358,14 +1357,16 @@ int do_execve(char * filename,
 
 	current->flags &= ~PF_KTHREAD;
 	retval = search_binary_handler(bprm,regs);
-	if (retval >= 0) {
-		/* execve success */
-		acct_update_integrals(current);
-		free_bprm(bprm);
-		if (displaced)
-			put_files_struct(displaced);
-		return retval;
-	}
+	if (retval < 0)
+		goto out;
+
+	/* execve succeeded */
+	mutex_unlock(&current->cred_exec_mutex);
+	acct_update_integrals(current);
+	free_bprm(bprm);
+	if (displaced)
+		put_files_struct(displaced);
+	return retval;
 
 out:
 	if (bprm->mm)

