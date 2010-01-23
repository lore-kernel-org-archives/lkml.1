Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027Ab0AWJAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0AWJAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 04:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814Ab0AWJAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 04:00:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43448 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab0AWJAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 04:00:34 -0500
Date: Sat, 23 Jan 2010 10:00:03 +0100
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
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to
 mce_cpu_specific_poll
Message-ID: <20100123090003.GA20056@elte.hu>
References: <20100121221711.GA8242@basil.fritz.box>
 <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org>
 <20100123051717.GA26471@elte.hu>
 <20100123075851.GA7098@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123075851.GA7098@liondog.tnic>
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

> (Adding some more interested parties to Cc:)
> 
> On Sat, Jan 23, 2010 at 06:17:17AM +0100, Ingo Molnar wrote:
> > 
> > * tip-bot for H. Peter Anvin <hpa@zytor.com> wrote:
> > 
> > > Commit-ID:  f91c4d2649531cc36e10c6bc0f92d0f99116b209
> > > Gitweb:     http://git.kernel.org/tip/f91c4d2649531cc36e10c6bc0f92d0f99116b209
> > > Author:     H. Peter Anvin <hpa@zytor.com>
> > > AuthorDate: Thu, 21 Jan 2010 18:31:54 -0800
> > > Committer:  H. Peter Anvin <hpa@zytor.com>
> > > CommitDate: Thu, 21 Jan 2010 18:31:54 -0800
> > > 
> > > x86, mce: Rename cpu_specific_poll to mce_cpu_specific_poll
> > > 
> > > cpu_specific_poll is a global variable, and it should have a global
> > > namespace name.  Since it is MCE-specific (it takes a struct mce *),
> > > rename it mce_cpu_specific_poll.
> > > 
> > > Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > > Cc: Andi Kleen <andi@firstfloor.org>
> > > LKML-Reference: <20100121221711.GA8242@basil.fritz.box>
> > 
> > FYI, this commit triggered a -tip test failure:
> > 
> >  arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c: In function 'xeon75xx_mce_init':
> >  arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c:340: error: implicit declaration of function 'pci_match_id'
> > 
> > I'm excluding it from tip:master.
> > 
> > But the bigger problem with this commit is structure of it - or the lack 
> > thereof.
> > 
> > It just blindly goes into the direction the MCE code has been going for some 
> > time, minimally enabling the hardware, ignoring both the new EDAC design and 
> > the new performance monitoring related design i outlined some time ago.
> 
> I completely agree - from what I see this is adding vendor- or rather 
> vendor-and-machine-specific hooks to read out (1) the position of the the 
> memory translation table from PCI config space (0x8c), (2) then to read out 
> the offset from the first MCA status register in order to (3) rdmsr the 
> status information.
> 
> In AMD's case, we need similar hooks too, in order to evaluate correctable 
> MCEs for different RAS reasons like for example L3 cache or data arrays 
> errors for disabling L3 indices. I was looking into adding hooks into 
> machine_check_poll() and cpu_specific_poll() interface could work.
> 
> Furthermore, lets leave mcheck be mcheck and do error decoding in EDAC 
> modules. For example, there was a core i7 EDAC module submission from Mauro 
> and the Xeon75xx-specific decoding bits could be added to it or even as a 
> new machine-specific module instead of mcelog.
> 
> With the evergrowing complexity of memory controller design I don't think 
> that the userspace mcelog approach will scale - you need the whole decoding 
> in the kernel where the module knows the exact memory controllers setup and 
> which DRAM addresses belong to which nodes and whether you do memory 
> hoisting and whether you interleave, if yes, how and on what granilarity you 
> interleave and on and on...

Yep. Could you give a few pointers to Andi where exactly you'd like to see the 
Intel Xeon functionality added to the EDAC code? There is some Intel 
functionality there already, but the current upstream code does not look very 
uptodate. I've looked at e752x_edac.c. (there's some Corei7 work pending, 
right?) In any case there's a lot of fixing to be done to the Intel code 
there.

Memory controller functionality integrated into the kernel proper is a good 
idea partly for similar reasons an on-die memory controller is a good idea in 
the hardware space.

> I believe Ingo also had some ideas about perf_event integration and this is 
> something we could add to the MCE polling routine too. Ingo?

