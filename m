Return-Path: <linux-kernel-owner+w=401wt.eu-S1763603AbYF0SIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763603AbYF0SIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759852AbYF0SD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:03:26 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57310 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762377AbYF0SDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:03:24 -0400
Message-ID: <48652B6A.7060007@sgi.com>
Date: Fri, 27 Jun 2008 11:03:22 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask
 V3
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>	 <19f34abd0806090420r4100241cgb4b828441de3b102@mail.gmail.com>	 <20080609113547.GA1534@elte.hu> <484D54F2.4070603@sgi.com>	 <20080626113229.GB29619@elte.hu> <4863C334.2090007@sgi.com>	 <486452CC.8050502@sgi.com> <48651EF5.5090808@sgi.com> <19f34abd0806271024j53b383ddq33ab2b58debfbb65@mail.gmail.com>
In-Reply-To: <19f34abd0806271024j53b383ddq33ab2b58debfbb65@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Fri, Jun 27, 2008 at 7:10 PM, Mike Travis <travis@sgi.com> wrote:
>> Subject: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3
>>
>>  * When CONFIG_DEBUG_PER_CPU_MAPS is set, the node passed to
>>    node_to_cpumask and node_to_cpumask_ptr should be validated.
>>    If invalid, then a dump_stack is performed and a zero cpumask
>>    is returned.
>>
>> Based on "Fri Jun 27 10:06:06 PDT 2008" tip/master...  ;-)
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> ---
>> V2: Slightly different version to remove a compiler warning.
>> V3: Redone to reflect moving setup.c -> setup_percpu.c
>> ---
>>  arch/x86/kernel/setup_percpu.c |   26 +++++++++++++++++++++++---
>>  include/asm-x86/topology.h     |    7 ++++++-
>>  2 files changed, 29 insertions(+), 4 deletions(-)
>>
>> --- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
>> +++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
>> @@ -346,6 +346,10 @@ int early_cpu_to_node(int cpu)
>>        return per_cpu(x86_cpu_to_node_map, cpu);
>>  }
>>
>> +
>> +/* empty cpumask */
>> +static const cpumask_t cpu_mask_none;
>> +
>>  /*
>>  * Returns a pointer to the bitmask of CPUs on Node 'node'.
>>  */
>> @@ -358,13 +362,23 @@ cpumask_t *_node_to_cpumask_ptr(int node
>>                dump_stack();
>>                return &cpu_online_map;
>>        }
>> -       BUG_ON(node >= nr_node_ids);
>> -       return &node_to_cpumask_map[node];
>> +       if (node >= nr_node_ids) {
>> +               printk(KERN_WARNING
>> +                       "_node_to_cpumask_ptr(%d): node > nr_node_ids(%d)\n",
>> +                       node, nr_node_ids);
>> +               dump_stack();
>> +               return (cpumask_t *)&cpu_mask_none;
> 
> Hm, I am wondering about this.
> 
> There exists an option DEBUG_RODATA ("Write protect kernel read-only
> data structures"). I'm guessing this RO protections means that we'll
> get page faults (and thus BUG/panic) if this "none" mask is ever
> attempted to be changed.
> 
> So if CONFIG_DEBUG_RODATA=y, I believe we'll see first this warning,
> then a panic (after all). Would it be better to make cpu_mask_none
> non-const, in spirit of trying to continue as far as possible? I don't
> really know if it matters, though. It seems that fedora kernels at
> least ship with a default of DEBUG_RODATA=y.
> 
> What you could also do is to make it non-const and then zero it each
> time it is requested. Again, this is an error situation in either
> case, so maybe it's not worth fussing about.
> 
> 
> Vegard
> 

Ingo asked me to add the "const".  But it would be a mistake to use
node_to_cpumask_ptr to modify the map... numa_set/clear_node is the
proper way to modify the maps.  Hmm, maybe I should add "const" to
the real node_to_cpumask_ptr function, at least then the compiler
would help spot illegal usages.

Thanks,
Mike
