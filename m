Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbYH0N5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbYH0N5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbYH0NuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:50:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476AbYH0NuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:50:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 37/59] CRED: Wrap task credential accesses in the NFS daemon
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>,
       "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       linux-nfs@vger.kernel.org
Date: Wed, 27 Aug 2008 14:48:53 +0100
Message-ID: <20080827134853.19980.45910.stgit@warthog.procyon.org.uk>
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
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: linux-nfs@vger.kernel.org
---

 fs/nfsd/vfs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index e3e37f7..34d2ade 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1165,7 +1165,7 @@ nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
 	 * send along the gid on create when it tries to implement
 	 * setgid directories via NFS:
 	 */
-	if (current->fsuid != 0)
+	if (current_fsuid() != 0)
 		iap->ia_valid &= ~(ATTR_UID|ATTR_GID);
 	if (iap->ia_valid)
 		return nfsd_setattr(rqstp, resfhp, iap, 0, (time_t)0);
@@ -1998,7 +1998,7 @@ nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
 		IS_APPEND(inode)?	" append" : "",
 		__mnt_is_readonly(exp->ex_path.mnt)?	" ro" : "");
 	dprintk("      owner %d/%d user %d/%d\n",
-		inode->i_uid, inode->i_gid, current->fsuid, current->fsgid);
+		inode->i_uid, inode->i_gid, current_fsuid(), current_fsgid());
 #endif
 
 	/* Normally we reject any write/sattr etc access on a read-only file
@@ -2041,7 +2041,7 @@ nfsd_permission(struct svc_rqst *rqstp, struct svc_export *exp,
 	 * with NFSv3.
 	 */
 	if ((acc & NFSD_MAY_OWNER_OVERRIDE) &&
-	    inode->i_uid == current->fsuid)
+	    inode->i_uid == current_fsuid())
 		return 0;
 
 	/* This assumes  NFSD_MAY_{READ,WRITE,EXEC} == MAY_{READ,WRITE,EXEC} */

