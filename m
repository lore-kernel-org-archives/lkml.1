Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbYHTRDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbYHTRDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759898AbYHTRCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:02:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbYHTRCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:02:08 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org
Cc: ak@linux.intel.com, len.brown@intel.com, arjan@linux.intel.com,
       bjorn.helgaas@hp.com, linux-acpi@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 2/3] Powernow-k8: Make use of firmware bug report interface
Date: Wed, 20 Aug 2008 19:02:05 +0200
Message-Id: <1219251726-24746-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219251726-24746-1-git-send-email-trenn@suse.de>
References: <1219251726-24746-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   45 ++++++++++++++++-------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 4e72719..f05025f 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/firmware_error.h>
 #include <linux/smp.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -45,7 +46,6 @@
 #endif
 
 #define PFX "powernow-k8: "
-#define BFX PFX "BIOS error: "
 #define VERSION "version 2.20.00"
 #include "powernow-k8.h"
 
@@ -536,35 +536,39 @@ static int check_pst_table(struct powernow_k8_data *data, struct pst_s *pst, u8
 
 	for (j = 0; j < data->numps; j++) {
 		if (pst[j].vid > LEAST_VID) {
-			printk(KERN_ERR PFX "vid %d invalid : 0x%x\n", j, pst[j].vid);
+			FW_PRINT_CRIT(FW_ERR, PFX "vid %d invalid : 0x%x", j, pst[j].vid);
 			return -EINVAL;
 		}
 		if (pst[j].vid < data->rvo) {	/* vid + rvo >= 0 */
-			printk(KERN_ERR BFX "0 vid exceeded with pstate %d\n", j);
+			FW_PRINT_CRIT(FW_ERR, PFX "0 vid exceeded with pstate"
+				      " %d", j);
 			return -ENODEV;
 		}
 		if (pst[j].vid < maxvid + data->rvo) {	/* vid + rvo >= maxvid */
-			printk(KERN_ERR BFX "maxvid exceeded with pstate %d\n", j);
+			FW_PRINT_CRIT(FW_ERR, PFX "maxvid exceeded with "
+				      "pstate %d", j);
 			return -ENODEV;
 		}
 		if (pst[j].fid > MAX_FID) {
-			printk(KERN_ERR BFX "maxfid exceeded with pstate %d\n", j);
+			FW_PRINT_CRIT(FW_ERR, PFX "maxfid exceeded with pstate "
+				      "%d", j);
 			return -ENODEV;
 		}
 		if (j && (pst[j].fid < HI_FID_TABLE_BOTTOM)) {
 			/* Only first fid is allowed to be in "low" range */
-			printk(KERN_ERR BFX "two low fids - %d : 0x%x\n", j, pst[j].fid);
+			FW_PRINT_CRIT(FW_ERR, PFX "two low fids - %d : 0x%x",
+				      j, pst[j].fid);
 			return -EINVAL;
 		}
 		if (pst[j].fid < lastfid)
 			lastfid = pst[j].fid;
 	}
 	if (lastfid & 1) {
-		printk(KERN_ERR BFX "lastfid invalid\n");
+		FW_PRINT_CRIT(FW_ERR, PFX "lastfid invalid");
 		return -EINVAL;
 	}
 	if (lastfid > LO_FID_TABLE_TOP)
-		printk(KERN_INFO BFX  "first fid not from lo freq table\n");
+		FW_PRINT_CRIT(FW_ERR, PFX  "first fid not from lo freq table");
 
 	return 0;
 }
@@ -672,13 +676,13 @@ static int find_psb_table(struct powernow_k8_data *data)
 
 		dprintk("table vers: 0x%x\n", psb->tableversion);
 		if (psb->tableversion != PSB_VERSION_1_4) {
-			printk(KERN_ERR BFX "PSB table is not v1.4\n");
+			FW_PRINT_CRIT(FW_ERR, PFX "PSB table is not v1.4");
 			return -ENODEV;
 		}
 
 		dprintk("flags: 0x%x\n", psb->flags1);
 		if (psb->flags1) {
-			printk(KERN_ERR BFX "unknown flags\n");
+			FW_PRINT_CRIT(FW_ERR, PFX "unknown flags");
 			return -ENODEV;
 		}
 
@@ -705,7 +709,7 @@ static int find_psb_table(struct powernow_k8_data *data)
 			}
 		}
 		if (cpst != 1) {
-			printk(KERN_ERR BFX "numpst must be 1\n");
+			FW_PRINT_CRIT(FW_ERR, PFX "numpst must be 1");
 			return -ENODEV;
 		}
 
@@ -730,7 +734,7 @@ static int find_psb_table(struct powernow_k8_data *data)
 	 * BIOS and Kernel Developer's Guide, which is available on
 	 * www.amd.com
 	 */
-	printk(KERN_ERR PFX "BIOS error - no PSB or ACPI _PSS objects\n");
+	FW_PRINT_CRIT(FW_ERR, PFX "BIOS error - no PSB or ACPI _PSS objects");
 	return -ENODEV;
 }
 
@@ -860,8 +864,7 @@ static int fill_powernow_table_pstate(struct powernow_k8_data *data, struct cpuf
 
 		index = data->acpi_data->states[i].control & HW_PSTATE_MASK;
 		if (index > data->max_hw_pstate) {
-			printk(KERN_ERR PFX "invalid pstate %d - bad value %d.\n", i, index);
-			printk(KERN_ERR PFX "Please report to BIOS manufacturer\n");
+			FW_PRINT_CRIT(FW_ERR, PFX "invalid pstate %d - bad value %d", i, index);
 			powernow_table[i].frequency = CPUFREQ_ENTRY_INVALID;
 			continue;
 		}
@@ -1165,17 +1168,19 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 			       "ACPI Processor module before starting this "
 			       "driver.\n");
 #else
-			printk(KERN_ERR PFX "Your BIOS does not provide ACPI "
-			       "_PSS objects in a way that Linux understands. "
-			       "Please report this to the Linux ACPI maintainers"
-			       " and complain to your BIOS vendor.\n");
+			FW_PRINT_CRIT(FW_ERR, PFX "Your BIOS does not provide "
+				      "ACPI _PSS objects in a way that Linux "
+				      "understands. Please report this to the "
+				      "Linux ACPI maintainers and complain to "
+				      "your BIOS vendor");
 #endif
 			kfree(data);
 			return -ENODEV;
 		}
 		if (pol->cpu != 0) {
-			printk(KERN_ERR PFX "No ACPI _PSS objects for CPU other than "
-			       "CPU0. Complain to your BIOS vendor.\n");
+			FW_PRINT_CRIT(FW_ERR, PFX "No ACPI _PSS objects for CPU"
+				      " other than CPU0. Complain to your BIOS"
+				      " vendor");
 			kfree(data);
 			return -ENODEV;
 		}
-- 
1.5.4.5

