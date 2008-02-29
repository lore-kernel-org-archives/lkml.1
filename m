Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbYB2Q2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbYB2Q2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932800AbYB2Q1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:27:46 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46950 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933159AbYB2Q1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:27:44 -0500
X-Sasl-enc: YCM4ZDD9TUn3kPpss6o/YsPUCDZWRYInKdg1ZcvlpbcZ 1204302461
Subject: Re: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20080227211723.d5d27c09.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
	 <Pine.LNX.4.64.0802261218230.8490@raven.themaw.net>
	 <20080227211723.d5d27c09.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 01 Mar 2008 01:24:10 +0900
Message-Id: <1204302250.19890.22.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 21:17 -0800, Andrew Morton wrote:
> On Tue, 26 Feb 2008 12:23:55 +0900 (WST) Ian Kent <raven@themaw.net> wrote:
> 
> > Hi Andrew,
> > 
> > Patch to add miscellaneous device to autofs4 module for
> > ioctls.
> 
> Could you please document the new kernel interface which you're proposing? 
> In Docmentation/ or in the changelog?
> 
> We seem to be passing some string into a miscdevice ioctl and getting some
> results back.  Be aware that this won't be a terribly popular proposal, so
> I'd suggest that you fully describe the problem which it's trying to solve,
> and how it solves it, and why the various alternatives (sysfs, netlink,
> mount options, etc) were judged unsuitable.

It appears I could do this with the generic netlink subsystem.
I'll have a go at it.

