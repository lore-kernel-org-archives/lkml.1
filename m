Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYJ3BPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYJ3BPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYJ3BPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:15:01 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:24319 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYJ3BO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:14:59 -0400
Subject: net: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 02:14:59 +0100
Message-Id: <1225329299.5970.67.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: net: struct device - replace bus_id with dev_name(), dev_set_name()

CC: David S. Miller <davem@davemloft.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
index 9ba295d..0c0d92a 100644
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -1026,7 +1026,7 @@ static int __devinit vortex_probe1(struct device *gendev,
 		}
 
 		if ((edev = DEVICE_EISA(gendev))) {
-			print_name = edev->dev.bus_id;
+			print_name = dev_name(&edev->dev);
 		}
 	}
 
@@ -2886,7 +2886,7 @@ static void vortex_get_drvinfo(struct net_device *dev,
 		strcpy(info->bus_info, pci_name(VORTEX_PCI(vp)));
 	} else {
 		if (VORTEX_EISA(vp))
-			sprintf(info->bus_info, vp->gendev->bus_id);
+			sprintf(info->bus_info, dev_name(vp->gendev));
 		else
 			sprintf(info->bus_info, "EISA 0x%lx %d",
 					dev->base_addr, dev->irq);
diff --git a/drivers/net/cpmac.c b/drivers/net/cpmac.c
index 017a536..1d50309 100644
--- a/drivers/net/cpmac.c
+++ b/drivers/net/cpmac.c
@@ -202,7 +202,7 @@ struct cpmac_priv {
 	void __iomem *regs;
 	struct mii_bus *mii_bus;
 	struct phy_device *phy;
-	char phy_name[BUS_ID_SIZE];
+	char phy_name[20];
 	int oldlink, oldspeed, oldduplex;
 	u32 msg_enable;
 	struct net_device *dev;
diff --git a/drivers/net/defxx.c b/drivers/net/defxx.c
index c062aac..1f87701 100644
--- a/drivers/net/defxx.c
+++ b/drivers/net/defxx.c
@@ -511,7 +511,7 @@ static int __devinit dfx_register(struct device *bdev)
 	int dfx_bus_pci = DFX_BUS_PCI(bdev);
 	int dfx_bus_tc = DFX_BUS_TC(bdev);
 	int dfx_use_mmio = DFX_MMIO || dfx_bus_tc;
-	char *print_name = bdev->bus_id;
+	const char *print_name = dev_name(bdev);
 	struct net_device *dev;
 	DFX_board_t	  *bp;			/* board pointer */
 	resource_size_t bar_start = 0;		/* pointer to port */
diff --git a/drivers/net/enc28j60.c b/drivers/net/enc28j60.c
index e1b441e..5ba551f 100644
--- a/drivers/net/enc28j60.c
+++ b/drivers/net/enc28j60.c
@@ -1453,7 +1453,7 @@ enc28j60_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
 	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info,
-		dev->dev.parent->bus_id, sizeof(info->bus_info));
+		dev_name(dev->dev.parent), sizeof(info->bus_info));
 }
 
 static int
