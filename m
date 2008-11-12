Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbYKLWSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbYKLWSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYKLWRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:17:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59837 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYKLWRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:17:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: Hibernate: Fix breakage on x86_32 with CONFIG_NUMA set (was: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE)
Date: Wed, 12 Nov 2008 23:22:35 +0100
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20081109140726.GB1786@ucw.cz> <20081112104951.GB11945@ucw.cz> <200811122257.50998.rjw@sisk.pl>
In-Reply-To: <200811122257.50998.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122322.36781.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: x86: Hibernate: Fix breakage on x86_32 with CONFIG_NUMA set

The NUMA code on x86_32 creates special memory mapping that allows
each node's pgdat to be located in this node's memory.  For this
purpose it allocates a memory area at the end of each node's memory
and maps this area so that it is accessible with virtual addresses
belonging to low memory.  As a result, if there is high memory,
these NUMA-allocated areas are physically located in high memory,
although they are mapped to low memory addresses.

Our hibernation code does not take that into account and for this
reason hibernation fails on all x86_32 systems with CONFIG_NUMA=y and
with high memory present.  Fix this by adding a special mapping for
the NUMA-allocated memory areas to the temporary page tables created
during the last phase of resume.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/mmzone_32.h |    4 ++++
 arch/x86/mm/numa_32.c            |   35 +++++++++++++++++++++++++++++++++++
 arch/x86/power/hibernate_32.c    |    4 ++++
 3 files changed, 43 insertions(+)

Index: linux-2.6/arch/x86/power/hibernate_32.c
===================================================================
--- linux-2.6.orig/arch/x86/power/hibernate_32.c
+++ linux-2.6/arch/x86/power/hibernate_32.c
@@ -12,6 +12,7 @@
 #include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/mmzone.h>
 
 /* Defined in hibernate_asm_32.S */
 extern int restore_image(void);
@@ -127,6 +128,9 @@ static int resume_physical_mapping_init(
 			}
 		}
 	}
+
+	resume_map_numa_kva(pgd_base);
+
 	return 0;
 }
 
Index: linux-2.6/arch/x86/mm/numa_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_32.c
+++ linux-2.6/arch/x86/mm/numa_32.c
@@ -222,6 +222,41 @@ static void __init remap_numa_kva(void)
 	}
 }
 
+#ifdef CONFIG_HIBERNATION
+/**
+ * resume_map_numa_kva - add KVA mapping to the temporary page tables created
+ *                       during resume from hibernation
+ * @pgd_base - temporary resume page directory
+ */
+void resume_map_numa_kva(pgd_t *pgd_base)
+{
+	int node;
+
+	for_each_online_node(node) {
+		unsigned long start_va, start_pfn, size, pfn;
+
+		start_va = (unsigned long)node_remap_start_vaddr[node];
+		start_pfn = node_remap_start_pfn[node];
+		size = node_remap_size[node];
+
+		printk(KERN_DEBUG "%s: node %d\n", __FUNCTION__, node);
+
+		for (pfn = 0; pfn < size; pfn += PTRS_PER_PTE) {
+			unsigned long vaddr = start_va + (pfn << PAGE_SHIFT);
+			pgd_t *pgd = pgd_base + pgd_index(vaddr);
+			pud_t *pud = pud_offset(pgd, vaddr);
+			pmd_t *pmd = pmd_offset(pud, vaddr);
+
+			set_pmd(pmd, pfn_pmd(start_pfn + pfn,
+						PAGE_KERNEL_LARGE_EXEC));
+
+			printk(KERN_DEBUG "%s: %08lx -> pfn %08lx\n",
+				__FUNCTION__, vaddr, start_pfn + pfn);
+		}
+	}
+}
+#endif
+
 static unsigned long calculate_numa_remap_pages(void)
 {
 	int nid;
Index: linux-2.6/arch/x86/include/asm/mmzone_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mmzone_32.h
+++ linux-2.6/arch/x86/include/asm/mmzone_32.h
@@ -34,10 +34,14 @@ static inline void get_memcfg_numa(void)
 
 extern int early_pfn_to_nid(unsigned long pfn);
 
+extern void resume_map_numa_kva(pgd_t *pgd);
+
 #else /* !CONFIG_NUMA */
 
 #define get_memcfg_numa get_memcfg_numa_flat
 
+static inline void resume_map_numa_kva(pgd_t *pgd) {}
+
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_DISCONTIGMEM
