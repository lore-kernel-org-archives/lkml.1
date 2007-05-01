Return-Path: <linux-kernel-owner+w=401wt.eu-S1031148AbXEADzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031148AbXEADzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbXEADzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:55:51 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932212AbXEADzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:55:49 -0400
Date: Mon, 30 Apr 2007 20:55:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Mark Brown <broonie@sirena.org.uk>
Subject: Re: Natsemi DP83815 driver spaming
Message-Id: <20070430205522.abad2481.akpm@linux-foundation.org>
In-Reply-To: <46365887.3010705@interia.pl>
References: <46365887.3010705@interia.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 22:58:47 +0200 Rafał Bilski <rafalbilski@interia.pl> wrote:

> Hello,
> 
> I have Wyse 3360SE terminal running Linux 2.6.21-rc7. Everything 
> works great with one small exception. Natsemi DP83815 driver is 
> filling log with:
> > ezri user.info kernel: eth0: DSPCFG accepted after 0 usec.
> > ezri user.notice kernel: eth0: Wake-up event 0x80000a
> > ezri user.info kernel: eth0: Setting full-duplex based on negotiated link capability.
> every 5 seconds. I can comment out these messages, but I would 
> like to turn off the source of wake up event. It is a bit 
> strange to see wakeup event on running system. 
> 
> Please CC me.
> 
> Thank You
> Rafał
> 
> natsemi dp8381x driver, version 2.1, Sept 11, 2006
>   originally by Donald Becker <becker@scyld.com>
>   http://www.scyld.com/network/natsemi.html
>   2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
> PCI: Setting latency timer of device 0000:00:0f.0 to 64
> natsemi eth0: NatSemi DP8381[56] at 0x10010000 (0000:00:0f.0), 00:80:64:10:c6:09, IRQ 10, port TP.
> 
> 00:0f.0 Ethernet controller: National Semiconductor Corporation DP83815 (MacPhyter) Ethernet Controller
> 	Subsystem: National Semiconductor Corporation DP83815 (MacPhyter) Ethernet Controller
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 64 (2750ns min, 13000ns max)
> 	Interrupt: pin A routed to IRQ 10
> 	Region 0: I/O ports at f800 [size=256]
> 	Region 1: Memory at 10010000 (32-bit, non-prefetchable) [size=4K]
> 	[virtual] Expansion ROM at 10000000 [disabled] [size=64K]
> 	Capabilities: [40] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=320mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
> 
> 

It seems to be repeatedly setting the same duplex setting.  The closest
thing I can see in there in recent times is
68c90166e4aaa15ddcdd4778ad30bfb8b32534be, "Add support for using MII port
with no PHY".

Does applying the below backout patch fix things?


diff -puN drivers/net/natsemi.c~a drivers/net/natsemi.c
--- a/drivers/net/natsemi.c~a
+++ a/drivers/net/natsemi.c
@@ -573,8 +573,6 @@ struct netdev_private {
 	u32 intr_status;
 	/* Do not touch the nic registers */
 	int hands_off;
-	/* Don't pay attention to the reported link state. */
-	int ignore_phy;
 	/* external phy that is used: only valid if dev->if_port != PORT_TP */
 	int mii;
 	int phy_addr_external;
@@ -703,10 +701,7 @@ static void __devinit natsemi_init_media
 	struct netdev_private *np = netdev_priv(dev);
 	u32 tmp;
 
-	if (np->ignore_phy)
-		netif_carrier_on(dev);
-	else
-		netif_carrier_off(dev);
+	netif_carrier_off(dev);
 
 	/* get the initial settings from hardware */
 	tmp            = mdio_read(dev, MII_BMCR);
@@ -816,13 +811,8 @@ static int __devinit natsemi_probe1 (str
 	np->hands_off = 0;
 	np->intr_status = 0;
 	np->eeprom_size = natsemi_pci_info[chip_idx].eeprom_size;
-	if (natsemi_pci_info[chip_idx].flags & NATSEMI_FLAG_IGNORE_PHY)
-		np->ignore_phy = 1;
-	else
-		np->ignore_phy = 0;
 
 	/* Initial port:
-	 * - If configured to ignore the PHY set up for external.
 	 * - If the nic was configured to use an external phy and if find_mii
 	 *   finds a phy: use external port, first phy that replies.
 	 * - Otherwise: internal port.
@@ -830,7 +820,7 @@ static int __devinit natsemi_probe1 (str
 	 * The address would be used to access a phy over the mii bus, but
 	 * the internal phy is accessed through mapped registers.
 	 */
-	if (np->ignore_phy || readl(ioaddr + ChipConfig) & CfgExtPhy)
+	if (readl(ioaddr + ChipConfig) & CfgExtPhy)
 		dev->if_port = PORT_MII;
 	else
 		dev->if_port = PORT_TP;
@@ -840,9 +830,7 @@ static int __devinit natsemi_probe1 (str
 
 	if (dev->if_port != PORT_TP) {
 		np->phy_addr_external = find_mii(dev);
-		/* If we're ignoring the PHY it doesn't matter if we can't
-		 * find one. */
-		if (!np->ignore_phy && np->phy_addr_external == PHY_ADDR_NONE) {
+		if (np->phy_addr_external == PHY_ADDR_NONE) {
 			dev->if_port = PORT_TP;
 			np->phy_addr_external = PHY_ADDR_INTERNAL;
 		}
@@ -908,8 +896,6 @@ static int __devinit natsemi_probe1 (str
 		printk("%02x, IRQ %d", dev->dev_addr[i], irq);
 		if (dev->if_port == PORT_TP)
 			printk(", port TP.\n");
-		else if (np->ignore_phy)
-			printk(", port MII, ignoring PHY\n");
 		else
 			printk(", port MII, phy ad %d.\n", np->phy_addr_external);
 	}
@@ -1590,13 +1576,9 @@ static void check_link(struct net_device
 {
 	struct netdev_private *np = netdev_priv(dev);
 	void __iomem * ioaddr = ns_ioaddr(dev);
-	int duplex = np->duplex;
+	int duplex;
 	u16 bmsr;
 
-	/* If we are ignoring the PHY then don't try reading it. */
-	if (np->ignore_phy)
-		goto propagate_state;
-
 	/* The link status field is latched: it remains low after a temporary
 	 * link failure until it's read. We need the current link status,
 	 * thus read twice.
@@ -1608,7 +1590,7 @@ static void check_link(struct net_device
 		if (netif_carrier_ok(dev)) {
 			if (netif_msg_link(np))
 				printk(KERN_NOTICE "%s: link down.\n",
-				       dev->name);
+					dev->name);
 			netif_carrier_off(dev);
 			undo_cable_magic(dev);
 		}
@@ -1632,7 +1614,6 @@ static void check_link(struct net_device
 			duplex = 1;
 	}
 
-propagate_state:
 	/* if duplex is set then bit 28 must be set, too */
 	if (duplex ^ !!(np->rx_config & RxAcceptTx)) {
 		if (netif_msg_link(np))
@@ -2861,15 +2842,6 @@ static int netdev_set_ecmd(struct net_de
 	}
 
 	/*
-	 * If we're ignoring the PHY then autoneg and the internal
-	 * transciever are really not going to work so don't let the
-	 * user select them.
-	 */
-	if (np->ignore_phy && (ecmd->autoneg == AUTONEG_ENABLE ||
-			       ecmd->port == PORT_TP))
-		return -EINVAL;
-
-	/*
 	 * maxtxpkt, maxrxpkt: ignored for now.
 	 *
 	 * transceiver:
_

