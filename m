Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbZHGFoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbZHGFoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 01:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZHGFoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 01:44:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:21774 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZHGFog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 01:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RTH2DJAaptZb8BpL+ZkHboSZgHQSM1xOh+nonDVf2Ha5cY8XBdcEl03zRuzJbygpRZ
         kLMC4s5BKWfNcR5Oin6PGGSURFn+PJD6A3QmYuGijXKRT7rTCcMKJUrvBDhDhGWLyqIr
         4Wd7em7iV1Aqc7Me8UJFggZLG25tRvi9K3BeI=
MIME-Version: 1.0
Date: Fri, 7 Aug 2009 13:36:30 +0800
Message-ID: <86bb1aef0908062236w1912a909yfa892d40f1776e08@mail.gmail.com>
Subject: [PATCH] amd64_edac: Rewrite unganged mode code of 
	f10_early_channel_count
From: wan wei <onewayforever@gmail.com>
To: Borislav Petkov <borislav.petkov@amd.com>, dougthompson@xmission.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
     I rechecked the f10_early_channel_count function, and found more
bugs in unganged mode. This patch will fix  bugs under following
conditions,
    a. only one DIMM in each channelof the node,
    b. two DIMMs are populated in the same channel of the node,
    c. there is no DIMM in a node(other than node 0),
    a and b  mean both dbam should be checked in any condition,  and c
means even channels==0 is ok.

the patch has been tested and works well in  this  4 ways machine:
   node 0:  2 DIMMS on each channel
   node11: no DIMMS
   node2:  2 DIMM on the chanel 0
   node3:  one DIMM on each channel

thanks :-)

Signed-off-by: Wan Wei<wanwei@mail.dawning.com.cn>

---
 drivers/edac/amd64_edac.c |   46 ++++++++++++++------------------------------
 1 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e2a10bc..7a328fa 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1200,6 +1200,7 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
 {
 	int err = 0, channels = 0;
 	u32 dbam;
+	int i;

 	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
 	if (err)
@@ -1236,40 +1237,23 @@ static int f10_early_channel_count(struct
amd64_pvt *pvt)
 	if (err)
 		goto err_reg;

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
-		if (err)
-			goto err_reg;
-
-		if (DBAM_DIMM(0, dbam) > 0)
+	for (i = 0; i < 4; i++) {
+		if (DBAM_DIMM(i, dbam) > 0) {
 			channels++;
-		if (DBAM_DIMM(1, dbam) > 0)
-			channels++;
-		if (DBAM_DIMM(2, dbam) > 0)
-			channels++;
-		if (DBAM_DIMM(3, dbam) > 0)
-			channels++;
-
-		if (channels > 2)
-			channels = 2;
+			break;
+		}
 	}

-	/* If we found ALL 0 values, then assume just ONE DIMM-ONE Channel */
-	if (channels == 0)
-		channels = 1;
+	err = pci_read_config_dword(pvt->dram_f2_ctl, DBAM1, &dbam);
+	if (err)
+		goto err_reg;
+
+	for (i = 0; i < 4; i++) {
+		if (DBAM_DIMM(i, dbam) > 0) {
+			channels++;
+			break;
+		}
+	}

 	debugf0("MCT channel count: %d\n", channels);

-- 
1.4.4.2
