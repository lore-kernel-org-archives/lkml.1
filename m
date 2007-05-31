Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbXEaSlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbXEaSlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbXEaSlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:41:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50388 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753976AbXEaSlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:41:23 -0400
Date: Thu, 31 May 2007 11:41:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: 2.6.22-rc3-mm1
In-Reply-To: <20070531113155.1c6d7185.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705311136200.11008@schroedinger.engr.sgi.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
 <465F0B83.2050100@googlemail.com> <20070531113155.1c6d7185.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Andrew Morton wrote:

> > l *0xc0181288
> > 0xc0181288 is in add_partial (/home/devel/linux-mm/mm/slub.c:1193).
> > 1188    }
> > 1189
> > 1190    static void add_partial(struct kmem_cache_node *n, struct page *page)
> > 1191    {
> > 1192            spin_lock(&n->list_lock);
> > 1193            n->nr_partial++;
> > 1194            list_add(&page->lru, &n->partial);
> > 1195            spin_unlock(&n->list_lock);
> > 1196    }
> > 1197

add_partial runs with interrupts disabled. The interrupts are disabled 
when we enter SLUB via allocator or free functions.

> > [ 4972.087650] {in-hardirq-W} state was registered at:
> > [ 4972.092656]   [<c0143bfe>] mark_lock+0x82/0x557
> > [ 4972.097323]   [<c0144c5f>] __lock_acquire+0x476/0xd36
> > [ 4972.102562]   [<c01455bd>] lock_acquire+0x9e/0xb8
> > [ 4972.107342]   [<c0348993>] _spin_lock+0x38/0x62
> > [ 4972.111993]   [<c0181d29>] deactivate_slab+0xb9/0x179
> > [ 4972.117300]   [<c0181e56>] flush_slab+0x6d/0x72
> > [ 4972.122063]   [<c0181e8c>] __flush_cpu_slab+0x31/0x36
> > [ 4972.127335]   [<c0181ea5>] flush_cpu_slab+0x14/0x17
> > [ 4972.132401]   [<c0113d6f>] smp_call_function_interrupt+0x3a/0x56
> > [ 4972.138607]   [<c0104c73>] call_function_interrupt+0x33/0x38
> > [ 4972.144503]   [<c0102b59>] default_idle+0x50/0x69
> > [ 4972.149421]   [<c01023eb>] cpu_idle+0xb3/0xf8
> > [ 4972.153889]   [<c03454fa>] rest_init+0x56/0x58
> > [ 4972.158402]   [<c04f39c7>] start_kernel+0x351/0x359
> > [ 4972.163450]   [<ffffffff>] 0xffffffff
> > [ 4972.167221] irq event stamp: 2451
> 
> Yep, that's a bug in slub.  We take that lock in the IPI handler.  If a CPU
> is currently holding that lock and then takes the IPI and enters
> add_partial(), it'll deadlock.

A cpu cannot enter an IPI handler while interrupts are disabled. That 
needs to be always the case when the list_lock is held.

> Perhaps a suitable fix would be local_irq_disable() in flush_slab().

As far as I can tell: Interrupts are always disabled when flush_slab is 
run. 

Sometimes we use spin_lock_irqsave for the list_lock and at other times 
spin_lock if interrupts are already disabled. Is that the problem?

