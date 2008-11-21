Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbYKUS2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbYKUS2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbYKUS2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:28:12 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:64627 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468AbYKUS2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:28:11 -0500
Message-ID: <4926FDB3.2030701@lwfinger.net>
Date: Fri, 21 Nov 2008 12:28:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Yuval Hager <yuval@avramzon.net>
CC: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, Peter Stuge <peter@stuge.se>
Subject: Re: BCM4312 Fails when xdm is started
References: <200811151801.02369.yuval@avramzon.net> <20081115174623.27321.qmail@stuge.se> <4926E0F2.5060200@lwfinger.net> <200811211842.13099.mb@bu3sch.de>
In-Reply-To: <200811211842.13099.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yuval,

Michael Buesch wrote:
> 
> Can you dump PCI config space and SSB registers (TMSLOW, maybe others, too).
> It looks like a random bus write disabled the device.

Please incorporate the following patch and run your system. In addition, run the
following command when the wireless is working and after it fails:

sudo lspci -d 14e4:4312 -x

Post the results of the above commands and any entries in /var/log/messages that
dump registers. They should all be prefaced with ****


Index: linux-2.6/drivers/net/wireless/b43/phy_common.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/phy_common.c
+++ linux-2.6/drivers/net/wireless/b43/phy_common.c
@@ -133,6 +133,11 @@ void b43_radio_lock(struct b43_wldev *de

 	macctl = b43_read32(dev, B43_MMIO_MACCTL);
 	B43_WARN_ON(macctl & B43_MACCTL_RADIOLOCK);
+	if (macctl & B43_MACCTL_RADIOLOCK) {
+		printk(KERN_INFO "****** b43: B43_MMIO_MACCTL 0x%X\n", macctl);
+		printk(KERN_INFO "****** b43: SSB_TMSLOW 0x%X\n",
+			ssb_read32(dev->dev, SSB_TMSLOW));
+	}
 	macctl |= B43_MACCTL_RADIOLOCK;
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 	/* Commit the write and wait for the device
@@ -150,6 +155,11 @@ void b43_radio_unlock(struct b43_wldev *
 	/* unlock */
 	macctl = b43_read32(dev, B43_MMIO_MACCTL);
 	B43_WARN_ON(!(macctl & B43_MACCTL_RADIOLOCK));
+	if (macctl & B43_MACCTL_RADIOLOCK) {
+		printk(KERN_INFO "****** b43: B43_MMIO_MACCTL 0x%X\n", macctl);
+		printk(KERN_INFO "****** b43: SSB_TMSLOW 0x%X\n",
+			ssb_read32(dev->dev, SSB_TMSLOW));
+	}
 	macctl &= ~B43_MACCTL_RADIOLOCK;
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 }
Index: linux-2.6/drivers/net/wireless/b43/rfkill.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43/rfkill.c
+++ linux-2.6/drivers/net/wireless/b43/rfkill.c
@@ -63,6 +63,8 @@ static void b43_rfkill_poll(struct input
 		report_change = 1;
 		b43info(wl, "Radio hardware status changed to %s\n",
 			enabled ? "ENABLED" : "DISABLED");
+		b43info(wl, "******** B43_B43_MMIO_RADIO_HWENABLED_HI 0x%X\n",
+			b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI));
 	}
 	mutex_unlock(&wl->mutex);



