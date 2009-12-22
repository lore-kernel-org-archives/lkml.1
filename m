Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZLVLlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZLVLlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZLVLlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:41:47 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:36037 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZLVLlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:41:44 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KV1XT8-01-IW1-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/6] amd64_edac: fix K8 chip select reporting
Date: Tue, 22 Dec 2009 12:41:12 +0100
Message-ID: <1261482077-23733-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
References: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 22 Dec 2009 11:41:33.0473 (UTC) FILETIME=[B5F6C110:01CA82FB]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the case when amd64_debug_display_dimm_sizes() reports only half the
amount of DRAM on it because it doesn't account for when the single DCT
operates in 128-bit mode and merges chip selects from different DIMMs.

Reported-by: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
LKML-Reference: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index df5b684..784cc5a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1700,11 +1700,14 @@ static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
  */
 static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 {
-	int dimm, size0, size1;
+	int dimm, size0, size1, factor = 0;
 	u32 dbam;
 	u32 *dcsb;
 
 	if (boot_cpu_data.x86 == 0xf) {
+		if (pvt->dclr0 & F10_WIDTH_128)
+			factor = 1;
+
 		/* K8 families < revF not supported yet */
 	       if (pvt->ext_model < K8_REV_F)
 			return;
@@ -1732,7 +1735,8 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 			size1 = pvt->ops->dbam_to_cs(pvt, DBAM_DIMM(dimm, dbam));
 
 		edac_printk(KERN_DEBUG, EDAC_MC, " %d: %5dMB %d: %5dMB\n",
-			    dimm * 2, size0, dimm * 2 + 1, size1);
+			    dimm * 2,     size0 << factor,
+			    dimm * 2 + 1, size1 << factor);
 	}
 }
 
-- 
1.6.5.4


