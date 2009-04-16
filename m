Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZDPWWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZDPWWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 18:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZDPWWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 18:22:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58779 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbZDPWWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 18:22:03 -0400
Date: Fri, 17 Apr 2009 00:21:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/uv fixes
Message-ID: <20090416222139.GA9311@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86/uv fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/uv

Sending these separately as they only affect x86/UV.

 Thanks,

	Ingo

------------------>
Cliff Wickman (4):
      x86: UV BAU and nodes with no memory
      x86: UV BAU messaging timeouts
      x86: UV: BAU partition-relative distribution map
      x86: UV BAU distribution and payload MMRs

Jack Steiner (2):
      x86, UV: Fix for nodes with memory and no cpus
      x86, uv: add Kconfig dependency on NUMA for UV systems

Russ Anderson (2):
      x86, UV: system table in bios accessed after unmap
      x86: prevent /sys/firmware/sgi_uv from being created on non-uv systems


 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/uv/uv_mmrs.h  |    5 +
 arch/x86/kernel/apic/x2apic_uv_x.c |   16 +++-
 arch/x86/kernel/bios_uv.c          |    3 +-
 arch/x86/kernel/tlb_uv.c           |  189 ++++++++++++++++++++++++------------
 arch/x86/kernel/uv_sysfs.c         |    4 +
 6 files changed, 154 insertions(+), 64 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 748e50a..2817ab5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -354,6 +354,7 @@ config X86_UV
 	bool "SGI Ultraviolet"
 	depends on X86_64
 	depends on X86_EXTENDED_PLATFORM
+	depends on NUMA
 	select X86_X2APIC
 	---help---
 	  This option is needed in order to support SGI Ultraviolet systems.
diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index db68ac8..2cae46c 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -17,6 +17,11 @@
 /* ========================================================================= */
 /*                           UVH_BAU_DATA_CONFIG                             */
 /* ========================================================================= */
+#define UVH_LB_BAU_MISC_CONTROL 0x320170UL
+#define UV_ENABLE_INTD_SOFT_ACK_MODE_SHIFT 15
+#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHIFT 16
+#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD 0x000000000bUL
+/* 1011 timebase 7 (168millisec) * 3 ticks -> 500ms */
 #define UVH_BAU_DATA_CONFIG 0x61680UL
 #define UVH_BAU_DATA_CONFIG_32 0x0438
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 1248318..de1a50a 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -549,7 +549,8 @@ void __init uv_system_init(void)
 	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
 	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
 	int max_pnode = 0;
-	unsigned long mmr_base, present;
+	unsigned long mmr_base, present, paddr;
+	unsigned short pnode_mask;
 
 	map_low_mmrs();
 
@@ -592,6 +593,7 @@ void __init uv_system_init(void)
 		}
 	}
 
+	pnode_mask = (1 << n_val) - 1;
 	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
 	gnode_upper = (((unsigned long)node_id.s.node_id) &
 		       ~((1 << n_val) - 1)) << m_val;
@@ -615,7 +617,7 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->numa_blade_id = blade;
 		uv_cpu_hub_info(cpu)->blade_processor_id = lcpu;
 		uv_cpu_hub_info(cpu)->pnode = pnode;
-		uv_cpu_hub_info(cpu)->pnode_mask = (1 << n_val) - 1;
+		uv_cpu_hub_info(cpu)->pnode_mask = pnode_mask;
 		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
@@ -631,6 +633,16 @@ void __init uv_system_init(void)
 			lcpu, blade);
 	}
 
+	/* Add blade/pnode info for nodes without cpus */
+	for_each_online_node(nid) {
+		if (uv_node_to_blade[nid] >= 0)
+			continue;
+		paddr = node_start_pfn(nid) << PAGE_SHIFT;
+		pnode = (paddr >> m_val) & pnode_mask;
+		blade = boot_pnode_to_blade(pnode);
+		uv_node_to_blade[nid] = blade;
+	}
+
 	map_gru_high(max_pnode);
 	map_mmr_high(max_pnode);
 	map_config_high(max_pnode);
diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/kernel/bios_uv.c
index f638827..63a88e1 100644
--- a/arch/x86/kernel/bios_uv.c
+++ b/arch/x86/kernel/bios_uv.c
@@ -182,7 +182,8 @@ void uv_bios_init(void)
 	memcpy(&uv_systab, tab, sizeof(struct uv_systab));
 	iounmap(tab);
 
