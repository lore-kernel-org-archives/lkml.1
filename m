Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbZHMIF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbZHMIF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZHMIFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:05:25 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:55377 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbZHMIFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:05:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xVdZdPW/v2A7QJM/+cIC5AoFDVPFu/wS1fJ6taLqQHJW5Gol4lvNvdwLPQQqiBigTt
         m8Yt2LITDQY0y8+Fix5LJD8CHgNTnJIJ8x48J8zeVeA1mLvZKOt+EPwx4eXvvpqZXhxt
         0m3j2FnOpB0eqt+IQio1AaW6Kc+YlDt8i+YS4=
Date: Thu, 13 Aug 2009 10:05:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/2] perf_counter: Fix swcounter context invariance
Message-ID: <20090813080515.GA6001@nowhere>
References: <20090812153529.716542680@chello.nl> <1250149915.10001.66.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250149915.10001.66.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 09:51:55AM +0200, Peter Zijlstra wrote:
> Not really related to this topic, but it needs posting anyway.
> 
> ---
> 
> Subject: perf_counter: Fix swcounter context invariance
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Aug 07 13:29:13 CEST 2009
> 
> perf_swcounter_is_counting() uses a lock, which means we cannot use
> swcounters from NMI or when holding that particular lock, this is
> unintended.
> 
> The below removes the lock, this opens up race window, but not worse
> than the swcounters already experience due to RCU traversal of the
> context in perf_swcounter_ctx_event().
> 
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>



As a side effect, it's possible this also fixes the hard lockups
while opening a lockdep tracepoint counter.


> ---
>  kernel/perf_counter.c |   44 ++++++++++++++++++--------------------------
>  1 file changed, 18 insertions(+), 26 deletions(-)
> 
> Index: linux-2.6/kernel/perf_counter.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_counter.c
> +++ linux-2.6/kernel/perf_counter.c
> @@ -3519,40 +3519,32 @@ static void perf_swcounter_add(struct pe
>  
>  static int perf_swcounter_is_counting(struct perf_counter *counter)
>  {
> -	struct perf_counter_context *ctx;
> -	unsigned long flags;
> -	int count;
> -
> +	/*
> +	 * The counter is active, we're good!
> +	 */
>  	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
>  		return 1;
>  
> +	/*
> +	 * The counter is off/error, not counting.
> +	 */
>  	if (counter->state != PERF_COUNTER_STATE_INACTIVE)
>  		return 0;
>  
>  	/*
> -	 * If the counter is inactive, it could be just because
> -	 * its task is scheduled out, or because it's in a group
> -	 * which could not go on the PMU.  We want to count in
> -	 * the first case but not the second.  If the context is
> -	 * currently active then an inactive software counter must
> -	 * be the second case.  If it's not currently active then
> -	 * we need to know whether the counter was active when the
> -	 * context was last active, which we can determine by
> -	 * comparing counter->tstamp_stopped with ctx->time.
> -	 *
> -	 * We are within an RCU read-side critical section,
> -	 * which protects the existence of *ctx.
> +	 * The counter is inactive, if the context is active
> +	 * we're part of a group that didn't make it on the 'pmu',
> +	 * not counting.
>  	 */
> -	ctx = counter->ctx;
> -	spin_lock_irqsave(&ctx->lock, flags);
> -	count = 1;
> -	/* Re-check state now we have the lock */
> -	if (counter->state < PERF_COUNTER_STATE_INACTIVE ||
> -	    counter->ctx->is_active ||
> -	    counter->tstamp_stopped < ctx->time)
> -		count = 0;
> -	spin_unlock_irqrestore(&ctx->lock, flags);
> -	return count;
> +	if (counter->ctx->is_active)
> +		return 0;
> +
> +	/*
> +	 * We're inactive and the context is too, this means the
> +	 * task is scheduled out, we're counting events that happen
> +	 * to us, like migration events.
> +	 */
> +	return 1;
>  }
>  
>  static int perf_swcounter_match(struct perf_counter *counter,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

