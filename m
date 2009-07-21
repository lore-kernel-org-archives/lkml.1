Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbZGUWbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbZGUWbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZGUWbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:31:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45890 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZGUWbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:31:22 -0400
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
From: john stultz <johnstul@us.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@tglx.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, nikolag@ca.ibm.com,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20090718153011.1de3af8e@infradead.org>
References: <1247873945.8334.67.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0907181027510.11571@localhost.localdomain>
	 <1247954978.14494.19.camel@work-vm> <20090718153011.1de3af8e@infradead.org>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 15:31:19 -0700
Message-Id: <1248215479.3298.124.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 15:30 -0700, Arjan van de Ven wrote:
> On Sat, 18 Jul 2009 15:09:38 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > After talking with some application writers who want very fast, but
> > not fine-grained timestamps, I decided to try to implement a new
> > clock_ids to clock_gettime(): CLOCK_REALTIME_COARSE and
> > CLOCK_MONOTONIC_COARSE which returns the time at the last tick. This
> > is very fast as we don't have to access any hardware (which can be
> > very painful if you're using something like the acpi_pm clocksource),
> > and we can even use the vdso clock_gettime() method to avoid the
> > syscall. The only trade off is you only get low-res tick grained time
> > resolution.
> 
> Does this tie us to having a tick? I still have hope that we can get
> rid of the tick even when apps are running .... since with CFS we don't
> really need the tick for the scheduler anymore for example....

So it does require some sort of periodic interval. But the granularity
is probably flexible, although I'm not sure it would be of much use if
the granularity gets to be lower then 100hz. 

While being 100% tickless, even when non-idle would be nice, there will
be some need for timekeeping events to prevent clocksource counters from
wrapping, and to do accurate NTP steering.

Even so, the value we're exporting in this patch is the xtime_cache,
which is updated every tick. This is currently used in file
timestamping, so if we go 100% tickless, we'll have to change the file
timestamping to use the actual CLOCK_REALTIME clock_id, which requires a
possibly slow hardware read and would likely hurt fs performance.

So this patch doesn't so much tie us to having a tick or periodic event
any more the the fs timestamping does.


> > me_lock, seq));
> > +
> > +	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
> > +				now.tv_nsec + mono.tv_nsec);
> > +	return now;
> > +}
> > +EXPORT_SYMBOL(get_monotonic_coarse);
> > +
> 
> why does this need to be exported ?

Doesn't. Thanks for noticing!

thanks
-john



