Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbZKPORv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbZKPORv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZKPOQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:16:33 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:26802 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZKPOQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:31 -0500
X-SpamScore: -1
X-BigFish: VPS-1(zz1fa4Lzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ7-02-PZA-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 18/21] amd64_edac: remove early hw support check
Date: Mon, 16 Nov 2009 15:16:45 +0100
Message-ID: <1258381008-18783-19-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:13.0266 (UTC) FILETIME=[5A47CB20:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .probe_valid_hardware low_ops member checked whether the DCTs are in
DDR3 mode and bailed out if so. Now that all the needed changes for DDR3
support is in place, remove it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   47 +--------------------------------------------
 drivers/edac/amd64_edac.h |    1 -
 2 files changed, 1 insertions(+), 47 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index d9cde71..351334e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1739,42 +1739,6 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 }
 
 /*
- * Very early hardware probe on pci_probe thread to determine if this module
- * supports the hardware.
- *
- * Return:
- *      0 for OK
- *      1 for error
- */
-static int f10_probe_valid_hardware(struct amd64_pvt *pvt)
-{
-	int ret = 0;
-
-	/*
-	 * If we are on a DDR3 machine, we don't know yet if
-	 * we support that properly at this time
-	 */
-	if ((pvt->dchr0 & DDR3_MODE) ||
-	    (pvt->dchr1 & DDR3_MODE)) {
-
-		amd64_printk(KERN_WARNING,
-			"%s() This machine is running with DDR3 memory. "
-			"This is not currently supported. "
-			"DCHR0=0x%x DCHR1=0x%x\n",
-			__func__, pvt->dchr0, pvt->dchr1);
-
-		amd64_printk(KERN_WARNING,
-			"   Contact '%s' module MAINTAINER to help add"
-			" support.\n",
-			EDAC_MOD_STR);
-
-		ret = 1;
-
-	}
-	return ret;
-}
-
-/*
  * There currently are 3 types type of MC devices for AMD Athlon/Opterons
  * (as per PCI DEVICE_IDs):
  *
@@ -1803,7 +1767,6 @@ static struct amd64_family_type amd64_family_types[] = {
 		.addr_f1_ctl = PCI_DEVICE_ID_AMD_10H_NB_MAP,
 		.misc_f3_ctl = PCI_DEVICE_ID_AMD_10H_NB_MISC,
 		.ops = {
-			.probe_valid_hardware	= f10_probe_valid_hardware,
 			.early_channel_count	= f10_early_channel_count,
 			.get_error_address	= f10_get_error_address,
 			.read_dram_base_limit	= f10_read_dram_base_limit,
@@ -1817,7 +1780,6 @@ static struct amd64_family_type amd64_family_types[] = {
 		.addr_f1_ctl = PCI_DEVICE_ID_AMD_11H_NB_MAP,
 		.misc_f3_ctl = PCI_DEVICE_ID_AMD_11H_NB_MISC,
 		.ops = {
-			.probe_valid_hardware	= f10_probe_valid_hardware,
 			.early_channel_count	= f10_early_channel_count,
 			.get_error_address	= f10_get_error_address,
 			.read_dram_base_limit	= f10_read_dram_base_limit,
@@ -2851,17 +2813,10 @@ static int amd64_init_2nd_stage(struct amd64_pvt *pvt)
 {
 	int node_id = pvt->mc_node_id;
 	struct mem_ctl_info *mci;
-	int ret, err = 0;
+	int ret;
 
 	amd64_read_mc_registers(pvt);
 
-	ret = -ENODEV;
-	if (pvt->ops->probe_valid_hardware) {
-		err = pvt->ops->probe_valid_hardware(pvt);
-		if (err)
-			goto err_exit;
-	}
-
 	/*
 	 * We need to determine how many memory channels there are. Then use
 	 * that information for calculating the size of the dynamic instance
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index f8c187e..e84f164 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -526,7 +526,6 @@ extern struct mcidev_sysfs_attribute amd64_dbg_attrs[NUM_DBG_ATTRS],
  * functions and per device encoding/decoding logic.
  */
 struct low_ops {
-	int (*probe_valid_hardware)	(struct amd64_pvt *pvt);
 	int (*early_channel_count)	(struct amd64_pvt *pvt);
 
 	u64 (*get_error_address)	(struct mem_ctl_info *mci,
-- 
1.6.4.3


