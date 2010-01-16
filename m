Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0APRDx (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 12:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594Ab0APRDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 12:03:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab0APRDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 12:03:51 -0500
Date: Sat, 16 Jan 2010 18:03:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20100116170338.GA17175@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
drivers/char/agp/amd64-agp.c       # 42590a7: x86/agp: Fix agp_amd64_init and a

 Thanks,

	Ingo

------------------>
Alan Cox (1):
      x86: mce.h: Fix warning in header checks

Cyrill Gorcunov (1):
      x86: kernel_thread() -- initialize SS to a known state

FUJITA Tomonori (1):
      x86/agp: Fix agp_amd64_init and agp_amd64_cleanup

Ian Campbell (1):
      x86: xen: 64-bit kernel RPL should be 0

Jack Steiner (1):
      x86, uv: Add function retrieving node controller revision number

Mike Travis (1):
      x86: SGI UV: Fix mapping of MMIO registers

Russ Anderson (1):
      x86, uv: Ensure hub revision set for all ACPI modes.


 arch/x86/include/asm/mce.h         |    3 ++-
 arch/x86/include/asm/uv/uv_hub.h   |   12 ++++++++++++
 arch/x86/kernel/aperture_64.c      |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c |   26 ++++++++++++++++++--------
 arch/x86/kernel/process.c          |    2 ++
 arch/x86/xen/enlighten.c           |    4 ++++
 drivers/char/agp/amd64-agp.c       |    5 +++--
 7 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 858baa0..6c3fdd6 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -108,10 +108,11 @@ struct mce_log {
 #define K8_MCE_THRESHOLD_BANK_5    (MCE_THRESHOLD_BASE + 5 * 9)
 #define K8_MCE_THRESHOLD_DRAM_ECC  (MCE_THRESHOLD_BANK_4 + 0)
 
-extern struct atomic_notifier_head x86_mce_decoder_chain;
 
 #ifdef __KERNEL__
 
+extern struct atomic_notifier_head x86_mce_decoder_chain;
+
 #include <linux/percpu.h>
 #include <linux/init.h>
 #include <asm/atomic.h>
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index bc54fa9..40be813 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -495,5 +495,17 @@ static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 
+/*
+ * Get the minimum revision number of the hub chips within the partition.
+ *     1 - initial rev 1.0 silicon
+ *     2 - rev 2.0 production silicon
+ */
+static inline int uv_get_min_hub_revision_id(void)
+{
+	extern int uv_min_hub_revision_id;
+
+	return uv_min_hub_revision_id;
+}
+
 #endif /* CONFIG_X86_64 */
 #endif /* _ASM_X86_UV_UV_HUB_H */
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 3704997..f147a95 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -31,6 +31,7 @@
 #include <asm/x86_init.h>
 
 int gart_iommu_aperture;
+EXPORT_SYMBOL_GPL(gart_iommu_aperture);
 int gart_iommu_aperture_disabled __initdata;
 int gart_iommu_aperture_allowed __initdata;
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 5f92494..21db3cb 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -36,6 +36,8 @@ DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
 static u64 gru_start_paddr, gru_end_paddr;
+int uv_min_hub_revision_id;
+EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
 
 static inline bool is_GRU_range(u64 start, u64 end)
 {
@@ -55,12 +57,19 @@ static int early_get_nodeid(void)
 	mmr = early_ioremap(UV_LOCAL_MMR_BASE | UVH_NODE_ID, sizeof(*mmr));
 	node_id.v = *mmr;
 	early_iounmap(mmr, sizeof(*mmr));
+
+	/* Currently, all blades have same revision number */
+	uv_min_hub_revision_id = node_id.s.revision;
+
 	return node_id.s.node_id;
 }
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
+	int nodeid;
+
 	if (!strcmp(oem_id, "SGI")) {
+		nodeid = early_get_nodeid();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
 		if (!strcmp(oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
@@ -68,7 +77,7 @@ static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
 			__get_cpu_var(x2apic_extra_bits) =
-				early_get_nodeid() << (UV_APIC_PNODE_SHIFT - 1);
+				nodeid << (UV_APIC_PNODE_SHIFT - 1);
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			return 1;
 		}
@@ -374,13 +383,13 @@ static __init void get_lowmem_redirect(unsigned long *base, unsigned long *size)
 
 enum map_type {map_wb, map_uc};
 
-static __init void map_high(char *id, unsigned long base, int shift,
-			    int max_pnode, enum map_type map_type)
+static __init void map_high(char *id, unsigned long base, int pshift,
+			int bshift, int max_pnode, enum map_type map_type)
 {
 	unsigned long bytes, paddr;
 
-	paddr = base << shift;
-	bytes = (1UL << shift) * (max_pnode + 1);
+	paddr = base << pshift;
+	bytes = (1UL << bshift) * (max_pnode + 1);
 	printk(KERN_INFO "UV: Map %s_HI 0x%lx - 0x%lx\n", id, paddr,
 						paddr + bytes);
 	if (map_type == map_uc)
@@ -396,7 +405,7 @@ static __init void map_gru_high(int max_pnode)
 
 	gru.v = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR);
 	if (gru.s.enable) {
-		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
+		map_high("GRU", gru.s.base, shift, shift, max_pnode, map_wb);
 		gru_start_paddr = ((u64)gru.s.base << shift);
 		gru_end_paddr = gru_start_paddr + (1UL << shift) * (max_pnode + 1);
 
@@ -410,7 +419,7 @@ static __init void map_mmr_high(int max_pnode)
 
 	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
 	if (mmr.s.enable)
-		map_high("MMR", mmr.s.base, shift, max_pnode, map_uc);
+		map_high("MMR", mmr.s.base, shift, shift, max_pnode, map_uc);
 }
 
 static __init void map_mmioh_high(int max_pnode)
@@ -420,7 +429,8 @@ static __init void map_mmioh_high(int max_pnode)
 
 	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
 	if (mmioh.s.enable)
-		map_high("MMIOH", mmioh.s.base, shift, max_pnode, map_uc);
+		map_high("MMIOH", mmioh.s.base, shift, mmioh.s.m_io,
+			max_pnode, map_uc);
 }
 
 static __init void map_low_mmrs(void)
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c6ee241..02c3ee0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -288,6 +288,8 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.es = __USER_DS;
 	regs.fs = __KERNEL_PERCPU;
 	regs.gs = __KERNEL_STACK_CANARY;
+#else
+	regs.ss = __KERNEL_DS;
 #endif
 
 	regs.orig_ax = -1;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2b26dd5..36daccb 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1151,9 +1151,13 @@ asmlinkage void __init xen_start_kernel(void)
 
 	/* keep using Xen gdt for now; no urgent need to change it */
 
+#ifdef CONFIG_X86_32
 	pv_info.kernel_rpl = 1;
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))
 		pv_info.kernel_rpl = 0;
+#else
+	pv_info.kernel_rpl = 0;
+#endif
 
 	/* set the limit of our address space */
 	xen_reserve_top();
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 5aa7a58..1afb896 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -725,12 +725,11 @@ static struct pci_driver agp_amd64_pci_driver = {
 int __init agp_amd64_init(void)
 {
 	int err = 0;
-	static int done = 0;
 
 	if (agp_off)
 		return -EINVAL;
 
-	if (done++)
+	if (gart_iommu_aperture)
 		return agp_bridges_found ? 0 : -ENODEV;
 
 	err = pci_register_driver(&agp_amd64_pci_driver);
@@ -771,6 +770,8 @@ int __init agp_amd64_init(void)
 
 static void __exit agp_amd64_cleanup(void)
 {
+	if (gart_iommu_aperture)
+		return;
 	if (aperture_resource)
 		release_resource(aperture_resource);
 	pci_unregister_driver(&agp_amd64_pci_driver);
