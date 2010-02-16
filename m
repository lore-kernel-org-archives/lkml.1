Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab0BPVC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 16:02:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44741 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294Ab0BPVCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 16:02:54 -0500
Date: Tue, 16 Feb 2010 22:02:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <petkovbb@googlemail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org, tglx@linutronix.de,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>,
       Huang Ying <ying.huang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to
 mce_cpu_specific_poll
Message-ID: <20100216210215.GA9051@elte.hu>
References: <20100121221711.GA8242@basil.fritz.box>
 <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org>
 <20100123051717.GA26471@elte.hu>
 <20100123075851.GA7098@liondog.tnic>
 <20100123090003.GA20056@elte.hu>
 <20100124100815.GA2895@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100124100815.GA2895@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <petkovbb@googlemail.com> wrote:

> > Yes, my initial thoughts on that are in the lkml mail below from a few 
> > months ago. We basically want to enumerate the hardware and its events 
> > intelligently - and integrate that nicely with other sources of events. 
> > That will give us a boatload of new performance monitoring and analysis 
> > features that we could not have dreamt of before.
> > 
> > Certain events can be 'richer' and 'more special' than others (they can 
> > cause things like signals - on correctable memory faults), but so far 
> > there's little that deviates from the view that these are all system 
> > events, and that we want a good in-kernel enumeration and handling of 
> > them. Exposing it on the low level a'la mcelog is a fundamentally bad 
> > idea as it pushes hardware complexity into user-space (handling hardware 
> > functionality and building good abstractions on it is the task of the 
> > kernel - every time we push that to user-space the kernel becomes a 
> > little bit poorer).
> > 
> > Note that this very much plugs into the whole problem space of how to 
> > enumerate CPU cache hierarchies - something that i think Andreas is 
> > keenly interested in.
> 
> Oh yes, he's interested in that allright :)
> 
> > We want one unified enumeration of hardware [and software] components and 
> > one enumeration of the events that originate from there. Right now we are 
> > mostly focused on software component enumeration via 
> > /debug/tracing/events, but that does not (and should not) remain so. It's 
> > not a small task to implement all aspects of that, but it can be done 
> > gradually and it will be very rewarding all along the way in my opinion.
> 
> Yes, this is very interesting. How do we represent that in the kernel space 
> as one contiguous "tree" or "library" or whatever without adding overhead 
> and opening that info to userspace?

If you do it within perf, or at least share code with it, you'd basically use 
its accessor methods as a library. There's parsers for event descriptors, so 
if the kernel exposes events it's all rather straightforward to code for.

For more dynamic set of events we could enhance the ftrace event interface 
some more as well - or possibly create a separate 'events' filesystem that 
enumerates all sorts of event sources in some nice unified hierarchy.

This is something that has come up before in other contexts as well.

