Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbZIPNvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbZIPNvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZIPNvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:51:44 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:51433 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965AbZIPNvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:51:39 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KQ2H5X-03-4N0-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <torvalds@linux-foundation.org>
CC: <norsk5@yahoo.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/5] amd64_edac: cleanup amd64_check_ecc_enabled
Date: Wed, 16 Sep 2009 15:50:48 +0200
Message-ID: <1253109050-31165-4-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253109050-31165-1-git-send-email-borislav.petkov@amd.com>
References: <1253109050-31165-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Sep 2009 13:51:23.0628 (UTC) FILETIME=[C73052C0:01CA36D4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify code flow and make sure return value is always valid since
further driver init depends on it. Carve out long warning string and
make code more readable. Shorten some names, while at it.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   76 +++++++++++++++------------------------------
 1 files changed, 25 insertions(+), 51 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 173dc4a..bde3d02 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2783,7 +2783,7 @@ static void check_mcg_ctl(void *ret)
 }
 
 /* check MCG_CTL on all the cpus on this node */
-static int amd64_mcg_ctl_enabled_on_cpus(const cpumask_t *mask)
+static int mcg_ctl_enabled_on_node(const struct cpumask *mask)
 {
 	int ret = 1;
 	preempt_disable();
@@ -2799,71 +2799,45 @@ static int amd64_mcg_ctl_enabled_on_cpus(const cpumask_t *mask)
  * the memory system completely. A command line option allows to force-enable
  * hardware ECC later in amd64_enable_ecc_error_reporting().
  */
+static const char *ecc_warning =
+	"WARNING: ECC is disabled by BIOS. Module will NOT be loaded.\n"
+	" Either Enable ECC in the BIOS, or set 'ecc_enable_override'.\n"
+	" Also, use of the override can cause unknown side effects.\n";
+
 static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 {
 	u32 value;
-	int err = 0, ret = 0;
-	u8 ecc_enabled = 0;
+	int err = 0;
+	u8 ecc_enabled = 0, mcg_ctl_en = 0;
 
 	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &value);
 	if (err)
 		debugf0("Reading K8_NBCTL failed\n");
 
 	ecc_enabled = !!(value & K8_NBCFG_ECC_ENABLE);
+	if (!ecc_enabled)
+		amd64_printk(KERN_WARNING, "This node reports that Memory ECC "
+			     "is currently disabled, set F3x%x[22] (%s).\n",
+			     K8_NBCFG, pci_name(pvt->misc_f3_ctl));
+	else
+		amd64_printk(KERN_INFO, "ECC is enabled by BIOS.\n");
 
-	ret = amd64_mcg_ctl_enabled_on_cpus(cpumask_of_node(pvt->mc_node_id));
-
-	debugf0("K8_NBCFG=0x%x,  DRAM ECC is %s\n", value,
-			(value & K8_NBCFG_ECC_ENABLE ? "enabled" : "disabled"));
-
-	if (!ecc_enabled || !ret) {
-		if (!ecc_enabled) {
-			amd64_printk(KERN_WARNING, "This node reports that "
-						   "Memory ECC is currently "
-						   "disabled.\n");
+	mcg_ctl_en = mcg_ctl_enabled_on_node(cpumask_of_node(pvt->mc_node_id));
+	if (!mcg_ctl_en)
+		amd64_printk(KERN_WARNING, "NB MCE bank disabled, set MSR "
+			     "0x%08x[4] on node %d to enable.\n",
+			     MSR_IA32_MCG_CTL, pvt->mc_node_id);
 
-			amd64_printk(KERN_WARNING, "bit 0x%lx in register "
-				"F3x%x of the MISC_CONTROL device (%s) "
-				"should be enabled\n", K8_NBCFG_ECC_ENABLE,
-				K8_NBCFG, pci_name(pvt->misc_f3_ctl));
-		}
-		if (!ret) {
-			amd64_printk(KERN_WARNING, "bit 0x%016lx in MSR 0x%08x "
-					"of node %d should be enabled\n",
-					K8_MSR_MCGCTL_NBE, MSR_IA32_MCG_CTL,
-					pvt->mc_node_id);
-		}
+	if (!ecc_enabled || !mcg_ctl_en) {
 		if (!ecc_enable_override) {
-			amd64_printk(KERN_WARNING, "WARNING: ECC is NOT "
-				"currently enabled by the BIOS. Module "
-				"will NOT be loaded.\n"
-				"    Either Enable ECC in the BIOS, "
-				"or use the 'ecc_enable_override' "
-				"parameter.\n"
-				"    Might be a BIOS bug, if BIOS says "
-				"ECC is enabled\n"
-				"    Use of the override can cause "
-				"unknown side effects.\n");
-			ret = -ENODEV;
-		} else
-			/*
-			 * enable further driver loading if ECC enable is
-			 * overridden.
-			 */
-			ret = 0;
-	} else {
-		amd64_printk(KERN_INFO,
-			"ECC is enabled by BIOS, Proceeding "
-			"with EDAC module initialization\n");
-
-		/* Signal good ECC status */
-		ret = 0;
-
+			amd64_printk(KERN_WARNING, "%s", ecc_warning);
+			return -ENODEV;
+		}
+	} else
 		/* CLEAR the override, since BIOS controlled it */
 		ecc_enable_override = 0;
-	}
 
-	return ret;
+	return 0;
 }
 
 struct mcidev_sysfs_attribute sysfs_attrs[ARRAY_SIZE(amd64_dbg_attrs) +
-- 
1.6.3.3


