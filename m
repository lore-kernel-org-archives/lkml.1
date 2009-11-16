Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbZKPOQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbZKPOQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbZKPOQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:16:43 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:45264
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753611AbZKPOQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:41 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ2-01-9KI-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 10/21] amd64_edac: cleanup f10_early_channel_count
Date: Mon, 16 Nov 2009 15:16:37 +0100
Message-ID: <1258381008-18783-11-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:13.0016 (UTC) FILETIME=[5A21A580:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not read DCLR[01] again since this is done in
amd64_read_mc_registers() earlier. There can be more than two physical
DIMMs present so clamp the channels value to max 2. Also, do not report
DCT data width - it is also done earlier.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c6d1aed..ed9b07a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1204,28 +1204,21 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
 	int i, j, channels = 0;
 	u32 dbam;
 
-	if (amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0))
-		goto err_reg;
-
-	if (amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_1, &pvt->dclr1))
-		goto err_reg;
-
 	/* If we are in 128 bit mode, then we are using 2 channels */
 	if (pvt->dclr0 & F10_WIDTH_128) {
-		debugf0("Data WIDTH is 128 bits - 2 channels\n");
 		channels = 2;
 		return channels;
 	}
 
 	/*
-	 * Need to check if in UN-ganged mode: In such, there are 2 channels,
-	 * but they are NOT in 128 bit mode and thus the above 'dcl0' status bit
-	 * will be OFF.
+	 * Need to check if in unganged mode: In such, there are 2 channels,
+	 * but they are not in 128 bit mode and thus the above 'dclr0' status
+	 * bit will be OFF.
 	 *
 	 * Need to check DCT0[0] and DCT1[0] to see if only one of them has
 	 * their CSEnable bit on. If so, then SINGLE DIMM case.
 	 */
-	debugf0("Data WIDTH is NOT 128 bits - need more decoding\n");
+	debugf0("Data width is not 128 bits - need more decoding\n");
 
 	/*
 	 * Check DRAM Bank Address Mapping values for each DIMM to see if there
@@ -1244,6 +1237,9 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
 		}
 	}
 
+	if (channels > 2)
+		channels = 2;
+
 	debugf0("MCT channel count: %d\n", channels);
 
 	return channels;
-- 
1.6.4.3