> Because this is one thing that has been bugging us for a long time. We 
> don't have a centralized smart utility with lots of small subcommands like 
> perf or git, if you like, which can dump you the whole or parts of the hw 
> configuration of the machine - something like cache sizes and hierarchy, 
> CPU capabilities from CPUID flags, memory controllers configuration, DRAM 
> type and sizes, NUMA info, processor PCI config space along with decoded 
> register and bit values, ... (where do I stop)...
> 
> Currently, we have a ragged collection of tools with their own syntax and 
> output formatting like numactl, x86info, /proc/cpuinfo, (eyeballing dmesg 
> output - which is not even a tool :) and it is very annoying when you have 
> a bunch of machines and you start pulling them tools in, one after another, 
> before you can even get to the hw information.
> 
> So, it would be much much more useful if we had such a tool that can give 
> you a precise hw information without disrupting the kernel (I remember 
> several bugs with ide-cd last year where some udev helpers were querying 
> the drive for capabilities but the drive wasn't ready yet and, as a result, 
> was getting puzzled so much that it wouldn't load properly). Its 
> subcommands could each cover a subsystem or a hw component and you could do 
> something like the following example (values in {} are actual settings read 
> from the hardware):
> 
> <tool> pcicfg -f 18.3 -r 0xe8
> F3x0e8 (Northbridge Capabilities Register): {0x02073f99}
> 
> ...
> 
>  L3Capable: [25]: {1}
>                                 1=Specifies that an L3 cache is present. See
>                                 CPUID Fn8000_0006_EDX.
> 
> ...
> 
>  LnkRtryCap: [11]: {1}
>                                 Link error-retry capable.
>  HTC_capable: [10]: {1}
>                                 This affects F3x64 and F3x68.
>  SVM_capable: [9]: {1}
> 
>  MctCap: [8]: {1}
>                                 memory controller (on the processor) capable.
>  DdrMaxRate: [7:5]: {0x4}
>                                 Specifies the maximum DRAM data rate that the
>                                 processor is designed to support.
>                                 Bits 	DDR limit  		Bits    DDR limit
> 				====	=========		====	=========
> 				000b	No limit		100b	800 MT/s
> 				001b	Reserved		101b	667 MT/s
> 				010b	1333 MT/s		110b	533 MT/s
> 				011b	1067 MT/s		111b	400 MT/s
> 
>  Chipkill_ECC_capable: [4]: {1}
> 
>  ECC_capable: [3]: {1}
> 
>  Eight_node_multi_processor_capable: [2]: {0}
> 
>  Dual_node_multi_processor_capable: [1]: {0}
> 
>  DctDualCap: [0]: {1}
>                                 two-channel DRAM capable (i.e., 128 bit).
>                                 0=Single channel (64-bit) only.
> 
> 
> And yes, this is very detailed output but it simply serves the purpose to 
> show how detailed we can get.
> 
> The same thing can output MSR registers like lsmsr does:
> 
> MC4_CTL              = 0x000000003fffffff (CECCEn=0x1,  UECCEn=0x1,  CrcErr0En=0x1,  CrcErr1En=0x1,  CrcErr2En=0x1,  SyncPkt0En=0x1,  SyncPkt1En=0x1,  SyncPkt2En=0x1,  MstrAbrtEn=0x1,  TgtAbrtEn=0x1,  GartTblWkEn=0x1,  AtomicRMWEn=0x1,  WDTRptEn=0x1,  DevErrEn=0x1,  L3ArrayCorEn=0x1,  L3ArrayUCEn=0x1,  HtProtEn=0x1,  HtDataEn=0x1,  DramParEn=0x1,  RtryHt0En=0x1,  RtryHt1En=0x1,  RtryHt2En=0x1,  RtryHt3En=0x1,  CrcErr3En=0x1,  SyncPkt3En=0x1,  McaUsPwDatErrEn=0x1,  NbArrayParEn=0x1,  TblWlkDatErrEn=0x1)
> 
> but with in a more human-readable form without the need to open the hw 
> manual for that. And this is pretty lowlevel. How about nodes and cores on 
> each node and HT siblings and NUMA proximity and DIMM distribution across 
> NBs and which northbridge is connected to to the southbridge on a multinode 
> system, etc? I know, we have parts of that in /sysfs but it should be 
> easier to get that info.
> 
> You can have a gazillion examples like those and the use cases are not a 
> small number: ask a user for a specific hw configuration when debugging, 
> output from this tool can do automatic tuning suggestions like powertop in 
> 'perf stat' runs where the machine spends too much time in a function 
> because, for example, the HT link has been configured to a lower speed for 
> power savings but the app that is being profiled is generating a bunch of 
> threads doing parallel computations and causing a bunch of cross-node 
> traffic which slows it down, etc. etc. etc.
> 
> > [ Furthermore, if there's interest i wouldnt mind a 'perf mce' (or more 
> > generally a 'perf edac') subcommand to perf either, which would 
> > specifically be centered about all things EDAC/MCE policy. (but of course 
> > other tooling can make use of it too - it doesnt 'have' to be within 
> > tools/perf/ per se - it's just a convenient and friendly place for kernel 
> > developers and makes it easy to backtest any new kernel code in this 
> > area.)
> >
> >   We already have subsystem specific perf subcommands: perf kmem, perf 
> >   lock, perf sched - this kind of spread out and subsystem specific 
> >   support it's one of the strong sides of perf. ]
> 
> The example below (which I cut for brevity) is a perfect example of how it 
> should be done. Let me first, however, go a step back and give you my 
> opinion of how I think this whole MCEs catching and decoding should be done 
> before we think of tooling:
> 
> 1. We need to notify userspace, as you've said earlier, and not scan the 
> syslog all the time. And EDAC, although decoding the correctable ECC, spews 
> it in the syslog too causing more parsing (there's edac-utils which polls 
> /sysfs but this is just another tool with problems as outlined above).

Via perf events you can get a super-fast mmap()-ed ring-buffer and get the 
info in a lightweight way and possibly squeeze in some policy action before 
the system possibly dies.

> What is more, the notification mechanism we come up with should push the 
> error as early as possible and be able to send it over the network to a 
> monitor (think data center with thousands of compute nodes here where CECCs 
> happen every day at least) - something like a more resilient netconsole 
> which sends out decoded MCE info to the monitor.

Yep.

> 2. Also another very good point you had is go into maintenance mode by 
> throttling or even suspend all uspace processes and start a restricted 
> maintenance shell after an MCE happens. This should be done based on the 
> severity of the MCE and the shell should run on a core that _didn't_ 
> observe the MCE.
> 
> 3. All the hw events like correctable ECCs should be thresholded so that 
> all errors exceeding a preset threshold (below that is normal operation and 
> they get corrected by ECC codes in the hardware anyway) should alarm of a 
> slowly failing DIMM or a L3 subcache index for the sysop to take action 
> against if the machine cannot do failover itself. For example, in the L3 
> cache case, the machine can initially disable max. 2 subcache indices and 
> notify the user that it has done so but the user should be warned that the 
> hw is failing slowly.
> 
> The current decoding needs more loving too since now it says something
> like the following:
> 
> EDAC DEBUG: in drivers/edac/amd64_edac_inj.c, line at 170: section=0x80000002 word_bits=0x10020001
> EDAC DEBUG: in drivers/edac/amd64_edac_inj.c, line at 170: section=0x80000002 word_bits=0x10020001
>  Northbridge Error, node 0, core: -1
> K8 ECC error.
> EDAC amd64 MC0: CE ERROR_ADDRESS= 0x33574910
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1572: (dram=0) Base=0x0 SystemAddr= 0x33574910 Limit=0x12fffffff
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1583:    HoleOffset=0x3000  HoleValid=0x1 IntlvSel=0x0
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1627:    (ChannelAddrLong=0x19aba480) >> 8 becomes InputAddr=0x19aba4
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1515: InputAddr=0x19aba4  channelselect=0
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1537:     CSROW=0 CSBase=0x0 RAW CSMask=0x783ee0
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1541:               Final CSMask=0x7ffeff
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1544:     (InputAddr & ~CSMask)=0x100 (CSBase & ~CSMask)=0x0
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1537:     CSROW=1 CSBase=0x100 RAW CSMask=0x783ee0
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1541:               Final CSMask=0x7ffeff
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1544:     (InputAddr & ~CSMask)=0x100 (CSBase & ~CSMask)=0x100
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1549:  MATCH csrow=1
> EDAC MC0: CE page 0x33574, offset 0x910, grain 0, syndrome 0xbe01, row 1, channel 0, label "": amd64_edac
> EDAC MC0: CE - no information available: amd64_edacError Overflow
> EDAC DEBUG: in drivers/edac/amd64_edac_inj.c, line at 170: section=0x80000002 word_bits=0x10020001
> 
> and this is only the chip select row but we need to map that to the actual 
> DIMM and to tell the admin: "DIMM with label "BLA" on your motherboard 
> seems to be failing" without first naming all DIMMs through /sysfs to their 
> silk-screen labels.
> 
> And yes, it is a lot of work but we can at least start talking about it and 
> gradually getting it done. What do the others think?

I like it.

You can do it as a 'perf hw' subcommand - or start off a fork as the 'hw' 
utility, if you'd like to maintain it separately. It would have a daemon 
component as well, to receive and log hardware events continuously, to 
trigger policy action, etc.

I'd suggest you start to do it in small steps, always having something that 
works - and extend it gradually.

	Ingo
