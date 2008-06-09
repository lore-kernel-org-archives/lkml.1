Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYFISgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYFISgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYFISg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:36:29 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51095 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYFISg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:36:28 -0400
Date: Mon, 9 Jun 2008 13:37:49 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Willy Tarreau <w@1wt.eu>, stable@kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Missing patch from stable [3/7]
Message-ID: <20080609183749.GD6836@halcrowt61p.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080608085923.GC6439@1wt.eu> <1212923462.4020.224.camel@tucsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212923462.4020.224.camel@tucsk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 01:11:02PM +0200, Miklos Szeredi wrote:
> On Sun, 2008-06-08 at 10:59 +0200, Willy Tarreau wrote:
> Thanks for picking up these ecryptfs patches ...but they hardly meet
> _any_ of the -stable rules.  In particular:
> 
>  - It must be obviously correct and tested.
> 
> It's obvious, but I don't know if it's been tested (or even looked
> at by the maintainer).

I see no obvious problems with these patches. I have tested with the
four eCryptfs patches in this thread applied to 2.6.25.5.

>  - It must fix a problem that causes a build error (but not for
>    things marked CONFIG_BROKEN), an oops, a hang, data corruption, a
>    real security issue, or some "oh, that's not good" issue.  In
>    short, something critical.
> 
> Not critical at all.

I am under the impression that bugs that could result in hangs or data
corruption are, by definition, critical.

>  - No "theoretical race condition" issues, unless an explanation of
>    how the race can be exploited is also provided.
> 
> It's theoretical, I have no idea how it's exploitable, if at all.

Exploits can be subtle, so I would be more comfortable with
eliminating known race conditions.

While I agree that "EXPERIMENTAL" features should be less likely to
receive updates in -stable, the experimental status of a feature
should not categorically exclude fixes from getting in. The
experimental status should just be one of the factors used in deciding
whether it is worth the effort.

Mike

> > --
> > 
> > From 8dc4e37362a5dc910d704d52ac6542bfd49ddc2f Mon Sep 17 00:00:00 2001
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > Date: Mon, 12 May 2008 14:02:04 -0700
> > Subject: ecryptfs: clean up (un)lock_parent
> > 
> > dget(dentry->d_parent) --> dget_parent(dentry)
> > 
> > unlock_parent() is racy and unnecessary.  Replace single caller with
> > unlock_dir().
> > 
> > There are several other suspect uses of ->d_parent in ecryptfs...
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > Cc: Michael Halcrow <mhalcrow@us.ibm.com>
> > Cc: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > ---
> >  fs/ecryptfs/inode.c |   13 ++++---------
> >  1 files changed, 4 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> > index 0a13973..c92cc1c 100644
> > --- a/fs/ecryptfs/inode.c
> > +++ b/fs/ecryptfs/inode.c
> > @@ -37,17 +37,11 @@ static struct dentry *lock_parent(struct dentry *dentry)
> >  {
> >  	struct dentry *dir;
> >  
> > -	dir = dget(dentry->d_parent);
> > +	dir = dget_parent(dentry);
> >  	mutex_lock_nested(&(dir->d_inode->i_mutex), I_MUTEX_PARENT);
> >  	return dir;
> >  }
> >  
> > -static void unlock_parent(struct dentry *dentry)
> > -{
> > -	mutex_unlock(&(dentry->d_parent->d_inode->i_mutex));
> > -	dput(dentry->d_parent);
> > -}
> > -
> >  static void unlock_dir(struct dentry *dir)
> >  {
> >  	mutex_unlock(&dir->d_inode->i_mutex);
> > @@ -426,8 +420,9 @@ static int ecryptfs_unlink(struct inode *dir, struct dentry *dentry)
> >  	int rc = 0;
> >  	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
> >  	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
> > +	struct dentry *lower_dir_dentry;
> >  
> > -	lock_parent(lower_dentry);
> > +	lower_dir_dentry = lock_parent(lower_dentry);
> >  	rc = vfs_unlink(lower_dir_inode, lower_dentry);
> >  	if (rc) {
> >  		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
> > @@ -439,7 +434,7 @@ static int ecryptfs_unlink(struct inode *dir, struct dentry *dentry)
> >  	dentry->d_inode->i_ctime = dir->i_ctime;
> >  	d_drop(dentry);
> >  out_unlock:
> > -	unlock_parent(lower_dentry);
> > +	unlock_dir(lower_dir_dentry);
> >  	return rc;
> >  }
> >  
> 
