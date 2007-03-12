Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXCLElg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXCLElg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 00:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965111AbXCLElg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 00:41:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51312 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965105AbXCLElf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 00:41:35 -0400
Date: Mon, 12 Mar 2007 15:41:17 +1100
From: David Chinner <dgc@sgi.com>
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com, ecashin@coraid.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: use xfs_get_buf_noaddr for iclogs
Message-ID: <20070312044117.GK6095633@melbourne.sgi.com>
References: <20070307101314.GB30587@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307101314.GB30587@lst.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:13:14AM +0100, Christoph Hellwig wrote:
> xfs_buf_get_noaddr.  There's a subtile change because
> xfs_buf_get_empty returns the buffer locked, but xfs_buf_get_noaddr
> returns it unlocked.  From my auditing and testing nothing in the
> log I/O code cares about this distincition, but I'd be happy if
> someone could try to prove this independently.

Looks safe to me - we initialise all the fields in the xfs_buf_t
when we allocate out of the slab, so it doesn't really matter what
state the buffer is in when we free it.

OTOH, all other buffers are supposed to be locked when under I/O.
This change makes a special case for the log buffers, and I'd prefer
not to have to remember that this behaviour changed fo log buffers
at some point in time.

I suggest that adding:

> -		iclog->hic_data = (xlog_in_core_2_t *)
> -			  kmem_zalloc(iclogsize, KM_SLEEP | KM_LARGE);
> -
>  		iclog->ic_prev = prev_iclog;
>  		prev_iclog = iclog;
> +
> +		bp = xfs_buf_get_noaddr(log->l_iclog_size, mp->m_logdev_targp);
> +		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
> +		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
> +		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);

+		XFS_BUF_PSEMA(bp, PRIBIO);

> +		iclog->ic_bp = bp;
> +		iclog->hic_data = bp->b_addr;
> +
>  		log->l_iclog_bak[i] = (xfs_caddr_t)&(iclog->ic_header);
>  
>  		head = &iclog->ic_header;

To lock the buffer should be added here. That way we don't change
any semantics of the code at all.

> @@ -1216,11 +1221,6 @@
>  		INT_SET(head->h_fmt, ARCH_CONVERT, XLOG_FMT);
>  		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
>  
> -		bp = xfs_buf_get_empty(log->l_iclog_size, mp->m_logdev_targp);
> -		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
> -		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
> -		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
> -		iclog->ic_bp = bp;
>  
>  		iclog->ic_size = XFS_BUF_SIZE(bp) - log->l_iclog_hsize;
>  		iclog->ic_state = XLOG_STATE_ACTIVE;
> @@ -1229,7 +1229,6 @@
>  		iclog->ic_datap = (char *)iclog->hic_data + log->l_iclog_hsize;
>  
>  		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
> -		ASSERT(XFS_BUF_VALUSEMA(iclog->ic_bp) <= 0);

And this assert can then stay...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