> 
> 
> >
> > ...
> >
> > +/*
> > + * Get the autofs super block info struct from the file opened on
> > + * the autofs mount point.
> > + */
> > +static struct autofs_sb_info *autofs_dev_ioctl_sbi(struct file *f)
> > +{
> > +	struct autofs_sb_info *sbi = NULL;
> > +	struct inode *inode;
> > +
> > +	if (f) {
> 
> `f' cannot be NULL here.

And, will still be in the netlink implementation and will still return
an appropriate error.

> 
> > +		inode = f->f_path.dentry->d_inode;
> > +		sbi = autofs4_sbi(inode->i_sb);
> > +	}
> > +
> > +	return sbi;
> > +}
> > +
> > +/* Return autofs module protocol version */
> > +static inline int autofs_dev_ioctl_protover(struct file *fp,
> > +					    struct autofs_sb_info *sbi,
> > +					    struct autofs_dev_ioctl *param)
> > +{
> > +	param->arg1 = sbi->version;
> > +	return 0;
> > +}
> > +
> > +/* Return autofs module protocol sub version */
> > +static inline int autofs_dev_ioctl_protosubver(struct file *fp,
> > +					       struct autofs_sb_info *sbi,
> > +					       struct autofs_dev_ioctl *param)
> > +{
> > +	param->arg1 = sbi->sub_version;
> > +	return 0;
> > +}
> 
> Don't bother inlining things - the compiler will do it.
> 
> > +/*
> > + * Walk down the mount stack looking for an autofs mount that
> > + * has the requested device number (aka. new_encode_dev(sb->s_dev).
> > + */
> > +static int autofs_dev_ioctl_find_super(struct nameidata *nd, dev_t devno)
> > +{
> > +	struct dentry *dentry;
> > +	struct inode *inode;
> > +	struct super_block *sb;
> > +	dev_t s_dev;
> > +	unsigned int err;
> > +
> > +	err = -ENOENT;
> > +
> > +	/* Lookup the dentry name at the base of our mount point */
> > +	dentry = d_lookup(nd->path.dentry, &nd->last);
> > +	if (!dentry)
> > +		goto out;
> > +
> > +	dput(nd->path.dentry);
> > +	nd->path.dentry = dentry;
> > +
> > +	/* And follow the mount stack looking for our autofs mount */
> > +	while (1) {
> > +		inode = nd->path.dentry->d_inode;
> > +		if (!inode)
> > +			continue;
> > +
> > +		sb = inode->i_sb;
> > +		s_dev = new_encode_dev(sb->s_dev);
> > +		if (devno == s_dev) {
> > +			if (sb->s_magic == AUTOFS_SUPER_MAGIC) {
> > +				err = 0;
> > +				break;
> > +			}
> > +		}
> > +
> > +		if (!follow_down(&nd->path.mnt, &nd->path.dentry))
> > +			goto out;
> > +	}
> > +
> > +out:
> > +	return err;
> > +}
> 
> hm.  possibly-interested parties cc'ed.

Agian, will still be in the netlink implementation.
Speak up if it's not right.

> 
> > +/*
> > + * Install the file opened for autofs mount point control functions
> > + * and set close on exec.
> > + */
> > +static void autofs_dev_ioctl_fd_install(unsigned int fd, struct file *file)
> > +{
> > +	struct files_struct *files = current->files;
> > +	struct fdtable *fdt;
> > +
> > +	spin_lock(&files->file_lock);
> > +	fdt = files_fdtable(files);
> > +	BUG_ON(fdt->fd[fd] != NULL);
> > +	rcu_assign_pointer(fdt->fd[fd], file);
> > +	FD_SET(fd, fdt->close_on_exec);
> > +	spin_unlock(&files->file_lock);
> > +}
> 
> That's fd_install() plus an add-on.  It's not autofs-specific.  Should be
> in fs/open.c, methinks?

OK, I'll do that if someone speaks up.

> 
> >
> > ...
> >
> > +/* Close file descriptor allocated above (user can also use close(2)). */
> > +static inline int autofs_dev_ioctl_closemount(struct file *fp,
> > +					      struct autofs_sb_info *sbi,
> > +					      struct autofs_dev_ioctl *param)
> > +{
> > +	return sys_close(param->ioctlfd);
> > +}
> 
> hm.

Also, still in the netlink implementation, with a comment a bit more
informative than the one above.

> 
> >
> > ...
> >
> > +/*
> > + * Set the pipe fd for kernel communication to the daemon.
> > + *
> > + * Normally this is set at mount using an option but if we
> > + * are reconnecting to a busy mount then we need to use this
> > + * to tell the autofs mount about the new kernel pipe fd. In
> > + * order to protect mounts against incorrectly setting the
> > + * pipefd we also require that the autofs mount be catatonic.
> > + *
> > + * This also sets the process group id used to identify the
> > + * controlling process (eg. the owning automount(8) daemon).
> > + */
> > +static int autofs_dev_ioctl_setpipefd(struct file *fp,
> > +				      struct autofs_sb_info *sbi,
> > +				      struct autofs_dev_ioctl *param)
> > +{
> > +	int pipefd;
> > +	int err = 0;
> > +
> > +	if (param->arg1 == -1)
> > +		return -EINVAL;
> > +
> > +	pipefd = param->arg1;
> > +
> > +	if (!sbi->catatonic)
> > +		return -EBUSY;
> > +	else {
> > +		struct file *pipe = fget(pipefd);
> > +		if (!pipe->f_op || !pipe->f_op->write) {
> > +			err = -EPIPE;
> > +			fput(pipe);
> > +			goto out;
> > +		}
> > +		sbi->oz_pgrp = task_pgrp_nr(current);
> > +		sbi->pipefd = pipefd;
> > +		sbi->pipe = pipe;
> > +		sbi->catatonic = 0;
> > +	}
> > +out:
> > +	return err;
> > +}
> 
> We have a new filesystem type, a misc device with a mysterious ioctl,
> hand-rolled mountpoint chasing, hand-rolled fd installation and now pipes
> too.

That's not going to change.
There's nothing new here at all.
This is merely an re-implementation of the existing autofs ioctl
interface with two additional calls, nothing more.

> 
> This is a complex interface.  We really need to see the overall
> problem
> statement, design and interface description, please.

I'll add a document describing this, as previously agreed.

snip ...

> > +
> > +/*
> > + * Call repeatedly until it returns -EAGAIN, meaning there's nothing
> > + * more that can be done.
> > + */
> > +static int autofs_dev_ioctl_expire(struct file *fp,
> > +				   struct autofs_sb_info *sbi,
> > +				   struct autofs_dev_ioctl *param)
> > +{
> > +	struct dentry *dentry;
> > +	struct vfsmount *mnt;
> > +	int err = -EAGAIN;
> > +	int when;
> > +
> > +	when = param->arg1;
> > +	mnt = fp->f_path.mnt;
> > +
> > +	if (sbi->type & AUTOFS_TYPE_DIRECT)
> > +		dentry = autofs4_expire_direct(sbi->sb, mnt, sbi, when);
> > +	else
> > +		dentry = autofs4_expire_indirect(sbi->sb, mnt, sbi, when);
> > +
> > +	if (dentry) {
> > +		struct autofs_info *ino = autofs4_dentry_ino(dentry);
> > +
> > +		/*
> > +		 * This is synchronous because it makes the daemon a
> > +		 * little easier
> > +		*/
> > +		ino->flags |= AUTOFS_INF_EXPIRING;
> > +		err = autofs4_wait(sbi, dentry, NFY_EXPIRE);
> > +		ino->flags &= ~AUTOFS_INF_EXPIRING;
> 
> Are there races around the modification of ino->flags here?

I haven't had any problems with this over time.
I've always thought that this was because the flag is only set during an
expire, of which there is only ever one going for a given mount, is
synchronous, and mount requests only read the flag to check status.

But I could be wrong since it may have been OK because the existing
autofs ioctl holds the BKL for its operations.

I'll think about it.

snip ....



