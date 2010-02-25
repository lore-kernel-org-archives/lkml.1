Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934282Ab0BYWba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:31:30 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:57958 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934167Ab0BYWb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:31:27 -0500
Date: Thu, 25 Feb 2010 16:31:00 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
In-Reply-To: <alpine.DEB.2.00.1002251315010.3501@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1002251627040.18861@router.home>
References: <20100211953.850854588@firstfloor.org> <20100211205404.085FEB1978@basil.firstfloor.org> <20100215061535.GI5723@laptop> <20100215103250.GD21783@one.firstfloor.org> <20100215104135.GM5723@laptop> <20100215105253.GE21783@one.firstfloor.org>
 <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box> <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi> <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1002251228140.18861@router.home> <alpine.DEB.2.00.1002251315010.3501@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, David Rientjes wrote:

> On Thu, 25 Feb 2010, Christoph Lameter wrote:
>
> > > I don't see how memory hotadd with a new node being onlined could have
> > > worked fine before since slab lacked any memory hotplug notifier until
> > > Andi just added it.
> >
> > AFAICR The cpu notifier took on that role in the past.
> >
>
> The cpu notifier isn't involved if the firmware notifies the kernel that a
> new ACPI memory device has been added or you write a start address to
> /sys/devices/system/memory/probe.  Hot-added memory devices can include
> ACPI_SRAT_MEM_HOT_PLUGGABLE entries in the SRAT for x86 that assign them
> non-online node ids (although all such entries get their bits set in
> node_possible_map at boot), so a new pgdat may be allocated for the node's
> registered range.

Yes Andi's work makes it explicit but there is already code in the cpu
notifier (see cpuup_prepare) that seems to have been intended to
initialize the node structures. Wonder why the hotplug people never
addressed that issue? Kame?


      list_for_each_entry(cachep, &cache_chain, next) {
                /*
                 * Set up the size64 kmemlist for cpu before we can
                 * begin anything. Make sure some other cpu on this
                 * node has not already allocated this
                 */
                if (!cachep->nodelists[node]) {
                        l3 = kmalloc_node(memsize, GFP_KERNEL, node);
                        if (!l3)
                                goto bad;
                        kmem_list3_init(l3);
                        l3->next_reap = jiffies + REAPTIMEOUT_LIST3 +
                            ((unsigned long)cachep) % REAPTIMEOUT_LIST3;

                        /*
                         * The l3s don't come and go as CPUs come and
                         * go.  cache_chain_mutex is sufficient
                         * protection here.
                         */
                        cachep->nodelists[node] = l3;
                }

                spin_lock_irq(&cachep->nodelists[node]->list_lock);
                cachep->nodelists[node]->free_limit =
                        (1 + nr_cpus_node(node)) *
                        cachep->batchcount + cachep->num;
                spin_unlock_irq(&cachep->nodelists[node]->list_lock);
        }


> kmalloc_node() in generic kernel code.  All that is done under
> MEM_GOING_ONLINE and not MEM_ONLINE, which is why I suggest the first and
> fourth patch in this series may not be necessary if we prevent setting the
> bit in the nodemask or building the zonelists until the slab nodelists are
> ready.

That sounds good.


