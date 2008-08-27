Return-Path: <linux-kernel-owner+w=401wt.eu-S1759183AbYH0N4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183AbYH0N4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbYH0Ntw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:49:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427AbYH0Ntu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:49:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/59] CRED: Wrap task credential accesses in the Coda
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
       codalist@TELEMANN.coda.cs.cmu.edu
Date: Wed, 27 Aug 2008 14:47:25 +0100
Message-ID: <20080827134725.19980.20123.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: codalist@coda.cs.cmu.edu
---

 fs/coda/cache.c  |    6 +++---
 fs/coda/upcall.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 8a23703..a5bf577 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -32,8 +32,8 @@ void coda_cache_enter(struct inode *inode, int mask)
 	struct coda_inode_info *cii = ITOC(inode);
 
 	cii->c_cached_epoch = atomic_read(&permission_epoch);
-	if (cii->c_uid != current->fsuid) {
-                cii->c_uid = current->fsuid;
+	if (cii->c_uid != current_fsuid()) {
+		cii->c_uid = current_fsuid();
                 cii->c_cached_perm = mask;
         } else
                 cii->c_cached_perm |= mask;
@@ -60,7 +60,7 @@ int coda_cache_check(struct inode *inode, int mask)
         int hit;
 	
         hit = (mask & cii->c_cached_perm) == mask &&
-		cii->c_uid == current->fsuid &&
+		cii->c_uid == current_fsuid() &&
 		cii->c_cached_epoch == atomic_read(&permission_epoch);
 
         return hit;
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index ce432bc..c274d94 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -52,7 +52,7 @@ static void *alloc_upcall(int opcode, int size)
         inp->ih.opcode = opcode;
 	inp->ih.pid = current->pid;
 	inp->ih.pgid = task_pgrp_nr(current);
-	inp->ih.uid = current->fsuid;
+	inp->ih.uid = current_fsuid();
 
 	return (void*)inp;
 }

