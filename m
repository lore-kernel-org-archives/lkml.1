Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbYH0OE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbYH0OE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756447AbYH0NwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:52:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbYH0NwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:52:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 39/59] CRED: Wrap task credential accesses in the OMFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Bob Copeland <me@bobcopeland.com>,
       linux-karma-devel@lists.sourceforge.net
Date: Wed, 27 Aug 2008 14:49:03 +0100
Message-ID: <20080827134903.19980.60358.stgit@warthog.procyon.org.uk>
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
Cc: Bob Copeland <me@bobcopeland.com>
Cc: linux-karma-devel@lists.sourceforge.net
---

 fs/omfs/inode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index d29047b..f96cddf 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -37,8 +37,8 @@ struct inode *omfs_new_inode(struct inode *dir, int mode)
 
 	inode->i_ino = new_block;
 	inode->i_mode = mode;
-	inode->i_uid = current->fsuid;
-	inode->i_gid = current->fsgid;
+	inode->i_uid = current_fsuid();
+	inode->i_gid = current_fsgid();
 	inode->i_blocks = 0;
 	inode->i_mapping->a_ops = &omfs_aops;
 
@@ -420,8 +420,8 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_fs_info = sbi;
 
-	sbi->s_uid = current->uid;
-	sbi->s_gid = current->gid;
+	sbi->s_uid = current_uid();
+	sbi->s_gid = current_gid();
 	sbi->s_dmask = sbi->s_fmask = current->fs->umask;
 
 	if (!parse_options((char *) data, sbi))

