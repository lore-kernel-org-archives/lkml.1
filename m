Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbXGPOmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbXGPOmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759290AbXGPOmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:42:35 -0400
Received: from vena.lwn.net ([206.168.112.25]:49657 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758052AbXGPOme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:42:34 -0400
To: Roman Zippel <zippel@linux-m68k.org>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH/RFC] msleep() with hrtimers 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 16 Jul 2007 13:39:48 +0200."
             <Pine.LNX.4.64.0707161325040.1818@scrub.home> 
Date: Mon, 16 Jul 2007 08:42:34 -0600
Message-ID: <21003.1184596954@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Roman,

> One possible problem here is that setting up that timer can be 
> considerably more expensive, for a relative timer you have to read the 
> current time, which can be quite expensive (e.g. your machine now uses the 
> PIT timer, because TSC was deemed unstable).

That's a possibility, I admit I haven't benchmarked it.  I will say that
I don't think it will be enough to matter - msleep() is not a hot-path
sort of function.  Once the system is up and running it almost never
gets called at all - at least, on my setup.

> One question here would be, is it really a problem to sleep a little more?

"A little more" is a bit different than "twenty times as long as you
asked for."  That "little bit more" added up to a few seconds when
programming a device which needs a brief delay after tweaking each of
almost 200 registers.

> BTW there is another thing to consider. If you already run with hrtimer/ 
> dyntick, there is not much reason to keep HZ at 100, so you could just 
> increase HZ to get the same effect.

Except that then, with the current implementation, you're paying for the
higher HZ whenever the CPU is busy.  I bet that doesn't take long to
overwhelm any added overhead in the hrtimer msleep().

In the end, I did this because I thought msleep() should do what it
claims to do, because I thought that getting a known-to-expire timeout
off the timer wheel made sense, and to make a tiny baby step in the
direction of reducing the use of jiffies in the core code.

jon
