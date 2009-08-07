Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbZHGOjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbZHGOjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 10:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932563AbZHGOjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 10:39:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:26635 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578AbZHGOjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 10:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vv64XMgDYXUqoDIjqcm0LhlUNNQWJdD+w7XjUN9j/5UjLgzj5ZGu2YnJiH49c4/3rW
         kFO58+lM7j0iCM28lWBI2CEuqoiJdZZd/bOh+3jIAvgdzrqLwu9IFTz3Il033N1Q8J0F
         T8kXNunY5yWtBzAJ1m7Au9WHV/Q7fbXMz6sjo=
MIME-Version: 1.0
In-Reply-To: <20090807122916.GC29900@aftab>
References: <86bb1aef0908062236w1912a909yfa892d40f1776e08@mail.gmail.com>
	 <20090807122916.GC29900@aftab>
Date: Fri, 7 Aug 2009 22:39:39 +0800
Message-ID: <86bb1aef0908070739q6b7fdd60wae9550bb99f658cd@mail.gmail.com>
Subject: [PATCH] amd64_edac: Rewrite unganged mode code of 
	f10_early_channel_count
From: wan wei <onewayforever@gmail.com>
To: borislav.petkov@amd.com, dougthompson@xmission.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simplify the procedure by checking if there is any dimm  in each channel.
this patch will fix the bugs such as when there is no dimms  under
certain node,  two dimms in the same channel, and only one dimm in
each channel of the node.

Signed-off-by: Wan Wei<wanwei@mail.dawning.com.cn>
---
 drivers/edac/amd64_edac.c |   43 ++++++++++---------------------------------
 1 files changed, 10 insertions(+), 33 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e2a10bc..acf9cfe 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1200,6 +1200,8 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
 {
 	int err = 0, channels = 0;
 	u32 dbam;
+	int i, j;
+	int dbams[] = { DBAM0, DBAM1 };

 	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
 	if (err)
@@ -1232,45 +1234,20 @@ static int f10_early_channel_count(struct
amd64_pvt *pvt)
 	 * both controllers since DIMMs can be placed in either one.
 	 */
 	channels = 0;
-	err = pci_read_config_dword(pvt->dram_f2_ctl, DBAM0, &dbam);
-	if (err)
-		goto err_reg;

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
1.4.4.2
