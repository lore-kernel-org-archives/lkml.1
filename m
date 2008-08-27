Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYH0Nvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYH0Nvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbYH0NsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:48:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629AbYH0NsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:48:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/59] CRED: Wrap task credential accesses in the HFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>
Date: Wed, 27 Aug 2008 14:48:11 +0100
Message-ID: <20080827134811.19980.68525.stgit@warthog.procyon.org.uk>
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
Cc: Roman Zippel <zippel@linux-m68k.org>
---

 fs/hfs/inode.c |    4 ++--
 fs/hfs/super.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 7e19835..d668267 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -155,8 +155,8 @@ struct inode *hfs_new_inode(struct inode *dir, struct qstr *name, int mode)
 	hfs_cat_build_key(sb, (btree_key *)&HFS_I(inode)->cat_key, dir->i_ino, name);
 	inode->i_ino = HFS_SB(sb)->next_id++;
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 	inode->i_nlink = 1;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	HFS_I(inode)->flags = 0;
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 4abb104..2d5df7d 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -210,8 +210,8 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
 	int tmp, token;
 
 	/* initialize the sb with defaults */
-	hsb->s_uid = current->uid;
-	hsb->s_gid = current->gid;
+	hsb->s_uid = current_uid();
+	hsb->s_gid = current_gid();
 	hsb->s_file_umask = 0133;
 	hsb->s_dir_umask = 0022;
 	hsb->s_type = hsb->s_creator = cpu_to_be32(0x3f3f3f3f);	/* == '????' */

