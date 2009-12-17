Return-Path: <linux-kernel-owner+w=401wt.eu-S936417AbZLQESf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936417AbZLQESf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936403AbZLQERw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:17:52 -0500
Received: from kroah.org ([198.145.64.141]:55901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936150AbZLQEFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:24 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:58 2009
Message-Id: <20091217035658.407255478@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Kyungwan Nam <kyungwan.nam@atheros.com>,
       Bennyam Malavazi <bennyam.malavazi@atheros.com>,
       Stephen Chen <stephen.chen@atheros.com>,
       Shan Palanisamy <shan.palanisamy@atheros.com>,
       Paul Shaw <paul.shaw@atheros.com>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [119/151] ath9k: Fix maximum tx fifo settings for single stream devices
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Luis R. Rodriguez" <lrodriguez@atheros.com>

This is a backport of upstream commit: f4709fdf683e1ed37b321c258b614ebe39752bf3

Atheros single stream AR9285 and AR9271 have half the PCU TX FIFO
buffer size of that of dual stream devices. Dual stream devices
have a max PCU TX FIFO size of 8 KB while single stream devices
have 4 KB. Single stream devices have an issue though and require
hardware only to use half of the amount of its capable PCU TX FIFO
size, 2 KB and this requires a change in software.

Technically a change would not have been required (except for frame
burst considerations of 128 bytes) if these devices would have been
able to use the full 4 KB of the PCU TX FIFO size but our systems
engineers recommend 2 KB to be used only. We enforce this through
software by reducing the max frame triggger level to 2 KB.

Fixing the max frame trigger level should then have a few benefits:

  * The PER will now be adjusted as designed for underruns when the
    max trigger level is reached. This should help alleviate the
    bus as the rate control algorithm chooses a slower rate which
    should ensure frames are transmitted properly under high system
    bus load.

  * The poll we use on our TX queues should now trigger and work
    as designed for single stream devices. The hardware passes
    data from each TX queue on the PCU TX FIFO queue respecting each
    queue's priority. The new trigger level ensures this seeding of
    the PCU TX FIFO queue occurs as designed which could mean avoiding
    false resets and actually reseting hw correctly when a TX queue
    is indeed stuck.

  * Some undocumented / unsupported behaviour could have been triggered
    when the max trigger level level was being set to 4 KB on single
    stream devices. Its not clear what this issue was to me yet.

Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Cc: Bennyam Malavazi <bennyam.malavazi@atheros.com>
Cc: Stephen Chen <stephen.chen@atheros.com>
Cc: Shan Palanisamy <shan.palanisamy@atheros.com>
Cc: Paul Shaw <paul.shaw@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   11 ++++++++++-
 drivers/net/wireless/ath/ath9k/hw.h  |    1 +
 drivers/net/wireless/ath/ath9k/mac.c |    4 ++--
 3 files changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -937,6 +937,11 @@ int ath9k_hw_init(struct ath_hw *ah)
 	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "serialize_regmode is %d\n",
 		ah->config.serialize_regmode);
 
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
+		ah->config.max_txtrig_level = MAX_TX_FIFO_THRESHOLD >> 1;
+	else
+		ah->config.max_txtrig_level = MAX_TX_FIFO_THRESHOLD;
+
 	if (!ath9k_hw_macversion_supported(ah->hw_version.macVersion)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"Mac Chip Rev 0x%02x.%x is not supported by "
@@ -3670,7 +3675,11 @@ void ath9k_hw_fill_cap_info(struct ath_h
 		pCap->keycache_size = AR_KEYTABLE_SIZE;
 
 	pCap->hw_caps |= ATH9K_HW_CAP_FASTCC;
-	pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD;
+
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
+		pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD >> 1;
+	else
+		pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD;
 
 	if (AR_SREV_9285_10_OR_LATER(ah))
 		pCap->num_gpio_pins = AR9285_NUM_GPIO;
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -218,6 +218,7 @@ struct ath9k_ops_config {
 #define AR_SPUR_FEEQ_BOUND_HT20 10
 	int spurmode;
 	u16 spurchans[AR_EEPROM_MODAL_SPURS][2];
+	u8 max_txtrig_level;
 };
 
 enum ath9k_int {
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -70,7 +70,7 @@ bool ath9k_hw_updatetxtriglevel(struct a
 	u32 txcfg, curLevel, newLevel;
 	enum ath9k_int omask;
 
-	if (ah->tx_trig_level >= MAX_TX_FIFO_THRESHOLD)
+	if (ah->tx_trig_level >= ah->config.max_txtrig_level)
 		return false;
 
 	omask = ath9k_hw_set_interrupts(ah, ah->mask_reg & ~ATH9K_INT_GLOBAL);
@@ -79,7 +79,7 @@ bool ath9k_hw_updatetxtriglevel(struct a
 	curLevel = MS(txcfg, AR_FTRIG);
 	newLevel = curLevel;
 	if (bIncTrigLevel) {
-		if (curLevel < MAX_TX_FIFO_THRESHOLD)
+		if (curLevel < ah->config.max_txtrig_level)
 			newLevel++;
 	} else if (curLevel > MIN_TX_FIFO_THRESHOLD)
 		newLevel--;


