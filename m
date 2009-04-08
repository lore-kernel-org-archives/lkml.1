Return-Path: <linux-kernel-owner+w=401wt.eu-S1763433AbZDHIQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763433AbZDHIQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762695AbZDHIOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:14:20 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:47651 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762101AbZDHIOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:14:10 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 05/11] w35und: simplify hal_init_hardware() error handling
Date: Wed,  8 Apr 2009 11:14:00 +0300
Message-Id: <1239178446-12893-5-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix, cleanup

If initialization in hal_init_hardware() fails, we call hal_halt() to
clean up and release resource. However, hal_halt() will attempt to
call del_timer_sync() on ->LEDTimer on "stage 3" although it's not
initialized at that point. Fix that up by simplifying error handling
logic in hal_init_hardware() with gotos.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 65d443a..b1ef30a 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -488,15 +488,15 @@ static int hal_init_hardware(struct ieee80211_hw *hw)
 
 	pHwData->InitialResource = 1;
 	if (!Wb35Reg_initial(pHwData))
-		goto error;
+		goto error_reg_destroy;
 
 	pHwData->InitialResource = 2;
 	if (!Wb35Tx_initial(pHwData))
-		goto error;
+		goto error_tx_destroy;
 
 	pHwData->InitialResource = 3;
 	if (!Wb35Rx_initial(pHwData))
-		goto error;
+		goto error_rx_destroy;
 
 	pHwData->InitialResource = 4;
 	init_timer(&pHwData->LEDTimer);
@@ -522,7 +522,13 @@ static int hal_init_hardware(struct ieee80211_hw *hw)
 
 	return 0;
 
-error:
+error_rx_destroy:
+	Wb35Rx_destroy(pHwData);
+error_tx_destroy:
+	Wb35Tx_destroy(pHwData);
+error_reg_destroy:
+	Wb35Reg_destroy(pHwData);
+
 	pHwData->SurpriseRemove = 1;
 	return -EINVAL;
 }
@@ -617,11 +623,8 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 	hal_driver_init_OK(pHwData) = 1; // Notify hal that the driver is ready now.
 	//set a tx power for reference.....
 //	sme_set_tx_power_level(priv, 12);	FIXME?
-	return 0;
 
 error:
-	hal_halt(pHwData, NULL);
-
 	return err;
 }
 
-- 
1.5.6.3

