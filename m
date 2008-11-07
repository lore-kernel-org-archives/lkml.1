Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbYKGTJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbYKGTJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYKGTJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:09:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38731 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbYKGTJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:09:46 -0500
Date: Fri, 7 Nov 2008 14:09:44 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: allocation failure in b43/ssb
Message-ID: <20081107190944.GA18949@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We just had a report from a user who spotted a bunch of messages
of the form below in his logs..

swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.26.6-79.fc9.i686.debug #1
[<c064a320>] ? printk+0xf/0x17
[<c0472da5>] __alloc_pages_internal+0x3c0/0x3db
[<c0472dd7>] __alloc_pages+0xa/0xc
[<c048bbab>] __slab_alloc+0x1aa/0x4ea
[<c048c74d>] __kmalloc_track_caller+0x98/0xf9
[<eec655c2>] ? setup_rx_descbuffer+0x3d/0x1cf [b43]
[<eec655c2>] ? setup_rx_descbuffer+0x3d/0x1cf [b43]
[<c05d5280>] __alloc_skb+0x49/0xf8
[<eec655c2>] setup_rx_descbuffer+0x3d/0x1cf [b43]
[<eeb9d783>] ? ssb_pci_read32+0x29/0x31 [ssb]
[<eec65a2e>] b43_dma_rx+0x28b/0x3f1 [b43]
[<eec59a83>] b43_interrupt_tasklet+0x58f/0x6e4 [b43]
[<c042eb92>] ? tasklet_action+0x40/0xec
[<c042ebd1>] tasklet_action+0x7f/0xec
[<c042f502>] __do_softirq+0x84/0x10a
[<c0406f6e>] do_softirq+0x79/0xda
[<c04685ed>] ? handle_fasteoi_irq+0x0/0xb6
[<c042f068>] irq_exit+0x44/0x77
[<c04070b3>] do_IRQ+0xe4/0xfd
[<c040567a>] common_interrupt+0x2e/0x34
[<c04400d8>] ? pm_qos_add_requirement+0x39/0x93
[<c05524e9>] ? acpi_idle_enter_simple+0x19e/0x20e
[<c05520c2>] acpi_idle_enter_bm+0xbc/0x345
[<c043fe82>] ? pm_qos_requirement+0x26/0x2b
[<c05beb2a>] ? menu_select+0x38/0x86
[<c05bdea1>] cpuidle_idle_call+0x67/0x97
[<c05bde3a>] ? cpuidle_idle_call+0x0/0x97
[<c0403bfc>] cpu_idle+0xb8/0xd8
[<c063ce6e>] rest_init+0x4e/0x50
=======================
Mem-info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 125
Active:127308 inactive:26735 dirty:8411 writeback:340 unstable:0
free:1213 slab:15322 mapped:13069 pagetables:1563 bounce:0
DMA free:2864kB min:72kB low:88kB high:108kB active:2784kB inactive:1552kB present:16160kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 709 709 709
Normal free:1988kB min:3368kB low:4208kB high:5052kB active:506448kB inactive:105388kB present:726060kB pages_scanned:1460 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 34*4kB 1*8kB 8*16kB 11*32kB 9*64kB 3*128kB 1*256kB 2*512kB 0*1024kB 0*2048kB 0*4096kB = 2864kB
Normal: 341*4kB 2*8kB 20*16kB 1*32kB 0*64kB 0*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1988kB
78549 total pagecache pages
Swap cache: add 352198, delete 308691, find 91428/128877
Free swap  = 1065960kB
Total swap = 1502068kB
188128 pages of RAM
0 pages of HIGHMEM
4850 reserved pages
100808 pages shared
43507 pages swap cached
8411 pages dirty
340 pages writeback
13069 pages mapped
15322 pages slab
1563 pages pagetables


The kernel is a little old (2.6.26).

Looking at it though, I'm puzzled..

It seems we failed to allocate an order-1 allocation, even though
we had memory available in the DMA and normal zones.

What am I missing?

Full logs at https://bugzilla.redhat.com/attachment.cgi?id=322882

	Dave

-- 
http://www.codemonkey.org.uk
