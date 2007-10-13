Return-Path: <linux-kernel-owner+w=401wt.eu-S1763104AbXJMOu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763104AbXJMOu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761145AbXJMOmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:46 -0400
Received: from 1wt.eu ([62.212.114.60]:3011 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762007AbXJMOmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:44 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143506.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:48 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, Duane Griffin <duaneg@dghda.com>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 26/35] dir_index: error out instead of BUG on corrupt dx dirs
Content-Disposition: inline; filename=0082-dir_index-error-out-instead-of-BUG-on-corrupt-dx-di.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3d82abae9523c33d4a16fdfdfd2bdde316d7b56a in mainline.

Convert asserts (BUGs) in dx_probe from bad on-disk data to recoverable
errors with helpful warnings.  With help catching other asserts from Duane
Griffin <duaneg@dghda.com>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext3/namei.c |   34 ++++++++++++++++++++++++++++++----
 fs/ext4/namei.c |   34 ++++++++++++++++++++++++++++++----
 2 files changed, 60 insertions(+), 8 deletions(-)

Index: 2.6/fs/ext3/namei.c
===================================================================
--- 2.6.orig/fs/ext3/namei.c
+++ 2.6/fs/ext3/namei.c
@@ -380,13 +380,28 @@ dx_probe(struct dentry *dentry, struct i
 
 	entries = (struct dx_entry *) (((char *)&root->info) +
 				       root->info.info_length);
-	assert(dx_get_limit(entries) == dx_root_limit(dir,
-						      root->info.info_length));
+
+	if (dx_get_limit(entries) != dx_root_limit(dir,
+						   root->info.info_length)) {
+		ext3_warning(dir->i_sb, __FUNCTION__,
+			     "dx entry: limit != root limit");
+		brelse(bh);
+		*err = ERR_BAD_DX_DIR;
+		goto fail;
+	}
+
 	dxtrace (printk("Look up %x", hash));
 	while (1)
 	{
 		count = dx_get_count(entries);
-		assert (count && count <= dx_get_limit(entries));
+		if (!count || count > dx_get_limit(entries)) {
+			ext3_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: no count or count > limit");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
+
 		p = entries + 1;
 		q = entries + count - 1;
 		while (p <= q)
@@ -424,8 +439,15 @@ dx_probe(struct dentry *dentry, struct i
 		if (!(bh = ext3_bread (NULL,dir, dx_get_block(at), 0, err)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
-		assert (dx_get_limit(entries) == dx_node_limit (dir));
+		if (dx_get_limit(entries) != dx_node_limit (dir)) {
+			ext3_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: limit != node limit");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
 		frame++;
+		frame->bh = NULL;
 	}
 fail2:
 	while (frame >= frame_in) {
@@ -433,6 +455,10 @@ fail2:
 		frame--;
 	}
 fail:
+	if (*err == ERR_BAD_DX_DIR)
+		ext3_warning(dir->i_sb, __FUNCTION__,
+			     "Corrupt dir inode %ld, running e2fsck is "
+			     "recommended.", dir->i_ino);
 	return NULL;
 }
 
Index: 2.6/fs/ext4/namei.c
===================================================================
--- 2.6.orig/fs/ext4/namei.c
+++ 2.6/fs/ext4/namei.c
@@ -380,13 +380,28 @@ dx_probe(struct dentry *dentry, struct i
 
 	entries = (struct dx_entry *) (((char *)&root->info) +
 				       root->info.info_length);
-	assert(dx_get_limit(entries) == dx_root_limit(dir,
-						      root->info.info_length));
+
+	if (dx_get_limit(entries) != dx_root_limit(dir,
+						   root->info.info_length)) {
+		ext4_warning(dir->i_sb, __FUNCTION__,
+			     "dx entry: limit != root limit");
+		brelse(bh);
+		*err = ERR_BAD_DX_DIR;
+		goto fail;
+	}
+
 	dxtrace (printk("Look up %x", hash));
 	while (1)
 	{
 		count = dx_get_count(entries);
-		assert (count && count <= dx_get_limit(entries));
+		if (!count || count > dx_get_limit(entries)) {
+			ext4_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: no count or count > limit");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
+
 		p = entries + 1;
 		q = entries + count - 1;
 		while (p <= q)
@@ -424,8 +439,15 @@ dx_probe(struct dentry *dentry, struct i
 		if (!(bh = ext4_bread (NULL,dir, dx_get_block(at), 0, err)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
-		assert (dx_get_limit(entries) == dx_node_limit (dir));
+		if (dx_get_limit(entries) != dx_node_limit (dir)) {
+			ext4_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: limit != node limit");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
 		frame++;
+		frame->bh = NULL;
 	}
 fail2:
 	while (frame >= frame_in) {
@@ -433,6 +455,10 @@ fail2:
 		frame--;
 	}
 fail:
+	if (*err == ERR_BAD_DX_DIR)
+		ext4_warning(dir->i_sb, __FUNCTION__,
+			     "Corrupt dir inode %ld, running e2fsck is "
+			     "recommended.", dir->i_ino);
 	return NULL;
 }
 

-- 
