Return-Path: <linux-kernel-owner+w=401wt.eu-S1750803AbXBNAZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750803AbXBNAZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbXBNAZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:25:37 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58807 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbXBNAZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:25:36 -0500
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
From: john stultz <johnstul@us.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Vojtech Pavlik <vojtech@suse.cz>, Jiri Bohac <jbohac@suse.cz>,
       linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, tglx@linutronix.de,
       zippel@linux-m68k.org, andrea@suse.de
In-Reply-To: <17874.21860.598842.609322@cargo.ozlabs.ibm.com>
References: <20070201095952.589234000@jet.suse.cz>
	 <1171348808.12771.19.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0702130906530.23634@schroedinger.engr.sgi.com>
	 <200702131820.15180.ak@suse.de>
	 <17874.21860.598842.609322@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 16:25:31 -0800
Message-Id: <1171412731.27519.112.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-14 at 11:18 +1100, Paul Mackerras wrote:
> Andi Kleen writes:
> 
> > Just to avoid spreading misinformation: modulo some new broken hardware
> > (which we always try to work around when found) i386/x86-64 gettimeofday
> > is monotonic.  AFAIK on the currently known hardware it should be generally
> > ok.
> > 
> > However ntpd can always screw you up, but that's inherent in the design.
> 
> On powerpc we manage to keep gettimeofday monotonic even when ntpd is
> adjusting the clock.  We have 3 parameters used to convert a value
> from the timebase register to the time of day, and these parameters
> are adjusted if necessary at the beginning of each tick, based on the
> value returned by current_tick_length().  The point is that
> current_tick_length() tells you at the *beginning* of each tick how
> much time will be added on to xtime at the *end* of that tick, and
> that makes it possible to aim the interpolation to hit the same value
> as xtime at the end of each tick.
> 
> Clearly if you make a discrete jump backwards with settimeofday or
> adjtime, it's impossible to keep gettimeofday monotonic, but apart
> from that it's monotonic on powerpc.
> 
> At least, that's the way it's supposed to work.  I hope the recent
> timekeeping changes haven't broken it. :)

No. Just to even further clarify (and since everyone is speaking up),
the generic timekeeping does a similar scaling adjustment of the
clocksource frequency for NTP adjustments made via sys_adjtimex().

I believe Andi was just referring to ntpd calling settimeofday(), which
will cause clock_gettime(CLOCK_REALTIME,...)/gettimeofday() to possibly
jump backwards. This behavior of NTP is of course configurable (see the
-x option, or the "tinker step 0" option combined w/ "disable kernel" in
ntp.conf)

-john

