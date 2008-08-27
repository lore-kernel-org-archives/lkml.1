Return-Path: <linux-kernel-owner+w=401wt.eu-S1760323AbYH0OCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760323AbYH0OCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbYH0Nvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:51:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855AbYH0Nvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:51:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/59] CRED: Wrap task credential accesses in the AFFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>
Date: Wed, 27 Aug 2008 14:46:59 +0100
Message-ID: <20080827134659.19980.11867.stgit@warthog.procyon.org.uk>
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

 fs/affs/inode.c |    4 ++--
 fs/affs/super.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index a13b334..415d9c6 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -293,8 +293,8 @@ affs_new_inode(struct inode *dir)
 	mark_buffer_dirty_inode(bh, inode);
 	affs_brelse(bh);
 
-	inode->i_uid     = current->fsuid;
-	inode->i_gid     = current->fsgid;
+	inode->i_uid     = current_fsuid();
+	inode->i_gid     = current_fsgid();
 	inode->i_ino     = block;
 	inode->i_nlink   = 1;
 	inode->i_mtime   = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 3a89094..d5d9b10 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -163,8 +163,8 @@ parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *reserved, s
 
 	/* Fill in defaults */
 
-	*uid        = current->uid;
-	*gid        = current->gid;
+	*uid        = current_uid();
+	*gid        = current_gid();
 	*reserved   = 2;
 	*root       = -1;
 	*blocksize  = -1;

