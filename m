Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934967Ab0CMBU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:20:58 -0500
Received: from kroah.org ([198.145.64.141]:60926 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934951Ab0CMAUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:31 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:11 2010
Message-Id: <20100313001511.540224117@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Felix Fietkau <nbd@openwrt.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 073/123] ath9k: disable RIFS search for AR91xx based chips
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Felix Fietkau <nbd@openwrt.org>

commit 7bfbae10dc10a5c94a780d117a57e875d77e8e5a upstream.

While ath9k does not support RIFS yet, the ability to receive RIFS
frames is currently enabled for most chipsets in the initvals.
This is causing baseband related issues on AR9160 and AR9130 based
chipsets, which can lock up under certain conditions.

This patch fixes these issues by overriding the initvals, effectively
disabling RIFS for all affected chipsets.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hw.c  |   10 ++++++++++
 drivers/net/wireless/ath/ath9k/phy.h |    3 +++
 2 files changed, 13 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1345,6 +1345,16 @@ static void ath9k_hw_override_ini(struct
 	 * Necessary to avoid issues on AR5416 2.0
 	 */
 	REG_WRITE(ah, 0x9800 + (651 << 2), 0x11);
+
+	/*
+	 * Disable RIFS search on some chips to avoid baseband
+	 * hang issues.
+	 */
+	if (AR_SREV_9100(ah) || AR_SREV_9160(ah)) {
+		val = REG_READ(ah, AR_PHY_HEAVY_CLIP_FACTOR_RIFS);
+		val &= ~AR_PHY_RIFS_INIT_DELAY;
+		REG_WRITE(ah, AR_PHY_HEAVY_CLIP_FACTOR_RIFS, val);
+	}
 }
 
 static u32 ath9k_hw_def_ini_fixup(struct ath_hw *ah,
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -384,6 +384,9 @@ bool ath9k_hw_set_rf_regs(struct ath_hw
 
 #define AR_PHY_HEAVY_CLIP_ENABLE         0x99E0
 
+#define AR_PHY_HEAVY_CLIP_FACTOR_RIFS    0x99EC
+#define AR_PHY_RIFS_INIT_DELAY         0x03ff0000
+
 #define AR_PHY_M_SLEEP      0x99f0
 #define AR_PHY_REFCLKDLY    0x99f4
 #define AR_PHY_REFCLKPD     0x99f8


