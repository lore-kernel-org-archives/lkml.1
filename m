Return-Path: <linux-kernel-owner+w=401wt.eu-S1759126AbZIPNvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126AbZIPNvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbZIPNvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:51:50 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:30215 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759079AbZIPNvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:51:47 -0400
X-SpamScore: 11
X-BigFish: VPS11(zza4b1ozz1202hzz5a6ciz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KQ2H5Z-03-4N3-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <torvalds@linux-foundation.org>
CC: <norsk5@yahoo.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Wan Wei <onewayforever@gmail.com>, Wan Wei <wanwei@mail.dawning.com.cn>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/5] amd64_edac: Rewrite unganged mode code of f10_early_channel_count
Date: Wed, 16 Sep 2009 15:50:49 +0200
Message-ID: <1253109050-31165-5-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253109050-31165-1-git-send-email-borislav.petkov@amd.com>
References: <1253109050-31165-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Sep 2009 13:51:23.0987 (UTC) FILETIME=[C7671A30:01CA36D4]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wan Wei <onewayforever@gmail.com>

Simplify the procedure by checking if there is any DIMM in each channel.
This patch will fix the bugs such as when there is no DIMMs under
certain node, two DIMMs in the same channel, and only one DIMM in each
channel of the node.

Borislav: minor fixups

Signed-off-by: Wan Wei <wanwei@mail.dawning.com.cn>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   45 ++++++++++-----------------------------------
 1 files changed, 10 insertions(+), 35 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index bde3d02..f943ad8 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1255,7 +1255,9 @@ static int k8_dbam_map_to_pages(struct amd64_pvt *pvt, int dram_map)
  */
 static int f10_early_channel_count(struct amd64_pvt *pvt)
 {
+	int dbams[] = { DBAM0, DBAM1 };
 	int err = 0, channels = 0;
+	int i, j;
 	u32 dbam;
 
 	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
@@ -1288,46 +1290,19 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
 	 * is more than just one DIMM present in unganged mode. Need to check
 	 * both controllers since DIMMs can be placed in either one.
 	 */
-	channels = 0;
-	err = pci_read_config_dword(pvt->dram_f2_ctl, DBAM0, &dbam);
-	if (err)
-		goto err_reg;
-
-	if (DBAM_DIMM(0, dbam) > 0)
-		channels++;
-	if (DBAM_DIMM(1, dbam) > 0)
-		channels++;
-	if (DBAM_DIMM(2, dbam) > 0)
-		channels++;
-	if (DBAM_DIMM(3, dbam) > 0)
-		channels++;
-
-	/* If more than 2 DIMMs are present, then we have 2 channels */
-	if (channels > 2)
-		channels = 2;
-	else if (channels == 0) {
-		/* No DIMMs on DCT0, so look at DCT1 */
-		err = pci_read_config_dword(pvt->dram_f2_ctl, DBAM1, &dbam);
+	for (i = 0; i < ARRAY_SIZE(dbams); i++) {
+		err = pci_read_config_dword(pvt->dram_f2_ctl, dbams[i], &dbam);
 		if (err)
 			goto err_reg;
 
-		if (DBAM_DIMM(0, dbam) > 0)
-			channels++;
-		if (DBAM_DIMM(1, dbam) > 0)
-			channels++;
-		if (DBAM_DIMM(2, dbam) > 0)
-			channels++;
-		if (DBAM_DIMM(3, dbam) > 0)
-			channels++;
-
-		if (channels > 2)
-			channels = 2;
+		for (j = 0; j < 4; j++) {
+			if (DBAM_DIMM(j, dbam) > 0) {
+				channels++;
+				break;
+			}
+		}
 	}
 
-	/* If we found ALL 0 values, then assume just ONE DIMM-ONE Channel */
-	if (channels == 0)
-		channels = 1;
-
 	debugf0("MCT channel count: %d\n", channels);
 
 	return channels;
-- 
1.6.3.3


