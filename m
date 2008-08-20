Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbYHTN4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbYHTN4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYHTN4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:56:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbYHTN4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:56:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Further fix execve error handling
To: jmorris@namei.org, a.beregalov@gmail.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Date: Wed, 20 Aug 2008 14:56:29 +0100
Message-ID: <20080820135624.10583.99230.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further fix [compat_]do_execve() error handling.  free_bprm() will release the
cred_exec_mutex, but only if bprm->cred is not NULL.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/compat.c |    3 ++-
 fs/exec.c   |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/compat.c b/fs/compat.c
index af24b8a..918f0f2 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1373,7 +1373,7 @@ int compat_do_execve(char * filename,
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_unlock;
+		goto out_free;
 
 	sched_exec();
 
@@ -1427,6 +1427,7 @@ out_file:
 		allow_write_access(bprm->file);
 		fput(bprm->file);
 	}
+	goto out_free;
 
 out_unlock:
 	mutex_unlock(&current->cred_exec_mutex);
diff --git a/fs/exec.c b/fs/exec.c
index 4b31a72..7b71679 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1319,7 +1319,7 @@ int do_execve(char * filename,
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
-		goto out_unlock;
+		goto out_free;
 
 	sched_exec();
 
@@ -1376,6 +1376,7 @@ out_file:
 		allow_write_access(bprm->file);
 		fput(bprm->file);
 	}
+	goto out_free;
 
 out_unlock:
 	mutex_unlock(&current->cred_exec_mutex);

