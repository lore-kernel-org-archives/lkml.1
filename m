Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYHAT5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYHAT5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYHAT5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:57:33 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:53267 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYHAT5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:57:32 -0400
Date: Fri, 1 Aug 2008 21:57:16 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Zhu Yi <yi.zhu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>
cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] iwlwifi: Don't use buffer allocated on the stack for led
 names
Message-ID: <alpine.LNX.1.10.0808012143050.2294@titan.stealer.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Fri, 01 Aug 2008 19:57:30 +0000
	Bayes: 0.0000 Tokens: new, 323; hammy, 11; neutral, 5; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
X-Spam-Signature: 68df02588c30d2e0529b876819e306cd804870dd
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having the buffer on the stack and even re-using it for all led devices is bad.
Not being able to resolve the name member of the led device structure to a
meaningful value leads to confusion during ad-hoc debugging and potential
breakage in the future, if we ever decide to access the name member outside of
the registration function. Move the buffer to our private per led device
structures so that it is accessible after registration.

A quick grep didn't yield any occurence of using the led device name parameter
outside of the led device registration function, so currently we should already
be safe for normal operation.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |   33 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-3945-led.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-led.c      |   29 ++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-led.h      |    1 +
 4 files changed, 36 insertions(+), 28 deletions(-)

Patch is based on current (de92dcd) head of the iwlwifi git tree. I could only
test the iwl4965 code due to the lack of hardware.

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 6be1fe1..d333696 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -206,12 +206,12 @@ static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
 static int iwl3945_led_register_led(struct iwl3945_priv *priv,
 				   struct iwl3945_led *led,
 				   enum led_type type, u8 set_led,
-				   const char *name, char *trigger)
+				   char *trigger)
 {
 	struct device *device = wiphy_dev(priv->hw->wiphy);
 	int ret;
 
-	led->led_dev.name = name;
+	led->led_dev.name = led->name;
 	led->led_dev.brightness_set = iwl3945_led_brightness_set;
 	led->led_dev.default_trigger = trigger;
 
@@ -308,7 +308,6 @@ void iwl3945_led_background(struct iwl3945_priv *priv)
 int iwl3945_led_register(struct iwl3945_priv *priv)
 {
 	char *trigger;
-	char name[32];
 	int ret;
 
 	priv->last_blink_rate = 0;
@@ -318,7 +317,8 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 	priv->allow_blinking = 0;
 
 	trigger = ieee80211_get_radio_led_name(priv->hw);
-	snprintf(name, sizeof(name), "iwl-%s:radio",
+	snprintf(priv->led[IWL_LED_TRG_RADIO].name,
+		 sizeof(priv->led[IWL_LED_TRG_RADIO].name), "iwl-%s:radio",
 		 wiphy_name(priv->hw->wiphy));
 
 	priv->led[IWL_LED_TRG_RADIO].led_on = iwl3945_led_on;
@@ -327,19 +327,20 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 
 	ret = iwl3945_led_register_led(priv,
 				   &priv->led[IWL_LED_TRG_RADIO],
-				   IWL_LED_TRG_RADIO, 1,
-				   name, trigger);
+				   IWL_LED_TRG_RADIO, 1, trigger);
+
 	if (ret)
 		goto exit_fail;
 
 	trigger = ieee80211_get_assoc_led_name(priv->hw);
-	snprintf(name, sizeof(name), "iwl-%s:assoc",
+	snprintf(priv->led[IWL_LED_TRG_ASSOC].name,
+		 sizeof(priv->led[IWL_LED_TRG_ASSOC].name), "iwl-%s:assoc",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl3945_led_register_led(priv,
 				   &priv->led[IWL_LED_TRG_ASSOC],
-				   IWL_LED_TRG_ASSOC, 0,
-				   name, trigger);
+				   IWL_LED_TRG_ASSOC, 0, trigger);
+
 	/* for assoc always turn led on */
 	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl3945_led_on;
 	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl3945_led_on;
@@ -349,14 +350,13 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 		goto exit_fail;
 
 	trigger = ieee80211_get_rx_led_name(priv->hw);
-	snprintf(name, sizeof(name), "iwl-%s:RX",
+	snprintf(priv->led[IWL_LED_TRG_RX].name,
+		 sizeof(priv->led[IWL_LED_TRG_RX].name), "iwl-%s:RX",
 		 wiphy_name(priv->hw->wiphy));
 
-
 	ret = iwl3945_led_register_led(priv,
 				   &priv->led[IWL_LED_TRG_RX],
-				   IWL_LED_TRG_RX, 0,
-				   name, trigger);
+				   IWL_LED_TRG_RX, 0, trigger);
 
 	priv->led[IWL_LED_TRG_RX].led_on = iwl3945_led_associated;
 	priv->led[IWL_LED_TRG_RX].led_off = iwl3945_led_associated;
@@ -366,13 +366,14 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 		goto exit_fail;
 
 	trigger = ieee80211_get_tx_led_name(priv->hw);
-	snprintf(name, sizeof(name), "iwl-%s:TX",
+	snprintf(priv->led[IWL_LED_TRG_TX].name,
+		 sizeof(priv->led[IWL_LED_TRG_TX].name), "iwl-%s:TX",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl3945_led_register_led(priv,
 				   &priv->led[IWL_LED_TRG_TX],
-				   IWL_LED_TRG_TX, 0,
-				   name, trigger);
+				   IWL_LED_TRG_TX, 0, trigger);
+
 	priv->led[IWL_LED_TRG_TX].led_on = iwl3945_led_associated;
 	priv->led[IWL_LED_TRG_TX].led_off = iwl3945_led_associated;
 	priv->led[IWL_LED_TRG_TX].led_pattern = iwl3945_led_pattern;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.h b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
index 47b7e0b..2fbd126 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
@@ -50,6 +50,7 @@ enum led_type {
 struct iwl3945_led {
 	struct iwl3945_priv *priv;
 	struct led_classdev led_dev;
+	char name[32];
 
 	int (*led_on) (struct iwl3945_priv *priv, int led_id);
 	int (*led_off) (struct iwl3945_priv *priv, int led_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 311be39..02b5cd0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -242,12 +242,12 @@ static void iwl_led_brightness_set(struct led_classdev *led_cdev,
  */
 static int iwl_leds_register_led(struct iwl_priv *priv, struct iwl_led *led,
 				   enum led_type type, u8 set_led,
-				   const char *name, char *trigger)
+				   char *trigger)
 {
 	struct device *device = wiphy_dev(priv->hw->wiphy);
 	int ret;
 
-	led->led_dev.name = name;
+	led->led_dev.name = led->name;
 	led->led_dev.brightness_set = iwl_led_brightness_set;
 	led->led_dev.default_trigger = trigger;
 
@@ -343,7 +343,6 @@ EXPORT_SYMBOL(iwl_leds_background);
 int iwl_leds_register(struct iwl_priv *priv)
 {
 	char *trigger;
-	char name[32];
 	int ret;
 
 	priv->last_blink_rate = 0;
@@ -352,7 +351,8 @@ int iwl_leds_register(struct iwl_priv *priv)
 	priv->allow_blinking = 0;
 
 	trigger = ieee80211_get_radio_led_name(priv->hw);
-	snprintf(name, sizeof(name), "iwl-%s:radio",
+	snprintf(priv->led[IWL_LED_TRG_RADIO].name,
+		 sizeof(priv->led[IWL_LED_TRG_RADIO].name), "iwl-%s:radio",
 		 wiphy_name(priv->hw->wiphy));
 
 	priv->led[IWL_LED_TRG_RADIO].led_on = iwl4965_led_on_reg;
@@ -360,16 +360,17 @@ int iwl_leds_register(struct iwl_priv *priv)
 	priv->led[IWL_LED_TRG_RADIO].led_pattern = NULL;
 
 	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_RADIO],
-				   IWL_LED_TRG_RADIO, 1, name, trigger);
+				   IWL_LED_TRG_RADIO, 1, trigger);
 	if (ret)
 		goto exit_fail;
 
 	trigger = ieee80211_get_assoc_led_name(priv->hw);
-	snprintf(name, sizeof(name), "iwl-%s:assoc",
+	snprintf(priv->led[IWL_LED_TRG_ASSOC].name,
+		 sizeof(priv->led[IWL_LED_TRG_ASSOC].name), "iwl-%s:assoc",
 		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_ASSOC],
-				   IWL_LED_TRG_ASSOC, 0, name, trigger);
+				   IWL_LED_TRG_ASSOC, 0, trigger);
 
 	/* for assoc always turn led on */
 	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl_led_associate;
@@ -380,11 +381,12 @@ int iwl_leds_register(struct iwl_priv *priv)
 		goto exit_fail;
 
 	trigger = ieee80211_get_rx_led_name(priv->hw);
-	snprintf(name, sizeof(name), "iwl-%s:RX", wiphy_name(priv->hw->wiphy));
-
+	snprintf(priv->led[IWL_LED_TRG_RX].name,
+		 sizeof(priv->led[IWL_LED_TRG_RX].name), "iwl-%s:RX",
+		 wiphy_name(priv->hw->wiphy));
 
 	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_RX],
-				   IWL_LED_TRG_RX, 0, name, trigger);
+				   IWL_LED_TRG_RX, 0, trigger);
 
 	priv->led[IWL_LED_TRG_RX].led_on = iwl_led_associated;
 	priv->led[IWL_LED_TRG_RX].led_off = iwl_led_associated;
@@ -394,9 +396,12 @@ int iwl_leds_register(struct iwl_priv *priv)
 		goto exit_fail;
 
 	trigger = ieee80211_get_tx_led_name(priv->hw);
-	snprintf(name, sizeof(name), "iwl-%s:TX", wiphy_name(priv->hw->wiphy));
+	snprintf(priv->led[IWL_LED_TRG_TX].name,
+		 sizeof(priv->led[IWL_LED_TRG_TX].name), "iwl-%s:TX",
+		 wiphy_name(priv->hw->wiphy));
+
 	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_TX],
-				   IWL_LED_TRG_TX, 0, name, trigger);
+				   IWL_LED_TRG_TX, 0, trigger);
 
 	priv->led[IWL_LED_TRG_TX].led_on = iwl_led_associated;
 	priv->led[IWL_LED_TRG_TX].led_off = iwl_led_associated;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 1980ae5..588c9ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -52,6 +52,7 @@ enum led_type {
 struct iwl_led {
 	struct iwl_priv *priv;
 	struct led_classdev led_dev;
+	char name[32];
 
 	int (*led_on) (struct iwl_priv *priv, int led_id);
 	int (*led_off) (struct iwl_priv *priv, int led_id);
