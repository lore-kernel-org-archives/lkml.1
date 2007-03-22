Return-Path: <linux-kernel-owner+w=401wt.eu-S934185AbXCVSqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934185AbXCVSqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934189AbXCVSqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:46:21 -0400
Received: from brick.kernel.dk ([62.242.22.158]:12124 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934185AbXCVSqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:46:20 -0400
Date: Thu, 22 Mar 2007 19:42:35 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dale Blount <linux-kernel@dale.us>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: null pointer dereference in cfq_dispatch_requests (2.6.21-rc2 and 2.6.20)
Message-ID: <20070322184235.GZ19922@kernel.dk>
References: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com> <200703011308.28266.linux@f-seidel.de> <20070301123057.GO23985@kernel.dk> <loom.20070321T135132-397@post.gmane.org> <20070321190359.GD16768@leiferikson>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321190359.GD16768@leiferikson>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21 2007, Johannes Weiner wrote:
> Hi,
> 
> I think I found where the NULL may come from.  Please, anybody, do not
> apply this patch before a trustful person reviewed it... Jens? ;)
> 
> My thoughts on this are, that there are two possibilities cfqq->next_rq
> could be NULL: End of list or a bug when it is set (or not set).
> But why does RB_EMPTY_ROOT() as last call in this loop does not trigger?
> 
> Did I even get the right place on where the NULL pointer dereference
> happens? :)
> 
> =Hannes
> 
> Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>

> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index b6491c0..ca84f0b 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -961,8 +961,8 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  		/*
>  		 * follow expired path, else get first next available
>  		 */
> -		if ((rq = cfq_check_fifo(cfqq)) == NULL)
> -			rq = cfqq->next_rq;
> +		if (!(rq = cfq_check_fifo(cfqq)) && !(rq = cfqq->next_rq))
> +			break;

That still only hides a bug. It is illegal for ->next_rq to be NULL
while the RB tree is non-empty.


-- 
Jens Axboe

