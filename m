Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZKLUFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZKLUFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZKLUFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:05:03 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44413 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754241AbZKLUFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:05:02 -0500
Message-ID: <4AFC6A6D.1040809@sgi.com>
Date: Thu, 12 Nov 2009 12:05:01 -0800
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
References: <20091112171934.584037000@alcatraz.americas.sgi.com> <20091112171942.423844000@alcatraz.americas.sgi.com> <20091112180910.GA8598@elte.hu>
In-Reply-To: <20091112180910.GA8598@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> --- linux.orig/arch/x86/kernel/smpboot.c
>> +++ linux/arch/x86/kernel/smpboot.c
>> @@ -442,6 +442,84 @@
>>  		return c->llc_shared_map;
>>  }
>>  
>> +/* Summarize Processor Information */
>> +static void __init summarize_cpu_info(void)
>> +{
>> +	cpumask_var_t cpulist, cpusdone;
>> +	int cpu;
>> +	int err = 0;
>> +
>> +	if (!alloc_cpumask_var(&cpulist, GFP_KERNEL))
>> +		err = 1;
>> +	else if (!alloc_cpumask_var(&cpusdone, GFP_KERNEL)) {
>> +		free_cpumask_var(cpulist);
>> +		err = 1;
>> +	}
>> +	if (err) {
>> +		printk(KERN_INFO "Can't print processor summaries\n");
>> +		return;
>> +	}
>> +
>> +	cpumask_clear(cpusdone);
>> +	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
>> +		struct cpuinfo_x86 *c;
>> +		char buf[128];
>> +		int ncpu, len;
>> +		unsigned long minlpj, maxlpj, avglpj = 0;
>> +
>> +		/* skip if cpu has already been displayed */
>> +		if (cpumask_test_cpu(cpu, cpusdone))
>> +			continue;
>> +
>> +		c = &cpu_data(cpu);
>> +		minlpj = ULONG_MAX;
>> +		maxlpj = 0;
>> +
>> +		cpumask_clear(cpulist);
>> +
>> +		/* collate all cpus with same specifics */
>> +		for (ncpu = cpu; ncpu < nr_cpu_ids; ncpu++) {
>> +			struct cpuinfo_x86 *n = &cpu_data(ncpu);
>> +
>> +			if (c->x86 != n->x86 ||
>> +			    c->x86_vendor != n->x86_vendor ||
>> +			    c->x86_model  != n->x86_model  ||
>> +			    c->x86_mask   != n->x86_mask   ||
>> +			    strcmp(c->x86_model_id, n->x86_model_id))
>> +				continue;
>> +
>> +			cpumask_set_cpu(ncpu, cpulist);
>> +			cpumask_set_cpu(ncpu, cpusdone);
>> +
>> +			if (cpu_data(ncpu).loops_per_jiffy < minlpj)
>> +				minlpj = cpu_data(ncpu).loops_per_jiffy;
>> +
>> +			if (cpu_data(ncpu).loops_per_jiffy > maxlpj)
>> +				maxlpj = cpu_data(ncpu).loops_per_jiffy;
>> +
>> +			avglpj += cpu_data(ncpu).loops_per_jiffy;
>> +		}
>> +
>> +		len = cpulist_scnprintf(buf, sizeof(buf), cpulist);
>> +		printk(KERN_INFO
>> +			"Processor Information for CPUS: %s%s\n",
>> +				buf, (len == sizeof(buf)-1) ? "..." : "");
>> +
>> +		printk(KERN_INFO);
>> +		print_cpu_info(c);
>> +
>> +		avglpj /= cpumask_weight(cpulist);
>> +		printk(KERN_INFO "BogoMIPS: MIN %lu.%02lu (%lu) "
>> +			"AVG %lu.%02lu (%lu) MAX %lu.%02lu (%lu)\n",
>> +			minlpj/(500000/HZ), (minlpj/(5000/HZ)) % 100, minlpj,
>> +			avglpj/(500000/HZ), (avglpj/(5000/HZ)) % 100, avglpj,
>> +			maxlpj/(500000/HZ), (maxlpj/(5000/HZ)) % 100, maxlpj);
>> +	}
>> +
>> +	free_cpumask_var(cpusdone);
>> +	free_cpumask_var(cpulist);
>> +}
>> +
> 
> Sigh, that's _way_ too complex.
> 
> If you cannot print it in a summarized way without carrying over stupid 
> state like bitmaps then please do the simple and obvious, and print:
> 
> booting CPUs: #0 #1 #2 #3 #4 #5 #6 ...

That is almost exactly what it does.  The following function prints
each cpu # as they are being booted, so you see a progressive listing.

Booting Node   0, Processors  1 2 3 4 5 6 7 Ok.
Booting Node   1, Processors  8 9 10 11 12 13 14 15 Ok.
Booting Node   2, Processors  16 17 18 19 20 21 22 23 Ok.

+#ifdef CONFIG_NUMA
+	if (system_state == SYSTEM_BOOTING) {
+		static int current_node = -1;
+		int node = cpu_to_node(cpu);
+
+		if (node != current_node) {
+			if (current_node > (-1))
+				pr_cont(" Ok.\n");
+			current_node = node;
+			pr_info("Booting Node %3d, Processors ", node);
+		}
+		pr_cont(" %d%s", cpu, cpu == (nr_cpu_ids - 1) ? " Ok.\n" : "");
+	} else
+#endif
+		pr_info("Booting Processor %d APIC 0x%x\n", cpu, apicid);

The part you highlight above is to print the summary shown below of the cpus
in the system after they have been booted, and since it's an init function,
it will be removed.

Processor Information for CPUS: 0-191,208-223,256-271,...
Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 04
BogoMIPS: MIN 3989.01 (7978031) AVG 4266.62 (8533249) MAX 4537.51 (9075028)
Processor Information for CPUS: 192-207,240-255,272-287,...
Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 03
BogoMIPS: MIN 4021.49 (8042995) AVG 4265.91 (8531833) MAX 4479.79 (8959584)

> It's a really long line with 4096 CPUs but that's not a big problem - on 
> most systems it will look sane.
> 
> 	Ingo
