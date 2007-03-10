Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbXCJWwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbXCJWwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbXCJWwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:52:12 -0500
Received: from gw.goop.org ([64.81.55.164]:41008 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388AbXCJWwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:52:10 -0500
Message-ID: <45F33697.4000000@goop.org>
Date: Sat, 10 Mar 2007 14:52:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Dan Hecht <dhecht@vmware.com>,
       john stultz <johnstul@us.ibm.com>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Use of absolute timeouts for oneshot timers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been thinking a bit more about how useful an absolute timeout is
for a oneshot timer in a virtual environment.

In principle, absolute times are generally preferable.  A relative
timeout means "timeout in X ns from now", but the meaning of "now" is
ambiguous, particularly if the vcpu can be preempted at any time, which
means the determination of "now" can be arbitrarily deferred.

However, an absolute time is only meaningful if the kernel and
hypervisor are operating off the same timebase (ie, no drift).  In
general, the kernel's monotonic timer is going to start from 0ns when
the virtual machine is booted, and the hypervisor's is going to start at
0ns when the hypervisor is booted.  If they're operating off the same
timebase, then in principle you can work out a constant offset between
the two, and use that for converting a kernel absolute time into a
hypervisor absolute time.

When booting under Xen, you'll get this if you're using both the xen
clocksource and clockevent drivers.  However, it seems that during boot
on a NO_HZ HIGHRES_TIMERS system, the kernel does not use the Xen
clocksource until it switches to highres timer mode.  This means that
during boot the kernel's monotonic clock is drifting with respect to the
hypervisor, and all timeouts are unreliable.

Initially I was just computing the kernel-hypervisor offset at boot
time, but then I changed it to recompute it every time the timer mode
changes.  However, this didn't really help, and I was still getting
unpredictable timeouts during boot.  I've changed it to just compute the
hypervisor absolute time directly using the delta each time the oneshot
timer is set, which will definitely be reliable (if the kernel and
hypervisor have drifting timebases then the meaning of Xns delta will be
different, but at least thats a local error rather than a long-term
cumulative error).

My analysis might be wrong here (I suspect the Xen periodic timer may
have unexpected behaviour), but the overall conclusion still stands:
using an absolute timeout only works if the kernel and hypervisor have
non-drifting timebases.  I think its too fragile for a clockevent
implementation to assume that a particular clocksource is in use to get
reliable results.

Or perhaps this is a property of the whole clock subsystem: that
clockevents must be paired with clocksources.  But its not obvious to me
that this enforced, or even acknowledged.

(Of course, if the drift can be characterized, then you can compensate
for it, but this seems too complex to be the right answer.  And drift
compensation is numerically much simpler for small 32-bit deltas
compared to 64-bit absolute times.)

    J
