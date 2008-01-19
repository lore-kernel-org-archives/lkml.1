Return-Path: <linux-kernel-owner+w=401wt.eu-S1761674AbYASOgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761674AbYASOgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761333AbYASOfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:35:48 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:42104 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761237AbYASOfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:35:46 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: david-b@pacbell.net, tony@atomide.com, Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH 2/4] USB: OTG: Make otg_get_transceiver() and otg_set_transceiver() generic
Date: Sat, 19 Jan 2008 16:37:23 +0200
Message-Id: <1200753446-9378-3-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.5.4.rc3.24.gb53139
In-Reply-To: <1200753446-9378-2-git-send-email-me@felipebalbi.com>
References: <1200753446-9378-1-git-send-email-me@felipebalbi.com>
 <1200753446-9378-2-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lidgren <tony@atomide.com>

Move otg_get_transceiver() and otg_set_transceiver() from omap specific code
to common otg.c so other upcoming drivers can share them.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 arch/arm/plat-omap/usb.c |   32 --------------------------------
 drivers/usb/core/otg.c   |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/core/otg.c b/drivers/usb/core/otg.c
index 11967c0..531afa6 100644
--- a/drivers/usb/core/otg.c
+++ b/drivers/usb/core/otg.c
@@ -14,9 +14,29 @@
 #include <linux/byteorder/generic.h>
 #include <linux/gfp.h>
 #include <linux/usb.h>
+#include <linux/usb/otg.h>
 
 #include "otg_whitelist.h"
 
+static struct otg_transceiver *xceiv;
+
+int otg_set_transceiver(struct otg_transceiver *x)
+{
+	if (xceiv && x)
+		return -EBUSY;
+	xceiv = x;
+	return 0;
+}
+EXPORT_SYMBOL(otg_set_transceiver);
+
+struct otg_transceiver *otg_get_transceiver(void)
+{
+	if (xceiv)
+		get_device(xceiv->dev);
+	return xceiv;
+}
+EXPORT_SYMBOL(otg_get_transceiver);
+
 #ifdef	CONFIG_USB_OTG_WHITELIST
 
 /*
diff --git a/arch/arm/plat-omap/usb.c b/arch/arm/plat-omap/usb.c
index a5aedf9..5cd39fa 100644
--- a/arch/arm/plat-omap/usb.c
+++ b/arch/arm/plat-omap/usb.c
@@ -76,38 +76,6 @@
 
 /*-------------------------------------------------------------------------*/
 
-#ifdef	CONFIG_ARCH_OMAP_OTG
-
-static struct otg_transceiver *xceiv;
-
-/**
- * otg_get_transceiver - find the (single) OTG transceiver driver
- *
- * Returns the transceiver driver, after getting a refcount to it; or
- * null if there is no such transceiver.  The caller is responsible for
- * releasing that count.
- */
-struct otg_transceiver *otg_get_transceiver(void)
-{
-	if (xceiv)
-		get_device(xceiv->dev);
-	return xceiv;
-}
-EXPORT_SYMBOL(otg_get_transceiver);
-
-int otg_set_transceiver(struct otg_transceiver *x)
-{
-	if (xceiv && x)
-		return -EBUSY;
-	xceiv = x;
-	return 0;
-}
-EXPORT_SYMBOL(otg_set_transceiver);
-
-#endif
-
-/*-------------------------------------------------------------------------*/
-
 #if defined(CONFIG_ARCH_OMAP_OTG) || defined(CONFIG_ARCH_OMAP15XX)
 
 static u32 __init omap_usb0_init(unsigned nwires, unsigned is_device)
-- 
1.5.4.rc3.24.gb53139

