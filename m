Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbZHKMjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbZHKMjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZHKMjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:39:47 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:34797 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZHKMjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:39:46 -0400
Date: Tue, 11 Aug 2009 11:34:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] cache-miss and cache-refs events on P6-mobile CPUs
Message-ID: <20090811093405.GA13004@elte.hu>
References: <87k51cgdt8.fsf@basil.nowhere.org> <20090810122731.GA5863@sig21.net> <20090810123228.GD6838@basil.fritz.box> <20090810125651.GB6082@sig21.net> <20090810132923.GA4418@elte.hu> <20090810192658.GA15513@sig21.net> <20090810201406.GA6961@elte.hu> <20090810203706.GA17338@sig21.net> <20090810213133.GB16944@elte.hu> <20090810221307.GA19236@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810221307.GA19236@sig21.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Stezenbach <js@sig21.net> wrote:

> On Mon, Aug 10, 2009 at 11:31:33PM +0200, Ingo Molnar wrote:
> > * Johannes Stezenbach <js@sig21.net> wrote:
> > > 
> > > # cat /proc/cpuinfo 
> > > processor	: 0
> > > vendor_id	: GenuineIntel
> > > cpu family	: 6
> > > model		: 13
> > > model name	: Intel(R) Pentium(R) M processor 1.80GHz
> > 
> > ah, yes. There's no cache-references/misses, because in 
> > arch/x86/kernel/cpu/perf_counter.c we have two zero entries:
> > 
> > static const u64 p6_perfmon_event_map[] =
> > {
> >   [PERF_COUNT_HW_CPU_CYCLES]            = 0x0079,
> >   [PERF_COUNT_HW_INSTRUCTIONS]          = 0x00c0,
> >   [PERF_COUNT_HW_CACHE_REFERENCES]      = 0x0000, <----------
> >   [PERF_COUNT_HW_CACHE_MISSES]          = 0x0000, <----------
> >   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]   = 0x00c4,
> >   [PERF_COUNT_HW_BRANCH_MISSES]         = 0x00c5,
> >   [PERF_COUNT_HW_BUS_CYCLES]            = 0x0062,
> > };
> > 
> > i.e. PERF_COUNT_HW_CACHE_REFERENCES and PERF_COUNT_HW_CACHE_MISSES 
> > is not filled in yet.
> > 
> > Could you try something like:
> > 
> >     perf stat -e r0f2e true
> > 
> > (0x2e: L2 requests, 0x0f: all units)
> > 
> > if i checked the docs right that counter would give us L2 cache 
> > stats - does it display non-zero values?
> 
> # ./perf stat -e r0f2e true
> 
>  Performance counter stats for 'true':
> 
>           10584  raw 0xf2e               
> 
>     0.001159924  seconds time elapsed
> 
> The number also increases for larger programs than "true".
> 
> According to /usr/share/oprofile/i386/p6_mobile/events and
> http://oprofile.sourceforge.net/docs/intel-p6-mobile-events.php
> 0x2e + 0x0f is "L2 requests, all units", but I couldn't say how
> to count cache references vs. misses.  Or does it work
> with unit mask 0x0e vs. 0x01?
> 
> # ./perf stat -e r0e2e true
> 
>  Performance counter stats for 'true':
> 
>           10147  raw 0xe2e               
> 
>     0.001121651  seconds time elapsed
> 
> # ./perf stat -e r012e true
> 
>  Performance counter stats for 'true':
> 
>             468  raw 0x12e               
> 
>     0.001130870  seconds time elapsed

Ok. That definitely looks like the right event to use.

Could you try the patch below, does it do the trick? Note, since 
there's just two generic counters and perf stat uses four counters, 
you'll need to run longer commands than 'true' or something like:

  perf stat -a sleep 1

or:

  perf stat --repeat 10 /bin/ls -R /usr/bin >/dev/null

to get all counters excercised and time-shared on your CPU.

	Ingo

-------------->
Subject: perf_counter, x86: Add generic cache events to P6-mobile CPUs
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Aug 11 10:26:33 CEST 2009

Johannes Stezenbach reported that 'perf stat' does not count
cache-miss and cache-references events on his Pentium-M based
laptop.

Add the events.

Reported-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux/arch/x86/kernel/cpu/perf_counter.c
@@ -116,8 +116,8 @@ static const u64 p6_perfmon_event_map[] 
 {
   [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,
   [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0000,
-  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0000,
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0f2e,
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x012e,
   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,
