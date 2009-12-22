Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZLVLnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZLVLnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZLVLnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:43:05 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:12249
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753009AbZLVLmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:42:35 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzab9bhzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KV1XTB-01-IW3-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/6] amd64_edac: make driver loading more robust
Date: Tue, 22 Dec 2009 12:41:14 +0100
Message-ID: <1261482077-23733-4-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
References: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 22 Dec 2009 11:41:35.0114 (UTC) FILETIME=[B6F126A0:01CA82FB]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the module does not initialize fully when the DIMMs aren't
ECC but remains still loaded. Propagate the error when no instance of
the driver is properly initialized and prevent further loading.

Reorganize and polish error handling in amd64_edac_init() while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index fb0d36b..a8af27a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3014,25 +3014,29 @@ static void amd64_setup_pci_device(void)
 static int __init amd64_edac_init(void)
 {
 	int nb, err = -ENODEV;
+	bool load_ok = false;
 
 	edac_printk(KERN_INFO, EDAC_MOD_STR, EDAC_AMD64_VERSION "\n");
 
 	opstate_init();
 
 	if (cache_k8_northbridges() < 0)
-		return err;
+		goto err_ret;
 
 	msrs = msrs_alloc();
+	if (!msrs)
+		goto err_ret;
 
 	err = pci_register_driver(&amd64_pci_driver);
 	if (err)
-		return err;
+		goto err_pci;
 
 	/*
 	 * At this point, the array 'pvt_lookup[]' contains pointers to alloc'd
 	 * amd64_pvt structs. These will be used in the 2nd stage init function
 	 * to finish initialization of the MC instances.
 	 */
+	err = -ENODEV;
 	for (nb = 0; nb < num_k8_northbridges; nb++) {
 		if (!pvt_lookup[nb])
 			continue;
@@ -3040,16 +3044,21 @@ static int __init amd64_edac_init(void)
 		err = amd64_init_2nd_stage(pvt_lookup[nb]);
 		if (err)
 			goto err_2nd_stage;
-	}
 
-	amd64_setup_pci_device();
+		load_ok = true;
+	}
 
-	return 0;
+	if (load_ok) {
+		amd64_setup_pci_device();
+		return 0;
+	}
 
 err_2nd_stage:
-	debugf0("2nd stage failed\n");
 	pci_unregister_driver(&amd64_pci_driver);
-
+err_pci:
+	msrs_free(msrs);
+	msrs = NULL;
+err_ret:
 	return err;
 }
 
-- 
1.6.5.4


