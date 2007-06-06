Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbXFFIi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbXFFIi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbXFFIiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:38:21 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:52701 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751019AbXFFIiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:38:20 -0400
Message-Id: <46668EC6.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 06 Jun 2007 10:39:02 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <virtualization@lists.osdl.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Chris Wright" <chrisw@sous-sol.org>, "Andi Kleen" <ak@suse.de>,
       "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
References: <20070522140941.802382212@goop.org>
 <20070522141252.030961467@goop.org>
In-Reply-To: <20070522141252.030961467@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>+cycle_t xen_clocksource_read(void)
>+{
>+	struct shadow_time_info *shadow = &get_cpu_var(shadow_time);
>+	cycle_t ret;
>+
>+	get_time_values_from_xen();
>+
>+	ret = shadow->system_timestamp + get_nsec_offset(shadow);
>+
>+	put_cpu_var(shadow_time);
>+
>+	return ret;
>+}

I'm afraid this mechanism is pretty unreliable on SMP: getnstimeofday() and
do_gettimeofday() both use the difference between the last snapshot taken
and the current value read from the clock source. Since I had added this
clocksource code to our kernel, I had reproducible hangs on one of the
systems I regularly work with (you may have seen the respective thread
on xen-devel), which recently I finally found time to look into. The issue is
that on that system, transition into ACPI mode takes over 600ms (SMM
execution, and hence no interrupts delivered during that time), and with
Xen using the PIT (PM timer support was added by Keir as a result of this,
but that doesn't cure the problem here, it just reduces the likelihood it'll
be encountered) platform time and local time got pretty much out of sync.

Xen itself knows to deal with this (by using an error correction factor to
slow down the local [TSC-based] clock), but for the kernel such a situation
may be fatal: If clocksource->cycle_last was most recently set on a CPU
with shadow->tsc_to_nsec_mul sufficiently different from that where
getnstimeofday() is being used, timekeeping.c's __get_nsec_offset() will
calculate a huge nanosecond value (due to cyc2ns() doing unsigned
operations), worth abut 4000s. This value may then be used to set a
timeout that was intended to be a few milliseconds, effectively yielding
a hung app (and perhaps system).

I'm sure the time keeping code can't deal with negative values returned
from __get_nsec_offset() (timespec_add_ns() is an example, used in
__get_realtime_clock_ts()), otherwise a potential solution might have
been to set the clock source's multiplier and shift to one and zero
respectively. But I think that a clock source can be expected to be
monotonic anyway, which Xen's interpolation mechanism doesn't
guarantee across multiple CPUs. (I'm actually beginning to think that
this might also be the reason for certain test suites occasionally reporting
timeouts to fire early.)

Unfortunately so far I haven't been able to think of a reasonable solution
to this - a simplistic approach like making xen_clocksource_read() check
the value it is about to return against the last value it returned doesn't
seem to be a good idea (time might appear to have stopped over some
period of time otherwise), nor does attempting to adjust the shadowed
tsc_to_nsec_mul values (because the kernel can't know whether it should
boost the lagging CPU or throttle the rushing one).

Jan


