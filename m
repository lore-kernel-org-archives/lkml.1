Return-Path: <linux-kernel-owner+w=401wt.eu-S1762166AbXIXQfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762166AbXIXQfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760395AbXIXQ0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:26:50 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47541 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760726AbXIXQ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:26:48 -0400
Date: Mon, 24 Sep 2007 09:21:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, sandeen@redhat.com, duaneg@dghda.com
Subject: [29/50] dir_index: error out instead of BUG on corrupt dx dirs
Message-ID: <20070924162139.GD13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Eric Sandeen <sandeen@redhat.com>

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

--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
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
 
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
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
