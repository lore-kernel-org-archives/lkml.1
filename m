Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbXJLJLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbXJLJLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367AbXJLJHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:07:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbXJLJHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:07:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/31] IGET: Stop autofs from using iget() and read_inode()
	[try #4]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Fri, 12 Oct 2007 10:07:44 +0100
Message-ID: <20071012090744.3442.34779.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
References: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the autofs filesystem from using iget() and read_inode().  Replace
autofs_read_inode() with autofs_iget(), and call that instead of iget().
autofs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/autofs/autofs_i.h |    1 +
 fs/autofs/inode.c    |   27 ++++++++++++++++++---------
 fs/autofs/root.c     |   22 ++++++++++++++++++----
 3 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/fs/autofs/autofs_i.h b/fs/autofs/autofs_i.h
index 8b4cca3..901a3e6 100644
--- a/fs/autofs/autofs_i.h
+++ b/fs/autofs/autofs_i.h
@@ -150,6 +150,7 @@ extern const struct file_operations autofs_root_operations;
 
 int autofs_fill_super(struct super_block *, void *, int);
 void autofs_kill_sb(struct super_block *sb);
+struct inode *autofs_iget(struct super_block *, unsigned long);
 
 /* Queue management functions */
 
diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index e7204d7..fc6a15e 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -52,10 +52,7 @@ out_kill_sb:
 	kill_anon_super(sb);
 }
 
-static void autofs_read_inode(struct inode *inode);
-
 static const struct super_operations autofs_sops = {
-	.read_inode	= autofs_read_inode,
 	.statfs		= simple_statfs,
 };
 
@@ -164,7 +161,9 @@ int autofs_fill_super(struct super_block *s, void *data, int silent)
 	s->s_time_gran = 1;
 	sbi->sb = s;
 
-	root_inode = iget(s, AUTOFS_ROOT_INO);
+	root_inode = autofs_iget(s, AUTOFS_ROOT_INO);
+	if (IS_ERR(root_inode))
+		goto fail_free;
 	root = d_alloc_root(root_inode);
 	pipe = NULL;
 
@@ -230,11 +229,17 @@ fail_unlock:
 	return -EINVAL;
 }
 
-static void autofs_read_inode(struct inode *inode)
+struct inode *autofs_iget(struct super_block *sb, unsigned long ino)
 {
-	ino_t ino = inode->i_ino;
 	unsigned int n;
-	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(sb);
+	struct inode *inode;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	/* Initialize to the default case (stub directory) */
 
@@ -250,7 +255,7 @@ static void autofs_read_inode(struct inode *inode)
 		inode->i_op = &autofs_root_inode_operations;
 		inode->i_fop = &autofs_root_operations;
 		inode->i_uid = inode->i_gid = 0; /* Changed in read_super */
-		return;
+		goto done;
 	} 
 	
 	inode->i_uid = inode->i_sb->s_root->d_inode->i_uid;
@@ -263,7 +268,7 @@ static void autofs_read_inode(struct inode *inode)
 		n = ino - AUTOFS_FIRST_SYMLINK;
 		if (n >= AUTOFS_MAX_SYMLINKS || !test_bit(n,sbi->symlink_bitmap)) {
 			printk("autofs: Looking for bad symlink inode %u\n", (unsigned int) ino);
-			return;
+			goto done;
 		}
 		
 		inode->i_op = &autofs_symlink_inode_operations;
@@ -275,4 +280,8 @@ static void autofs_read_inode(struct inode *inode)
 		inode->i_size = sl->len;
 		inode->i_nlink = 1;
 	}
+
+done:
+	unlock_new_inode(inode);
+	return inode;
 }
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index c148953..3aec567 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -114,8 +114,8 @@ static int try_to_fill_dentry(struct dentry *dentry, struct super_block *sb, str
 	dentry->d_time = (unsigned long) ent;
 	
 	if (!dentry->d_inode) {
-		inode = iget(sb, ent->ino);
-		if (!inode) {
+		inode = autofs_iget(sb, ent->ino);
+		if (IS_ERR(inode)) {
 			/* Failed, but leave pending for next time */
 			return 1;
 		}
@@ -274,6 +274,7 @@ static int autofs_root_symlink(struct inode *dir, struct dentry *dentry, const c
 	unsigned int n;
 	int slsize;
 	struct autofs_symlink *sl;
+	struct inode *inode;
 
 	DPRINTK(("autofs_root_symlink: %s <- ", symname));
 	autofs_say(dentry->d_name.name,dentry->d_name.len);
@@ -331,7 +332,12 @@ static int autofs_root_symlink(struct inode *dir, struct dentry *dentry, const c
 	ent->dentry = NULL;	/* We don't keep the dentry for symlinks */
 
 	autofs_hash_insert(dh,ent);
-	d_instantiate(dentry, iget(dir->i_sb,ent->ino));
+
+	inode = autofs_iget(dir->i_sb, ent->ino);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	d_instantiate(dentry, inode);
 	unlock_kernel();
 	return 0;
 }
@@ -428,6 +434,7 @@ static int autofs_root_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
 	struct autofs_dirhash *dh = &sbi->dirhash;
 	struct autofs_dir_ent *ent;
+	struct inode *inode;
 	ino_t ino;
 
 	lock_kernel();
@@ -469,7 +476,14 @@ static int autofs_root_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	autofs_hash_insert(dh,ent);
 
 	inc_nlink(dir);
-	d_instantiate(dentry, iget(dir->i_sb,ino));
+
+	inode = autofs_iget(dir->i_sb, ino);
+	if (IS_ERR(inode)) {
+		drop_nlink(dir);
+		return PTR_ERR(inode);
+	}
+
+	d_instantiate(dentry, inode);
 	unlock_kernel();
 
 	return 0;

