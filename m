Return-Path: <linux-kernel-owner+w=401wt.eu-S1751029AbXA2Trh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029AbXA2Trh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXA2Trg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:47:36 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35880 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbXA2Trf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:47:35 -0500
Message-ID: <45BE4F55.8070801@us.ibm.com>
Date: Mon, 29 Jan 2007 13:47:33 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
Reply-To: maynardj@us.ibm.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net
Subject: [RFC, PATCH 2/4] Add support to OProfile for profiling Cell BE SPUs
  -- update
References: <45BE4ED0.5030808@us.ibm.com>
In-Reply-To: <45BE4ED0.5030808@us.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------050902020003010107060807"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050902020003010107060807
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------050902020003010107060807
Content-Type: text/x-patch;
 name="oprof-ppu-fix2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oprof-ppu-fix2.diff"

The code was setting up the debug bus for group 21 when profiling on the 
event PPU CYCLES.  The debug bus is not actually used by the hardware 
performance counters when counting PPU CYCLES.  Setting up the debug bus
for PPU CYCLES causes signal routing conflicts on the debug bus when 
profiling PPU cycles and another PPU event.  This patch fixes the code to 
only setup the debug bus to route the performance signals for the non
PPU CYCLE events.

Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>
Signed-off-by: Carl Love <carll@us.ibm.com>

Index: linux-2.6.20-rc1/arch/powerpc/oprofile/op_model_cell.c
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/oprofile/op_model_cell.c	2007-01-18 16:56:47.300605984 -0600
+++ linux-2.6.20-rc1/arch/powerpc/oprofile/op_model_cell.c	2007-01-24 12:16:16.225609136 -0600
@@ -39,6 +39,9 @@
 #include "../platforms/cell/interrupt.h"
 
 #define PPU_CYCLES_EVENT_NUM 1	/*  event number for CYCLES */
+#define PPU_CYCLES_GRP_NUM   1  /* special group number for identifying
+                                 * PPU_CYCLES event
+                                 */
 #define CBE_COUNT_ALL_CYCLES 0x42800000	/* PPU cycle event specifier */
 
 #define NUM_THREADS 2         /* number of physical threads in 
@@ -62,7 +65,7 @@
 struct pm_signal {
 	u16 cpu;		/* Processor to modify */
 	u16 sub_unit;		/* hw subunit this applies to (if applicable) */
-	u16 signal_group;	/* Signal Group to Enable/Disable */
+	short int signal_group;	/* Signal Group to Enable/Disable */
 	u8 bus_word;		/* Enable/Disable on this Trace/Trigger/Event
 				 * Bus Word(s) (bitmask)
 				 */
@@ -173,26 +176,40 @@
 static void pm_rtas_activate_signals(u32 node, u32 count)
 {
 	int ret;
-	int j;
+	int i, j;
 	struct pm_signal pm_signal_local[NR_PHYS_CTRS];
 
+	/* There is no debug setup required for the cycles event.
+	 * Note that only events in the same group can be used.
+	 * Otherwise, there will be conflicts in correctly routing
+	 * the signals on the debug bus.  It is the responsiblity
+	 * of the OProfile user tool to check the events are in
+	 * the same group.
+	 */
+	i = 0;
 	for (j = 0; j < count; j++) {
-		/* fw expects physical cpu # */
-		pm_signal_local[j].cpu = node;
-		pm_signal_local[j].signal_group 
-			= pm_signal[j].signal_group;
-		pm_signal_local[j].bus_word = pm_signal[j].bus_word;
-		pm_signal_local[j].sub_unit = pm_signal[j].sub_unit;
-		pm_signal_local[j].bit = pm_signal[j].bit;
-	}
+		if (pm_signal[j].signal_group != PPU_CYCLES_GRP_NUM) {
 
-	ret = rtas_ibm_cbe_perftools(SUBFUNC_ACTIVATE, PASSTHRU_ENABLE,
-				     pm_signal_local,
-				     count * sizeof(struct pm_signal));
+			/* fw expects physical cpu # */
+			pm_signal_local[i].cpu = node;
+			pm_signal_local[i].signal_group 
+				= pm_signal[j].signal_group;
+			pm_signal_local[i].bus_word = pm_signal[j].bus_word;
+			pm_signal_local[i].sub_unit = pm_signal[j].sub_unit;
+			pm_signal_local[i].bit = pm_signal[j].bit;
+			i++;
+		}
+	}
 
-	if (ret)
-		printk(KERN_WARNING "%s: rtas returned: %d\n",
-		       __FUNCTION__, ret);
+	if (i != 0) {
+		ret = rtas_ibm_cbe_perftools(SUBFUNC_ACTIVATE, PASSTHRU_ENABLE,
+					     pm_signal_local,
+					     i * sizeof(struct pm_signal));
+
+		if (ret)
+			printk(KERN_WARNING "%s: rtas returned: %d\n",
+			       __FUNCTION__, ret);
+	}
 }
 
 /*
@@ -209,7 +226,7 @@
 		/* Special Event: Count all cpu cycles */
 		pm_regs.pm07_cntrl[ctr] = CBE_COUNT_ALL_CYCLES;
 		p = &(pm_signal[ctr]);
-		p->signal_group = 21;
+		p->signal_group = PPU_CYCLES_GRP_NUM;
 		p->bus_word = 1;
 		p->sub_unit = 0;
 		p->bit = 0;

--------------050902020003010107060807--

