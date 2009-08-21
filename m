Return-Path: <linux-kernel-owner+w=401wt.eu-S932576AbZHURPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbZHURPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932391AbZHURPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:15:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33918 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbZHURPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:15:18 -0400
Date: Fri, 21 Aug 2009 13:03:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2009-08-21
Message-ID: <20090821170324.GC8532@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

One more straggler for 2.6.31...without this rtl8187b devices simply
don't work. :-(

The patch is small and isolated to rtl8187.  I think we should take
it for 2.6.31.

Please let me know if there are problems!

John

---

Patch available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit 08fdef99342955a62884fb5c49ab43431a1cafbf:
  David S. Miller (1):
        Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Herton Ronaldo Krzesinski (1):
      rtl8187: always set MSR_LINK_ENEDCA flag with RTL8187B

 drivers/net/wireless/rtl818x/rtl8187_dev.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 294250e..87a9558 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -869,6 +869,9 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	priv->aifsn[3] = 3; /* AIFSN[AC_BE] */
 	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);
 
+	/* ENEDCA flag must always be set, transmit issues? */
+	rtl818x_iowrite8(priv, &priv->map->MSR, RTL818X_MSR_ENEDCA);
+
 	return 0;
 }
 
@@ -1173,13 +1176,16 @@ static void rtl8187_bss_info_changed(struct ieee80211_hw *dev,
 			rtl818x_iowrite8(priv, &priv->map->BSSID[i],
 					 info->bssid[i]);
 
+		if (priv->is_rtl8187b)
+			reg = RTL818X_MSR_ENEDCA;
+		else
+			reg = 0;
+
 		if (is_valid_ether_addr(info->bssid)) {
-			reg = RTL818X_MSR_INFRA;
-			if (priv->is_rtl8187b)
-				reg |= RTL818X_MSR_ENEDCA;
+			reg |= RTL818X_MSR_INFRA;
 			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
 		} else {
-			reg = RTL818X_MSR_NO_LINK;
+			reg |= RTL818X_MSR_NO_LINK;
 			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
 		}
 
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
