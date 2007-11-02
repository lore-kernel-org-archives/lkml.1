Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbXKBPsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbXKBPsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760967AbXKBPqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:46:40 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53875 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760952AbXKBPqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:46:38 -0400
Date: Fri, 2 Nov 2007 16:46:15 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Brownell <david-b@pacbell.net>
Cc: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [2.6 patch] usbnet.c: check for the right MII variable
Message-ID: <20071102154615.GS30287@stusta.de>
References: <200711012024.57412.toralf.foerster@gmx.de> <20071101222524.GB7227@stusta.de> <200711011652.39601.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200711011652.39601.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 04:52:39PM -0700, David Brownell wrote:
> On Thursday 01 November 2007, Adrian Bunk wrote:
> > All this USB_USBNET_MII trickery is simply not worth it considering how 
> > few code it saves.
> 
> Depends on what systems you're talking about.  Forcing unused
> code into the kernel is not free, especially if that's made into
> a design policy and applied repeatedly to many subsystems.

If it was turned into a design policy...

My impression is that in some parts of the kernel every byte gets 
counted, while in other parts noone would notice a few kilobytes more or 
less.

> > As a side effect, this also fixes the following compile error reported 
> > by Toralf Förster:
> 
> Why not just fix the thing which changed and broke the build?

Today it's exactly one year since your commit entered the tree.

Dear bug, happy birthday!  ;-)

> Or if reverse dependencies can't be made to work sanely, then
> have those Ethernet-adapter minidrivers depend on NET_ETHERNET
> and then select MII.  (To make the relationships be simple
> enough that current Kconfig can handle them.)

It's not Kconfig's fault that you test for the wrong variable in 
usbnet.c ...

> I have a fair number of usbnet devices.  Not one of them needs
> MII or NET_ETHERNET.

I don't understand why you think this bug was in any way related to 
NET_ETHERNET - set NET_ETHERNET=y and the bug is still present.

If you insist on the #ifdef's take the patch below - it even saves a few 
additional bytes if you have non-usbnet net drivers requiring MII 
enabled statically or as modules in your .config but no usbnet drivers 
requiring MII.

> - Dave

cu
Adrian


<--  snip  -->


This patch fixes the following compile error with CONFIG_MII=m, 
CONFIG_USB_USBNET=y, CONFIG_USB_USBNET_MII=n:

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

This bug was introduced by commit 18ee91fa9815fa3bb4e51cdcb8229bd0a0f11a70
and reported by Toralf Förster.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

BTW:
The Kconfig part of this patch is not really required, but testing for
  #if defined(CONFIG_USB_USBNET_MII) || defined(CONFIG_USB_USBNET_MII_MODULE)
would look needlessly ugly.

 drivers/net/usb/Kconfig  |    5 ++---
 drivers/net/usb/usbnet.c |    7 +++----
 2 files changed, 5 insertions(+), 7 deletions(-)

a421e4910eb30b140a315e274632e87c7a218df6 
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 5a96d74..9261371 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -94,12 +94,11 @@ config USB_RTL8150
 	  module will be called rtl8150.
 
 config USB_USBNET_MII
-	tristate
-	default n
+	bool
 
 config USB_USBNET
 	tristate "Multi-purpose USB Networking Framework"
-	select MII if USB_USBNET_MII != n
+	select MII if USB_USBNET_MII
 	---help---
 	  This driver supports several kinds of network links over USB,
 	  with "minidrivers" built around a common network driver core
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index acd5f1c..7393ab0 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -683,8 +683,7 @@ done_nopm:
  * they'll probably want to use this base set.
  */
 
-#if defined(CONFIG_MII) || defined(CONFIG_MII_MODULE)
-#define HAVE_MII
+#ifdef CONFIG_USB_USBNET_MII
 
 int usbnet_get_settings (struct net_device *net, struct ethtool_cmd *cmd)
 {
@@ -744,7 +743,7 @@ int usbnet_nway_reset(struct net_device *net)
 }
 EXPORT_SYMBOL_GPL(usbnet_nway_reset);
 
-#endif	/* HAVE_MII */
+#endif	/*  CONFIG_USB_USBNET_MII  */
 
 void usbnet_get_drvinfo (struct net_device *net, struct ethtool_drvinfo *info)
 {
@@ -776,7 +775,7 @@ EXPORT_SYMBOL_GPL(usbnet_set_msglevel);
 
 /* drivers may override default ethtool_ops in their bind() routine */
 static struct ethtool_ops usbnet_ethtool_ops = {
-#ifdef	HAVE_MII
+#ifdef CONFIG_USB_USBNET_MII
 	.get_settings		= usbnet_get_settings,
 	.set_settings		= usbnet_set_settings,
 	.get_link		= usbnet_get_link,

