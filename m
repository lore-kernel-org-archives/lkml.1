Return-Path: <linux-kernel-owner+w=401wt.eu-S935810AbYD1Phs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935810AbYD1Phs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934008AbYD1Phk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:37:40 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55648 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933744AbYD1Phj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:37:39 -0400
Date: Mon, 28 Apr 2008 11:37:16 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 7/19] UML - Move hppfs_kern.c to hppfs.c
Message-ID: <20080428153716.GC7334@c2.user-mode-linux.org>
References: <20080425175609.GA11180@c2.user-mode-linux.org> <20080426.171755.99884416.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.171755.99884416.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 05:17:55PM +0800, WANG Cong wrote:
> > +static struct inode *get_inode(struct super_block *, struct dentry *);
> > +
> > +struct hppfs_data {
> > +	struct list_head list;
> > +	char contents[PAGE_SIZE - sizeof(struct list_head)];
> > +};
> > +
> > +struct hppfs_private {
> > +	struct file *proc_file;
> > +	int host_fd;
> > +	loff_t len;
> > +	struct hppfs_data *contents;
> > +};
> > +
> > +struct hppfs_inode_info {
> > +	struct dentry *proc_dentry;
> > +	struct inode vfs_inode;
> > +};
> > +
> > +static inline struct hppfs_inode_info *HPPFS_I(struct inode *inode)
> > +{
> > +	return container_of(inode, struct hppfs_inode_info, vfs_inode);
> > +}
> > +
> > +#define HPPFS_SUPER_MAGIC 0xb00000ee
> 
> 
> These can be put into a single header, e.g. hppfs.h.

Why, when this one C file is the only user?

> > +static char *dentry_name(struct dentry *dentry, int extra)
> > +{
> > +	struct dentry *parent;
> > +	char *root, *name;
> > +	const char *seg_name;
> > +	int len, seg_len;
> > +
> > +	len = 0;
> > +	parent = dentry;
> 
> These can be put into initialization, I think, that's more readable.

Yup.

> > +	if (fd > 0) {
> > +		os_close_file(fd);
> > +		return 1;
> > +	}
> 
> 
> How about 'fd < 0' ?

OK, that would remove the braces at least...

> > +		new = kmalloc(sizeof(*data), GFP_KERNEL);
> > +		if (new == 0) {
> 
> 
> Using NULL is better, at least sparse complains about this. ;)

Good, I never liked using 0 (or !ptr) in place of NULL anyway.

> > +static int hppfs_filldir(void *d, const char *name, int size,
> > +			 loff_t offset, u64 inode, unsigned int type)
> > +{
> > +	struct hppfs_dirent *dirent = d;
> > +
> > +	if (file_removed(dirent->dentry, name))
> > +		return 0;
> 
> If returning 0 indicates success, this is wrong, since file_removed() may
> return -ENOMEM.
> 
> Or I miss something that is too obvious? ;-)

Oops, nice spotting.

See what you think about the patch below...

			Jeff

-- 
Work email - jdike at linux dot intel dot com

Index: linux-2.6.22/fs/hppfs/hppfs.c
===================================================================
--- linux-2.6.22.orig/fs/hppfs/hppfs.c	2008-04-28 11:21:38.000000000 -0400
+++ linux-2.6.22/fs/hppfs/hppfs.c	2008-04-28 11:34:58.000000000 -0400
@@ -64,13 +64,11 @@ static int is_pid(struct dentry *dentry)
 
 static char *dentry_name(struct dentry *dentry, int extra)
 {
-	struct dentry *parent;
-	char *root, *name;
+	struct dentry *parent = dentry;
+	char *root = "proc", *name;
 	const char *seg_name;
-	int len, seg_len;
+	int len = 0, seg_len;
 
-	len = 0;
-	parent = dentry;
 	while (parent->d_parent != parent) {
 		if (is_pid(parent))
 			len += strlen("pid") + 1;
@@ -78,7 +76,6 @@ static char *dentry_name(struct dentry *
 		parent = parent->d_parent;
 	}
 
-	root = "proc";
 	len += strlen(root);
 	name = kmalloc(len + extra + 1, GFP_KERNEL);
 	if (name == NULL)
@@ -128,11 +125,11 @@ static int file_removed(struct dentry *d
 
 	fd = os_open_file(host_file, of_read(OPENFLAGS()), 0);
 	kfree(host_file);
-	if (fd > 0) {
-		os_close_file(fd);
-		return 1;
-	}
-	return 0;
+	if (fd < 0)
+		return 0;
+
+	os_close_file(fd);
+	return 1;
 }
 
 static struct dentry *hppfs_lookup(struct inode *ino, struct dentry *dentry,
@@ -210,11 +207,10 @@ static ssize_t read_proc(struct file *fi
 
 static ssize_t hppfs_read_file(int fd, char __user *buf, ssize_t count)
 {
-	ssize_t n;
+	ssize_t n = -ENOMEM;
 	int cur, err;
 	char *new_buf;
 
-	n = -ENOMEM;
 	new_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (new_buf == NULL) {
 		printk(KERN_ERR "hppfs_read_file : kmalloc failed\n");
@@ -271,8 +267,10 @@ static ssize_t hppfs_read(struct file *f
 			count = hppfs->len - off;
 		rem = copy_to_user(buf, &data->contents[off], count);
 		*ppos += count - rem;
-		if (rem > 0)
+		if (rem == count)
 			return -EFAULT;
+		else if (rem > 0)
+			return count - rem;
 	} else if (hppfs->host_fd != -1) {
 		err = os_seek_file(hppfs->host_fd, *ppos);
 		if (err) {
@@ -380,7 +378,7 @@ static struct hppfs_data *hppfs_get_data
 			break;
 
 		new = kmalloc(sizeof(*data), GFP_KERNEL);
-		if (new == 0) {
+		if (new == NULL) {
 			printk(KERN_ERR "hppfs_get_data : data allocation "
 			       "failed\n");
 			err = -ENOMEM;
@@ -551,8 +549,11 @@ static int hppfs_filldir(void *d, const 
 			 loff_t offset, u64 inode, unsigned int type)
 {
 	struct hppfs_dirent *dirent = d;
+	int gone = file_removed(dirent->dentry, name);
 
-	if (file_removed(dirent->dentry, name))
+	if (gone < 0)
+		return gone;
+	else if (gone)
 		return 0;
 
 	return (*dirent->filldir)(dirent->vfs_dirent, name, size, offset,
