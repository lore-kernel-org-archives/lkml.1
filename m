Return-Path: <linux-kernel-owner+w=401wt.eu-S1761102AbXGJANu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102AbXGJANu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbXGJANn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:13:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56182 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758939AbXGJANm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:13:42 -0400
Date: Tue, 10 Jul 2007 02:14:14 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22: section mismatch warnings
Message-ID: <20070710001414.GO3492@stusta.de>
References: <20070709184200.GA2496@janus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070709184200.GA2496@janus>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 08:42:01PM +0200, Frank van Maarseveen wrote:
>...
> WARNING: kernel/built-in.o(.text+0x1add5): Section mismatch: reference to .init.text: (between 'kthreadd' and 'init_waitqueue_head')

Below is the fix in -mm for this (and other issues).

> Frank

cu
Adrian


<--  snip  -->


From: "Jan Beulich" <jbeulich@novell.com>

.. which modpost started warning about.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 +-
 mm/page_alloc.c  |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/kthread.c~mm-fix-improper-init-type-section-references kernel/kthread.c
--- a/kernel/kthread.c~mm-fix-improper-init-type-section-references
+++ a/kernel/kthread.c
@@ -215,7 +215,7 @@ int kthread_stop(struct task_struct *k)
 EXPORT_SYMBOL(kthread_stop);
 
 
-static __init void kthreadd_setup(void)
+static noinline __init_refok void kthreadd_setup(void)
 {
 	struct task_struct *tsk = current;
 
diff -puN mm/page_alloc.c~mm-fix-improper-init-type-section-references mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-improper-init-type-section-references
+++ a/mm/page_alloc.c
@@ -126,13 +126,13 @@ static unsigned long __meminitdata dma_r
     #endif
   #endif
 
-  struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
-  int __meminitdata nr_nodemap_entries;
-  unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
-  unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
+  static struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
+  static int __meminitdata nr_nodemap_entries;
+  static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
+  static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
 #ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-  unsigned long __initdata node_boundary_start_pfn[MAX_NUMNODES];
-  unsigned long __initdata node_boundary_end_pfn[MAX_NUMNODES];
+  static unsigned long __meminitdata node_boundary_start_pfn[MAX_NUMNODES];
+  static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
@@ -2598,7 +2598,7 @@ void __init push_node_boundaries(unsigne
 }
 
 /* If necessary, push the node boundary out for reserve hotadd */
-static void __init account_node_boundary(unsigned int nid,
+static void __meminit account_node_boundary(unsigned int nid,
 		unsigned long *start_pfn, unsigned long *end_pfn)
 {
 	printk(KERN_DEBUG "Entering account_node_boundary(%u, %lu, %lu)\n",
@@ -2618,7 +2618,7 @@ static void __init account_node_boundary
 void __init push_node_boundaries(unsigned int nid,
 		unsigned long start_pfn, unsigned long end_pfn) {}
 
-static void __init account_node_boundary(unsigned int nid,
+static void __meminit account_node_boundary(unsigned int nid,
 		unsigned long *start_pfn, unsigned long *end_pfn) {}
 #endif
 
_
