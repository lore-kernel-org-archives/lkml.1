Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbZE2Nak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbZE2Nak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757425AbZE2Nac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:30:32 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50175 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948AbZE2Nab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:30:31 -0400
Date: Fri, 29 May 2009 15:28:59 +0200
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2009-05-29
Message-ID: <20090529132858.GA3520@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here are a couple of fixes that would be nice to have for 2.6.30 --
nothing very controversial.  Each has a bugzilla.kernel.org entry listed
in the changelog.

Please let me know if there are problems!

Thanks,

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit 4d3383d0adb6d1047fb9ee3edd9dc05e4d2184f0:
  David S. Miller (1):
        Merge branch 'master' of git://git.kernel.org/.../kaber/nf-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

John W. Linville (2):
      at76c50x-usb: avoid mutex deadlock in at76_dwork_hw_scan
      rtl8187: add USB ID for Linksys WUSB54GC-EU v2 USB wifi dongle

 drivers/net/wireless/Kconfig               |    1 +
 drivers/net/wireless/at76c50x-usb.c        |   12 ++++++------
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 ++
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 8a08235..3d94e7d 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -430,6 +430,7 @@ config RTL8187
 	  ASUS P5B Deluxe
 	  Toshiba Satellite Pro series of laptops
 	  Asus Wireless Link
+	  Linksys WUSB54GC-EU
 
 	  Thanks to Realtek for their support!
 
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 744f4f4..8d93ca4 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1873,18 +1873,18 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 	if (ret != CMD_STATUS_COMPLETE) {
 		queue_delayed_work(priv->hw->workqueue, &priv->dwork_hw_scan,
 				   SCAN_POLL_INTERVAL);
-		goto exit;
+		mutex_unlock(&priv->mtx);
+		return;
 	}
 
-	ieee80211_scan_completed(priv->hw, false);
-
 	if (is_valid_ether_addr(priv->bssid))
 		at76_join(priv);
 
-	ieee80211_wake_queues(priv->hw);
-
-exit:
 	mutex_unlock(&priv->mtx);
+
+	ieee80211_scan_completed(priv->hw, false);
+
+	ieee80211_wake_queues(priv->hw);
 }
 
 static int at76_hw_scan(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index bac6cfb..d51ba0a 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -71,6 +71,8 @@ static struct usb_device_id rtl8187_table[] __devinitdata = {
 	{USB_DEVICE(0x18E8, 0x6232), .driver_info = DEVICE_RTL8187},
 	/* AirLive */
 	{USB_DEVICE(0x1b75, 0x8187), .driver_info = DEVICE_RTL8187},
+	/* Linksys */
+	{USB_DEVICE(0x1737, 0x0073), .driver_info = DEVICE_RTL8187B},
 	{}
 };
 
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
