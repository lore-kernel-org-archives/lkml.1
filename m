Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676Ab0ATWgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0ATWgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638Ab0ATWga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:36:30 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59732 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab0ATWg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:36:29 -0500
Message-ID: <4B578568.6080808@austin.ibm.com>
Date: Wed, 20 Jan 2010 16:36:24 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, ego@in.ibm.com,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] powerpc: implement arch_scale_smt_power for Power7
References: <1264017638.5717.121.camel@jschopp-laptop>	 <1264017847.5717.132.camel@jschopp-laptop> <1264023213.724.561.camel@pasglop>
In-Reply-To: <1264023213.724.561.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +
>> +static inline int thread_in_smt4core(int x)
>> +{
>> +  return x % 4;
>> +}
>>     
>
> Needs a whitespace here though I don't really like the above. Any reason
> why you can't use the existing cpu_thread_in_core() ?
>   
I will change it to cpu_thread_in_core()
>   
>> +unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
>> +{
>> +  int cpu2;
>> +  int idle_count = 0;
>> +
>> +  struct cpumask *cpu_map = sched_domain_span(sd);
>> +
>> +	unsigned long weight = cpumask_weight(cpu_map);
>> +	unsigned long smt_gain = sd->smt_gain;
>>     
>
> More whitespace damage above.
>   
You are better than checkpatch.pl, will fix.
>   
>> +	if (cpu_has_feature(CPU_FTRS_POWER7) && weight == 4) {
>> +		for_each_cpu(cpu2, cpu_map) {
>> +			if (idle_cpu(cpu2))
>> +				idle_count++;
>> +		}
>>     
>
> I'm not 100% sure about the use of the CPU feature above. First I wonder
> if the right approach is to instead do something like
>
> 	if (!cpu_has_feature(...) !! weigth < 4)
> 		return default_scale_smt_power(sd, cpu);
>
> Though we may be better off using a ppc_md. hook here to avoid
> calculating the weight etc... on processors that don't need any
> of that.
>
> I also dislike your naming. I would suggest you change cpu_map to
> sibling_map() and cpu2 to sibling (or just c). One thing I wonder is how
> sure we are that sched_domain_span() is always going to give us the
> threads btw ? If we introduce another sched domain level for NUMA
> purposes can't we get confused ?
>   
Right now it's 100% always giving us threads.  My development version of 
the patch had a BUG_ON() to check this.  I expect this to stay the case 
in the future as the name of the function is arch_scale_smt_power(), 
which clearly denotes threads are expected.

I am not stuck on the names, I'll change it to sibling instead of cpu2 
and sibling_map instead of cpu_map.  It seems clear to me either way.

As for testing the ! case it seems funcationally equivalent, and mine 
seems less confusing.

Having a ppc.md hook with exactly 1 user is pointless, especially since 
you'll still have to calculate the weight with the ability to 
dynamically disable smt.

> Also, how hot is this code path ?
>   
It's every load balance, which is to say not hot, but fairly frequent.  
I haven't been able to measure an impact from doing very hairy 
calculations (without actually changing the weights) here vs not having 
it at all in actual end workloads.
>   
>> +		/* the following section attempts to tweak cpu power based
>> +		 * on current idleness of the threads dynamically at runtime
>> +		 */
>> +		if (idle_count == 2 || idle_count == 3 || idle_count == 4) {
>>     
>
> 		if (idle_count > 1) ? :-)
>   
Yes :)  Originally I had done different weightings for each of the 3 
cases, which gained in some workloads but regressed some others.   But 
since I'm not doing that anymore I'll fold it down to > 1
