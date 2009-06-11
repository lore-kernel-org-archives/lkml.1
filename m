Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbZFKLuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbZFKLuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762823AbZFKLtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:49:52 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39161 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761424AbZFKLtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:49:51 -0400
Date: Thu, 11 Jun 2009 14:49:52 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early boot SLAB for 2.6.31
In-Reply-To: <20090611114032.GA8856@elte.hu>
Message-ID: <Pine.LNX.4.64.0906111448510.11179@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>
 <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
 <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain>
 <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI> <20090611113512.GA6971@elte.hu>
 <20090611114032.GA8856@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Ingo Molnar wrote:
> Wasnt this supposed to have gone away with this tree?

Yes, if I hadn't messed up the merge conflict fixup. :-) I am not hitting 
that with my configuration, btw.

			Pekka

>From fc1ebbcad1d86b67deed4442df9445cc81061c85 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Thu, 11 Jun 2009 14:46:49 +0300
Subject: [PATCH] irq: use kcalloc() instead of the bootmem allocator

Fixes the following problem:

[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:4352 nr_irqs:256
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at mm/bootmem.c:537 alloc_arch_preferred_bootmem+0x40/0x7e()
[    0.000000] Hardware name: To Be Filled By O.E.M.
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-tip-02161-g7a74539-dirty #59709
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff823f8c8e>] ? alloc_arch_preferred_bootmem+0x40/0x7e
[    0.000000]  [<ffffffff81067168>] warn_slowpath_common+0x88/0xcb
[    0.000000]  [<ffffffff810671d2>] warn_slowpath_null+0x27/0x3d
[    0.000000]  [<ffffffff823f8c8e>] alloc_arch_preferred_bootmem+0x40/0x7e
[    0.000000]  [<ffffffff823f9307>] ___alloc_bootmem_nopanic+0x4e/0xec
[    0.000000]  [<ffffffff823f93c5>] ___alloc_bootmem+0x20/0x61
[    0.000000]  [<ffffffff823f962e>] __alloc_bootmem+0x1e/0x34
[    0.000000]  [<ffffffff823f757c>] early_irq_init+0x6d/0x118
[    0.000000]  [<ffffffff823e0140>] ? early_idt_handler+0x0/0x71
[    0.000000]  [<ffffffff823e0cf7>] start_kernel+0x192/0x394
[    0.000000]  [<ffffffff823e0140>] ? early_idt_handler+0x0/0x71
[    0.000000]  [<ffffffff823e02ad>] x86_64_start_reservations+0xb4/0xcf
[    0.000000]  [<ffffffff823e0000>] ? __init_begin+0x0/0x140
[    0.000000]  [<ffffffff823e0420>] x86_64_start_kernel+0x158/0x17b
[    0.000000] ---[ end trace a7919e7f17c0a725 ]---
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2002.510 MHz processor.
[    0.004000] Console: colour VGA+ 80x25

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 kernel/irq/handle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index e161999..1045785 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -164,7 +164,7 @@ int __init early_irq_init(void)
  	node = first_online_node;
 
 	/* allocate irq_desc_ptrs array based on nr_irqs */
-	irq_desc_ptrs = alloc_bootmem(nr_irqs * sizeof(void *));
+	irq_desc_ptrs = kcalloc(nr_irqs, sizeof(void *), GFP_NOWAIT);
 
 	/* allocate based on nr_cpu_ids */
 	kstat_irqs_legacy = kzalloc_node(NR_IRQS_LEGACY * nr_cpu_ids *
-- 
1.6.0.4

