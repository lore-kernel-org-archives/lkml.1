Return-Path: <linux-kernel-owner+w=401wt.eu-S933810AbZGQFww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbZGQFww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 01:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933494AbZGQFww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 01:52:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42617 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476AbZGQFwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 01:52:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 17 Jul 2009 14:52:44 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Luming Yu <luming.yu@gmail.com>
Subject: Re: [RFC patch] delete improper hot pluggable code of memory affinity
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <3877989d0907162233x6e5874e5r3b679454160a6077@mail.gmail.com>
References: <20090717135847.38B3.E1E9C6FF@jp.fujitsu.com> <3877989d0907162233x6e5874e5r3b679454160a6077@mail.gmail.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20090717143818.38B7.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Without a fix like my proposal, I have seen NUMA configure disabled by
> kernel (due to the code the patch deletes) on a system with Enabled
> bit set , and Hotplug-able bit cleared, and
> CONFIG_MEMORY_HOTPLUG_SPARSE disabled.

Ok. I guess that save_add_info() was to check percentage of 
reserve area when CONFIG_MEMORY_HOTPLUG_RESERVE is set.
Its code was removed at 2.6.25, save_add_info() may be garbage now.

However, I have one question now.

>> - 	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
>> - 		update_nodes_add(node, start, end);
>> - 		/* restore nodes[node] */
>> - 		*nd = oldnode;
>> - 		if ((nd->start | nd->end) == 0)
>> - 			node_clear(node, nodes_parsed);
>> -     }

I don't understand why you remove this code. could you tell me why?

Bye.


> 
> On Fri, Jul 17, 2009 at 1:16 PM, Yasunori Goto<y-goto@jp.fujitsu.com> wrote:
> >
> > Hi, Luming-san.
> >
> >> The current kernel code *wrongly* interprets Hot Pluggable bit of
> >> Memory Affinity Structure (SRAT table in ACPI spec).
> >
> > I'm not sure your patch is correct or not yet, but I would like
> > to tell you a critical point about the definition of
> > Memory Affinity Structure.
> >
> > The spec says the Enable bit of Memory Affinity Structure means that
> > the contents of its memory affinity structure is only VALID.
> > It doesn't mean memory is really connected at the area.
> > It means only that OS can read the entry.
> >
> > When the enabled bit and hot pluggable bit is set on,
> > it may mean that the area may be hot-added after boot up.
> > So, kernel must check e820 or efi to confirm that memory is
> > really connected.
> >
> > If you already know it, sorry for noise....
> > Just for your information.
> >
> > Thanks.
> >
> >
> >
> >> if Hot Pluggable bit is set and CONFIG_MEMORY_HOTPLUG_SPARSE is NOT
> >> set, the memory Affinity will
> >> be ignored. And a faked Node will be used...
> >>
> >> An alternative is to enable CONFIG_MEMORY_HOTPLUG_SPARSE *always*
> >> along with acpi_numa_memory_affinity_init.
> >> Please decide which one is appropriate.
> >>
> >> The downside of this patch is *some useful info* is lost and a follow
> >> up patch is needed.
> >>
> >> **The patch is enclosed in text attachment*
> >> **Using web client to send the patch* *
> >> **below is for review, please apply attached ?patch*/
> >>
> >> Thanks,
> >> Luming
> >>
> >>
> >> Signed-off-by: Yu Luming <luming.yu@intel.com>
> >>
> >> ?srat_64.c | ? 16 ----------------
> >> ?1 file changed, 16 deletions(-)
> >>
> >>
> >> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> >> index 2dfcbf9..82423e5 100644
> >> --- a/arch/x86/mm/srat_64.c
> >> +++ b/arch/x86/mm/srat_64.c
> >> @@ -172,11 +172,6 @@ acpi_numa_processor_affinity_init(struct
> >> acpi_srat_cpu_affinity *pa)
> >> ? ? ? ? ? ? ?pxm, apic_id, node);
> >> ?}
> >>
> >> -#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
> >> -static inline int save_add_info(void) {return 1;}
> >> -#else
> >> -static inline int save_add_info(void) {return 0;}
> >> -#endif
> >> ?/*
> >> ? * Update nodes_add[]
> >> ? * This code supports one contiguous hot add area per node
> >> @@ -249,9 +244,6 @@ acpi_numa_memory_affinity_init(struct
> >> acpi_srat_mem_affinity *ma)
> >> ? ? ? }
> >> ? ? ? if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
> >> ? ? ? ? ? ? ? return;
> >> -
> >> - ? ? if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
> >> - ? ? ? ? ? ? return;
> >> ? ? ? start = ma->base_address;
> >> ? ? ? end = start + ma->length;
> >> ? ? ? pxm = ma->proximity_domain;
> >> @@ -291,14 +283,6 @@ acpi_numa_memory_affinity_init(struct
> >> acpi_srat_mem_affinity *ma)
> >> ? ? ? e820_register_active_regions(node, start >> PAGE_SHIFT,
> >> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?end >> PAGE_SHIFT);
> >>
> >> - ? ? if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
> >> - ? ? ? ? ? ? update_nodes_add(node, start, end);
> >> - ? ? ? ? ? ? /* restore nodes[node] */
> >> - ? ? ? ? ? ? *nd = oldnode;
> >> - ? ? ? ? ? ? if ((nd->start | nd->end) == 0)
> >> - ? ? ? ? ? ? ? ? ? ? node_clear(node, nodes_parsed);
> >> - ? ? }
> >> -
> >> ? ? ? node_memblk_range[num_node_memblks].start = start;
> >> ? ? ? node_memblk_range[num_node_memblks].end = end;
> >> ? ? ? memblk_nodeid[num_node_memblks] = node;
> >
> > --
> > Yasunori Goto
> >
> >
> >

-- 
Yasunori Goto 


