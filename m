Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZJ2KQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZJ2KQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 06:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZJ2KQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 06:16:27 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:44354 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbZJ2KQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 06:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=i+paxSJhnWLu3F7dmOHAeOi7GbBdgfiMuSYPbg9hO+dykIoilGYX6Z7OIttlb2MCUt
         DuLdWhEJAmHlW4hnQR/QfAL68TdsId4bTr4ggKdEWtVdctvBsOi2imY6KUR5+mmG1cuL
         ObrSxtfnYVzv44zTjflbD7pi/cz6+szL5dA2g=
Date: Thu, 29 Oct 2009 13:16:29 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: dushistov@mail.ru, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] ufs: pass qstr instead of dentry where necessary for
 NFS
Message-ID: <20091029101629.GA27166@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/ufs/dir.c   |   10 +++++-----
 fs/ufs/namei.c |    8 ++++----
 fs/ufs/ufs.h   |    4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -70,13 +70,13 @@ static inline unsigned long ufs_dir_pages(struct inode *inode)
 	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
 }
 
-ino_t ufs_inode_by_name(struct inode *dir, struct dentry *dentry)
+ino_t ufs_inode_by_name(struct inode *dir, struct qstr *qstr)
 {
 	ino_t res = 0;
 	struct ufs_dir_entry *de;
 	struct page *page;
 	
-	de = ufs_find_entry(dir, dentry, &page);
+	de = ufs_find_entry(dir, qstr, &page);
 	if (de) {
 		res = fs32_to_cpu(dir->i_sb, de->d_ino);
 		ufs_put_page(page);
@@ -249,12 +249,12 @@ struct ufs_dir_entry *ufs_dotdot(struct inode *dir, struct page **p)
  * (as a parameter - res_dir). Page is returned mapped and unlocked.
  * Entry is guaranteed to be valid.
  */
-struct ufs_dir_entry *ufs_find_entry(struct inode *dir, struct dentry *dentry,
+struct ufs_dir_entry *ufs_find_entry(struct inode *dir, struct qstr *qstr,
 				     struct page **res_page)
 {
 	struct super_block *sb = dir->i_sb;
-	const char *name = dentry->d_name.name;
-	int namelen = dentry->d_name.len;
+	const char *name = qstr->name;
+	int namelen = qstr->len;
 	unsigned reclen = UFS_DIR_REC_LEN(namelen);
 	unsigned long start, n;
 	unsigned long npages = ufs_dir_pages(dir);
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -56,7 +56,7 @@ static struct dentry *ufs_lookup(struct inode * dir, struct dentry *dentry, stru
 		return ERR_PTR(-ENAMETOOLONG);
 
 	lock_kernel();
-	ino = ufs_inode_by_name(dir, dentry);
+	ino = ufs_inode_by_name(dir, &dentry->d_name);
 	if (ino) {
 		inode = ufs_iget(dir->i_sb, ino);
 		if (IS_ERR(inode)) {
@@ -237,7 +237,7 @@ static int ufs_unlink(struct inode *dir, struct dentry *dentry)
 	struct page *page;
 	int err = -ENOENT;
 
-	de = ufs_find_entry(dir, dentry, &page);
+	de = ufs_find_entry(dir, &dentry->d_name, &page);
 	if (!de)
 		goto out;
 
@@ -281,7 +281,7 @@ static int ufs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ufs_dir_entry *old_de;
 	int err = -ENOENT;
 
-	old_de = ufs_find_entry(old_dir, old_dentry, &old_page);
+	old_de = ufs_find_entry(old_dir, &old_dentry->d_name, &old_page);
 	if (!old_de)
 		goto out;
 
@@ -301,7 +301,7 @@ static int ufs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto out_dir;
 
 		err = -ENOENT;
-		new_de = ufs_find_entry(new_dir, new_dentry, &new_page);
+		new_de = ufs_find_entry(new_dir, &new_dentry->d_name, &new_page);
 		if (!new_de)
 			goto out_dir;
 		inode_inc_link_count(old_inode);
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -86,9 +86,9 @@ extern void ufs_put_cylinder (struct super_block *, unsigned);
 /* dir.c */
 extern const struct inode_operations ufs_dir_inode_operations;
 extern int ufs_add_link (struct dentry *, struct inode *);
-extern ino_t ufs_inode_by_name(struct inode *, struct dentry *);
+extern ino_t ufs_inode_by_name(struct inode *, struct qstr *);
 extern int ufs_make_empty(struct inode *, struct inode *);
-extern struct ufs_dir_entry *ufs_find_entry(struct inode *, struct dentry *, struct page **);
+extern struct ufs_dir_entry *ufs_find_entry(struct inode *, struct qstr *, struct page **);
 extern int ufs_delete_entry(struct inode *, struct ufs_dir_entry *, struct page *);
 extern int ufs_empty_dir (struct inode *);
 extern struct ufs_dir_entry *ufs_dotdot(struct inode *, struct page **);
