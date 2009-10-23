Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbZJWOlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbZJWOlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZJWOlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:41:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37235 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZJWOlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:41:07 -0400
Date: Fri, 23 Oct 2009 16:40:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20091023144057.GA10067@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
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

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86: Document linker script ASSERT() quirk

Robin Holt (3):
      x86, UV: Fix information in __uv_hub_info structure
      x86, UV: Fix and clean up bau code to use uv_gpa_to_pnode()
      x86, UV: Set DELIVERY_MODE=4 for vector=NMI_VECTOR in uv_hub_send_ipi()

Roland Dreier (1):
      x86: Don't print number of MCE banks for every CPU


 arch/x86/boot/setup.ld                     |    3 +++
 arch/x86/include/asm/uv/uv_hub.h           |   23 ++++++++++++++++++++++-
 arch/x86/kernel/acpi/realmode/wakeup.lds.S |    3 +++
 arch/x86/kernel/apic/x2apic_uv_x.c         |    8 ++++----
 arch/x86/kernel/cpu/mcheck/mce.c           |    3 ++-
 arch/x86/kernel/tlb_uv.c                   |    9 +++------
 arch/x86/kernel/vmlinux.lds.S              |    3 +++
 7 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/arch/x86/boot/setup.ld b/arch/x86/boot/setup.ld
index 0f6ec45..03c0683 100644
--- a/arch/x86/boot/setup.ld
+++ b/arch/x86/boot/setup.ld
@@ -53,6 +53,9 @@ SECTIONS
 
 	/DISCARD/ : { *(.note*) }
 
+	/*
+	 * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
+	 */
 	. = ASSERT(_end <= 0x8000, "Setup too big!");
 	. = ASSERT(hdr == 0x1f1, "The setup header has the wrong offset!");
 	/* Necessary for the very-old-loader check to work... */
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 04eb6c9..d1414af 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -19,6 +19,8 @@
 #include <asm/types.h>
 #include <asm/percpu.h>
 #include <asm/uv/uv_mmrs.h>
+#include <asm/irq_vectors.h>
+#include <asm/io_apic.h>
 
 
 /*
@@ -114,7 +116,7 @@
 /*
  * The largest possible NASID of a C or M brick (+ 2)
  */
-#define UV_MAX_NASID_VALUE	(UV_MAX_NUMALINK_NODES * 2)
+#define UV_MAX_NASID_VALUE	(UV_MAX_NUMALINK_BLADES * 2)
 
 struct uv_scir_s {
 	struct timer_list timer;
@@ -230,6 +232,20 @@ static inline unsigned long uv_gpa(void *v)
 	return uv_soc_phys_ram_to_gpa(__pa(v));
 }
 
