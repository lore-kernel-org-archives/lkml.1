Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbYH0N4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbYH0N4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbYH0Ntn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:49:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372AbYH0Ntk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:49:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 45/59] CRED: Wrap task credential accesses in the UDF
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Jan Kara <jack@suse.cz>
Date: Wed, 27 Aug 2008 14:49:34 +0100
Message-ID: <20080827134934.19980.69154.stgit@warthog.procyon.org.uk>
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
Cc: Jan Kara <jack@suse.cz>
---

 fs/udf/ialloc.c |    4 ++--
 fs/udf/namei.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index a4f2b3c..31fc842 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -126,13 +126,13 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	if (dir->i_mode & S_ISGID) {
 		inode->i_gid = dir->i_gid;
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else {
-		inode->i_gid = current->fsgid;
+		inode->i_gid = current_fsgid();
 	}
 
 	iinfo->i_location.logicalBlockNum = block;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 7578fae..869c982 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -605,7 +605,7 @@ static int udf_mknod(struct inode *dir, struct dentry *dentry, int mode,
 		goto out;
 
 	iinfo = UDF_I(inode);
-	inode->i_uid = current->fsuid;
+	inode->i_uid = current_fsuid();
 	init_special_inode(inode, mode, rdev);
 	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
 	if (!fi) {

