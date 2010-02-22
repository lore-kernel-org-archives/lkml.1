Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0BVMEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:04:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab0BVMEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:04:22 -0500
Message-ID: <4B8271AA.9060005@redhat.com>
Date: Mon, 22 Feb 2010 08:59:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Borislav Petkov <petkovbb@googlemail.com>, mingo@redhat.com, hpa@zytor.com,
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
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to mce_cpu_specific_poll
References: <20100121221711.GA8242@basil.fritz.box> <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org> <20100123051717.GA26471@elte.hu> <20100123075851.GA7098@liondog.tnic> <20100123090003.GA20056@elte.hu> <20100124100815.GA2895@liondog.tnic> <20100216210215.GA9051@elte.hu> <20100222082840.GA3975@liondog.tnic> <20100222094739.GA20844@elte.hu>
In-Reply-To: <20100222094739.GA20844@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Tue, Feb 16, 2010 at 10:02:15PM +0100
>> Hi,
>>
>>> I like it.
>>>
>>> You can do it as a 'perf hw' subcommand - or start off a fork as the 'hw' 
>>> utility, if you'd like to maintain it separately. It would have a daemon 
>>> component as well, to receive and log hardware events continuously, to 
>>> trigger policy action, etc.
>>>
>>> I'd suggest you start to do it in small steps, always having something that 
>>> works - and extend it gradually.
>> I had the chance to meditate over the weekend a bit more on the whole
>> RAS thing after rereading all the discussion points more carefully.
>> Here are some aspects I think are important which I'd like to drop here
>> rather sooner than later so that we're in sync and don't waste time
>> implementing the wrong stuff:
>>
>> * Critical errors: we need to switch to a console and dump decoded error 
>> there at least, before panicking. Nowadays, almost everyone has a camera 
>> with which that information can be extracted from the screen. I'm afraid we 
>> won't be able to send the error over a network since climbing up the TCP 
>> stack takes relatively long and we cannot risk error propagation...? We 
>> could try to do it on a core which is not affected by the error though as a 
>> last step in the sequence...
>>
>> I think this is much more user-friendly than the current panicking which is 
>> never seen when running X except when the user has a serial/netconsole 
>> sending to some other machine.
> 
> Yep.

If the user has set up kexec/kdump, currently, the error is dumped
to the crash log at the local machine or to another machine, depending on
the config.

I like the idea of switching to console before panicking, but this is sometimes
problematic, as there are some video drivers that switching to console don't 
always work. Also, this could interfere at the kdump setup, if configured.
So, if kdump or serial/netconsole is enabled, the better is to not try to switch
the video mode. So, I think the better is to allow userspace to select one or
another mode.

>> All other non-that-critical errors are copied to userspace over a mmapped 
>> buffer and then the uspace daemon is being poked with a uevent to dump the 
>> error/signal over network/parse its contents and do policy stuff.

It seems interesting, but, if the userspace daemon is not running, it should 
fallback to write the errors via dmesg.
 
> If you use perf here you get the events and can poll() the event channel. 
> User-space can decide which events to listen in on. uevent/user-notifier is a 
> bit clumsy for that.
> 
>> * receive commands by syscall, also for hw config: I like the idea of 
>> sending commands to the kernel over a syscall, we can reuse perf 
>> functionality here and make those reused bits generic.

Why? I think we should keep using sysfs for hw config, and it seems that you also
agree. Sysfs work fine and fits nice for enumerating hierarchical data. 
What's the rationale to add also a syscall API?

The EDAC data model needs some discussion, as, currently, the memory is represented 
per csrow, and modern MCU don't allow such level of control (and it doesn't 
make much sense on representing this way, as you can't replace a csrow). The 
better is to use DIMM as the minumum unit.

>>
>> * do not bind to error format etc: not a big fan of slaving to an error 
>> format - just dump error info into the buffer and let userspace format it. 
>> We can do the formatting if we absolutely have to.

The format code is needed for critical errors anyway.

