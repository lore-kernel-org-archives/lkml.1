Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbXKHSuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbXKHSuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXKHSuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:50:03 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:55599 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753318AbXKHSuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:50:01 -0500
Date: Thu, 8 Nov 2007 10:50:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <Pine.LNX.4.64.0711081031420.7871@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711081048490.7871@schroedinger.engr.sgi.com>
References: <20071106195144.983665861@sgi.com>  <20071106195157.878563669@sgi.com>
 <1194525257.6289.145.camel@twins> <Pine.LNX.4.64.0711081031420.7871@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Christoph Lameter wrote:

> > Also, looking at the lock usage, this thing is not IRQ safe, so it
> > should not be called from hardirq context. Please document this.

Well I went the other way and made it work like the slab allocators.


cpu_alloc: Make it irq safe

Use the same method as used in SLAB/SLUB to make the allocator interrupt safe.
disable interrupts when allocator metadata is processed. Reenable interrupts
during page allocator calls if __GFP_WAIT is set in the flags passed to the
allocator.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/cpu_alloc.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/cpu_alloc.c
===================================================================
--- linux-2.6.orig/mm/cpu_alloc.c	2007-11-07 16:49:40.069701326 -0800
+++ linux-2.6/mm/cpu_alloc.c	2007-11-08 10:45:43.172294260 -0800
@@ -186,6 +186,8 @@ static int expand_cpu_area(gfp_t flags)
 		goto out;
 
 	spin_unlock(&cpu_alloc_map_lock);
+	if (flags & __GFP_WAIT)
+		local_irq_enable();
 
 	/*
 	 * Determine the size of the bit map needed
@@ -212,6 +214,8 @@ static int expand_cpu_area(gfp_t flags)
 			goto out;
 	}
 
+	if (flags & __GFP_WAIT)
+		local_irq_disable();
 	spin_lock(&cpu_alloc_map_lock);
 
 	/*
@@ -312,10 +316,11 @@ void *cpu_alloc(unsigned long size, gfp_
 	void *ptr;
 	int first;
 	unsigned long map_size;
+	unsigned long flags;
 
 	BUG_ON(gfpflags & ~(GFP_RECLAIM_MASK | __GFP_ZERO));
 
-	spin_lock(&cpu_alloc_map_lock);
+	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
 
 restart:
 	map_size = PAGE_SIZE << cpu_alloc_map_order;
@@ -358,7 +363,7 @@ restart:
 	units_free -= units;
 	__count_vm_events(CPU_BYTES, units * UNIT_SIZE);
 
-	spin_unlock(&cpu_alloc_map_lock);
+	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
 
 	ptr = cpu_area + start * UNIT_SIZE;
 
@@ -372,7 +377,7 @@ restart:
 	return ptr;
 
 out_of_memory:
-	spin_unlock(&cpu_alloc_map_lock);
+	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
 	return NULL;
 }
 EXPORT_SYMBOL(cpu_alloc);
@@ -386,13 +391,14 @@ void cpu_free(void *start, unsigned long
 	int units = size_to_units(size);
 	int index;
 	u8 *p = start;
+	unsigned long flags;
 
 	BUG_ON(p < cpu_area);
 	index = (p - cpu_area) / UNIT_SIZE;
 	BUG_ON(!test_bit(index, cpu_alloc_map) ||
 			index >= units_total);
 
-	spin_lock(&cpu_alloc_map_lock);
+	spin_lock_irqsave(&cpu_alloc_map_lock, flags);
 
 	clear_map(index, units);
 	units_free += units;
@@ -400,6 +406,6 @@ void cpu_free(void *start, unsigned long
 	if (index < first_free)
 		first_free = index;
 
-	spin_unlock(&cpu_alloc_map_lock);
+	spin_unlock_irqrestore(&cpu_alloc_map_lock, flags);
 }
 EXPORT_SYMBOL(cpu_free);