diff --git a/drivers/net/fec_mpc52xx.c b/drivers/net/fec_mpc52xx.c
index aec3b97..4a7109b 100644
--- a/drivers/net/fec_mpc52xx.c
+++ b/drivers/net/fec_mpc52xx.c
@@ -214,9 +214,9 @@ static int mpc52xx_fec_init_phy(struct net_device *dev)
 {
 	struct mpc52xx_fec_priv *priv = netdev_priv(dev);
 	struct phy_device *phydev;
-	char phy_id[BUS_ID_SIZE];
+	char phy_id[20];
 
-	snprintf(phy_id, BUS_ID_SIZE, "%x:%02x",
+	snprintf(phy_id, sizeof(phy_id), "%x:%02x",
 			(unsigned int)dev->base_addr, priv->phy_addr);
 
 	priv->link = PHY_DOWN;
diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 64b2011..e670744 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -541,14 +541,14 @@ static int init_phy(struct net_device *dev)
 		priv->einfo->device_flags & FSL_GIANFAR_DEV_HAS_GIGABIT ?
 		SUPPORTED_1000baseT_Full : 0;
 	struct phy_device *phydev;
-	char phy_id[BUS_ID_SIZE];
+	char phy_id[20];
 	phy_interface_t interface;
 
 	priv->oldlink = 0;
 	priv->oldspeed = 0;
 	priv->oldduplex = -1;
 
-	snprintf(phy_id, BUS_ID_SIZE, PHY_ID_FMT, priv->einfo->bus_id, priv->einfo->phy_id);
+	snprintf(phy_id, sizeof(phy_id), PHY_ID_FMT, priv->einfo->bus_id, priv->einfo->phy_id);
 
 	interface = gfar_get_interface(dev);
 
diff --git a/drivers/net/mlx4/mlx4_en.h b/drivers/net/mlx4/mlx4_en.h
index 11fb17c..cc02219 100644
--- a/drivers/net/mlx4/mlx4_en.h
+++ b/drivers/net/mlx4/mlx4_en.h
@@ -58,17 +58,17 @@
 #define mlx4_dbg(mlevel, priv, format, arg...)	\
 	if (NETIF_MSG_##mlevel & priv->msg_enable) \
 	printk(KERN_DEBUG "%s %s: " format , DRV_NAME ,\
-		(&priv->mdev->pdev->dev)->bus_id , ## arg)
+		(dev_name(&priv->mdev->pdev->dev)) , ## arg)
 
 #define mlx4_err(mdev, format, arg...) \
 	printk(KERN_ERR "%s %s: " format , DRV_NAME ,\
-		(&mdev->pdev->dev)->bus_id , ## arg)
+		(dev_name(&mdev->pdev->dev)) , ## arg)
 #define mlx4_info(mdev, format, arg...) \
 	printk(KERN_INFO "%s %s: " format , DRV_NAME ,\
-		(&mdev->pdev->dev)->bus_id , ## arg)
+		(dev_name(&mdev->pdev->dev)) , ## arg)
 #define mlx4_warn(mdev, format, arg...) \
 	printk(KERN_WARNING "%s %s: " format , DRV_NAME ,\
-		(&mdev->pdev->dev)->bus_id , ## arg)
+		(dev_name(&mdev->pdev->dev)) , ## arg)
 
 /*
  * Device constants
diff --git a/drivers/net/pasemi_mac.c b/drivers/net/pasemi_mac.c
index edc0fd5..dbc783c 100644
--- a/drivers/net/pasemi_mac.c
+++ b/drivers/net/pasemi_mac.c
@@ -1105,7 +1105,8 @@ static int pasemi_mac_phy_init(struct net_device *dev)
 		goto err;
 
 	phy_id = *prop;
-	snprintf(mac->phy_id, BUS_ID_SIZE, "%x:%02x", (int)r.start, phy_id);
+	snprintf(mac->phy_id, sizeof(mac->phy_id), "%x:%02x",
+		 (int)r.start, phy_id);
 
 	of_node_put(phy_dn);
 
diff --git a/drivers/net/pasemi_mac.h b/drivers/net/pasemi_mac.h
index 1a115ec..513be4d 100644
--- a/drivers/net/pasemi_mac.h
+++ b/drivers/net/pasemi_mac.h
@@ -100,7 +100,7 @@ struct pasemi_mac {
 	int	duplex;
 
 	unsigned int	msg_enable;
-	char	phy_id[BUS_ID_SIZE];
+	char	phy_id[20];
 };
 
 /* Software status descriptor (ring_info) */
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index d0ed1ef..6afd35f 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -97,7 +97,7 @@ int mdiobus_register(struct mii_bus *bus)
 	bus->dev.parent = bus->parent;
 	bus->dev.class = &mdio_bus_class;
 	bus->dev.groups = NULL;
-	memcpy(bus->dev.bus_id, bus->id, MII_BUS_ID_SIZE);
+	dev_set_name(&bus->dev, bus->id);
 
 	err = device_register(&bus->dev);
 	if (err) {
@@ -191,7 +191,7 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
 
 	phydev->dev.parent = bus->parent;
 	phydev->dev.bus = &mdio_bus_type;
-	snprintf(phydev->dev.bus_id, BUS_ID_SIZE, PHY_ID_FMT, bus->id, addr);
+	dev_set_name(&phydev->dev, PHY_ID_FMT, bus->id, addr);
 
 	phydev->bus = bus;
 
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index df4e625..e4ede60 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -45,7 +45,7 @@
  */
 void phy_print_status(struct phy_device *phydev)
 {
-	pr_info("PHY: %s - Link is %s", phydev->dev.bus_id,
+	pr_info("PHY: %s - Link is %s", dev_name(&phydev->dev),
 			phydev->link ? "Up" : "Down");
 	if (phydev->link)
 		printk(" - %d/%s", phydev->speed,
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e11b03b..e976c1c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -74,7 +74,7 @@ int phy_register_fixup(const char *bus_id, u32 phy_uid, u32 phy_uid_mask,
 	if (!fixup)
 		return -ENOMEM;
 
-	strncpy(fixup->bus_id, bus_id, BUS_ID_SIZE);
+	strlcpy(fixup->bus_id, bus_id, sizeof(fixup->bus_id));
 	fixup->phy_uid = phy_uid;
 	fixup->phy_uid_mask = phy_uid_mask;
 	fixup->run = run;
@@ -109,7 +109,7 @@ EXPORT_SYMBOL(phy_register_fixup_for_id);
  */
 static int phy_needs_fixup(struct phy_device *phydev, struct phy_fixup *fixup)
 {
-	if (strcmp(fixup->bus_id, phydev->dev.bus_id) != 0)
+	if (strcmp(fixup->bus_id, dev_name(&phydev->dev)) != 0)
 		if (strcmp(fixup->bus_id, PHY_ANY_ID) != 0)
 			return 0;
 
diff --git a/drivers/net/sh_eth.c b/drivers/net/sh_eth.c
index a24bb68..dc7bfd9 100644
--- a/drivers/net/sh_eth.c
+++ b/drivers/net/sh_eth.c
@@ -797,10 +797,10 @@ static void sh_eth_adjust_link(struct net_device *ndev)
 static int sh_eth_phy_init(struct net_device *ndev)
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
-	char phy_id[BUS_ID_SIZE];
+	char phy_id[20];
 	struct phy_device *phydev = NULL;
 
-	snprintf(phy_id, BUS_ID_SIZE, PHY_ID_FMT,
+	snprintf(phy_id, sizeof(phy_id), PHY_ID_FMT,
 		mdp->mii_bus->id , mdp->phy_id);
 
 	mdp->link = PHY_DOWN;
diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index eb9f8f3..0659078 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -1339,7 +1339,7 @@ static int tg3_phy_init(struct tg3 *tp)
 	phydev = tp->mdio_bus->phy_map[PHY_ADDR];
 
 	/* Attach the MAC to the PHY. */
-	phydev = phy_connect(tp->dev, phydev->dev.bus_id, tg3_adjust_link,
+	phydev = phy_connect(tp->dev, dev_name(&phydev->dev), tg3_adjust_link,
 			     phydev->dev_flags, phydev->interface);
 	if (IS_ERR(phydev)) {
 		printk(KERN_ERR "%s: Could not attach to PHY\n", tp->dev->name);
@@ -1357,7 +1357,7 @@ static int tg3_phy_init(struct tg3 *tp)
 
 	printk(KERN_INFO
 	       "%s: attached PHY driver [%s] (mii_bus:phy_addr=%s)\n",
-	       tp->dev->name, phydev->drv->name, phydev->dev.bus_id);
+	       tp->dev->name, phydev->drv->name, dev_name(&phydev->dev));
 
 	return 0;
 }
diff --git a/drivers/net/tulip/de4x5.c b/drivers/net/tulip/de4x5.c
index 6444cbe..02d511c 100644
--- a/drivers/net/tulip/de4x5.c
+++ b/drivers/net/tulip/de4x5.c
@@ -1119,7 +1119,7 @@ de4x5_hw_init(struct net_device *dev, u_long iobase, struct device *gendev)
     }
 
     dev->base_addr = iobase;
-    printk ("%s: %s at 0x%04lx", gendev->bus_id, name, iobase);
+    printk ("%s: %s at 0x%04lx", dev_name(gendev), name, iobase);
 
     status = get_hw_addr(dev);
     printk(", h/w address %s\n", print_mac(mac, dev->dev_addr));
@@ -1154,7 +1154,7 @@ de4x5_hw_init(struct net_device *dev, u_long iobase, struct device *gendev)
             }
         }
 	lp->fdx = lp->params.fdx;
-	sprintf(lp->adapter_name,"%s (%s)", name, gendev->bus_id);
+	sprintf(lp->adapter_name,"%s (%s)", name, dev_name(gendev));
 
 	lp->dma_size = (NUM_RX_DESC + NUM_TX_DESC) * sizeof(struct de4x5_desc);
 #if defined(__alpha__) || defined(__powerpc__) || defined(CONFIG_SPARC) || defined(DE4X5_DO_MEMCPY)
diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index c87747b..dd13e54 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -1609,14 +1609,14 @@ static int init_phy(struct net_device *dev)
 {
 	struct ucc_geth_private *priv = netdev_priv(dev);
 	struct phy_device *phydev;
-	char phy_id[BUS_ID_SIZE];
+	char phy_id[20];
 
 	priv->oldlink = 0;
 	priv->oldspeed = 0;
 	priv->oldduplex = -1;
 
-	snprintf(phy_id, BUS_ID_SIZE, PHY_ID_FMT, priv->ug_info->mdio_bus,
-			priv->ug_info->phy_address);
+	snprintf(phy_id, sizeof(phy_id), PHY_ID_FMT, priv->ug_info->mdio_bus,
+		 priv->ug_info->phy_address);
 
 	phydev = phy_connect(dev, phy_id, &adjust_link, 0, priv->phy_interface);
 
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 076a636..2d4666f 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -79,7 +79,7 @@ do { if ((lbs_debug & (grp)) == (grp)) \
 #define lbs_deb_tx(fmt, args...)        LBS_DEB_LL(LBS_DEB_TX, " tx", fmt, ##args)
 #define lbs_deb_fw(fmt, args...)        LBS_DEB_LL(LBS_DEB_FW, " fw", fmt, ##args)
 #define lbs_deb_usb(fmt, args...)       LBS_DEB_LL(LBS_DEB_USB, " usb", fmt, ##args)
-#define lbs_deb_usbd(dev, fmt, args...) LBS_DEB_LL(LBS_DEB_USB, " usbd", "%s:" fmt, (dev)->bus_id, ##args)
+#define lbs_deb_usbd(dev, fmt, args...) LBS_DEB_LL(LBS_DEB_USB, " usbd", "%s:" fmt, dev_name(dev), ##args)
 #define lbs_deb_cs(fmt, args...)        LBS_DEB_LL(LBS_DEB_CS, " cs", fmt, ##args)
 #define lbs_deb_thread(fmt, args...)    LBS_DEB_LL(LBS_DEB_THREAD, " thread", fmt, ##args)
 #define lbs_deb_sdio(fmt, args...)      LBS_DEB_LL(LBS_DEB_SDIO, " sdio", fmt, ##args)
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index e0512e4..5d24e56 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -5976,7 +5976,7 @@ static void orinoco_get_drvinfo(struct net_device *dev,
 	strncpy(info->version, DRIVER_VERSION, sizeof(info->version) - 1);
 	strncpy(info->fw_version, priv->fw_name, sizeof(info->fw_version) - 1);
 	if (dev->dev.parent)
-		strncpy(info->bus_info, dev->dev.parent->bus_id,
+		strncpy(info->bus_info, dev_name(dev->dev.parent),
 			sizeof(info->bus_info) - 1);
 	else
 		snprintf(info->bus_info, sizeof(info->bus_info) - 1,
diff --git a/drivers/net/wireless/orinoco_cs.c b/drivers/net/wireless/orinoco_cs.c
index 6fcf2bd..bf6a51d 100644
--- a/drivers/net/wireless/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco_cs.c
@@ -308,7 +308,7 @@ orinoco_cs_config(struct pcmcia_device *link)
 
 	/* Finally, report what we've done */
 	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s, irq %d, io "
-	       "0x%04x-0x%04x\n", dev->name, dev->dev.parent->bus_id,
+	       "0x%04x-0x%04x\n", dev->name, dev_name(dev->dev.parent),
 	       link->irq.AssignedIRQ, link->io.BasePort1,
 	       link->io.BasePort1 + link->io.NumPorts1 - 1);
 	return 0;
diff --git a/drivers/net/wireless/spectrum_cs.c b/drivers/net/wireless/spectrum_cs.c
index 852789a..0bae3dc 100644
--- a/drivers/net/wireless/spectrum_cs.c
+++ b/drivers/net/wireless/spectrum_cs.c
@@ -383,7 +383,7 @@ spectrum_cs_config(struct pcmcia_device *link)
 
 	/* Finally, report what we've done */
 	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s, irq %d, io "
-	       "0x%04x-0x%04x\n", dev->name, dev->dev.parent->bus_id,
+	       "0x%04x-0x%04x\n", dev->name, dev_name(dev->dev.parent),
 	       link->irq.AssignedIRQ, link->io.BasePort1,
 	       link->io.BasePort1 + link->io.NumPorts1 - 1);
 
diff --git a/include/net/wireless.h b/include/net/wireless.h
index 721efb3..58bcb9b 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -262,9 +262,9 @@ static inline struct device *wiphy_dev(struct wiphy *wiphy)
 /**
  * wiphy_name - get wiphy name
  */
-static inline char *wiphy_name(struct wiphy *wiphy)
+static inline const char *wiphy_name(struct wiphy *wiphy)
 {
-	return wiphy->dev.bus_id;
+	return dev_name(&wiphy->dev);
 }
 
 /**
diff --git a/net/atm/atm_sysfs.c b/net/atm/atm_sysfs.c
index 1b88311..b5674dc 100644
--- a/net/atm/atm_sysfs.c
+++ b/net/atm/atm_sysfs.c
@@ -149,7 +149,7 @@ int atm_register_sysfs(struct atm_dev *adev)
 	cdev->class = &atm_class;
 	dev_set_drvdata(cdev, adev);
 
-	snprintf(cdev->bus_id, BUS_ID_SIZE, "%s%d", adev->type, adev->number);
+	dev_set_name(cdev, "%s%d", adev->type, adev->number);
 	err = device_register(cdev);
 	if (err < 0)
 		return err;
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index f4f6615..f2bbb2f 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -113,8 +113,7 @@ void hci_conn_add_sysfs(struct hci_conn *conn)
 	conn->dev.class = bt_class;
 	conn->dev.parent = &hdev->dev;
 
-	snprintf(conn->dev.bus_id, BUS_ID_SIZE, "%s:%d",
-					hdev->name, conn->handle);
+	dev_set_name(&conn->dev, "%s:%d", hdev->name, conn->handle);
 
 	dev_set_drvdata(&conn->dev, conn);
 
@@ -132,7 +131,7 @@ void hci_conn_add_sysfs(struct hci_conn *conn)
  */
 static int __match_tty(struct device *dev, void *data)
 {
-	return !strncmp(dev->bus_id, "rfcomm", 6);
+	return !strncmp(dev_name(dev), "rfcomm", 6);
 }
 
 static void del_conn(struct work_struct *work)
@@ -421,7 +420,7 @@ int hci_register_sysfs(struct hci_dev *hdev)
 	dev->class = bt_class;
 	dev->parent = hdev->parent;
 
-	strlcpy(dev->bus_id, hdev->name, BUS_ID_SIZE);
+	dev_set_name(dev, hdev->name);
 
 	dev_set_drvdata(dev, hdev);
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 92d6b94..ccaa2fa 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -489,8 +489,7 @@ int netdev_register_kobject(struct net_device *net)
 	dev->platform_data = net;
 	dev->groups = groups;
 
-	BUILD_BUG_ON(BUS_ID_SIZE < IFNAMSIZ);
-	strlcpy(dev->bus_id, net->name, BUS_ID_SIZE);
+	dev_set_name(dev, net->name);
 
 #ifdef CONFIG_SYSFS
 	*groups++ = &netstat_group;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3761688..7384bad 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -284,7 +284,7 @@ dsa_slave_create(struct dsa_switch *ds, struct device *parent,
 	netif_carrier_off(slave_dev);
 
 	if (p->phy != NULL) {
-		phy_attach(slave_dev, p->phy->dev.bus_id,
+		phy_attach(slave_dev, dev_name(&p->phy->dev),
 			   0, PHY_INTERFACE_MODE_GMII);
 
 		p->phy->autoneg = AUTONEG_ENABLE;
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index f949a48..2183d33 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -711,7 +711,7 @@ static void rfkill_led_trigger_register(struct rfkill *rfkill)
 	int error;
 
 	if (!rfkill->led_trigger.name)
-		rfkill->led_trigger.name = rfkill->dev.bus_id;
+		rfkill->led_trigger.name = dev_name(&rfkill->dev);
 	if (!rfkill->led_trigger.activate)
 		rfkill->led_trigger.activate = rfkill_led_trigger_activate;
 	error = led_trigger_register(&rfkill->led_trigger);
@@ -752,8 +752,7 @@ int __must_check rfkill_register(struct rfkill *rfkill)
 			"badly initialized rfkill struct\n"))
 		return -EINVAL;
 
-	snprintf(dev->bus_id, sizeof(dev->bus_id),
-		 "rfkill%ld", (long)atomic_inc_return(&rfkill_no) - 1);
+	dev_set_name(dev, "rfkill%ld", (long)atomic_inc_return(&rfkill_no) - 1);
 
 	rfkill_led_trigger_register(rfkill);
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5031db7..1d550bf 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -236,8 +236,7 @@ struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
 	mutex_unlock(&cfg80211_drv_mutex);
 
 	/* give it a proper name */
-	snprintf(drv->wiphy.dev.bus_id, BUS_ID_SIZE,
-		 PHY_NAME "%d", drv->idx);
+	dev_set_name(&drv->wiphy.dev, PHY_NAME "%d", drv->idx);
 
 	mutex_init(&drv->mtx);
 	mutex_init(&drv->devlist_mtx);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 572793c..e0af926 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -57,7 +57,7 @@ static int get_drv_dev_by_info_ifindex(struct nlattr **attrs,
 static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
-				      .len = BUS_ID_SIZE-1 },
+				      .len = 20-1 },
 
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 77c4ed6..b1f2109 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -79,7 +79,7 @@ typedef enum {
  * Need to be a little smaller than phydev->dev.bus_id to leave room
  * for the ":%02x"
  */
-#define MII_BUS_ID_SIZE	(BUS_ID_SIZE - 3)
+#define MII_BUS_ID_SIZE	(20 - 3)
 
 /*
  * The Bus class for PHYs.  Devices which provide access to
@@ -402,7 +402,7 @@ struct phy_driver {
 /* A Structure for boards to register fixups with the PHY Lib */
 struct phy_fixup {
 	struct list_head list;
-	char bus_id[BUS_ID_SIZE];
+	char bus_id[20];
 	u32 phy_uid;
 	u32 phy_uid_mask;
 	int (*run)(struct phy_device *phydev);


