Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZIRLKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZIRLKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZIRLKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:10:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39308 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZIRLKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:10:14 -0400
Date: Fri, 18 Sep 2009 13:09:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX -v7] x86, MCE: Fix bugs and issues of MCE log ring
	buffer
Message-ID: <20090918110953.GA9930@elte.hu>
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com>
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


* Huang Ying <ying.huang@intel.com> wrote:

> Current MCE log ring buffer has following bugs and issues:
> 
> - On larger systems the 32 size buffer easily overflow, losing events.
> 
> - We had some reports of events getting corrupted which were also
>   blamed on the ring buffer.
> 
> - There's a known livelock, now hit by more people, under high error
>   rate.
> 
> We fix these bugs and issues via making MCE log ring buffer as 
> lock-less per-CPU ring buffer.

I like the direction of this (the current MCE ring-buffer code is a bad 
local hack that should never have been merged upstream in that form) - 
but i'd like to see a MUCH more ambitious (and much more useful!) 
approach insted of using an explicit ring-buffer.

Please define MCE generic tracepoints using TRACE_EVENT() and use 
perfcounters to access them.

This approach solves all the problems you listed and it also adds a 
large number of new features to MCE events:

 - Multiple user-space agents can access MCE events. You can have an
   mcelog daemon running but also a system-wide tracer capturing
   important events in flight-recorder mode.

 - Sampling support: the kernel and the user-space call-chain of MCE
   events can be stored and analyzed as well. This way actual patterns 
   of bad behavior can be matched to precisely what kind of activity 
   happened in the kernel (and/or in the app) around that moment in 
   time.

 - Coupling with other hardware and software events: the PMU can track a 
   number of other anomalies - monitoring software might chose to 
   monitor those plus the MCE events as well - in one coherent stream of 
   events.

 - Discovery of MCE sources - tracepoints are enumerated and tools can 
   act upon the existence (or non-existence) of various channels of MCE 
   information.

 - Filtering support: you just subscribe to and act upon the events you 
   are interested in. Then even on a per event source basis there's 
   in-kernel filter expressions available that can restrict the amount
   of data that hits the event channel.

 - Arbitrary deep per cpu buffering of events - you can buffer 32 
   entries or you can buffer as much as you want, as long as you have 
   the RAM.

 - An NMI-safe ring-buffer implementation - mappable to user-space.

 - Built-in support for timestamping of events, PID markers, CPU 
   markers, etc.

 - A rich ABI accessible over system call interface. Per cpu, per task 
   and per workload monitoring of MCE events can be done this way. The 
   ABI itself has a nice, meaningful structure.

 - Extensible ABI: new fields can be added without breaking tooling.
   New tracepoints can be added as the hardware side evolves. There's 
   various parsers that can be used.

 - Lots of scheduling/buffering/batching modes of operandi for MCE
   events. poll() support. mmap() support. read() support. You name it.

 - Rich tooling support: even without any MCE specific extensions added
   the 'perf' tool today offers various views of MCE data: perf report,
   perf stat, perf trace can all be used to view logged MCE events and
   perhaps correlate them to certain user-space usage patterns. But it
   can be used directly as well, for user-space agents and policy action
   in mcelog, etc.

 - Significant code reduction and cleanup in the MCE code: the whole 
   mcelog facility can be dropped in essence.

 - (these are the top of the list - there more advantages as well.)

Such a design would basically propel the MCE code into the twenty first 
century. Once we have these facilities we can phase out /dev/mcelog for 
good. It would turn Linux MCE events from a quirky hack that doesnt even 
work after years of hacking into a modern, extensible event logging 
facility that uses event sources and flexible transports to user-space.

It would actually be code that is not a problem child like today but one 
that we can take pride in and which is fun to work on :-)

Now, an approach like this shouldnt just be a blind export of mce_log() 
into a single artificial generic event [which is a pretty poor API to 
begin with] - it should be the definition of meaningful 
tracepoints/events that describe the hardware's structure.

I'd rather have a good enumeration of various sources of MCEs as 
separate tracepoints than some badly jumbled mess of all MCE sources in 
one inflexible ABI as /dev/mcelog does it today.

Note, if you need any perfcounter infrastructure extensions/help for 
this then we'll be glad to provide that. I'm sure there's a few things 
to enhance and a few things to fix - there always are with any 
non-trivial new user :-) But heck would i take _those_ forward looking 
problems over any of the current MCE design mess, any day of the week.

Thanks,

	Ingo
