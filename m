Return-Path: <linux-kernel-owner+w=401wt.eu-S1764202AbXF1DuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764202AbXF1DuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761826AbXF1DuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:50:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46962 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759575AbXF1DuG (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:50:06 -0400
Date: Thu, 28 Jun 2007 13:49:57 +1000
From: David Chinner <dgc@sgi.com>
To: mmarek@suse.cz
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and XFS_IOC_FSINUMBERS in compat mode
Message-ID: <20070628034957.GE989688@sgi.com>
References: <20070619132549.266927601@suse.cz> <20070619132726.893544847@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619132726.893544847@suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 03:25:52PM +0200, mmarek@suse.cz wrote:
> * 32bit struct xfs_fsop_bulkreq has different size and layout of
>   members, no matter the alignment. Move the code out of the #else
>   branch (why was it there in the first place?). Define _32 variants of
>   the ioctl constants.
> * 32bit struct xfs_bstat is different because of time_t and on
>   i386 becaus of different padding. Create a new formatter
>   xfs_bulkstat_one_compat() that takes care of this. To do this, we need
>   to make xfs_bulkstat_one_iget() and xfs_bulkstat_one_dinode()
>   non-static.
> * i386 struct xfs_inogrp has different padding. Introduce a similar
>   "formatter" mechanism for xfs_inumbers: the native formatter is just a
>   copy_to_user, the compat formatter takes care of the different layout

Oh, wow, that is so much nicer than the first version, Michal. ;)

Still, I think there's possibly one further revision:

> +static int xfs_bulkstat_one_compat(
> +	xfs_mount_t	*mp,		/* mount point for filesystem */
> +	xfs_ino_t	ino,		/* inode number to get data for */
> +	void		__user *buffer,	/* buffer to place output in */
> +	int		ubsize,		/* size of buffer */
> +	void		*private_data,	/* my private data */
> +	xfs_daddr_t	bno,		/* starting bno of inode cluster */
> +	int		*ubused,	/* bytes used by me */
> +	void		*dibuff,	/* on-disk inode buffer */
> +	int		*stat)		/* BULKSTAT_RV_... */

Hmmm - this is almost all duplicated code. It's pretty much what I
described, but maybe not /quite/ what I had in mind here. It's a
*big* improvement on the first version, but it seems now that the
only real difference xfs_bulkstat_one() and
xfs_bulkstat_one_compat() is copy_to_user() vs the discrete put_user
calls.

I think we can remove xfs_bulkstat_one_compat() completely by using
the same method you used with the xfs_inumber_fmt functions. That
would mean the only duplicated code is the initial ioctl handling
(which we can't really avoid). It would also mean that there is no
need to make xfs_bulkstat_one_iget() and xfs_bulkstat_one_dinode()
non-static. Your thoughts?

Other than that possible improvement, this looks really good.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
