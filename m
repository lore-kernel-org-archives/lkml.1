Return-Path: <linux-kernel-owner+w=401wt.eu-S1765176AbYJKG65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765176AbYJKG65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757628AbYJKGk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:40:29 -0400
Received: from vms172071pub.verizon.net ([206.46.172.71]:52144 "EHLO
	vms172071pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYJKGg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:59 -0400
Date: Sat, 11 Oct 2008 02:35:47 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 27/85] CPUFREQ: powernow-k8: Try to detect old BIOS,
 not supporting CPU freq on a recent AMD CPUs.
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <2fd47094f92fa2bdbf99be33294a7b6b97785a70.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

Make use of FW_BUG interface to give vendors and users the ability to
automatically check for powernow-k8 related BIOS bugs by:
dmesg |grep "Firmware Bug"

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   42 ++++++++++++++++------------
 1 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 84bb395..4e0c6ab 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -45,7 +45,6 @@
 #endif
 
 #define PFX "powernow-k8: "
-#define BFX PFX "BIOS error: "
 #define VERSION "version 2.20.00"
 #include "powernow-k8.h"
 
@@ -536,35 +535,40 @@ static int check_pst_table(struct powernow_k8_data *data, struct pst_s *pst, u8
 
 	for (j = 0; j < data->numps; j++) {
 		if (pst[j].vid > LEAST_VID) {
-			printk(KERN_ERR PFX "vid %d invalid : 0x%x\n", j, pst[j].vid);
+			printk(KERN_ERR FW_BUG PFX "vid %d invalid : 0x%x\n",
+			       j, pst[j].vid);
 			return -EINVAL;
 		}
 		if (pst[j].vid < data->rvo) {	/* vid + rvo >= 0 */
-			printk(KERN_ERR BFX "0 vid exceeded with pstate %d\n", j);
+			printk(KERN_ERR FW_BUG PFX "0 vid exceeded with pstate"
+			       " %d\n", j);
 			return -ENODEV;
 		}
 		if (pst[j].vid < maxvid + data->rvo) {	/* vid + rvo >= maxvid */
-			printk(KERN_ERR BFX "maxvid exceeded with pstate %d\n", j);
+			printk(KERN_ERR FW_BUG PFX "maxvid exceeded with pstate"
+			       " %d\n", j);
 			return -ENODEV;
 		}
 		if (pst[j].fid > MAX_FID) {
-			printk(KERN_ERR BFX "maxfid exceeded with pstate %d\n", j);
+			printk(KERN_ERR FW_BUG PFX "maxfid exceeded with pstate"
+			       " %d\n", j);
 			return -ENODEV;
 		}
 		if (j && (pst[j].fid < HI_FID_TABLE_BOTTOM)) {
 			/* Only first fid is allowed to be in "low" range */
-			printk(KERN_ERR BFX "two low fids - %d : 0x%x\n", j, pst[j].fid);
+			printk(KERN_ERR FW_BUG PFX "two low fids - %d : "
+			       "0x%x\n", j, pst[j].fid);
 			return -EINVAL;
 		}
 		if (pst[j].fid < lastfid)
 			lastfid = pst[j].fid;
 	}
 	if (lastfid & 1) {
-		printk(KERN_ERR BFX "lastfid invalid\n");
+		printk(KERN_ERR FW_BUG PFX "lastfid invalid\n");
 		return -EINVAL;
 	}
 	if (lastfid > LO_FID_TABLE_TOP)
-		printk(KERN_INFO BFX  "first fid not from lo freq table\n");
+		printk(KERN_INFO FW_BUG PFX  "first fid not from lo freq table\n");
 
 	return 0;
 }
@@ -672,13 +676,13 @@ static int find_psb_table(struct powernow_k8_data *data)
 
 		dprintk("table vers: 0x%x\n", psb->tableversion);
 		if (psb->tableversion != PSB_VERSION_1_4) {
-			printk(KERN_ERR BFX "PSB table is not v1.4\n");
+			printk(KERN_ERR FW_BUG PFX "PSB table is not v1.4\n");
 			return -ENODEV;
 		}
 
 		dprintk("flags: 0x%x\n", psb->flags1);
 		if (psb->flags1) {
-			printk(KERN_ERR BFX "unknown flags\n");
+			printk(KERN_ERR FW_BUG PFX "unknown flags\n");
 			return -ENODEV;
 		}
 
@@ -705,7 +709,7 @@ static int find_psb_table(struct powernow_k8_data *data)
 			}
 		}
 		if (cpst != 1) {
-			printk(KERN_ERR BFX "numpst must be 1\n");
+			printk(KERN_ERR FW_BUG PFX "numpst must be 1\n");
 			return -ENODEV;
 		}
 
@@ -1130,17 +1134,19 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 			       "ACPI Processor module before starting this "
 			       "driver.\n");
 #else
-			printk(KERN_ERR PFX "Your BIOS does not provide ACPI "
-			       "_PSS objects in a way that Linux understands. "
-			       "Please report this to the Linux ACPI maintainers"
-			       " and complain to your BIOS vendor.\n");
+			printk(KERN_ERR FW_BUG PFX "Your BIOS does not provide"
+			       " ACPI _PSS objects in a way that Linux "
+			       "understands. Please report this to the Linux "
+			       "ACPI maintainers and complain to your BIOS "
+			       "vendor.\n");
 #endif
 			kfree(data);
 			return -ENODEV;
 		}
 		if (pol->cpu != 0) {
-			printk(KERN_ERR PFX "No ACPI _PSS objects for CPU other than "
-			       "CPU0. Complain to your BIOS vendor.\n");
+			printk(KERN_ERR FW_BUG PFX "No ACPI _PSS objects for "
+			       "CPU other than CPU0. Complain to your BIOS "
+			       "vendor.\n");
 			kfree(data);
 			return -ENODEV;
 		}
@@ -1193,7 +1199,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 
 	/* min/max the cpu is capable of */
 	if (cpufreq_frequency_table_cpuinfo(pol, data->powernow_table)) {
-		printk(KERN_ERR PFX "invalid powernow_table\n");
+		printk(KERN_ERR FW_BUG PFX "invalid powernow_table\n");
 		powernow_k8_cpu_exit_acpi(data);
 		kfree(data->powernow_table);
 		kfree(data);
-- 
1.5.5.1

