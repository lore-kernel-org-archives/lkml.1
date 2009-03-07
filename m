Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZCGJ2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZCGJ2N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 04:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZCGJ1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 04:27:41 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:55085 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbZCGJ1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 04:27:37 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] ath5k: don't change mac in eeprom_read_mac on error
Date: Sat,  7 Mar 2009 10:26:42 +0100
Message-Id: <1236418002-2189-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236418002-2189-1-git-send-email-jirislaby@gmail.com>
References: <1236418002-2189-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not touch mac parameter passed to ath5k_eeprom_read_mac unless
we are sure we have correct address. I.e. when returning error, do
not change it.

While at it, use '= {}' compiler trick for memsetting mac_d.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <jirislaby@gmail.com>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/eeprom.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath5k/eeprom.c b/drivers/net/wireless/ath5k/eeprom.c
index a54ee7e..ac45ca4 100644
--- a/drivers/net/wireless/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath5k/eeprom.c
@@ -1418,14 +1418,11 @@ ath5k_eeprom_init(struct ath5k_hw *ah)
  */
 int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
 {
-	u8 mac_d[ETH_ALEN];
+	u8 mac_d[ETH_ALEN] = {};
 	u32 total, offset;
 	u16 data;
 	int octet, ret;
 
-	memset(mac, 0, ETH_ALEN);
-	memset(mac_d, 0, ETH_ALEN);
-
 	ret = ath5k_hw_eeprom_read(ah, 0x20, &data);
 	if (ret)
 		return ret;
@@ -1441,11 +1438,11 @@ int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
 		octet += 2;
 	}
 
-	memcpy(mac, mac_d, ETH_ALEN);
-
 	if (!total || total == 3 * 0xffff)
 		return -EINVAL;
 
+	memcpy(mac, mac_d, ETH_ALEN);
+
 	return 0;
 }
 
-- 
1.6.1.3

