Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbZKDQKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbZKDQKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbZKDQKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:10:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33181 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753510AbZKDQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:10:50 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Mask and unmask wm8350 IRQs on request and free
Date: Wed,  4 Nov 2009 16:10:52 +0000
Message-Id: <1257351052-32375-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257351052-32375-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1257351052-32375-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring the WM8350 IRQ API more in line with the generic IRQ API by
masking and unmasking interrupts as they are requested and freed.
This is mostly just a case of deleting the mask and unmask calls
from the individual drivers.

The RTC driver is changed to mask the periodic IRQ after requesting
it rather than only unmasking the alarm IRQ. If the periodic IRQ
fires in the period where it is reqested then there will be a
spurious notification but there should be no serious consequences
from this.

The CODEC drive is changed to explicitly disable headphone jack
detection prior to requesting the IRQs. This will avoid the IRQ
firing with no jack set up.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-irq.c             |    4 ++++
 drivers/power/wm8350_power.c         |   26 --------------------------
 drivers/regulator/wm8350-regulator.c |    3 ---
 drivers/rtc/rtc-wm8350.c             |    7 +------
 sound/soc/codecs/wm8350.c            |   10 ++++------
 5 files changed, 9 insertions(+), 41 deletions(-)

diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index 2ea2b8b..c8df547 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -445,6 +445,8 @@ int wm8350_register_irq(struct wm8350 *wm8350, int irq,
 	wm8350->irq[irq].data = data;
 	mutex_unlock(&wm8350->irq_mutex);
 
+	wm8350_unmask_irq(wm8350, irq);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wm8350_register_irq);
@@ -454,6 +456,8 @@ int wm8350_free_irq(struct wm8350 *wm8350, int irq)
 	if (irq < 0 || irq > WM8350_NUM_IRQ)
 		return -EINVAL;
 
+	wm8350_mask_irq(wm8350, irq);
+
 	mutex_lock(&wm8350->irq_mutex);
 	wm8350->irq[irq].handler = NULL;
 	mutex_unlock(&wm8350->irq_mutex);
diff --git a/drivers/power/wm8350_power.c b/drivers/power/wm8350_power.c
index 6e634cf..ad4f071 100644
--- a/drivers/power/wm8350_power.c
+++ b/drivers/power/wm8350_power.c
@@ -391,80 +391,54 @@ static void wm8350_init_charger(struct wm8350 *wm8350)
 	/* register our interest in charger events */
 	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT,
 			    wm8350_charger_handler, 0, "Battery hot", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT);
 	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD,
 			    wm8350_charger_handler, 0, "Battery cold", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD);
 	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL,
 			    wm8350_charger_handler, 0, "Battery fail", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL);
 	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_TO,
 			    wm8350_charger_handler, 0,
 			    "Charger timeout", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_TO);
 	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_END,
 			    wm8350_charger_handler, 0,
 			    "Charge end", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_END);
 	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_START,
 			    wm8350_charger_handler, 0,
 			    "Charge start", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_START);
 	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY,
 			    wm8350_charger_handler, 0,
 			    "Fast charge ready", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY);
 	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9,
 			    wm8350_charger_handler, 0,
 			    "Battery <3.9V", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9);
 	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1,
 			    wm8350_charger_handler, 0,
 			    "Battery <3.1V", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1);
 	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85,
 			    wm8350_charger_handler, 0,
 			    "Battery <2.85V", wm8350);
 
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85);
-
 	/* and supply change events */
 	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_USB_FB,
 			    wm8350_charger_handler, 0, "USB", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_EXT_USB_FB);
 	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_WALL_FB,
 			    wm8350_charger_handler, 0, "Wall", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_EXT_WALL_FB);
 	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_BAT_FB,
 			    wm8350_charger_handler, 0, "Battery", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_EXT_BAT_FB);
 }
 
 static void free_charger_irq(struct wm8350 *wm8350)
 {
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_TO);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_TO);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_END);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_END);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_START);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_START);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_EXT_USB_FB);
 	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_USB_FB);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_EXT_WALL_FB);
 	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_WALL_FB);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_EXT_BAT_FB);
 	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_BAT_FB);
 }
 
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 8c289fd..1bbff09 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1399,8 +1399,6 @@ static int wm8350_regulator_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	wm8350_unmask_irq(wm8350, wm8350_reg[pdev->id].irq);
-
 	return 0;
 }
 
@@ -1409,7 +1407,6 @@ static int wm8350_regulator_remove(struct platform_device *pdev)
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 	struct wm8350 *wm8350 = rdev_get_drvdata(rdev);
 
-	wm8350_mask_irq(wm8350, wm8350_reg[pdev->id].irq);
 	wm8350_free_irq(wm8350, wm8350_reg[pdev->id].irq);
 
 	regulator_unregister(rdev);
diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index 56e56e5..f164866 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -459,17 +459,14 @@ static int wm8350_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_SEC);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_PER);
-
 	wm8350_register_irq(wm8350, WM8350_IRQ_RTC_SEC,
 			    wm8350_rtc_update_handler, 0,
 			    "RTC Seconds", wm8350);
+	wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_SEC);
 
 	wm8350_register_irq(wm8350, WM8350_IRQ_RTC_ALM,
 			    wm8350_rtc_alarm_handler, 0,
 			    "RTC Alarm", wm8350);
-	wm8350_unmask_irq(wm8350, WM8350_IRQ_RTC_ALM);
 
 	return 0;
 }
@@ -479,8 +476,6 @@ static int __devexit wm8350_rtc_remove(struct platform_device *pdev)
 	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
 	struct wm8350_rtc *wm_rtc = &wm8350->rtc;
 
-	wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_SEC);
-
 	wm8350_free_irq(wm8350, WM8350_IRQ_RTC_SEC);
 	wm8350_free_irq(wm8350, WM8350_IRQ_RTC_ALM);
 
diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
index 2803913..7ee917b 100644
--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -1426,8 +1426,6 @@ int wm8350_hp_jack_detect(struct snd_soc_codec *codec, enum wm8350_jack which,
 	/* Sync status */
 	wm8350_hp_jack_handler(irq, priv);
 
-	wm8350_unmask_irq(wm8350, irq);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wm8350_hp_jack_detect);
@@ -1485,8 +1483,10 @@ static int wm8350_probe(struct platform_device *pdev)
 	wm8350_set_bits(wm8350, WM8350_ROUT2_VOLUME,
 			WM8350_OUT2_VU | WM8350_OUT2R_MUTE);
 
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R);
+	/* Make sure jack detect is disabled to start off with */
+	wm8350_clear_bits(wm8350, WM8350_JACK_DETECT,
+			  WM8350_JDL_ENA | WM8350_JDR_ENA);
+
 	wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L,
 			    wm8350_hp_jack_handler, 0, "Left jack detect",
 			    priv);
@@ -1532,8 +1532,6 @@ static int wm8350_remove(struct platform_device *pdev)
 			  WM8350_JDL_ENA | WM8350_JDR_ENA);
 	wm8350_clear_bits(wm8350, WM8350_POWER_MGMT_4, WM8350_TOCLK_ENA);
 
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L);
-	wm8350_mask_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R);
 
-- 
1.6.5.2

