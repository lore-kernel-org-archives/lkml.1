Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbZLVLml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbZLVLml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZLVLmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:42:38 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:1977 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752992AbZLVLme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:42:34 -0500
X-SpamScore: 4
X-BigFish: VPS4(zzab9bhzz1202hzz5a6ciz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KV1XTA-01-IW2-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/6] amd64_edac: fix driver instance freeing
Date: Tue, 22 Dec 2009 12:41:13 +0100
Message-ID: <1261482077-23733-3-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
References: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 22 Dec 2009 11:41:35.0082 (UTC) FILETIME=[B6EC44A0:01CA82FB]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix use-after-free errors by pushing all memory-freeing calls to the end
of amd64_remove_one_instance().

Reported-by: Darren Jenkins <darrenrjenkins@gmail.com>
LKML-Reference: <1261370306.11354.52.camel@ICE-BOX>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 784cc5a..fb0d36b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2929,16 +2929,15 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 
 	amd64_free_mc_sibling_devices(pvt);
 
-	kfree(pvt);
-	mci->pvt_info = NULL;
-
-	mci_lookup[pvt->mc_node_id] = NULL;
-
 	/* unregister from EDAC MCE */
 	amd_report_gart_errors(false);
 	amd_unregister_ecc_decoder(amd64_decode_bus_error);
 
 	/* Free the EDAC CORE resources */
+	mci->pvt_info = NULL;
+	mci_lookup[pvt->mc_node_id] = NULL;
+
+	kfree(pvt);
 	edac_mc_free(mci);
 }
 
-- 
1.6.5.4