-	printk(KERN_INFO "EFI UV System Table Revision %d\n", tab->revision);
+	printk(KERN_INFO "EFI UV System Table Revision %d\n",
+					uv_systab.revision);
 }
 #else	/* !CONFIG_EFI */
 
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 79c0732..7842233 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -25,6 +25,8 @@ static int			uv_bau_retry_limit __read_mostly;
 
 /* position of pnode (which is nasid>>1): */
 static int			uv_nshift __read_mostly;
+/* base pnode in this partition */
+static int			uv_partition_base_pnode __read_mostly;
 
 static unsigned long		uv_mmask __read_mostly;
 
@@ -32,6 +34,34 @@ static DEFINE_PER_CPU(struct ptc_stats, ptcstats);
 static DEFINE_PER_CPU(struct bau_control, bau_control);
 
 /*
+ * Determine the first node on a blade.
+ */
+static int __init blade_to_first_node(int blade)
+{
+	int node, b;
+
+	for_each_online_node(node) {
+		b = uv_node_to_blade_id(node);
+		if (blade == b)
+			return node;
+	}
+	return -1; /* shouldn't happen */
+}
+
+/*
+ * Determine the apicid of the first cpu on a blade.
+ */
+static int __init blade_to_first_apicid(int blade)
+{
+	int cpu;
+
+	for_each_present_cpu(cpu)
+		if (blade == uv_cpu_to_blade_id(cpu))
+			return per_cpu(x86_cpu_to_apicid, cpu);
+	return -1;
+}
+
+/*
  * Free a software acknowledge hardware resource by clearing its Pending
  * bit. This will return a reply to the sender.
  * If the message has timed out, a reply has already been sent by the
@@ -67,7 +97,7 @@ static void uv_bau_process_message(struct bau_payload_queue_entry *msg,
 	msp = __get_cpu_var(bau_control).msg_statuses + msg_slot;
 	cpu = uv_blade_processor_id();
 	msg->number_of_cpus =
-	    uv_blade_nr_online_cpus(uv_node_to_blade_id(numa_node_id()));
+		uv_blade_nr_online_cpus(uv_node_to_blade_id(numa_node_id()));
 	this_cpu_mask = 1UL << cpu;
 	if (msp->seen_by.bits & this_cpu_mask)
 		return;
@@ -215,14 +245,14 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
  * Returns @flush_mask if some remote flushing remains to be done. The
  * mask will have some bits still set.
  */
