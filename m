Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbZFJVuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbZFJVuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZFJVu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:50:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZFJVu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:50:26 -0400
Date: Wed, 10 Jun 2009 23:50:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/urgent fixes for v2.6.31
Message-ID: <20090610215015.GA17334@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus

These are the patches that you'd have gotten before .30 had there 
been an -rc9 release.

If you care then please have a look whether in hindsight you'd have 
preferred to have any of these upstream sooner, in the final week of 
.30. We generally only send you lots-of-boxes-affected fixes after 
the final -rc.

All of these patches are for -stable 2.6.30.1.

 Thanks,

	Ingo

------------------>
Andreas Herrmann (2):
      x86: memtest: remove 64-bit division
      x86: Detect use of extended APIC ID for AMD CPUs

Chuck Ebbert (1):
      x86: Clear TS in irq_ts_save() when in an atomic section

Cliff Wickman (1):
      x86: Fix UV BAU activation descriptor init

Jack Steiner (1):
      x86, UV: Fix macros for multiple coherency domains

Jean Delvare (1):
      x86: Add quirk for reboot stalls on a Dell Optiplex 360

Lubomir Rintel (1):
      x86: Fix non-lazy GS handling in sys_vm86()


 arch/x86/include/asm/apic.h        |    2 +-
 arch/x86/include/asm/cpufeature.h  |    1 +
 arch/x86/include/asm/i387.h        |   12 ++++++------
 arch/x86/include/asm/uv/uv_bau.h   |    2 +-
 arch/x86/include/asm/uv/uv_hub.h   |    6 ++++--
 arch/x86/kernel/apic/x2apic_uv_x.c |   15 +++++++++------
 arch/x86/kernel/cpu/amd.c          |   10 ++++++++++
 arch/x86/kernel/reboot.c           |    9 +++++++++
 arch/x86/kernel/tlb_uv.c           |   15 +++++++++++++--
 arch/x86/kernel/vm86_32.c          |    9 +++++----
 arch/x86/mm/memtest.c              |   14 +++++++-------
 11 files changed, 66 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 42f2f83..9b2c049 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -410,7 +410,7 @@ static inline unsigned default_get_apic_id(unsigned long x)
 {
 	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
 
-	if (APIC_XAPIC(ver))
+	if (APIC_XAPIC(ver) || boot_cpu_has(X86_FEATURE_EXTD_APICID))
 		return (x >> 24) & 0xFF;
 	else
 		return (x >> 24) & 0x0F;
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb83b1c..78dee4f 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -94,6 +94,7 @@
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
 #define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
+#define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 71c9e51..4aab52f 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -305,18 +305,18 @@ static inline void kernel_fpu_end(void)
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
  * DNA fault but don't modify SSE registers. And these instructions
- * get used from interrupt context aswell. To prevent these kernel instructions
- * in interrupt context interact wrongly with other user/kernel fpu usage, we
+ * get used from interrupt context as well. To prevent these kernel instructions
+ * in interrupt context interacting wrongly with other user/kernel fpu usage, we
  * should use them only in the context of irq_ts_save/restore()
  */
 static inline int irq_ts_save(void)
 {
 	/*
-	 * If we are in process context, we are ok to take a spurious DNA fault.
-	 * Otherwise, doing clts() in process context require pre-emption to
-	 * be disabled or some heavy lifting like kernel_fpu_begin()
+	 * If in process context and not atomic, we can take a spurious DNA fault.
+	 * Otherwise, doing clts() in process context requires disabling preemption
+	 * or some heavy lifting like kernel_fpu_begin()
 	 */
-	if (!in_interrupt())
+	if (!in_atomic())
 		return 0;
 
 	if (read_cr0() & X86_CR0_TS) {
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 9b0e61b..bddd44f 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -37,7 +37,7 @@
 #define UV_CPUS_PER_ACT_STATUS		32
 #define UV_ACT_STATUS_MASK		0x3
 #define UV_ACT_STATUS_SIZE		2
-#define UV_ACTIVATION_DESCRIPTOR_SIZE	32
+#define UV_ADP_SIZE			32
 #define UV_DISTRIBUTION_SIZE		256
 #define UV_SW_ACK_NPENDING		8
 #define UV_NET_ENDPOINT_INTD		0x38
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index d3a98ea..341070f 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -133,6 +133,7 @@ struct uv_scir_s {
 struct uv_hub_info_s {
 	unsigned long		global_mmr_base;
 	unsigned long		gpa_mask;
+	unsigned int		gnode_extra;
 	unsigned long		gnode_upper;
 	unsigned long		lowmem_remap_top;
 	unsigned long		lowmem_remap_base;
@@ -159,7 +160,8 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
  * 		p -  PNODE (local part of nsids, right shifted 1)
  */
 #define UV_NASID_TO_PNODE(n)		(((n) >> 1) & uv_hub_info->pnode_mask)
-#define UV_PNODE_TO_NASID(p)		(((p) << 1) | uv_hub_info->gnode_upper)
+#define UV_PNODE_TO_GNODE(p)		((p) |uv_hub_info->gnode_extra)
+#define UV_PNODE_TO_NASID(p)		(UV_PNODE_TO_GNODE(p) << 1)
 
 #define UV_LOCAL_MMR_BASE		0xf4000000UL
 #define UV_GLOBAL_MMR32_BASE		0xf8000000UL
@@ -173,7 +175,7 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define UV_GLOBAL_MMR32_PNODE_BITS(p)	((p) << (UV_GLOBAL_MMR32_PNODE_SHIFT))
 
 #define UV_GLOBAL_MMR64_PNODE_BITS(p)					\
-	((unsigned long)(p) << UV_GLOBAL_MMR64_PNODE_SHIFT)
+	((unsigned long)(UV_PNODE_TO_GNODE(p)) << UV_GLOBAL_MMR64_PNODE_SHIFT)
 
 #define UV_APIC_PNODE_SHIFT	6
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 2bda693..39f2af4 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -562,7 +562,7 @@ void __init uv_system_init(void)
 	union uvh_node_id_u node_id;
 	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
 	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
-	int max_pnode = 0;
+	int gnode_extra, max_pnode = 0;
 	unsigned long mmr_base, present, paddr;
 	unsigned short pnode_mask;
 
@@ -574,6 +574,13 @@ void __init uv_system_init(void)
 	mmr_base =
 	    uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR) &
 	    ~UV_MMR_ENABLE;
+	pnode_mask = (1 << n_val) - 1;
+	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
+	gnode_extra = (node_id.s.node_id & ~((1 << n_val) - 1)) >> 1;
+	gnode_upper = ((unsigned long)gnode_extra  << m_val);
+	printk(KERN_DEBUG "UV: N %d, M %d, gnode_upper 0x%lx, gnode_extra 0x%x\n",
+			n_val, m_val, gnode_upper, gnode_extra);
+
 	printk(KERN_DEBUG "UV: global MMR base 0x%lx\n", mmr_base);
 
 	for(i = 0; i < UVH_NODE_PRESENT_TABLE_DEPTH; i++)
@@ -607,11 +614,6 @@ void __init uv_system_init(void)
 		}
 	}
 
-	pnode_mask = (1 << n_val) - 1;
-	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
-	gnode_upper = (((unsigned long)node_id.s.node_id) &
-		       ~((1 << n_val) - 1)) << m_val;
-
 	uv_bios_init();
 	uv_bios_get_sn_info(0, &uv_type, &sn_partition_id,
 			    &sn_coherency_id, &sn_region_size);
@@ -634,6 +636,7 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->pnode_mask = pnode_mask;
 		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
+		uv_cpu_hub_info(cpu)->gnode_extra = gnode_extra;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = sn_coherency_id;
 		uv_cpu_hub_info(cpu)->scir.offset = SCIR_LOCAL_MMR_BASE + lcpu;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7e4a459..0802e15 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -6,6 +6,7 @@
 #include <asm/processor.h>
 #include <asm/apic.h>
 #include <asm/cpu.h>
+#include <asm/pci-direct.h>
 
 #ifdef CONFIG_X86_64
 # include <asm/numa_64.h>
@@ -351,6 +352,15 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 		    (c->x86_model == 8 && c->x86_mask >= 8))
 			set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 #endif
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_PCI)
+	/* check CPU config space for extended APIC ID */
+	if (c->x86 >= 0xf) {
+		unsigned int val;
+		val = read_pci_config(0, 24, 0, 0x68);
+		if ((val & ((1 << 17) | (1 << 18))) == ((1 << 17) | (1 << 18)))
+			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
+	}
+#endif
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 667188e..d2d1ce8 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -192,6 +192,15 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),
 		},
 	},
