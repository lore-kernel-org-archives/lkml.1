Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbZA2G6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbZA2G6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 01:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZA2G6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 01:58:05 -0500
Received: from serv04.lahn.de ([213.239.197.57]:55176 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZA2G6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 01:58:04 -0500
X-Greylist: delayed 1600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2009 01:58:03 EST
Date: Thu, 29 Jan 2009 07:31:18 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: WOL with forcedeth broken since
	f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
Message-ID: <20090129063118.GA3586@pmhahn.de>
Mail-Followup-To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Somewhere between 2.6.26 and 2.6.27 WOL stopped working on my MS-7350
motherboard with an "nVidia Corporation MCP51 Ethernet Controller (rev a3)".
	"etherwake 00:19:db:f2:e1:35" did not work
	"etherwake 35:e1:f2:db:19:00" did work
Since I did a BIOS update during the same time window I (wrongly) put
the fault on the BIOS. (See /sys/class/dmi/id/modalias for yourself:
dmi:bvnAmericanMegatrendsInc.:bvrV1.7:bd07/29/2008:svnMSI:pnMS-7350:pvr1.0:rvnMSI:rnMS-7350:rvr1.0:cvnToBeFilledByO.E.M.:ct3:cvrToBeFilledByO.E.M.:
)

Today I finally found the time to test various old versions of
"drivers/net/forcedeth.c" and also did a "git-bisect v2.6.26 v2.6.27"
which lead to the following culprit:

f55c21fd9a92a444e55ad1ca4e4732d56661bf2e is first bad commit
commit f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Sat Sep 13 13:10:31 2008 -0700

    forcedeth: call restore mac addr in nv_shutdown path
    
    after
    
    | commit f735a2a1a4f2a0f5cd823ce323e82675990469e2
    | Author: Tobias Diedrich <ranma+kernel@tdiedrich.de>
    | Date:   Sun May 18 15:02:37 2008 +0200
    |
    |    [netdrvr] forcedeth: setup wake-on-lan before shutting down
    |
    |    When hibernating in 'shutdown' mode, after saving the image the suspend hook
    |    is not called again.
    |    However, if the device is in promiscous mode, wake-on-lan will not work.
    |    This adds a shutdown hook to setup wake-on-lan before the final shutdown.
    |
    |    Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
    |    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
    
    my servers with nvidia ck804 and mcp55 will reverse mac address with kexec.
    
    it turns out that we need to restore the mac addr in nv_shutdown().
    
    [akpm@linux-foundation.org: fix typo in printk]
    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Cc: Tobias Diedrich <ranma+kernel@tdiedrich.de>
    Cc: Ayaz Abdulla <aabdulla@nvidia.com>
    Cc: Jeff Garzik <jeff@garzik.org>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 0b6ecef..eeb55ed 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -5643,6 +5643,7 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 		dev->dev_addr[4] = (np->orig_mac[0] >>  8) & 0xff;
 		dev->dev_addr[5] = (np->orig_mac[0] >>  0) & 0xff;
 		writel(txreg|NVREG_TRANSMITPOLL_MAC_ADDR_REV, base + NvRegTransmitPoll);
+		printk(KERN_DEBUG "nv_probe: set workaround bit for reversed mac addr\n");
 	}
 	memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
 
@@ -5890,14 +5891,12 @@ static void nv_restore_phy(struct net_device *dev)
 	}
 }
 
-static void __devexit nv_remove(struct pci_dev *pci_dev)
+static void nv_restore_mac_addr(struct pci_dev *pci_dev)
 {
 	struct net_device *dev = pci_get_drvdata(pci_dev);
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
 
-	unregister_netdev(dev);
-
 	/* special op: write back the misordered MAC address - otherwise
 	 * the next nv_probe would see a wrong address.
 	 */
@@ -5905,6 +5904,15 @@ static void __devexit nv_remove(struct pci_dev *pci_dev)
 	writel(np->orig_mac[1], base + NvRegMacAddrB);
 	writel(readl(base + NvRegTransmitPoll) & ~NVREG_TRANSMITPOLL_MAC_ADDR_REV,
 	       base + NvRegTransmitPoll);
+}
+
+static void __devexit nv_remove(struct pci_dev *pci_dev)
+{
+	struct net_device *dev = pci_get_drvdata(pci_dev);
+
+	unregister_netdev(dev);
+
+	nv_restore_mac_addr(pci_dev);
 
 	/* restore any phy related changes */
 	nv_restore_phy(dev);
@@ -5975,6 +5983,8 @@ static void nv_shutdown(struct pci_dev *pdev)
 	if (netif_running(dev))
 		nv_close(dev);
 
+	nv_restore_mac_addr(pdev);
+
 	pci_disable_device(pdev);
 	if (system_state == SYSTEM_POWER_OFF) {
 		if (pci_enable_wake(pdev, PCI_D3cold, np->wolenabled))

:040000 040000 8c603aa1f71b79f3f4a94bef066a830a249c8d2a e85d84f3c509421a33fd4b71bacddeb4b9fbe896 M drivers

Reverting that patch on top of drivers/net/forcedeth.c from 2.6.28.2
resolves the problem for me.
I DON'T use kexec, just simple poweroff.

BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
