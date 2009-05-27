Return-Path: <linux-kernel-owner+w=401wt.eu-S1761379AbZE0Q0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761379AbZE0Q0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 12:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbZE0QZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 12:25:54 -0400
Received: from fifo99.com ([67.223.236.141]:51829 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042AbZE0QZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 12:25:53 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
	fallback sched_clock().
From: Daniel Walker <dwalker@fifo99.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
In-Reply-To: <20090527001543.GA8493@linux-sh.org>
References: <20090526061532.GD9188@linux-sh.org>
	 <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
	 <1243348681.23657.14.camel@twins>
	 <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain>
	 <20090526230855.GA27218@linux-sh.org>
	 <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain>
	 <20090527001543.GA8493@linux-sh.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 09:25:25 -0700
Message-Id: <1243441525.28705.19.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 09:15 +0900, Paul Mundt wrote:

>  unsigned long long __attribute__((weak)) sched_clock(void)
>  {
> +	/*
> +	 * Use the current clocksource when it becomes available later in
> +	 * the boot process, and ensure that it is usable for sched_clock().
> +	 */
> +	if (clock && (clock->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK))
> +		return cyc2ns(clock, clocksource_read(clock));
> +
> +	/* Otherwise just fall back on jiffies */
>  	return (unsigned long long)(jiffies - INITIAL_JIFFIES)

Do we really need all this complexity in a fast path? the jiffies
clocksource is static and always ready. Could we instead remove the
usage of "clock" and create a new pointer called "sched_clocksource" and
initialize it to the jiffies clock, and allow the clocksource management
code to update that new pointer based on the
CLOCK_SOURCE_USE_FOR_SCHED_CLOCK flag when new clocksources are
registered/removed/marked unstable etc..

that would eliminate all the code in sched_clock except one line,

unsigned long long __attribute__((weak)) sched_clock(void)
{
	return cyc2ns(sched_clocksource, clocksource_read(sched_clocksource));
}

Daniel

