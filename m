Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbZIPUia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbZIPUia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759999AbZIPUiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:38:24 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:43657 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756128AbZIPUiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:38:22 -0400
Date: Wed, 16 Sep 2009 22:43:19 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, laurent.pinchart@skynet.be,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb autosuspend is history after S2R (also on 2.6.31; UVC?)
Message-ID: <20090916204319.GB30867@electric-eye.fr.zoreil.com>
References: <20090915185145.GA31490@rhlx01.hs-esslingen.de> <200909152148.29662.oliver@neukum.org> <20090916181910.GA28260@rhlx01.hs-esslingen.de> <20090916195156.GA30867@electric-eye.fr.zoreil.com> <20090916195418.GB15489@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916195418.GB15489@rhlx01.hs-esslingen.de>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr <andi@lisas.de> :
[...]
> Wait, you mean this is the patch to fix it that you created just now,
> and it's that easy?

I can not exclude that it will not swap a settings loss problem for
a (new) link loss after resume one or some completely random crash
but it deserves to be tested, yes.

> I'd have expected needing to fiddle with PHY power-management registers
> and such stuff (while remembering pre-suspend status)
> upon resume() handlers.

The current driver does not play directly with the PHY during
suspend / resume.

/me wonders...

Can you try the patch below too ? A PHY reset will probably be required
too now.

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 50c6a3c..116797f 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3934,11 +3934,19 @@ static struct net_device_stats *rtl8169_get_stats(struct net_device *dev)
 
 static void rtl8169_net_suspend(struct net_device *dev)
 {
+	struct rtl8169_private *tp = netdev_priv(dev);
+
 	if (!netif_running(dev))
 		return;
 
 	netif_device_detach(dev);
 	netif_stop_queue(dev);
+
+	if (!(tp->features & RTL_FEATURE_WOL)) {
+		void __iomem *ioaddr = tp->mmio_addr;
+
+		mdio_patch(ioaddr, MII_BMCR, BMCR_PDOWN);
+	}
 }
 
 #ifdef CONFIG_PM
@@ -3957,13 +3965,21 @@ static int rtl8169_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct net_device *dev = pci_get_drvdata(pdev);
+	struct rtl8169_private *tp = netdev_priv(dev);
 
 	if (!netif_running(dev))
 		goto out;
 
 	netif_device_attach(dev);
+	netif_wake_queue(dev);
 
-	rtl8169_schedule_work(dev, rtl8169_reset_task);
+	if (!(tp->features & RTL_FEATURE_WOL)) {
+		void __iomem *ioaddr = tp->mmio_addr;
+		unsigned int val;
+
+		val = mdio_read(ioaddr, MII_BMCR) & ~BMCR_PDOWN;
+		mdio_write(ioaddr, MII_BMCR, val & 0xffff);
+	}
 out:
 	return 0;
 }

> And sorry for not reporting it earlier (provoking that "Stealth tester"
> above, right?), but I had kept tabs on it.

No problem, really. :o)

-- 
Ueimor
