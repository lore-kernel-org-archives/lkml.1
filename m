Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZIUJwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZIUJwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZIUJwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:52:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54132 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZIUJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:52:13 -0400
Subject: [PATCH 2/2] w35und: Fix ->configure_filter breakage
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, jbenc@suse.cz, jkosina@suse.cz, johannes@sipsolutions.net,
       pavel@ucw.cz, sandro.bonazzola@gmail.com
Date: Mon, 21 Sep 2009 12:52:16 +0300
Message-Id: <1253526736.5216.8.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Commit 3ac64beecd27400d12cc7afb4108eef26c499f6a ("mac80211: allow
configure_filter callback to sleep") ->configure_filter function
signature. Fix driver breakage by introducing a ->prepare_multicast
operation that returns "mc_count". I'm not sure if the "mc_count > 32"
check is actually needed but lets keep the driver functionally
equivalent for now.

Cc: Greg KH <greg@kroah.com>
Cc: Jiri Benc <jbenc@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index ee6425e..4bf1057 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -99,10 +99,16 @@ static int wbsoft_get_tx_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static u64 wbsoft_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
+				    struct dev_addr_list *mclist)
+{
+	return mc_count;
+}
+
 static void wbsoft_configure_filter(struct ieee80211_hw *dev,
 				    unsigned int changed_flags,
 				    unsigned int *total_flags,
-				    int mc_count, struct dev_mc_list *mclist)
+				    u64 multicast)
 {
 	unsigned int new_flags;
 
@@ -110,7 +116,7 @@ static void wbsoft_configure_filter(struct ieee80211_hw *dev,
 
 	if (*total_flags & FIF_PROMISC_IN_BSS)
 		new_flags |= FIF_PROMISC_IN_BSS;
-	else if ((*total_flags & FIF_ALLMULTI) || (mc_count > 32))
+	else if ((*total_flags & FIF_ALLMULTI) || (multicast > 32))
 		new_flags |= FIF_ALLMULTI;
 
 	dev->flags &= ~IEEE80211_HW_RX_INCLUDES_FCS;
@@ -278,6 +284,7 @@ static const struct ieee80211_ops wbsoft_ops = {
 	.add_interface		= wbsoft_add_interface,
 	.remove_interface	= wbsoft_remove_interface,
 	.config			= wbsoft_config,
+	.prepare_multicast	= wbsoft_prepare_multicast,
 	.configure_filter	= wbsoft_configure_filter,
 	.get_stats		= wbsoft_get_stats,
 	.get_tx_stats		= wbsoft_get_tx_stats,
-- 
1.5.6.3



