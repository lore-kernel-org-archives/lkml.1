Return-Path: <linux-kernel-owner+w=401wt.eu-S1750882AbXB0DcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882AbXB0DcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 22:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXB0DcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 22:32:13 -0500
Received: from anchor-post-36.mail.demon.net ([194.217.242.86]:1444 "EHLO
	anchor-post-36.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbXB0DcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 22:32:12 -0500
Date: Tue, 27 Feb 2007 02:47:18 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
Message-ID: <4EBB823D2F%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <20070227000538.GA6283@kroah.com>
User-Agent: Messenger-Pro/4.30 (MsgServe/3.30) (RISC-OS/4.02) POPstar/2.06+cvs
To: linux-kernel@vger.kernel.org, stable@kernel.org
Mail-Followup-To: linux-kernel@vger.kernel.org, stable@kernel.org, linux@youmustbejoking.demon.co.uk
Subject: Re: [patch 0/9] 2.6.19-stable review (mmc: Power quirk for ENE controllers)
X-Editor: Zap 1.47 (27 Apr 2006) [TEST], ZapEmail 0.28.3 (25 Mar 2005) (32)
X-SDate: Tue, 4928 Sep 1993 02:47:18 +0000
X-Message-Flag: Outlook Express is broken. Upgrade to mail(1).
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.2
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Could you add this patch (which is in 2.6.21-rc1) to the queues for 2.6.19.6
and 2.6.20.2 and, if it's ever to be released, 2.6.18.9? (There's one
trivially-fixable reject against 2.6.18, but it's otherwise fine with all
three.)


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
---

diff --git a/drivers/mmc/sdhci.c b/drivers/mmc/sdhci.c
index c2d13d7..175a942 100644
--- a/drivers/mmc/sdhci.c
+++ b/drivers/mmc/sdhci.c
@@ -37,6 +37,7 @@ static unsigned int debug_quirks = 0;
 #define SDHCI_QUIRK_FORCE_DMA				(1<<1)
 /* Controller doesn't like some resets when there is no card inserted. */
 #define SDHCI_QUIRK_NO_CARD_NO_RESET			(1<<2)
+#define SDHCI_QUIRK_SINGLE_POWER_WRITE			(1<<3)
 
 static const struct pci_device_id pci_ids[] __devinitdata = {
 	{
@@ -65,6 +66,14 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
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
@@ -674,10 +683,17 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned short power)
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
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3d1d210..d37f46a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1971,6 +1971,7 @@
 #define PCI_DEVICE_ID_TOPIC_TP560	0x0000
 
 #define PCI_VENDOR_ID_ENE		0x1524
+#define PCI_DEVICE_ID_ENE_CB712_SD	0x0550
 #define PCI_DEVICE_ID_ENE_1211		0x1211
 #define PCI_DEVICE_ID_ENE_1225		0x1225
 #define PCI_DEVICE_ID_ENE_1410		0x1410

-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Burn less waste. Use less packaging. Waste less.     USE FEWER RESOURCES.

Necessity has no law.
