Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbXCJXI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbXCJXI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 18:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXCJXI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 18:08:29 -0500
Received: from www.osadl.org ([213.239.205.134]:35868 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932419AbXCJXI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 18:08:28 -0500
Subject: Re: Use of absolute timeouts for oneshot timers
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Hecht <dhecht@vmware.com>, john stultz <johnstul@us.ibm.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45F33697.4000000@goop.org>
References: <45F33697.4000000@goop.org>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 00:14:51 +0100
Message-Id: <1173568491.24738.1194.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 14:52 -0800, Jeremy Fitzhardinge wrote:
> When booting under Xen, you'll get this if you're using both the xen
> clocksource and clockevent drivers.  However, it seems that during boot
> on a NO_HZ HIGHRES_TIMERS system, the kernel does not use the Xen
> clocksource until it switches to highres timer mode.  This means that
> during boot the kernel's monotonic clock is drifting with respect to the
> hypervisor, and all timeouts are unreliable.

The clocksource is not used until the clocksource is installed. Also the
periodic mode during boot, when the clock event device supports periodic
mode, is not reading the time. It relies on the clock event device
getting it straight. That's not a big deal during boot and on a kernel
with NO_HZ=n and HIGHRES=n the periodic tick only updates jiffies. If
the only clocksource is jiffies, then we have to live with it and we do
not switch to NO_HZ/HIGHRES as we would lose track of time.

Once we switch to NO_HZ or HIGHRES the clock event device is directly
coupled to the clock event source.

> Initially I was just computing the kernel-hypervisor offset at boot
> time, but then I changed it to recompute it every time the timer mode
> changes.  However, this didn't really help, and I was still getting
> unpredictable timeouts during boot.  I've changed it to just compute the
> hypervisor absolute time directly using the delta each time the oneshot
> timer is set, which will definitely be reliable (if the kernel and
> hypervisor have drifting timebases then the meaning of Xns delta will be
> different, but at least thats a local error rather than a long-term
> cumulative error).

We do not really care up to the point, where the high resolution
clocksource (e.g. TSC, PM-Timer or HPET on real hardware) becomes
active. Early boot is fragile and we switch over to high res clocksource
and highres/nohz when things have stabilized. 

> My analysis might be wrong here (I suspect the Xen periodic timer may
> have unexpected behaviour), but the overall conclusion still stands:
> using an absolute timeout only works if the kernel and hypervisor have
> non-drifting timebases.  I think its too fragile for a clockevent
> implementation to assume that a particular clocksource is in use to get
> reliable results.

Once we switched over to the clocksource, everything should be in
perfect sync.

> Or perhaps this is a property of the whole clock subsystem: that
> clockevents must be paired with clocksources.  But its not obvious to me
> that this enforced, or even acknowledged.

It's simply enforced in NO_HZ, HIGHRES mode as we operate in absolute
time, which is read back from the clocksource, even if we use a relative
value for real hardware clock event devices to program the next event.
We calculate the delta between the absolute event and now. So we never
get an accumulating error.

What problem are you observing ?

	tglx


