Return-Path: <linux-kernel-owner+w=401wt.eu-S1765610AbZCaXmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765610AbZCaXmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764585AbZCaXha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:37:30 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:24622 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764776AbZCaXh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:37:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADdG0kl5LJex/2dsb2JhbADOR4N6Bg
X-IronPort-AV: E=Sophos;i="4.39,304,1235914200"; 
   d="scan'208";a="322652635"
Date: Wed, 1 Apr 2009 10:37:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, tj@kernel.org, bzolnier@gmail.com
Subject: Re: [PATCH 6/7] xfs: propagate issue-flush error code
Message-ID: <20090331233718.GT26138@disturbed>
Mail-Followup-To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Jeff Garzik <jeff@garzik.org>,
	Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, David Rees <drees76@gmail.com>,
	Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	chris.mason@oracle.com, tj@kernel.org, bzolnier@gmail.com
References: <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0BC0A.9050909@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49D0BC0A.9050909@oss.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 09:33:14PM +0900, Fernando Luis Vázquez Cao wrote:
> blkdev_issue_flush() may fail (i.e. due to media error on FLUSH CACHE
> command execution) so its users should check for the return value.
>
> (This issues was first spotted Bartlomiej Zolnierkiewicz)
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

I think this patch is unnecessary as well as being broken.


> diff -urNp linux-2.6.29-orig/fs/xfs/xfs_vnodeops.c linux-2.6.29/fs/xfs/xfs_vnodeops.c
> --- linux-2.6.29-orig/fs/xfs/xfs_vnodeops.c	2009-03-24 08:12:14.000000000 +0900
> +++ linux-2.6.29/fs/xfs/xfs_vnodeops.c	2009-03-30 15:08:21.000000000 +0900
> @@ -678,20 +678,20 @@ xfs_fsync(
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	}
>
> -	if ((ip->i_mount->m_flags & XFS_MOUNT_BARRIER) && changed) {
> +	if (!error && (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) && changed) {

That is wrong. Even if there was a error, we still need to
flush the device if it hasn't already been done.

>  		/*
>  		 * If the log write didn't issue an ordered tag we need
>  		 * to flush the disk cache for the data device now.
>  		 */
>  		if (!log_flushed)
> -			xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);
> +			error = xfs_blkdev_issue_flush(ip->i_mount->m_ddev_targp);

What happens if we get an EOPNOTSUPP here?
That is a meaningless error to return to fsync()....


>  		/*
>  		 * If this inode is on the RT dev we need to flush that
>  		 * cache as well.
>  		 */
> -		if (XFS_IS_REALTIME_INODE(ip))
> -			xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);
> +		if (!error && XFS_IS_REALTIME_INODE(ip))
> +			error = xfs_blkdev_issue_flush(ip->i_mount->m_rtdev_targp);

That is broken, too. The realtime device is a different device,
so always should be flushed regardless of the return from the
log device.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
