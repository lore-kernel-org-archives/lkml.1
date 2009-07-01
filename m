Return-Path: <linux-kernel-owner+w=401wt.eu-S1762741AbZGABFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762741AbZGABFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761516AbZGAAfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:15 -0400
Received: from kroah.org ([198.145.64.141]:60511 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761482AbZGAAfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:34 2009
Message-Id: <20090701002434.033636810@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 067/108] ath9k: Fix bug when using a card with a busted EEPROM
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ath9k-fix-bug-when-using-a-card-with-a-busted-eeprom.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

backport of commit 85efc86eb7c6cbb1c8ce8d99b10b948be033fbb9 upstream.

We fail if your EEPROM is busted but we were never propagated the
error back so such users could end up with a cryptic oops message
like:

IP: [<f883e1b9>] ath9k_reg_apply_world_flags+0x29/0x130 [ath9k]
*pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: ath9k(+) mac80211 cfg80211
Pid: 4284, comm: insmod Not tainted (2.6.29-wl #3) 7660A14
EIP: 0060:[<f883e1b9>] EFLAGS: 00010286 CPU: 1
EIP is at ath9k_reg_apply_world_flags+0x29/0x130 [ath9k]

Fix this by propagating the error and also lets not leave the
user in the dark and communicate what's going on. When this
happens you will now see this:

ath9k 0000:16:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ath9k: Invalid EEPROM contents

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/main.c |    3 ++-
 drivers/net/wireless/ath9k/regd.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1416,7 +1416,8 @@ static int ath_init(u16 devid, struct at
 	for (i = 0; i < sc->keymax; i++)
 		ath9k_hw_keyreset(ah, (u16) i);
 
-	if (ath9k_regd_init(sc->sc_ah))
+	error = ath9k_regd_init(sc->sc_ah);
+	if (error)
 		goto bad;
 
 	/* default to MONITOR mode */
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -439,7 +439,7 @@ int ath9k_regd_init(struct ath_hw *ah)
 	u16 regdmn;
 
 	if (!ath9k_regd_is_eeprom_valid(ah)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"Invalid EEPROM contents\n");
 		return -EINVAL;
 	}


