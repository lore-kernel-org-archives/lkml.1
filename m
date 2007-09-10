Return-Path: <linux-kernel-owner+w=401wt.eu-S965604AbXIJWmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965604AbXIJWmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760108AbXIJWl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:41:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759089AbXIJWl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:41:58 -0400
Message-ID: <46E5C82C.907@redhat.com>
Date: Mon, 10 Sep 2007 17:41:48 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Duane Griffin <duaneg@dghda.com>
CC: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext4 development <linux-ext4@vger.kernel.org>
Subject: [PATCH V2] dir_index: error out instead of BUG on corrupt dx dirs
References: <46D8D30B.6090703@redhat.com>	 <20070909131933.GA15229@dastardly.plus.com>	 <46E55BD0.30500@redhat.com> <e9e943910709101506p555c6c0co8ce4529f90e814e8@mail.gmail.com>
In-Reply-To: <e9e943910709101506p555c6c0co8ce4529f90e814e8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Duane Griffin wrote:

> "Corrupt root limit in dir inode %ld, running e2fsck is recommended\n"
>
>   
Probably good, for anything that was read from disk, certainly.

I don't know if it's worth differentiating messages for different types
of corruption (root block vs. others, etc...) - I guess the other error
cases do.

Maybe it'd be best to just consolidate the fsck suggestion message under 
fail: ?

Here's a patch rolling up yours with mine + discussed changes, and 
consolidating the fsck suggestion message.

How's it look to you?  Suppose I'd better run this a bit to be sure it's
not hitting any common cases and issuing new warnings...?

ThAnks!
-Eric

---------------------------------

Convert asserts (BUGs) in dx_probe from bad on-disk data to recoverable 
errors with helpful warnings.  With help catching other asserts
from Duane Griffin <duaneg@dghda.com>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.22-rc4/fs/ext3/namei.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext3/namei.c
+++ linux-2.6.22-rc4/fs/ext3/namei.c
@@ -379,13 +379,28 @@ dx_probe(struct dentry *dentry, struct i
 
 	entries = (struct dx_entry *) (((char *)&root->info) +
 				       root->info.info_length);
-	assert(dx_get_limit(entries) == dx_root_limit(dir,
-						      root->info.info_length));
+
+	if (dx_get_limit(entries) != dx_root_limit(dir,
+						   root->info.info_length)) {
+		ext3_warning(dir->i_sb, __FUNCTION__,
+			     "dx entry: limit != root limit\n");
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
+				     "dx entry: no count or count > limit\n");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
+
 		p = entries + 1;
 		q = entries + count - 1;
 		while (p <= q)
@@ -423,8 +438,15 @@ dx_probe(struct dentry *dentry, struct i
 		if (!(bh = ext3_bread (NULL,dir, dx_get_block(at), 0, err)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
-		assert (dx_get_limit(entries) == dx_node_limit (dir));
+		if (dx_get_limit(entries) != dx_node_limit (dir)) {
+			ext3_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: limit != node limit\n");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
 		frame++;
+		frame->bh = NULL;
 	}
 fail2:
 	while (frame >= frame_in) {
@@ -432,6 +454,10 @@ fail2:
 		frame--;
 	}
 fail:
+	if (*err == ERR_BAD_DX_DIR)
+		ext3_warning(dir->i_sb, __FUNCTION__,
+			     "Corrupt dir inode %ld, running e2fsck is "
+			     "recommended.\n", dir->i_ino);
 	return NULL;
 }
 
Index: linux-2.6.22-rc4/fs/ext4/namei.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/namei.c
+++ linux-2.6.22-rc4/fs/ext4/namei.c
@@ -379,13 +379,28 @@ dx_probe(struct dentry *dentry, struct i
 
 	entries = (struct dx_entry *) (((char *)&root->info) +
 				       root->info.info_length);
-	assert(dx_get_limit(entries) == dx_root_limit(dir,
-						      root->info.info_length));
+
+	if (dx_get_limit(entries) != dx_root_limit(dir,
+						   root->info.info_length)) {
+		ext4_warning(dir->i_sb, __FUNCTION__,
+			     "dx entry: limit != root limit\n");
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
+				     "dx entry: no count or count > limit\n");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
+
 		p = entries + 1;
 		q = entries + count - 1;
 		while (p <= q)
@@ -423,8 +438,15 @@ dx_probe(struct dentry *dentry, struct i
 		if (!(bh = ext4_bread (NULL,dir, dx_get_block(at), 0, err)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
-		assert (dx_get_limit(entries) == dx_node_limit (dir));
+		if (dx_get_limit(entries) != dx_node_limit (dir)) {
+			ext4_warning(dir->i_sb, __FUNCTION__,
+				     "dx entry: limit != node limit\n");
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
 		frame++;
+		frame->bh = NULL;
 	}
 fail2:
 	while (frame >= frame_in) {
@@ -432,6 +454,10 @@ fail2:
 		frame--;
 	}
 fail:
+	if (*err == ERR_BAD_DX_DIR)
+		ext4_warning(dir->i_sb, __FUNCTION__,
+			     "Corrupt dir inode %ld, running e2fsck is "
+			     "recommended.\n", dir->i_ino);
 	return NULL;
 }
 


