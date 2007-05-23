Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbXEWKK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbXEWKK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760873AbXEWKKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:10:05 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:46639 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765598AbXEWKKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:10:01 -0400
To: viro@ftp.linux.org.uk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-reply-to: <20070523095127.GQ4095@ftp.linux.org.uk> (message from Al Viro on
	Wed, 23 May 2007 10:51:27 +0100)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070523095127.GQ4095@ftp.linux.org.uk>
Message-Id: <E1HqnmR-0001dI-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 May 2007 12:09:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > + * This is called if the object has no ->lookup() defined, yet the
> > + * path contains a slash after the object name.
> > + *
> > + * If the filesystem defines an ->enter() method, this will be called,
> > + * and the filesystem shall fill the supplied struct path or return an
> > + * error.
> > + *
> > + * The returned path will be bind mounted on top of the object with
> > + * the MNT_DIRONFILE flag, and the nameidata will descend into the
> > + * mount.
> > + */
> > +static int enter_file(struct inode *inode, struct nameidata *nd)
> > +{
> > +	int err;
> > +	struct path newpath;
> > +
> > +	printk(KERN_DEBUG "%s/%d enter %s/\n", current->comm, current->pid,
> > +	       nd->dentry->d_name.name);
> > +	if (!inode->i_op->enter)
> > +		return -ENOTDIR;
> > +
> > +	newpath.mnt = NULL;
> > +	newpath.dentry = NULL;
> > +	err = inode->i_op->enter(nd, &newpath);
> > +	if (!err) {
> > +		err = mount_dironfile(nd, &newpath);
> > +		pathput(&newpath);
> > +	}
> > +	return err;
> 
> Ouch.  What guarantees that two lookups won't race right here?  You are
> not holding any locks at that point, AFAICS...

Right.  After locking vfsmount_lock, mount_dironfile() should recheck
if there was a race and bail out.

> BTW, why newpath?  What's wrong with simply returning a new vfsmount
> with right ->mnt_root/->mnt_sb (instead of creating it inside
> mount_dironfile())?  ERR_PTR() for error, struct vfsmount * for success...

I don't think the filesystem ought to try _creating_ a vfsmount.  I
imagine, that the fs has already a kernel-internal mounted for this
kind of stuff, and it just supplies a dentry from that.  The vfsmount
isn't actually important, but it should be readily available, and it's
easier to clone from a vfsmount/dentry pair.

> > @@ -301,8 +310,8 @@ static struct vfsmount *clone_mnt(struct
> >  	mnt->mnt_mountpoint = mnt->mnt_root;
> >  	mnt->mnt_parent = mnt;
> >  
> > -	/* don't copy the MNT_USER flag */
> > -	mnt->mnt_flags &= ~MNT_USER;
> > +	/* don't copy some flags */
> > +	mnt->mnt_flags &= ~(MNT_USER | MNT_DIRONFILE);
> >  	if (flag & CL_SETUSER)
> >  		__set_mnt_user(mnt, owner);
> 
> Hmm?  So you do copy them and strip your MNT_DIRONFILE from copies?

Yes.  On namespace cloning the MNT_DIRONFILE will be re-added later.
Otherwise we shouln't even get here with MNT_DIRONFILE.

> > + * This is tricky, because for namespace modification we must take the
> > + * namespace semaphore.  But mntput() is called from various places,
> > + * sometimes with namespace_sem held.  Fortunately in those places the
> > + * mount cannot yet have MNT_DIRONFILE, or at least that's what I
> > + * hope...
> > + *
> > + * The umounting is done in two stages, first the mount is removed
> > + * from the hashes.  This is done atomically wrt other mount lookups,
> > + * so it's not possible to acquire a new ref to this dead mount that
> > + * way.
> > + *
> > + * Then after having locked namespace_sem and relocked vfsmount_lock,
> > + * the mount is properly detached.
> > + */
> > +static void umount_dironfile(struct vfsmount *mnt)
> > +	__releases(vfsmount_lock)
> > +{
> > +	struct nameidata nd;
> 
> You've got to be kidding.  nameidata is *big*.  If anything, we want
> to make detach_mnt() take struct path * instead, but even that is
> lousy due to recursion.
> 
> I really don't like what's going on here.  The thing is, current code
> is based on assumption that presence in the mount tree => holding a
> reference.  We _might_ deal with that (there was an old plan to change
> refcounting logics for vfsmounts), but that sort of games with locks
> spells trouble.  What happens, for example, if namespace gets cloned
> before you grab namespace_sem?

It _should_ work.  The mount in the new namespace will be created
(with namespace_sem held, so we can't yet free this mount), and then
dropped, because there are no refs to it.

> There's another problem, BTW - a lot of stuff does stat + open + fstat +
> compare kind of sequence.  You'll end up mounting/umounting between stat
> and open, which opens you to race with somebody else.  Get a different
> st_dev, eat a nice unreproducible error from application...

As I said, the superblock should be persistent, so we'll get a stable
st_dev for multiple mounts.

Miklos
