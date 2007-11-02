Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbXKBSpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbXKBSpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 14:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbXKBSpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 14:45:20 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:45277 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756795AbXKBSpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:45:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LyLFVGEVSNSUBdn87p9i7pJLYTulloLexVgKcvx9W8nJFOOrysTZWpXJVwK2msv2uw4iEpe3WZJLUPdNzNjoQXwcilhiM8l6ipx01KkeM10pM2GrxuJSMCqy3L8YxqSj1TVIko1U/LXzXi2jHi+FxUIdhUrqbLXzisCs45i6Eiw=  ;
X-YMail-OSG: oxWpzr0VM1mUt.6o9mybYtPVEL8I43VxCl4YJMU4qJxKhsTLSWvkWkmZ6hSjtXxnHO2Xj2yePA--
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: build #337 failed for 2.6.24-rc1-gb1d08ac In function `usbnet_set_settings':
Date: Fri, 2 Nov 2007 11:45:15 -0700
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
References: <200711012024.57412.toralf.foerster@gmx.de> <200711011632.18333.david-b@pacbell.net> <20071101234443.GD7227@stusta.de>
In-Reply-To: <20071101234443.GD7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711021145.15542.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007, Adrian Bunk wrote:
> The following combination of options is simply an unusual one:
> 
> CONFIG_MII=m
> CONFIG_USB_USBNET=y
> CONFIG_USB_USBNET_MII=n

I though that had been fixed for ages ...

This should do a better job of it.

- Dave

==========	CUT HERE
Simplify handling of the MII-dependent usbnet based adapters:  stick
to forward dependencies, and explicitly handle the core dependency.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/net/usb/Kconfig  |   23 ++++++++++++-----------
 drivers/net/usb/usbnet.c |    9 ++++++++-
 2 files changed, 20 insertions(+), 12 deletions(-)

--- a.orig/drivers/net/usb/Kconfig	2007-10-21 10:35:16.000000000 -0700
+++ a/drivers/net/usb/Kconfig	2007-11-02 11:32:15.000000000 -0700
@@ -93,13 +93,8 @@ config USB_RTL8150
 	  To compile this driver as a module, choose M here: the
 	  module will be called rtl8150.
 
-config USB_USBNET_MII
-	tristate
-	default n
-
 config USB_USBNET
 	tristate "Multi-purpose USB Networking Framework"
-	select MII if USB_USBNET_MII != n
 	---help---
 	  This driver supports several kinds of network links over USB,
 	  with "minidrivers" built around a common network driver core
@@ -131,11 +126,19 @@ config USB_USBNET
 	  To compile this driver as a module, choose M here: the
 	  module will be called usbnet.
 
+# usbnet core will support MII when MII is static, or both are modules
+config USB_NET_MII
+	tristate
+	depends on USB_USBNET && NET_ETHERNET && (MII = y || MII = USB_USBNET)
+	default MII
+
+comment "MII support is needed for most Ethernet adapters"
+	depends on USB_USBNET && USB_NET_MII=n
+
 config USB_NET_AX8817X
 	tristate "ASIX AX88xxx Based USB 2.0 Ethernet Adapters"
-	depends on USB_USBNET && NET_ETHERNET
+	depends on USB_USBNET && USB_NET_MII
 	select CRC32
-	select USB_USBNET_MII
 	default y
 	help
 	  This option adds support for ASIX AX88xxx based USB 2.0
@@ -188,9 +191,8 @@ config USB_NET_CDCETHER
 
 config USB_NET_DM9601
 	tristate "Davicom DM9601 based USB 1.1 10/100 ethernet devices"
-	depends on USB_USBNET
+	depends on USB_USBNET && USB_NET_MII
 	select CRC32
-	select USB_USBNET_MII
 	help
 	  This option adds support for Davicom DM9601 based USB 1.1
 	  10/100 Ethernet adapters.
@@ -224,8 +226,7 @@ config USB_NET_PLUSB
 
 config USB_NET_MCS7830
 	tristate "MosChip MCS7830 based Ethernet adapters"
-	depends on USB_USBNET
-	select USB_USBNET_MII
+	depends on USB_USBNET && USB_NET_MII
 	help
 	  Choose this option if you're using a 10/100 Ethernet USB2
 	  adapter based on the MosChip 7830 controller. This includes
--- a.orig/drivers/net/usb/usbnet.c	2007-10-13 15:16:10.000000000 -0700
+++ a/drivers/net/usb/usbnet.c	2007-11-02 11:39:59.000000000 -0700
@@ -682,10 +682,17 @@ done_nopm:
 /* ethtool methods; minidrivers may need to add some more, but
  * they'll probably want to use this base set.
  */
+#undef HAVE_MII
 
-#if defined(CONFIG_MII) || defined(CONFIG_MII_MODULE)
+#if defined(CONFIG_MII)
 #define HAVE_MII
 
+#elif defined(CONFIG_MII_MODULE) && defined(MODULE)
+#define HAVE_MII
+#endif
+
+#ifdef HAVE_MII
+
 int usbnet_get_settings (struct net_device *net, struct ethtool_cmd *cmd)
 {
 	struct usbnet *dev = netdev_priv(net);

