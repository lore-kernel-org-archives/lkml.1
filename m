Return-Path: <linux-kernel-owner+w=401wt.eu-S1751471AbZHAMaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbZHAMaA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 08:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZHAM37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 08:29:59 -0400
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:56801
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZHAM36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 08:29:58 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Aug 2009 08:29:58 EDT
Message-ID: <4A743333.7000006@mit.edu>
Date: Sat, 01 Aug 2009 08:21:07 -0400
From: Andy Lutomirski <luto@mit.edu>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@tglx.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       nikolag@ca.ibm.com, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
References: <1247873945.8334.67.camel@localhost.localdomain>	 <alpine.LFD.2.00.0907181027510.11571@localhost.localdomain>	 <1247954978.14494.19.camel@work-vm> <20090718153011.1de3af8e@infradead.org> <1248215479.3298.124.camel@localhost>
In-Reply-To: <1248215479.3298.124.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> On Sat, 2009-07-18 at 15:30 -0700, Arjan van de Ven wrote:
>> On Sat, 18 Jul 2009 15:09:38 -0700
>> john stultz <johnstul@us.ibm.com> wrote:
>>
>>> After talking with some application writers who want very fast, but
>>> not fine-grained timestamps, I decided to try to implement a new
>>> clock_ids to clock_gettime(): CLOCK_REALTIME_COARSE and
>>> CLOCK_MONOTONIC_COARSE which returns the time at the last tick. This
>>> is very fast as we don't have to access any hardware (which can be
>>> very painful if you're using something like the acpi_pm clocksource),
>>> and we can even use the vdso clock_gettime() method to avoid the
>>> syscall. The only trade off is you only get low-res tick grained time
>>> resolution.
>> Does this tie us to having a tick? I still have hope that we can get
>> rid of the tick even when apps are running .... since with CFS we don't
>> really need the tick for the scheduler anymore for example....
> 
> So it does require some sort of periodic interval. But the granularity
> is probably flexible, although I'm not sure it would be of much use if
> the granularity gets to be lower then 100hz. 
> 
> While being 100% tickless, even when non-idle would be nice, there will
> be some need for timekeeping events to prevent clocksource counters from
> wrapping, and to do accurate NTP steering.
> 
> Even so, the value we're exporting in this patch is the xtime_cache,
> which is updated every tick. This is currently used in file
> timestamping, so if we go 100% tickless, we'll have to change the file
> timestamping to use the actual CLOCK_REALTIME clock_id, which requires a
> possibly slow hardware read and would likely hurt fs performance.
> 
> So this patch doesn't so much tie us to having a tick or periodic event
> any more the the fs timestamping does.

Hmm.  I think that we can have our cake and eat it too, if the machine 
has a hardware timer that can be turned on and off very cheaply.  Just 
(heh) turn off the tick when an entire tick interval elapses without an 
access to the cached time.

This is a win if we frequently have two or more consecutive tick 
intervals without a clock read, it does nothing (except probably a touch 
of bookkeeping overhead) when someone reads the cached time during each 
tick interval, and it's a loss (due to excessive reprogramming of the 
timer) when the cache is read on alternating intervals.  Of course, if 
the cached time is read (several times, anyway) every tick, then having 
a tick is a good thing because it avoids time source reads.

Getting this to work from the a vsyscall would be tricky.  We could have 
a userspace-readable flag indicating both what time it is and whether 
the value is accurate and has already been requested this interval (use 
some sentinal value for the not-requested case, at the cost of a tiny 
chance the vsyscall doesn't work) and punt to the kernel if this is the 
first access in any interval.


--Andy
