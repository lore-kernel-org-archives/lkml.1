Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYLAK5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYLAK5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYLAK5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:57:40 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:59532 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbYLAK5j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:57:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiEFAEdOM0lMROB9/2dsb2JhbACBbcxxgn0
Date: Mon, 1 Dec 2008 05:57:37 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] keypad/touchscreen driver events latencies using
	LTTng on ARM?
Message-ID: <20081201105737.GE25340@Krystal>
References: <5d5443650811301000t58665a7j7aa93be52325a23b@mail.gmail.com> <20081201103502.GC25340@Krystal> <20081201104529.GB28971@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20081201104529.GB28971@flint.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 05:50:52 up 14 days, 11:31,  1 user,  load average: 0.91, 0.54,
	0.45
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King (rmk+lkml@arm.linux.org.uk) wrote:
> On Mon, Dec 01, 2008 at 05:35:02AM -0500, Mathieu Desnoyers wrote:
> > However, I wonder if some of the newer ARM boards would happen to have a
> > cycle counter (timestamp counter), so we could implement a get_cycles()
> > and trace clock for them ?
> 
> There continues to be nothing architected for that - it would be very
> SoC specific and the precision and resolution is very variable if it's
> provided at all.  About the best implementation is a 32-bit counter
> being clocked at various rates depending on the implementation.
> 
> Our best implementation is used for sched_clock() with all the
> cnt32_to_63() stuff to extend the size of the counter which as we've
> seen from other threads, may cause problems if used for other purposes.
> 
> The next best implementation is probably the hrtimer stuff.
> 

Ok, so for LTTng on ARM it would make sense to use the same clock source
as sched_clock for :
mach-pxa, mach-realview, mach-sa1100, mach-versatile, plat-omap.

We basically have, for each of these build scenarios, to take the mmio
clock used by sched_clock and use it through
kernel/trace/trace-clock-32-to-64 to extend it to 64-bits. Therefore we
won't suffer from any of the constrains linked to cnt32_to_63 and we
would be sure that the trace clock is correct wrt SMP wrt memory
barriers and cache line bouncing because it uses per-cpu data to keep
the counters.

That should be pretty much straightforward to do. Basically starting
from the MIPS trace clock I already have should make it trivial.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
