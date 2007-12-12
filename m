Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbXLLQIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbXLLQIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbXLLQIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:08:15 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:47239 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbXLLQIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:08:14 -0500
Message-ID: <47600715.9000303@panasas.com>
Date: Wed, 12 Dec 2007 18:06:45 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] REQ-flags to/from BIO-flags bugfix
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <47462F3C.3040700@googlemail.com> <20071122201250.f957e280.akpm@linux-foundation.org> <47466B5D.90607@googlemail.com> <20071126221509.8f437b61.akpm@linux-foundation.org> <1197390783.3812.19.camel@localhost.localdomain> <475FB316.6040804@panasas.com> <475FBFEE.9010009@panasas.com> <20071212151813.GJ26334@parisc-linux.org>
In-Reply-To: <20071212151813.GJ26334@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12 2007 at 17:18 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Dec 12, 2007 at 01:03:10PM +0200, Boaz Harrosh wrote:
>>  - BIO flags bio->bi_rw and REQ flags req->cmd_flags no longer match.
>>    Remove comments and do a proper translation between the 2 systems.
> 
> I'd rather see them resynchronised ... in a way that makes it obvious
> that they should be desynced again:
> 
> I don't know whether BIO_RW_BARRIER is __REQ_SOFTBARRIER or
> __REQ_HARDBARRIER, so I didn't include that in this patch.  There also
> doesn't seem to be a __REQ equivalent to BIO_RW_AHEAD, but we can do
> the other four bits (and leave gaps for those two).
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index d18ee67..6aef34b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -167,11 +167,13 @@ enum {
>  };
>  
>  /*
> - * request type modified bits. first three bits match BIO_RW* bits, important
> + * request type modified bits.  Don't change without looking at bi_rw flags
>   */
>  enum rq_flag_bits {
> -	__REQ_RW,		/* not set, read. set, write */
> -	__REQ_FAILFAST,		/* no low level driver retries */
> +	__REQ_RW = BIO_RW,	/* not set, read. set, write */
> +	__REQ_FAILFAST = BIO_RW_FAILFAST, /* no low level driver retries */
> +	__REQ_RW_SYNC = BIO_RW_SYNC,	/* request is sync (O_DIRECT) */
> +	__REQ_RW_META = BIO_RW_META,	/* metadata io request */
>  	__REQ_SORTED,		/* elevator knows about this request */
>  	__REQ_SOFTBARRIER,	/* may not be passed by ioscheduler */
>  	__REQ_HARDBARRIER,	/* may not be passed by drive either */
> @@ -185,9 +187,7 @@ enum rq_flag_bits {
>  	__REQ_QUIET,		/* don't worry about errors */
>  	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
>  	__REQ_ORDERED_COLOR,	/* is before or after barrier */
> -	__REQ_RW_SYNC,		/* request is sync (O_DIRECT) */
>  	__REQ_ALLOCED,		/* request came from our alloc pool */
> -	__REQ_RW_META,		/* metadata io request */
>  	__REQ_NR_BITS,		/* stops here */
>  };
>  
> 
Thats not enough You still need to fix code in ll_rw_blk(), I would
define a rq_flags_bio_match_mask = 0xf for that. 
(and also add what Jens called "needed" with the
BIO_RW_AHEAD selects REQ_FAILFAST.)

And I still don't understand why, for example, "Domain Validation" fails
with the original patch. What sets BIO_RW_FAILFAST and than panics
on Errors?
(All I see is this flag set in dm/multipath.c & dm-mpath.c)

Boaz

