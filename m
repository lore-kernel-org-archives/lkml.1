Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbXKWRk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbXKWRk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 12:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXKWRkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 12:40:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55964 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbXKWRkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 12:40:17 -0500
Date: Fri, 23 Nov 2007 17:40:13 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] Factor common inode cluster buffer lookup code
Message-ID: <20071123174013.GB12227@infradead.org>
References: <20071122003642.GJ114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122003642.GJ114266761@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 11:36:42AM +1100, David Chinner wrote:
> +STATIC int
> +xfs_ino_to_imap(
> +	xfs_mount_t	*mp,
> +	xfs_trans_t	*tp,
> +	xfs_ino_t	ino,
> +	xfs_imap_t	*imap,
> +	uint		imap_flags)
> +{
> +	int		error;
> +
> +	error = xfs_imap(mp, tp, ino, imap, imap_flags);
> +	if (error) {
> +		cmn_err(CE_WARN, "xfs_ino_to_imap: xfs_imap()  returned an "
> +				"error %d on %s.  Returning error.",
> +				error, mp->m_fsname);
> +		return error;
> +	}
> +
> +	/*
> +	 * If the inode number maps to a block outside the bounds
> +	 * of the file system then return NULL rather than calling
> +	 * read_buf and panicing when we get an error from the
> +	 * driver.
> +	 */
> +	if ((imap->im_blkno + imap->im_len) >
> +	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
> +		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_ino_to_imap: "
> +			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
> +			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
> +			(unsigned long long) imap->im_blkno,
> +			(unsigned long long) imap->im_len,
> +			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
> +		return XFS_ERROR(EINVAL);
> +	}

What about just adding this verification to xfs_imap instead of creating
this wrapper for two of it's three callers?

Otherwise this patch looks fine to me.
