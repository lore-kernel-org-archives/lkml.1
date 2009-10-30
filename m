Return-Path: <linux-kernel-owner+w=401wt.eu-S933093AbZJ3XaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093AbZJ3XaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 19:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933058AbZJ3XaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 19:30:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39166 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933054AbZJ3XaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 19:30:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CvLHd7/LDcmksArrR3PMWEScCv3c4wccCWJcO2ExwFMRCGiY7RXMU1VAxqdeXkmbW
	LaA+K77+AvD6hSFoPdy+A==
Date: Fri, 30 Oct 2009 16:30:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
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
In-Reply-To: <4AEB4F0C.5020309@sgi.com>
Message-ID: <alpine.DEB.2.00.0910301620260.31387@chino.kir.corp.google.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com>
 <alpine.DEB.2.00.0910301248390.1090@chino.kir.corp.google.com> <4AEB4F0C.5020309@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009, Mike Travis wrote:

> > > x86_64: Limit the number of processor bootup messages
> > > 

Is this really only limited to 64 bit?

> > > With a large number of processors in a system there is an excessive amount
> > > of messages sent to the system console.  It's estimated that with 4096
> > > processors in a system, and the console baudrate set to 56K, the startup
> > > messages will take about 84 minutes to clear the serial port.
> > > 
> > > This set of patches limits the number of repetitious messages which
> > > contain
> > > no additional information.  Much of this information is obtainable from
> > > the
> > > /proc and /sysfs.   Most of the messages are also sent to the kernel log
> > > buffer as KERN_DEBUG messages so it can be used to examine more closely
> > > any
> > > details specific to a processor.
> > > 
> > > The list of message transformations....
> > > 
> > > For system_state == SYSTEM_BOOTING:
> > > 
> > > 	[   25.388280] Booting Processors 1-7,320-327, Node 0
> > > 	[   26.064742] Booting Processors 8-15,328-335, Node 1
> > > 	[   26.837006] Booting Processors 16-31,336-351, Nodes 2-3
> > > 	[   28.440427] Booting Processors 32-63,352-383, Nodes 4-7
> > > 	[   31.640450] Booting Processors 64-127,384-447, Nodes 8-15
> > > 	[   38.041430] Booting Processors 128-255,448-575, Nodes 16-31
> > > 	[   50.917504] Booting Processors 256-319,576-639, Nodes 32-39
> > > 	[   90.964169] Brought up 640 CPUs
> > > 
> > > The range of processors increases as a power of 2, so 4096 CPU's should
> > > only take 12 lines.
> > > 

On your particular machine, yes, but there's no x86 restriction on the 
number of cpus per node.

> > > @@ -671,6 +759,50 @@
> > > 	complete(&c_idle->done);
> > > }
> > > 
> > > +/* Summarize the "Booting processor ..." startup messages */
> > > +static void __init print_summary_bootmsg(int cpu)
> > > +{
> > > +	static int next_node, node_shift;
> > > +	int node = cpu_to_node(cpu);
> > > +
> > > +	if (node >= next_node) {
> > > +		cpumask_var_t cpulist;
> > > +
> > > +		node = next_node;
> > > +		next_node = 1 << node_shift;
> > > +		node_shift++;
> > > +
> > > +		if (alloc_cpumask_var(&cpulist, GFP_KERNEL)) {
> > > +			int i, tmp, last_node = node;
> > > +			char buf[32];
> > > +
> > > +			cpumask_clear(cpulist);
> > > +			for_each_present_cpu(i) {
> > > +				if (i == 0)	/* boot cpu */
> > > +					continue;
> > > +
> > > +				tmp = cpu_to_node(i);
> > > +				if (node <= tmp && tmp < next_node) {
> > > +					cpumask_set_cpu(i, cpulist);
> > > +					if (last_node < tmp)
> > > +						last_node = tmp;
> > > +				}
> > > +			}
> > > +			if (cpumask_weight(cpulist)) {
> > > +				cpulist_scnprintf(buf, sizeof(buf), cpulist);
> > > +				printk(KERN_INFO "Booting Processors %s,",
> > > buf);
> > > +
> > > +				if (node == last_node)
> > > +					printk(KERN_CONT " Node %d\n", node);
> > > +				else
> > > +					printk(KERN_CONT " Nodes %d-%d\n",
> > > +						node, last_node);
> > > +			}
> > > +			free_cpumask_var(cpulist);
> > > +		}
> > > +	}
> > > +}
> > > +
> > > /*
> > >  * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
> > >  * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
> > 
> > Why isn't cpumask_of_node() available yet?
> 
> I'll try that.  It gets a bit tricky in specifying the actual last node that
> is being booted.
> 

Why do you need to call print_summary_bootmsg() for each cpu?  It seems 
like you'd be able to move this out to a single call to a new function:

void __init print_summary_bootmsg(void)
{
	char buf[128];
	int nid;

	for_each_online_node(nid) {
		const struct cpumask *mask = cpumask_of_node(nid);

		if (cpumask_empty(mask))
			continue;
		cpulist_scnprintf(buf, sizeof(buf), cpumask_of_node(nid));
		pr_info("Booting Processors %s, Node %d\n", buf, nid);
	}
}
