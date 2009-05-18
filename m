Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZERQKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZERQKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZERQJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:09:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:41555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137AbZERQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:37 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 30/32] union mount: ext2 fallthru support
Date: Mon, 18 May 2009 18:09:26 +0200
Message-Id: <1242662968-11684-31-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora (Henson) <vaurora@redhat.com>

Add support for fallthru directory entries to ext2.

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext2/dir.c           |   86 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/ext2/ext2.h          |    1 +
 fs/ext2/namei.c         |   20 +++++++++++
 include/linux/ext2_fs.h |    1 +
 4 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 5b499ad..b9380fe 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -219,7 +219,8 @@ static inline int ext2_match (int len, const char * const name,
 {
 	if (len != de->name_len)
 		return 0;
-	if (!de->inode && (de->file_type != EXT2_FT_WHT))
+	if (!de->inode && ((de->file_type != EXT2_FT_WHT) &&
+			   (de->file_type != EXT2_FT_FALLTHRU)))
 		return 0;
 	return !memcmp(name, de->name, len);
 }
@@ -256,6 +257,7 @@ static unsigned char ext2_filetype_table[EXT2_FT_MAX] = {
 	[EXT2_FT_SOCK]		= DT_SOCK,
 	[EXT2_FT_SYMLINK]	= DT_LNK,
 	[EXT2_FT_WHT]		= DT_WHT,
+	[EXT2_FT_FALLTHRU]	= DT_UNKNOWN,
 };
 
 #define S_SHIFT 12
@@ -342,6 +344,18 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 					ext2_put_page(page);
 					return 0;
 				}
+			} else if (de->file_type == EXT2_FT_FALLTHRU) {
+				int over;
+				unsigned char d_type = DT_UNKNOWN;
+
+				offset = (char *)de - kaddr;
+				over = filldir(dirent, de->name, de->name_len,
+						(n<<PAGE_CACHE_SHIFT) | offset,
+						123, d_type);
+				if (over) {
+					ext2_put_page(page);
+					return 0;
+				}
 			}
 			filp->f_pos += ext2_rec_len_from_disk(de->rec_len);
 		}
@@ -463,6 +477,10 @@ ino_t ext2_inode_by_dentry(struct inode *dir, struct dentry *dentry)
 			spin_lock(&dentry->d_lock);
 			dentry->d_flags |= DCACHE_WHITEOUT;
 			spin_unlock(&dentry->d_lock);
+		} else if(!res && de->file_type == EXT2_FT_FALLTHRU) {
+			spin_lock(&dentry->d_lock);
+			dentry->d_flags |= DCACHE_FALLTHRU;
+			spin_unlock(&dentry->d_lock);
 		}
 		ext2_put_page(page);
 	}
