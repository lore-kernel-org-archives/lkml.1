Return-Path: <linux-kernel-owner+w=401wt.eu-S1751992AbXFYVKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbXFYVKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXFYVKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:10:02 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4488 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbXFYVKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:10:00 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Date: Mon, 25 Jun 2007 23:09:46 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20070625200601.GA18980@elte.hu>
In-Reply-To: <20070625200601.GA18980@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706252309.47467.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 25 June 2007, Ingo Molnar wrote:

> the patch improves the sysbench OLTP macrobenchmark significantly:

Has that any real practical relevance?

> @@ -373,6 +376,20 @@ void do_gettimeofday (struct timeval *tv
>
>  	tv->tv_sec = sec;
>  	tv->tv_usec = usec;
> +
> +	/*
> +	 * Make sure xtime.tv_sec [returned by sys_time()] always
> +	 * follows the gettimeofday() result precisely. This
> +	 * condition is extremely unlikely, it can hit at most
> +	 * once per second:
> +	 */
> +	if (unlikely(xtime.tv_sec != tv->tv_sec)) {
> +		unsigned long flags;
> +
> +		write_seqlock_irqsave(&xtime_lock);
> +		update_wall_time();
> +		write_seqlock_irqrestore(&xtime_lock);
> +	}
>  }
>
>  EXPORT_SYMBOL(do_gettimeofday);

Is this the do_gettimeofday() inside CONFIG_TIME_INTERPOLATION?
What did you test?
There can be many ways to read the clock, do you want to put this hook 
everywhere? Wouldn't it be better to improve the clock performance?

bye, Roman
