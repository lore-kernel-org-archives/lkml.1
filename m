Return-Path: <linux-kernel-owner+w=401wt.eu-S932646AbXFEQw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbXFEQw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbXFEQwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:52:51 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:41607 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbXFEQwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:52:50 -0400
Date: Tue, 5 Jun 2007 09:52:49 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Chris Wright <chrisw@sous-sol.org>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, Andi Kleen <ak@suse.de>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
       guilherme@centralinf.com.br, johnstul@us.ibm.com
Subject: Re: [patch 43/69] i386: HPET, check if the counter works
In-Reply-To: <20070521191740.534306000@sous-sol.org>
Message-ID: <Pine.LNX.4.64.0706050951240.20704@twinlark.arctic.org>
References: <20070521191612.800400000@sous-sol.org> <20070521191740.534306000@sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the HPET specification allows for HPETs with *much* lower resolution than 
50us.  in fact Fmin is 10Hz iirc.  (sorry to jump in so late, but i'm 
about a month behind on the list.)

-dean

On Mon, 21 May 2007, Chris Wright wrote:

> -stable review patch.  If anyone has any objections, please let us know.
> ---------------------
> 
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Some systems have a HPET which is not incrementing, which leads to a
> complete hang. Detect it during HPET setup.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
> [chrisw: Why is this not upstream yet?]
> 
> ---
>  arch/i386/kernel/hpet.c |   24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.21.1.orig/arch/i386/kernel/hpet.c
> +++ linux-2.6.21.1/arch/i386/kernel/hpet.c
> @@ -226,7 +226,8 @@ int __init hpet_enable(void)
>  {
>  	unsigned long id;
>  	uint64_t hpet_freq;
> -	u64 tmp;
> +	u64 tmp, start, now;
> +	cycle_t t1;
>  
>  	if (!is_hpet_capable())
>  		return 0;
> @@ -273,6 +274,27 @@ int __init hpet_enable(void)
>  	/* Start the counter */
>  	hpet_start_counter();
>  
> +	/* Verify whether hpet counter works */
> +	t1 = read_hpet();
> +	rdtscll(start);
> +
> +	/*
> +	 * We don't know the TSC frequency yet, but waiting for
> +	 * 200000 TSC cycles is safe:
> +	 * 4 GHz == 50us
> +	 * 1 GHz == 200us
> +	 */
> +	do {
> +		rep_nop();
> +		rdtscll(now);
> +	} while ((now - start) < 200000UL);
> +
> +	if (t1 == read_hpet()) {
> +		printk(KERN_WARNING
> +		       "HPET counter not counting. HPET disabled\n");
> +		goto out_nohpet;
> +	}
> +
>  	/* Initialize and register HPET clocksource
>  	 *
>  	 * hpet period is in femto seconds per cycle
> 
> -- 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
