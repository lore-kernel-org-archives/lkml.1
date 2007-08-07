Return-Path: <linux-kernel-owner+w=401wt.eu-S936450AbXHGWrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936450AbXHGWrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXHGWrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:47:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35272 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761114AbXHGWrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:47:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: [RFC][PATCH] uli526x: Add suspend and resume routines (updated)
Date: Wed, 8 Aug 2007 00:56:41 +0200
User-Agent: KMail/1.9.5
Cc: Kyle McMartin <kyle@mcmartin.ca>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>
References: <200708052114.01790.rjw@sisk.pl> <200708080024.28692.rjw@sisk.pl> <46B8F19D.6060406@garzik.org>
In-Reply-To: <46B8F19D.6060406@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708080056.41651.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 8 August 2007 00:26, Jeff Garzik wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday, 7 August 2007 23:40, Jeff Garzik wrote:
> >> I'll let our new tulip maintainer see what he thinks about the 
> >> implementation.  Seems fairly sane to me, but should at least get an "it 
> >> works" test.
> > 
> > It has been tested, as stated in the changelog, and works (on my test system).
> 
> 
> Apologies, I missed this.  I'll look to our new tulip maintainer to 
> queue your resent patch, or at least ACK it...

OK

Below is the updated version.  It's functionally equivalent to the previous one.

Greetings,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

Add suspend/resume support to the uli526x network driver (tested on x86_64,
with 'Ethernet controller: ALi Corporation M5263 Ethernet Controller, rev 40').

This patch is based on the suspend/resume code in the tg3 driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/net/tulip/uli526x.c |  109 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 103 insertions(+), 6 deletions(-)

Index: linux-2.6.23-rc2/drivers/net/tulip/uli526x.c
===================================================================
--- linux-2.6.23-rc2.orig/drivers/net/tulip/uli526x.c
+++ linux-2.6.23-rc2/drivers/net/tulip/uli526x.c
@@ -1110,19 +1110,15 @@ static void uli526x_timer(unsigned long 
 
 
 /*
- *	Dynamic reset the ULI526X board
  *	Stop ULI526X board
  *	Free Tx/Rx allocated memory
- *	Reset ULI526X board
- *	Re-initialize ULI526X board
+ *	Init system variable
  */
 
-static void uli526x_dynamic_reset(struct net_device *dev)
+static void uli526x_reset_prepare(struct net_device *dev)
 {
 	struct uli526x_board_info *db = netdev_priv(dev);
 
-	ULI526X_DBUG(0, "uli526x_dynamic_reset()", 0);
-
 	/* Sopt MAC controller */
 	db->cr6_data &= ~(CR6_RXSC | CR6_TXSC);	/* Disable Tx/Rx */
 	update_cr6(db->cr6_data, dev->base_addr);
@@ -1141,6 +1137,22 @@ static void uli526x_dynamic_reset(struct
 	db->link_failed = 1;
 	db->init=1;
 	db->wait_reset = 0;
+}
+
+
+/*
+ *	Dynamic reset the ULI526X board
+ *	Stop ULI526X board
+ *	Free Tx/Rx allocated memory
+ *	Reset ULI526X board
+ *	Re-initialize ULI526X board
+ */
+
+static void uli526x_dynamic_reset(struct net_device *dev)
+{
+	ULI526X_DBUG(0, "uli526x_dynamic_reset()", 0);
+
+	uli526x_reset_prepare(dev);
 
 	/* Re-initialize ULI526X board */
 	uli526x_init(dev);
@@ -1150,6 +1162,89 @@ static void uli526x_dynamic_reset(struct
 }
 
 
+#ifdef CONFIG_PM_SLEEP
+
+/*
+ *	Suspend the interface.
+ */
+
+static int uli526x_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+	pci_power_t power_state;
+	int err;
+
+	ULI526X_DBUG(0, "uli526x_suspend", 0);
+
+	if (!(dev && netdev_priv(dev)))
+		return 0;
+
+	pci_save_state(pdev);
+
+	if (!netif_running(dev))
+		return 0;
+
+	netif_device_detach(dev);
+	uli526x_reset_prepare(dev);
+
+	power_state = pci_choose_state(pdev, state);
+	pci_enable_wake(pdev, power_state, 0);
+	err = pci_set_power_state(pdev, power_state);
+	if (err) {
+		netif_device_attach(dev);
+		/* Re-initialize ULI526X board */
+		uli526x_init(dev);
+		/* Restart upper layer interface */
+		netif_wake_queue(dev);
+	}
+
+	return err;
+}
+
+/*
+ *	Resume the interface.
+ */
+
+static int uli526x_resume(struct pci_dev *pdev)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+	struct uli526x_board_info *db = netdev_priv(dev);
+	int err;
+
+	ULI526X_DBUG(0, "uli526x_resume", 0);
+
+	if (!(dev && db))
+		return 0;
+
+	pci_restore_state(pdev);
+
+	if (!netif_running(dev))
+		return 0;
+
+	err = pci_set_power_state(pdev, PCI_D0);
+	if (err) {
+		printk(KERN_WARNING "%s: Could not put device into D0\n",
+			dev->name);
+		return err;
+	}
+
+	netif_device_attach(dev);
+	/* Re-initialize ULI526X board */
+	uli526x_init(dev);
+	/* Restart upper layer interface */
+	netif_wake_queue(dev);
+
+	return 0;
+}
+
+#else /* !CONFIG_PM_SLEEP */
+
+#define uli526x_suspend	NULL
+#define uli526x_resume	NULL
+
+#endif /* !CONFIG_PM_SLEEP */
+
+
 /*
  *	free all allocated rx buffer
  */
@@ -1689,6 +1784,8 @@ static struct pci_driver uli526x_driver 
 	.id_table	= uli526x_pci_tbl,
 	.probe		= uli526x_init_one,
 	.remove		= __devexit_p(uli526x_remove_one),
+	.suspend	= uli526x_suspend,
+	.resume		= uli526x_resume,
 };
 
 MODULE_AUTHOR("Peer Chen, peer.chen@uli.com.tw");
