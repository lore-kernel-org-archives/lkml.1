Return-Path: <linux-kernel-owner+w=401wt.eu-S1761471AbXFFKFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471AbXFFKFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbXFFKFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:05:33 -0400
Received: from gw.goop.org ([64.81.55.164]:47991 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757796AbXFFKFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:05:32 -0400
Message-ID: <466686E2.4040004@goop.org>
Date: Wed, 06 Jun 2007 03:05:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       virtualization@lists.osdl.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
References: <20070522140941.802382212@goop.org> <20070522141252.030961467@goop.org> <46668EC6.76E4.0078.0@novell.com>
In-Reply-To: <46668EC6.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Xen itself knows to deal with this (by using an error correction factor to
> slow down the local [TSC-based] clock), but for the kernel such a situation
> may be fatal: If clocksource->cycle_last was most recently set on a CPU
> with shadow->tsc_to_nsec_mul sufficiently different from that where
> getnstimeofday() is being used, timekeeping.c's __get_nsec_offset() will
> calculate a huge nanosecond value (due to cyc2ns() doing unsigned
> operations), worth abut 4000s. This value may then be used to set a
> timeout that was intended to be a few milliseconds, effectively yielding
> a hung app (and perhaps system).
>   

Hm.  I had a similar situation in the stolen time code, and I ended up
using signed values so I could clamp at zero.  Though that might have
been another bug; either way, the clamp is still there.

I wonder if cyc2ns might not be better using signed operations?  Or
perhaps better, the time code should endevour to do things on a
completely per-cpu basis (haven't really given this any thought).

> I'm sure the time keeping code can't deal with negative values returned
> from __get_nsec_offset() (timespec_add_ns() is an example, used in
> __get_realtime_clock_ts()), otherwise a potential solution might have
> been to set the clock source's multiplier and shift to one and zero
> respectively.

I don't quite follow you here, but wouldn't setting the multiplier/shift
to 1/0 preclude being able to warp the clocksource with ntp?

>  But I think that a clock source can be expected to be
> monotonic anyway, which Xen's interpolation mechanism doesn't
> guarantee across multiple CPUs. (I'm actually beginning to think that
> this might also be the reason for certain test suites occasionally reporting
> timeouts to fire early.)
>   

Does the kernel expect the tsc clocksource to be completely monotonic
across cpus?  Any form of cpu-local clocksource is going to have this
problem; I wonder if clocksources can really only be useful if they're
always referring to a single system-wide time reference - seems like a
bit of a limitation.

> Unfortunately so far I haven't been able to think of a reasonable solution
> to this - a simplistic approach like making xen_clocksource_read() check
> the value it is about to return against the last value it returned doesn't
> seem to be a good idea (time might appear to have stopped over some
> period of time otherwise), nor does attempting to adjust the shadowed
> tsc_to_nsec_mul values (because the kernel can't know whether it should
> boost the lagging CPU or throttle the rushing one).

I once had some code in there to do that, implemented in very boneheaded
way with a spinlock to protect the "last time returned" variable.  I
expect there's a better way to implement it.

    J