Yes, my initial thoughts on that are in the lkml mail below from a few months 
ago. We basically want to enumerate the hardware and its events intelligently 
- and integrate that nicely with other sources of events. That will give us a 
boatload of new performance monitoring and analysis features that we could not 
have dreamt of before.

Certain events can be 'richer' and 'more special' than others (they can cause 
things like signals - on correctable memory faults), but so far there's little 
that deviates from the view that these are all system events, and that we want 
a good in-kernel enumeration and handling of them. Exposing it on the low 
level a'la mcelog is a fundamentally bad idea as it pushes hardware complexity 
into user-space (handling hardware functionality and building good 
abstractions on it is the task of the kernel - every time we push that to 
user-space the kernel becomes a little bit poorer).

Note that this very much plugs into the whole problem space of how to 
enumerate CPU cache hierarchies - something that i think Andreas is keenly 
interested in. We want one unified enumeration of hardware [and software] 
components and one enumeration of the events that originate from there.

Right now we are mostly focused on software component enumeration via 
/debug/tracing/events, but that does not (and should not) remain so. It's not 
a small task to implement all aspects of that, but it can be done gradually 
and it will be very rewarding all along the way in my opinion.

[ Furthermore, if there's interest i wouldnt mind a 'perf mce' (or more
  generally a 'perf edac') subcommand to perf either, which would specifically
  be centered about all things EDAC/MCE policy. (but of course other tooling
  can make use of it too - it doesnt 'have' to be within tools/perf/ per se -
  it's just a convenient and friendly place for kernel developers and makes it
  easy to backtest any new kernel code in this area.)

  We already have subsystem specific perf subcommands: perf kmem, perf lock,
  perf sched - this kind of spread out and subsystem specific support it's one
  of the strong sides of perf. ]

Andi's patch goes in the exact opposite direction of all that, which is a step 
backwards - and i'm not accepting that. Please at minimum come up with a good 
drivers/edac/ solution. (and better yet, make it all plug into perf event 
logging/monitoring and help bring hardware diagnostics and monitoring to all 
Linux users.)

Thanks,

	Ingo

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

Date: Tue, 22 Sep 2009 15:39:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
	Fr??d??ric Weisbecker <fweisbec@gmail.com>,
	Li Zefan <lizf@cn.fujitsu.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: mce: New MCE logging design


* Huang Ying <ying.huang@intel.com> wrote:

> Hi, Ingo,
> 
> I think it is a interesting idea to replace the original MCE logging 
> part implementation (MCE log ring buffer + /dev/mcelog misc device) 
> with tracing infrastructure. The tracing infrastructure has definitely 
> more features than original method, but it is more complex than 
> original method too.

TRACE_EVENT() can be used to define the tracepoint itself - but most of 
the benefit comes from using the performance events subsystem for event 
reporting. It's a perfect match for MCE events - see below.

> The tracing infrastructure is good at tracing. But I think it may be 
> too complex to be used as a (hardware) error processing mechanism. I 
> think the error processing should be simple and relatively independent 
> with other part of the kernel to avoid triggering more (hardware) 
> error during error processing. What do you think about this?

The fact that event reporting is used for other things as well might 
even make it more fault-resilient than open-coded MCE code: just due to 
it possibly being hot in the cache already (and thus not needing extra 
DRAM cycles to a possibly faulty piece of hardware) while the MCE code, 
not used by anything else, has to be brought into the cache for error 
processing - triggering more faults.

But ... that argument is even largely irrelevant: the overriding core 
kernel principle was always that of reuse of facilities. We want to keep 
performance event reporting simple and robust too, so re-using 
facilities is a good thing and the needs of MCE logging will improve 
perf events - and vice versa.

Furthermore, to me as x86 maintainer it matters a lot that a piece of 
code i maintain is clean, well-designed and maintainable in the long 
run. The current /dev/mcelog code is not clean and not maintainable,
and that needs to be fixed before it can be extended.

That MCE logging also becomes more robust and more feature-rich as a 
result is a happy side-effect.

> Even if we will reach consensus at some point to re-write MCE logging 
> part totally. We still need to fix the bugs in original implementation 
> before the new implementation being ready. Do you agree?

Well, this is all 2.6.33 stuff and that's plenty of time to do the 
generic events + perf events approach.

Anyway, i think we can work on these MCE enhancements much better if we 
move it to the level of actual patches. Let me give you a (very small) 
demonstration of my requests.

The patch attached below adds two new events to the MCE code, to the 
thermal throttling code:

  mce_thermal_throttle_hot
  mce_thermal_throttle_cold

