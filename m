Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYFLUHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYFLUHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYFLUHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:07:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56520 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754416AbYFLUHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:07:22 -0400
To: mingo@elte.hu
Subject: Re: [PATCH] SGI UV: TLB shootdown using broadcast assist unit
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1K6t40-0000UB-GC@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 12 Jun 2008 15:06:28 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




From: Cliff Wickman <cpw@sgi.com>

TLB shootdown for SGI UV. 

This patch brings v1 up to v5.

v1: 6/2 original
v2: 6/3 corrections/improvements per Ingo's review
v3: 6/4 split atomic operations off to a separate patch (Jeremy's review)
v4: 6/12 include <mach_apic.h> rather than <asm/mach-bigsmp/mach_apic.h>
         (fixes a !SMP build problem that Ingo found)
         fix the index on uv_table_bases[blade]
v5: 6/12 corrections/improvements per Ingo's second review


Diffed against 2.6.26-rc4 branch x86/x86/uv

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---

 arch/x86/kernel/tlb_64.c    |    2 
 arch/x86/kernel/tlb_uv.c    |  749 +++++++++++++++++++++++---------------------
 include/asm-x86/uv/uv_bau.h |  172 +++++-----
 3 files changed, 483 insertions(+), 440 deletions(-)

Index: linux/arch/x86/kernel/tlb_64.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_64.c
+++ linux/arch/x86/kernel/tlb_64.c
@@ -165,7 +165,7 @@ void native_flush_tlb_others(const cpuma
 	cpumask_t cpumask = *cpumaskp;
 
 	if (is_uv_system() && uv_flush_tlb_others(&cpumask, mm, va))
-			return;
+		return;
 
 	/* Caller has disabled preemption */
 	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -10,28 +10,23 @@
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
 
-#include <asm/mach-bigsmp/mach_apic.h>
 #include <asm/mmu_context.h>
 #include <asm/idle.h>
 #include <asm/genapic.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_bau.h>
+#include <asm/tsc.h>
 
-struct bau_control **uv_bau_table_bases;
-static int uv_bau_retry_limit;
-static int uv_nshift;		/* position of pnode (which is nasid>>1) */
-static unsigned long uv_mmask;
-
-char *status_table[] = {
-	"IDLE",
-	"ACTIVE",
-	"DESTINATION TIMEOUT",
-	"SOURCE TIMEOUT"
-};
+#include <mach_apic.h>
+
+static struct bau_control **uv_bau_table_bases __read_mostly;
+static int uv_bau_retry_limit __read_mostly;
+static int uv_nshift __read_mostly; /* position of pnode (which is nasid>>1) */
+static unsigned long uv_mmask __read_mostly;
 
-DEFINE_PER_CPU(struct ptc_stats, ptcstats);
-DEFINE_PER_CPU(struct bau_control, bau_control);
+static DEFINE_PER_CPU(struct ptc_stats, ptcstats);
+static DEFINE_PER_CPU(struct bau_control, bau_control);
 
 /*
  * Free a software acknowledge hardware resource by clearing its Pending
@@ -41,28 +36,25 @@ DEFINE_PER_CPU(struct bau_control, bau_c
  * clear of the Timeout bit (as well) will free the resource. No reply will
  * be sent (the hardware will only do one reply per message).
  */
-static void
-uv_reply_to_message(int resource,
+static void uv_reply_to_message(int resource,
 		    struct bau_payload_queue_entry *msg,
 		    struct bau_msg_status *msp)
 {
-	int fw;
+	unsigned long dw;
 
-	fw = (1 << (resource + UV_SW_ACK_NPENDING)) | (1 << resource);
+	dw = (1 << (resource + UV_SW_ACK_NPENDING)) | (1 << resource);
 	msg->replied_to = 1;
 	msg->sw_ack_vector = 0;
 	if (msp)
 		msp->seen_by.bits = 0;
-	uv_write_local_mmr(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS, fw);
-	return;
+	uv_write_local_mmr(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS, dw);
 }
 
 /*
  * Do all the things a cpu should do for a TLB shootdown message.
  * Other cpu's may come here at the same time for this message.
  */
-static void
-uv_bau_process_message(struct bau_payload_queue_entry *msg,
+static void uv_bau_process_message(struct bau_payload_queue_entry *msg,
 		       int msg_slot, int sw_ack_slot)
 {
 	int cpu;
@@ -73,7 +65,7 @@ uv_bau_process_message(struct bau_payloa
 	cpu = uv_blade_processor_id();
 	msg->number_of_cpus =
 	    uv_blade_nr_online_cpus(uv_node_to_blade_id(numa_node_id()));
-	this_cpu_mask = (unsigned long)1 << cpu;
+	this_cpu_mask = 1UL << cpu;
 	if (msp->seen_by.bits & this_cpu_mask)
 		return;
 	atomic_or_long(&msp->seen_by.bits, this_cpu_mask);
@@ -94,56 +86,189 @@ uv_bau_process_message(struct bau_payloa
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
-static int
-uv_examine_destinations(struct bau_target_nodemask *distribution)
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
-		if (bau_node_isset(i, distribution)) {
-			bau_tablesp = uv_bau_table_bases[i];
-			for (msg = bau_tablesp->va_queue_first, j = 0;
-			     j < DESTINATION_PAYLOAD_QUEUE_SIZE; msg++, j++) {
-				if ((msg->sending_cpu == sender) &&
-				    (!msg->replied_to)) {
-					msp = bau_tablesp->msg_statuses + j;
+		if (!bau_node_isset(i, distribution))
+			continue;
+		count += uv_examine_destination(uv_bau_table_bases[i], sender);
+	}
+	return count;
+}
+
+/*
+ * wait for completion of a broadcast message
+ *
+ * return COMPLETE, RETRY or GIVEUP
+ */
+static int uv_wait_completion(struct bau_desc *bau_desc,
+			      unsigned long mmr_offset, int right_shift)
+{
+	int exams = 0;
+	long destination_timeouts = 0;
+	long source_timeouts = 0;
+	unsigned long descriptor_status;
+
+	while ((descriptor_status = (((unsigned long)
+		uv_read_local_mmr(mmr_offset) >>
+			right_shift) & UV_ACT_STATUS_MASK)) !=
+			DESC_STATUS_IDLE) {
+		if (descriptor_status == DESC_STATUS_SOURCE_TIMEOUT) {
+			source_timeouts++;
+			if (source_timeouts > SOURCE_TIMEOUT_LIMIT)
+				source_timeouts = 0;
+			__get_cpu_var(ptcstats).s_retry++;
+			return FLUSH_RETRY;
+		}
+		/*
+		 * spin here looking for progress at the destinations
+		 */
+		if (descriptor_status == DESC_STATUS_DESTINATION_TIMEOUT) {
+			destination_timeouts++;
+			if (destination_timeouts > DESTINATION_TIMEOUT_LIMIT) {
+				/*
+				 * returns number of cpus not responding
+				 */
+				if (uv_examine_destinations
+				    (&bau_desc->distribution) == 0) {
+					__get_cpu_var(ptcstats).d_retry++;
+					return FLUSH_RETRY;
+				}
+				exams++;
+				if (exams >= uv_bau_retry_limit) {
 					printk(KERN_DEBUG
-				"blade %d: address:%#lx %d of %d, not cpu(s): ",
-					       i, msg->address,
-					       msg->acknowledge_count,
-					       msg->number_of_cpus);
-					for (k = 0; k < msg->number_of_cpus;
-					     k++) {
-						if (!((long)1 << k & msp->
-						      seen_by.bits)) {
-							count++;
-							printk("%d ", k);
-						}
-					}
-					printk("\n");
+					       "uv_flush_tlb_others");
+					printk("giving up on cpu %d\n",
+					       smp_processor_id());
+					return FLUSH_GIVEUP;
 				}
+				/*
+				 * delays can hang the simulator
+				   udelay(1000);
+				 */
+				destination_timeouts = 0;
 			}
 		}
 	}
-	return count;
+	return FLUSH_COMPLETE;
+}
+
+/**
+ * uv_flush_send_and_wait
+ *
+ * Send a broadcast and wait for a broadcast message to complete.
+ *
+ * The cpumaskp mask contains the cpus the broadcast was sent to.
+ *
+ * Returns 1 if all remote flushing was done. The mask is zeroed.
+ * Returns 0 if some remote flushing remains to be done. The mask is left
+ * unchanged.
+ */
+int uv_flush_send_and_wait(int cpu, int this_blade, struct bau_desc *bau_desc,
+			   cpumask_t *cpumaskp)
+{
+	int completion_status = 0;
+	int right_shift;
+	int bit;
+	int blade;
+	int tries = 0;
+	unsigned long index;
+	unsigned long mmr_offset;
+	cycles_t time1;
+	cycles_t time2;
+
+	if (cpu < UV_CPUS_PER_ACT_STATUS) {
+		mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_0;
+		right_shift = cpu * UV_ACT_STATUS_SIZE;
+	} else {
+		mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_1;
+		right_shift =
+		    ((cpu - UV_CPUS_PER_ACT_STATUS) * UV_ACT_STATUS_SIZE);
+	}
+	time1 = get_cycles();
+	do {
+		tries++;
+		index = (1UL << UVH_LB_BAU_SB_ACTIVATION_CONTROL_PUSH_SHFT) |
+			cpu;
+		uv_write_local_mmr(UVH_LB_BAU_SB_ACTIVATION_CONTROL, index);
+		completion_status = uv_wait_completion(bau_desc, mmr_offset,
+					right_shift);
+	} while (completion_status == FLUSH_RETRY);
+	time2 = get_cycles();
+	__get_cpu_var(ptcstats).sflush += (time2 - time1);
+	if (tries > 1)
+		__get_cpu_var(ptcstats).retriesok++;
+
+	if (completion_status == FLUSH_GIVEUP) {
+		/*
+		 * Cause the caller to do an IPI-style TLB shootdown on
+		 * the cpu's, all of which are still in the mask.
+		 */
+		__get_cpu_var(ptcstats).ptc_i++;
+		return 0;
+	}
+
+	/*
+	 * Success, so clear the remote cpu's from the mask so we don't
+	 * use the IPI method of shootdown on them.
+	 */
+	for_each_cpu_mask(bit, *cpumaskp) {
+		blade = uv_cpu_to_blade_id(bit);
+		if (blade == this_blade)
+			continue;
+		cpu_clear(bit, *cpumaskp);
+	}
+	if (!cpus_empty(*cpumaskp))
+		return 0;
+	return 1;
 }
 
 /**
@@ -164,128 +289,55 @@ uv_examine_destinations(struct bau_targe
  *
  * The cpumaskp is converted into a nodemask of the nodes containing
  * the cpus.
+ *
+ * Returns 1 if all remote flushing was done.
+ * Returns 0 if some remote flushing remains to be done.
  */
-int
-uv_flush_tlb_others(cpumask_t *cpumaskp, struct mm_struct *mm, unsigned long va)
+int uv_flush_tlb_others(cpumask_t *cpumaskp, struct mm_struct *mm,
+	unsigned long va)
 {
 	int i;
+	int bit;
 	int blade;
 	int cpu;
-	int bit;
-	int right_shift;
 	int this_blade;
-	int exams = 0;
-	int tries = 0;
-	long source_timeouts = 0;
-	long destination_timeouts = 0;
-	unsigned long index;
-	unsigned long mmr_offset;
-	unsigned long descriptor_status;
-	struct bau_activation_descriptor *bau_desc;
-	ktime_t time1, time2;
+	int locals = 0;
+	struct bau_desc *bau_desc;
 
 	cpu = uv_blade_processor_id();
 	this_blade = uv_numa_blade_id();
 	bau_desc = __get_cpu_var(bau_control).descriptor_base;
-	bau_desc += (UV_ITEMS_PER_DESCRIPTOR * cpu);
+	bau_desc += UV_ITEMS_PER_DESCRIPTOR * cpu;
 
 	bau_nodes_clear(&bau_desc->distribution, UV_DISTRIBUTION_SIZE);
 
 	i = 0;
 	for_each_cpu_mask(bit, *cpumaskp) {
 		blade = uv_cpu_to_blade_id(bit);
-		if (blade > (UV_DISTRIBUTION_SIZE - 1))
-			BUG();
-		if (blade == this_blade)
+		BUG_ON(blade > (UV_DISTRIBUTION_SIZE - 1));
+		if (blade == this_blade) {
+			locals++;
 			continue;
+		}
 		bau_node_set(blade, &bau_desc->distribution);
-		/* leave the bits for the remote cpu's in the mask until
-		   success; on failure we fall back to the IPI method */
 		i++;
 	}
-	if (i == 0)
-		goto none_to_flush;
+	if (i == 0) {
+		/*
+		 * no off_node flushing; return status for local node
+		 */
+		if (locals)
+			return 0;
+		else
+			return 1;
+	}
 	__get_cpu_var(ptcstats).requestor++;
 	__get_cpu_var(ptcstats).ntargeted += i;
 
 	bau_desc->payload.address = va;
 	bau_desc->payload.sending_cpu = smp_processor_id();
 
-	if (cpu < UV_CPUS_PER_ACT_STATUS) {
-		mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_0;
-		right_shift = cpu * UV_ACT_STATUS_SIZE;
-	} else {
-		mmr_offset = UVH_LB_BAU_SB_ACTIVATION_STATUS_1;
-		right_shift =
-		    ((cpu - UV_CPUS_PER_ACT_STATUS) * UV_ACT_STATUS_SIZE);
-	}
-	time1 = ktime_get();
-
-retry:
-	tries++;
-	index = ((unsigned long)
-		 1 << UVH_LB_BAU_SB_ACTIVATION_CONTROL_PUSH_SHFT) | cpu;
-	uv_write_local_mmr(UVH_LB_BAU_SB_ACTIVATION_CONTROL, index);
-
-	while ((descriptor_status = (((unsigned long)
-				      uv_read_local_mmr(mmr_offset) >>
-				      right_shift) & UV_ACT_STATUS_MASK)) !=
-	       DESC_STATUS_IDLE) {
-		if (descriptor_status == DESC_STATUS_SOURCE_TIMEOUT) {
-			source_timeouts++;
-			if (source_timeouts > SOURCE_TIMEOUT_LIMIT)
-				source_timeouts = 0;
-			__get_cpu_var(ptcstats).s_retry++;
-			goto retry;
-		}
-		/* spin here looking for progress at the destinations */
-		if (descriptor_status == DESC_STATUS_DESTINATION_TIMEOUT) {
-			destination_timeouts++;
-			if (destination_timeouts > DESTINATION_TIMEOUT_LIMIT) {
-				/* returns # of cpus not responding */
-				if (uv_examine_destinations
-				    (&bau_desc->distribution) == 0) {
-					__get_cpu_var(ptcstats).d_retry++;
-					goto retry;
-				}
-				exams++;
-				if (exams >= uv_bau_retry_limit) {
-					printk(KERN_DEBUG
-					       "uv_flush_tlb_others");
-					printk("giving up on cpu %d\n",
-					       smp_processor_id());
-					goto unsuccessful;
-				}
-				/* delays can hang up the simulator
-				   udelay(1000);
-				 */
-				destination_timeouts = 0;
-			}
-		}
-	}
-	if (tries > 1)
-		__get_cpu_var(ptcstats).retriesok++;
-	/* on success, clear the remote cpu's from the mask so we don't
-	   use the IPI method of shootdown on them */
-	for_each_cpu_mask(bit, *cpumaskp) {
-		blade = uv_cpu_to_blade_id(bit);
-		if (blade == this_blade)
-			continue;
-		cpu_clear(bit, *cpumaskp);
-	}
-
-unsuccessful:
-	time2 = ktime_get();
-	__get_cpu_var(ptcstats).sflush_ns += (time2.tv64 - time1.tv64);
-
-none_to_flush:
-	if (cpus_empty(*cpumaskp))
-		return 1;
-
-	/* Cause the caller to do an IPI-style TLB shootdown on
-	   the cpu's still in the mask */
-	__get_cpu_var(ptcstats).ptc_i++;
-	return 0;
+	return uv_flush_send_and_wait(cpu, this_blade, bau_desc, cpumaskp);
 }
 
 /*
@@ -302,13 +354,14 @@ none_to_flush:
  * (the resource will not be freed until noninterruptable cpus see this
  *  interrupt; hardware will timeout the s/w ack and reply ERROR)
  */
-void
-uv_bau_message_interrupt(struct pt_regs *regs)
+void uv_bau_message_interrupt(struct pt_regs *regs)
 {
 	struct bau_payload_queue_entry *pqp;
 	struct bau_payload_queue_entry *msg;
+	struct bau_payload_queue_entry *va_queue_first;
+	struct bau_payload_queue_entry *va_queue_last;
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	ktime_t time1, time2;
+	cycles_t time1, time2;
 	int msg_slot;
 	int sw_ack_slot;
 	int fw;
@@ -319,11 +372,12 @@ uv_bau_message_interrupt(struct pt_regs 
 	exit_idle();
 	irq_enter();
 
-	time1 = ktime_get();
+	time1 = get_cycles();
 
 	local_pnode = uv_blade_to_pnode(uv_numa_blade_id());
 
-	pqp = __get_cpu_var(bau_control).va_queue_first;
+	pqp = va_queue_first = __get_cpu_var(bau_control).va_queue_first;
+	va_queue_last = __get_cpu_var(bau_control).va_queue_last;
 	msg = __get_cpu_var(bau_control).bau_msg_head;
 	while (msg->sw_ack_vector) {
 		count++;
@@ -334,8 +388,8 @@ uv_bau_message_interrupt(struct pt_regs 
 		uv_bau_process_message(msg, msg_slot, sw_ack_slot);
 
 		msg++;
-		if (msg > __get_cpu_var(bau_control).va_queue_last)
-			msg = __get_cpu_var(bau_control).va_queue_first;
+		if (msg > va_queue_last)
+			msg = va_queue_first;
 		__get_cpu_var(bau_control).bau_msg_head = msg;
 	}
 	if (!count)
@@ -343,16 +397,14 @@ uv_bau_message_interrupt(struct pt_regs 
 	else if (count > 1)
 		__get_cpu_var(ptcstats).multmsg++;
 
-	time2 = ktime_get();
-	__get_cpu_var(ptcstats).dflush_ns += (time2.tv64 - time1.tv64);
+	time2 = get_cycles();
+	__get_cpu_var(ptcstats).dflush += (time2 - time1);
 
 	irq_exit();
 	set_irq_regs(old_regs);
-	return;
 }
 
-static void
-uv_enable_timeouts(void)
+static void uv_enable_timeouts(void)
 {
 	int i;
 	int blade;
@@ -361,7 +413,6 @@ uv_enable_timeouts(void)
 	int cur_cpu = 0;
 	unsigned long apicid;
 
-	/* better if we had each_online_blade */
 	last_blade = -1;
 	for_each_online_node(i) {
 		blade = uv_node_to_blade_id(i);
@@ -372,19 +423,16 @@ uv_enable_timeouts(void)
 		pnode = uv_blade_to_pnode(blade);
 		cur_cpu += uv_blade_nr_possible_cpus(i);
 	}
-	return;
 }
 
-static void *
-uv_ptc_seq_start(struct seq_file *file, loff_t *offset)
+static void *uv_ptc_seq_start(struct seq_file *file, loff_t *offset)
 {
 	if (*offset < num_possible_cpus())
 		return offset;
 	return NULL;
 }
 
-static void *
-uv_ptc_seq_next(struct seq_file *file, void *data, loff_t *offset)
+static void *uv_ptc_seq_next(struct seq_file *file, void *data, loff_t *offset)
 {
 	(*offset)++;
 	if (*offset < num_possible_cpus())
@@ -392,8 +440,7 @@ uv_ptc_seq_next(struct seq_file *file, v
 	return NULL;
 }
 
-static void
-uv_ptc_seq_stop(struct seq_file *file, void *data)
+static void uv_ptc_seq_stop(struct seq_file *file, void *data)
 {
 }
 
@@ -401,8 +448,7 @@ uv_ptc_seq_stop(struct seq_file *file, v
  * Display the statistics thru /proc
  * data points to the cpu number
  */
-static int
-uv_ptc_seq_show(struct seq_file *file, void *data)
+static int uv_ptc_seq_show(struct seq_file *file, void *data)
 {
 	struct ptc_stats *stat;
 	int cpu;
@@ -413,7 +459,7 @@ uv_ptc_seq_show(struct seq_file *file, v
 		seq_printf(file,
 		"# cpu requestor requestee one all sretry dretry ptc_i ");
 		seq_printf(file,
-		"sw_ack sflush_us dflush_us sok dnomsg dmult starget\n");
+		"sw_ack sflush dflush sok dnomsg dmult starget\n");
 	}
 	if (cpu < num_possible_cpus() && cpu_online(cpu)) {
 		stat = &per_cpu(ptcstats, cpu);
@@ -425,7 +471,7 @@ uv_ptc_seq_show(struct seq_file *file, v
 			   uv_read_global_mmr64(uv_blade_to_pnode
 					(uv_cpu_to_blade_id(cpu)),
 					UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE),
-			   stat->sflush_ns / 1000, stat->dflush_ns / 1000,
+			   stat->sflush, stat->dflush,
 			   stat->retriesok, stat->nomsg,
 			   stat->multmsg, stat->ntargeted);
 	}
@@ -437,8 +483,7 @@ uv_ptc_seq_show(struct seq_file *file, v
  *  0: display meaning of the statistics
  * >0: retry limit
  */
-static ssize_t
-uv_ptc_proc_write(struct file *file, const char __user *user,
+static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
 		  size_t count, loff_t *data)
 {
 	long newmode;
@@ -471,9 +516,9 @@ uv_ptc_proc_write(struct file *file, con
 		printk(KERN_DEBUG
 		"sw_ack:     image of UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE\n");
 		printk(KERN_DEBUG
-		"sflush_us:  microseconds spent in uv_flush_tlb_others()\n");
+		"sflush_us:  cycles spent in uv_flush_tlb_others()\n");
 		printk(KERN_DEBUG
-		"dflush_us:  microseconds spent in handling flush requests\n");
+		"dflush_us:  cycles spent in handling flush requests\n");
 		printk(KERN_DEBUG "sok:        successes on retry\n");
 		printk(KERN_DEBUG "dnomsg:     interrupts with no message\n");
 		printk(KERN_DEBUG
@@ -489,248 +534,240 @@ uv_ptc_proc_write(struct file *file, con
 }
 
 static const struct seq_operations uv_ptc_seq_ops = {
-	.start = uv_ptc_seq_start,
-	.next = uv_ptc_seq_next,
-	.stop = uv_ptc_seq_stop,
-	.show = uv_ptc_seq_show
+	.start		= uv_ptc_seq_start,
+	.next		= uv_ptc_seq_next,
+	.stop		= uv_ptc_seq_stop,
+	.show		= uv_ptc_seq_show
 };
 
-static int
-uv_ptc_proc_open(struct inode *inode, struct file *file)
+static int uv_ptc_proc_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &uv_ptc_seq_ops);
 }
 
 static const struct file_operations proc_uv_ptc_operations = {
-	.open = uv_ptc_proc_open,
-	.read = seq_read,
-	.write = uv_ptc_proc_write,
-	.llseek = seq_lseek,
-	.release = seq_release,
+	.open		= uv_ptc_proc_open,
+	.read		= seq_read,
+	.write		= uv_ptc_proc_write,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
 };
 
-static struct proc_dir_entry *proc_uv_ptc;
-
-static int __init
-uv_ptc_init(void)
+static int __init uv_ptc_init(void)
 {
-	static struct proc_dir_entry *sgi_proc_dir;
-
-	sgi_proc_dir = NULL;
+	struct proc_dir_entry *proc_uv_ptc;
 
 	if (!is_uv_system())
 		return 0;
 
-	sgi_proc_dir = proc_mkdir("sgi_uv", NULL);
-	if (!sgi_proc_dir)
+	if (!proc_mkdir("sgi_uv", NULL))
 		return -EINVAL;
 
 	proc_uv_ptc = create_proc_entry(UV_PTC_BASENAME, 0444, NULL);
 	if (!proc_uv_ptc) {
 		printk(KERN_ERR "unable to create %s proc entry\n",
 		       UV_PTC_BASENAME);
+		remove_proc_entry("sgi_uv", NULL);
 		return -EINVAL;
 	}
 	proc_uv_ptc->proc_fops = &proc_uv_ptc_operations;
 	return 0;
 }
 
-static void __exit
-uv_ptc_exit(void)
+/*
+ * begin the initialization of the per-blade control structures
+ */
+static struct bau_control * __init uv_table_bases_init(int blade, int node)
 {
-	remove_proc_entry(UV_PTC_BASENAME, NULL);
+	int i;
+	int *ip;
+	struct bau_msg_status *msp;
+	struct bau_control *bau_tabp;
+
+	bau_tabp =
+	    kmalloc_node(sizeof(struct bau_control), GFP_KERNEL, node);
+	BUG_ON(!bau_tabp);
+	bau_tabp->msg_statuses =
+	    kmalloc_node(sizeof(struct bau_msg_status) *
+			 DEST_Q_SIZE, GFP_KERNEL, node);
+	BUG_ON(!bau_tabp->msg_statuses);
+	for (i = 0, msp = bau_tabp->msg_statuses; i < DEST_Q_SIZE; i++, msp++)
+		bau_cpubits_clear(&msp->seen_by, (int)
+				  uv_blade_nr_possible_cpus(blade));
+	bau_tabp->watching =
+	    kmalloc_node(sizeof(int) * DEST_NUM_RESOURCES, GFP_KERNEL, node);
+	BUG_ON(!bau_tabp->watching);
+	for (i = 0, ip = bau_tabp->watching; i < DEST_Q_SIZE; i++, ip++) {
+		*ip = 0;
+	}
+	uv_bau_table_bases[blade] = bau_tabp;
+	return bau_tabsp;
 }
 
-module_init(uv_ptc_init);
-module_exit(uv_ptc_exit);
+/*
+ * finish the initialization of the per-blade control structures
+ */
+static void __init uv_table_bases_finish(int blade, int node, int cur_cpu,
+				  struct bau_control *bau_tablesp,
+				  struct bau_desc *adp)
+{
+	int i;
+	struct bau_control *bcp;
+
+	for (i = cur_cpu; i < (cur_cpu + uv_blade_nr_possible_cpus(blade));
+	     i++) {
+		bcp = (struct bau_control *)&per_cpu(bau_control, i);
+		bcp->bau_msg_head = bau_tablesp->va_queue_first;
+		bcp->va_queue_first = bau_tablesp->va_queue_first;
+		bcp->va_queue_last = bau_tablesp->va_queue_last;
+		bcp->watching = bau_tablesp->watching;
+		bcp->msg_statuses = bau_tablesp->msg_statuses;
+		bcp->descriptor_base = adp;
+	}
+}
 
 /*
- * Initialization of BAU-related structures
+ * initialize the sending side's sending buffers
  */
-int __init
-uv_bau_init(void)
+static struct bau_desc * __init
+uv_activation_descriptor_init(int node, int pnode)
 {
 	int i;
-	int j;
-	int blade;
-	int nblades;
-	int *ip;
-	int pnode;
-	int last_blade;
-	int cur_cpu = 0;
 	unsigned long pa;
-	unsigned long n;
 	unsigned long m;
+	unsigned long n;
 	unsigned long mmr_image;
-	unsigned long apicid;
+	struct bau_desc *adp;
+	struct bau_desc *ad2;
+
+	adp = (struct bau_desc *)
+	    kmalloc_node(16384, GFP_KERNEL, node);
+	BUG_ON(!adp);
+	pa = __pa((unsigned long)adp);
+	n = pa >> uv_nshift;
+	m = pa & uv_mmask;
+	mmr_image = uv_read_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE);
+	if (mmr_image)
+		uv_write_global_mmr64(pnode, (unsigned long)
+				      UVH_LB_BAU_SB_DESCRIPTOR_BASE,
+				      (n << UV_DESC_BASE_PNODE_SHIFT | m));
+	for (i = 0, ad2 = adp; i < UV_ACTIVATION_DESCRIPTOR_SIZE; i++, ad2++) {
+		memset(ad2, 0, sizeof(struct bau_desc));
+		ad2->header.sw_ack_flag = 1;
+		ad2->header.base_dest_nodeid =
+		    uv_blade_to_pnode(uv_cpu_to_blade_id(0));
+		ad2->header.command = UV_NET_ENDPOINT_INTD;
+		ad2->header.int_both = 1;
+		/*
+		 * all others need to be set to zero:
+		 *   fairness chaining multilevel count replied_to
+		 */
+	}
+	return adp;
+}
+
+/*
+ * initialize the destination side's receiving buffers
+ */
+static struct bau_payload_queue_entry * __init uv_payload_queue_init(int node,
+				int pnode, struct bau_control *bau_tablesp)
+{
 	char *cp;
-	struct bau_control *bau_tablesp;
-	struct bau_activation_descriptor *adp, *ad2;
 	struct bau_payload_queue_entry *pqp;
-	struct bau_msg_status *msp;
-	struct bau_control *bcp;
 
-	if (!is_uv_system())
-		return 0;
+	pqp = (struct bau_payload_queue_entry *) kmalloc_node(
+		(DEST_Q_SIZE + 1) * sizeof(struct bau_payload_queue_entry),
+		GFP_KERNEL, node);
+	BUG_ON(!pqp);
+	cp = (char *)pqp + 31;
+	pqp = (struct bau_payload_queue_entry *)(((unsigned long)cp >> 5) << 5);
+	bau_tablesp->va_queue_first = pqp;
+	uv_write_global_mmr64(pnode,
+			      UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST,
+			      ((unsigned long)pnode <<
+			       UV_PAYLOADQ_PNODE_SHIFT) |
+			      uv_physnodeaddr(pqp));
+	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL,
+			      uv_physnodeaddr(pqp));
+	bau_tablesp->va_queue_last = pqp + (DEST_Q_SIZE - 1);
+	uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST,
+			      (unsigned long)
+			      uv_physnodeaddr(bau_tablesp->va_queue_last));
+	memset(pqp, 0, sizeof(struct bau_payload_queue_entry) * DEST_Q_SIZE);
+	return pqp;
+}
 
-	uv_bau_retry_limit = 1;
+/*
+ * Initialization of each UV blade's structures
+ */
+static int __init uv_init_blade(int blade, int node, int cur_cpu)
+{
+	int pnode;
+	unsigned long pa;
+	unsigned long apicid;
+	struct bau_desc *adp;
+	struct bau_payload_queue_entry *pqp;
+	struct bau_control *bau_tablesp;
 
-	if ((sizeof(struct bau_local_cpumask) * BITSPERBYTE) <
-	    MAX_CPUS_PER_NODE) {
-		printk(KERN_ERR
-			"uv_bau_init: bau_local_cpumask.bits too small\n");
-		BUG();
+	bau_tablesp = uv_table_bases_init(blade, node);
+	pnode = uv_blade_to_pnode(blade);
+	adp = uv_activation_descriptor_init(node, pnode);
+	pqp = uv_payload_queue_init(node, pnode, bau_tablesp);
+	uv_table_bases_finish(blade, node, cur_cpu, bau_tablesp, adp);
+	/*
+	 * the below initialization can't be in firmware because the
+	 * messaging IRQ will be determined by the OS
+	 */
+	apicid = per_cpu(x86_cpu_to_apicid, cur_cpu);
+	pa = uv_read_global_mmr64(pnode, UVH_BAU_DATA_CONFIG);
+	if ((pa & 0xff) != UV_BAU_MESSAGE) {
+		uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
+				      ((apicid << 32) | UV_BAU_MESSAGE));
 	}
+	return 0;
+}
+
+/*
+ * Initialization of BAU-related structures
+ */
+static int __init uv_bau_init(void)
+{
+	int blade;
+	int node;
+	int nblades;
+	int last_blade;
+	int cur_cpu = 0;
 
+	if (!is_uv_system())
+		return 0;
+
+	uv_bau_retry_limit = 1;
 	uv_nshift = uv_hub_info->n_val;
-	uv_mmask = ((unsigned long)1 << uv_hub_info->n_val) - 1;
+	uv_mmask = (1UL << uv_hub_info->n_val) - 1;
 	nblades = 0;
 	last_blade = -1;
-	for_each_online_node(i) {
-		blade = uv_node_to_blade_id(i);
+	for_each_online_node(node) {
+		blade = uv_node_to_blade_id(node);
 		if (blade == last_blade)
 			continue;
 		last_blade = blade;
 		nblades++;
 	}
-
 	uv_bau_table_bases = (struct bau_control **)
 	    kmalloc(nblades * sizeof(struct bau_control *), GFP_KERNEL);
-	if (!uv_bau_table_bases)
-		BUG();
-
-	/* better if we had each_online_blade */
+	BUG_ON(!uv_bau_table_bases);
 	last_blade = -1;
-	for_each_online_node(i) {
-		blade = uv_node_to_blade_id(i);
+	for_each_online_node(node) {
+		blade = uv_node_to_blade_id(node);
 		if (blade == last_blade)
 			continue;
 		last_blade = blade;
-
-		bau_tablesp =
-		    kmalloc_node(sizeof(struct bau_control), GFP_KERNEL, i);
-		if (!bau_tablesp)
-			BUG();
-
-		bau_tablesp->msg_statuses =
-		    kmalloc_node(sizeof(struct bau_msg_status) *
-				 DESTINATION_PAYLOAD_QUEUE_SIZE, GFP_KERNEL, i);
-		if (!bau_tablesp->msg_statuses)
-			BUG();
-		for (j = 0, msp = bau_tablesp->msg_statuses;
-		     j < DESTINATION_PAYLOAD_QUEUE_SIZE; j++, msp++) {
-			bau_cpubits_clear(&msp->seen_by, (int)
-					  uv_blade_nr_possible_cpus(blade));
-		}
-
-		bau_tablesp->watching =
-		    kmalloc_node(sizeof(int) * DESTINATION_NUM_RESOURCES,
-				 GFP_KERNEL, i);
-		if (!bau_tablesp->watching)
-			BUG();
-		for (j = 0, ip = bau_tablesp->watching;
-		     j < DESTINATION_PAYLOAD_QUEUE_SIZE; j++, ip++) {
-			*ip = 0;
-		}
-
-		uv_bau_table_bases[i] = bau_tablesp;
-
-		pnode = uv_blade_to_pnode(blade);
-
-		if (sizeof(struct bau_activation_descriptor) != 64)
-			BUG();
-
-		adp = (struct bau_activation_descriptor *)
-		    kmalloc_node(16384, GFP_KERNEL, i);
-		if (!adp)
-			BUG();
-		if ((unsigned long)adp & 0xfff)
-			BUG();
-		pa = __pa((unsigned long)adp);
-		n = pa >> uv_nshift;
-		m = pa & uv_mmask;
-
-		mmr_image = uv_read_global_mmr64(pnode,
-						 UVH_LB_BAU_SB_DESCRIPTOR_BASE);
-		if (mmr_image)
-			uv_write_global_mmr64(pnode, (unsigned long)
-					      UVH_LB_BAU_SB_DESCRIPTOR_BASE,
-					      (n << UV_DESC_BASE_PNODE_SHIFT |
-					       m));
-		for (j = 0, ad2 = adp; j < UV_ACTIVATION_DESCRIPTOR_SIZE;
-		     j++, ad2++) {
-			memset(ad2, 0,
-			       sizeof(struct bau_activation_descriptor));
-			ad2->header.sw_ack_flag = 1;
-			ad2->header.base_dest_nodeid =
-			    uv_blade_to_pnode(uv_cpu_to_blade_id(0));
-			ad2->header.command = UV_NET_ENDPOINT_INTD;
-			ad2->header.int_both = 1;
-			/* all others need to be set to zero:
-			   fairness chaining multilevel count replied_to */
-		}
-
-		pqp = (struct bau_payload_queue_entry *)
-		    kmalloc_node((DESTINATION_PAYLOAD_QUEUE_SIZE + 1) *
-				 sizeof(struct bau_payload_queue_entry),
-				 GFP_KERNEL, i);
-		if (!pqp)
-			BUG();
-		if (sizeof(struct bau_payload_queue_entry) != 32)
-			BUG();
-		if ((unsigned long)(&((struct bau_payload_queue_entry *)0)->
-				    sw_ack_vector) != 15)
-			BUG();
-
-		cp = (char *)pqp + 31;
-		pqp = (struct bau_payload_queue_entry *)
-		    (((unsigned long)cp >> 5) << 5);
-		bau_tablesp->va_queue_first = pqp;
-		uv_write_global_mmr64(pnode,
-				      UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST,
-				      ((unsigned long)pnode <<
-				       UV_PAYLOADQ_PNODE_SHIFT) |
-				      uv_physnodeaddr(pqp));
-		uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL,
-				      uv_physnodeaddr(pqp));
-		bau_tablesp->va_queue_last =
-		    pqp + (DESTINATION_PAYLOAD_QUEUE_SIZE - 1);
-		uv_write_global_mmr64(pnode, UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST,
-				      (unsigned long)
-				      uv_physnodeaddr(bau_tablesp->
-						      va_queue_last));
-		memset(pqp, 0, sizeof(struct bau_payload_queue_entry) *
-		       DESTINATION_PAYLOAD_QUEUE_SIZE);
-
-		/* this initialization can't be in firmware because the
-		   messaging IRQ will be determined by the OS */
-		apicid = per_cpu(x86_cpu_to_apicid, cur_cpu);
-		pa = uv_read_global_mmr64(pnode, UVH_BAU_DATA_CONFIG);
-		if ((pa & 0xff) != UV_BAU_MESSAGE) {
-			uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
-					      ((apicid << 32) |
-					       UV_BAU_MESSAGE));
-		}
-
-		for (j = cur_cpu; j < (cur_cpu + uv_blade_nr_possible_cpus(i));
-		     j++) {
-			bcp = (struct bau_control *)&per_cpu(bau_control, j);
-			bcp->bau_msg_head = bau_tablesp->va_queue_first;
-			bcp->va_queue_first = bau_tablesp->va_queue_first;
-
-			bcp->va_queue_last = bau_tablesp->va_queue_last;
-			bcp->watching = bau_tablesp->watching;
-			bcp->msg_statuses = bau_tablesp->msg_statuses;
-			bcp->descriptor_base = adp;
-		}
-		cur_cpu += uv_blade_nr_possible_cpus(i);
+		uv_init_blade(blade, node, cur_cpu);
+		cur_cpu += uv_blade_nr_possible_cpus(blade);
 	}
-
 	set_intr_gate(UV_BAU_MESSAGE, uv_bau_message_intr1);
-
 	uv_enable_timeouts();
-
 	return 0;
 }
-
 __initcall(uv_bau_init);
+__initcall(uv_ptc_init);
Index: linux/include/asm-x86/uv/uv_bau.h
===================================================================
--- linux.orig/include/asm-x86/uv/uv_bau.h
+++ linux/include/asm-x86/uv/uv_bau.h
@@ -14,9 +14,9 @@
 #include <linux/bitmap.h>
 #define BITSPERBYTE 8
 
-/* Broadcast Assist Unit messaging structures */
-
 /*
+ * Broadcast Assist Unit messaging structures
+ *
  * Selective Broadcast activations are induced by software action
  * specifying a particular 8-descriptor "set" via a 6-bit index written
  * to an MMR.
@@ -33,54 +33,73 @@
  * Each of the descriptors is 64 bytes in size (8*64 = 512 bytes in a set).
  */
 
-#define UV_ITEMS_PER_DESCRIPTOR 8
-#define UV_CPUS_PER_ACT_STATUS 32
-#define UV_ACT_STATUS_MASK 0x3
-#define UV_ACT_STATUS_SIZE 2
-#define UV_ACTIVATION_DESCRIPTOR_SIZE 32
-#define UV_DISTRIBUTION_SIZE 256
-#define UV_SW_ACK_NPENDING 8
-#define UV_BAU_MESSAGE 200	/* Messaging irq; see irq_64.h */
-				/* and include/asm-x86/hw_irq_64.h */
-				/* To be dynamically allocated in the future */
-#define UV_NET_ENDPOINT_INTD 0x38
-#define UV_DESC_BASE_PNODE_SHIFT 49 /* position of pnode (nasid>>1) in MMR */
-#define UV_PAYLOADQ_PNODE_SHIFT 49
-
-#define UV_PTC_BASENAME "sgi_uv/ptc_statistics"
-#define uv_physnodeaddr(x) ((__pa((unsigned long)(x)) & uv_mmask))
-
-/* bits in UVH_LB_BAU_SB_ACTIVATION_STATUS_0/1 */
-#define DESC_STATUS_IDLE                0
-#define DESC_STATUS_ACTIVE              1
-#define DESC_STATUS_DESTINATION_TIMEOUT 2
-#define DESC_STATUS_SOURCE_TIMEOUT      3
-
-/* source side threshholds at which message retries print a warning */
-#define SOURCE_TIMEOUT_LIMIT            20
-#define DESTINATION_TIMEOUT_LIMIT       20
-
-/* number of entries in the destination side payload queue */
-#define DESTINATION_PAYLOAD_QUEUE_SIZE  17
-/* number of destination side software ack resources */
-#define DESTINATION_NUM_RESOURCES       8
+#define UV_ITEMS_PER_DESCRIPTOR		8
+#define UV_CPUS_PER_ACT_STATUS		32
+#define UV_ACT_STATUS_MASK		0x3
+#define UV_ACT_STATUS_SIZE		2
+#define UV_ACTIVATION_DESCRIPTOR_SIZE	32
+#define UV_DISTRIBUTION_SIZE		256
+#define UV_SW_ACK_NPENDING		8
+#define UV_BAU_MESSAGE			200
+/*
+ * Messaging irq; see irq_64.h and include/asm-x86/hw_irq_64.h
+ * To be dynamically allocated in the future
+ */
+#define UV_NET_ENDPOINT_INTD		0x38
+#define UV_DESC_BASE_PNODE_SHIFT	49
+#define UV_PAYLOADQ_PNODE_SHIFT		49
+#define UV_PTC_BASENAME			"sgi_uv/ptc_statistics"
+#define uv_physnodeaddr(x)		((__pa((unsigned long)(x)) & uv_mmask))
+
+/*
+ * bits in UVH_LB_BAU_SB_ACTIVATION_STATUS_0/1
+ */
+#define DESC_STATUS_IDLE		0
+#define DESC_STATUS_ACTIVE		1
+#define DESC_STATUS_DESTINATION_TIMEOUT	2
+#define DESC_STATUS_SOURCE_TIMEOUT	3
+
+/*
+ * source side threshholds at which message retries print a warning
+ */
+#define SOURCE_TIMEOUT_LIMIT		20
+#define DESTINATION_TIMEOUT_LIMIT	20
+
+/*
+ * number of entries in the destination side payload queue
+ */
+#define DEST_Q_SIZE			17
+/*
+ * number of destination side software ack resources
+ */
+#define DEST_NUM_RESOURCES		8
 #define MAX_CPUS_PER_NODE		32
+/*
+ * completion statuses for sending a TLB flush message
+ */
+#define	FLUSH_RETRY			1
+#define	FLUSH_GIVEUP			2
+#define	FLUSH_COMPLETE			3
 
-/* Distribution: 32 bytes (256 bits) (bytes 0-0x1f of descriptor) */
-/* If the 'multilevel' flag in the header portion of the descriptor
+/*
+ * Distribution: 32 bytes (256 bits) (bytes 0-0x1f of descriptor)
+ * If the 'multilevel' flag in the header portion of the descriptor
  * has been set to 0, then endpoint multi-unicast mode is selected.
  * The distribution specification (32 bytes) is interpreted as a 256-bit
  * distribution vector. Adjacent bits correspond to consecutive even numbered
  * nodeIDs. The result of adding the index of a given bit to the 15-bit
  * 'base_dest_nodeid' field of the header corresponds to the
- * destination nodeID associated with that specified bit.  */
+ * destination nodeID associated with that specified bit.
+ */
 struct bau_target_nodemask {
 	unsigned long bits[BITS_TO_LONGS(256)];
 };
 
-/* mask of cpu's on a node */
-/* (during initialization we need to check that unsigned long has
-    enough bits for max. cpu's per node) */
+/*
+ * mask of cpu's on a node
+ * (during initialization we need to check that unsigned long has
+ *  enough bits for max. cpu's per node)
+ */
 struct bau_local_cpumask {
 	unsigned long bits;
 };
@@ -99,7 +118,9 @@ struct bau_local_cpumask {
  *   the s/w ack bit vector  ]
  */
 
-/* The payload is software-defined for INTD transactions */
+/*
+ * The payload is software-defined for INTD transactions
+ */
 struct bau_msg_payload {
 	unsigned long address;		/* signifies a page or all TLB's
 						of the cpu */
@@ -112,8 +133,10 @@ struct bau_msg_payload {
 };
 
 
-/* Message header:  16 bytes (128 bits) (bytes 0x30-0x3f of descriptor) */
-/* see table 4.2.3.0.1 in broacast_assist spec. */
+/*
+ * Message header:  16 bytes (128 bits) (bytes 0x30-0x3f of descriptor)
+ * see table 4.2.3.0.1 in broacast_assist spec.
+ */
 struct bau_msg_header {
 	int dest_subnodeid:6;	/* must be zero */
 	/* bits 5:0 */
@@ -173,11 +196,16 @@ struct bau_msg_header {
 	/* bits 127:107 */
 };
 
-/* The format of the message to send, plus all accompanying control */
-/* Should be 64 bytes */
-struct bau_activation_descriptor {
+/*
+ * The activation descriptor:
+ * The format of the message to send, plus all accompanying control
+ * Should be 64 bytes
+ */
+struct bau_desc {
 	struct bau_target_nodemask distribution;
-	/* message template, consisting of header and payload: */
+	/*
+	 * message template, consisting of header and payload:
+	 */
 	struct bau_msg_header header;
 	struct bau_msg_payload payload;
 };
@@ -235,20 +263,26 @@ struct bau_payload_queue_entry {
 	/* bytes 24-31 */
 };
 
-/* one for every slot in the destination payload queue */
+/*
+ * one for every slot in the destination payload queue
+ */
 struct bau_msg_status {
 	struct bau_local_cpumask seen_by;	/* map of cpu's */
 };
 
-/* one for every slot in the destination software ack resources */
+/*
+ * one for every slot in the destination software ack resources
+ */
 struct bau_sw_ack_status {
 	struct bau_payload_queue_entry *msg;	/* associated message */
 	int watcher;				/* cpu monitoring, or -1 */
 };
 
-/* one on every node and per-cpu; to locate the software tables */
+/*
+ * one on every node and per-cpu; to locate the software tables
+ */
 struct bau_control {
-	struct bau_activation_descriptor *descriptor_base;
+	struct bau_desc *descriptor_base;
 	struct bau_payload_queue_entry *bau_msg_head;
 	struct bau_payload_queue_entry *va_queue_first;
 	struct bau_payload_queue_entry *va_queue_last;
@@ -267,8 +301,8 @@ struct ptc_stats {
 	unsigned long onetlb;	/* times just one tlb on this cpu was flushed */
 	unsigned long s_retry;	/* retries on source side timeouts */
 	unsigned long d_retry;	/* retries on destination side timeouts */
-	unsigned long sflush_ns;/* nanoseconds spent in uv_flush_tlb_others */
-	unsigned long dflush_ns;/* nanoseconds spent destination side */
+	unsigned long sflush;	/* cycles spent in uv_flush_tlb_others */
+	unsigned long dflush;	/* cycles spent on destination side */
 	unsigned long retriesok; /* successes on retries */
 	unsigned long nomsg;	/* interrupts with no message */
 	unsigned long multmsg;	/* interrupts with multiple messages */
@@ -293,39 +327,11 @@ static inline void bau_cpubits_clear(str
 	bitmap_zero(&dstp->bits, nbits);
 }
 
-/*
- * atomic increment of a short integer
- * (rather than using the __sync_add_and_fetch() intrinsic)
- *
- * returns the new value of the variable
- */
-static inline short int atomic_inc_short(short int *v)
-{
-	asm volatile("movw $1, %%cx\n"
-			"lock ; xaddw %%cx, %0\n"
-			: "+m" (*v)		/* outputs */
-			: : "%cx", "memory");	/* inputs : clobbereds */
-	return *v;
-}
-
-/*
- * atomic OR of two long integers
- * (rather than using the __sync_or_and_fetch() intrinsic)
- */
-static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
-{
-	asm volatile("movq %0, %%rax; lea %1, %%rdx\n"
-			"lock ; orq %%rax, %%rdx\n"
-			: "+m" (*v1)		/* outputs */
-			: "m" (v1), "m" (v2)	/* inputs */
-			: "memory");		/* clobbereds */
-}
-
 #define cpubit_isset(cpu, bau_local_cpumask) \
 	test_bit((cpu), (bau_local_cpumask).bits)
 
-int uv_flush_tlb_others(cpumask_t *, struct mm_struct *, unsigned long);
-void uv_bau_message_intr1(void);
-void uv_bau_timeout_intr1(void);
+extern int uv_flush_tlb_others(cpumask_t *, struct mm_struct *, unsigned long);
+extern void uv_bau_message_intr1(void);
+extern void uv_bau_timeout_intr1(void);
 
 #endif /* __ASM_X86_UV_BAU__ */
