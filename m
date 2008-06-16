Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbYFPVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbYFPVIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbYFPVIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:08:05 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55059 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755852AbYFPVID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:08:03 -0400
To: mingo@elte.hu
Subject: [PATCHv5] SGI UV: TLB shootdown using broadcast assist unit - delta
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1K8Lvk-0004JX-In@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Mon, 16 Jun 2008 16:08:00 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Cliff Wickman <cpw@sgi.com>

TLB shootdown for SGI UV.

This is the delta from v4 to v5, implementing the recommendations
from Ingo's second review.

v1: 6/2 original
v2: 6/3 corrections/improvements per Ingo's review
v3: 6/4 split atomic operations off to a separate patch (Jeremy's review)
v4: 6/12 include <mach_apic.h> rather than <asm/mach-bigsmp/mach_apic.h>
         (fixes a !SMP build problem)
         fix the index on uv_table_bases[blade]
v5: 6/12 corrections/improvements per Ingo's second review

---
 Ingo,
   This patch should be applied to your x86/uv branch to make 
   the changes you requested the second time you reviewed this code.

 arch/x86/kernel/tlb_uv.c    |  183 ++++++++++++++++++++------------------------
 include/asm-x86/uv/uv_bau.h |   21 ++---
 2 files changed, 96 insertions(+), 108 deletions(-)

Index: 080602.ingo/arch/x86/kernel/tlb_uv.c
===================================================================
--- 080602.ingo.orig/arch/x86/kernel/tlb_uv.c
+++ 080602.ingo/arch/x86/kernel/tlb_uv.c
@@ -25,15 +25,8 @@ static int uv_bau_retry_limit __read_mos
 static int uv_nshift __read_mostly; /* position of pnode (which is nasid>>1) */
 static unsigned long uv_mmask __read_mostly;
 
-char *status_table[] = {
-	"IDLE",
-	"ACTIVE",
-	"DESTINATION TIMEOUT",
-	"SOURCE TIMEOUT"
-};
-
-DEFINE_PER_CPU(struct ptc_stats, ptcstats);
-DEFINE_PER_CPU(struct bau_control, bau_control);
+static DEFINE_PER_CPU(struct ptc_stats, ptcstats);
+static DEFINE_PER_CPU(struct bau_control, bau_control);
 
 /*
  * Free a software acknowledge hardware resource by clearing its Pending
@@ -55,7 +48,6 @@ static void uv_reply_to_message(int reso
 	if (msp)
 		msp->seen_by.bits = 0;
 	uv_write_local_mmr(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS, dw);
-	return;
 }
 
 /*
@@ -73,7 +65,7 @@ static void uv_bau_process_message(struc
 	cpu = uv_blade_processor_id();
 	msg->number_of_cpus =
 	    uv_blade_nr_online_cpus(uv_node_to_blade_id(numa_node_id()));
-	this_cpu_mask = (unsigned long)1 << cpu;
+	this_cpu_mask = 1UL << cpu;
 	if (msp->seen_by.bits & this_cpu_mask)
 		return;
 	atomic_or_long(&msp->seen_by.bits, this_cpu_mask);
@@ -94,53 +86,60 @@ static void uv_bau_process_message(struc
 	atomic_inc_short(&msg->acknowledge_count);
 	if (msg->number_of_cpus == msg->acknowledge_count)
 		uv_reply_to_message(sw_ack_slot, msg, msp);
-	return;
 }
 
 /*
- * Examine the payload queue on all the distribution nodes to see
+ * Examine the payload queue on one distribution node to see
  * which messages have not been seen, and which cpu(s) have not seen them.
  *
  * Returns the number of cpu's that have not responded.
  */
-static int uv_examine_destinations(struct bau_target_nodemask *distribution)
+static int uv_examine_destination(struct bau_control *bau_tablesp, int sender)
 {
-	int sender;
 	int i;
 	int j;
-	int k;
 	int count = 0;
-	struct bau_control *bau_tablesp;
 	struct bau_payload_queue_entry *msg;
 	struct bau_msg_status *msp;
 
+	for (msg = bau_tablesp->va_queue_first, i = 0; i < DEST_Q_SIZE;
+	     msg++, i++) {
+		if ((msg->sending_cpu == sender) && (!msg->replied_to)) {
+			msp = bau_tablesp->msg_statuses + i;
+			printk(KERN_DEBUG
+			       "blade %d: address:%#lx %d of %d, not cpu(s): ",
+			       i, msg->address, msg->acknowledge_count,
+			       msg->number_of_cpus);
+			for (j = 0; j < msg->number_of_cpus; j++) {
+				if (!((long)1 << j & msp-> seen_by.bits)) {
+					count++;
+					printk("%d ", j);
+				}
+			}
+			printk("\n");
+		}
+	}
+	return count;
+}
+
+/*
+ * Examine the payload queue on all the distribution nodes to see
+ * which messages have not been seen, and which cpu(s) have not seen them.
+ *
+ * Returns the number of cpu's that have not responded.
+ */
+static int uv_examine_destinations(struct bau_target_nodemask *distribution)
+{
+	int sender;
+	int i;
+	int count = 0;
+
 	sender = smp_processor_id();
 	for (i = 0; i < (sizeof(struct bau_target_nodemask) * BITSPERBYTE);
 	     i++) {
 		if (!bau_node_isset(i, distribution))
 			continue;
-		bau_tablesp = uv_bau_table_bases[i];
-		for (msg = bau_tablesp->va_queue_first, j = 0;
-		     j < DESTINATION_PAYLOAD_QUEUE_SIZE; msg++, j++) {
-			if ((msg->sending_cpu == sender) &&
-			    (!msg->replied_to)) {
-				msp = bau_tablesp->msg_statuses + j;
-				printk(KERN_DEBUG
-				"blade %d: address:%#lx %d of %d, not cpu(s): ",
-				       i, msg->address,
-				       msg->acknowledge_count,
-				       msg->number_of_cpus);
-				for (k = 0; k < msg->number_of_cpus;
-				     k++) {
-					if (!((long)1 << k & msp->
-					      seen_by.bits)) {
-						count++;
-						printk("%d ", k);
-					}
-				}
-				printk("\n");
-			}
-		}
+		count += uv_examine_destination(uv_bau_table_bases[i], sender);
 	}
 	return count;
 }
@@ -150,7 +149,7 @@ static int uv_examine_destinations(struc
  *
  * return COMPLETE, RETRY or GIVEUP
  */
-static int uv_wait_completion(struct bau_activation_descriptor *bau_desc,
+static int uv_wait_completion(struct bau_desc *bau_desc,
 			      unsigned long mmr_offset, int right_shift)
 {
 	int exams = 0;
@@ -213,8 +212,8 @@ static int uv_wait_completion(struct bau
  * Returns 0 if some remote flushing remains to be done. The mask is left
  * unchanged.
  */
-int uv_flush_send_and_wait(int cpu, int this_blade,
-	struct bau_activation_descriptor *bau_desc, cpumask_t *cpumaskp)
+int uv_flush_send_and_wait(int cpu, int this_blade, struct bau_desc *bau_desc,
+			   cpumask_t *cpumaskp)
 {
 	int completion_status = 0;
 	int right_shift;
@@ -237,8 +236,8 @@ int uv_flush_send_and_wait(int cpu, int 
 	time1 = get_cycles();
 	do {
 		tries++;
-		index = ((unsigned long)
-			1 << UVH_LB_BAU_SB_ACTIVATION_CONTROL_PUSH_SHFT) | cpu;
+		index = (1UL << UVH_LB_BAU_SB_ACTIVATION_CONTROL_PUSH_SHFT) |
+			cpu;
 		uv_write_local_mmr(UVH_LB_BAU_SB_ACTIVATION_CONTROL, index);
 		completion_status = uv_wait_completion(bau_desc, mmr_offset,
 					right_shift);
@@ -303,7 +302,7 @@ int uv_flush_tlb_others(cpumask_t *cpuma
 	int cpu;
 	int this_blade;
 	int locals = 0;
-	struct bau_activation_descriptor *bau_desc;
+	struct bau_desc *bau_desc;
 
 	cpu = uv_blade_processor_id();
 	this_blade = uv_numa_blade_id();
@@ -315,8 +314,7 @@ int uv_flush_tlb_others(cpumask_t *cpuma
 	i = 0;
 	for_each_cpu_mask(bit, *cpumaskp) {
 		blade = uv_cpu_to_blade_id(bit);
-		if (blade > (UV_DISTRIBUTION_SIZE - 1))
-			BUG();
+		BUG_ON(blade > (UV_DISTRIBUTION_SIZE - 1));
 		if (blade == this_blade) {
 			locals++;
 			continue;
@@ -360,6 +358,8 @@ void uv_bau_message_interrupt(struct pt_
 {
 	struct bau_payload_queue_entry *pqp;
 	struct bau_payload_queue_entry *msg;
+	struct bau_payload_queue_entry *va_queue_first;
+	struct bau_payload_queue_entry *va_queue_last;
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	cycles_t time1, time2;
 	int msg_slot;
@@ -376,7 +376,8 @@ void uv_bau_message_interrupt(struct pt_
 
 	local_pnode = uv_blade_to_pnode(uv_numa_blade_id());
 
-	pqp = __get_cpu_var(bau_control).va_queue_first;
+	pqp = va_queue_first = __get_cpu_var(bau_control).va_queue_first;
+	va_queue_last = __get_cpu_var(bau_control).va_queue_last;
 	msg = __get_cpu_var(bau_control).bau_msg_head;
 	while (msg->sw_ack_vector) {
 		count++;
@@ -387,8 +388,8 @@ void uv_bau_message_interrupt(struct pt_
 		uv_bau_process_message(msg, msg_slot, sw_ack_slot);
 
 		msg++;
-		if (msg > __get_cpu_var(bau_control).va_queue_last)
-			msg = __get_cpu_var(bau_control).va_queue_first;
+		if (msg > va_queue_last)
+			msg = va_queue_first;
 		__get_cpu_var(bau_control).bau_msg_head = msg;
 	}
 	if (!count)
@@ -401,7 +402,6 @@ void uv_bau_message_interrupt(struct pt_
 
 	irq_exit();
 	set_irq_regs(old_regs);
-	return;
 }
 
 static void uv_enable_timeouts(void)
@@ -423,7 +423,6 @@ static void uv_enable_timeouts(void)
 		pnode = uv_blade_to_pnode(blade);
 		cur_cpu += uv_blade_nr_possible_cpus(i);
 	}
-	return;
 }
 
 static void *uv_ptc_seq_start(struct seq_file *file, loff_t *offset)
@@ -535,10 +534,10 @@ static ssize_t uv_ptc_proc_write(struct 
 }
 
 static const struct seq_operations uv_ptc_seq_ops = {
-	.start	= uv_ptc_seq_start,
-	.next	= uv_ptc_seq_next,
-	.stop	= uv_ptc_seq_stop,
-	.show	= uv_ptc_seq_show
+	.start		= uv_ptc_seq_start,
+	.next		= uv_ptc_seq_next,
+	.stop		= uv_ptc_seq_stop,
+	.show		= uv_ptc_seq_show
 };
 
 static int uv_ptc_proc_open(struct inode *inode, struct file *file)
@@ -568,6 +567,7 @@ static int __init uv_ptc_init(void)
 	if (!proc_uv_ptc) {
 		printk(KERN_ERR "unable to create %s proc entry\n",
 		       UV_PTC_BASENAME);
+		remove_proc_entry("sgi_uv", NULL);
 		return -EINVAL;
 	}
 	proc_uv_ptc->proc_fops = &proc_uv_ptc_operations;
@@ -582,33 +582,26 @@ static struct bau_control * __init uv_ta
 	int i;
 	int *ip;
 	struct bau_msg_status *msp;
-	struct bau_control *bau_tablesp;
+	struct bau_control *bau_tabp;
 
-	bau_tablesp =
+	bau_tabp =
 	    kmalloc_node(sizeof(struct bau_control), GFP_KERNEL, node);
-	if (!bau_tablesp)
-		BUG();
-	bau_tablesp->msg_statuses =
+	BUG_ON(!bau_tabp);
+	bau_tabp->msg_statuses =
 	    kmalloc_node(sizeof(struct bau_msg_status) *
-			 DESTINATION_PAYLOAD_QUEUE_SIZE, GFP_KERNEL, node);
-	if (!bau_tablesp->msg_statuses)
-		BUG();
-	for (i = 0, msp = bau_tablesp->msg_statuses;
-	     i < DESTINATION_PAYLOAD_QUEUE_SIZE; i++, msp++) {
+			 DEST_Q_SIZE, GFP_KERNEL, node);
+	BUG_ON(!bau_tabp->msg_statuses);
+	for (i = 0, msp = bau_tabp->msg_statuses; i < DEST_Q_SIZE; i++, msp++)
 		bau_cpubits_clear(&msp->seen_by, (int)
 				  uv_blade_nr_possible_cpus(blade));
-	}
-	bau_tablesp->watching =
-	    kmalloc_node(sizeof(int) * DESTINATION_NUM_RESOURCES,
-			 GFP_KERNEL, node);
-	if (!bau_tablesp->watching)
-		BUG();
-	for (i = 0, ip = bau_tablesp->watching;
-	     i < DESTINATION_PAYLOAD_QUEUE_SIZE; i++, ip++) {
+	bau_tabp->watching =
+	    kmalloc_node(sizeof(int) * DEST_NUM_RESOURCES, GFP_KERNEL, node);
+	BUG_ON(!bau_tabp->watching);
+	for (i = 0, ip = bau_tabp->watching; i < DEST_Q_SIZE; i++, ip++) {
 		*ip = 0;
 	}
-	uv_bau_table_bases[blade] = bau_tablesp;
-	return bau_tablesp;
+	uv_bau_table_bases[blade] = bau_tabp;
+	return bau_tabp;
 }
 
 /*
@@ -616,7 +609,7 @@ static struct bau_control * __init uv_ta
  */
 static void __init uv_table_bases_finish(int blade, int node, int cur_cpu,
 				  struct bau_control *bau_tablesp,
-				  struct bau_activation_descriptor *adp)
+				  struct bau_desc *adp)
 {
 	int i;
 	struct bau_control *bcp;
@@ -636,7 +629,7 @@ static void __init uv_table_bases_finish
 /*
  * initialize the sending side's sending buffers
  */
-static struct bau_activation_descriptor * __init
+static struct bau_desc * __init
 uv_activation_descriptor_init(int node, int pnode)
 {
 	int i;
@@ -644,13 +637,12 @@ uv_activation_descriptor_init(int node, 
 	unsigned long m;
 	unsigned long n;
 	unsigned long mmr_image;
-	struct bau_activation_descriptor *adp;
-	struct bau_activation_descriptor *ad2;
+	struct bau_desc *adp;
+	struct bau_desc *ad2;
 
-	adp = (struct bau_activation_descriptor *)
+	adp = (struct bau_desc *)
 	    kmalloc_node(16384, GFP_KERNEL, node);
-	if (!adp)
-		BUG();
+	BUG_ON(!adp);
 	pa = __pa((unsigned long)adp);
 	n = pa >> uv_nshift;
 	m = pa & uv_mmask;
@@ -660,7 +652,7 @@ uv_activation_descriptor_init(int node, 
 				      UVH_LB_BAU_SB_DESCRIPTOR_BASE,
 				      (n << UV_DESC_BASE_PNODE_SHIFT | m));
 	for (i = 0, ad2 = adp; i < UV_ACTIVATION_DESCRIPTOR_SIZE; i++, ad2++) {
-		memset(ad2, 0, sizeof(struct bau_activation_descriptor));
+		memset(ad2, 0, sizeof(struct bau_desc));
 		ad2->header.sw_ack_flag = 1;
 		ad2->header.base_dest_nodeid =
 		    uv_blade_to_pnode(uv_cpu_to_blade_id(0));
@@ -683,12 +675,10 @@ static struct bau_payload_queue_entry * 
 	char *cp;
 	struct bau_payload_queue_entry *pqp;
 
-	pqp = (struct bau_payload_queue_entry *)
-	    kmalloc_node((DESTINATION_PAYLOAD_QUEUE_SIZE + 1) *
-			 sizeof(struct bau_payload_queue_entry),
-			 GFP_KERNEL, node);
-	if (!pqp)
-		BUG();
+	pqp = (struct bau_payload_queue_entry *) kmalloc_node(
+		(DEST_Q_SIZE + 1) * sizeof(struct bau_payload_queue_entry),
+		GFP_KERNEL, node);
+	BUG_ON(!pqp);
 	cp = (char *)pqp + 31;
 	pqp = (struct bau_payload_queue_entry *)(((unsigned long)cp >> 5) << 5);
 	bau_tablesp->va_queue_first = pqp;
@@ -699,13 +689,11 @@ static struct bau_payload_queue_entry * 
 			      uv_physnodeaddr(pqp));
 	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL,
 			      uv_physnodeaddr(pqp));
-	bau_tablesp->va_queue_last =
-	    pqp + (DESTINATION_PAYLOAD_QUEUE_SIZE - 1);
+	bau_tablesp->va_queue_last = pqp + (DEST_Q_SIZE - 1);
 	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST,
 			      (unsigned long)
 			      uv_physnodeaddr(bau_tablesp->va_queue_last));
-	memset(pqp, 0, sizeof(struct bau_payload_queue_entry) *
-	       DESTINATION_PAYLOAD_QUEUE_SIZE);
+	memset(pqp, 0, sizeof(struct bau_payload_queue_entry) * DEST_Q_SIZE);
 	return pqp;
 }
 
@@ -717,7 +705,7 @@ static int __init uv_init_blade(int blad
 	int pnode;
 	unsigned long pa;
 	unsigned long apicid;
-	struct bau_activation_descriptor *adp;
+	struct bau_desc *adp;
 	struct bau_payload_queue_entry *pqp;
 	struct bau_control *bau_tablesp;
 
@@ -755,7 +743,7 @@ static int __init uv_bau_init(void)
 
 	uv_bau_retry_limit = 1;
 	uv_nshift = uv_hub_info->n_val;
-	uv_mmask = ((unsigned long)1 << uv_hub_info->n_val) - 1;
+	uv_mmask = (1UL << uv_hub_info->n_val) - 1;
 	nblades = 0;
 	last_blade = -1;
 	for_each_online_node(node) {
@@ -767,8 +755,7 @@ static int __init uv_bau_init(void)
 	}
 	uv_bau_table_bases = (struct bau_control **)
 	    kmalloc(nblades * sizeof(struct bau_control *), GFP_KERNEL);
-	if (!uv_bau_table_bases)
-		BUG();
+	BUG_ON(!uv_bau_table_bases);
 	last_blade = -1;
 	for_each_online_node(node) {
 		blade = uv_node_to_blade_id(node);
Index: 080602.ingo/include/asm-x86/uv/uv_bau.h
===================================================================
--- 080602.ingo.orig/include/asm-x86/uv/uv_bau.h
+++ 080602.ingo/include/asm-x86/uv/uv_bau.h
@@ -54,25 +54,25 @@
 /*
  * bits in UVH_LB_BAU_SB_ACTIVATION_STATUS_0/1
  */
-#define DESC_STATUS_IDLE                0
-#define DESC_STATUS_ACTIVE              1
-#define DESC_STATUS_DESTINATION_TIMEOUT 2
-#define DESC_STATUS_SOURCE_TIMEOUT      3
+#define DESC_STATUS_IDLE		0
+#define DESC_STATUS_ACTIVE		1
+#define DESC_STATUS_DESTINATION_TIMEOUT	2
+#define DESC_STATUS_SOURCE_TIMEOUT	3
 
 /*
  * source side threshholds at which message retries print a warning
  */
-#define SOURCE_TIMEOUT_LIMIT            20
-#define DESTINATION_TIMEOUT_LIMIT       20
+#define SOURCE_TIMEOUT_LIMIT		20
+#define DESTINATION_TIMEOUT_LIMIT	20
 
 /*
  * number of entries in the destination side payload queue
  */
-#define DESTINATION_PAYLOAD_QUEUE_SIZE  17
+#define DEST_Q_SIZE			17
 /*
  * number of destination side software ack resources
  */
-#define DESTINATION_NUM_RESOURCES       8
+#define DEST_NUM_RESOURCES		8
 #define MAX_CPUS_PER_NODE		32
 /*
  * completion statuses for sending a TLB flush message
@@ -197,10 +197,11 @@ struct bau_msg_header {
 };
 
 /*
+ * The activation descriptor:
  * The format of the message to send, plus all accompanying control
  * Should be 64 bytes
  */
-struct bau_activation_descriptor {
+struct bau_desc {
 	struct bau_target_nodemask distribution;
 	/*
 	 * message template, consisting of header and payload:
@@ -281,7 +282,7 @@ struct bau_sw_ack_status {
  * one on every node and per-cpu; to locate the software tables
  */
 struct bau_control {
-	struct bau_activation_descriptor *descriptor_base;
+	struct bau_desc *descriptor_base;
 	struct bau_payload_queue_entry *bau_msg_head;
 	struct bau_payload_queue_entry *va_queue_first;
 	struct bau_payload_queue_entry *va_queue_last;
