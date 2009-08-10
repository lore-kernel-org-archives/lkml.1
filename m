Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZHJWNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZHJWNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZHJWNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:13:06 -0400
Received: from bar.sig21.net ([80.81.252.164]:51685 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbZHJWNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:13:05 -0400
Date: Tue, 11 Aug 2009 00:13:07 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090810221307.GA19236@sig21.net>
References: <20090807170942.GB9177@sig21.net>
 <87k51cgdt8.fsf@basil.nowhere.org>
 <20090810122731.GA5863@sig21.net>
 <20090810123228.GD6838@basil.fritz.box>
 <20090810125651.GB6082@sig21.net>
 <20090810132923.GA4418@elte.hu>
 <20090810192658.GA15513@sig21.net>
 <20090810201406.GA6961@elte.hu>
 <20090810203706.GA17338@sig21.net>
 <20090810213133.GB16944@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810213133.GB16944@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -4.1 (----)
X-Spam-21-Report: No, score=-4.1 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.303,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 11:31:33PM +0200, Ingo Molnar wrote:
> * Johannes Stezenbach <js@sig21.net> wrote:
> > 
> > # cat /proc/cpuinfo 
> > processor	: 0
> > vendor_id	: GenuineIntel
> > cpu family	: 6
> > model		: 13
> > model name	: Intel(R) Pentium(R) M processor 1.80GHz
> 
> ah, yes. There's no cache-references/misses, because in 
> arch/x86/kernel/cpu/perf_counter.c we have two zero entries:
> 
> static const u64 p6_perfmon_event_map[] =
> {
>   [PERF_COUNT_HW_CPU_CYCLES]            = 0x0079,
>   [PERF_COUNT_HW_INSTRUCTIONS]          = 0x00c0,
>   [PERF_COUNT_HW_CACHE_REFERENCES]      = 0x0000, <----------
>   [PERF_COUNT_HW_CACHE_MISSES]          = 0x0000, <----------
>   [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]   = 0x00c4,
>   [PERF_COUNT_HW_BRANCH_MISSES]         = 0x00c5,
>   [PERF_COUNT_HW_BUS_CYCLES]            = 0x0062,
> };
> 
> i.e. PERF_COUNT_HW_CACHE_REFERENCES and PERF_COUNT_HW_CACHE_MISSES 
> is not filled in yet.
> 
> Could you try something like:
> 
>     perf stat -e r0f2e true
> 
> (0x2e: L2 requests, 0x0f: all units)
> 
> if i checked the docs right that counter would give us L2 cache 
> stats - does it display non-zero values?

# ./perf stat -e r0f2e true

 Performance counter stats for 'true':

          10584  raw 0xf2e               

    0.001159924  seconds time elapsed

The number also increases for larger programs than "true".

According to /usr/share/oprofile/i386/p6_mobile/events and
http://oprofile.sourceforge.net/docs/intel-p6-mobile-events.php
0x2e + 0x0f is "L2 requests, all units", but I couldn't say how
to count cache references vs. misses.  Or does it work
with unit mask 0x0e vs. 0x01?

# ./perf stat -e r0e2e true

 Performance counter stats for 'true':

          10147  raw 0xe2e               

    0.001121651  seconds time elapsed

# ./perf stat -e r012e true

 Performance counter stats for 'true':

            468  raw 0x12e               

    0.001130870  seconds time elapsed


> > Could the warning be caused by the cpufreq ondemand governor? ISTR 
> > that one should switch to the performance governor before doing 
> > any profiling, but I forgot for this test.
> 
> there might be a connection - it could in theory cause sched_clock() 
> transients and confuse the ring-buffer time-stamping.

I'll try tomorrow after a fresh boot if the warning also appears
with the performance governor.


Thanks
Johannes
