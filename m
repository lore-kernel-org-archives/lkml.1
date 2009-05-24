Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbZEXWDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbZEXWDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZEXWDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:03:40 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:40473 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZEXWDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L0S5VeYpl47hCZZmv1QP74uVPXQXOLpQVs9ZxNYrGcEZkKa76jq7eVz55EmAnoo3td
         9W1nPDfhw9jMu9C+TRoEVJPVCmbXINQ/TjMdAy36GPB85BaDxovqjbRFEKcvqCNWlUC4
         0cdoj5EbkzwaTL2UmIFi6GeSX63YsLHUhOvSs=
Date: Mon, 25 May 2009 00:03:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: manual merge of the vfs tree with the  tree
Message-ID: <20090524220336.GF6471@nowhere>
References: <20090522112326.9eafa340.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522112326.9eafa340.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 11:23:26AM +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> Today's linux-next merge of the vfs tree got a conflict in
> fs/reiserfs/super.c between commit
> d38705358bf6f5ab82348d0c6ee8039cea20ce6b ("reiserfs: kill-the-BKL") from
> the reiserfs-bkl tree and commit 8123178eb9ca12cde31a95170746e15a79528a62
> ("push BKL down into ->put_super") from the vfs tree.
> 
> OK, I am not sure what is needed here, so I combined both (see below).  I
> can carry this fixup as necessary.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/reiserfs/super.c
> index b301f7d,90dcb7b..0000000
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@@ -468,13 -465,11 +465,18 @@@ static void reiserfs_put_super(struct s
>   	struct reiserfs_transaction_handle th;
>   	th.t_trans_id = 0;
>   
> + 	lock_kernel();
> + 
>  +	/*
>  +	 * We didn't need to explicitly lock here before, because put_super
>  +	 * is called with the bkl held.
>  +	 * Now that we have our own lock, we must explicitly lock.
>  +	 */
>  +	reiserfs_write_lock(s);


Hi Stephen,


I'm not sure how this conflict look like.
But yeah, you need both.

The write lock, which was the bkl before, has been placed explicitly
since the write lock is a mutex and the locking does not depend anymore
on the bkl.

I also think the bkl pushdown in reiserfs is not needed, since it now
protects itself from concurrent reiserfs_put_super() using its own lock.
But although it is not needed, it should be removed in a separate commit.

So for now, IMO you have the right fix. The end result should be:

static void reiserfs_put_super(struct super_block *s)
{
	struct reiserfs_transaction_handle th;
	th.t_trans_id = 0;

	lock_kernel();
	/*
	 * We didn't need to explicitly lock here before, because put_super
	 * is called with the bkl held.
	 * Now that we have our own lock, we must explicitly lock.
	 */
	reiserfs_write_lock(s);

	[...]

	reiserfs_write_unlock(s);
	mutex_destroy(&REISERFS_SB(s)->lock);
	kfree(s->s_fs_info);
	s->s_fs_info = NULL;

	unlock_kernel();
}




> + 	if (s->s_dirt)
> + 		reiserfs_write_super(s);



But this part seems to solve another conflict, right?
I'm not sure about it.


Frederic.


> + 
>   	/* change file system state to current state if it was mounted with read-write permissions */
>   	if (!(s->s_flags & MS_RDONLY)) {
>   		if (!journal_begin(&th, s, 10)) {

