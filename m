Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbZFRXHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbZFRXHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 19:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758665AbZFRXHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 19:07:33 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:54150 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285AbZFRXHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 19:07:33 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/1] ath5k: fix beacon_int handling
Date: Fri, 19 Jun 2009 01:06:45 +0200
Message-Id: <1245366405-27426-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

73ca5203366235f8a43e490767284ba8cfd8c479
(ath5k: remove conf->beacon_int usage)
removed bintval setting from ath5k_config. We need to init the
interval earlier and don't touch it in add_interface anymore.

Otherwise it will be set only once by upper layer through
bss_info_changed but not on second and further hostap executions.

We ended up having bintval 1000 which rendered the AP useless on
many clients.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 55f7de0..70ba861 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -538,6 +538,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	sc->iobase = mem; /* So we can unmap it on detach */
 	sc->cachelsz = csz * sizeof(u32); /* convert to bytes */
 	sc->opmode = NL80211_IFTYPE_STATION;
+	sc->bintval = 1000;
 	mutex_init(&sc->lock);
 	spin_lock_init(&sc->rxbuflock);
 	spin_lock_init(&sc->txbuflock);
@@ -2748,9 +2749,6 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 		goto end;
 	}
 
-	/* Set to a reasonable value. Note that this will
-	 * be set to mac80211's value at ath5k_config(). */
-	sc->bintval = 1000;
 	ath5k_hw_set_lladdr(sc->ah, conf->mac_addr);
 
 	ret = 0;
-- 
1.6.3.2

