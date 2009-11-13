Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZKMNnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZKMNnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZKMNnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:43:12 -0500
Received: from relay1.sgi.com ([192.48.179.29]:55357 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752480AbZKMNnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:43:11 -0500
Message-ID: <4AFD6269.3090404@sgi.com>
Date: Fri, 13 Nov 2009 05:43:05 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] x86: Limit the number of processor bootup messages
References: <20091112171934.584037000@alcatraz.americas.sgi.com> <20091112171942.423844000@alcatraz.americas.sgi.com> <20091112180910.GA8598@elte.hu> <4AFC6A6D.1040809@sgi.com> <20091113095249.GB1364@elte.hu>
In-Reply-To: <20091113095249.GB1364@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>
>> Ingo Molnar wrote:
>>> * Mike Travis <travis@sgi.com> wrote:
>>>
>>>> --- linux.orig/arch/x86/kernel/smpboot.c
>>>> +++ linux/arch/x86/kernel/smpboot.c
>>>> @@ -442,6 +442,84 @@
>>>> 		return c->llc_shared_map;
>>>> }
>>>> +/* Summarize Processor Information */
>>>> +static void __init summarize_cpu_info(void)
>>>> +{
>>>> +	cpumask_var_t cpulist, cpusdone;
>>>> +	int cpu;
>>>> +	int err = 0;
>>>> +
>>>> +	if (!alloc_cpumask_var(&cpulist, GFP_KERNEL))
>>>> +		err = 1;
>>>> +	else if (!alloc_cpumask_var(&cpusdone, GFP_KERNEL)) {
>>>> +		free_cpumask_var(cpulist);
>>>> +		err = 1;
>>>> +	}
>>>> +	if (err) {
>>>> +		printk(KERN_INFO "Can't print processor summaries\n");
>>>> +		return;
>>>> +	}
>>>> +
>>>> +	cpumask_clear(cpusdone);
>>>> +	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
>>>> +		struct cpuinfo_x86 *c;
>>>> +		char buf[128];
>>>> +		int ncpu, len;
>>>> +		unsigned long minlpj, maxlpj, avglpj = 0;
>>>> +
>>>> +		/* skip if cpu has already been displayed */
>>>> +		if (cpumask_test_cpu(cpu, cpusdone))
>>>> +			continue;
>>>> +
>>>> +		c = &cpu_data(cpu);
>>>> +		minlpj = ULONG_MAX;
>>>> +		maxlpj = 0;
>>>> +
>>>> +		cpumask_clear(cpulist);
>>>> +
>>>> +		/* collate all cpus with same specifics */
>>>> +		for (ncpu = cpu; ncpu < nr_cpu_ids; ncpu++) {
>>>> +			struct cpuinfo_x86 *n = &cpu_data(ncpu);
>>>> +
>>>> +			if (c->x86 != n->x86 ||
>>>> +			    c->x86_vendor != n->x86_vendor ||
>>>> +			    c->x86_model  != n->x86_model  ||
>>>> +			    c->x86_mask   != n->x86_mask   ||
>>>> +			    strcmp(c->x86_model_id, n->x86_model_id))
>>>> +				continue;
>>>> +
>>>> +			cpumask_set_cpu(ncpu, cpulist);
>>>> +			cpumask_set_cpu(ncpu, cpusdone);
>>>> +
>>>> +			if (cpu_data(ncpu).loops_per_jiffy < minlpj)
>>>> +				minlpj = cpu_data(ncpu).loops_per_jiffy;
>>>> +
>>>> +			if (cpu_data(ncpu).loops_per_jiffy > maxlpj)
>>>> +				maxlpj = cpu_data(ncpu).loops_per_jiffy;
>>>> +
>>>> +			avglpj += cpu_data(ncpu).loops_per_jiffy;
>>>> +		}
>>>> +
>>>> +		len = cpulist_scnprintf(buf, sizeof(buf), cpulist);
>>>> +		printk(KERN_INFO
>>>> +			"Processor Information for CPUS: %s%s\n",
>>>> +				buf, (len == sizeof(buf)-1) ? "..." : "");
>>>> +
>>>> +		printk(KERN_INFO);
>>>> +		print_cpu_info(c);
>>>> +
>>>> +		avglpj /= cpumask_weight(cpulist);
>>>> +		printk(KERN_INFO "BogoMIPS: MIN %lu.%02lu (%lu) "
>>>> +			"AVG %lu.%02lu (%lu) MAX %lu.%02lu (%lu)\n",
>>>> +			minlpj/(500000/HZ), (minlpj/(5000/HZ)) % 100, minlpj,
>>>> +			avglpj/(500000/HZ), (avglpj/(5000/HZ)) % 100, avglpj,
>>>> +			maxlpj/(500000/HZ), (maxlpj/(5000/HZ)) % 100, maxlpj);
>>>> +	}
>>>> +
>>>> +	free_cpumask_var(cpusdone);
>>>> +	free_cpumask_var(cpulist);
>>>> +}
>>>> +
>>> Sigh, that's _way_ too complex.
>>>
>>> If you cannot print it in a summarized way without carrying over
>>> stupid state like bitmaps then please do the simple and obvious,
>>> and print:
>>>
>>> booting CPUs: #0 #1 #2 #3 #4 #5 #6 ...
>> That is almost exactly what it does. [...]
> 
> You are missing my point i think, which is that we dont want the 76 
> lines long summarize_cpu_info() complexity during bootup. Lets keep it 
> _very_ simple and zap excessive messages - like DaveJ's patch did.
> 
> 	Ingo

Ok, I'll zap the summary as I'm not sure how much easier to make a function
that scans the cpus to find ones that are common, and print their specific
information.  If I can include the model id and stepping in some /proc
interface, then a user app could do the same thing (though I'm not sure if
BogoMIPs is available or not.)

Btw, I don't actually see the difference between the two functions, both
scan a bit map list (apics vs. cpus) to find unprocessed items, then
collates similar items comparing (nodeid vs. cpu specifics) and then
prints a summary using the scnlistprintf to gather progressive item #'s.
But maybe I'm missing something.

Thanks,
Mike
