Return-Path: <linux-kernel-owner+w=401wt.eu-S1760563AbYARKey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563AbYARKey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760446AbYARKeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:34:14 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:59216 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbYARKeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:34:12 -0500
Date: Fri, 18 Jan 2008 12:21:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC (Take 2)
Message-ID: <20080118065146.GB8973@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Michael Ellerman <michael@ellerman.id.au>,
	linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop> <1200635703.18783.5.camel@concordia.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1200635703.18783.5.camel@concordia.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Ellerman <michael@ellerman.id.au> [2008-01-18 16:55:03]:

> On Sat, 2007-12-08 at 04:07 +0530, Balbir Singh wrote:
> > Here's a dumb simple implementation of fake NUMA nodes for PowerPC. Fake
> > NUMA nodes can be specified using the following command line option
> > 
> 
> > 
> > Comments are as always welcome!
> 
> Here's some :)
> 

Thanks!

> > diff -puN arch/powerpc/mm/numa.c~ppc-fake-numa-easy arch/powerpc/mm/numa.c
> > --- linux-2.6.24-rc4-mm1/arch/powerpc/mm/numa.c~ppc-fake-numa-easy	2007-12-07 21:25:55.000000000 +0530
> > +++ linux-2.6.24-rc4-mm1-balbir/arch/powerpc/mm/numa.c	2007-12-08 03:19:46.000000000 +0530
> > @@ -24,6 +24,8 @@
> >  
> >  static int numa_enabled = 1;
> >  
> > +static char *cmdline __initdata;
> 
> Can you call this fake_numa_args or something, cmdline is a bit generic.
> 


I could if it makes code easier to understand. Will put it in my TODO
list.

> 
> > @@ -39,6 +41,43 @@ static bootmem_data_t __initdata plat_no
> >  static int min_common_depth;
> >  static int n_mem_addr_cells, n_mem_size_cells;
> >  
> > +static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
> > +						unsigned int *nid)
> > +{
> > +	unsigned long long mem;
> > +	char *p = cmdline;
> > +	static unsigned int fake_nid = 0;
> > +	static unsigned long long curr_boundary = 0;
> > +
> > +	*nid = fake_nid;
> 
> As I mentioned in my other email I think this is broken, you
> unconditionally overwrite *nid, even if no fake numa was specified?
> 

Aah.. OK.. looks like a BUG. I'll also respond to your other email.


> > +	if (!p)
> > +		return 0;
> > +
> > +	mem = memparse(p, &p);
> > +	if (!mem)
> > +		return 0;
> > +
> > +	if (mem < curr_boundary)
> > +		return 0;
> > +
> > +	curr_boundary = mem;
> > +
> > +	if ((end_pfn << PAGE_SHIFT) > mem) {
> > +		/*
> > +		 * Skip commas and spaces
> > +		 */
> > +		while (*p == ',' || *p == ' ' || *p == '\t')
> > +			p++;
> > +
> > +		cmdline = p;
> > +		fake_nid++;
> > +		*nid = fake_nid;
> > +		dbg("created new fake_node with id %d\n", fake_nid);
> > +		return 1;
> > +	}
> > +	return 0;
> > +}
> > +
> >  static void __cpuinit map_cpu_to_node(int cpu, int node)
> >  {
> >  	numa_cpu_lookup_table[cpu] = node;
> > @@ -344,12 +383,14 @@ static void __init parse_drconf_memory(s
> >  			if (nid == 0xffff || nid >= MAX_NUMNODES)
> >  				nid = default_nid;
> >  		}
> > -		node_set_online(nid);
> >  
> >  		size = numa_enforce_memory_limit(start, lmb_size);
> >  		if (!size)
> >  			continue;
> >  
> > +		fake_numa_create_new_node(((start + size) >> PAGE_SHIFT), &nid);
> > +		node_set_online(nid);
> 
> I can't convince myself that this is 100% ok, the moving of
> node_set_online(). At the very least it's a change in behaviour,
> previously we would online the node regardless of the memory limit.
> 

Hmm.. this can be reverted, but do we gain anything by enabling nodes,
even though we are over the memory limit?


> >  		add_active_range(nid, start >> PAGE_SHIFT,
> >  				 (start >> PAGE_SHIFT) + (size >> PAGE_SHIFT));
> >  	}
> > @@ -429,7 +470,6 @@ new_range:
> >  		nid = of_node_to_nid_single(memory);
> >  		if (nid < 0)
> >  			nid = default_nid;
> > -		node_set_online(nid);
> >  
> >  		if (!(size = numa_enforce_memory_limit(start, size))) {
> >  			if (--ranges)
> > @@ -438,6 +478,9 @@ new_range:
> >  				continue;
> >  		}
> >  
> > +		fake_numa_create_new_node(((start + size) >> PAGE_SHIFT), &nid);
> > +		node_set_online(nid);
> 
> Ditto previous comment.
> 

Yes, point noted.

Thanks for your review and problem report.

> cheers
> 
> -- 
> Michael Ellerman
> OzLabs, IBM Australia Development Lab
> 
> wwweb: http://michael.ellerman.id.au
> phone: +61 2 6212 1183 (tie line 70 21183)
> 
> We do not inherit the earth from our ancestors,
> we borrow it from our children. - S.M.A.R.T Person



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
