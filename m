Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbXBALMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbXBALMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbXBALMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:12:35 -0500
Received: from styx.suse.cz ([82.119.242.94]:53745 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751729AbXBALMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:12:33 -0500
Message-Id: <20070201095952.589234000@jet.suse.cz>
User-Agent: quilt/0.44-16.5
Date: Thu, 01 Feb 2007 10:59:52 +0100
From: jbohac@suse.cz
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: [patch 0/9] x86_64: reliable TSC-based gettimeofday
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TSC-based x86_64 timekeeping implementation
===========================================
by Vojtech Pavlik and Jiri Bohac

This implementation allows the current time to be approximated by reading the
CPU's TSC even on SMP machines with unsynchronised TSCs. This allows us to
have a very fast gettimeofday() vsyscall on all SMP machines supporting the
RDTSCP instruction (AMD) or having synchronised TSCs (Intel).

Inter-CPU monotonicity can not, however, be guaranteed in a vsyscall, so
vsyscall is not used by default. Still, the syscall version of gettimeofday is
a lot faster using the TSC approximation instead of other hardware timers.

At boot, either the PM timer or HPET (preferred) is chosen as the "Master
Timer" (MT), from which all the time is calculated. As reading either of these
is slow, we want to approximate it using the TSC.

Each CPU updates its idea of the real time in update_timer_caches() called from
the LAPIC ISR. This function reads the real value of the MT and updates the
per-CPU timekeeping variables accordingly. Each CPU maintains its own
"tsc_slope" (a ratio of the MT and TSC frequencies) and a couple of offsets,
allowing us to guess (using guess_mt()) the value of the MT at any time on any
CPU.  All this per-cpu data is kept in the vxtime structure.

The gettimeofday (both the syscall and vsyscall versions) use the
approximated value of the MT to calculate the time elapsed since the
last timer interrupt. For this purpose, vxtime.mt_wall holds the value
of the MT at the last timer interrupt.

During a CPU frequency change, we cannot trust the TSCs. Therefore, when
we get the pre-change notification, we switch to using the hardware
Master Timer instead of the approximation by setting a flag in
vxtime.tsc_invalid. After the post-change notification we keep using the
hardware MT for a while, until the approximation becomes accurate again.

When strict inter-CPU monotonicity is not needed, the vsyscall version of
gettimeofday may be forced using the "nomonotonic" command line parameter.
gettimeofday()'s monotonicity is guaranteed on a single CPU even with the very
fast vsyscall version.  Across CPUs, the vsyscall version of gettimeofday is
not guaranteed to be monotonic, but it should be pretty close. Currently, we
get errors of tens/hundreds of microseconds.

We rely on neither the LAPIC timer nor the main timer interrupts being
called in regular intervals (although a little modification would
improve the MT approximation in this case), so we're basically ready for a
tickless kernel.

A patch series follows. Comments welcome.

--
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ
