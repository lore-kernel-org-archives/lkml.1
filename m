Return-Path: <linux-kernel-owner+w=401wt.eu-S1763756AbXEWJvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763756AbXEWJvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbXEWJv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:51:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47253 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbXEWJv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:51:28 -0400
Date: Wed, 23 May 2007 10:51:27 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070523095127.GQ4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 08:48:49PM +0200, Miklos Szeredi wrote:
>   */
> -static int __follow_mount(struct path *path)
> +static int __follow_mount(struct path *path, bool enter)
>  {
>  	int res = 0;
>  	while (d_mountpoint(path->dentry)) {
> -		struct vfsmount *mounted = lookup_mnt(path->mnt, path->dentry);
> +		struct vfsmount *mounted =
> +			lookup_mnt(path->mnt, path->dentry, enter);
> +
>  		if (!mounted)
>  			break;
>  		dput(path->dentry);
> @@ -689,27 +697,37 @@ static int __follow_mount(struct path *p
>  	return res;
>  }
>  
> -static void follow_mount(struct vfsmount **mnt, struct dentry **dentry)
> +/*
> + * Follows mounts on the given nameidata.
> + *
> + * Only follows "directory on file" mounts if LOOKUP_ENTER is set.
> + */
> +void follow_mount(struct nameidata *nd)

BTW, I'd split that (and matching updates in callers) into separate
patch.

>  {
> -	while (d_mountpoint(*dentry)) {
> -		struct vfsmount *mounted = lookup_mnt(*mnt, *dentry);
> +	while (d_mountpoint(nd->dentry)) {
> +		bool enter = nd->flags & LOOKUP_ENTER;

int, surely?

> + * This is called if the object has no ->lookup() defined, yet the
> + * path contains a slash after the object name.
> + *
> + * If the filesystem defines an ->enter() method, this will be called,
> + * and the filesystem shall fill the supplied struct path or return an
> + * error.
> + *
> + * The returned path will be bind mounted on top of the object with
> + * the MNT_DIRONFILE flag, and the nameidata will descend into the
> + * mount.
> + */
> +static int enter_file(struct inode *inode, struct nameidata *nd)
> +{
> +	int err;
> +	struct path newpath;
> +
> +	printk(KERN_DEBUG "%s/%d enter %s/\n", current->comm, current->pid,
> +	       nd->dentry->d_name.name);
> +	if (!inode->i_op->enter)
> +		return -ENOTDIR;
> +
> +	newpath.mnt = NULL;
> +	newpath.dentry = NULL;
> +	err = inode->i_op->enter(nd, &newpath);
> +	if (!err) {
> +		err = mount_dironfile(nd, &newpath);
> +		pathput(&newpath);
> +	}
> +	return err;

Ouch.  What guarantees that two lookups won't race right here?  You are
not holding any locks at that point, AFAICS...

BTW, why newpath?  What's wrong with simply returning a new vfsmount
with right ->mnt_root/->mnt_sb (instead of creating it inside
mount_dironfile())?  ERR_PTR() for error, struct vfsmount * for success...

> @@ -301,8 +310,8 @@ static struct vfsmount *clone_mnt(struct
>  	mnt->mnt_mountpoint = mnt->mnt_root;
>  	mnt->mnt_parent = mnt;
>  
> -	/* don't copy the MNT_USER flag */
> -	mnt->mnt_flags &= ~MNT_USER;
> +	/* don't copy some flags */
> +	mnt->mnt_flags &= ~(MNT_USER | MNT_DIRONFILE);
>  	if (flag & CL_SETUSER)
>  		__set_mnt_user(mnt, owner);

Hmm?  So you do copy them and strip your MNT_DIRONFILE from copies?

> + * This is tricky, because for namespace modification we must take the
> + * namespace semaphore.  But mntput() is called from various places,
> + * sometimes with namespace_sem held.  Fortunately in those places the
> + * mount cannot yet have MNT_DIRONFILE, or at least that's what I
> + * hope...
> + *
> + * The umounting is done in two stages, first the mount is removed
> + * from the hashes.  This is done atomically wrt other mount lookups,
> + * so it's not possible to acquire a new ref to this dead mount that
> + * way.
> + *
> + * Then after having locked namespace_sem and relocked vfsmount_lock,
> + * the mount is properly detached.
> + */
> +static void umount_dironfile(struct vfsmount *mnt)
> +	__releases(vfsmount_lock)
> +{
> +	struct nameidata nd;

You've got to be kidding.  nameidata is *big*.  If anything, we want
to make detach_mnt() take struct path * instead, but even that is
lousy due to recursion.

I really don't like what's going on here.  The thing is, current code
is based on assumption that presence in the mount tree => holding a
reference.  We _might_ deal with that (there was an old plan to change
refcounting logics for vfsmounts), but that sort of games with locks
spells trouble.  What happens, for example, if namespace gets cloned
before you grab namespace_sem?

There's another problem, BTW - a lot of stuff does stat + open + fstat +
compare kind of sequence.  You'll end up mounting/umounting between stat
and open, which opens you to race with somebody else.  Get a different
st_dev, eat a nice unreproducible error from application...
