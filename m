Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbYH0OFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbYH0OFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbYH0Nx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:53:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758278AbYH0Nx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:53:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 28/59] CRED: Wrap task credential accesses in the GFS2
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Date: Wed, 27 Aug 2008 14:48:06 +0100
Message-ID: <20080827134806.19980.24651.stgit@warthog.procyon.org.uk>
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
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
---

 fs/gfs2/inode.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 8b0806a..c1c36f3 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -701,18 +701,18 @@ static void munge_mode_uid_gid(struct gfs2_inode *dip, unsigned int *mode,
 	    (dip->i_inode.i_mode & S_ISUID) && dip->i_inode.i_uid) {
 		if (S_ISDIR(*mode))
 			*mode |= S_ISUID;
-		else if (dip->i_inode.i_uid != current->fsuid)
+		else if (dip->i_inode.i_uid != current_fsuid())
 			*mode &= ~07111;
 		*uid = dip->i_inode.i_uid;
 	} else
-		*uid = current->fsuid;
+		*uid = current_fsuid();
 
 	if (dip->i_inode.i_mode & S_ISGID) {
 		if (S_ISDIR(*mode))
 			*mode |= S_ISGID;
 		*gid = dip->i_inode.i_gid;
 	} else
-		*gid = current->fsgid;
+		*gid = current_fsgid();
 }
 
 static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
@@ -1122,8 +1122,8 @@ int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 		return -EPERM;
 
 	if ((dip->i_inode.i_mode & S_ISVTX) &&
-	    dip->i_inode.i_uid != current->fsuid &&
-	    ip->i_inode.i_uid != current->fsuid && !capable(CAP_FOWNER))
+	    dip->i_inode.i_uid != current_fsuid() &&
+	    ip->i_inode.i_uid != current_fsuid() && !capable(CAP_FOWNER))
 		return -EPERM;
 
 	if (IS_APPEND(&dip->i_inode))

