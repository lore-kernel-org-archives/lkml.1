Return-Path: <linux-kernel-owner+w=401wt.eu-S1762478AbZDHIP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762478AbZDHIP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762645AbZDHIOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:14:19 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:47621 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbZDHIOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:14:10 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 03/11] w35und: simplify error handling in wb35_hw_init()
Date: Wed,  8 Apr 2009 11:13:58 +0300
Message-Id: <1239178446-12893-3-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Change hal_init_hardware() to return an error code rather than a boolean
to simplify error handling in wb35_hw_init().

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index a035c8c..1943ff0 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -476,7 +476,7 @@ static void hal_led_control(unsigned long data)
 	add_timer(&pHwData->LEDTimer);
 }
 
-static u8 hal_init_hardware(struct ieee80211_hw *hw)
+static int hal_init_hardware(struct ieee80211_hw *hw)
 {
 	struct wbsoft_priv *priv = hw->priv;
 	struct hw_data * pHwData = &priv->sHwData;
@@ -514,13 +514,13 @@ static u8 hal_init_hardware(struct ieee80211_hw *hw)
 				Wb35Rx_start(hw);
 				Wb35Tx_EP2VM_start(priv);
 
-				return true;
+				return 0;
 			}
 		}
 	}
 
 	pHwData->SurpriseRemove = 1;
-	return false;
+	return -EINVAL;
 }
 
 static int wb35_hw_init(struct ieee80211_hw *hw)
@@ -555,10 +555,9 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 
 	// Initial USB hal
 	pHwData = &priv->sHwData;
-	if (!hal_init_hardware(hw)) {
-		err = -EINVAL;
+	err = hal_init_hardware(hw);
+	if (err)
 		goto error;
-	}
 
 	EEPROM_region = hal_get_region_from_EEPROM( pHwData );
 	if (EEPROM_region != REGION_AUTO)
-- 
1.5.6.3

