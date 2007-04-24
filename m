Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbXDXUqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbXDXUqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXDXUqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:46:16 -0400
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83]:36889 "EHLO
	pne-smtpout1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754646AbXDXUqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:46:15 -0400
Date: Tue, 24 Apr 2007 22:46:09 +0200 (CEST)
From: Peter Osterlund <petero2@telia.com>
X-X-Sender: petero@p4.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: William Heimbigner <icxcnika@mar.tar.cc>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: Null pointer dereference in fs/open.c
In-Reply-To: <20070423215810.5a24ed9a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704242231270.5493@p4.localdomain>
References: <Pine.LNX.4.64.0704222310030.25153@server.thyself>
 <20070423010032.c89e8d32.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231356480.25153@server.thyself>
 <Pine.LNX.4.64.0704231633210.25153@server.thyself>
 <Pine.LNX.4.64.0704240347470.25153@server.thyself>
 <20070423215810.5a24ed9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Andrew Morton wrote:

> Try this:
>
> --- a/drivers/block/pktcdvd.c~packet-fix-error-handling
> +++ a/drivers/block/pktcdvd.c
> @@ -777,7 +777,8 @@ static int pkt_generic_packet(struct pkt
> 		rq->cmd_flags |= REQ_QUIET;
>
> 	blk_execute_rq(rq->q, pd->bdev->bd_disk, rq, 0);
> -	ret = rq->errors;
> +	if (rq->errors)
> +		ret = -EIO;
> out:
> 	blk_put_request(rq);
> 	return ret;
> _
>
>
> The packet driver was assuming that request.errors is an errno, but it
> isn't - it's some sort of diagnostic bitfield thing.  Now why would the
> packet driver have though that?  Let's go read the comments:
...
> Well there's your root cause right there.
>
> I don't know why this wasn't oopsing in eariler kernels.  Perhaps something
> else is broken.  Please test this urgently.

The code used to return -EIO until commit 
406c9b605cbc45151c03ac9a3f95e9acf050808c, which was commited 2007-01-05, 
so that would explain why older kernels didn't crash.

> What the heck _is_ in request.errors?

According to linux/Documentation/block/request.txt, it is an error 
counter. The info in that text file would probably do a lot more good as 
comments in the structure definition though.

> Should the packet driver even be looking at it?

I think so. How else is it supposed to know if the request failed?

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
