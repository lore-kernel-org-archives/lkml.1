Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbYFFPxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbYFFPxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYFFPwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:52:51 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48358 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755379AbYFFPwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:52:50 -0400
Message-ID: <48495D4E.2070203@sgi.com>
Date: Fri, 06 Jun 2008 08:52:46 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for June 5
References: <20080606115759.GA29321@elte.hu> <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com> <48493CBD.1000202@sgi.com> <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com> <19f34abd0806060707x7570c835u4b1837b54dfa36ba@mail.gmail.com> <484947A9.5050804@sgi.com> <19f34abd0806060736m10424455kfbc3e6272d18646e@mail.gmail.com> <20080606145717.GA5300@elte.hu> <20080606150102.GA14141@elte.hu> <19f34abd0806060813t10d422fel10dcb25c71f3b032@mail.gmail.com> <20080606152326.GA18359@elte.hu>
In-Reply-To: <20080606152326.GA18359@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> 
>>>> AFAICS this is not yet required for v2.6.26, as the requirement to 
>>>> never iterate to MAX_NUMNODES and call nr_cpus_node() with the 
>>>> index only got introduced by Mike's patch.
>>> the one below is needed as well i think.
>> Yeah. I think you had better take Mike's patches, I don't trust even 
>> that my patch and your fixlet does everything correctly.
> 
> yep, just discovered that we had them already ;-)
> 
> Thomas has just scripted up a new "detect if a commit is not in 
> linux-next yet" script that should avoid such problems in the future.
> 
> your second patch is still wanted, it would have detected the problem 
> earlier.
> 
> 	Ingo

Thanks, yes, I agree.  However I would like to modify it slightly:
---
Subject: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask

  * When CONFIG_DEBUG_PER_CPU_MAPS is set, the node passed to
    node_to_cpumask and node_to_cpumask_ptr should be validated.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/setup.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- linux-2.6.tip.orig/arch/x86/kernel/setup.c
+++ linux-2.6.tip/arch/x86/kernel/setup.c
@@ -399,6 +399,10 @@ int early_cpu_to_node(int cpu)
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
 
+
+/* empty cpumask */
+static cpumask_t cpu_mask_none;
+
 /*
  * Returns a pointer to the bitmask of CPUs on Node 'node'.
  */
@@ -411,6 +415,13 @@ cpumask_t *_node_to_cpumask_ptr(int node
 		dump_stack();
 		return &cpu_online_map;
 	}
+	if (node >= nr_node_ids) {
+		printk(KERN_WARNING
+			"_node_to_cpumask_ptr(%d): node > nr_node_ids(%d)\n",
+			node, nr_node_ids);
+		dump_stack();
+		return &cpu_mask_none;
+	}
 	return &node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(_node_to_cpumask_ptr);
@@ -426,6 +437,13 @@ cpumask_t node_to_cpumask(int node)
 		dump_stack();
 		return cpu_online_map;
 	}
+	if (node >= nr_node_ids) {
+		printk(KERN_WARNING
+			"node_to_cpumask(%d): node > nr_node_ids(%d)\n",
+			node, nr_node_ids);
+		dump_stack();
+		return cpu_mask_none;
+	}
 	return node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(node_to_cpumask);
