Return-Path: <linux-kernel-owner+w=401wt.eu-S935483AbZDCQ2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935483AbZDCQ2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935724AbZDCQ2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:28:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:55008 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934352AbZDCQ2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:28:33 -0400
Date: Fri, 3 Apr 2009 16:27:56 GMT
From: Cliff Wickman <cpw@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1LpjXU-00007e-Qh@eag09.americas.sgi.com>
References: <E1LpjXU-00007e-Qh@eag09.americas.sgi.com>
Subject: [tip:x86/uv] x86: UV BAU messaging timeouts
Message-ID: <tip-c4c4688f72e638708e5f6b5c259699de82a36fec@git.kernel.org>
Git-Commit-ID: c4c4688f72e638708e5f6b5c259699de82a36fec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 16:27:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4c4688f72e638708e5f6b5c259699de82a36fec
Gitweb:     http://git.kernel.org/tip/c4c4688f72e638708e5f6b5c259699de82a36fec
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Fri, 3 Apr 2009 08:34:32 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 18:25:27 +0200

x86: UV BAU messaging timeouts

This patch replaces a 'nop' uv_enable_timeouts() in the
UV TLB shootdown code. (somehow, long ago that function got
eviscerated)

If any cpu in the destination node does not get interrupted by the
message and post completion in a reasonable time the hardware
should respond to the sender with an error.  This function
enables such timeouts.

Tested on the UV hardware simulator.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
LKML-Reference: <E1LpjXU-00007e-Qh@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/uv/uv_mmrs.h |    5 +++
 arch/x86/kernel/tlb_uv.c          |   56 +++++++++++++++++++++++++++++-------
 2 files changed, 50 insertions(+), 11 deletions(-)

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
 
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index b833bc6..fced96e 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -445,24 +445,58 @@ void uv_bau_message_interrupt(struct pt_regs *regs)
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
 
