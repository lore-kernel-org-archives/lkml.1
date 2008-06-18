Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYFRM3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYFRM3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYFRM3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:29:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56958 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbYFRM3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:29:44 -0400
Date: Wed, 18 Jun 2008 14:29:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] SGI UV: TLB shootdown using broadcast assist unit
Message-ID: <20080618122931.GB12763@elte.hu>
References: <E1K6t40-0000UB-GC@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K6t40-0000UB-GC@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> TLB shootdown for SGI UV. 
> 
> This patch brings v1 up to v5.

applied to tip/x86/uv, thanks Cliff.

Note that i've done a few minor cleanups as well in that branch (see the 
patch below). The code could still be improved.

Found a potential security hole while doing that:

static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
                                 size_t count, loff_t *data)
{
        long newmode;
        char optstr[64];

        if (copy_from_user(optstr, user, count))
                return -EFAULT;

is count guaranteed to never be larger than 64?

	Ingo

---------------->
commit b007179c763655806671ac173ae5dbe1d4fa70ae
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jun 18 14:28:19 2008 +0200

    SGI UV: clean up arch/x86/kernel/tlb_uv.c
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index d8705e9..7bdbf67 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -11,19 +11,22 @@
 #include <linux/kernel.h>
 
 #include <asm/mmu_context.h>
-#include <asm/idle.h>
-#include <asm/genapic.h>
-#include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_mmrs.h>
+#include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_bau.h>
+#include <asm/genapic.h>
+#include <asm/idle.h>
 #include <asm/tsc.h>
 
 #include <mach_apic.h>
 
-static struct bau_control **uv_bau_table_bases __read_mostly;
-static int uv_bau_retry_limit __read_mostly;
-static int uv_nshift __read_mostly; /* position of pnode (which is nasid>>1) */
-static unsigned long uv_mmask __read_mostly;
+static struct bau_control	**uv_bau_table_bases __read_mostly;
+static int			uv_bau_retry_limit __read_mostly;
+
+/* position of pnode (which is nasid>>1): */
+static int			uv_nshift __read_mostly;
+
+static unsigned long		uv_mmask __read_mostly;
 
 static DEFINE_PER_CPU(struct ptc_stats, ptcstats);
 static DEFINE_PER_CPU(struct bau_control, bau_control);
@@ -37,8 +40,8 @@ static DEFINE_PER_CPU(struct bau_control, bau_control);
  * be sent (the hardware will only do one reply per message).
  */
 static void uv_reply_to_message(int resource,
-		    struct bau_payload_queue_entry *msg,
-		    struct bau_msg_status *msp)
+				struct bau_payload_queue_entry *msg,
+				struct bau_msg_status *msp)
 {
 	unsigned long dw;
 
@@ -55,11 +58,11 @@ static void uv_reply_to_message(int resource,
  * Other cpu's may come here at the same time for this message.
  */
 static void uv_bau_process_message(struct bau_payload_queue_entry *msg,
-		       int msg_slot, int sw_ack_slot)
+				   int msg_slot, int sw_ack_slot)
 {
-	int cpu;
 	unsigned long this_cpu_mask;
 	struct bau_msg_status *msp;
+	int cpu;
 
 	msp = __get_cpu_var(bau_control).msg_statuses + msg_slot;
 	cpu = uv_blade_processor_id();
@@ -96,11 +99,11 @@ static void uv_bau_process_message(struct bau_payload_queue_entry *msg,
  */
 static int uv_examine_destination(struct bau_control *bau_tablesp, int sender)
 {
-	int i;
-	int j;
-	int count = 0;
 	struct bau_payload_queue_entry *msg;
 	struct bau_msg_status *msp;
+	int count = 0;
+	int i;
+	int j;
 
 	for (msg = bau_tablesp->va_queue_first, i = 0; i < DEST_Q_SIZE;
 	     msg++, i++) {
@@ -111,7 +114,7 @@ static int uv_examine_destination(struct bau_control *bau_tablesp, int sender)
 			       i, msg->address, msg->acknowledge_count,
 			       msg->number_of_cpus);
 			for (j = 0; j < msg->number_of_cpus; j++) {
-				if (!((long)1 << j & msp-> seen_by.bits)) {
+				if (!((1L << j) & msp->seen_by.bits)) {
 					count++;
 					printk("%d ", j);
 				}
@@ -135,8 +138,7 @@ static int uv_examine_destinations(struct bau_target_nodemask *distribution)
 	int count = 0;
 
 	sender = smp_processor_id();
-	for (i = 0; i < (sizeof(struct bau_target_nodemask) * BITSPERBYTE);
-	     i++) {
+	for (i = 0; i < sizeof(struct bau_target_nodemask) * BITSPERBYTE; i++) {
 		if (!bau_node_isset(i, distribution))
 			continue;
 		count += uv_examine_destination(uv_bau_table_bases[i], sender);
@@ -217,11 +219,11 @@ int uv_flush_send_and_wait(int cpu, int this_blade, struct bau_desc *bau_desc,
 {
 	int completion_status = 0;
 	int right_shift;
-	int bit;
-	int blade;
 	int tries = 0;
-	unsigned long index;
+	int blade;
+	int bit;
 	unsigned long mmr_offset;
+	unsigned long index;
 	cycles_t time1;
 	cycles_t time2;
 
@@ -294,7 +296,7 @@ int uv_flush_send_and_wait(int cpu, int this_blade, struct bau_desc *bau_desc,
  * Returns 0 if some remote flushing remains to be done.
  */
 int uv_flush_tlb_others(cpumask_t *cpumaskp, struct mm_struct *mm,
-	unsigned long va)
+			unsigned long va)
 {
 	int i;
 	int bit;
@@ -356,12 +358,12 @@ int uv_flush_tlb_others(cpumask_t *cpumaskp, struct mm_struct *mm,
  */
 void uv_bau_message_interrupt(struct pt_regs *regs)
 {
-	struct bau_payload_queue_entry *pqp;
-	struct bau_payload_queue_entry *msg;
 	struct bau_payload_queue_entry *va_queue_first;
 	struct bau_payload_queue_entry *va_queue_last;
+	struct bau_payload_queue_entry *msg;
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	cycles_t time1, time2;
+	cycles_t time1;
+	cycles_t time2;
 	int msg_slot;
 	int sw_ack_slot;
 	int fw;
@@ -376,13 +378,14 @@ void uv_bau_message_interrupt(struct pt_regs *regs)
 
 	local_pnode = uv_blade_to_pnode(uv_numa_blade_id());
 
-	pqp = va_queue_first = __get_cpu_var(bau_control).va_queue_first;
+	va_queue_first = __get_cpu_var(bau_control).va_queue_first;
 	va_queue_last = __get_cpu_var(bau_control).va_queue_last;
+
 	msg = __get_cpu_var(bau_control).bau_msg_head;
 	while (msg->sw_ack_vector) {
 		count++;
 		fw = msg->sw_ack_vector;
-		msg_slot = msg - pqp;
+		msg_slot = msg - va_queue_first;
 		sw_ack_slot = ffs(fw) - 1;
 
 		uv_bau_process_message(msg, msg_slot, sw_ack_slot);
@@ -484,7 +487,7 @@ static int uv_ptc_seq_show(struct seq_file *file, void *data)
  * >0: retry limit
  */
 static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
-		  size_t count, loff_t *data)
+				 size_t count, loff_t *data)
 {
 	long newmode;
 	char optstr[64];
@@ -587,42 +590,48 @@ static struct bau_control * __init uv_table_bases_init(int blade, int node)
 	bau_tabp =
 	    kmalloc_node(sizeof(struct bau_control), GFP_KERNEL, node);
 	BUG_ON(!bau_tabp);
+
 	bau_tabp->msg_statuses =
 	    kmalloc_node(sizeof(struct bau_msg_status) *
 			 DEST_Q_SIZE, GFP_KERNEL, node);
 	BUG_ON(!bau_tabp->msg_statuses);
+
 	for (i = 0, msp = bau_tabp->msg_statuses; i < DEST_Q_SIZE; i++, msp++)
 		bau_cpubits_clear(&msp->seen_by, (int)
 				  uv_blade_nr_possible_cpus(blade));
+
 	bau_tabp->watching =
 	    kmalloc_node(sizeof(int) * DEST_NUM_RESOURCES, GFP_KERNEL, node);
 	BUG_ON(!bau_tabp->watching);
-	for (i = 0, ip = bau_tabp->watching; i < DEST_Q_SIZE; i++, ip++) {
+
+	for (i = 0, ip = bau_tabp->watching; i < DEST_Q_SIZE; i++, ip++)
 		*ip = 0;
-	}
+
 	uv_bau_table_bases[blade] = bau_tabp;
+
 	return bau_tabsp;
 }
 
 /*
  * finish the initialization of the per-blade control structures
  */
-static void __init uv_table_bases_finish(int blade, int node, int cur_cpu,
-				  struct bau_control *bau_tablesp,
-				  struct bau_desc *adp)
+static void __init
+uv_table_bases_finish(int blade, int node, int cur_cpu,
+		      struct bau_control *bau_tablesp,
+		      struct bau_desc *adp)
 {
-	int i;
 	struct bau_control *bcp;
+	int i;
 
-	for (i = cur_cpu; i < (cur_cpu + uv_blade_nr_possible_cpus(blade));
-	     i++) {
+	for (i = cur_cpu; i < cur_cpu + uv_blade_nr_possible_cpus(blade); i++) {
 		bcp = (struct bau_control *)&per_cpu(bau_control, i);
-		bcp->bau_msg_head = bau_tablesp->va_queue_first;
-		bcp->va_queue_first = bau_tablesp->va_queue_first;
-		bcp->va_queue_last = bau_tablesp->va_queue_last;
-		bcp->watching = bau_tablesp->watching;
-		bcp->msg_statuses = bau_tablesp->msg_statuses;
-		bcp->descriptor_base = adp;
+
+		bcp->bau_msg_head	= bau_tablesp->va_queue_first;
+		bcp->va_queue_first	= bau_tablesp->va_queue_first;
+		bcp->va_queue_last	= bau_tablesp->va_queue_last;
+		bcp->watching		= bau_tablesp->watching;
+		bcp->msg_statuses	= bau_tablesp->msg_statuses;
+		bcp->descriptor_base	= adp;
 	}
 }
 
@@ -643,14 +652,18 @@ uv_activation_descriptor_init(int node, int pnode)
 	adp = (struct bau_desc *)
 	    kmalloc_node(16384, GFP_KERNEL, node);
 	BUG_ON(!adp);
+
 	pa = __pa((unsigned long)adp);
 	n = pa >> uv_nshift;
 	m = pa & uv_mmask;
+
 	mmr_image = uv_read_global_mmr64(pnode, UVH_LB_BAU_SB_DESCRIPTOR_BASE);
-	if (mmr_image)
+	if (mmr_image) {
 		uv_write_global_mmr64(pnode, (unsigned long)
 				      UVH_LB_BAU_SB_DESCRIPTOR_BASE,
 				      (n << UV_DESC_BASE_PNODE_SHIFT | m));
+	}
+
 	for (i = 0, ad2 = adp; i < UV_ACTIVATION_DESCRIPTOR_SIZE; i++, ad2++) {
 		memset(ad2, 0, sizeof(struct bau_desc));
 		ad2->header.sw_ack_flag = 1;
@@ -669,16 +682,17 @@ uv_activation_descriptor_init(int node, int pnode)
 /*
  * initialize the destination side's receiving buffers
  */
-static struct bau_payload_queue_entry * __init uv_payload_queue_init(int node,
-				int pnode, struct bau_control *bau_tablesp)
+static struct bau_payload_queue_entry * __init
+uv_payload_queue_init(int node, int pnode, struct bau_control *bau_tablesp)
 {
-	char *cp;
 	struct bau_payload_queue_entry *pqp;
+	char *cp;
 
 	pqp = (struct bau_payload_queue_entry *) kmalloc_node(
 		(DEST_Q_SIZE + 1) * sizeof(struct bau_payload_queue_entry),
 		GFP_KERNEL, node);
 	BUG_ON(!pqp);
+
 	cp = (char *)pqp + 31;
 	pqp = (struct bau_payload_queue_entry *)(((unsigned long)cp >> 5) << 5);
 	bau_tablesp->va_queue_first = pqp;
@@ -694,6 +708,7 @@ static struct bau_payload_queue_entry * __init uv_payload_queue_init(int node,
 			      (unsigned long)
 			      uv_physnodeaddr(bau_tablesp->va_queue_last));
 	memset(pqp, 0, sizeof(struct bau_payload_queue_entry) * DEST_Q_SIZE);
+
 	return pqp;
 }
 
@@ -756,6 +771,7 @@ static int __init uv_bau_init(void)
 	uv_bau_table_bases = (struct bau_control **)
 	    kmalloc(nblades * sizeof(struct bau_control *), GFP_KERNEL);
 	BUG_ON(!uv_bau_table_bases);
+
 	last_blade = -1;
 	for_each_online_node(node) {
 		blade = uv_node_to_blade_id(node);
@@ -767,6 +783,7 @@ static int __init uv_bau_init(void)
 	}
 	set_intr_gate(UV_BAU_MESSAGE, uv_bau_message_intr1);
 	uv_enable_timeouts();
+
 	return 0;
 }
 __initcall(uv_bau_init);
