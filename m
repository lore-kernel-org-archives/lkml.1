Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbYJ1Kt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbYJ1Kt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYJ1Ktv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:49:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33622 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYJ1Ktu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:49:50 -0400
Date: Tue, 28 Oct 2008 11:49:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081028104926.GA25703@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Chris Lalancette (1):
      xen: fix Xen domU boot with batched mprotect

Cliff Wickman (1):
      x86/uv: memory allocation at initialization

Shaohua Li (1):
      x86, memory hotplug: remove wrong -1 in calling init_memory_mapping()

Yinghai Lu (1):
      x86: keep the /proc/meminfo page count correct


 arch/x86/kernel/genx2apic_uv_x.c |    7 +++----
 arch/x86/mm/init_64.c            |   14 ++++++++++----
 arch/x86/xen/mmu.c               |   18 ++++++++++++++----
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 680a065..2c7dbdb 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -15,7 +15,6 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/sched.h>
-#include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/hardirq.h>
 #include <asm/smp.h>
@@ -398,16 +397,16 @@ void __init uv_system_init(void)
 	printk(KERN_DEBUG "UV: Found %d blades\n", uv_num_possible_blades());
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
-	uv_blade_info = alloc_bootmem_pages(bytes);
+	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
 
 	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
 
 	bytes = sizeof(uv_node_to_blade[0]) * num_possible_nodes();
-	uv_node_to_blade = alloc_bootmem_pages(bytes);
+	uv_node_to_blade = kmalloc(bytes, GFP_KERNEL);
 	memset(uv_node_to_blade, 255, bytes);
 
 	bytes = sizeof(uv_cpu_to_blade[0]) * num_possible_cpus();
-	uv_cpu_to_blade = alloc_bootmem_pages(bytes);
+	uv_cpu_to_blade = kmalloc(bytes, GFP_KERNEL);
 	memset(uv_cpu_to_blade, 255, bytes);
 
 	blade = 0;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b8e461d..f79a02f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -350,8 +350,10 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 		 * pagetable pages as RO. So assume someone who pre-setup
 		 * these mappings are more intelligent.
 		 */
-		if (pte_val(*pte))
+		if (pte_val(*pte)) {
+			pages++;
 			continue;
+		}
 
 		if (0)
 			printk("   pte=%p addr=%lx pte=%016lx\n",
@@ -418,8 +420,10 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			 * not differ with respect to page frame and
 			 * attributes.
 			 */
-			if (page_size_mask & (1 << PG_LEVEL_2M))
+			if (page_size_mask & (1 << PG_LEVEL_2M)) {
+				pages++;
 				continue;
+			}
 			new_prot = pte_pgprot(pte_clrhuge(*(pte_t *)pmd));
 		}
 
@@ -499,8 +503,10 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			 * not differ with respect to page frame and
 			 * attributes.
 			 */
-			if (page_size_mask & (1 << PG_LEVEL_1G))
+			if (page_size_mask & (1 << PG_LEVEL_1G)) {
+				pages++;
 				continue;
+			}
 			prot = pte_pgprot(pte_clrhuge(*(pte_t *)pud));
 		}
 
@@ -831,7 +837,7 @@ int arch_add_memory(int nid, u64 start, u64 size)
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	last_mapped_pfn = init_memory_mapping(start, start + size-1);
+	last_mapped_pfn = init_memory_mapping(start, start + size);
 	if (last_mapped_pfn > max_pfn_mapped)
 		max_pfn_mapped = last_mapped_pfn;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index d4d52f5..aba77b2 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -246,11 +246,21 @@ xmaddr_t arbitrary_virt_to_machine(void *vaddr)
 {
 	unsigned long address = (unsigned long)vaddr;
 	unsigned int level;
-	pte_t *pte = lookup_address(address, &level);
-	unsigned offset = address & ~PAGE_MASK;
+	pte_t *pte;
+	unsigned offset;
 
-	BUG_ON(pte == NULL);
+	/*
+	 * if the PFN is in the linear mapped vaddr range, we can just use
+	 * the (quick) virt_to_machine() p2m lookup
+	 */
+	if (virt_addr_valid(vaddr))
+		return virt_to_machine(vaddr);
 
+	/* otherwise we have to do a (slower) full page-table walk */
+
+	pte = lookup_address(address, &level);
+	BUG_ON(pte == NULL);
+	offset = address & ~PAGE_MASK;
 	return XMADDR(((phys_addr_t)pte_mfn(*pte) << PAGE_SHIFT) + offset);
 }
 
@@ -410,7 +420,7 @@ void xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 
 	xen_mc_batch();
 
-	u.ptr = virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
+	u.ptr = arbitrary_virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
 	u.val = pte_val_ma(pte);
 	xen_extend_mmu_update(&u);
 
