Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbZGNUhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbZGNUhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 16:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbZGNUhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 16:37:17 -0400
Received: from server1.wserver.cz ([82.113.45.157]:45739 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbZGNUhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 16:37:16 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: luciano.coelho@nokia.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH v2] wireless: wl12xx, fix lock imbalance
Date: Tue, 14 Jul 2009 22:37:13 +0200
Message-Id: <1247603833-10862-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omitted mutex_unlock to one of wl12xx_op_start fail paths (when
wl12xx_chip_wakeup fails).

[v2]
Power off the device, because:
\= cite from http://marc.info/?l=linux-kernel&m=124755028209880&w=2
If the chip cannot be booted, why should it remain powered on?
In some rare cases, the chip might fail to initialize, but can
recover if powered off and on again, so turning it off at this
point is the right thing to do. =/

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 603d611..d30683c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -336,7 +336,7 @@ static int wl12xx_op_start(struct ieee80211_hw *hw)
 
 	ret = wl12xx_chip_wakeup(wl);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ret = wl->chip.op_boot(wl);
 	if (ret < 0)
-- 
1.6.3.2

