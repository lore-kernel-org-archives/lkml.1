Return-Path: <linux-kernel-owner+w=401wt.eu-S1750898AbXC3WoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898AbXC3WoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 18:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXC3WoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 18:44:22 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47571 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbXC3WoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 18:44:21 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 30 Mar 2007 15:44:15 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 1/13] signal/timer/event fds v8 - anonymous inode source
 ...
In-Reply-To: <20070330123943.8df1aa92.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703301532500.3721@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28743.1174415834.1>
 <20070330123943.8df1aa92.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Andrew Morton wrote:

> > +#include <asm/uaccess.h>
> > +
> > +
> > +
> 
> Too many blank lines

It'd be interesting to know how much is enough. You use one, ppl says it 
is too dense. You use more, ppl says it's too much.
There's the one-line rule for inter-function spacing, but what's the 
include-functions ones? Or the functions-data ones?



> > +static int ainofs_delete_dentry(struct dentry *dentry);
> > +static struct inode *aino_mkinode(void);
> 
> Unneeded forward declaration.

Same here. You're the third says this, so I'm gonna change it. But pls 
consider adding it to the coding style.



> > +static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
> > +			 const char *dev_name, void *data, struct vfsmount *mnt);
> > +
> > +
> > +
> > +static struct vfsmount *aino_mnt __read_mostly;
> > +static struct inode *aino_inode;
> > +static const struct file_operations aino_fops = { };
> 
> Unneeded { }

Ack.



> > +static struct file_system_type aino_fs_type = {
> > +	.name		= "ainofs",
> > +	.get_sb		= ainofs_get_sb,
> > +	.kill_sb	= kill_anon_super,
> > +};
> > +static struct dentry_operations ainofs_dentry_operations = {
> > +	.d_delete	= ainofs_delete_dentry,
> > +};
> 
> If this is moved elsewhere we can perhaps remove some or all of the
> unpleasing static function forward-declarations.

Grrr :)




> > +/**
> > + * aino_getfd - creates a new file instance by hooking it up to and anonymous
> > + *              inode, and a dentry that describe the "class" of the file
> > + * @pfd:     [out]   pointer to the file descriptor
> > + * @dpinode: [out]   pointer to the inode
> > + * @pfile:   [out]   pointer to the file struct
> > + * @name:    [in]    name of the "class" of the new file
> > + * @fops     [in]    file operations for the new file
> > + * @priv     [in]    private data for the new file (will be file's private_data)
> 
> The [in] and [out] thing is nice - does kerneldoc handle it appropriately?

No idea. It should come out as text at least.




> > + *
> > + * Creates a new file by hooking it on a single inode. This is useful for files
> > + * that do not need to have a full-fledged inode in order to operate correctly.
> > + * All the files created with aino_getfd() will share a single inode, by hence
> > + * saving memory and avoiding code duplication for the file/inode/dentry setup.
> > + */
> > +int aino_getfd(int *pfd, struct inode **pinode, struct file **pfile,
> > +	       char const *name, const struct file_operations *fops, void *priv)
> 
> Dunno about others, but the "aino" naming doesn't grab me, really. 
> anon_inode_getfd() would make more sense.

Why? Don't you like fortran-like compact naming? :)



> We conventionally use `const char *' rather than `char const *', and I thnk
> it is more logical to do so.

Okie




> > +static int ainofs_delete_dentry(struct dentry *dentry)
> > +{
> > +	/*
> > +	 * We faked vfs to believe the dentry was hashed when we created it.
> > +	 * Now we restore the flag so that dput() will work correctly.
> > +	 */
> > +	dentry->d_flags |= DCACHE_UNHASHED;
> > +	return 1;
> > +}
> 
> Is that legit, or is it a hack??

Same thing used in pipes. Avoid loading the hash for things that'll never 
be looked up.




> > +/*
> > + * A single inode exist for all aino files. On the contrary of pipes,
> > + * aino inodes has no per-instance data associated, so we can avoid
> > + * the allocation of multiple of them.
> > + */
> 
> "Contrary to pipes, aino inodes have no ...."

Ok



> > +static struct inode *aino_mkinode(void)
> > +{
> > +	struct inode *inode = new_inode(aino_mnt->mnt_sb);
> > +
> > +	if (!inode)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	inode->i_fop = &aino_fops;
> > +
> > +	/*
> > +	 * Mark the inode dirty from the very beginning,
> > +	 * that way it will never be moved to the dirty
> > +	 * list because mark_inode_dirty() will think
> > +	 * that it already _is_ on the dirty list.
> > +	 */
> 
> Thus breaking what is hopefully a VFS invariant.  How come?

Copied from pipes.




> > +static int __init aino_init(void)
> > +{
> > +	int error;
> > +
> > +	error = register_filesystem(&aino_fs_type);
> > +	if (error)
> > +		goto err_exit;
> > +	aino_mnt = kern_mount(&aino_fs_type);
> > +	if (IS_ERR(aino_mnt)) {
> > +		error = PTR_ERR(aino_mnt);
> > +		goto err_unregister_filesystem;
> > +	}
> > +	aino_inode = aino_mkinode();
> > +	if (IS_ERR(aino_inode)) {
> > +		error = PTR_ERR(aino_inode);
> > +		goto err_mntput;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_mntput:
> > +	mntput(aino_mnt);
> > +err_unregister_filesystem:
> > +	unregister_filesystem(&aino_fs_type);
> > +err_exit:
> > +	printk(KERN_ERR "aino_init() failed (%d)\n", error);
> 
> I suspect this is panic time?

Ok, it was panincing, and someone made me change it. Would you please 
agree?
The system can survive w/out, but it'll be a broken system WRT userspace.




> > +int aino_getfd(int *pfd, struct inode **pinode, struct file **pfile,
> > +	       char const *name, const struct file_operations *fops, void *priv);
> > +
> > +#endif /* _LINUX_ANON_INODES_H */
> > +
> > Index: linux-2.6.21-rc3.quilt/fs/Makefile
> > ===================================================================
> > --- linux-2.6.21-rc3.quilt.orig/fs/Makefile	2007-03-15 15:19:22.000000000 -0700
> > +++ linux-2.6.21-rc3.quilt/fs/Makefile	2007-03-19 19:01:01.000000000 -0700
> > @@ -11,7 +11,7 @@
> >  		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
> >  		seq_file.o xattr.o libfs.o fs-writeback.o \
> >  		pnode.o drop_caches.o splice.o sync.o utimes.o \
> > -		stack.o
> > +		stack.o anon_inodes.o
> 
> Can we make this optional if CONFIG_EMBEDDED?  You plan on converting epoll
> to use this facility, but with CONFIG_EPOLL=n, this is all dead code?

Hmmm, the whole point is that all this stuff works with or without epoll. 
And epoll need no changes to support this.



- Davide


