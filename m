Return-Path: <linux-kernel-owner+w=401wt.eu-S1764458AbYBAB5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764458AbYBAB5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbYBAB5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:57:32 -0500
Received: from relay2.sgi.com ([192.48.171.30]:52651 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752988AbYBAB5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:57:31 -0500
Date: Thu, 31 Jan 2008 17:57:25 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: mmu_notifier: invalidate_range for move_page_tables 
In-Reply-To: <20080201001355.GU7185@v2.random>
Message-ID: <Pine.LNX.4.64.0801311752200.24427@schroedinger.engr.sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.785269387@sgi.com>
 <20080131123118.GK7185@v2.random> <Pine.LNX.4.64.0801311355260.27804@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0801311421110.22290@schroedinger.engr.sgi.com>
 <20080201001355.GU7185@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmu_notifier: Provide invalidate_range for move_page_tables

Move page tables also needs to invalidate the external references
and hold new references off while moving page table entries.

This is already guaranteed by holding a writelock
on mmap_sem for get_user_pages() but follow_page() is not subject to
the mmap_sem locking.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/mremap.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/mm/mremap.c
===================================================================
--- linux-2.6.orig/mm/mremap.c	2008-01-25 14:25:31.000000000 -0800
+++ linux-2.6/mm/mremap.c	2008-01-31 17:54:19.000000000 -0800
@@ -18,6 +18,7 @@
 #include <linux/highmem.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -130,6 +131,8 @@ unsigned long move_page_tables(struct vm
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
+	mmu_notifier(invalidate_range_begin, vma->vm_mm,
+					old_addr, old_addr + len, 0);
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
 		cond_resched();
 		next = (old_addr + PMD_SIZE) & PMD_MASK;
@@ -150,6 +153,7 @@ unsigned long move_page_tables(struct vm
 		move_ptes(vma, old_pmd, old_addr, old_addr + extent,
 				new_vma, new_pmd, new_addr);
 	}
+	mmu_notifier(invalidate_range_end, vma->vm_mm, 0);
 
 	return len + old_addr - old_end;	/* how much done */
 }
