Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbYH0Nwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbYH0Nwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbYH0Nsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:48:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703AbYH0Ns2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:48:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 31/59] CRED: Wrap task credential accesses in the HPFS
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Date: Wed, 27 Aug 2008 14:48:22 +0100
Message-ID: <20080827134822.19980.47170.stgit@warthog.procyon.org.uk>
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
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
---

 fs/hpfs/namei.c |   24 ++++++++++++------------
 fs/hpfs/super.c |    4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index 10783f3..b649232 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -92,11 +92,11 @@ static int hpfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	inc_nlink(dir);
 	insert_inode_hash(result);
 
-	if (result->i_uid != current->fsuid ||
-	    result->i_gid != current->fsgid ||
+	if (result->i_uid != current_fsuid() ||
+	    result->i_gid != current_fsgid() ||
 	    result->i_mode != (mode | S_IFDIR)) {
-		result->i_uid = current->fsuid;
-		result->i_gid = current->fsgid;
+		result->i_uid = current_fsuid();
+		result->i_gid = current_fsgid();
 		result->i_mode = mode | S_IFDIR;
 		hpfs_write_inode_nolock(result);
 	}
@@ -184,11 +184,11 @@ static int hpfs_create(struct inode *dir, struct dentry *dentry, int mode, struc
 
 	insert_inode_hash(result);
 
-	if (result->i_uid != current->fsuid ||
-	    result->i_gid != current->fsgid ||
+	if (result->i_uid != current_fsuid() ||
+	    result->i_gid != current_fsgid() ||
 	    result->i_mode != (mode | S_IFREG)) {
-		result->i_uid = current->fsuid;
-		result->i_gid = current->fsgid;
+		result->i_uid = current_fsuid();
+		result->i_gid = current_fsgid();
 		result->i_mode = mode | S_IFREG;
 		hpfs_write_inode_nolock(result);
 	}
@@ -247,8 +247,8 @@ static int hpfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t
 	result->i_mtime.tv_nsec = 0;
 	result->i_atime.tv_nsec = 0;
 	hpfs_i(result)->i_ea_size = 0;
-	result->i_uid = current->fsuid;
-	result->i_gid = current->fsgid;
+	result->i_uid = current_fsuid();
+	result->i_gid = current_fsgid();
 	result->i_nlink = 1;
 	result->i_size = 0;
 	result->i_blocks = 1;
@@ -325,8 +325,8 @@ static int hpfs_symlink(struct inode *dir, struct dentry *dentry, const char *sy
 	result->i_atime.tv_nsec = 0;
 	hpfs_i(result)->i_ea_size = 0;
 	result->i_mode = S_IFLNK | 0777;
-	result->i_uid = current->fsuid;
-	result->i_gid = current->fsgid;
+	result->i_uid = current_fsuid();
+	result->i_gid = current_fsgid();
 	result->i_blocks = 1;
 	result->i_nlink = 1;
 	result->i_size = strlen(symlink);
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index b8ae9c9..5e109f9 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -475,8 +475,8 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 
 	init_MUTEX(&sbi->hpfs_creation_de);
 
-	uid = current->uid;
-	gid = current->gid;
+	uid = current_uid();
+	gid = current_gid();
 	umask = current->fs->umask;
 	lowercase = 0;
 	conv = CONV_BINARY;

