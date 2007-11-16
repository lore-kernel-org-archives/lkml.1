Return-Path: <linux-kernel-owner+w=401wt.eu-S1762335AbXKPRgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762335AbXKPRgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXKPRgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:36:47 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:58953 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbXKPRgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:36:46 -0500
Date: Fri, 16 Nov 2007 09:36:04 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Philip Mucci <mucci@cs.utk.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: perfmon2 merge news
Message-ID: <20071116173604.GG10616@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <20071113203645.GA17145@one.firstfloor.org> <9FF72994-F55A-4B36-9EAA-CB1D2360A6F5@cs.utk.edu> <20071114015210.GA20365@one.firstfloor.org> <A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu> <p737ikicjbn.fsf@bingen.suse.de> <20071116160056.GF10616@frankl.hpl.hp.com> <20071116162813.GA29644@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116162813.GA29644@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,
On Fri, Nov 16, 2007 at 05:28:13PM +0100, Andi Kleen wrote:
> On Fri, Nov 16, 2007 at 08:00:56AM -0800, Stephane Eranian wrote:
> > No, he is talking about something similar to what was in perfctr.
> > The kernel emulates 64-bit counters in software and that is you
> > get back when you read the counters. If you read via RDPMC, you
> > get 40 bits. To reconstruct the full 64-bit value from user land
> > you need the upper bits. One approach is for the kernel to allow
> > you to remap a page that has the 64-bit (software) counters. With
> > that and a bit of mask/shifting you can reconstruct the full value.
> 
> You mean the page contains the upper [40;63] bits? 
> 
> Sounds reasonable, although I don't remember seeing that when I looked
> at the perfmon code last.
> 
I dropped that quite some time ago.

> > 
> > > I'm considering that an essential feature too. I wasn't aware
> > > it was dropped.
> > > 
> > What I dropped is the cr4.pce enabled for self-monitoring sessions.
> 
> That sounds bad.

That's because you said you were going to enable it system-wide by default.

> 
> > Perfmon2 allows you to have an in-kernel sampling buffer. The idea is
> 
> ... you also didn't say *why* that is needed.
> 
Do you question why Oprofile has one ;->

But I am happy to explain.

With sampling, you want to record information about the execution of a
thread at some interval. The interval could be expressed as time or
number of occurences of an PMU event.

Typically you get a notification. Then you need to collect certain 
information about the execution. Typically you record the instruction
pointer (e.g. Oprofile), but you may want to record the value of other
counters, PMU registers or other HW/SW resources. While you're doing
this monitoring is typically stopped so you get a consitent view. After
you're done recording you need to re-arm the sampling period. If you
use event-based sampling, you need to reprogram the counter(s). Then
you resume monitoring. You have to repeat this process for each sample
regardless of whether you are self-monitoring, monitoring another thread,
or monitoring a CPU.

Such sequence of operations is quite expensive, especially in the case
where you are monitoring another thread, because it incurs at least
a couple of context switches per sample in addition to the various
register manipulations and syscalls.

The idea with the kernel sampling buffer is that you amortize the
cost of notification to userland over LOTS of samples. On counter
overflow, the kernel records the samples on your behalf. There is
no context switch, samples are always recorded in the context on
the monitored thread.

Now, you need a bit more information for this to work correctly
because the kernel records on *your behalf*,  thus
you need to express:
	- what you want to see recorded

	- the value to reload into the overflowed counter(s)
	  so the kernel can re-arm the next period.

Because you have multiple counters, you may use them for sampling
periods, i.e., overlap sampling measurements. That is something
done very frequently.

For instance, the q-syscollect tool that D. Mosberger wrote, is
overlapping elapsed cycles and branch trace buffer (BTB) sampling
to collect, in *one* run, a flat profile and a statistical call graph.

Depending on which counter overflowed, you may one to record
different things. For instance, the flat profile requires
just the instruction pointer. But for the BTB, the buffer
is implemented by PMU registers, thus you need to record
them (16 total). You don't want to record all register possible
in each sample: reading PMU register is costly and you
want to maximize buffer space usage.

As you can see, you need to express per counter:
	- what other resources to record when it overflows
	- the value to reload into the counter after overflow

In perfmon2 this information is passed by the pfm_write_pmds()
call. You can say:
	PMD2.value     = -5000; /* initial period */
	PMD2.reset     = -2000; /* repeat period */
	PMD2.smpl_pmds = 0xf0;  /* to record PMD4-7 on overlow */

Now, it is important to note that this is not just on Itanium
that we need this kind of flexibility. Given that you mentioned
IBS, I will use it as a non-X86 example. IBS is implemented
using PMU registers, 10 to be precise. There is no need for a
custom sampling format to support that, the default format is
sufficient.

The default sampling format does record more than the instruction
pointer.  Each sample has a fixed size header including the instruction
pointer but also PID/TID/CPU. But it also has a variable size body
where the kernel stores the other registers you want to record
in each sample based on which counter overflowed. So for IBS, it
would store the 10 data registers.

> Can you give a concrete use case for something that cannot be done
> without custom buffer formats? 
> 

PEBS is one. You would have to special this. PEBS includes
the instruction pointer + values of all registers. You'd have
to devise a scheme to allocate the PEBS buffer and then on
PEBS interrupt you'd have to copy the data  into the other
buffer. Not counting on the fact that PEBS between P4 and Intel
Core 2 different and that this is an Intel X86 only feature.
I think this is better isolated into X86 specific code and
into a kernel module because it does not work on all models.


> > Using this mechanism, for instance, we were able to connect the
> > Oprofile kernel code to perfmon2 on Itanium with a 100 lines of
> > code. The exact same approach would also work on X86 Oprofile as well.
> 
> The existing oprofile code works already fine on x86, no real
> need for another one.
> 
Can you support advanced monitoring like I just described above?

> > > e.g. PEBS and so on pretty much fix the in memory sample format in hardware,
> > > so they only way to get a custom format would be to use a separate buffer.
> > > 
> > 
> > This is also how we support PEBS because, as you said, the format of the
> > samples is not under your control. if you want zero-copy PEBS support,
> > you have to follow the PEBS format.
> 
> Exactly that makes the support for random custom buffers questionable.
> 
Quite the contrary, without the custom buffers we would have horrible
hacks to support PEBS.

> e.g. as I can see the main advantage of perfmon over existing setups
> is that it support PEBS etc., but with your custom buffer formats which
> are by definition incompatible with PEBS you would negate that advantage
> again.
> 

I think  you are confused about the terms here. The custom sampling
format is a kernel-level interface to plug-in kernel modules
which implement custom sampling formats. PEBS requires a custom
format  because you do not control what is recorded. Thus what
you do is you *create* a format whose sample format *maps* the PEBS
format exactly. And that format is *different* from the one used
by the default sampling format.


> Ok IBS will probably need some special handling.
> 
No, it does not. No sampling format, no extra tricks.

> > Yes, you could do that without changing the core implementation of
> > perfmon2.
> 
> Why this insistence against changing anything?
> 

Because hardware is very diverse and is changing rapidly.
Changing the kernel is difficult and it takes a very long time
for new features to reach end-users. You are not without knowing
that most users do not download their production kernels from
kernel.org. Monitoring is not just reserved for core developers
and it is also very useful on production systems to diagnose
performance problems.

-- 
-Stephane
