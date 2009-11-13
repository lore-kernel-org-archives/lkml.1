Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZKMKO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZKMKO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbZKMKOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:14:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56466 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606AbZKMKOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:14:23 -0500
Date: Fri, 13 Nov 2009 11:13:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>,
       Andreas Herrmann <herrmann.der.user@googlemail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
Message-ID: <20091113101326.GA17451@elte.hu>
References: <20091112171934.584037000@alcatraz.americas.sgi.com>
 <alpine.DEB.2.00.0911121247420.9544@chino.kir.corp.google.com>
 <20091113095350.GC1364@elte.hu>
 <alpine.DEB.2.00.0911130158390.13911@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911130158390.13911@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> On Fri, 13 Nov 2009, Ingo Molnar wrote:
> 
> > > It's possible to reduce the number of SRAT messages emitted to the kernel
> > > log by printing each valid pxm once and then creating bitmaps to represent
> > > the apic ids that map to the same node.
> > > 
> > > This reduces lines such as
> > > 
> > > 	SRAT: PXM 0 -> APIC 0 -> Node 0
> > > 	SRAT: PXM 0 -> APIC 1 -> Node 0
> > > 	SRAT: PXM 1 -> APIC 2 -> Node 1
> > > 	SRAT: PXM 1 -> APIC 3 -> Node 1
> > > 
> > > to
> > > 
> > > 	SRAT: PXM 0 -> APIC {0-1} -> Node 0
> > > 	SRAT: PXM 1 -> APIC {2-3} -> Node 1
> > > 
> > > The buffer used to store the apic id list is 128 characters in length.
> > > If that is too small to represent all the apic id ranges that are bound
> > > to a single pxm, a trailing "..." is added.  APICID_LIST_LEN should be
> > > manually increased for such configurations.
> > > 
> > > Acked-by: Mike Travis <travis@sgi.com>
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> > > ---
> > >  arch/x86/mm/srat_64.c |   41 +++++++++++++++++++++++++++++++++++++----
> > >  drivers/acpi/numa.c   |    5 +++++
> > >  include/linux/acpi.h  |    3 ++-
> > >  3 files changed, 44 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> > > --- a/arch/x86/mm/srat_64.c
> > > +++ b/arch/x86/mm/srat_64.c
> > > @@ -36,6 +36,9 @@ static int num_node_memblks __initdata;
> > >  static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
> > >  static int memblk_nodeid[NR_NODE_MEMBLKS] __initdata;
> > >  
> > > +static DECLARE_BITMAP(apicid_map, MAX_LOCAL_APIC) __initdata;
> > > +#define APICID_LIST_LEN	(128)
> > > +
> > >  static __init int setup_node(int pxm)
> > >  {
> > >  	return acpi_map_pxm_to_node(pxm);
> > > @@ -136,8 +139,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
> > >  	apicid_to_node[apic_id] = node;
> > >  	node_set(node, cpu_nodes_parsed);
> > >  	acpi_numa = 1;
> > > -	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
> > > -	       pxm, apic_id, node);
> > >  }
> > >  
> > >  /* Callback for Proximity Domain -> LAPIC mapping */
> > > @@ -170,8 +171,40 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
> > >  	apicid_to_node[apic_id] = node;
> > >  	node_set(node, cpu_nodes_parsed);
> > >  	acpi_numa = 1;
> > > -	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
> > > -	       pxm, apic_id, node);
> > > +}
> > > +
> > > +void __init acpi_numa_print_srat_mapping(void)
> > > +{
> > > +	char apicid_list[APICID_LIST_LEN];
> > > +	int i, j;
> > > +
> > > +	for (i = 0; i < MAX_PXM_DOMAINS; i++) {
> > > +		int len;
> > > +		int nid;
> > > +
> > > +		nid = pxm_to_node(i);
> > > +		if (nid == NUMA_NO_NODE)
> > > +			continue;
> > > +
> > > +		bitmap_zero(apicid_map, MAX_LOCAL_APIC);
> > > +		for (j = 0; j < MAX_LOCAL_APIC; j++)
> > > +			if (apicid_to_node[j] == nid)
> > > +				set_bit(j, apicid_map);
> > > +
> > > +		if (bitmap_empty(apicid_map, MAX_LOCAL_APIC))
> > > +			continue;
> > > +
> > > +		/*
> > > +		 * If the bitmap cannot be listed in a buffer of length
> > > +		 * APICID_LIST_LEN, then it is suffixed with "...".
> > > +		 */
> > > +		len = bitmap_scnlistprintf(apicid_list, APICID_LIST_LEN,
> > > +					   apicid_map, MAX_LOCAL_APIC);
> > > +		pr_info("SRAT: PXM %u -> APIC {%s%s} -> Node %u\n",
> > > +			i, apicid_list,
> > > +			(len == APICID_LIST_LEN - 1) ? "..." : "",
> > > +			nid);
> > > +	}
> > >  }
> > 
> > No. As i suggested many times before, just get rid of the printouts or 
> > make them boot-debug-flag dependent.
> > 
> 
> Hmm, so even if these were dependent on a kernel parameter, do you think 
> this patch would still be needed exactly as it is written?  In other 
> words, do you believe that Mark's system should really emit 1272 lines for 
> this data instead of the 40 with this patch?
> 
> I'm all for making this dependent on a kernel parameter, but it's a 
> seperate change than what this patch is addressing.  We need the apic 
> id mappings because they aren't exposed to userspace in any other way, 
> they need to exported somehow and this is a clear improvement to 
> reduce verbosity in the kernel log.
>
> So I really don't know what you're insisting here, you want this 
> compression to be accompanied by another patch which makes the call to 
> acpi_numa_print_srat_mapping() depend on a kernel parameter?  Or are 
> you saying we shouldn't compress it at all and Mike should just deal 
> with 1272 lines instead of 40?  Or are you saying we should export 
> this static information via sysfs?

There's two problems outlined in this discussion:

 A) too verbose bootup that is annoying with 64 CPUs and a show-stopper
    with 4096 CPUs.

 B) the ad-hoc nature of our topology enumeration. Some of it is in
    /sys, some of it is in printk logs. None really works well and 
    there's no structure in it.

The simplest solution for (A) is what i suggested a few mails ago: dont 
print the information by default, but allow (for trouble-shooting) 
purposes for it to be printed when a boot option is passed.

Problem (B), topology info enumeration of a successful bootup is a 
different matter. It should be exposed to user-space via proper /sys 
abstractions, not via ad-hoc printks. There's ongoing work in that area, 
from Andreas Hermann, with patches posted. hpa expressed the view there 
that topology structure should be expressed via a nice vfs abstraction - 
i share that opinion.

	Ingo
