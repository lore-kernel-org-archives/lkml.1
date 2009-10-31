Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZJaA1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZJaA1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 20:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757025AbZJaA1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 20:27:44 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42463 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754179AbZJaA1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 20:27:43 -0400
Message-ID: <4AEB847C.4020003@sgi.com>
Date: Fri, 30 Oct 2009 17:27:40 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com> <alpine.DEB.2.00.0910301248390.1090@chino.kir.corp.google.com> <4AEB4F0C.5020309@sgi.com> <alpine.DEB.2.00.0910301620260.31387@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0910301620260.31387@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



David Rientjes wrote:
> On Fri, 30 Oct 2009, Mike Travis wrote:
> 
>>>> x86_64: Limit the number of processor bootup messages
>>>>
> 
> Is this really only limited to 64 bit?

[That was a quick edit to change it from SGI X86_64 UV and it didn't
occur to me to remove the _64. :-)]

> 
>>>> With a large number of processors in a system there is an excessive amount
>>>> of messages sent to the system console.  It's estimated that with 4096
>>>> processors in a system, and the console baudrate set to 56K, the startup
>>>> messages will take about 84 minutes to clear the serial port.
>>>>
>>>> This set of patches limits the number of repetitious messages which
>>>> contain
>>>> no additional information.  Much of this information is obtainable from
>>>> the
>>>> /proc and /sysfs.   Most of the messages are also sent to the kernel log
>>>> buffer as KERN_DEBUG messages so it can be used to examine more closely
>>>> any
>>>> details specific to a processor.
>>>>
>>>> The list of message transformations....
>>>>
>>>> For system_state == SYSTEM_BOOTING:
>>>>
>>>> 	[   25.388280] Booting Processors 1-7,320-327, Node 0
>>>> 	[   26.064742] Booting Processors 8-15,328-335, Node 1
>>>> 	[   26.837006] Booting Processors 16-31,336-351, Nodes 2-3
>>>> 	[   28.440427] Booting Processors 32-63,352-383, Nodes 4-7
>>>> 	[   31.640450] Booting Processors 64-127,384-447, Nodes 8-15
>>>> 	[   38.041430] Booting Processors 128-255,448-575, Nodes 16-31
>>>> 	[   50.917504] Booting Processors 256-319,576-639, Nodes 32-39
>>>> 	[   90.964169] Brought up 640 CPUs
>>>>
>>>> The range of processors increases as a power of 2, so 4096 CPU's should
>>>> only take 12 lines.
>>>>
> 
> On your particular machine, yes, but there's no x86 restriction on the 
> number of cpus per node.

Yes, my comment is wrong.  The limit would be 10 lines for the current kernel
limit of 512 nodes.

> 
>>>> @@ -671,6 +759,50 @@
>>>> 	complete(&c_idle->done);
>>>> }
>>>>
>>>> +/* Summarize the "Booting processor ..." startup messages */
>>>> +static void __init print_summary_bootmsg(int cpu)
>>>> +{
>>>> +	static int next_node, node_shift;
>>>> +	int node = cpu_to_node(cpu);
>>>> +
>>>> +	if (node >= next_node) {
>>>> +		cpumask_var_t cpulist;
>>>> +
>>>> +		node = next_node;
>>>> +		next_node = 1 << node_shift;
>>>> +		node_shift++;
>>>> +
>>>> +		if (alloc_cpumask_var(&cpulist, GFP_KERNEL)) {
>>>> +			int i, tmp, last_node = node;
>>>> +			char buf[32];
>>>> +
>>>> +			cpumask_clear(cpulist);
>>>> +			for_each_present_cpu(i) {
>>>> +				if (i == 0)	/* boot cpu */
>>>> +					continue;
>>>> +
>>>> +				tmp = cpu_to_node(i);
>>>> +				if (node <= tmp && tmp < next_node) {
>>>> +					cpumask_set_cpu(i, cpulist);
>>>> +					if (last_node < tmp)
>>>> +						last_node = tmp;
>>>> +				}
>>>> +			}
>>>> +			if (cpumask_weight(cpulist)) {
>>>> +				cpulist_scnprintf(buf, sizeof(buf), cpulist);
>>>> +				printk(KERN_INFO "Booting Processors %s,",
>>>> buf);
>>>> +
>>>> +				if (node == last_node)
>>>> +					printk(KERN_CONT " Node %d\n", node);
>>>> +				else
>>>> +					printk(KERN_CONT " Nodes %d-%d\n",
>>>> +						node, last_node);
>>>> +			}
>>>> +			free_cpumask_var(cpulist);
>>>> +		}
>>>> +	}
>>>> +}
>>>> +
>>>> /*
>>>>  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
>>>>  * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
>>> Why isn't cpumask_of_node() available yet?
>> I'll try that.  It gets a bit tricky in specifying the actual last node that
>> is being booted.
>>
> 
> Why do you need to call print_summary_bootmsg() for each cpu?  It seems 
> like you'd be able to move this out to a single call to a new function:
> 
> void __init print_summary_bootmsg(void)
> {
> 	char buf[128];
> 	int nid;
> 
> 	for_each_online_node(nid) {
> 		const struct cpumask *mask = cpumask_of_node(nid);
> 
> 		if (cpumask_empty(mask))
> 			continue;
> 		cpulist_scnprintf(buf, sizeof(buf), cpumask_of_node(nid));
> 		pr_info("Booting Processors %s, Node %d\n", buf, nid);
> 	}
> }

Well one thing I did find out, cpumask_of_node (or more specifically
node_to_cpumask_map[] is filled in while the CPU's are booting, not
before.

Also, the above could potentially print 512 lines of boot messages before
booting cpu 1. The printk times also would not be accurate for each group
of cpus.  And there's something to be said about actually doing what it
is you say you are doing. ;-)

	Booting Processors 0-15  Node 0
	Booting Processors 16-31  Node 1
	<Here you expect cpus 0-15 to have already been booted.>

Why not just say:

        cpulist_scnprintf(buf, sizeof(buf), cpu_present_mask);
        pr_info("Booting Processors %s\n", buf);

Since the node -> cpu map can be printed much more efficiently some other way?

For example:

	Nodes 0-7:  0-7,512-519   8-15,520-527   ...

would shrink it to 64 lines max.

(Note, it's important to include the "cpu_present_mask" because cpus can
be powered on disabled, and be booted later on, to decrease the initial
system startup time.)

A request was made (by AK?) that getting a general sense of progress is
a "good thing".  I wanted to avoid something more mundane like dots or
sequential numbers.  The one thing that Andi mentioned that I haven't
figured out is how to "delay print" specific cpu info in the case of a
boot error.  I suppose one way would be to save the current position in
the kernel log buffer at the start of each cpu boot, and print that to
the console in case of an error?

Thanks,
Mike

