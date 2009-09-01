Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836AbZIAF54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbZIAF54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 01:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZIAF54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 01:57:56 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37044 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZIAF5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 01:57:55 -0400
Date: Tue, 1 Sep 2009 11:27:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix fake numa on ppc
Message-ID: <20090901055753.GB5563@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090901050316.GA4076@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090901050316.GA4076@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ankita Garg <ankita@in.ibm.com> [2009-09-01 10:33:16]:

> Hello,
> 
> Below is a patch to fix a couple of issues with fake numa node creation
> on ppc:
> 
> 1) Presently, fake nodes could be created such that real numa node
> boundaries are not respected. So a node could have lmbs that belong to
> different real nodes.
> 
> 2) The cpu association is broken. On a JS22 blade for example, which is
> a 2-node numa machine, I get the following:
> 
> # cat /proc/cmdline
> root=/dev/sda6  numa=fake=2G,4G,,6G,8G,10G,12G,14G,16G
> # cat /sys/devices/system/node/node0/cpulist
> 0-3
> # cat /sys/devices/system/node/node1/cpulist
> 4-7
> # cat /sys/devices/system/node/node4/cpulist
> 
> #
> 
> So, though the cpus 4-7 should have been associated with node4, they
> still belong to node1. The patch works by recording a real numa node
> boundary and incrementing the fake node count. At the same time, a
> mapping is stored from the real numa node to the first fake node that
> gets created on it.
>

Some details on how you tested it and results before and after would
be nice. Please see git commit 1daa6d08d1257aa61f376c3cc4795660877fb9e3
for example

 
> Any suggestions on improving the patch are most welcome!
> 
> Signed-off-by: Ankita Garg <ankita@in.ibm.com>
> 
> Index: linux-2.6.31-rc5/arch/powerpc/mm/numa.c
> ===================================================================
> --- linux-2.6.31-rc5.orig/arch/powerpc/mm/numa.c
> +++ linux-2.6.31-rc5/arch/powerpc/mm/numa.c
> @@ -26,6 +26,11 @@
>  #include <asm/smp.h>
> 
>  static int numa_enabled = 1;
> +static int fake_enabled = 1;
> +
> +/* The array maps a real numa node to the first fake node that gets
> +created on it */

Coding style is broken

> +int fake_numa_node_mapping[MAX_NUMNODES];
> 
>  static char *cmdline __initdata;
> 
> @@ -49,14 +54,24 @@ static int __cpuinit fake_numa_create_ne
>  	unsigned long long mem;
>  	char *p = cmdline;
>  	static unsigned int fake_nid;
> +	static unsigned int orig_nid = 0;

Should we call this prev_nid?

>  	static unsigned long long curr_boundary;
> 
>  	/*
>  	 * Modify node id, iff we started creating NUMA nodes
>  	 * We want to continue from where we left of the last time
>  	 */
> -	if (fake_nid)
> +	if (fake_nid) {
> +		if (orig_nid != *nid) {

OK, so this is called when the real NUMA node changes - comments would
be nice

> +			fake_nid++;
> +			fake_numa_node_mapping[*nid] = fake_nid;
> +			orig_nid = *nid;
> +			*nid = fake_nid;
> +			return 0;
> +		}
>  		*nid = fake_nid;
> +	}
> +
>  	/*
>  	 * In case there are no more arguments to parse, the
>  	 * node_id should be the same as the last fake node id
> @@ -440,7 +455,7 @@ static int of_drconf_to_nid_single(struc
>   */
>  static int __cpuinit numa_setup_cpu(unsigned long lcpu)
>  {
> -	int nid = 0;
> +	int nid = 0, new_nid;
>  	struct device_node *cpu = of_get_cpu_node(lcpu, NULL);
> 
>  	if (!cpu) {
> @@ -450,8 +465,15 @@ static int __cpuinit numa_setup_cpu(unsi
> 
>  	nid = of_node_to_nid_single(cpu);
> 
> +	if (fake_enabled && nid) {
> +		new_nid = fake_numa_node_mapping[nid];
> +		if (new_nid > 0)
> +			nid = new_nid;
> +	}
> +
>  	if (nid < 0 || !node_online(nid))
>  		nid = any_online_node(NODE_MASK_ALL);
> +
>  out:
>  	map_cpu_to_node(lcpu, nid);
> 
> @@ -1005,8 +1027,11 @@ static int __init early_numa(char *p)
>  		numa_debug = 1;
> 
>  	p = strstr(p, "fake=");
> -	if (p)
> +	if (p) {
>  		cmdline = p + strlen("fake=");
> +		if (numa_enabled)
> +			fake_enabled = 1;

Have you tried passing just numa=fake= without any commandline?
That should enable fake_enabled, but I wonder if that negatively
impacts numa_setup_cpu(). I wonder if you should look at cmdline
to decide on fake_enabled.

> +	}
> 
>  	return 0;
>  }
>

Overall, I think this is the right thing to do, we need to move in
this direction. 

-- 
	Balbir