If you apply the patch below to latest -tip and boot that kernel and do:

	cd tools/perf/
	make -j install

And type 'perf list', those two new MCE events will show up in the list 
of available events:

  # perf list
  [...]
    mce:mce_thermal_throttle_hot               [Tracepoint event]
    mce:mce_thermal_throttle_cold              [Tracepoint event]
  [...]

Initially you can check whether those events are occuring:

  # perf stat -a -e mce:mce_thermal_throttle_hot sleep 1

   Performance counter stats for 'sleep 1':

              0  mce:mce_thermal_throttle_hot #      0.000 M/sec

    1.000672214  seconds time elapsed

None on a normal system. Now, i tried it on a system that gets frequent 
thermal events, and there it gives:

  # perf stat -a -e mce:mce_thermal_throttle_hot sleep 1

  Performance counter stats for 'sleep 1':

              73  mce:mce_thermal_throttle_hot #      0.000 M/sec

     1.000765260  seconds time elapsed

Now i can observe the frequency of those thermal throttling events:

  # perf stat --repeat 10 -a -e mce:mce_thermal_throttle_hot sleep 1

  Performance counter stats for 'sleep 1' (10 runs):

             184  mce:mce_thermal_throttle_hot #      0.000 M/sec   ( +-   1.971% )

     1.006488821  seconds time elapsed   ( +-   0.203% )

184/sec is pretty hefty, with a relatively stable rate.

Now i try to see exactly which code is affected by those thermal 
throttling events. For that i use 'perf record', and profile the whole 
system for 10 seconds:

  # perf record -f -e mce:mce_thermal_throttle_hot -c 1 -a sleep 10
  [ perf record: Woken up 4 times to write data ]
  [ perf record: Captured and wrote 0.802 MB perf.data (~35026 samples) ]

And i used 'perf report' to analyze where the MCE events occured:

 # Samples: 2495
 #
 # Overhead         Command             Shared Object  Symbol
 # ........  ..............  ........................  ......
 #
    55.39%       hackbench  [vdso]                    [.] 0x000000f77e1430
    35.27%       hackbench                  f77c2430  [.] 0x000000f77c2430
     3.05%       hackbench  [kernel]                  [k] ia32_setup_sigcontext
     0.88%            bash  [vdso]                    [.] 0x000000f776f430
     0.64%            bash                  f7731430  [.] 0x000000f7731430
     0.52%       hackbench  ./hackbench               [.] sender
     0.48%            nice                  f7753430  [.] 0x000000f7753430
     0.36%       hackbench  ./hackbench               [.] receiver
     0.24%            perf  /lib64/libc-2.5.so        [.] __GI_read
     0.24%       hackbench  /lib/libc-2.5.so          [.] __libc_read

Most of the events concentrate themselves to around syscall entry 
points. That's not because the system is doing that most of the time - 
it's probably because the fast syscall entry point is a critical path of 
the CPU and overheating events likely concentrate themselves to around 
that place.

Now lets how we can do very detailed MCE logs, with per CPU data, 
timestamps and other events mixed. For that i use perf record again:

# perf record -R -f -e mce:mce_thermal_throttle_hot:r -e mce:mce_thermal_throttle_cold:r -e irq:irq_handler_entry:r -M -c 1 -a sleep 10
[ perf record: Woken up 12 times to write data ]
[ perf record: Captured and wrote 1.167 MB perf.data (~50990 samples) ]

And i use 'perf trace' to look at the result:

       hackbench-5070  [000]  1542.044184301: mce_thermal_throttle_hot: throttle_count=150852
       hackbench-5070  [000]  1542.044672817: mce_thermal_throttle_cold: throttle_count=150852
       hackbench-5056  [000]  1542.047029212: mce_thermal_throttle_hot: throttle_count=150853
       hackbench-5057  [000]  1542.047518733: mce_thermal_throttle_cold: throttle_count=150853
       hackbench-5058  [000]  1542.049822672: mce_thermal_throttle_hot: throttle_count=150854
       hackbench-5046  [000]  1542.050312612: mce_thermal_throttle_cold: throttle_count=150854
       hackbench-5072  [000]  1542.052720357: mce_thermal_throttle_hot: throttle_count=150855
       hackbench-5072  [000]  1542.053210612: mce_thermal_throttle_cold: throttle_count=150855
           :5074-5074  [000]  1542.055689468: mce_thermal_throttle_hot: throttle_count=150856
       hackbench-5011  [000]  1542.056179849: mce_thermal_throttle_cold: throttle_count=150856
           :5061-5061  [000]  1542.056937152: mce_thermal_throttle_hot: throttle_count=150857
       hackbench-5048  [000]  1542.057428970: mce_thermal_throttle_cold: throttle_count=150857
       hackbench-5053  [000]  1542.060372255: mce_thermal_throttle_hot: throttle_count=150858
       hackbench-5054  [000]  1542.060863006: mce_thermal_throttle_cold: throttle_count=150858

