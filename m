Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYHUMjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYHUMjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYHUMjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:39:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYHUMjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:39:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Move the exec mutex release out of bprm_free()
To: jmorris@namei.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Date: Thu, 21 Aug 2008 13:39:08 +0100
Message-ID: <20080821123907.4731.54839.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the exec mutex release out of free_bprm() and into the error handling
paths of do_execve() and compat_do_execve().  install_exec_creds() already
takes care of the success path.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/compat.c |    3 +--
 fs/exec.c   |    7 ++-----
 2 files changed, 3 insertions(+), 7 deletions(-)


diff --git a/fs/compat.c b/fs/compat.c
index 918f0f2..af24b8a 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1373,7 +1373,7 @@ int compat_do_execve(char * filename,
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_free;
+		goto out_unlock;
 
 	sched_exec();
 
@@ -1427,7 +1427,6 @@ out_file:
 		allow_write_access(bprm->file);
 		fput(bprm->file);
 	}
-	goto out_free;
 
 out_unlock:
 	mutex_unlock(&current->cred_exec_mutex);
diff --git a/fs/exec.c b/fs/exec.c
index 7b71679..9fa9a2d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1277,10 +1277,8 @@ EXPORT_SYMBOL(search_binary_handler);
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
 
@@ -1319,7 +1317,7 @@ int do_execve(char * filename,
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_free;
+		goto out_unlock;
 
 	sched_exec();
 
@@ -1376,7 +1374,6 @@ out_file:
 		allow_write_access(bprm->file);
 		fput(bprm->file);
 	}
-	goto out_free;
 
 out_unlock:
 	mutex_unlock(&current->cred_exec_mutex);

