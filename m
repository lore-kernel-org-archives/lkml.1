Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbZIAO2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbZIAO2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZIAO2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:28:25 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:33511 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbZIAO2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:28:24 -0400
Date: Tue, 1 Sep 2009 19:57:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ankita Garg <ankita@in.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix fake numa on ppc
Message-ID: <20090901142729.GA5022@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090901050316.GA4076@in.ibm.com>
 <20090901055753.GB5563@balbir.in.ibm.com>
 <20090901092407.GC4076@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090901092407.GC4076@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ankita Garg <ankita@in.ibm.com> [2009-09-01 14:54:07]:

> Hi Balbir,
> 
> On Tue, Sep 01, 2009 at 11:27:53AM +0530, Balbir Singh wrote:
> > * Ankita Garg <ankita@in.ibm.com> [2009-09-01 10:33:16]:
> > 
> > > Hello,
> > > 
> > > Below is a patch to fix a couple of issues with fake numa node creation
> > > on ppc:
> > > 
> > > 1) Presently, fake nodes could be created such that real numa node
> > > boundaries are not respected. So a node could have lmbs that belong to
> > > different real nodes.
> > > 
> > > 2) The cpu association is broken. On a JS22 blade for example, which is
> > > a 2-node numa machine, I get the following:
> > > 
> > > # cat /proc/cmdline
> > > root=/dev/sda6  numa=fake=2G,4G,,6G,8G,10G,12G,14G,16G
> > > # cat /sys/devices/system/node/node0/cpulist
> > > 0-3
> > > # cat /sys/devices/system/node/node1/cpulist
> > > 4-7
> > > # cat /sys/devices/system/node/node4/cpulist
> > > 
> > > #
> > > 
> > > So, though the cpus 4-7 should have been associated with node4, they
> > > still belong to node1. The patch works by recording a real numa node
> > > boundary and incrementing the fake node count. At the same time, a
> > > mapping is stored from the real numa node to the first fake node that
> > > gets created on it.
> > >
> > 
> > Some details on how you tested it and results before and after would
> > be nice. Please see git commit 1daa6d08d1257aa61f376c3cc4795660877fb9e3
> > for example
> > 
> >
> 
> Thanks for the quick review of the patch. Here is some information on
> the testing:
> 
> Tested the patch with the following commandlines:
> numa=fake=2G,4G,6G,8G,10G,12G,14G,16G
> numa=fake=3G,6G,10G,16G
> numa=fake=4G
> numa=fake=
> 
> For testing if the fake nodes respect the real node boundaries, I added
> some debug printks in the node creation path. Without the patch, for the
> commandline numa=fake=2G,4G,6G,8G,10G,12G,14G,16G, this is what I got:
> 
> fake id: 1 nid: 0
> fake id: 1 nid: 0
> ...
> fake id: 2 nid: 0
> fake id: 2 nid: 0
> ...
> fake id: 2 nid: 0
> created new fake_node with id 3
> fake id: 3 nid: 0
> fake id: 3 nid: 0
> ...
> fake id: 3 nid: 0
> fake id: 3 nid: 0
> fake id: 3 nid: 1
> fake id: 3 nid: 1
> ...
> created new fake_node with id 4
> fake id: 4 nid: 1
> fake id: 4 nid: 1
> ...
> 
> and so on. So, fake node 3 encompasses real node 0 & 1. Also,
> 
> # cat /sys/devices/system/node/node3/meminfo
> Node 0 MemTotal:        2097152 kB
> ...
> # # cat /sys/devices/system/node/node4/meminfo
> Node 0 MemTotal:        2097152 kB
> ...
> 
> 
> With the patch, I get:
> 
> fake id: 1 nid: 0
> fake id: 1 nid: 0
> ...
> fake id: 2 nid: 0
> fake id: 2 nid: 0
> ...
> fake id: 2 nid: 0
> created new fake_node with id 3
> fake id: 3 nid: 0
> fake id: 3 nid: 0
> ...
> fake id: 3 nid: 0
> fake id: 3 nid: 0
> created new fake_node with id 4
> fake id: 4 nid: 1
> fake id: 4 nid: 1
> ...
> 
> and so on. With the patch, the fake node sizes are slightly different
> from that specified by the user.
> 
> # cat /sys/devices/system/node/node3/meminfo
> Node 3 MemTotal:        1638400 kB
> ...
> # cat /sys/devices/system/node/node4/meminfo
> Node 4 MemTotal:         458752 kB
> ...
> 
> CPU association was tested as mentioned in the previous mail:
> 
> Without the patch,
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
> With the patch,
> 
> # cat /proc/cmdline
> root=/dev/sda6  numa=fake=2G,4G,,6G,8G,10G,12G,14G,16G
> # cat /sys/devices/system/node/node0/cpulist
> 0-3
> # cat /sys/devices/system/node/node1/cpulist
> 

