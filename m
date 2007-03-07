Return-Path: <linux-kernel-owner+w=401wt.eu-S1422871AbXCGRQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422871AbXCGRQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422863AbXCGRQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:16:33 -0500
Received: from ns2.suse.de ([195.135.220.15]:43401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422851AbXCGRQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:10 -0500
Message-Id: <20070307171430.487969755@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Darren Salt <linux@youmustbejoking.demon.co.uk>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 058/101] mmc: Power quirk for ENE controllers
Content-Disposition: inline; filename=mmc-power-quirk-for-ene-controllers.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Salt <linux@youmustbejoking.demon.co.uk>

mmc: Power quirk for ENE controllers

Support for these devices was broken for 2.6.18-rc1 and later by commit
146ad66eac836c0b976c98f428d73e1f6a75270d, which added voltage level support.

This restores the previous behaviour for these devices by ensuring that when
the voltage is changed, only one write to set the voltage is performed.

It may be that both writes are needed if the voltage is being changed between
two non-zero values or that it's safe to ensure that only one write is done
if the hardware only supports one voltage; I don't know whether either is the
case nor can I test since I have only the one SD reader (1524:0550), and it
supports just the one voltage.

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/sdhci.c     |   22 +++++++++++++++++++---
 include/linux/pci_ids.h |    1 +
 2 files changed, 20 insertions(+), 3 deletions(-)

--- linux-2.6.20.1.orig/drivers/mmc/sdhci.c
+++ linux-2.6.20.1/drivers/mmc/sdhci.c
@@ -37,6 +37,7 @@ static unsigned int debug_quirks = 0;
 #define SDHCI_QUIRK_FORCE_DMA				(1<<1)
 /* Controller doesn't like some resets when there is no card inserted. */
 #define SDHCI_QUIRK_NO_CARD_NO_RESET			(1<<2)
+#define SDHCI_QUIRK_SINGLE_POWER_WRITE			(1<<3)
 
 static const struct pci_device_id pci_ids[] __devinitdata = {
 	{
@@ -65,6 +66,14 @@ static const struct pci_device_id pci_id
 		.driver_data	= SDHCI_QUIRK_FORCE_DMA,
 	},
 
+	{
+		.vendor		= PCI_VENDOR_ID_ENE,
+		.device		= PCI_DEVICE_ID_ENE_CB712_SD,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= SDHCI_QUIRK_SINGLE_POWER_WRITE,
+	},
+
 	{	/* Generic SD host controller */
 		PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
 	},
@@ -674,10 +683,17 @@ static void sdhci_set_power(struct sdhci
 	if (host->power == power)
 		return;
 
-	writeb(0, host->ioaddr + SDHCI_POWER_CONTROL);
-
-	if (power == (unsigned short)-1)
+	if (power == (unsigned short)-1) {
+		writeb(0, host->ioaddr + SDHCI_POWER_CONTROL);
 		goto out;
+	}
+
+	/*
+	 * Spec says that we should clear the power reg before setting
+	 * a new value. Some controllers don't seem to like this though.
+	 */
+	if (!(host->chip->quirks & SDHCI_QUIRK_SINGLE_POWER_WRITE))
+		writeb(0, host->ioaddr + SDHCI_POWER_CONTROL);
 
 	pwr = SDHCI_POWER_ON;
 
--- linux-2.6.20.1.orig/include/linux/pci_ids.h
+++ linux-2.6.20.1/include/linux/pci_ids.h
@@ -1971,6 +1971,7 @@
 #define PCI_DEVICE_ID_TOPIC_TP560	0x0000
 
 #define PCI_VENDOR_ID_ENE		0x1524
+#define PCI_DEVICE_ID_ENE_CB712_SD	0x0550
 #define PCI_DEVICE_ID_ENE_1211		0x1211
 #define PCI_DEVICE_ID_ENE_1225		0x1225
 #define PCI_DEVICE_ID_ENE_1410		0x1410

--
