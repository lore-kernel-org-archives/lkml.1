Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbXEJQQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbXEJQQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbXEJQQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:16:47 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48647 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbXEJQQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:16:46 -0400
Date: Thu, 10 May 2007 18:12:51 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [another git patch] move USB net drivers to drivers/net
In-Reply-To: <20070510013855.GA3402@havoc.gtf.org>
Message-ID: <Pine.LNX.4.61.0705101735080.24536@yvahk01.tjqt.qr>
References: <20070510013855.GA3402@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,


On May 9 2007 21:38, Jeff Garzik wrote:
>diff --git a/drivers/net/Makefile b/drivers/net/Makefile
>index 59c0459..c5d8423 100644
>--- a/drivers/net/Makefile
>+++ b/drivers/net/Makefile
>@@ -206,6 +206,14 @@ obj-$(CONFIG_TR) += tokenring/
> obj-$(CONFIG_WAN) += wan/
> obj-$(CONFIG_ARCNET) += arcnet/
> obj-$(CONFIG_NET_PCMCIA) += pcmcia/
>+
>+obj-$(CONFIG_USB_CATC)          += usb/
>+obj-$(CONFIG_USB_KAWETH)        += usb/
>+obj-$(CONFIG_USB_PEGASUS)       += usb/
>+obj-$(CONFIG_USB_RTL8150)       += usb/
>+obj-$(CONFIG_USB_USBNET)        += usb/
>+obj-$(CONFIG_USB_ZD1201)        += usb/
>+

This looks, well, a bit ugly. Since we seem to be going in the direction
of using "menuconfig"s (Kconfig language object) anyway, I propose the
patch below.

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
new file mode 100644
index 0000000..3de564b
--- /dev/null
+++ b/drivers/net/usb/Kconfig
@@ -0,0 +1,338 @@
+#
+# USB Network devices configuration
+#
+comment "Networking support is needed for USB Network Adapter support"
+       depends on USB && !NET

This comment is superfluous. If !NET, then NETDEVICES is not even available.
Since you just moved/renamed it, you are not to blame. Though, I remove
it in below's patch (applies on top of
commit 5b2fc499917e5897a13add780e181b4cef197072).


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index c5d8423..5f6112d 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -207,12 +207,7 @@ obj-$(CONFIG_WAN) += wan/
 obj-$(CONFIG_ARCNET) += arcnet/
 obj-$(CONFIG_NET_PCMCIA) += pcmcia/
 
-obj-$(CONFIG_USB_CATC)          += usb/
-obj-$(CONFIG_USB_KAWETH)        += usb/
-obj-$(CONFIG_USB_PEGASUS)       += usb/
-obj-$(CONFIG_USB_RTL8150)       += usb/
-obj-$(CONFIG_USB_USBNET)        += usb/
-obj-$(CONFIG_USB_ZD1201)        += usb/
+obj-$(CONFIG_NETDEV_USB) += usb/
 
 obj-y += wireless/
 obj-$(CONFIG_NET_TULIP) += tulip/
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 3de564b..2458f99 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -1,11 +1,12 @@
 #
 # USB Network devices configuration
 #
-comment "Networking support is needed for USB Network Adapter support"
-	depends on USB && !NET
-
-menu "USB Network Adapters"
+menuconfig NETDEVICES_USB
+	bool "USB Network Adapters"
 	depends on USB && NET
+	default y
+
+if NETDEVICES_USB
 
 config USB_CATC
 	tristate "USB CATC NetMate-based Ethernet device support (EXPERIMENTAL)"
@@ -334,5 +335,4 @@ config USB_NET_ZAURUS
 	  really need this non-conformant variant of CDC Ethernet (or in
 	  some cases CDC MDLM) protocol, not "g_ether".
 
-
-endmenu
+endif # NETDEVICES_USB
#<EOF>

	Jan
-- 
