Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbYLCUIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbYLCUIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYLCTw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:56 -0500
Received: from kroah.org ([198.145.64.141]:60083 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754763AbYLCTww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:52 -0500
Date: Wed, 3 Dec 2008 11:51:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 045/104] x86: Hibernate: Fix breakage on x86_32 with
	CONFIG_NUMA set
Message-ID: <20081203195125.GT8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-hibernate-fix-breakage-on-x86_32-with-config_numa-set.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

backport of commit 97a70e548bd97d5a46ae9d44f24aafcc013fd701 to the 2.6.27 kernel.

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
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/discontig_32.c    |   35 +++++++++++++++++++++++++++++++++++
 arch/x86/power/hibernate_32.c |    4 ++++
 include/asm-x86/mmzone_32.h   |    4 ++++
 3 files changed, 43 insertions(+)

--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
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
--- a/arch/x86/power/hibernate_32.c
+++ b/arch/x86/power/hibernate_32.c
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
 
--- a/include/asm-x86/mmzone_32.h
+++ b/include/asm-x86/mmzone_32.h
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

