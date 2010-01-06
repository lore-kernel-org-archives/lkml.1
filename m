Return-Path: <linux-kernel-owner+w=401wt.eu-S932644Ab0AFTYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab0AFTYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120Ab0AFTY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:24:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45755 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756140Ab0AFTY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:24:28 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Update WM8350 drivers for changed interrupt numbers
Date: Wed,  6 Jan 2010 19:24:25 +0000
Message-Id: <1262805865-15605-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The headphone detect and charger are using the IRQ numbers so need
to take account of irq_base with the genirq conversion. I obviously
picked the wrong system for initial testing.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/wm8350_power.c |    2 +-
 sound/soc/codecs/wm8350.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/wm8350_power.c b/drivers/power/wm8350_power.c
index 3839a5e..0693902 100644
--- a/drivers/power/wm8350_power.c
+++ b/drivers/power/wm8350_power.c
@@ -190,7 +190,7 @@ static irqreturn_t wm8350_charger_handler(int irq, void *data)
 	struct wm8350_power *power = &wm8350->power;
 	struct wm8350_charger_policy *policy = power->policy;
 
-	switch (irq) {
+	switch (irq - wm8350->irq_base) {
 	case WM8350_IRQ_CHG_BAT_FAIL:
 		dev_err(wm8350->dev, "battery failed\n");
 		break;
diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
index f45845a..93f1e4e 100644
--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -1349,7 +1349,7 @@ static irqreturn_t wm8350_hp_jack_handler(int irq, void *data)
 	int mask;
 	struct wm8350_jack_data *jack = NULL;
 
-	switch (irq) {
+	switch (irq - wm8350->irq_base) {
 	case WM8350_IRQ_CODEC_JCK_DET_L:
 		jack = &priv->hpl;
 		mask = WM8350_JACK_L_LVL;
@@ -1424,7 +1424,7 @@ int wm8350_hp_jack_detect(struct snd_soc_codec *codec, enum wm8350_jack which,
 	wm8350_set_bits(wm8350, WM8350_JACK_DETECT, ena);
 
 	/* Sync status */
-	wm8350_hp_jack_handler(irq, priv);
+	wm8350_hp_jack_handler(irq + wm8350->irq_base, priv);
 
 	return 0;
 }
-- 
1.6.5.7

