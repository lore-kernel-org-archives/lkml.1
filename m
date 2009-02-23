Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZBWTag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZBWTag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 14:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbZBWTaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 14:30:21 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44585 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZBWTaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 14:30:19 -0500
Date: Mon, 23 Feb 2009 14:26:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2009-02-23
Message-ID: <20090223192617.GA3553@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here are a couple of fixes, one for an oops and one for a warning.  Also
included is a PCI ID addition.  These are intended for 2.6.29.

Please let me know if there are problems!

Thanks,

John

P.S.  This causes some conflicts with -next.  The ath9k conflict is
simple.  The orinoco conflict involves moving some code from orinoco.c
to orinoco/main.c in -next (where orinoco.c no longer exists).  I have
included a "merge-test" branch in the wireless-next-2.6 tree to provide
and example for the merge when you get to it.

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit 486a87f1e5624096bd1c09e9e716239597d48dca:
  Daniel Lezcano (1):
        netns: fix double free at netns creation

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Andrey Borzenkov (1):
      orinoco: do not resgister NULL pm_notifier function

Larry Finger (1):
      rtl8187: New USB ID's for RTL8187L

Vasanthakumar Thiagarajan (1):
      ath9k: Fix panic upon attach failure

 drivers/net/wireless/ath9k/main.c          |   24 +++++++++++++++++-------
 drivers/net/wireless/orinoco/orinoco.c     |   19 +++++++++++++++----
 drivers/net/wireless/rtl818x/rtl8187_dev.c |   12 ++++++++++++
 3 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 727f067..0e80990 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1538,6 +1538,7 @@ bad2:
 bad:
 	if (ah)
 		ath9k_hw_detach(ah);
+	ath9k_exit_debug(sc);
 
 	return error;
 }
@@ -1545,7 +1546,7 @@ bad:
 static int ath_attach(u16 devid, struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
-	int error = 0;
+	int error = 0, i;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Attach ATH hw\n");
 
@@ -1589,11 +1590,11 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
 	/* initialize tx/rx engine */
 	error = ath_tx_init(sc, ATH_TXBUF);
 	if (error != 0)
-		goto detach;
+		goto error_attach;
 
 	error = ath_rx_init(sc, ATH_RXBUF);
 	if (error != 0)
-		goto detach;
+		goto error_attach;
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	/* Initialze h/w Rfkill */
@@ -1601,8 +1602,9 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
 		INIT_DELAYED_WORK(&sc->rf_kill.rfkill_poll, ath_rfkill_poll);
 
 	/* Initialize s/w rfkill */
-	if (ath_init_sw_rfkill(sc))
-		goto detach;
+	error = ath_init_sw_rfkill(sc);
+	if (error)
+		goto error_attach;
 #endif
 
 	error = ieee80211_register_hw(hw);
@@ -1611,8 +1613,16 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
 	ath_init_leds(sc);
 
 	return 0;
-detach:
-	ath_detach(sc);
+
+error_attach:
+	/* cleanup tx queues */
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
+		if (ATH_TXQ_SETUP(sc, i))
+			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
+
+	ath9k_hw_detach(sc->sc_ah);
+	ath9k_exit_debug(sc);
+
 	return error;
 }
 
diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 45a04fa..067d1a9 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -3157,8 +3157,20 @@ static int orinoco_pm_notifier(struct notifier_block *notifier,
 
 	return NOTIFY_DONE;
 }
+
+static void orinoco_register_pm_notifier(struct orinoco_private *priv)
+{
+	priv->pm_notifier.notifier_call = orinoco_pm_notifier;
+	register_pm_notifier(&priv->pm_notifier);
+}
+
+static void orinoco_unregister_pm_notifier(struct orinoco_private *priv)
+{
+	unregister_pm_notifier(&priv->pm_notifier);
+}
 #else /* !PM_SLEEP || HERMES_CACHE_FW_ON_INIT */
-#define orinoco_pm_notifier NULL
+#define orinoco_register_pm_notifier(priv) do { } while(0)
+#define orinoco_unregister_pm_notifier(priv) do { } while(0)
 #endif
 
 /********************************************************************/
@@ -3648,8 +3660,7 @@ struct net_device
 	priv->cached_fw = NULL;
 
 	/* Register PM notifiers */
-	priv->pm_notifier.notifier_call = orinoco_pm_notifier;
-	register_pm_notifier(&priv->pm_notifier);
+	orinoco_register_pm_notifier(priv);
 
 	return dev;
 }
@@ -3673,7 +3684,7 @@ void free_orinocodev(struct net_device *dev)
 		kfree(rx_data);
 	}
 
-	unregister_pm_notifier(&priv->pm_notifier);
+	orinoco_unregister_pm_notifier(priv);
 	orinoco_uncache_fw(priv);
 
 	priv->wpa_ie_len = 0;
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 22bc07e..f4747a1 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -48,6 +48,10 @@ static struct usb_device_id rtl8187_table[] __devinitdata = {
 	{USB_DEVICE(0x0bda, 0x8189), .driver_info = DEVICE_RTL8187B},
 	{USB_DEVICE(0x0bda, 0x8197), .driver_info = DEVICE_RTL8187B},
 	{USB_DEVICE(0x0bda, 0x8198), .driver_info = DEVICE_RTL8187B},
+	/* Surecom */
+	{USB_DEVICE(0x0769, 0x11F2), .driver_info = DEVICE_RTL8187},
+	/* Logitech */
+	{USB_DEVICE(0x0789, 0x010C), .driver_info = DEVICE_RTL8187},
 	/* Netgear */
 	{USB_DEVICE(0x0846, 0x6100), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0846, 0x6a00), .driver_info = DEVICE_RTL8187},
@@ -57,8 +61,16 @@ static struct usb_device_id rtl8187_table[] __devinitdata = {
 	/* Sitecom */
 	{USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0df6, 0x0028), .driver_info = DEVICE_RTL8187B},
+	/* Sphairon Access Systems GmbH */
+	{USB_DEVICE(0x114B, 0x0150), .driver_info = DEVICE_RTL8187},
+	/* Dick Smith Electronics */
+	{USB_DEVICE(0x1371, 0x9401), .driver_info = DEVICE_RTL8187},
 	/* Abocom */
 	{USB_DEVICE(0x13d1, 0xabe6), .driver_info = DEVICE_RTL8187},
+	/* Qcom */
+	{USB_DEVICE(0x18E8, 0x6232), .driver_info = DEVICE_RTL8187},
+	/* AirLive */
+	{USB_DEVICE(0x1b75, 0x8187), .driver_info = DEVICE_RTL8187},
 	{}
 };
 
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
