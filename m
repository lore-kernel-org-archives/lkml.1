Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbYH0Ntk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbYH0Ntk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbYH0Nrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:47:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbYH0Nrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:47:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/59] CRED: Wrap task credential accesses in 9P2000 filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
       v9fs-developer@lists.sourceforge.net
Date: Wed, 27 Aug 2008 14:46:54 +0100
Message-ID: <20080827134654.19980.45849.stgit@warthog.procyon.org.uk>
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
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: v9fs-developer@lists.sourceforge.net
---

 fs/9p/fid.c       |    2 +-
 fs/9p/vfs_inode.c |    4 ++--
 fs/9p/vfs_super.c |    4 ++--
 net/9p/client.c   |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 3031e32..a43e4ab 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -120,7 +120,7 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 	switch (access) {
 	case V9FS_ACCESS_SINGLE:
 	case V9FS_ACCESS_USER:
-		uid = current->fsuid;
+		uid = current_fsuid();
 		any = 0;
 		break;
 
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index c95295c..517dd27 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -215,8 +215,8 @@ struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 	inode = new_inode(sb);
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current_fsuid();
+		inode->i_gid = current_fsgid();
 		inode->i_blocks = 0;
 		inode->i_rdev = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index bf59c39..f59ffcd 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -113,8 +113,8 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 	struct v9fs_session_info *v9ses = NULL;
 	struct p9_stat *st = NULL;
 	int mode = S_IRWXUGO | S_ISVTX;
-	uid_t uid = current->fsuid;
-	gid_t gid = current->fsgid;
+	uid_t uid = current_fsuid();
+	gid_t gid = current_fsgid();
 	struct p9_fid *fid;
 	int retval = 0;
 
diff --git a/net/9p/client.c b/net/9p/client.c
index 2ffe40c..a5dfc17 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1049,7 +1049,7 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
 	fid->rdir_fpos = 0;
 	fid->rdir_pos = 0;
 	fid->rdir_fcall = NULL;
-	fid->uid = current->fsuid;
+	fid->uid = current_fsuid();
 	fid->clnt = clnt;
 	fid->aux = NULL;
 

