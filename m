Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbXKAWZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbXKAWZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXKAWZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:25:44 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40641 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753079AbXKAWZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:25:43 -0400
Date: Thu, 1 Nov 2007 23:25:24 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       dbrownell@users.sourceforge.net, jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [2.6 patch] let USB_USBNET always select MII
Message-ID: <20071101222524.GB7227@stusta.de>
References: <200711012024.57412.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200711012024.57412.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All this USB_USBNET_MII trickery is simply not worth it considering how 
few code it saves.

As a side effect, this also fixes the following compile error reported 
by Toralf Förster:

<--  snip  -->

...
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `usbnet_set_settings':
(.text+0xf1876): undefined reference to `mii_ethtool_sset'
drivers/built-in.o: In function `usbnet_get_settings':
(.text+0xf1836): undefined reference to `mii_ethtool_gset'
drivers/built-in.o: In function `usbnet_get_link':
(.text+0xf18d6): undefined reference to `mii_link_ok'
drivers/built-in.o: In function `usbnet_nway_reset':
(.text+0xf18f6): undefined reference to `mii_nway_restart'
make: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/net/usb/Kconfig  |    9 +--------
 drivers/net/usb/usbnet.c |    7 -------
 2 files changed, 1 insertion(+), 15 deletions(-)

3b7f6290c639b9042fead1698fdbe1c84132c953 
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 5a96d74..a12c9c4 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -93,13 +93,9 @@ config USB_RTL8150
 	  To compile this driver as a module, choose M here: the
 	  module will be called rtl8150.
 
-config USB_USBNET_MII
-	tristate
-	default n
-
 config USB_USBNET
 	tristate "Multi-purpose USB Networking Framework"
-	select MII if USB_USBNET_MII != n
+	select MII
 	---help---
 	  This driver supports several kinds of network links over USB,
 	  with "minidrivers" built around a common network driver core
@@ -135,7 +131,6 @@ config USB_NET_AX8817X
 	tristate "ASIX AX88xxx Based USB 2.0 Ethernet Adapters"
 	depends on USB_USBNET && NET_ETHERNET
 	select CRC32
-	select USB_USBNET_MII
 	default y
 	help
 	  This option adds support for ASIX AX88xxx based USB 2.0
@@ -190,7 +185,6 @@ config USB_NET_DM9601
 	tristate "Davicom DM9601 based USB 1.1 10/100 ethernet devices"
 	depends on USB_USBNET
 	select CRC32
-	select USB_USBNET_MII
 	help
 	  This option adds support for Davicom DM9601 based USB 1.1
 	  10/100 Ethernet adapters.
@@ -225,7 +219,6 @@ config USB_NET_PLUSB
 config USB_NET_MCS7830
 	tristate "MosChip MCS7830 based Ethernet adapters"
 	depends on USB_USBNET
-	select USB_USBNET_MII
 	help
 	  Choose this option if you're using a 10/100 Ethernet USB2
 	  adapter based on the MosChip 7830 controller. This includes
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index acd5f1c..8ed1fc5 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -683,9 +683,6 @@ done_nopm:
  * they'll probably want to use this base set.
  */
 
-#if defined(CONFIG_MII) || defined(CONFIG_MII_MODULE)
-#define HAVE_MII
-
 int usbnet_get_settings (struct net_device *net, struct ethtool_cmd *cmd)
 {
 	struct usbnet *dev = netdev_priv(net);
@@ -744,8 +741,6 @@ int usbnet_nway_reset(struct net_device *net)
 }
 EXPORT_SYMBOL_GPL(usbnet_nway_reset);
 
-#endif	/* HAVE_MII */
-
 void usbnet_get_drvinfo (struct net_device *net, struct ethtool_drvinfo *info)
 {
 	struct usbnet *dev = netdev_priv(net);
@@ -776,12 +771,10 @@ EXPORT_SYMBOL_GPL(usbnet_set_msglevel);
 
 /* drivers may override default ethtool_ops in their bind() routine */
 static struct ethtool_ops usbnet_ethtool_ops = {
-#ifdef	HAVE_MII
 	.get_settings		= usbnet_get_settings,
 	.set_settings		= usbnet_set_settings,
 	.get_link		= usbnet_get_link,
 	.nway_reset		= usbnet_nway_reset,
-#endif
 	.get_drvinfo		= usbnet_get_drvinfo,
 	.get_msglevel		= usbnet_get_msglevel,
 	.set_msglevel		= usbnet_set_msglevel,
