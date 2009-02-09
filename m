Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbZBISwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbZBISwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZBISwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:52:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:5015 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZBISwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:52:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,406,1231142400"; 
   d="scan'208";a="488555227"
Subject: Re: [PATCH] futex: fix reference leak
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1234203975.5951.143.camel@laptop>
References: <1234181898.16083.26.camel@pc1117.cambridge.arm.com>
	 <1234190649.16083.44.camel@pc1117.cambridge.arm.com>
	 <1234192363.5951.129.camel@laptop>  <1234197950.5951.132.camel@laptop>
	 <1234198023.5951.133.camel@laptop>
	 <1234200538.16083.52.camel@pc1117.cambridge.arm.com>
	 <1234203975.5951.143.camel@laptop>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 10:53:15 -0800
Message-Id: <1234205595.4286.223.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yes. This patch fixes the problem on my system. With git, without the
patch I see the same oops as before on reboot. With the patch, system
reboots cleanly.

A minor typo in the patch
+ ret = -RESTART_RESTARTBLOCK;
should be
+ ret = -ERESTART_RESTARTBLOCK;

Thanks,
Venki

On Mon, 2009-02-09 at 10:26 -0800, Peter Zijlstra wrote:
> Venki, does this perchance solve your issue with my futex patch?
> 
> Darren, could you please have a look at this before Ingo pushes it out
> to Linus?
> 
> ---
> Catalin noticed that (38d47c1b7075: futex: rely on
> get_user_pages() for shared futexes) caused an mm_struct leak.
> 
> Some tracing with the function graph tracer quickly pointed out that
> futex_wait() has exit paths with unbalanced reference counts.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/futex.c |   23 +++++++++++++++--------
>  1 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index f89d373..7b76c8e 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1284,18 +1284,23 @@ retry:
>  	 */
>  
>  	/* If we were woken (and unqueued), we succeeded, whatever. */
> -	if (!unqueue_me(&q))
> -		return 0;
> -	if (rem)
> -		return -ETIMEDOUT;
> +	if (!unqueue_me(&q)) {
> +		ret = 0;
> +		goto out_put_key;
> +	}
> +	if (rem) {
> +		ret = -ETIMEDOUT;
> +		goto out_put_key;
> +	}
>  
>  	/*
>  	 * We expect signal_pending(current), but another thread may
>  	 * have handled it for us already.
>  	 */
> -	if (!abs_time)
> -		return -ERESTARTSYS;
> -	else {
> +	if (!abs_time) {
> +		ret = -ERESTARTSYS;
> +		goto out_put_key;
> +	} else {
>  		struct restart_block *restart;
>  		restart = &current_thread_info()->restart_block;
>  		restart->fn = futex_wait_restart;
> @@ -1309,11 +1314,13 @@ retry:
>  			restart->futex.flags |= FLAGS_SHARED;
>  		if (clockrt)
>  			restart->futex.flags |= FLAGS_CLOCKRT;
> -		return -ERESTART_RESTARTBLOCK;
> +		ret = -RESTART_RESTARTBLOCK;
> +		goto out_put_key;
>  	}
>  
>  out_unlock_put_key:
>  	queue_unlock(&q, hb);
> +out_put_key:
>  	put_futex_key(fshared, &q.key);
>  
>  out:
> 
> 

