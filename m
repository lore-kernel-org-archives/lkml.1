Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYHSPSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYHSPSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYHSPSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:18:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYHSPSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:18:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Take cred_exec_mutex in compat_do_execve() and fix
	error handling in do_execve()
To: jmorris@namei.org, a.beregalov@gmail.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Date: Tue, 19 Aug 2008 16:18:29 +0100
Message-ID: <20080819151829.24589.30461.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take cred_exec_mutex in compat_do_execve().  This reflects what do_execve()
does.  The mutex protects credentials calculation against PTRACE_ATTACH needing
to alter it mid-exec.

Also fix the error handling in do_execve().  The mutex needs to be unlocked if
an error occurs after it is taken, but before the install_exec_creds()
released it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/compat.c |   12 ++++++++++--
 fs/exec.c   |   12 ++++++++----
 2 files changed, 18 insertions(+), 6 deletions(-)


diff --git a/fs/compat.c b/fs/compat.c
index 2dde882..af24b8a 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1360,15 +1360,20 @@ int compat_do_execve(char * filename,
 	if (!bprm)
 		goto out_ret;
 
+	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
+	if (retval < 0)
+		goto out_free;
+
+	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
 	if (!bprm->cred)
-		goto out_free;
+		goto out_unlock;
 	check_unsafe_exec(bprm);
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_free;
+		goto out_unlock;
 
 	sched_exec();
 
@@ -1423,6 +1428,9 @@ out_file:
 		fput(bprm->file);
 	}
 
+out_unlock:
+	mutex_unlock(&current->cred_exec_mutex);
+
 out_free:
 	free_bprm(bprm);
 
diff --git a/fs/exec.c b/fs/exec.c
index a7633e5..4b31a72 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1308,18 +1308,18 @@ int do_execve(char * filename,
 
 	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
 	if (retval < 0)
-		goto out_kfree;
+		goto out_free;
 
 	retval = -ENOMEM;
 	bprm->cred = prepare_exec_creds();
 	if (!bprm->cred)
-		goto out_kfree;
+		goto out_unlock;
 	check_unsafe_exec(bprm);
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_kfree;
+		goto out_unlock;
 
 	sched_exec();
 
@@ -1376,7 +1376,11 @@ out_file:
 		allow_write_access(bprm->file);
 		fput(bprm->file);
 	}
-out_kfree:
+
+out_unlock:
+	mutex_unlock(&current->cred_exec_mutex);
+
+out_free:
 	free_bprm(bprm);
 
 out_files:

