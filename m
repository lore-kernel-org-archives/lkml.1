Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZE1JfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZE1JfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZE1Je7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:34:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:48410 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZE1Je6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:34:58 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
 fallback sched_clock().
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
In-Reply-To: <20090528091936.GA27545@linux-sh.org>
References: <20090526061532.GD9188@linux-sh.org>
	 <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
	 <1243348681.23657.14.camel@twins>
	 <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain>
	 <20090526230855.GA27218@linux-sh.org>
	 <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain>
	 <20090527001543.GA8493@linux-sh.org> <1243441525.28705.19.camel@desktop>
	 <20090528091936.GA27545@linux-sh.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 28 May 2009 11:34:41 +0200
Message-Id: <1243503281.23657.80.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 18:19 +0900, Paul Mundt wrote:

> Ok, there were some ordering problems with the early platform code, but
> I've played with this a bit more and got it to the point where this now
> also works. I can live with this over the v3 version if people prefer
> this approach instead.
> 
> --

> @@ -38,8 +39,7 @@
>   */
>  unsigned long long __attribute__((weak)) sched_clock(void)
>  {
> -	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> -					* (NSEC_PER_SEC / HZ);
> +	return cyc2ns(sched_clocksource, clocksource_read(sched_clocksource));
>  }
>  
>  static __read_mostly int sched_clock_running;

> @@ -362,6 +363,9 @@ static struct clocksource *select_clocksource(void)
>  	if (next == curr_clocksource)
>  		return NULL;
>  
> +	if (next->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK)
> +		sched_clocksource = next;
> +
>  	return next;
>  }
>  

That's a single assignment, vs two reads on use. Should we be worried
about the SMP race where we observe two different sched_clocksource
pointers on read?


I would suggest we write it as:

u64 __weak sched_clock(void)
{
	struct clocksource *clock = ACCESS_ONCE(sched_clocksource);

	return cyc2ns(clock, clocksource_read(clock));
}
