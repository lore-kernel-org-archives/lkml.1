Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbYH0Ofj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbYH0Ofj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYH0Ofa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:35:30 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56005 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754791AbYH0Of2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:35:28 -0400
Message-ID: <48B5662B.2020806@sgi.com>
Date: Wed, 27 Aug 2008 07:35:23 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Luck, Tony" <tony.luck@intel.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <48B29F7B.6080405@hp.com> <20080826192848.GA20653@redhat.com> <48B460FE.2020100@sgi.com> <200808271654.32721.nickpiggin@yahoo.com.au>
In-Reply-To: <200808271654.32721.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Wednesday 27 August 2008 06:01, Mike Travis wrote:
>> Dave Jones wrote:
>> ...
>>
>>> But yes, for this to be even remotely feasible, there has to be a
>>> negligable performance cost associated with it, which right now, we
>>> clearly don't have. Given that the number of people running 4096 CPU
>>> boxes even in a few years time will still be tiny, punishing the common
>>> case is obviously absurd.
>>>
>>> 	Dave
>> I did do some fairly extensive benchmarking between configs of NR_CPUS =
>> 128 and 4096 and most performance hits were in the neighborhood of < 5% on
>> systems with 8 cpus and 4GB of memory (our most common test system).
> 
> 5% is a pretty nasty performance hit... what sort of benchmarks are we
> talking about here?

It's been a while now, I should go back and check my notes.  Many of the
BM's did not have any changes.  I believe the ones that were right on the
edge of paging were affected by the fact that less memory was available.
> 
> I just made some pretty crazy changes to the VM to get "only" around 5
> or so % performance improvement in some workloads.
> 
> What places are making heavy use of cpumasks that causes such a slowdown?
> Hopefully callers can mostly be improved so they don't need to use cpumasks
> for common cases.

That's another study I did, and it seemed that maybe 95% of the functions
would not be affected by passing pointers to cpumasks instead of the cpumasks
themselves, because the data was processed by a cpu_xxx function that
uses a pointer.  Most commonly was to create a temp cpumask, using
cpus_and(temp_mask, callers_mask, cpu_online_map);  The speedup to use nr_cpu_ids
instead of NR_CPUS in the traversal functions helped quite a bit.  Using this
same method in the cpus_xxx functions would further speed up things.  (As
well as only allocating the cpumask sized by nr_cpu_ids instead of NR_CPUS
as the current cpumask_t definition specifies.)

> 
> Until then, it would be kind of sad for a distro to ship a generic x86
> kernel and lose 5% performance because it is set to 4096 CPUs...
> 
> But if I misunderstand and you're talking about specific microbenchmarks to
> find the worst case for huge cpumasks, then I take that back.

Yes, I was (at the time) trying to determine how many of the cpumask functions
were actually in play by user tasks, so I was zeroing in on those (cpusets,
rescheds, etc.)

> 
> 
>> [But 
>> changing cpumask_t's to be pointers instead of values will likely increase
>> this.]  I've tried to be very sensitive to this issue with all my previous
>> changes, so convincing the distros to set NR_CPUS=4096 would be as painless
>> for them as possible. ;-)
>>
>> Btw, huge count cpu systems I don't think are that far away.  I believe the
>> nextgen Larabbee chips will be geared towards HPC applications [instead of
>> just GFX apps], and putting 4 of these chips on a motherboard would add up
>> to 512 cpu threads (1024 if they support hyperthreading.)
> 
> It would be quite interesting if they make them cache coherent / MP capable.
> Will they be?

There's not been a lot of info available yet, but I think the 128 cores will
share at least an L2 cache + memory controller.  How the APIC's interact is
also another big question.  And most likely some standard system controller
CPU will be needed, but that could be a tiny VIA processor... ;-)

Thanks,
Mike
