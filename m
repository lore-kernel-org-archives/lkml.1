Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZGPH6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZGPH6C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 03:58:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZGPH6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 03:58:01 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:32851
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751306AbZGPH6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 03:58:00 -0400
Message-ID: <4A5EDD81.6060409@panasas.com>
Date: Thu, 16 Jul 2009 10:57:53 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH #tj-block-for-linus] block: fix failfast merge testing
 in elv_rq_merge_ok()
References: <4A5ECC62.7050607@kernel.org>
In-Reply-To: <4A5ECC62.7050607@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 07:57:56.0457 (UTC) FILETIME=[211E5590:01CA05EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2009 09:44 AM, Tejun Heo wrote:
> Commit ab0fd1debe730ec9998678a0c53caefbd121ed10 tries to prevent merge
> of requests with different failfast settings.  In elv_rq_merge_ok(),
> it compares new bio's failfast flags against the merge target
> request's.  However, the flag testing accessors for bio and blk don't
> return boolean but the tested bit value directly and FAILFAST on bio
> and blk don't match, so directly comparing them with == results in
> false negative unnecessary preventing merge of readahead requests.
> 
> This patch convert the results to boolean by negating them before
> comparison.

I don't like that at all. Please fix the accessors to return
boolean. They look and regarded as boolean. I've never seen
them used as their bit value.

if you are concerned with performance don't
an if(flag & bit) is even slightly slower then
   if(0 != (flag & bit)) on some processors

> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Jeff Garzik <jeff@garzik.org>
> ---
> Eh... talk about being obscure. :-( I've put this onto the following
> temp block tree I'm running and will push toward Linus in a few days.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-block-for-linus
> 
> Thanks.
> 
>  block/elevator.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/block/elevator.c b/block/elevator.c
> index 6f23753..977aa7c 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -103,9 +103,9 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
>  	/*
>  	 * Don't merge if failfast settings don't match
>  	 */
> -	if (bio_failfast_dev(bio)	!= blk_failfast_dev(rq)		||
> -	    bio_failfast_transport(bio)	!= blk_failfast_transport(rq)	||
> -	    bio_failfast_driver(bio)	!= blk_failfast_driver(rq))
> +	if (!bio_failfast_dev(bio)	 != !blk_failfast_dev(rq)	||
> +	    !bio_failfast_transport(bio) != !blk_failfast_transport(rq)	||
> +	    !bio_failfast_driver(bio)	 != !blk_failfast_driver(rq))
>  		return 0;
> 
>  	if (!elv_iosched_allow_merge(rq, bio))

Boaz
