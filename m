Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbYDZIc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbYDZIc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 04:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYDZIcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 04:32:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:60140 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYDZIcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 04:32:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=hep61FUAbtNwjfif1i6I5SI8e2CIuTi4FPCPK3mCjg8+u9bQcvyFPLn0LE0E+pFizcQcOQ53kr81vBNZTbZW7jQ0TPe4NfCT5WsPzrobevKG9BZVPg2TcvFn8p1aMnF/HVP/Pd8Adgmk4Ud74vo9EXZ6udsilR94qgQZB63AE+w=
Date: Sat, 26 Apr 2008 16:31:32 +0800 (CST)
Message-Id: <20080426.163132.194697674.xiyou.wangcong@gmail.com>
To: jdike@addtoit.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 6/19] UML - hppfs fixes
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080425175608.GA11182@c2.user-mode-linux.org>
References: <20080425175608.GA11182@c2.user-mode-linux.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Dike <jdike@addtoit.com>
Date: Fri, 25 Apr 2008 13:56:09 -0400
> hppfs tidying and fixes noticed during hch's get_inode work -
>       style fixes
>       a copy_to_user got its return value checked
>       hppfs_write no longer fiddles file->f_pos because it gets and
> returns pos in its arguments
>       hppfs_delete_inode dputs the underlyng procfs dentry stored in
> its private data and mntputs the vfsmnt stashed in s_fs_info
>       hppfs_put_super no longer needs to mntput the s_fs_info, so it
> no longer needs to exist
>       hppfs_readlink and hppfs_follow_link were doing a bunch of stuff
> with a struct file which they didn't use
>       there is now a ->permission which calls generic_permission
>       get_inode was always returning 0 for some reason - it now
> returns an inode if nothing bad happened
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  fs/hppfs/hppfs_kern.c |   82 ++++++++++++++++++--------------------------------
>  1 file changed, 30 insertions(+), 52 deletions(-)
> 
> Index: linux-2.6.22/fs/hppfs/hppfs_kern.c
> ===================================================================
> --- linux-2.6.22.orig/fs/hppfs/hppfs_kern.c	2008-04-24 13:35:54.000000000 -0400
> +++ linux-2.6.22/fs/hppfs/hppfs_kern.c	2008-04-24 15:31:59.000000000 -0400
> @@ -33,7 +33,7 @@ struct hppfs_private {
>  };
>  
>  struct hppfs_inode_info {
> -        struct dentry *proc_dentry;
> +	struct dentry *proc_dentry;
>  	struct inode vfs_inode;
>  };
>  
> @@ -52,7 +52,7 @@ static int is_pid(struct dentry *dentry)
>  	int i;
>  
>  	sb = dentry->d_sb;
> -	if ((sb->s_op != &hppfs_sbops) || (dentry->d_parent != sb->s_root))
> +	if (dentry->d_parent != sb->s_root)
>  		return 0;
>  
>  	for (i = 0; i < dentry->d_name.len; i++) {
> @@ -136,7 +136,7 @@ static int file_removed(struct dentry *d
>  }
>  
>  static struct dentry *hppfs_lookup(struct inode *ino, struct dentry *dentry,
> -                                  struct nameidata *nd)
> +				   struct nameidata *nd)
>  {
>  	struct dentry *proc_dentry, *new, *parent;
>  	struct inode *inode;
> @@ -254,6 +254,8 @@ static ssize_t hppfs_read(struct file *f
>  	int err;
>  
>  	if (hppfs->contents != NULL) {
> +		int rem;
> +
>  		if (*ppos >= hppfs->len)
>  			return 0;
>  
> @@ -267,8 +269,10 @@ static ssize_t hppfs_read(struct file *f
>  
>  		if (off + count > hppfs->len)
>  			count = hppfs->len - off;
> -		copy_to_user(buf, &data->contents[off], count);
> -		*ppos += count;
> +		rem = copy_to_user(buf, &data->contents[off], count);
> +		*ppos += count - rem;
> +		if (rem > 0)
> +			return -EFAULT;


Could you please explain why check 'rem' after using it here?


>  	} else if (hppfs->host_fd != -1) {
>  		err = os_seek_file(hppfs->host_fd, *ppos);
>  		if (err) {
> @@ -285,21 +289,15 @@ static ssize_t hppfs_read(struct file *f
>  	return count;
>  }
>  
> -static ssize_t hppfs_write(struct file *file, const char __user *buf, size_t len,
> -			   loff_t *ppos)
> +static ssize_t hppfs_write(struct file *file, const char __user *buf,
> +			   size_t len, loff_t *ppos)
>  {
>  	struct hppfs_private *data = file->private_data;
>  	struct file *proc_file = data->proc_file;
>  	ssize_t (*write)(struct file *, const char __user *, size_t, loff_t *);
> -	int err;
>  
>  	write = proc_file->f_path.dentry->d_inode->i_fop->write;
> -
> -	proc_file->f_pos = file->f_pos;
> -	err = (*write)(proc_file, buf, len, &proc_file->f_pos);
> -	file->f_pos = proc_file->f_pos;
> -
> -	return err;
> +	return (*write)(proc_file, buf, len, ppos);
>  }
>  
>  static int open_host_sock(char *host_file, int *filter_out)
> @@ -357,7 +355,7 @@ static struct hppfs_data *hppfs_get_data
>  
>  	if (filter) {
>  		while ((n = read_proc(proc_file, data->contents,
> -				     sizeof(data->contents), NULL, 0)) > 0)
> +				      sizeof(data->contents), NULL, 0)) > 0)
>  			os_write_file(fd, data->contents, n);
>  		err = os_shutdown_socket(fd, 0, 1);
>  		if (err) {
> @@ -429,8 +427,8 @@ static int file_mode(int fmode)
>  static int hppfs_open(struct inode *inode, struct file *file)
>  {
>  	struct hppfs_private *data;
> -	struct dentry *proc_dentry;
>  	struct vfsmount *proc_mnt;
> +	struct dentry *proc_dentry;

And what does this kind of change mean?

>  	char *host_file;
>  	int err, fd, type, filter;
>  
> @@ -492,8 +490,8 @@ static int hppfs_open(struct inode *inod
>  static int hppfs_dir_open(struct inode *inode, struct file *file)
>  {
>  	struct hppfs_private *data;
> -	struct dentry *proc_dentry;
>  	struct vfsmount *proc_mnt;
> +	struct dentry *proc_dentry;

ditto

<snip>

Thanks!


Cong
