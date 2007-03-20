Return-Path: <linux-kernel-owner+w=401wt.eu-S1030805AbXCTBAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030805AbXCTBAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 21:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966067AbXCTBAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 21:00:42 -0400
Received: from www.osadl.org ([213.239.205.134]:40540 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964834AbXCTBAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 21:00:41 -0400
Subject: Re: [patch 1/13] signal/timer/event fds v7 - anonymous inode
	source ...
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <send-serie.davidel@xmailserver.org.15249.1174348071.1>
References: <send-serie.davidel@xmailserver.org.15249.1174348071.1>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 02:07:46 +0100
Message-Id: <1174352866.13341.758.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,

On Mon, 2007-03-19 at 16:47 -0700, Davide Libenzi wrote:
> This patch add an anonymous inode source, to be used for files that need 
> and inode only in order to create a file*. We do not care of having an 
> inode for each file, and we do not even care of having different names in 
> the associated dentries (dentry names will be same for classes of file*).
> This allow code reuse, and will be used by epoll, signalfd and timerfd 
> (and whatever else there'll be).
>
> +int aino_getfd(int *pfd, struct inode **pinode, struct file **pfile,
> +	       char const *name, const struct file_operations *fops, void *priv)
> +{
> +	struct qstr this;
> +	struct dentry *dentry;
> +	struct inode *inode;
> +	struct file *file;
> +	int error, fd;
> +
> +	error = -ENFILE;
> +	file = get_empty_filp();
> +	if (!file)
> +		goto eexit_1;

make this "return -ENFILE;" please

> +	inode = aino_getinode();
> +	if (IS_ERR(inode)) {
> +		error = PTR_ERR(inode);
> +		goto eexit_2;

Can you please use a bit more descriptive labels ?

e.g:
	goto out_filp;

> +	}
> +
> +	error = get_unused_fd();
> +	if (error < 0)
> +		goto eexit_3;

e.g:
	goto out_inode;

> +	fd = error;
> +
> +	/*
> +	 * Link the inode to a directory entry by creating a unique name
> +	 * using the inode sequence number.
> +	 */
> +	error = -ENOMEM;
> +	this.name = name;
> +	this.len = strlen(name);
> +	this.hash = 0;
> +	dentry = d_alloc(aino_mnt->mnt_sb->s_root, &this);
> +	if (!dentry)
> +		goto eexit_4;

e.g:

	goto out_fd;


> +static int ainofs_delete_dentry(struct dentry *dentry)
> +{
> +	/*
> +	 * We faked vfs to believe the dentry was hashed when we created it.
> +	 * Now we restore the flag so that dput() will work correctly.
> +	 */
> +	dentry->d_flags |= DCACHE_UNHASHED;
> +	return 1;
> +}

Please put either "struct ainofs_dentry_operations ..." below the next
function or move ainofs_delete_dentry() above "struct
ainofs_dentry_operations ..."

It's annoying to lookup the protoypes and implemenation back and forth.

> +static struct inode *aino_getinode(void)
> +{
> +	return igrab(aino_inode);
> +}

Please use "igrab(aino_inode);" directly in this one single place above.
That saves us a prototype and an useless static function with no value.

> +/*
> + * A single inode exist for all aino files. On the contrary of pipes,
> + * aino inodes has no per-instance data associated, so we can avoid
> + * the allocation of multiple of them.
> + */
> +static struct inode *aino_mkinode(void)
> +{
> +	int error = -ENOMEM;
> +	struct inode *inode = new_inode(aino_mnt->mnt_sb);
> +
> +	if (!inode)
> +		goto eexit_1;

	return ERR_PTR(-ENOMEM);

> +	inode->i_fop = &aino_fops;
> +}
> +
> +static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
> +			 const char *dev_name, void *data, struct vfsmount *mnt)
> +{
> +	return get_sb_pseudo(fs_type, "aino:", NULL, AINOFS_MAGIC, mnt);
> +}

Please put either "struct file_system_type aino_fs_typ ..." below this
function or move ainofs_get_sb() above "struct file_system_type
aino_fs_typ ..."

> +static int __init aino_init(void)
> +{
> +
> +	if (register_filesystem(&aino_fs_type))
> +		goto epanic;
> +
> +	aino_mnt = kern_mount(&aino_fs_type);
> +	if (IS_ERR(aino_mnt))
> +		goto epanic;
> +
> +	aino_inode = aino_mkinode();
> +	if (IS_ERR(aino_inode))
> +		goto epanic;
> +
> +	return 0;
> +
> +epanic:
> +	panic("aino_init() failed\n");

Panic ? It's not life critical - is it ? 

A printk(KERN_ERR...) and a return -Exx would be sufficient.

	tglx