+	{   /* Handle problems with rebooting on Dell Optiplex 360 with 0T656F */
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 360",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 360"),
+			DMI_MATCH(DMI_BOARD_NAME, "0T656F"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index ed0c337..16f0fd4 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -715,7 +715,12 @@ uv_activation_descriptor_init(int node, int pnode)
 	struct bau_desc *adp;
 	struct bau_desc *ad2;
 
-	adp = (struct bau_desc *)kmalloc_node(16384, GFP_KERNEL, node);
+	/*
+	 * each bau_desc is 64 bytes; there are 8 (UV_ITEMS_PER_DESCRIPTOR)
+	 * per cpu; and up to 32 (UV_ADP_SIZE) cpu's per blade
+	 */
+	adp = (struct bau_desc *)kmalloc_node(sizeof(struct bau_desc)*
+		UV_ADP_SIZE*UV_ITEMS_PER_DESCRIPTOR, GFP_KERNEL, node);
 	BUG_ON(!adp);
 
 	pa = uv_gpa(adp); /* need the real nasid*/
@@ -729,7 +734,13 @@ uv_activation_descriptor_init(int node, int pnode)
 				      (n << UV_DESC_BASE_PNODE_SHIFT | m));
 	}
 
-	for (i = 0, ad2 = adp; i < UV_ACTIVATION_DESCRIPTOR_SIZE; i++, ad2++) {
+	/*
+	 * initializing all 8 (UV_ITEMS_PER_DESCRIPTOR) descriptors for each
+	 * cpu even though we only use the first one; one descriptor can
+	 * describe a broadcast to 256 nodes.
+	 */
+	for (i = 0, ad2 = adp; i < (UV_ADP_SIZE*UV_ITEMS_PER_DESCRIPTOR);
+		i++, ad2++) {
 		memset(ad2, 0, sizeof(struct bau_desc));
 		ad2->header.sw_ack_flag = 1;
 		/*
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index d7ac84e..6a17769 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -287,10 +287,9 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 	info->regs.pt.ds = 0;
 	info->regs.pt.es = 0;
 	info->regs.pt.fs = 0;
-
-/* we are clearing gs later just before "jmp resume_userspace",
- * because it is not saved/restored.
- */
+#ifndef CONFIG_X86_32_LAZY_GS
+	info->regs.pt.gs = 0;
+#endif
 
 /*
  * The flags register is also special: we cannot trust that the user
@@ -343,7 +342,9 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 	__asm__ __volatile__(
 		"movl %0,%%esp\n\t"
 		"movl %1,%%ebp\n\t"
+#ifdef CONFIG_X86_32_LAZY_GS
 		"mov  %2, %%gs\n\t"
+#endif
 		"jmp resume_userspace"
 		: /* no outputs */
 		:"r" (&info->regs), "r" (task_thread_info(tsk)), "r" (0));
diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 605c8be..c0bedcd 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -40,23 +40,23 @@ static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
 
 static void __init memtest(u64 pattern, u64 start_phys, u64 size)
 {
-	u64 i, count;
-	u64 *start;
+	u64 *p;
+	void *start, *end;
 	u64 start_bad, last_bad;
 	u64 start_phys_aligned;
 	size_t incr;
 
 	incr = sizeof(pattern);
 	start_phys_aligned = ALIGN(start_phys, incr);
-	count = (size - (start_phys_aligned - start_phys))/incr;
 	start = __va(start_phys_aligned);
+	end = start + size - (start_phys_aligned - start_phys);
 	start_bad = 0;
 	last_bad = 0;
 
-	for (i = 0; i < count; i++)
-		start[i] = pattern;
-	for (i = 0; i < count; i++, start++, start_phys_aligned += incr) {
-		if (*start == pattern)
+	for (p = start; p < end; p++)
+		*p = pattern;
+	for (p = start; p < end; p++, start_phys_aligned += incr) {
+		if (*p == pattern)
 			continue;
 		if (start_phys_aligned == last_bad + incr) {
 			last_bad += incr;
