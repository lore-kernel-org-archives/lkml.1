Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbZFWLnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbZFWLnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759020AbZFWLnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:43:20 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:12003 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759240AbZFWLnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:43:19 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KLOWJT-02-0GD-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: [PATCH 3/3] amd64_edac: misc small cleanups
Date: Tue, 23 Jun 2009 13:43:03 +0200
Message-ID: <1245757383-21333-3-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245757383-21333-2-git-send-email-borislav.petkov@amd.com>
References: <1245757383-21333-1-git-send-email-borislav.petkov@amd.com>
 <1245757383-21333-2-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 23 Jun 2009 11:43:07.0325 (UTC) FILETIME=[C6B8EED0:01C9F3F7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- cleanup debug calls
- shorten function names
- cleanup error exit paths

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   13 +++++++------
 drivers/edac/amd64_edac.h |    2 +-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8497963..858fe60 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1269,7 +1269,7 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
 	if (channels == 0)
 		channels = 1;
 
-	debugf0("DIMM count= %d\n", channels);
+	debugf0("MCT channel count: %d\n", channels);
 
 	return channels;
 
@@ -3056,7 +3056,7 @@ static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl,
 	if (!pvt)
 		goto err_exit;
 
-	pvt->mc_node_id = get_mc_node_id_from_pdev(dram_f2_ctl);
+	pvt->mc_node_id = get_node_id(dram_f2_ctl);
 
 	pvt->dram_f2_ctl	= dram_f2_ctl;
 	pvt->ext_model		= boot_cpu_data.x86_model >> 4;
@@ -3183,8 +3183,7 @@ static int __devinit amd64_init_one_instance(struct pci_dev *pdev,
 {
 	int ret = 0;
 
-	debugf0("(MC node=%d,mc_type='%s')\n",
-		get_mc_node_id_from_pdev(pdev),
+	debugf0("(MC node=%d,mc_type='%s')\n", get_node_id(pdev),
 		get_amd_family_name(mc_type->driver_data));
 
 	ret = pci_enable_device(pdev);
@@ -3323,15 +3322,17 @@ static int __init amd64_edac_init(void)
 
 		err = amd64_init_2nd_stage(pvt_lookup[nb]);
 		if (err)
-			goto err_exit;
+			goto err_2nd_stage;
 	}
 
 	amd64_setup_pci_device();
 
 	return 0;
 
+err_2nd_stage:
+	debugf0("2nd stage failed\n");
+
 err_exit:
-	debugf0("'finish_setup' stage failed\n");
 	pci_unregister_driver(&amd64_pci_driver);
 
 	return err;
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index a159957..ba73015 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -444,7 +444,7 @@ enum {
 #define K8_MSR_MC4ADDR			0x0412
 
 /* AMD sets the first MC device at device ID 0x18. */
-static inline int get_mc_node_id_from_pdev(struct pci_dev *pdev)
+static inline int get_node_id(struct pci_dev *pdev)
 {
 	return PCI_SLOT(pdev->devfn) - 0x18;
 }
-- 
1.6.3.1


