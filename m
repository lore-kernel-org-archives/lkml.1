Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYHZGPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYHZGPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 02:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYHZGO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 02:14:57 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:37467 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751344AbYHZGO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 02:14:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rZUtknjz2P0FrHv7nE8GqagRzge39AhPlBul8pvlSOizl2JURFlvVbFC44hZkeKMGkbWa6boeiO5AcoKdY2cOsRmyQuFURVDk4yrN8cF1LfJiCR2dlG4lu0FhE8P9hv18dUvRGHXM9/6Rf5vW0pY1QEnDiR8ACRUaMTM3W7DdMQ=  ;
X-YMail-OSG: kBSZTnwVM1l_RAEdl_rGDQG5xYRlGJqKUAsQpuKLnbv_Jsu0LmkA06RfRE3MubrEttyPxmMmQzNNBvN3s8LYq5X5zVJIdy5u8VWVJLBSTIpDYcV9cMZaGoLsgTkQIqITwS9h_UgaY63fSsPiDCeN1r3M
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH 3/5] sched: make double-lock-balance fair
Date: Tue, 26 Aug 2008 16:14:49 +1000
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, srostedt@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       npiggin@suse.de, gregory.haskins@gmail.com
References: <20080825200852.23217.13842.stgit@dev.haskins.net> <20080825201534.23217.14936.stgit@dev.haskins.net>
In-Reply-To: <20080825201534.23217.14936.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261614.49662.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008 06:15, Gregory Haskins wrote:
> double_lock balance() currently favors logically lower cpus since they
> often do not have to release their own lock to acquire a second lock.
> The result is that logically higher cpus can get starved when there is
> a lot of pressure on the RQs.  This can result in higher latencies on
> higher cpu-ids.
>
> This patch makes the algorithm more fair by forcing all paths to have
> to release both locks before acquiring them again.  Since callsites to
> double_lock_balance already consider it a potential preemption/reschedule
> point, they have the proper logic to recheck for atomicity violations.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  kernel/sched.c |   17 +++++------------
>  1 files changed, 5 insertions(+), 12 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 6e0bde6..b7326cd 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2790,23 +2790,16 @@ static int double_lock_balance(struct rq *this_rq,
> struct rq *busiest) __acquires(busiest->lock)
>  	__acquires(this_rq->lock)
>  {
> -	int ret = 0;
> -
>  	if (unlikely(!irqs_disabled())) {
>  		/* printk() doesn't work good under rq->lock */
>  		spin_unlock(&this_rq->lock);
>  		BUG_ON(1);
>  	}
> -	if (unlikely(!spin_trylock(&busiest->lock))) {
> -		if (busiest < this_rq) {
> -			spin_unlock(&this_rq->lock);
> -			spin_lock(&busiest->lock);
> -			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
> -			ret = 1;
> -		} else
> -			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
> -	}
> -	return ret;
> +
> +	spin_unlock(&this_rq->lock);
> +	double_rq_lock(this_rq, busiest);

Rather than adding the extra atomic operation, can't you just put this
into the unlikely spin_trylock failure path rather than the unfair logic
there?

FWIW, this is always going to be a *tiny* bit unfair, because of double
rq lock taking the lower lock first. I guess to fix that you need to just
have a single lock to take before taking 2 rq locks. But that's not
really appropriate for mainline (and maybe not -rt either).

