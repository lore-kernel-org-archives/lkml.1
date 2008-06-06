Return-Path: <linux-kernel-owner+w=401wt.eu-S1761757AbYFFCvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761757AbYFFCvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 22:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYFFCvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 22:51:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47329 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298AbYFFCvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 22:51:08 -0400
X-Sasl-enc: JxT5bEzSFSB8nRN8KdGS+KGmkoiLT7svQEczQyY5MjY3 1212720665
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, miklos@szeredi.hu,
       jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jmoyer@redhat.com
In-Reply-To: <20080605153019.77d61199.akpm@linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>
	 <20080603095713.GR28946@ZenIV.linux.org.uk>
	 <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
	 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
	 <20080603104035.GT28946@ZenIV.linux.org.uk>
	 <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	 <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212651099.3047.44.camel@raven.themaw.net>
	 <20080605153019.77d61199.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:47:32 +0800
Message-Id: <1212720453.3035.9.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 15:30 -0700, Andrew Morton wrote:
> On Thu, 05 Jun 2008 15:31:37 +0800
> Ian Kent <raven@themaw.net> wrote:
> 
> > 
> > On Tue, 2008-06-03 at 08:01 -0700, Linus Torvalds wrote:
> > > 
> > > On Tue, 3 Jun 2008, Ian Kent wrote:
> > > > > 
> > > > > > I think it must be autofs4 doing something weird.  Like this in
> > > > > > autofs4_lookup_unhashed():
> > > > > > 
> > > > > > 			/*
> > > > > > 			 * Make the rehashed dentry negative so the VFS
> > > > > > 			 * behaves as it should.
> > > > > > 			 */
> > > > > > 			if (inode) {
> > > > > > 				dentry->d_inode = NULL;
> > > 
> > > Uhhuh. Yeah, that's not allowed.
> > > 
> > > A dentry inode can start _out_ as NULL, but it can never later become NULL 
> > > again until it is totally unused.
> > 
> > Here is a patch for autofs4 to, hopefully, resolve this.
> > 
> > Keep in mind this doesn't address any other autofs4 issues but I it
> > should allow us to identify if this was in fact the root cause of the
> > problem Jesper reported.
> > 
> > autofs4 - leave rehashed dentry positive
> > 
> > From: Ian Kent <raven@themaw.net>
> > 
> > Correct the error of making a positive dentry negative after it has been
> > instantiated.
> > 
> > This involves removing the code in autofs4_lookup_unhashed() that
> > makes the dentry negative and updating autofs4_dir_symlink() and
> > autofs4_dir_mkdir() to recognise they have been given a postive
> > dentry (previously the dentry was always negative) and deal with
> > it. In addition the dentry info struct initialization, autofs4_init_ino(),
> > and the symlink free function, ino_lnkfree(), have been made aware
> > of this possible re-use. This is needed because the current case
> > re-uses a dentry in order to preserve it's flags as described in
> > commit f50b6f8691cae2e0064c499dd3ef3f31142987f0.
> > 
> > ...
> >
> > ...
> >
> > diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> > index edf5b6b..6ce603b 100644
> > --- a/fs/autofs4/root.c
> > +++ b/fs/autofs4/root.c
> > @@ -555,24 +555,8 @@ static struct dentry *autofs4_lookup_unhashed(struct autofs_sb_info *sbi, struct
> >  			goto next;
> >  
> >  		if (d_unhashed(dentry)) {
> > -			struct inode *inode = dentry->d_inode;
> > -
> > -			ino = autofs4_dentry_ino(dentry);
> >  			list_del_init(&ino->rehash);
> >  			dget(dentry);
> > -			/*
> > -			 * Make the rehashed dentry negative so the VFS
> > -			 * behaves as it should.
> > -			 */
> > -			if (inode) {
> > -				dentry->d_inode = NULL;
> > -				list_del_init(&dentry->d_alias);
> > -				spin_unlock(&dentry->d_lock);
> > -				spin_unlock(&sbi->rehash_lock);
> > -				spin_unlock(&dcache_lock);
> > -				iput(inode);
> > -				return dentry;
> > -			}
> >  			spin_unlock(&dentry->d_lock);
> >  			spin_unlock(&sbi->rehash_lock);
> >  			spin_unlock(&dcache_lock);
> > @@ -728,35 +712,50 @@ static int autofs4_dir_symlink(struct inode *dir,
> >  		return -EACCES;
> >  
> >  	ino = autofs4_init_ino(ino, sbi, S_IFLNK | 0555);
> > -	if (ino == NULL)
> > +	if (!ino)
> >  		return -ENOSPC;
> 
> Should have been ENOMEM, I guess.

Ha, yeah, I think it should be.
I just used the errno that has been there all along without thinking.

> 
> > -	ino->size = strlen(symname);
> > -	ino->u.symlink = cp = kmalloc(ino->size + 1, GFP_KERNEL);
> > -
> > -	if (cp == NULL) {
> > -		kfree(ino);
> > +	cp = kmalloc(ino->size + 1, GFP_KERNEL);
> > +	if (!cp) {
> > +		if (!dentry->d_fsdata)
> > +			kfree(ino);
> 
> OK, so here we work out that autofs4_init_ino() had to allocate a new
> autofs_info and if so, free it here.  It took me a moment..

That is right, but as it is now, this will always be a new allocation.
If all goes well (yeah right) I will be allocating the info struct in
->lookup() in a subsequent patch.

> 
> >  		return -ENOSPC;
> 
> ENOMEM?
> 
> >  	}
> >  
> >  	strcpy(cp, symname);
> >  
> > -	inode = autofs4_get_inode(dir->i_sb, ino);
> > -	d_add(dentry, inode);
> > +	inode = dentry->d_inode;
> > +	if (inode)
> > +		d_rehash(dentry);
> > +	else {
> > +		inode = autofs4_get_inode(dir->i_sb, ino);
> > +		if (!inode) {
> > +			kfree(cp);
> > +			if (!dentry->d_fsdata)
> > +				kfree(ino);
> > +			return -ENOSPC;
> > +		}
> > +
> > +		d_add(dentry, inode);
> >  
> > -	if (dir == dir->i_sb->s_root->d_inode)
> > -		dentry->d_op = &autofs4_root_dentry_operations;
> > -	else
> > -		dentry->d_op = &autofs4_dentry_operations;
> > +		if (dir == dir->i_sb->s_root->d_inode)
> > +			dentry->d_op = &autofs4_root_dentry_operations;
> > +		else
> > +			dentry->d_op = &autofs4_dentry_operations;
> > +
> > +		dentry->d_fsdata = ino;
> > +		ino->dentry = dentry;
> > +		ino->inode = inode;
> > +	}
> > +	dget(dentry);
> >  
> > -	dentry->d_fsdata = ino;
> > -	ino->dentry = dget(dentry);
> >  	atomic_inc(&ino->count);
> >  	p_ino = autofs4_dentry_ino(dentry->d_parent);
> >  	if (p_ino && dentry->d_parent != dentry)
> >  		atomic_inc(&p_ino->count);
> > -	ino->inode = inode;
> >  
> > +	ino->u.symlink = cp;
> > +	ino->size = strlen(symname);
> >  	dir->i_mtime = CURRENT_TIME;
> 
> This all seems a bit ungainly.  I assume that on entry to
> autofs4_dir_symlink(), ino->size is equal to strlen(symname)?  If it's
> not, that strcpy() will overrun.
> 
> But if ino->size _is_ equal to strlen(symname) then why did we just
> recalculate the same thing?
> 
> I'm suspecting we can zap a lump of code and just do
> 
> 	cp = kstrdup(symname, GFP_KERNEL);
> 
> Anyway, please check that.
> 
> >  	return 0;
> > @@ -866,24 +865,38 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> >  		dentry, dentry->d_name.len, dentry->d_name.name);
> >  
> >  	ino = autofs4_init_ino(ino, sbi, S_IFDIR | 0555);
> > -	if (ino == NULL)
> > +	if (!ino)
> >  		return -ENOSPC;
> 
> ENOMEM?
> 
> > -	inode = autofs4_get_inode(dir->i_sb, ino);
> > -	d_add(dentry, inode);
> > +	inode = dentry->d_inode;
> > +	if (inode)
> > +		d_rehash(dentry);
> > +	else {
> > +		inode = autofs4_get_inode(dir->i_sb, ino);
> > +		if (!inode) {
> > +			if (!dentry->d_fsdata)
> > +				kfree(ino);
> > +			return -ENOSPC;
> > +		}
> >  
> > -	if (dir == dir->i_sb->s_root->d_inode)
> > -		dentry->d_op = &autofs4_root_dentry_operations;
> > -	else
> > -		dentry->d_op = &autofs4_dentry_operations;
> > +		d_add(dentry, inode);
> > +
> > +		if (dir == dir->i_sb->s_root->d_inode)
> > +			dentry->d_op = &autofs4_root_dentry_operations;
> > +		else
> > +			dentry->d_op = &autofs4_dentry_operations;
> > +
> > +		dentry->d_fsdata = ino;
> > +		ino->dentry = dentry;
> > +		ino->inode = inode;
> > +	}
> > +	dget(dentry);
> 
> This all looks very similar to the code in autofs4_dir_symlink().  Some
> refactoring might be needed at some stage?
> 
> > -	dentry->d_fsdata = ino;
> > -	ino->dentry = dget(dentry);
> >  	atomic_inc(&ino->count);
> >  	p_ino = autofs4_dentry_ino(dentry->d_parent);
> >  	if (p_ino && dentry->d_parent != dentry)
> >  		atomic_inc(&p_ino->count);
> > -	ino->inode = inode;
> > +
> >  	inc_nlink(dir);
> >  	dir->i_mtime = CURRENT_TIME;
> >  
> > 