+/* gnode -> pnode */
+static inline unsigned long uv_gpa_to_gnode(unsigned long gpa)
+{
+	return gpa >> uv_hub_info->m_val;
+}
+
+/* gpa -> pnode */
+static inline int uv_gpa_to_pnode(unsigned long gpa)
+{
+	unsigned long n_mask = (1UL << uv_hub_info->n_val) - 1;
+
+	return uv_gpa_to_gnode(gpa) & n_mask;
+}
+
 /* pnode, offset --> socket virtual */
 static inline void *uv_pnode_offset_to_vaddr(int pnode, unsigned long offset)
 {
@@ -421,9 +437,14 @@ static inline void uv_set_cpu_scir_bits(int cpu, unsigned char value)
 static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
 {
 	unsigned long val;
+	unsigned long dmode = dest_Fixed;
+
+	if (vector == NMI_VECTOR)
+		dmode = dest_NMI;
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
+			(dmode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
 			(vector << UVH_IPI_INT_VECTOR_SHFT);
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
index 7da00b7..060fff8 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -57,5 +57,8 @@ SECTIONS
 		*(.note*)
 	}
 
+	/*
+	 * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
+	 */
 	. = ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
 }
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index f5f5886..326c254 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -352,14 +352,14 @@ static __init void get_lowmem_redirect(unsigned long *base, unsigned long *size)
 
 	for (i = 0; i < ARRAY_SIZE(redir_addrs); i++) {
 		alias.v = uv_read_local_mmr(redir_addrs[i].alias);
-		if (alias.s.base == 0) {
+		if (alias.s.enable && alias.s.base == 0) {
 			*size = (1UL << alias.s.m_alias);
 			redirect.v = uv_read_local_mmr(redir_addrs[i].redirect);
 			*base = (unsigned long)redirect.s.dest_base << DEST_SHIFT;
 			return;
 		}
 	}
-	BUG();
+	*base = *size = 0;
 }
 
 enum map_type {map_wb, map_uc};
@@ -619,12 +619,12 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->lowmem_remap_base = lowmem_redir_base;
 		uv_cpu_hub_info(cpu)->lowmem_remap_top = lowmem_redir_size;
 		uv_cpu_hub_info(cpu)->m_val = m_val;
-		uv_cpu_hub_info(cpu)->n_val = m_val;
+		uv_cpu_hub_info(cpu)->n_val = n_val;
 		uv_cpu_hub_info(cpu)->numa_blade_id = blade;
 		uv_cpu_hub_info(cpu)->blade_processor_id = lcpu;
 		uv_cpu_hub_info(cpu)->pnode = pnode;
 		uv_cpu_hub_info(cpu)->pnode_mask = pnode_mask;
-		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
+		uv_cpu_hub_info(cpu)->gpa_mask = (1UL << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->gnode_extra = gnode_extra;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b1598a9..721a77c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1214,7 +1214,8 @@ static int __cpuinit mce_cap_init(void)
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 
 	b = cap & MCG_BANKCNT_MASK;
-	printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
+	if (!banks)
+		printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
 
 	if (b > MAX_NR_BANKS) {
 		printk(KERN_WARNING
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 503c1f2..1740c85 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -23,8 +23,6 @@
 static struct bau_control	**uv_bau_table_bases __read_mostly;
 static int			uv_bau_retry_limit __read_mostly;
 
-/* position of pnode (which is nasid>>1): */
-static int			uv_nshift __read_mostly;
 /* base pnode in this partition */
 static int			uv_partition_base_pnode __read_mostly;
 
@@ -723,7 +721,7 @@ uv_activation_descriptor_init(int node, int pnode)
 	BUG_ON(!adp);
 
 	pa = uv_gpa(adp); /* need the real nasid*/
-	n = pa >> uv_nshift;
+	n = uv_gpa_to_pnode(pa);
 	m = pa & uv_mmask;
 
 	uv_write_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE,
@@ -778,7 +776,7 @@ uv_payload_queue_init(int node, int pnode, struct bau_control *bau_tablesp)
 	 * need the pnode of where the memory was really allocated
 	 */
 	pa = uv_gpa(pqp);
-	pn = pa >> uv_nshift;
+	pn = uv_gpa_to_pnode(pa);
 	uv_write_global_mmr64(pnode,
 			      UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST,
 			      ((unsigned long)pn << UV_PAYLOADQ_PNODE_SHIFT) |
@@ -843,8 +841,7 @@ static int __init uv_bau_init(void)
 				       GFP_KERNEL, cpu_to_node(cur_cpu));
 
 	uv_bau_retry_limit = 1;
-	uv_nshift = uv_hub_info->n_val;
-	uv_mmask = (1UL << uv_hub_info->n_val) - 1;
+	uv_mmask = (1UL << uv_hub_info->m_val) - 1;
 	nblades = uv_num_possible_blades();
 
 	uv_bau_table_bases = (struct bau_control **)
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 92929fb..3c68fe2 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -305,6 +305,9 @@ SECTIONS
 
 
 #ifdef CONFIG_X86_32
+/*
+ * The ASSERT() sink to . is intentional, for binutils 2.14 compatibility:
+ */
 . = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
 	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 #else
