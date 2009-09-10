Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZIJJHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZIJJHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 05:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZIJJHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 05:07:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbZIJJHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 05:07:19 -0400
Date: Thu, 10 Sep 2009 11:07:20 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, stable@kernel.org
Subject: Re: [PATCH] fs: Make sure data stored into inode is properly seen
	before unlocking new inode
Message-ID: <20090910090720.GD607@duck.suse.cz>
References: <1252410063-26872-1-git-send-email-jack@suse.cz> <20090909150334.68fcde88.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909150334.68fcde88.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 09-09-09 15:03:34, Andrew Morton wrote:
> On Tue,  8 Sep 2009 13:41:03 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > In theory it could happen that on one CPU we initialize a new inode but clearing
> > of I_NEW | I_LOCK gets reordered before some of the initialization. Thus on
> > another CPU we return not fully uptodate inode from iget_locked().
> > 
> > This seems to fix a corruption issue on ext3 mounted over NFS.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/inode.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> >   Since Al doesn't seem to be online, does anybody else have opinion on this
> > patch? I can merge it via my tree but I'd like to get a review from someone
> > else.
> 
> I'll merge it for 2.6.31.
  Thanks!

> Please always remember -stable kernels when preparing bugfixes!  This
> one should have had a Cc:stable in the changelog and in the email
> headers.
  Good point. Thanks for reminding.

> > diff --git a/fs/inode.c b/fs/inode.c
> > index 901bad1..e9a8e77 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -696,6 +696,7 @@ void unlock_new_inode(struct inode *inode)
> >  	 * just created it (so there can be no old holders
> >  	 * that haven't tested I_LOCK).
> >  	 */
> > +	smp_mb();
> >  	WARN_ON((inode->i_state & (I_LOCK|I_NEW)) != (I_LOCK|I_NEW));
> >  	inode->i_state &= ~(I_LOCK|I_NEW);
> >  	wake_up_inode(inode);
> 
> But an uncommented barrier is always a hard thing for a reader to
> understand.  Let's add something to help people.  How's this look?
> 
> --- a/fs/inode.c~fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix
> +++ a/fs/inode.c
> @@ -697,12 +697,13 @@ void unlock_new_inode(struct inode *inod
>  	}
>  #endif
>  	/*
> -	 * This is special!  We do not need the spinlock
> -	 * when clearing I_LOCK, because we're guaranteed
> -	 * that nobody else tries to do anything about the
> -	 * state of the inode when it is locked, as we
> -	 * just created it (so there can be no old holders
> -	 * that haven't tested I_LOCK).
> +	 * This is special!  We do not need the spinlock when clearing I_LOCK,
> +	 * because we're guaranteed that nobody else tries to do anything about
> +	 * the state of the inode when it is locked, as we just created it (so
> +	 * there can be no old holders that haven't tested I_LOCK).
> +	 * However we must emit the memory barrier so that other CPUs reliably
> +	 * see the clearing of I_LOCK after the other inode initialisation has
> +	 * completed.
>  	 */
>  	smp_mb();
>  	WARN_ON((inode->i_state & (I_LOCK|I_NEW)) != (I_LOCK|I_NEW));
  Looks good.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