The first thing we can see it from the trace, only the first core 
reports thermal events (the box is a dual-core box). The other thing is 
the timing: the CPU is in 'hot' state for about ~490 microseconds, then 
in 'cold' state for ~250 microseconds.

So the CPU spends about 65% of its time in hot-throttled state, to cool 
down enough to switch back to cold mode again.

Also, most of the overheating events hit the 'hackbench' app. (which is 
no surprise on this box as it is only running that workload - but might 
be interesting on other systems with more mixed workloads.)

So even in its completely MCE-unaware form, and with this small patch 
that took 5 minutes to write, the performance events subsystem and 
tooling can already give far greater insight into characteristics of 
these events than the MCE subsystem did before.

Obviously the reported events can be used for different, MCE specific 
things as well:

 - Report an alert on the desktop (without having to scan the syslog all 
   the time)

 - Mail the sysadmin

 - Do some specific policy action such as soft-throttle the workload 
   until the situation and the log data can be examined.

As i outlined it in my previous mail, the perf events subsystem provides 
a wide range of facilities that can be used for that purpose.

If there are aspects of MCE reporting usecases that necessiate the 
extension of perf events, then we can do that - both sides will benefit 
from it. What we dont want to do is to prolongue the pain caused by the 
inferior, buggy and poorly designed /dev/mcelog ABI and code. It's not 
serving our users well and people are spending time on fixing something 
that has been misdesigned from the get go instead of concentrating on 
improving the right facilities.

So this is really how i see the future of the MCE logging subsystem: use 
meaningful generic events that empowers users, admins and tools to do 
something intelligent with the available stream of MCE data. The 
hardware tells us a _lot_ of information - lets use and expose that in a 
structured form.

	Ingo

---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    9 +++++
 include/trace/events/mce.h               |   47 +++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/cpu/mcheck/therm_throt.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ linux/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -31,6 +31,9 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/mce.h>
+
 /* How long to wait between reporting thermal events */
 #define CHECK_INTERVAL		(300 * HZ)
 
@@ -118,8 +121,12 @@ static int therm_throt_process(bool is_t
 	was_throttled = state->is_throttled;
 	state->is_throttled = is_throttled;
 
-	if (is_throttled)
+	if (is_throttled) {
 		state->throttle_count++;
+		trace_mce_thermal_throttle_hot(state->throttle_count);
+	} else {
+		trace_mce_thermal_throttle_cold(state->throttle_count);
+	}
 
 	if (time_before64(now, state->next_check) &&
 			state->throttle_count != state->last_throttle_count)
Index: linux/include/trace/events/mce.h
===================================================================
--- /dev/null
+++ linux/include/trace/events/mce.h
@@ -0,0 +1,47 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mce
+
+#if !defined(_TRACE_MCE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MCE_H
+
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(mce_thermal_throttle_hot,
+
+	TP_PROTO(unsigned int throttle_count),
+
+	TP_ARGS(throttle_count),
+
+	TP_STRUCT__entry(
+		__field(	u64,		throttle_count	)
+	),
+
+	TP_fast_assign(
+		__entry->throttle_count = throttle_count;
+	),
+
+	TP_printk("throttle_count=%Lu", __entry->throttle_count)
+);
+
+TRACE_EVENT(mce_thermal_throttle_cold,
+
+	TP_PROTO(unsigned int throttle_count),
+
+	TP_ARGS(throttle_count),
+
+	TP_STRUCT__entry(
+		__field(	u64,		throttle_count	)
+	),
+
+	TP_fast_assign(
+		__entry->throttle_count = throttle_count;
+	),
+
+	TP_printk("throttle_count=%Lu", __entry->throttle_count)
+);
+
+#endif /* _TRACE_MCE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>

----- End forwarded message -----
