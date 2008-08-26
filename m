Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbYHZUNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbYHZUNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYHZUNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:13:35 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:59600 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYHZUNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ENmDxjlLKd9RIxmT1MxU2sTJZvcrKgbPgdDRMoXv3kcu4Yf39gX0svrig4s5mnKlT0
         MmPnwrlXEUbvGFGD0Ex+ISrRLt7SykKkvdQ9Vd8p/r+M2ydvD5hqwxmfq4OTQ0GJgObF
         54+a5FchSc5zjz/HdA2MO/2lHEi4WSVn2Qu+A=
Message-ID: <6278d2220808261313ve58a692r38c913356ee135e2@mail.gmail.com>
Date: Tue, 26 Aug 2008 21:13:33 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Dave Chinner" <david@fromorbit.com>
Subject: Re: [2.6.27-rc4] XFS i_lock vs i_iolock...
Cc: "Christoph Hellwig" <hch@lst.de>, "Peter Zijlstra" <peterz@infradead.org>,
       "Lachlan McIlroy" <lachlan@sgi.com>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
In-Reply-To: <20080826024547.GX5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com>
	 <20080825010213.GO5706@disturbed> <48B21507.9050708@sgi.com>
	 <20080825035542.GR5706@disturbed> <1219647573.20732.28.camel@twins>
	 <20080825215532.GB28188@lst.de> <20080826024547.GX5706@disturbed>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Tue, Aug 26, 2008 at 3:45 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Aug 25, 2008 at 11:55:32PM +0200, Christoph Hellwig wrote:
>> On Mon, Aug 25, 2008 at 08:59:33AM +0200, Peter Zijlstra wrote:
>> > How can you take two locks in one go? It seems to me you always need to
>> > take them one after another, and as soon as you do that, you have
>> > ordering constraints.
>>
>> Yes, you would.  Except that in all other places we only have a single
>> iolock involved, so the ordering of the second iolock and second ilock
>> don't matter.
>>
>> Because of that I think declaring that xfs_lock_two_inodes can just
>> lock on lock type at a time might be the better solution.
>
> Agreed. Patch below.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> XFS: prevent lockdep false positives when locking two inodes
>
> If we call xfs_lock_two_inodes() to grab both the iolock and
> the ilock, then drop the ilocks on both inodes, then grab
> them again (as xfs_swap_extents() does) then lockdep will
> report a locking order problem. This is a false positive.
>
> To avoid this, disallow xfs_lock_two_inodes() fom locking both
> inode locks at once - force calers to make two separate calls.
> This means that nested dropping and regaining of the ilocks
> will retain the same lockdep subclass and so lockdep will
> not see anything wrong with this code.
>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_dfrag.c    |    9 ++++++++-
>  fs/xfs/xfs_vnodeops.c |   10 ++++++++++
>  2 files changed, 18 insertions(+), 1 deletions(-)
>
> diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
> index 760f4c5..75b0cd4 100644
> --- a/fs/xfs/xfs_dfrag.c
> +++ b/fs/xfs/xfs_dfrag.c
> @@ -149,7 +149,14 @@ xfs_swap_extents(
>
>        sbp = &sxp->sx_stat;
>
> -       xfs_lock_two_inodes(ip, tip, lock_flags);
> +       /*
> +        * we have to do two separate lock calls here to keep lockdep
> +        * happy. If we try to get all the locks in one call, lock will
> +        * report false positives when we drop the ILOCK and regain them
> +        * below.
> +        */
> +       xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
> +       xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
>        locked = 1;
>
>        /* Verify that both files have the same format */
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index f108102..cb1b5fd 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -1836,6 +1836,12 @@ again:
>  #endif
>  }
>
> +/*
> + * xfs_lock_two_inodes() can only be used to lock one type of lock
> + * at a time - the iolock or the ilock, but not both at once. If
> + * we lock both at once, lockdep will report false positives saying
> + * we have violated locking orders.
> + */
>  void
>  xfs_lock_two_inodes(
>        xfs_inode_t             *ip0,
> @@ -1846,7 +1852,11 @@ xfs_lock_two_inodes(
>        int                     attempts = 0;
>        xfs_log_item_t          *lp;
>
> +#ifdef DEBUG
> +       if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
> +               ASSERT((lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)) == 0);
>        ASSERT(ip0->i_ino != ip1->i_ino);
> +#endif
>
>        if (ip0->i_ino > ip1->i_ino) {
>                temp = ip0;

Good to get your patch and HCH's ack...thanks!

I'll pursue testing and touchdown in < 24 hrs.

Daniel
-- 
Daniel J Blueman
