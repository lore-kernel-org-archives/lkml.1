Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYGRPaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYGRPaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYGRP35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:29:57 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46854 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbYGRP34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:29:56 -0400
X-Sasl-enc: SlsGCp0kRK5lLRZvA+JlqUGD+HH9H/mebDt/GtUQ1KH2 1216394994
Subject: Re: [PATCH 2/7] autofs4 - cleanup redundant readir code
From: Ian Kent <raven@themaw.net>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <x4963r3dzbd.fsf@segfault.boston.devel.redhat.com>
References: <20080718023651.12802.59107.stgit@raven.themaw.net>
	 <20080718023700.12802.52927.stgit@raven.themaw.net>
	 <x4963r3dzbd.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 23:26:12 +0800
Message-Id: <1216394774.18371.7.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-07-18 at 10:47 -0400, Jeff Moyer wrote:
> Ian Kent <raven@themaw.net> writes:
> 
> > The mount triggering functionality of readdir and related functions
> > is no longer used (and is quite broken as well). The unused portions
> > have been removed.
> 
> I agree that this should be safe (and I also agree that the code was
> broken!), but I'm not sure why you say that the code was no longer used.
> It was still wired up until this patch, right?

Of course that's true but the times that this was called were
essentially due to races in the lookup code. So, partly due to our
recent changes in the lookup (and revalidate), and also due to
observations and suggestions from Al Viro, I believe we catch all cases
their now, as it should be.

