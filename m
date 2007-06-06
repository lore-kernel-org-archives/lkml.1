Return-Path: <linux-kernel-owner+w=401wt.eu-S934670AbXFFN1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670AbXFFN1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 09:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764933AbXFFN1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 09:27:19 -0400
Received: from mail.tmr.com ([64.65.253.246]:41202 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764203AbXFFN1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 09:27:17 -0400
Message-ID: <4666B606.60801@tmr.com>
Date: Wed, 06 Jun 2007 09:26:30 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: "Li, Tong N" <tong.n.li@intel.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>, vatsa@in.ibm.com,
       balbir@in.ibm.com, Nick Piggin <npiggin@suse.de>,
       John Kingman <kingman@storagegear.com>,
       Peter Williams <pwil3058@bigpond.net.au>, seuler.shi@gmail.com
Subject: Re: [RFC] Extend Linux to support proportional-share scheduling
References: <20070606033330.GB3266@1wt.eu> <5FD5754DDBA0B1499B5A0B4BB5419485013068A4@fmsmsx411.amr.corp.intel.com> <20070606053018.GA4049@1wt.eu>
In-Reply-To: <20070606053018.GA4049@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Tue, Jun 05, 2007 at 09:31:33PM -0700, Li, Tong N wrote:
>   
>> Willy,
>>
>> These are all good comments. Regarding the cache penalty, I've done some
>> measurements using benchmarks like SPEC OMP on an 8-processor SMP and
>> the performance with this patch was nearly identical to that with the
>> mainline. I'm sure some apps may suffer from the potentially more
>> migrations with this design. In the end, I think what we want is to
>> balance fairness and performance. This design currently emphasizes on
>> fairness, but it could be changed to relax fairness when performance
>> does become an issue (which could even be a user-tunable knob depending
>> on which aspect the user cares more).
>>     
>
> Maybe storing in each task a small list of the 2 or 4 last CPUs used would
> help the scheduler in trying to place them. I mean, let's say you have 10
> tasks and 8 CPUs. You first assign tasks 1..8 CPUs 1..8 for 1 timeslice.
> Then you will give 9..10 a run on CPUs 1..2, and CPUs 3..8 will be usable
> for other tasks. It wil be optimal to run tasks 3..8 on them. Then you will
> stop some of those because they are "in advance", and run 9..10 and 1..2
> again. You'll have to switch 1..2 to another group of CPUs to maintain hot
> cache on CPUs 1..2 for tasks 9..10. But another possibility would be to
> consider that 9..10 and 1..2 have performed the same amount of work, so
> let's 9..10 take some advance and benefit from the hot cache, then try to
> place 1..2 there again. But it will mean that 3..8 will now have run 2
> timeslices more than others. At this moment, it should be wise to make
> them sleep and keep their CPU history for future use.
>
> Maybe on end-user systems, the CPUs history is not that important because
> of the often small caches, but on high-end systems with large L2/L3 caches,
> I think that we can often keep several tasks in the cache, justifying the
> ability to select one of the last CPUs used.
>
>   
CPU affinity to preserve cache is a very delicate balance. It makes 
sense to try to run a process on the same CPU, but since even a few ms 
of running some other process is long enough to refill the cache with 
new contents (depending on what it does, obviously) that long delays in 
running a process to get it on the "right CPU" are not always a saving, 
using the previous CPU becomes less beneficial rapidly.

Some omnipotent scheduler would have a count of pages evicted from cache 
as process A runs, and deduct that from the affinity of process B 
previously on the same CPU. Then make a perfect decision when it's 
better to migrate the task and how far. Since the schedulers now being 
advanced are "fair" rather than "perfect," everyone is making educated 
guesses on optimal process migration policy, migrating all threads to 
improve cache hit vs. spread them to better run threads in parallel, etc.

For a desktop I want a scheduler which "doesn't suck" at the things I do 
regularly. For a server I'm more concerned with overall tps than the 
latency of one transaction. Most users would trade a slowdown in kernel 
compiles for being able to watch youtube while the compile runs, and 
conversely people with heavily loaded servers would usually trade a 
slower transaction for more of them per second. Obviously within 
reason... what people will tolerate is a bounded value.
> Not an easy thing to do, but probably very complementary to your work IMHO.
>   
Agree, not easy at all.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

