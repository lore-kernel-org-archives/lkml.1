Return-Path: <linux-kernel-owner+w=401wt.eu-S1764790AbXGPPnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764790AbXGPPnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbXGPPnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:43:00 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1453 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330AbXGPPnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:43:00 -0400
Date: Mon, 16 Jul 2007 17:43:22 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH/RFC] msleep() with hrtimers 
In-Reply-To: <21003.1184596954@lwn.net>
Message-ID: <Pine.LNX.4.64.0707161654130.1817@scrub.home>
References: <21003.1184596954@lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Jonathan Corbet wrote:

> > One possible problem here is that setting up that timer can be 
> > considerably more expensive, for a relative timer you have to read the 
> > current time, which can be quite expensive (e.g. your machine now uses the 
> > PIT timer, because TSC was deemed unstable).
> 
> That's a possibility, I admit I haven't benchmarked it.  I will say that
> I don't think it will be enough to matter - msleep() is not a hot-path
> sort of function.  Once the system is up and running it almost never
> gets called at all - at least, on my setup.

That's a bit my problem - we have to consider other setups as well.
Is it worth converting all msleep users behind their back or should we 
just a provide a separate function for those who care?
I would really like to keep hrtimer and kernel timer separate and make it 
obvious who is using what, as the usage requirements are somewhat 
different.

> > One question here would be, is it really a problem to sleep a little more?
> 
> "A little more" is a bit different than "twenty times as long as you
> asked for."  That "little bit more" added up to a few seconds when
> programming a device which needs a brief delay after tweaking each of
> almost 200 registers.

Which driver is this? I'd like to look at this, in case there's some other 
hidden problem. 

> > BTW there is another thing to consider. If you already run with hrtimer/ 
> > dyntick, there is not much reason to keep HZ at 100, so you could just 
> > increase HZ to get the same effect.
> 
> Except that then, with the current implementation, you're paying for the
> higher HZ whenever the CPU is busy.  I bet that doesn't take long to
> overwhelm any added overhead in the hrtimer msleep().

Actually if that's the case I'd consider this a bug, where is that extra 
cost coming from?

> In the end, I did this because I thought msleep() should do what it
> claims to do, because I thought that getting a known-to-expire timeout
> off the timer wheel made sense, and to make a tiny baby step in the
> direction of reducing the use of jiffies in the core code.

I know that Ingo considers everything HZ related evil, but it really is 
not - it keeps Linux scalable. Unless you need the high resolution the 
timer wheel performance is still pretty hard to beat. That 
"known-to-expire" stuff is really the least significant problem to 
consider here, please just forget about it.
I don't want to keep anyone from using hrtimer, if it's just some driver 
go wild, but in generic code we have to consider portability issues. Using 
jiffies as a time base is still unbeatable cheap in the general case, so 
we have to carefully consider whether using a different time source is 
required. There is nothing wrong with using jiffies if it fits the bill 
and in many cases it still does.

bye, Roman
