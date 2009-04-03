Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbZDCNdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbZDCNdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZDCNdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:33:44 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42775 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750971AbZDCNdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:33:43 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV BAU and nodes with no memory
Cc: mingo@elte.hu
Message-Id: <E1LpjX3-00007N-12@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Fri, 03 Apr 2009 08:34:05 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Cliff Wickman <cpw@sgi.com>

This patch fixes BAU initialization for systems containing
nodes with no memory and for systems with non-consecutive
node numbers.

Fixes and clarifies situations where pnode should be used instead
of node id.

Tested on the UV hardware simulator.

Diffed against 2.6.29

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/kernel/tlb_uv.c |  108 ++++++++++++++++++++++++++---------------------
 1 file changed, 61 insertions(+), 47 deletions(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -32,6 +32,34 @@ static DEFINE_PER_CPU(struct ptc_stats, 
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
+	BUG();
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
@@ -67,7 +95,7 @@ static void uv_bau_process_message(struc
 	msp = __get_cpu_var(bau_control).msg_statuses + msg_slot;
 	cpu = uv_blade_processor_id();
 	msg->number_of_cpus =
-	    uv_blade_nr_online_cpus(uv_node_to_blade_id(numa_node_id()));
+		uv_blade_nr_online_cpus(uv_node_to_blade_id(numa_node_id()));
 	this_cpu_mask = 1UL << cpu;
 	if (msp->seen_by.bits & this_cpu_mask)
 		return;
@@ -215,14 +243,14 @@ static int uv_wait_completion(struct bau
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
@@ -265,8 +293,8 @@ const struct cpumask *uv_flush_send_and_
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
@@ -309,16 +337,16 @@ const struct cpumask *uv_flush_tlb_other
 	struct cpumask *flush_mask = __get_cpu_var(uv_flush_tlb_mask);
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
 
@@ -326,13 +354,13 @@ const struct cpumask *uv_flush_tlb_other
 
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
+		bau_node_set(pnode, &bau_desc->distribution);
 		i++;
 	}
 	if (i == 0) {
@@ -350,7 +378,7 @@ const struct cpumask *uv_flush_tlb_other
 	bau_desc->payload.address = va;
 	bau_desc->payload.sending_cpu = cpu;
 
-	return uv_flush_send_and_wait(uv_cpu, this_blade, bau_desc, flush_mask);
+	return uv_flush_send_and_wait(uv_cpu, this_pnode, bau_desc, flush_mask);
 }
 
 /*
@@ -482,8 +510,7 @@ static int uv_ptc_seq_show(struct seq_fi
 			   stat->requestee, stat->onetlb, stat->alltlb,
 			   stat->s_retry, stat->d_retry, stat->ptc_i);
 		seq_printf(file, "%lx %ld %ld %ld %ld %ld %ld\n",
-			   uv_read_global_mmr64(uv_blade_to_pnode
-					(uv_cpu_to_blade_id(cpu)),
+			   uv_read_global_mmr64(uv_cpu_to_pnode(cpu),
 					UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE),
 			   stat->sflush, stat->dflush,
 			   stat->retriesok, stat->nomsg,
@@ -617,16 +644,18 @@ static struct bau_control * __init uv_ta
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
@@ -649,8 +678,7 @@ uv_activation_descriptor_init(int node, 
 	struct bau_desc *adp;
 	struct bau_desc *ad2;
 
-	adp = (struct bau_desc *)
-	    kmalloc_node(16384, GFP_KERNEL, node);
+	adp = (struct bau_desc *)kmalloc_node(16384, GFP_KERNEL, node);
 	BUG_ON(!adp);
 
 	pa = __pa((unsigned long)adp);
@@ -667,8 +695,7 @@ uv_activation_descriptor_init(int node, 
 	for (i = 0, ad2 = adp; i < UV_ACTIVATION_DESCRIPTOR_SIZE; i++, ad2++) {
 		memset(ad2, 0, sizeof(struct bau_desc));
 		ad2->header.sw_ack_flag = 1;
-		ad2->header.base_dest_nodeid =
-		    uv_blade_to_pnode(uv_cpu_to_blade_id(0));
+		ad2->header.base_dest_nodeid = uv_cpu_to_pnode(0);
 		ad2->header.command = UV_NET_ENDPOINT_INTD;
 		ad2->header.int_both = 1;
 		/*
@@ -715,8 +742,9 @@ uv_payload_queue_init(int node, int pnod
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
@@ -724,16 +752,17 @@ static int __init uv_init_blade(int blad
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
@@ -748,9 +777,7 @@ static int __init uv_init_blade(int blad
 static int __init uv_bau_init(void)
 {
 	int blade;
-	int node;
 	int nblades;
-	int last_blade;
 	int cur_cpu;
 
 	if (!is_uv_system())
@@ -763,29 +790,16 @@ static int __init uv_bau_init(void)
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
+	for (blade = 0; blade < nblades; blade++)
+		if (uv_blade_nr_possible_cpus(blade))
+			uv_init_blade(blade);
+
 	alloc_intr_gate(UV_BAU_MESSAGE, uv_bau_message_intr1);
 	uv_enable_timeouts();
 