> 
> Anyway:
> 
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> 
> >
> > Signed-off-by: Ian Kent <raven@themaw.net>
> >
> > ---
> >
> >  fs/autofs4/root.c |  149 ++++++-----------------------------------------------
> >  1 files changed, 16 insertions(+), 133 deletions(-)
> >
> >
> > diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> > index 2a1a631..e842b0a 100644
> > --- a/fs/autofs4/root.c
> > +++ b/fs/autofs4/root.c
> > @@ -25,8 +25,6 @@ static int autofs4_dir_rmdir(struct inode *,struct dentry *);
> >  static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
> >  static int autofs4_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
> >  static int autofs4_dir_open(struct inode *inode, struct file *file);
> > -static int autofs4_dir_close(struct inode *inode, struct file *file);
> > -static int autofs4_dir_readdir(struct file * filp, void * dirent, filldir_t filldir);
> >  static int autofs4_root_readdir(struct file * filp, void * dirent, filldir_t filldir);
> >  static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
> >  static void *autofs4_follow_link(struct dentry *, struct nameidata *);
> > @@ -44,9 +42,9 @@ const struct file_operations autofs4_root_operations = {
> >  
> >  const struct file_operations autofs4_dir_operations = {
> >  	.open		= autofs4_dir_open,
> > -	.release	= autofs4_dir_close,
> > +	.release	= dcache_dir_close,
> >  	.read		= generic_read_dir,
> > -	.readdir	= autofs4_dir_readdir,
> > +	.readdir	= dcache_readdir,
> >  };
> >  
> >  const struct inode_operations autofs4_indirect_root_inode_operations = {
> > @@ -98,17 +96,7 @@ static int autofs4_root_readdir(struct file *file, void *dirent,
> >  static int autofs4_dir_open(struct inode *inode, struct file *file)
> >  {
> >  	struct dentry *dentry = file->f_path.dentry;
> > -	struct vfsmount *mnt = file->f_path.mnt;
> >  	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
> > -	struct dentry *cursor;
> > -	int status;
> > -
> > -	status = dcache_dir_open(inode, file);
> > -	if (status)
> > -		goto out;
> > -
> > -	cursor = file->private_data;
> > -	cursor->d_fsdata = NULL;
> >  
> >  	DPRINTK("file=%p dentry=%p %.*s",
> >  		file, dentry, dentry->d_name.len, dentry->d_name.name);
> > @@ -116,129 +104,24 @@ static int autofs4_dir_open(struct inode *inode, struct file *file)
> >  	if (autofs4_oz_mode(sbi))
> >  		goto out;
> >  
> > -	if (autofs4_ispending(dentry)) {
> > -		DPRINTK("dentry busy");
> > -		dcache_dir_close(inode, file);
> > -		status = -EBUSY;
> > -		goto out;
> > -	}
> > -
> > -	status = -ENOENT;
> > -	if (!d_mountpoint(dentry) && dentry->d_op && dentry->d_op->d_revalidate) {
> > -		struct nameidata nd;
> > -		int empty, ret;
> > -
> > -		/* In case there are stale directory dentrys from a failed mount */
> > -		spin_lock(&dcache_lock);
> > -		empty = list_empty(&dentry->d_subdirs);
> > +	/*
> > +	 * An empty directory in an autofs file system is always a
> > +	 * mount point. The daemon must have failed to mount this
> > +	 * during lookup so it doesn't exist. This can happen, for
> > +	 * example, if user space returns an incorrect status for a
> > +	 * mount request. Otherwise we're doing a readdir on the
> > +	 * autofs file system so just let the libfs routines handle
> > +	 * it.
> > +	 */
> > +	spin_lock(&dcache_lock);
> > +	if (!d_mountpoint(dentry) && __simple_empty(dentry)) {
> >  		spin_unlock(&dcache_lock);
> > -
> > -		if (!empty)
> > -			d_invalidate(dentry);
> > -
> > -		nd.flags = LOOKUP_DIRECTORY;
> > -		ret = (dentry->d_op->d_revalidate)(dentry, &nd);
> > -
> > -		if (ret <= 0) {
> > -			if (ret < 0)
> > -				status = ret;
> > -			dcache_dir_close(inode, file);
> > -			goto out;
> > -		}
> > +		return -ENOENT;
> >  	}
> > +	spin_unlock(&dcache_lock);
> >  
> > -	if (d_mountpoint(dentry)) {
> > -		struct file *fp = NULL;
> > -		struct path fp_path = { .dentry = dentry, .mnt = mnt };
> > -
> > -		path_get(&fp_path);
> > -
> > -		if (!autofs4_follow_mount(&fp_path.mnt, &fp_path.dentry)) {
> > -			path_put(&fp_path);
> > -			dcache_dir_close(inode, file);
> > -			goto out;
> > -		}
> > -
> > -		fp = dentry_open(fp_path.dentry, fp_path.mnt, file->f_flags);
> > -		status = PTR_ERR(fp);
> > -		if (IS_ERR(fp)) {
> > -			dcache_dir_close(inode, file);
> > -			goto out;
> > -		}
> > -		cursor->d_fsdata = fp;
> > -	}
> > -	return 0;
> > -out:
> > -	return status;
> > -}
> > -
> > -static int autofs4_dir_close(struct inode *inode, struct file *file)
> > -{
> > -	struct dentry *dentry = file->f_path.dentry;
> > -	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
> > -	struct dentry *cursor = file->private_data;
> > -	int status = 0;
> > -
> > -	DPRINTK("file=%p dentry=%p %.*s",
> > -		file, dentry, dentry->d_name.len, dentry->d_name.name);
> > -
> > -	if (autofs4_oz_mode(sbi))
> > -		goto out;
> > -
> > -	if (autofs4_ispending(dentry)) {
> > -		DPRINTK("dentry busy");
> > -		status = -EBUSY;
> > -		goto out;
> > -	}
> > -
> > -	if (d_mountpoint(dentry)) {
> > -		struct file *fp = cursor->d_fsdata;
> > -		if (!fp) {
> > -			status = -ENOENT;
> > -			goto out;
> > -		}
> > -		filp_close(fp, current->files);
> > -	}
> > -out:
> > -	dcache_dir_close(inode, file);
> > -	return status;
> > -}
> > -
> > -static int autofs4_dir_readdir(struct file *file, void *dirent, filldir_t filldir)
> > -{
> > -	struct dentry *dentry = file->f_path.dentry;
> > -	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
> > -	struct dentry *cursor = file->private_data;
> > -	int status;
> > -
> > -	DPRINTK("file=%p dentry=%p %.*s",
> > -		file, dentry, dentry->d_name.len, dentry->d_name.name);
> > -
> > -	if (autofs4_oz_mode(sbi))
> > -		goto out;
> > -
> > -	if (autofs4_ispending(dentry)) {
> > -		DPRINTK("dentry busy");
> > -		return -EBUSY;
> > -	}
> > -
> > -	if (d_mountpoint(dentry)) {
> > -		struct file *fp = cursor->d_fsdata;
> > -
> > -		if (!fp)
> > -			return -ENOENT;
> > -
> > -		if (!fp->f_op || !fp->f_op->readdir)
> > -			goto out;
> > -
> > -		status = vfs_readdir(fp, filldir, dirent);
> > -		file->f_pos = fp->f_pos;
> > -		if (status)
> > -			autofs4_copy_atime(file, fp);
> > -		return status;
> > -	}
> >  out:
> > -	return dcache_readdir(file, dirent, filldir);
> > +	return dcache_dir_open(inode, file);
> >  }
> >  
> >  static int try_to_fill_dentry(struct dentry *dentry, int flags)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

