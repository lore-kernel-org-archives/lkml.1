Return-Path: <linux-kernel-owner+w=401wt.eu-S1764880AbZDCNlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764880AbZDCNlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZDCNlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:41:35 -0400
Received: from relay3.sgi.com ([192.48.156.57]:57777 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754549AbZDCNle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:41:34 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Apr 2009 09:41:34 EDT
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV BAU messaging timeouts
Cc: mingo@elte.hu
Message-Id: <E1LpjXU-00007e-Qh@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Fri, 03 Apr 2009 08:34:32 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Cliff Wickman <cpw@sgi.com>

This patch replaces a 'nop' uv_enable_timeouts() in the
UV TLB shootdown code. (somehow, long ago that function got
eviscerated)

If any cpu in the destination node does not get interrupted by the
message and post completion in a reasonable time the hardware
should respond to the sender with an error.  This function
enables such timeouts.

Tested on the UV hardware simulator.

Diffed against 2.6.29

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_mmrs.h |    5 +++
 arch/x86/kernel/tlb_uv.c          |   56 ++++++++++++++++++++++++++++++--------
 2 files changed, 50 insertions(+), 11 deletions(-)

Index: linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/tlb_uv.c
+++ linux/arch/x86/kernel/tlb_uv.c
@@ -446,24 +446,58 @@ void uv_bau_message_interrupt(struct pt_
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
+
+	nblades = uv_num_possible_blades();
 
-	last_blade = -1;
-	for_each_online_node(i) {
-		blade = uv_node_to_blade_id(i);
-		if (blade == last_blade)
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
 
Index: linux/arch/x86/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h
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
 
