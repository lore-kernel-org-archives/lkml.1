Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab0BDRX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:23:27 -0500
Received: from kroah.org ([198.145.64.141]:34996 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933385Ab0BDRWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:34 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:29 2010
Message-Id: <20100204171528.884576832@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Felix Fietkau <nbd@openwrt.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [72/74] ath9k: fix eeprom INI values override for 2GHz-only cards
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit aa8bc9ef18a2c5b2b97e1f36ee9604cf15743f96 upstream.

Among other changes, this commit:

   commit 06d0f0663e11cab4ec5f2c143a118d71a12fbbe9
   Author: Sujith <Sujith.Manoharan@atheros.com>
   Date:   Thu Feb 12 10:06:45 2009 +0530

   ath9k: Enable Fractional N mode

changed the hw attach code to fix up initialization values only for
dual band devices, however the commit message did not give a reason as
to why this would be useful or necessary.

According to tests by Jorge Boncompte, this breaks at least some
2GHz-only cards, so the code should be changed back to the
unconditional INI fixup.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Jorge Boncompte <jorge@dti2.net>
Tested-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hw.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -880,12 +880,11 @@ static void ath9k_hw_init_mode_gain_regs
 	}
 }
 
-static void ath9k_hw_init_11a_eeprom_fix(struct ath_hw *ah)
+static void ath9k_hw_init_eeprom_fix(struct ath_hw *ah)
 {
 	u32 i, j;
 
-	if ((ah->hw_version.devid == AR9280_DEVID_PCI) &&
-	    test_bit(ATH9K_MODE_11A, ah->caps.wireless_modes)) {
+	if (ah->hw_version.devid == AR9280_DEVID_PCI) {
 
 		/* EEPROM Fixup */
 		for (i = 0; i < ah->iniModes.ia_rows; i++) {
@@ -980,7 +979,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 
 	ath9k_hw_init_mode_gain_regs(ah);
 	ath9k_hw_fill_cap_info(ah);
-	ath9k_hw_init_11a_eeprom_fix(ah);
+	ath9k_hw_init_eeprom_fix(ah);
 
 	r = ath9k_hw_init_macaddr(ah);
 	if (r) {


