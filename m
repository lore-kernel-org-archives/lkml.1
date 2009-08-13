Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbZHMXNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbZHMXNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 19:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZHMXNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 19:13:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54405 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbZHMXNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 19:13:36 -0400
Message-ID: <4A849E14.7030007@linux.vnet.ibm.com>
Date: Thu, 13 Aug 2009 16:13:24 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: eranian@gmail.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perf_counters issue with PERF_SAMPLE_GROUP
References: <7c86c4470908110841wca07382gf7487c0ed55909f2@mail.gmail.com> <1250006744.10001.29.camel@twins> <7c86c4470908111240s58385748wdb3c3e4a0d66a1ea@mail.gmail.com> <1250024143.7091.7.camel@laptop> <7c86c4470908111408x256e294i13ac90035fd8f5c8@mail.gmail.com> <1250065963.10001.30.camel@twins> <20090812090234.GB14114@elte.hu> <7c86c4470908120522m1eaf891bqb394df072dddc701@mail.gmail.com> <20090813094635.GA26612@elte.hu> <7c86c4470908131215se9b81d4v18d4d881a70f1aad@mail.gmail.com>
In-Reply-To: <7c86c4470908131215se9b81d4v18d4d881a70f1aad@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



stephane eranian wrote:
> On Thu, Aug 13, 2009 at 11:46 AM, Ingo Molnar<mingo@elte.hu> wrote:
>> * stephane eranian <eranian@googlemail.com> wrote:
>>
>>> On Wed, Aug 12, 2009 at 11:02 AM, Ingo Molnar<mingo@elte.hu> wrote:
[snip]
>>
>> So yes, both chipset and GPU sampling is very much possible, and it
>> does not require the tweaking of the syscall target parameters -
>> each CPU has a typically symmetric view on it.
>>
> 
> Except there can be many GPUs, I/O devices and other pieces of
> hardware with PMU-like capabilities in a single system. In that case,
> you need to be able to name them: I want to measure GPUcycles on
> GPU0. When you are down at that level, you don't really care about
> the CPU or thread. So what would you pass for those in that case?
> 
>> Note that there's overlap: a CPU can be an event source and a
>> scheduling target as well. I think some of the confusion in
>> terminology comes from that.
>>
>> To support chipset or GPU sampling, the perf_type_id and/or the
>> struct perf_counter_attr space can be extended.
>>

One solution might be to split up the cpu argument to sys_perf_counter_open into 
two fields, for example:

union {
     int   cpu;
     __u32 pmu_type   : 12,   /* 0 = CPU, 1 = Socket, 2 = GPU,
                                 3-4095 = arch-defined ... */
           pmu_number : 20;   /* when pmu_type is 0, 0 = CPU0, 1 = CPU1, etc. */
}

If cpu is not equal to -1, then it would be interpreted as the union above.  For 
the most common case where you are monitoring CPU's, you just pass the cpu 
number in without worrying about the upper bits (as long as the cpu number is 
less than 2^20!).

As time goes on, I think we will see more chips with fancy integrated GPU's and 
other types of accelerators, as well as other off-chip processors/accelerators, 
that developers will want to monitor.

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
cjashfor@us.ibm.com

