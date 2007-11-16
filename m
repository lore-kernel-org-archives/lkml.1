Return-Path: <linux-kernel-owner+w=401wt.eu-S1765251AbXKPUgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765251AbXKPUgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbXKPUgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:36:33 -0500
Received: from static-72-72-73-123.bstnma.east.verizon.net ([72.72.73.123]:38148
	"EHLO mail1.sicortex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbXKPUgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:36:32 -0500
X-Greylist: delayed 1168 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2007 15:36:32 EST
In-Reply-To: <p737ikicjbn.fsf@bingen.suse.de>
References: <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <20071113203645.GA17145@one.firstfloor.org> <9FF72994-F55A-4B36-9EAA-CB1D2360A6F5@cs.utk.edu> <20071114015210.GA20365@one.firstfloor.org> <A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu> <p737ikicjbn.fsf@bingen.suse.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <BFC49780-73B0-47AB-BC95-516ABF557D95@sicortex.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Stephane Eranian <eranian@hpl.hp.com>,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       papi list <ptools-perfapi@cs.utk.edu>
Content-Transfer-Encoding: 7bit
From: Philip Mucci <phil@sicortex.com>
Subject: Re: perfmon2 merge news
Date: Fri, 16 Nov 2007 12:16:50 -0800
To: Andi Kleen <andi@firstfloor.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes it is for everybody. I've been rather questioning if the slow
> ways (complicated syscalls) to get the counter information are really
> needed.

I suppose by complicated here, your referring to the gather semantics  
of the
pfm_read/write_pmds/pmcs calls. Many processors may have 100's of  
registers
(IA64, BG/P, SiCortex), some of which have different access times. So a
naive syscall of 'give me all the registers you've got' isn't going  
to cut it.
However, any additional simplicity (performance) we can squeeze out  
of this
particular primitive is a huge win as it sits in the critical path of  
the user
tools (unless one is sampling).

>> referring to the concept of eventsets. Having multiplexing is
>> important.
>
> Why is it important?
>

Performance and noise. See the earlier message about our user-land  
implementation versus kernel mode implementations. Any any useful  
granularity, you begin to seriously affect the counts with noise as  
well as dilate the run-time. But let's punt on this one until after  
we get the basics in. It's a non-essential feature at this point.

>> - Custom sample formats would be considered not often used in our
>> community, largely
>> because the tools run on all HPC/Linux architectures. PAPI uses the
>> default sample
>> format which has been sufficient for our needs. However, the lack of
>> custom sample
>> formats preclude the dev of the specialized tools that access the
>> sampling
>> hardware as found on the IA64, PPC64, the Barcelona and the SiCortex
>> node chip.
>> pfmon exports this functionality quite well, and it does get used.
>
> What do you mean with custom sample formats exactly?  What information
> do you want in there? And why?

By custom here, I mean the ability to have the kernel take samples  
containing
more than just the IP, the PID and a bitmask of which registers  
overflowed at this
point. Myself and others have worked hard to get effective address  
sampling into the
hardware (there are registers that contain EA's of misses as well as  
branch mispredict
data on the PPC, IA64, Barcelona and SiCortex) that are handled  
through the use
of a format that gathers up that information at interrupt time for  
deposit into
the sample buffer. We are not wedded to Perfmon2's implementation of  
these formats, we
are however, wedded to having this information collected at interrupt  
time as the data
may change by the time you get back to user-mode. This hardware is  
not obscure any more,
it's the norm, as we've learned at thus simple aggregate counters,  
even those with precise
interrupt abilities, are not sufficient to satisfy all of our needs.

> e.g. PEBS and so on pretty much fix the in memory sample format in  
> hardware,
> so they only way to get a custom format would be to use a separate  
> buffer.
>
> I can think of one reason why the kernel should add more information
> in a separate buffer (log the instruction bytes so that it can
> be disassembled and a address histogram be generated using the PEBS
> register values), but it is a relatively obscure one and definitely
> not a essential feature. Unfortunately it is also hard to implement  
> completely
> race-free.
>

>> This is kind of comment that makes the Linux/HPC folks 'somber'. What
>> isn't useful, is being dismissive of an entire community that moves a
>> heck of a lot of Linux DVD's.
>
> Sorry, but these kind of non technical BS arguments will just make
> you be ignored in mainline Linux lands. They might work if you pay
> a lot of money to specific Linux companies (do you?), but here
> on linux-kernel you have to convince with purely technical arguments.

I love it when kernel folks refer to their own revenue streams
(and yes, we do, ask your VP of sales) and the needs of a user  
community as
"BS non-technical arguments".

But let's get back to basics here. We can sort that out over a beer  
sometime.
At this point, let's try and agree on the minimum set of
functionality acceptable for a first round of patches.

- per-CPU (system-wide) and per-thread 64-bit virtualized counters
- dispatch of interrupt on overflow via a signal
- first (self) and third-party (attach) semantics
- extensible to new lines within an architecture without repatching
   (By this I mean that through the use of modules that contain PMU
    description tables, i.e. patches don't have to be issued for  
every new rev
    of HW that Intel releases)

To be considered later:
- Sample buffers and formats
- Multiplexing (by event threshold and time slicing)
- fast-read support if the hardware supports it (mmap + user rdpmc)

I think(?) we are all clear now why oprofile is not sufficient, i.e.
simultaneous usage by non-root users, each with different counter  
configurations,
lack of read/write access  etc. Oprofile is however, a very important  
tool
and any initial set of functionality should allow for a very simple  
port to
each version of the infrastructure along the way. I'd happily port
incremental versions of PAPI to the patches, so the performance tools  
can be
accessible to the LKML community while testing/benchmarking the
patchset on a variety of architectures. If we can agree on the  
starting point,
we can move the discussion of the API to the Perfmon2 mailing list  
and with your
input, finally 'get it right' in terms of acceptance.

If there's anything we do have in common at the moment, it's momentum.
We (speaking for the HPC community/vendors again) are not in favor of  
useless bloat, every
TLB slot, mispredict, miss, timer-tick or pipeline bubble, we care  
about, kernel
space or not. It's precisely why this type of infrastructure has  
become so
vital to us over the years.

-Phil