-const struct cpumask *uv_flush_send_and_wait(int cpu, int this_blade,
+const struct cpumask *uv_flush_send_and_wait(int cpu, int this_pnode,
 					     struct bau_desc *bau_desc,
 					     struct cpumask *flush_mask)
 {
 	int completion_status = 0;
 	int right_shift;
 	int tries = 0;
-	int blade;
+	int pnode;
 	int bit;
 	unsigned long mmr_offset;
 	unsigned long index;
@@ -265,8 +295,8 @@ const struct cpumask *uv_flush_send_and_wait(int cpu, int this_blade,
 	 * use the IPI method of shootdown on them.
 	 */
 	for_each_cpu(bit, flush_mask) {
-		blade = uv_cpu_to_blade_id(bit);
-		if (blade == this_blade)
+		pnode = uv_cpu_to_pnode(bit);
+		if (pnode == this_pnode)
 			continue;
 		cpumask_clear_cpu(bit, flush_mask);
 	}
@@ -308,16 +338,16 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 	struct cpumask *flush_mask = &__get_cpu_var(flush_tlb_mask);
 	int i;
 	int bit;
-	int blade;
+	int pnode;
 	int uv_cpu;
-	int this_blade;
+	int this_pnode;
 	int locals = 0;
 	struct bau_desc *bau_desc;
 
 	cpumask_andnot(flush_mask, cpumask, cpumask_of(cpu));
 
 	uv_cpu = uv_blade_processor_id();
-	this_blade = uv_numa_blade_id();
+	this_pnode = uv_hub_info->pnode;
 	bau_desc = __get_cpu_var(bau_control).descriptor_base;
 	bau_desc += UV_ITEMS_PER_DESCRIPTOR * uv_cpu;
 
@@ -325,13 +355,14 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 
 	i = 0;
 	for_each_cpu(bit, flush_mask) {
-		blade = uv_cpu_to_blade_id(bit);
-		BUG_ON(blade > (UV_DISTRIBUTION_SIZE - 1));
-		if (blade == this_blade) {
+		pnode = uv_cpu_to_pnode(bit);
+		BUG_ON(pnode > (UV_DISTRIBUTION_SIZE - 1));
+		if (pnode == this_pnode) {
 			locals++;
 			continue;
 		}
-		bau_node_set(blade, &bau_desc->distribution);
+		bau_node_set(pnode - uv_partition_base_pnode,
+				&bau_desc->distribution);
 		i++;
 	}
 	if (i == 0) {
@@ -349,7 +380,7 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 	bau_desc->payload.address = va;
 	bau_desc->payload.sending_cpu = cpu;
 
-	return uv_flush_send_and_wait(uv_cpu, this_blade, bau_desc, flush_mask);
+	return uv_flush_send_and_wait(uv_cpu, this_pnode, bau_desc, flush_mask);
 }
 
 /*
@@ -417,24 +448,58 @@ void uv_bau_message_interrupt(struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
+/*
+ * uv_enable_timeouts
+ *
+ * Each target blade (i.e. blades that have cpu's) needs to have
+ * shootdown message timeouts enabled.  The timeout does not cause
+ * an interrupt, but causes an error message to be returned to
+ * the sender.
+ */
 static void uv_enable_timeouts(void)
 {
-	int i;
 	int blade;
-	int last_blade;
+	int nblades;
 	int pnode;
-	int cur_cpu = 0;
-	unsigned long apicid;
+	unsigned long mmr_image;
 
-	last_blade = -1;
-	for_each_online_node(i) {
-		blade = uv_node_to_blade_id(i);
-		if (blade == last_blade)
+	nblades = uv_num_possible_blades();
+
+	for (blade = 0; blade < nblades; blade++) {
+		if (!uv_blade_nr_possible_cpus(blade))
 			continue;
-		last_blade = blade;
-		apicid = per_cpu(x86_cpu_to_apicid, cur_cpu);
+
 		pnode = uv_blade_to_pnode(blade);
-		cur_cpu += uv_blade_nr_possible_cpus(i);
+		mmr_image =
+		    uv_read_global_mmr64(pnode, UVH_LB_BAU_MISC_CONTROL);
+		/*
+		 * Set the timeout period and then lock it in, in three
+		 * steps; captures and locks in the period.
+		 *
+		 * To program the period, the SOFT_ACK_MODE must be off.
+		 */
+		mmr_image &= ~((unsigned long)1 <<
+			       UV_ENABLE_INTD_SOFT_ACK_MODE_SHIFT);
+		uv_write_global_mmr64
+		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
+		/*
+		 * Set the 4-bit period.
+		 */
+		mmr_image &= ~((unsigned long)0xf <<
+			UV_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHIFT);
+		mmr_image |= (UV_INTD_SOFT_ACK_TIMEOUT_PERIOD <<
+			     UV_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHIFT);
+		uv_write_global_mmr64
+		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
+		/*
+		 * Subsequent reversals of the timebase bit (3) cause an
+		 * immediate timeout of one or all INTD resources as
+		 * indicated in bits 2:0 (7 causes all of them to timeout).
+		 */
+		mmr_image |= ((unsigned long)1 <<
+			      UV_ENABLE_INTD_SOFT_ACK_MODE_SHIFT);
+		uv_write_global_mmr64
+		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
 	}
 }
 
@@ -481,8 +546,7 @@ static int uv_ptc_seq_show(struct seq_file *file, void *data)
 			   stat->requestee, stat->onetlb, stat->alltlb,
 			   stat->s_retry, stat->d_retry, stat->ptc_i);
 		seq_printf(file, "%lx %ld %ld %ld %ld %ld %ld\n",
-			   uv_read_global_mmr64(uv_blade_to_pnode
-					(uv_cpu_to_blade_id(cpu)),
+			   uv_read_global_mmr64(uv_cpu_to_pnode(cpu),
 					UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE),
 			   stat->sflush, stat->dflush,
 			   stat->retriesok, stat->nomsg,
@@ -616,16 +680,18 @@ static struct bau_control * __init uv_table_bases_init(int blade, int node)
  * finish the initialization of the per-blade control structures
  */
 static void __init
-uv_table_bases_finish(int blade, int node, int cur_cpu,
+uv_table_bases_finish(int blade,
 		      struct bau_control *bau_tablesp,
 		      struct bau_desc *adp)
 {
 	struct bau_control *bcp;
-	int i;
+	int cpu;
 
-	for (i = cur_cpu; i < cur_cpu + uv_blade_nr_possible_cpus(blade); i++) {
-		bcp = (struct bau_control *)&per_cpu(bau_control, i);
+	for_each_present_cpu(cpu) {
+		if (blade != uv_cpu_to_blade_id(cpu))
+			continue;
 
+		bcp = (struct bau_control *)&per_cpu(bau_control, cpu);
 		bcp->bau_msg_head	= bau_tablesp->va_queue_first;
 		bcp->va_queue_first	= bau_tablesp->va_queue_first;
 		bcp->va_queue_last	= bau_tablesp->va_queue_last;
@@ -648,11 +714,10 @@ uv_activation_descriptor_init(int node, int pnode)
 	struct bau_desc *adp;
 	struct bau_desc *ad2;
 
-	adp = (struct bau_desc *)
-	    kmalloc_node(16384, GFP_KERNEL, node);
+	adp = (struct bau_desc *)kmalloc_node(16384, GFP_KERNEL, node);
 	BUG_ON(!adp);
 
-	pa = __pa((unsigned long)adp);
+	pa = uv_gpa(adp); /* need the real nasid*/
 	n = pa >> uv_nshift;
 	m = pa & uv_mmask;
 
@@ -666,8 +731,12 @@ uv_activation_descriptor_init(int node, int pnode)
 	for (i = 0, ad2 = adp; i < UV_ACTIVATION_DESCRIPTOR_SIZE; i++, ad2++) {
 		memset(ad2, 0, sizeof(struct bau_desc));
 		ad2->header.sw_ack_flag = 1;
-		ad2->header.base_dest_nodeid =
-		    uv_blade_to_pnode(uv_cpu_to_blade_id(0));
+		/*
+		 * base_dest_nodeid is the first node in the partition, so
+		 * the bit map will indicate partition-relative node numbers.
+		 * note that base_dest_nodeid is actually a nasid.
+		 */
+		ad2->header.base_dest_nodeid = uv_partition_base_pnode << 1;
 		ad2->header.command = UV_NET_ENDPOINT_INTD;
 		ad2->header.int_both = 1;
 		/*
@@ -685,6 +754,8 @@ static struct bau_payload_queue_entry * __init
 uv_payload_queue_init(int node, int pnode, struct bau_control *bau_tablesp)
 {
 	struct bau_payload_queue_entry *pqp;
+	unsigned long pa;
+	int pn;
 	char *cp;
 
 	pqp = (struct bau_payload_queue_entry *) kmalloc_node(
@@ -695,10 +766,14 @@ uv_payload_queue_init(int node, int pnode, struct bau_control *bau_tablesp)
 	cp = (char *)pqp + 31;
 	pqp = (struct bau_payload_queue_entry *)(((unsigned long)cp >> 5) << 5);
 	bau_tablesp->va_queue_first = pqp;
+	/*
+	 * need the pnode of where the memory was really allocated
+	 */
+	pa = uv_gpa(pqp);
+	pn = pa >> uv_nshift;
 	uv_write_global_mmr64(pnode,
 			      UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST,
-			      ((unsigned long)pnode <<
-			       UV_PAYLOADQ_PNODE_SHIFT) |
+			      ((unsigned long)pn << UV_PAYLOADQ_PNODE_SHIFT) |
 			      uv_physnodeaddr(pqp));
 	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL,
 			      uv_physnodeaddr(pqp));
@@ -714,8 +789,9 @@ uv_payload_queue_init(int node, int pnode, struct bau_control *bau_tablesp)
 /*
  * Initialization of each UV blade's structures
  */
-static int __init uv_init_blade(int blade, int node, int cur_cpu)
+static int __init uv_init_blade(int blade)
 {
+	int node;
 	int pnode;
 	unsigned long pa;
 	unsigned long apicid;
@@ -723,16 +799,17 @@ static int __init uv_init_blade(int blade, int node, int cur_cpu)
 	struct bau_payload_queue_entry *pqp;
 	struct bau_control *bau_tablesp;
 
+	node = blade_to_first_node(blade);
 	bau_tablesp = uv_table_bases_init(blade, node);
 	pnode = uv_blade_to_pnode(blade);
 	adp = uv_activation_descriptor_init(node, pnode);
 	pqp = uv_payload_queue_init(node, pnode, bau_tablesp);
-	uv_table_bases_finish(blade, node, cur_cpu, bau_tablesp, adp);
+	uv_table_bases_finish(blade, bau_tablesp, adp);
 	/*
 	 * the below initialization can't be in firmware because the
 	 * messaging IRQ will be determined by the OS
 	 */
-	apicid = per_cpu(x86_cpu_to_apicid, cur_cpu);
+	apicid = blade_to_first_apicid(blade);
 	pa = uv_read_global_mmr64(pnode, UVH_BAU_DATA_CONFIG);
 	if ((pa & 0xff) != UV_BAU_MESSAGE) {
 		uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
@@ -747,9 +824,7 @@ static int __init uv_init_blade(int blade, int node, int cur_cpu)
 static int __init uv_bau_init(void)
 {
 	int blade;
-	int node;
 	int nblades;
-	int last_blade;
 	int cur_cpu;
 
 	if (!is_uv_system())
@@ -758,29 +833,21 @@ static int __init uv_bau_init(void)
 	uv_bau_retry_limit = 1;
 	uv_nshift = uv_hub_info->n_val;
 	uv_mmask = (1UL << uv_hub_info->n_val) - 1;
-	nblades = 0;
-	last_blade = -1;
-	cur_cpu = 0;
-	for_each_online_node(node) {
-		blade = uv_node_to_blade_id(node);
-		if (blade == last_blade)
-			continue;
-		last_blade = blade;
-		nblades++;
-	}
+	nblades = uv_num_possible_blades();
+
 	uv_bau_table_bases = (struct bau_control **)
 	    kmalloc(nblades * sizeof(struct bau_control *), GFP_KERNEL);
 	BUG_ON(!uv_bau_table_bases);
 
-	last_blade = -1;
-	for_each_online_node(node) {
-		blade = uv_node_to_blade_id(node);
-		if (blade == last_blade)
-			continue;
-		last_blade = blade;
-		uv_init_blade(blade, node, cur_cpu);
-		cur_cpu += uv_blade_nr_possible_cpus(blade);
-	}
+	uv_partition_base_pnode = 0x7fffffff;
+	for (blade = 0; blade < nblades; blade++)
+		if (uv_blade_nr_possible_cpus(blade) &&
+			(uv_blade_to_pnode(blade) < uv_partition_base_pnode))
+			uv_partition_base_pnode = uv_blade_to_pnode(blade);
+	for (blade = 0; blade < nblades; blade++)
+		if (uv_blade_nr_possible_cpus(blade))
+			uv_init_blade(blade);
+
 	alloc_intr_gate(UV_BAU_MESSAGE, uv_bau_message_intr1);
 	uv_enable_timeouts();
 
diff --git a/arch/x86/kernel/uv_sysfs.c b/arch/x86/kernel/uv_sysfs.c
index 67f9b9d..36afb98 100644
--- a/arch/x86/kernel/uv_sysfs.c
+++ b/arch/x86/kernel/uv_sysfs.c
@@ -21,6 +21,7 @@
 
 #include <linux/sysdev.h>
 #include <asm/uv/bios.h>
+#include <asm/uv/uv.h>
 
 struct kobject *sgi_uv_kobj;
 
@@ -47,6 +48,9 @@ static int __init sgi_uv_sysfs_init(void)
 {
 	unsigned long ret;
 
+	if (!is_uv_system())
+		return -ENODEV;
+
 	if (!sgi_uv_kobj)
 		sgi_uv_kobj = kobject_create_and_add("sgi_uv", firmware_kobj);
 	if (!sgi_uv_kobj) {
