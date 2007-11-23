Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbXKWRvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbXKWRvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 12:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbXKWRu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 12:50:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33899 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbXKWRu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 12:50:57 -0500
Date: Fri, 23 Nov 2007 17:50:53 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] Don't block pdflush when flushing inodes
Message-ID: <20071123175053.GA12649@infradead.org>
References: <20071122003817.GK114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122003817.GK114266761@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-11-22 10:33:51.037704348 +1100
> @@ -183,12 +183,20 @@ xfs_imap_to_bp(
>  	int		ni;
>  	xfs_buf_t	*bp;
>  
> +	if (buf_flags == 0)
> +		buf_flags = XFS_BUF_LOCK;

There's just two caller and they never pass 0, so this is not needed.

> +	error = xfs_itobp_flags(mp, NULL, ip, &dip, &bp, 0, 0,
> +				(noblock) ? XFS_BUF_TRYLOCK : XFS_BUF_LOCK);

no need for the braces around noblock.

> +int		xfs_itobp_flags(struct xfs_mount *, struct xfs_trans *,
>  			  xfs_inode_t *, struct xfs_dinode **, struct xfs_buf **,
> -			  xfs_daddr_t, uint);
> +			  xfs_daddr_t, uint, uint);
> +#define xfs_itobp(mp, tp, ip, dipp, bpp, bno, iflags)	\
> +	xfs_itobp_flags(mp, tp, ip, dipp, bpp, bno, iflags, XFS_BUF_LOCK)

I'd say just convert xfs_itobp and all it's user to take the additional
argument.

