Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbZK3Jyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbZK3Jyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZK3Jyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:54:39 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46169 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbZK3Jyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:54:36 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 30 Nov 2009 10:55:40 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: Added USB_ETH_RNDIS to use instead of CONFIG_USB_ETH_RNDIS
In-reply-to: <20091128103429.705670b2.randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <1259574940-25345-1-git-send-email-m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.6.5
References: <20091128103429.705670b2.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <m.nazarewicz@samsung.com>

If g_ether and g_multi are both built CONFIG_USB_ETH_RNDIS symbol
may be redefined in the later and, whats even worse, g_ether's settings
may affect g_multi's.  This adds a USB_ETH_RNDIS symbol defined at the
beginning of ether.c and multi.c according toproper KConfig settings.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/usb/gadget/ether.c   |   16 ++++++++++++----
 drivers/usb/gadget/multi.c   |   13 ++++++++-----
 drivers/usb/gadget/u_ether.h |    2 +-
 3 files changed, 21 insertions(+), 10 deletions(-)

> On Wed, 25 Nov 2009 12:59:46 +0100 Michal Nazarewicz wrote:
>> CONFIG_USB_ETH_RNDIS may be defined when g_ether is built causing
>> warning when multi.c tries to redefine its value.  Changed to first
>> undefine CONFIG_USB_ETH_RNDIS in multi.c.

On Sat, 28 Nov 2009 19:34:29 +0100, Randy Dunlap wrote:
> Is there no kconfig way to solve this?
> You shouldn't be messing with kconfig symbols in source files...

Messing with KConfig symbols was less intrusive method of fixing the
warning but if anyone feels like it's not the proper method here's
another patch.

diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index 167cb2a..141372b 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -25,6 +25,14 @@
 #include <linux/kernel.h>
 #include <linux/utsname.h>

+
+#if defined USB_ETH_RNDIS
+#  undef USB_ETH_RNDIS
+#endif
+#ifdef CONFIG_USB_ETH_RNDIS
+#  define USB_ETH_RNDIS y
+#endif
+
 #include "u_ether.h"


@@ -66,7 +74,7 @@
 #define DRIVER_DESC		"Ethernet Gadget"
 #define DRIVER_VERSION		"Memorial Day 2008"

-#ifdef CONFIG_USB_ETH_RNDIS
+#ifdef USB_ETH_RNDIS
 #define PREFIX			"RNDIS/"
 #else
 #define PREFIX			""
@@ -87,7 +95,7 @@

 static inline bool has_rndis(void)
 {
-#ifdef	CONFIG_USB_ETH_RNDIS
+#ifdef	USB_ETH_RNDIS
 	return true;
 #else
 	return false;
@@ -110,7 +118,7 @@ static inline bool has_rndis(void)

 #include "f_ecm.c"
 #include "f_subset.c"
-#ifdef	CONFIG_USB_ETH_RNDIS
+#ifdef	USB_ETH_RNDIS
 #include "f_rndis.c"
 #include "rndis.c"
 #endif
@@ -251,7 +259,7 @@ static struct usb_configuration rndis_config_driver = {

 /*-------------------------------------------------------------------------*/

-#ifdef CONFIG_USB_ETH_EEM
+#ifdef USB_ETH_EEM
 static int use_eem = 1;
 #else
 static int use_eem;
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 64711fe..4295601 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -26,8 +26,11 @@
 #include <linux/utsname.h>


-#if defined CONFIG_USB_G_MULTI_RNDIS
-#  define CONFIG_USB_ETH_RNDIS y
+#if defined USB_ETH_RNDIS
+#  undef USB_ETH_RNDIS
+#endif
+#ifdef CONFIG_USB_ETH_RNDIS
+#  define USB_ETH_RNDIS y
 #endif


@@ -59,7 +62,7 @@

 #include "f_ecm.c"
 #include "f_subset.c"
-#ifdef CONFIG_USB_ETH_RNDIS
+#ifdef USB_ETH_RNDIS
 #  include "f_rndis.c"
 #  include "rndis.c"
 #endif
@@ -150,7 +153,7 @@ FSG_MODULE_PARAMETERS(/* no prefix */, mod_data);
 static struct fsg_common *fsg_common;


-#ifdef CONFIG_USB_ETH_RNDIS
+#ifdef USB_ETH_RNDIS

 static int __init rndis_do_config(struct usb_configuration *c)
 {
@@ -292,7 +295,7 @@ static int __init multi_bind(struct usb_composite_dev *cdev)
 	strings_dev[STRING_PRODUCT_IDX].id = status;
 	device_desc.iProduct = status;

-#ifdef CONFIG_USB_ETH_RNDIS
+#ifdef USB_ETH_RNDIS
 	/* register our first configuration */
 	status = usb_add_config(cdev, &rndis_config_driver);
 	if (status < 0)
diff --git a/drivers/usb/gadget/u_ether.h b/drivers/usb/gadget/u_ether.h
index 91b39ff..fd55f45 100644
--- a/drivers/usb/gadget/u_ether.h
+++ b/drivers/usb/gadget/u_ether.h
@@ -112,7 +112,7 @@ int geth_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN]);
 int ecm_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN]);
 int eem_bind_config(struct usb_configuration *c);

-#ifdef CONFIG_USB_ETH_RNDIS
+#ifdef USB_ETH_RNDIS

 int rndis_bind_config(struct usb_configuration *c, u8 ethaddr[ETH_ALEN]);

-- 
1.6.5