Oh! interesting.. cpuless nodes :) I think we need to fix this in the
longer run and distribute cpus between fake numa nodes of a real node
using some acceptable heuristic.

> # cat /sys/devices/system/node/node4/cpulist
> 4-7
> 
> > > 
> > > Signed-off-by: Ankita Garg <ankita@in.ibm.com>
> > > 
> > > Index: linux-2.6.31-rc5/arch/powerpc/mm/numa.c
> > > ===================================================================
> > > --- linux-2.6.31-rc5.orig/arch/powerpc/mm/numa.c
> > > +++ linux-2.6.31-rc5/arch/powerpc/mm/numa.c
> > > @@ -26,6 +26,11 @@
> > >  #include <asm/smp.h>
> > > 
> > >  static int numa_enabled = 1;
> > > +static int fake_enabled = 1;
> > > +
> > > +/* The array maps a real numa node to the first fake node that gets
> > > +created on it */
> > 
> > Coding style is broken
> > 
> 
> Fixed.
> 
> > > +int fake_numa_node_mapping[MAX_NUMNODES];
> > > 
> > >  static char *cmdline __initdata;
> > > 
> > > @@ -49,14 +54,24 @@ static int __cpuinit fake_numa_create_ne
> > >  	unsigned long long mem;
> > >  	char *p = cmdline;
> > >  	static unsigned int fake_nid;
> > > +	static unsigned int orig_nid = 0;
> > 
> > Should we call this prev_nid?
> > 
> 
> Yes, makes sense.
> > >  	static unsigned long long curr_boundary;
> > > 
> > >  	/*
> > >  	 * Modify node id, iff we started creating NUMA nodes
> > >  	 * We want to continue from where we left of the last time
> > >  	 */
> > > -	if (fake_nid)
> > > +	if (fake_nid) {
> > > +		if (orig_nid != *nid) {
> > 
> > OK, so this is called when the real NUMA node changes - comments would
> > be nice
> >
> 
> Thanks, have added the comment.
> 
> > > +			fake_nid++;
> > > +			fake_numa_node_mapping[*nid] = fake_nid;
> > > +			orig_nid = *nid;
> > > +			*nid = fake_nid;
> > > +			return 0;
> > > +		}
> > >  		*nid = fake_nid;
> > > +	}
> > > +
> > >  	/*
> > >  	 * In case there are no more arguments to parse, the
> > >  	 * node_id should be the same as the last fake node id
> > > @@ -440,7 +455,7 @@ static int of_drconf_to_nid_single(struc
> > >   */
> > >  static int __cpuinit numa_setup_cpu(unsigned long lcpu)
> > >  {
> > > -	int nid = 0;
> > > +	int nid = 0, new_nid;
> > >  	struct device_node *cpu = of_get_cpu_node(lcpu, NULL);
> > > 
> > >  	if (!cpu) {
> > > @@ -450,8 +465,15 @@ static int __cpuinit numa_setup_cpu(unsi
> > > 
> > >  	nid = of_node_to_nid_single(cpu);
> > > 
> > > +	if (fake_enabled && nid) {
> > > +		new_nid = fake_numa_node_mapping[nid];
> > > +		if (new_nid > 0)
> > > +			nid = new_nid;
> > > +	}
> > > +
> > >  	if (nid < 0 || !node_online(nid))
> > >  		nid = any_online_node(NODE_MASK_ALL);
> > > +
> > >  out:
> > >  	map_cpu_to_node(lcpu, nid);
> > > 
> > > @@ -1005,8 +1027,11 @@ static int __init early_numa(char *p)
> > >  		numa_debug = 1;
> > > 
> > >  	p = strstr(p, "fake=");
> > > -	if (p)
> > > +	if (p) {
> > >  		cmdline = p + strlen("fake=");
> > > +		if (numa_enabled)
> > > +			fake_enabled = 1;
> > 
> > Have you tried passing just numa=fake= without any commandline?
> > That should enable fake_enabled, but I wonder if that negatively
> > impacts numa_setup_cpu(). I wonder if you should look at cmdline
> > to decide on fake_enabled.
> >
> 
> fake_enabled does get set even for numa=fake=. However, it does not
> impact numa_setup_cpu, since fake_numa_node_mapping array would have no
> mapping stored and there is a condition there already to check for the
> value of the mapping. I confirmed this by booting with the above
> parameter as well.
> 
> > > +	}
> > > 
> > >  	return 0;
> > >  }
> > >
> > 
> > Overall, I think this is the right thing to do, we need to move in
> > this direction. 
> > 
> 
> Heres the updated patch:
> 
> Signed-off-by: Ankita Garg <ankita@in.ibm.com> 
> 
> Index: linux-2.6.31-rc5/arch/powerpc/mm/numa.c
> ===================================================================
> --- linux-2.6.31-rc5.orig/arch/powerpc/mm/numa.c
> +++ linux-2.6.31-rc5/arch/powerpc/mm/numa.c
> @@ -26,6 +26,13 @@
>  #include <asm/smp.h>
> 
>  static int numa_enabled = 1;
> +static int fake_enabled = 1;
> +
> +/*
> + * The array maps a real numa node to the first fake node that gets
> + * created on it
> + */
> +int fake_numa_node_mapping[MAX_NUMNODES];
> 
>  static char *cmdline __initdata;
> 
> @@ -49,14 +56,29 @@ static int __cpuinit fake_numa_create_ne
>  	unsigned long long mem;
>  	char *p = cmdline;
>  	static unsigned int fake_nid;
> +	static unsigned int prev_nid = 0;
>  	static unsigned long long curr_boundary;
> 
>  	/*
>  	 * Modify node id, iff we started creating NUMA nodes
>  	 * We want to continue from where we left of the last time
>  	 */
> -	if (fake_nid)
> +	if (fake_nid) {
> +		/*
> +		 * Moved over to the next real numa node, increment fake
> +		 * node number and store the mapping of the real node to
> +		 * the fake node
> +		 */
> +		if (prev_nid != *nid) {
> +			fake_nid++;
> +			fake_numa_node_mapping[*nid] = fake_nid;
> +			prev_nid = *nid;
> +			*nid = fake_nid;
> +			return 0;
> +		}
>  		*nid = fake_nid;
> +	}
> +
>  	/*
>  	 * In case there are no more arguments to parse, the
>  	 * node_id should be the same as the last fake node id
> @@ -440,7 +462,7 @@ static int of_drconf_to_nid_single(struc
>   */
>  static int __cpuinit numa_setup_cpu(unsigned long lcpu)
>  {
> -	int nid = 0;
> +	int nid = 0, new_nid;
>  	struct device_node *cpu = of_get_cpu_node(lcpu, NULL);
> 
>  	if (!cpu) {
> @@ -450,8 +472,15 @@ static int __cpuinit numa_setup_cpu(unsi
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
> @@ -1005,8 +1034,12 @@ static int __init early_numa(char *p)
>  		numa_debug = 1;
> 
>  	p = strstr(p, "fake=");
> -	if (p)
> +	if (p) {
>  		cmdline = p + strlen("fake=");
> +		if (numa_enabled) {
> +			fake_enabled = 1;
> +		}
> +	}
> 
>  	return 0;
>  }
>


Looks good to me


Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
 

-- 
	Balbir
