Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903Ab0AEApA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0AEApA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530Ab0AEAo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:44:56 -0500
Received: from kroah.org ([198.145.64.141]:34391 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391Ab0AEAfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:38 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes@sipsolutions.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 56/97] iwlwifi: fix more eeprom endian bugs
Date: Mon,  4 Jan 2010 16:33:09 -0800
Message-Id: <1262651630-7354-56-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

commit b7bb1756cb6a610cdbac8cfdad9e79bb5670b63b upstream.

I've also for a long time had a problem with the
temperature calculation code, which I had fixed
by byte-swapping the values, and now it turns out
that was the correct fix after all.

Also, any use of iwl_eeprom_query_addr() that is
for more than a u8 must be cast to little endian,
and some structs as well.

Fix all this. Again, no real impact on platforms
that already are little endian.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h |   14 +++++++++-----
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h  |    4 ++--
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6f703a0..f4e2e84 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1337,7 +1337,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	iwl4965_interpolate_chan(priv, channel, &ch_eeprom_info);
 
 	/* calculate tx gain adjustment based on power supply voltage */
-	voltage = priv->calib_info->voltage;
+	voltage = le16_to_cpu(priv->calib_info->voltage);
 	init_voltage = (s32)le32_to_cpu(priv->card_alive_init.voltage);
 	voltage_compensation =
 	    iwl4965_get_voltage_compensation(voltage, init_voltage);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 4ef6804..bc056e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -92,11 +92,15 @@
 
 static inline s32 iwl_temp_calib_to_offset(struct iwl_priv *priv)
 {
-	u16 *temp_calib = (u16 *)iwl_eeprom_query_addr(priv,
-						       EEPROM_5000_TEMPERATURE);
-	/* offset =  temperature -  voltage / coef */
-	s32 offset = (s32)(temp_calib[0] - temp_calib[1] / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF);
-	return offset;
+	u16 temperature, voltage;
+	__le16 *temp_calib =
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_TEMPERATURE);
+
+	temperature = le16_to_cpu(temp_calib[0]);
+	voltage = le16_to_cpu(temp_calib[1]);
+
+	/* offset = temp - volt / coeff */
+	return (s32)(temperature - voltage / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF);
 }
 
 /* Fixed (non-configurable) rx data from phy */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 6e6f516..94a1225 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -460,14 +460,15 @@ static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
 static int iwl5000_set_Xtal_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_xtal_freq_cmd cmd;
-	u16 *xtal_calib = (u16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_XTAL);
+	__le16 *xtal_calib =
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_XTAL);
 
 	cmd.hdr.op_code = IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD;
 	cmd.hdr.first_group = 0;
 	cmd.hdr.groups_num = 1;
 	cmd.hdr.data_valid = 1;
-	cmd.cap_pin1 = (u8)xtal_calib[0];
-	cmd.cap_pin2 = (u8)xtal_calib[1];
+	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
+	cmd.cap_pin2 = le16_to_cpu(xtal_calib[1]);
 	return iwl_calib_set(&priv->calib_results[IWL_CALIB_XTAL],
 			     (u8 *)&cmd, sizeof(cmd));
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 80b9e45..fc93f12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -133,7 +133,7 @@ struct iwl_eeprom_channel {
  *
  */
 struct iwl_eeprom_enhanced_txpwr {
-	u16 reserved;
+	__le16 common;
 	s8 chain_a_max;
 	s8 chain_b_max;
 	s8 chain_c_max;
@@ -347,7 +347,7 @@ struct iwl_eeprom_calib_subband_info {
 struct iwl_eeprom_calib_info {
 	u8 saturation_power24;	/* half-dBm (e.g. "34" = 17 dBm) */
 	u8 saturation_power52;	/* half-dBm */
-	s16 voltage;		/* signed */
+	__le16 voltage;		/* signed */
 	struct iwl_eeprom_calib_subband_info
 		band_info[EEPROM_TX_POWER_BANDS];
 } __attribute__ ((packed));
-- 
1.6.6

