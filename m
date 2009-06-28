Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbZF1OQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbZF1OQB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbZF1ONr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:13:47 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43467 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbZF1ONq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:13:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ry8BCXVKRFUYaHPjwe6K5idzCHBvyKmvD+Q5q9OdnqYt8dxnFrUm/MzXUVO2PemVBh
         Wcg9nHS5Tu3dY9z8MzCQHIRriB91oa9Vih7ZZEKzDycFt61uE/fOdPkMSbWPdAUecs+T
         0mVAniqkWwn9taLv7huD7oX8wU+j/sJrzafgk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 28 Jun 2009 16:20:10 +0200
Message-Id: <20090628142010.8761.16823.sendpatchset@localhost.localdomain>
In-Reply-To: <20090628141844.8761.8943.sendpatchset@localhost.localdomain>
References: <20090628141844.8761.8943.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/18] Staging: rtl8187se: merge r8180_pm.c with r8180_core.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8187se: merge r8180_pm.c with r8180_core.c

* merge r8180_pm.c with r8180_core.c
* make functions static

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/Makefile      |    1 
 drivers/staging/rtl8187se/r8180_core.c  |   63 ++++++++++++++++++++++++++-
 drivers/staging/rtl8187se/r8180_pm.c    |   74 --------------------------------
 drivers/staging/rtl8187se/r8180_pm.h    |   24 ----------
 drivers/staging/rtl8187se/r8185b_init.c |    2 
 5 files changed, 61 insertions(+), 103 deletions(-)

Index: b/drivers/staging/rtl8187se/Makefile
===================================================================
--- a/drivers/staging/rtl8187se/Makefile
+++ b/drivers/staging/rtl8187se/Makefile
@@ -25,7 +25,6 @@ rtl8187se-objs :=			\
 		r8180_rtl8225z2.o	\
 		r8185b_init.o		\
 		r8180_dm.o		\
-		r8180_pm.o		\
 		ieee80211/dot11d.o			\
 		ieee80211/ieee80211_softmac.o		\
 		ieee80211/ieee80211_rx.o		\
Index: b/drivers/staging/rtl8187se/r8180_core.c
===================================================================
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -22,6 +22,9 @@
 
    A big big thanks goes also to Realtek corp. for their help in my attempt to
    add RTL8185 and RTL8225 support, and to David Young also.
+
+   Power management interface routines.
+   Written by Mariusz Matuszek.
 */
 
 #undef RX_DONT_PASS_UL
@@ -37,8 +40,6 @@
 #include "r8180_wx.h"
 #include "r8180_dm.h"
 
-#include "r8180_pm.h"
-
 #include "ieee80211/dot11d.h"
 
 #ifndef PCI_VENDOR_ID_BELKIN
@@ -121,6 +122,64 @@ static void rtl8180_shutdown (struct pci
 	pci_disable_device(pdev);
 }
 
