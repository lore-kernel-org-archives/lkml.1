Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbYH0ODU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbYH0ODU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbYH0Nv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:51:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757923AbYH0Nvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:51:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 47/59] CRED: Wrap task credential accesses in the XFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, xfs@oss.sgi.com
Date: Wed, 27 Aug 2008 14:49:44 +0100
Message-ID: <20080827134944.19980.51300.stgit@warthog.procyon.org.uk>
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
Cc: xfs@oss.sgi.com
---

 fs/xfs/linux-2.6/xfs_cred.h |    2 +-
 fs/xfs/xfs_acl.c            |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/linux-2.6/xfs_cred.h b/fs/xfs/linux-2.6/xfs_cred.h
index 652721c..293043a 100644
--- a/fs/xfs/linux-2.6/xfs_cred.h
+++ b/fs/xfs/linux-2.6/xfs_cred.h
@@ -24,7 +24,7 @@
  * Credentials
  */
 typedef struct cred {
-	/* EMPTY */
+       /* EMPTY */
 } cred_t;
 
 extern struct cred *sys_cred;
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index b2f639a..91d6933 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -366,7 +366,7 @@ xfs_acl_allow_set(
 		return ENOTDIR;
 	if (vp->i_sb->s_flags & MS_RDONLY)
 		return EROFS;
-	if (XFS_I(vp)->i_d.di_uid != current->fsuid && !capable(CAP_FOWNER))
+	if (XFS_I(vp)->i_d.di_uid != current_fsuid() && !capable(CAP_FOWNER))
 		return EPERM;
 	return 0;
 }
@@ -413,13 +413,13 @@ xfs_acl_access(
 		switch (fap->acl_entry[i].ae_tag) {
 		case ACL_USER_OBJ:
 			seen_userobj = 1;
-			if (fuid != current->fsuid)
+			if (fuid != current_fsuid())
 				continue;
 			matched.ae_tag = ACL_USER_OBJ;
 			matched.ae_perm = allows;
 			break;
 		case ACL_USER:
-			if (fap->acl_entry[i].ae_id != current->fsuid)
+			if (fap->acl_entry[i].ae_id != current_fsuid())
 				continue;
 			matched.ae_tag = ACL_USER;
 			matched.ae_perm = allows;

