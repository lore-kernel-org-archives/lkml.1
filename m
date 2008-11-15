Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbYKOF0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYKOF0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYKOFYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:24:54 -0500
Received: from kroah.org ([198.145.64.141]:50478 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751877AbYKOFYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:24:52 -0500
Date: Fri, 14 Nov 2008 21:22:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Elias Oltmanns <eo@nebensachen.de>
Subject: [patch 04/22] ath5k: Fix reset sequence for AR5212 in general and
	RF5111 in particular
Message-ID: <20081115052254.GE3710@kroah.com>
References: <20081115051732.506914008@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ath5k-fix-reset-sequence-for-ar5212-in-general-and-rf5111-in-particular.patch"
In-Reply-To: <20081115052220.GA3710@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Elias Oltmanns <eo@nebensachen.de>

commit 7d19267b8d1e12c0baebf9be96e04cddffe63f67 upstream

Take care to handle register 0xa228 exactly as in the HAL released by
Atheros. This change is required to make ath5k work again on my system
since commit 2203d6be (ath5k: Misc hw_reset updates), thus fixing a
regression in 2.6.27 and therefore hopefully eligible for inclusion into
a stable release.

v2: Only overwrite initial register values on later revisions of AR5212
    chips.
v3: Use standard macros to manipulate the register.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath5k/hw.c       |   22 +++++++---------------
 drivers/net/wireless/ath5k/initvals.c |    2 ++
 2 files changed, 9 insertions(+), 15 deletions(-)

--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -826,9 +826,10 @@ int ath5k_hw_reset(struct ath5k_hw *ah, 
 		mdelay(1);
 
 		/*
-		 * Write some more initial register settings
+		 * Write some more initial register settings for revised chips
 		 */
-		if (ah->ah_version == AR5K_AR5212) {
+		if (ah->ah_version == AR5K_AR5212 &&
+		    ah->ah_phy_revision > 0x41) {
 			ath5k_hw_reg_write(ah, 0x0002a002, 0x982c);
 
 			if (channel->hw_value == CHANNEL_G)
@@ -847,19 +848,10 @@ int ath5k_hw_reset(struct ath5k_hw *ah, 
 			else
 				ath5k_hw_reg_write(ah, 0x00000000, 0x994c);
 
-			/* Some bits are disabled here, we know nothing about
-			 * register 0xa228 yet, most of the times this ends up
-			 * with a value 0x9b5 -haven't seen any dump with
-			 * a different value- */
-			/* Got this from decompiling binary HAL */
-			data = ath5k_hw_reg_read(ah, 0xa228);
-			data &= 0xfffffdff;
-			ath5k_hw_reg_write(ah, data, 0xa228);
-
-			data = ath5k_hw_reg_read(ah, 0xa228);
-			data &= 0xfffe03ff;
-			ath5k_hw_reg_write(ah, data, 0xa228);
-			data = 0;
+			/* Got this from legacy-hal */
+			AR5K_REG_DISABLE_BITS(ah, 0xa228, 0x200);
+
+			AR5K_REG_MASKED_BITS(ah, 0xa228, 2 << 10, ~0x1fc00);
 
 			/* Just write 0x9b5 ? */
 			/* ath5k_hw_reg_write(ah, 0x000009b5, 0xa228); */
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -810,6 +810,8 @@ static const struct ath5k_ini_mode ar521
 		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ AR5K_PHY(642),
 		{ 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
+	{ 0xa228,
+		{ 0x000001b5, 0x000001b5, 0x000001b5, 0x000001b5, 0x000001b5 } },
 	{ 0xa23c,
 		{ 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af } },
 };

-- 
