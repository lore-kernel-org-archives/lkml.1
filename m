Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbZHJVcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbZHJVcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 17:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZHJVcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 17:32:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43261 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbZHJVcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 17:32:00 -0400
Date: Mon, 10 Aug 2009 23:31:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Stezenbach <js@sig21.net>
Cc: Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090810213133.GB16944@elte.hu>
References: <20090807170942.GB9177@sig21.net> <87k51cgdt8.fsf@basil.nowhere.org> <20090810122731.GA5863@sig21.net> <20090810123228.GD6838@basil.fritz.box> <20090810125651.GB6082@sig21.net> <20090810132923.GA4418@elte.hu> <20090810192658.GA15513@sig21.net> <20090810201406.GA6961@elte.hu> <20090810203706.GA17338@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810203706.GA17338@sig21.net>
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

> On Mon, Aug 10, 2009 at 10:14:06PM +0200, Ingo Molnar wrote:
> > * Johannes Stezenbach <js@sig21.net> wrote:
> > > 
> > > # ./perf stat true
> > > 
> > >  Performance counter stats for 'true':
> > > 
> > >        0.985808  task-clock-msecs         #      0.779 CPUs 
> > >               0  context-switches         #      0.000 M/sec
> > >               0  CPU-migrations           #      0.000 M/sec
> > >             110  page-faults              #      0.112 M/sec
> > >          583873  cycles                   #    592.279 M/sec
> > >          500937  instructions             #      0.858 IPC  
> > >   <not counted>  cache-references        
> > >   <not counted>  cache-misses            
> > > 
> > >     0.001265524  seconds time elapsed
> > 
> > That looks almost normal - except for cache-references and 
> > cache-misses that is not counted. Could you send the /proc/cpuinfo 
> > info please?
> 
> # cat /proc/cpuinfo 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 13
> model name	: Intel(R) Pentium(R) M processor 1.80GHz

ah, yes. There's no cache-references/misses, because in 
arch/x86/kernel/cpu/perf_counter.c we have two zero entries:

static const u64 p6_perfmon_event_map[] =
{
  [PERF_COUNT_HW_CPU_CYCLES]            = 0x0079,
  [PERF_COUNT_HW_INSTRUCTIONS]          = 0x00c0,
  [PERF_COUNT_HW_CACHE_REFERENCES]      = 0x0000, <----------
  [PERF_COUNT_HW_CACHE_MISSES]          = 0x0000, <----------
  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]   = 0x00c4,
  [PERF_COUNT_HW_BRANCH_MISSES]         = 0x00c5,
  [PERF_COUNT_HW_BUS_CYCLES]            = 0x0062,
};

i.e. PERF_COUNT_HW_CACHE_REFERENCES and PERF_COUNT_HW_CACHE_MISSES 
is not filled in yet.

Could you try something like:

    perf stat -e r0f2e true

(0x2e: L2 requests, 0x0f: all units)

if i checked the docs right that counter would give us L2 cache 
stats - does it display non-zero values?

> stepping	: 6
> cpu MHz		: 600.000
> cache size	: 2048 KB
> fdiv_bug	: no
> hlt_bug		: no
> f00f_bug	: no
> coma_bug	: no
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 2
> wp		: yes
> flags		: fpu vme de pse tsc msr mce cx8 apic sep mtrr pge mca cmov clflush dts acpi mmx fxsr sse sse2 ss tm pbe bts est tm2
> bogomips	: 1196.15
> clflush size	: 64
> power management:
> 
> 
> > The warning is probably harmless - oprofile sampling still works 
> > fine, right?
> 
> I haven't done much testing so far, but so far it looks promising.
> 
> Could the warning be caused by the cpufreq ondemand governor? ISTR 
> that one should switch to the performance governor before doing 
> any profiling, but I forgot for this test.

there might be a connection - it could in theory cause sched_clock() 
transients and confuse the ring-buffer time-stamping.

	Ingo