> If you use perf and tracepoints to shape the event log format then this is all 
> taken care of already, you get structured event format descriptors in 
> /debug/tracing/events/*. For example there's already an MCE tracepoint in the 
> upstream kernel today (for thermal events):
> 
> phoenix:/home/mingo> cat /debug/tracing/events/mce/mce_record/format 
> name: mce_record
> ID: 28
> format:
> 	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
> 	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
> 	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
> 	field:int common_pid;	offset:4;	size:4;	signed:1;
> 	field:int common_lock_depth;	offset:8;	size:4;	signed:1;
> 
> 	field:u64 mcgcap;	offset:16;	size:8;	signed:0;
> 	field:u64 mcgstatus;	offset:24;	size:8;	signed:0;
> 	field:u8 bank;	offset:32;	size:1;	signed:0;
> 	field:u64 status;	offset:40;	size:8;	signed:0;
> 	field:u64 addr;	offset:48;	size:8;	signed:0;
> 	field:u64 misc;	offset:56;	size:8;	signed:0;
> 	field:u64 ip;	offset:64;	size:8;	signed:0;
> 	field:u8 cs;	offset:72;	size:1;	signed:0;
> 	field:u64 tsc;	offset:80;	size:8;	signed:0;
> 	field:u64 walltime;	offset:88;	size:8;	signed:0;
> 	field:u32 cpu;	offset:96;	size:4;	signed:0;
> 	field:u32 cpuid;	offset:100;	size:4;	signed:0;
> 	field:u32 apicid;	offset:104;	size:4;	signed:0;
> 	field:u32 socketid;	offset:108;	size:4;	signed:0;
> 	field:u8 cpuvendor;	offset:112;	size:1;	signed:0;
> 
> print fmt: "CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x", REC->cpu, REC->mcgcap, REC->mcgstatus, REC->bank, REC->status, REC->addr, REC->misc, REC->cs, REC->ip, REC->tsc, REC->cpuvendor, REC->cpuid, REC->walltime, REC->socketid, REC->apicid
> 
> tools/perf/util/trace-event-parse.c contains the above structured format 
> descriptor parsing code, and can turn it into records that you can read out 
> from C code - and provides all sorts of standard functionality over it.
> 
> I'd strongly suggest to reuse that - we _really_ want health monitoring and 
> general system performance monitoring to share a single facility: as they are 
> both one and the same thing, just from different viewpoints.
>
> In other words: 'system component failure' is another metric of 'system 
> performance', so there's strong synergies all around.

Agreed.

> 
>> * can also configure hw: The tool can also send commands over the syscall to 
>> configure certain aspects of the hardware, like:
>>
>> - disable L3 cache indices which are faulty
>> - enable/disable MCE error sources: toggle MCi_CTL, MCi_CTL_MASK bits
>> - disable whole DIMMs: F2x[1, 0][5C:40][CSEnable]
>> - control ECC checking
>> - enable/disable powering down of DRAM regions for power savings
>> - set memory clock frequency
>> - some other relevant aspects of hw/CPU configuration

I agree that configuring the hw is interesting, while I still think that we should
use sysfs for it.

> Once the hardware's structure is enumerated (into a tree/hiearchy), and events 
> are attached to individual components, then 'commands' are the next logical 
> step: they are methods of a given component/object.
> 
> One such method could be 'injection' functionality btw: to simulate rare 
> hardware failures and to make sure policy logic is ready for all 
> eventualities.

The i7core, amd64 and a very few other EDAC drivers already implements memory
error injection errors, via sysfs. The point with error injection is that this
feature is hardware dependent.

So, while you can use the same hierarchy/tree for hw description, things like
error injection will require an specific hierarchy. That's one of the reasons
why I think we should keep using sysfs: it can easily be used to represent data
that are hardware dependent.

The way I mapped this on the i7core_edac is that I kept using the standard EDAC
sysfs hierarchy for memory, and added a generic code that allows describing
the error injection bits found in Nehalem.

> But ... while that is clearly the 'big grand' end goal, the panacea of RAS 
> design, i'd suggest to start with a small but useful base and pick up low 
> hanging fruits - then work towards this end goal. This is how perf is 
> developed/maintained as well.
> 
> So i'd suggest to start with _something_ that other people can try and have a 
> look at and extend, for example something that replaces basic mcelog 
> functionality. That alone should be fairly easy and immediately gives it a 
> short-term purpose. It would also be highly beneficial to the x86 code to get 
> rid of the mcelog abonimation.
> 
>> * keep all info in sysfs so that no tool is needed for accessing it,
>> similar to ftrace: All knobs needed for user interaction should appear
>> redundantly as sysfs files/dirs so that configuration/query can be done
>> "by hand" even when the hw tool is missing
> 
> Please share this code with perf. Profiling needs the same kind of 'hardware 
> structure' enumeration - combined with 'software component enumeration'.
> 
> Currently we have that info /debug/tracing/events/. Some hw structure is in 
> there as well, but not much - most of it is kernel subsystem event structure.
> 
> sysfs would be an option but IMO it's even better to put ftrace's 
> /debug/tracing/events/ hiearchy into a separate eventfs - and extend it with 
> 'hardware structure' details.
> 
> This would not only crystalise the RAS purpose, but would nicely extend perf 
> as well. With every hardware component you add from the RAS angle we'd get new 
> events for tracing/profiling use as well - and vice versa. There's no reason 
> why RAS should be limited to hw component failure events: a RAS policy action 
> could be defined over OOM events too for example, or over checksum failures in 
> network packets - etc.
> 
> RAS is not just about hardware, and profiling isnt just about software. We 
> want event logging to be a unified design - there's big advantages to that.
> 
> So please go for an integrated design. The easiest and most useful way for 
> that would be to factor out /debug/tracing/events/ into /eventfs.
> 
>> * gradually move pieces of RAS code into kernel proper: important 
>> codepaths/aspects from the HW which are being queried often (e.g., DIMM 
>> population and config) should be moved gradually into the kernel proper.
> 
> Yeah. Good plans.
> 
> 	Ingo


-- 

Cheers,
Mauro