+static int rtl8180_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+
+	if (!netif_running(dev))
+		goto out_pci_suspend;
+
+	if (dev->netdev_ops->ndo_stop)
+		dev->netdev_ops->ndo_stop(dev);
+
+	netif_device_detach(dev);
+
+out_pci_suspend:
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	return 0;
+}
+
+static int rtl8180_resume(struct pci_dev *pdev)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+	int err;
+	u32 val;
+
+	pci_set_power_state(pdev, PCI_D0);
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
+				dev->name);
+
+		return err;
+	}
+
+	pci_restore_state(pdev);
+
+	/*
+	 * Suspend/Resume resets the PCI configuration space, so we have to
+	 * re-disable the RETRY_TIMEOUT register (0x41) to keep PCI Tx retries
+	 * from interfering with C3 CPU state. pci_restore_state won't help
+	 * here since it only restores the first 64 bytes pci config header.
+	 */
+	pci_read_config_dword(pdev, 0x40, &val);
+	if ((val & 0x0000ff00) != 0)
+		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
+
+	if (!netif_running(dev))
+		goto out;
+
+	if (dev->netdev_ops->ndo_open)
+		dev->netdev_ops->ndo_open(dev);
+
+	netif_device_attach(dev);
+out:
+	return 0;
+}
+
 static struct pci_driver rtl8180_pci_driver = {
 	.name		= RTL8180_MODULE_NAME,	          /* Driver name   */
 	.id_table	= rtl8180_pci_id_tbl,	          /* PCI_ID table  */
Index: b/drivers/staging/rtl8187se/r8180_pm.c
===================================================================
--- a/drivers/staging/rtl8187se/r8180_pm.c
+++ /dev/null
@@ -1,74 +0,0 @@
-/*
-   Power management interface routines.
-   Written by Mariusz Matuszek.
-   This code is currently just a placeholder for later work and
-   does not do anything useful.
-
-   This is part of rtl8180 OpenSource driver.
-   Copyright (C) Andrea Merello 2004  <andreamrl@tiscali.it>
-   Released under the terms of GPL (General Public Licence)
-*/
-
-
-
-#include "r8180_hw.h"
-#include "r8180_pm.h"
-#include "r8180.h"
-
-int rtl8180_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	struct net_device *dev = pci_get_drvdata(pdev);
-
-	if (!netif_running(dev))
-		goto out_pci_suspend;
-
-	if (dev->netdev_ops->ndo_stop)
-		dev->netdev_ops->ndo_stop(dev);
-
-	netif_device_detach(dev);
-
-out_pci_suspend:
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-	return 0;
-}
-
-int rtl8180_resume(struct pci_dev *pdev)
-{
-	struct net_device *dev = pci_get_drvdata(pdev);
-	int err;
-	u32 val;
-
-	pci_set_power_state(pdev, PCI_D0);
-
-	err = pci_enable_device(pdev);
-	if (err) {
-		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
-				dev->name);
-
-		return err;
-	}
-
-	pci_restore_state(pdev);
-
-	/*
-	 * Suspend/Resume resets the PCI configuration space, so we have to
-	 * re-disable the RETRY_TIMEOUT register (0x41) to keep PCI Tx retries
-	 * from interfering with C3 CPU state. pci_restore_state won't help
-	 * here since it only restores the first 64 bytes pci config header.
-	 */
-	pci_read_config_dword(pdev, 0x40, &val);
-	if ((val & 0x0000ff00) != 0)
-		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
-
-	if (!netif_running(dev))
-		goto out;
-
-	if (dev->netdev_ops->ndo_open)
-		dev->netdev_ops->ndo_open(dev);
-
-	netif_device_attach(dev);
-out:
-	return 0;
-}
Index: b/drivers/staging/rtl8187se/r8180_pm.h
===================================================================
--- a/drivers/staging/rtl8187se/r8180_pm.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
-        Power management interface routines.
-	Written by Mariusz Matuszek.
-	This code is currently just a placeholder for later work and
-	does not do anything useful.
-
-	This is part of rtl8180 OpenSource driver.
-	Copyright (C) Andrea Merello 2004  <andreamrl@tiscali.it>
-	Released under the terms of GPL (General Public Licence)
-
-*/
-
-
-#ifndef R8180_PM_H
-#define R8180_PM_H
-
-#include <linux/types.h>
-#include <linux/pci.h>
-
-int rtl8180_suspend (struct pci_dev *pdev, pm_message_t state);
-int rtl8180_resume (struct pci_dev *pdev);
-
-#endif //R8180_PM_H
-
Index: b/drivers/staging/rtl8187se/r8185b_init.c
===================================================================
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -26,8 +26,6 @@ Notes:
 #include "r8180_93cx6.h"   /* Card EEPROM */
 #include "r8180_wx.h"
 
-#include "r8180_pm.h"
-
 #include "ieee80211/dot11d.h"
 
 
