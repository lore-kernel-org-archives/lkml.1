Return-Path: <linux-kernel-owner+w=401wt.eu-S1763656AbXEUWKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763656AbXEUWKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762216AbXEUWJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:09:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36532 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757546AbXEUWJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:09:53 -0400
Date: Mon, 21 May 2007 14:57:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andi Kleen <ak@suse.de>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       guilherme@centralinf.com.br, johnstul@us.ibm.com
Subject: Re: [patch 43/69] i386: HPET, check if the counter works
Message-Id: <20070521145719.739bb8eb.akpm@linux-foundation.org>
In-Reply-To: <1179777535.12708.37.camel@chaos>
References: <20070521191612.800400000@sous-sol.org>
	<20070521191740.534306000@sous-sol.org>
	<1179777535.12708.37.camel@chaos>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 21:58:55 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> The warning in the NOHZ code, which triggers when a CPU goes idle with
> softirqs pending can fill up the logs quite quickly. Rate limit the
> output until we found the root cause of that problem.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Index: linux-2.6.21/kernel/time/tick-sched.c
> ===================================================================
> --- linux-2.6.21.orig/kernel/time/tick-sched.c
> +++ linux-2.6.21/kernel/time/tick-sched.c
> @@ -167,9 +167,15 @@ void tick_nohz_stop_sched_tick(void)
>  		goto end;
>  
>  	cpu = smp_processor_id();
> -	if (unlikely(local_softirq_pending()))
> -		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
> -		       local_softirq_pending());
> +	if (unlikely(local_softirq_pending())) {
> +		static int ratelimit;
> +
> +		if (ratelimit < 10) {
> +			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
> +			       local_softirq_pending());
> +			ratelimit++;
> +		}
> +	}

that's not a "rate" limit.  I resist the temptation to rename it to "limit"
to keep mainline and -stable in sync, and coz it's temporary (we hope).
