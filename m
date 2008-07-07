Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYGGMmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYGGMmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYGGMmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:42:40 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:54718 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752913AbYGGMmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:42:38 -0400
X-Greylist: delayed 1837 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 08:42:38 EDT
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: linux-kernel@vger.kernel.org
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [PATCH 1/1] Optimize order of calculating Rt in ads7846_rx function
Date: Mon,  7 Jul 2008 14:11:57 +0200
Message-Id: <1215432717-25386-1-git-send-email-hans-christian.egtvedt@atmel.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch alters the if expression for calculating Rt. The old implementation
would run unnecessary code when the ADS7843 device was used.

The patch also fixes the code style to kernel standard.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 drivers/input/touchscreen/ads7846.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 57a1c28..3044fad 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -527,7 +527,9 @@ static void ads7846_rx(void *ads)
 	if (x == MAX_12BIT)
 		x = 0;
 
-	if (likely(x && z1)) {
+	if (ts->model == 7843) {
+		Rt = ts->pressure_max / 2;
+	} else if (likely(x && z1)) {
 		/* compute touch pressure resistance using equation #2 */
 		Rt = z2;
 		Rt -= z1;
@@ -535,11 +537,9 @@ static void ads7846_rx(void *ads)
 		Rt *= ts->x_plate_ohms;
 		Rt /= z1;
 		Rt = (Rt + 2047) >> 12;
-	} else
+	} else {
 		Rt = 0;
-
-	if (ts->model == 7843)
-		Rt = ts->pressure_max / 2;
+	}
 
 	/* Sample found inconsistent by debouncing or pressure is beyond
 	 * the maximum. Don't report it to user space, repeat at least
-- 
1.5.4.3