@@ -531,6 +549,7 @@ static ext2_dirent * ext2_append_entry(struct dentry * dentry,
 				de->name_len = 0;
 				de->rec_len = ext2_rec_len_to_disk(chunk_size);
 				de->inode = 0;
+				de->file_type = 0;
 				goto got_it;
 			}
 			if (de->rec_len == 0) {
@@ -544,6 +563,7 @@ static ext2_dirent * ext2_append_entry(struct dentry * dentry,
 			name_len = EXT2_DIR_REC_LEN(de->name_len);
 			rec_len = ext2_rec_len_from_disk(de->rec_len);
 			if (!de->inode && (de->file_type != EXT2_FT_WHT) &&
+			    (de->file_type != EXT2_FT_FALLTHRU) &&
 			    (rec_len >= reclen))
 				goto got_it;
 			if (rec_len >= name_len + reclen)
@@ -586,7 +606,8 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 
 	err = -EEXIST;
 	if (ext2_match (namelen, name, de)) {
-		if (de->file_type == EXT2_FT_WHT)
+		if ((de->file_type == EXT2_FT_WHT) ||
+		    (de->file_type == EXT2_FT_FALLTHRU))
 			goto got_it;
 		goto out_unlock;
 	}
@@ -601,7 +622,8 @@ got_it:
 							&page, NULL);
 	if (err)
 		goto out_unlock;
-	if (de->inode || ((de->file_type == EXT2_FT_WHT) &&
+	if (de->inode || (((de->file_type == EXT2_FT_WHT) ||
+			   (de->file_type == EXT2_FT_FALLTHRU)) &&
 			  !ext2_match (namelen, name, de))) {
 		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
 		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
@@ -626,6 +648,60 @@ out_unlock:
 }
 
 /*
+ * Create a fallthru entry.
+ */
+int ext2_fallthru_entry (struct inode *dir, struct dentry *dentry)
+{
+	const char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	unsigned short rec_len, name_len;
+	ext2_dirent * de;
+	struct page *page;
+	loff_t pos;
+	int err;
+
+	de = ext2_append_entry(dentry, &page);
+	if (IS_ERR(de))
+		return PTR_ERR(de);
+
+	err = -EEXIST;
+	if (ext2_match (namelen, name, de))
+		goto out_unlock;
+
+	name_len = EXT2_DIR_REC_LEN(de->name_len);
+	rec_len = ext2_rec_len_from_disk(de->rec_len);
+
+	pos = page_offset(page) +
+		(char*)de - (char*)page_address(page);
+	err = __ext2_write_begin(NULL, page->mapping, pos, rec_len, 0,
+							&page, NULL);
+	if (err)
+		goto out_unlock;
+	if (de->inode || (de->file_type == EXT2_FT_WHT) ||
+	    (de->file_type == EXT2_FT_FALLTHRU)) {
+		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
+		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
+		de->rec_len = ext2_rec_len_to_disk(name_len);
+		de = de1;
+	}
+	de->name_len = namelen;
+	memcpy(de->name, name, namelen);
+	de->inode = 0;
+	de->file_type = EXT2_FT_FALLTHRU;
+	err = ext2_commit_chunk(page, pos, rec_len);
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
+	EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;
+	mark_inode_dirty(dir);
+	/* OFFSET_CACHE */
+out_put:
+	ext2_put_page(page);
+	return err;
+out_unlock:
+	unlock_page(page);
+	goto out_put;
+}
+
+/*
  * ext2_delete_entry deletes a directory entry by merging it with the
  * previous entry. Page is up-to-date. Releases the page.
  */
@@ -710,7 +786,9 @@ int ext2_whiteout_entry (struct inode * dir, struct dentry * dentry,
 	 */
 	if (ext2_match (namelen, name, de))
 		de->inode = 0;
-	if (de->inode || (de->file_type == EXT2_FT_WHT)) {
+	if (de->inode || (((de->file_type == EXT2_FT_WHT) ||
+			   (de->file_type == EXT2_FT_FALLTHRU)) &&
+			  !ext2_match (namelen, name, de))) {
 		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
 		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
 		de->rec_len = ext2_rec_len_to_disk(name_len);
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index ec9a0bd..363b0fa 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -112,6 +112,7 @@ extern struct ext2_dir_entry_2 * ext2_find_entry (struct inode *,struct qstr *,
 extern int ext2_delete_entry (struct ext2_dir_entry_2 *, struct page *);
 extern int ext2_whiteout_entry (struct inode *, struct dentry *,
 				struct ext2_dir_entry_2 *, struct page *);
+extern int ext2_fallthru_entry (struct inode *, struct dentry *);
 extern int ext2_empty_dir (struct inode *);
 extern struct ext2_dir_entry_2 * ext2_dotdot (struct inode *, struct page **);
 extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page *, struct inode *);
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 58107ff..5bdf990 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -325,6 +325,7 @@ static int ext2_whiteout(struct inode *dir, struct dentry *dentry,
 		goto out;
 
 	spin_lock(&new_dentry->d_lock);
+	new_dentry->d_flags &= ~DCACHE_FALLTHRU;
 	new_dentry->d_flags |= DCACHE_WHITEOUT;
 	spin_unlock(&new_dentry->d_lock);
 	d_add(new_dentry, NULL);
@@ -343,6 +344,24 @@ out:
 	return err;
 }
 
+/*
+ * Create a fallthru entry.
+ */
+static int ext2_fallthru (struct inode *dir, struct dentry *dentry)
+{
+	int err;
+
+	err = ext2_fallthru_entry(dir, dentry);
+	if (err)
+		return err;
+
+	d_instantiate(dentry, NULL);
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= DCACHE_FALLTHRU;
+	spin_unlock(&dentry->d_lock);
+	return 0;
+}
+
 static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	struct inode * new_dir,	struct dentry * new_dentry )
 {
@@ -438,6 +457,7 @@ const struct inode_operations ext2_dir_inode_operations = {
 	.rmdir		= ext2_rmdir,
 	.mknod		= ext2_mknod,
 	.whiteout	= ext2_whiteout,
+	.fallthru	= ext2_fallthru,
 	.rename		= ext2_rename,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.setxattr	= generic_setxattr,
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index bd10826..f6b68ec 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -577,6 +577,7 @@ enum {
 	EXT2_FT_SOCK,
 	EXT2_FT_SYMLINK,
 	EXT2_FT_WHT,
+	EXT2_FT_FALLTHRU,
 	EXT2_FT_MAX
 };
 
-- 
1.6.1.3

