Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXDQFs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXDQFs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 01:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbXDQFs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 01:48:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60910 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750719AbXDQFs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 01:48:58 -0400
Date: Tue, 17 Apr 2007 15:50:49 +1000
From: Timothy Shimmin <tes@sgi.com>
To: xfs-masters@oss.sgi.com
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: mm snapshot broken-out-2007-04-11-02-24.tar.gz uploaded
Message-ID: <89881D4AB20BD6592A06F7A5@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070416015911.GW32602149@melbourne.sgi.com>
References: <200704110926.l3B9Qe3D000895@shell0.pdx.osdl.net> <461D22E5.9030705@googlemail.com>
 <20070411121515.56425c23.akpm@linux-foundation.org> <461D5DE3.1050300@googlemail.com>
 <20070411154204.84c97c10.akpm@linux-foundation.org> <20070416015911.GW32602149@melbourne.sgi.com>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> There's a couple of different ways I can see to fix the problem -
> the first is to not reference the buffer in xlog_iodone() after
> running the callbacks that may trigger it being freed. I'd prfer to
> see if this fixes the problem before having to do more invasive
> surgery.  Can you try the patch below to see if it fixes the
> problem?
>
>  fs/xfs/xfs_log.c |   11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-04-03 09:09:36.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-04-16 11:40:21.655306665 +1000
> @@ -988,14 +988,11 @@ xlog_iodone(xfs_buf_t *bp)
>  	} else if (iclog->ic_state & XLOG_STATE_IOERROR) {
>  		aborted = XFS_LI_ABORTED;
>  	}
> +	/* log I/O is always issued ASYNC, so we should see that here */

I guess this is a left over because at a prior time
xlog_sync() took an extra flags param (which could have XFS_LOG_SYNC set)
which could do a SYNC write of the iclog.
IIRC, we took this extra param out because nobody was ever calling with
it set for xlog_sync().

> +	WARN_ON(!(XFS_BUF_ISASYNC(bp)));
>  	xlog_state_done_syncing(iclog, aborted);
> -	if (!(XFS_BUF_ISASYNC(bp))) {
> -		/*
> -		 * Corresponding psema() will be done in bwrite().  If we don't
> -		 * vsema() here, panic.
> -		 */
> -		XFS_BUF_V_IODONESEMA(bp);
> -	}
> +	/* do not reference bp here - it may have been freed during unmount */
> +
>  }	/* xlog_iodone */
>
>  /*
>
>

--Tim


