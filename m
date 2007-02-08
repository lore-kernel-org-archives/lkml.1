Return-Path: <linux-kernel-owner+w=401wt.eu-S1030231AbXBHX3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231AbXBHX3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030256AbXBHX3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:29:18 -0500
Received: (root@vger.kernel.org) by vger.kernel.org id S1030231AbXBHX3S
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:29:18 -0500
Received: from mf2.realtek.com.tw ([60.248.182.6]:2196 "EHLO
	mf2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965724AbXBHJgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 04:36:45 -0500
Message-ID: <000301c74b64$a2eaad10$083415ac@realtek.com.tw>
Illegal-Object: Syntax error in From: address found on vger.kernel.org:
	From:	=?iso-8859-1?Q?=22=B3\\=AB=ED=B9=C5=22?=<edward_hsu@realtek.com.tw>
								^-missing end of mailbox
To: <romieu@fr.zoreil.com>
Cc: <linux-kernel@vger.kernel.org>, <hiwu@realtek.com.tw>
Subject: [PATCH 2.6.20] r8169.c: support RTL8169SC/8110SC
Date: Thu, 8 Feb 2007 17:36:40 +0800
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2180
X-RFC2646: Format=Flowed; Original
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
X-MIMETrack: Itemize by SMTP Server on 
    msx/Realtek(Release 6.5.3|September 14, 2004) at 2007/02/08 
    =?Bog5?B?pFWkyCAwNTozNjo0MA==?=, Serialize by Router on 
    msx/Realtek(Release 6.5.3|September 14, 2004) at 2007/02/08 
    =?Bog5?B?pFWkyCAwNTozNjo0MQ==?=, Serialize complete at 2007/02/08 
    =?Bog5?B?pFWkyCAwNTozNjo0MQ==?=
From: Edward Hsu <edward_hsu@realtek.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for /driver/net/r8169.c to support RTL8169SC/8110SC,
which is a new Realtek Gigabit PCI Ethernet Controller. RTL8110SC's PCI DID
is 0x8167, while RTL8110S and RTL8110SB share 0x8169.

Signed-off-by: Edward Hsu <edward_hsu@realtek.com>
------------------------------------------------------------------------------

--- ./drivers/net/r8169_n.c 2007-02-09 01:12:43.000000000 +0800
+++ ./drivers/net/r8169.c 2007-02-05 02:44:54.000000000 +0800
@@ -1,29 +1,4 @@
 /*
-################################################################################
-#
-# Copyright(c) 1999 - 2007 Realtek Semiconductor Corp. All rights reserved.
-#
-# This program is free software; you can redistribute it and/or modify it
-# under the terms of the GNU General Public License as published by the 
Free
-# Software Foundation; either version 2 of the License, or (at your option)
-# any later version.
-#
-# This program is distributed in the hope that it will be useful, but 
WITHOUT
-# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-# more details.
-#
-# You should have received a copy of the GNU General Public License along 
with
-# this program; if not, write to the Free Software Foundation, Inc., 59
-# Temple Place - Suite 330, Boston, MA  02111-1307, USA.
-#
-# The full GNU General Public License is included in this distribution in 
the
-# file called LICENSE.
-#
-################################################################################
-*/
-
-/*
 =========================================================================
  r8169.c: A RealTek RTL-8169 Gigabit Ethernet driver for Linux kernel 
2.4.x.
  --------------------------------------------------------------------
@@ -76,7 +51,6 @@ VERSION 2.2LK <2005/01/25>
  */

 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/moduleparam.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
@@ -95,15 +69,13 @@ VERSION 2.2LK <2005/01/25>
 #include <asm/io.h>
 #include <asm/irq.h>

-#define NODE_ADDRESS_SIZE 6
-
 #ifdef CONFIG_R8169_NAPI
 #define NAPI_SUFFIX "-NAPI"
 #else
 #define NAPI_SUFFIX ""
 #endif

-#define RTL8169_VERSION "6.001.00" NAPI_SUFFIX
+#define RTL8169_VERSION "2.2LK" NAPI_SUFFIX
 #define MODULENAME "r8169"
 #define PFX MODULENAME ": "

@@ -137,12 +109,8 @@ VERSION 2.2LK <2005/01/25>

 /* media options */
 #define MAX_UNITS 8
-static int speed[MAX_UNITS] = { -1, -1, -1, -1, -1, -1, -1, -1 };
-static int num_speed = 0;
-static int duplex[MAX_UNITS] = { -1, -1, -1, -1, -1, -1, -1, -1 };
-static int num_duplex = 0;
-static int autoneg[MAX_UNITS] = { -1, -1, -1, -1, -1, -1, -1, -1 };
-static int num_autoneg = 0;
+static int media[MAX_UNITS] = { -1, -1, -1, -1, -1, -1, -1, -1 };
+static int num_media = 0;

 /* Maximum events (Rx packets, etc.) to handle at each interrupt. */
 static const int max_interrupt_work = 20;
@@ -155,8 +123,8 @@ static const int multicast_filter_limit
 #define MAC_ADDR_LEN 6

 #define RX_FIFO_THRESH 7 /* 7 means NO threshold, Rx buffer level before 
first PCI xfer. */
-#define RX_DMA_BURST 7 /* Maximum PCI burst, '7' is unlimited */
-#define TX_DMA_BURST 7 /* Maximum PCI burst, '7' is unlimited */
+#define RX_DMA_BURST 6 /* Maximum PCI burst, '6' is 1024 */
+#define TX_DMA_BURST 6 /* Maximum PCI burst, '6' is 1024 */
 #define EarlyTxThld  0x3F /* 0x3F means NO early transmit */
 #define RxPacketMaxSize 0x3FE8 /* 16K - 1 - ETH_HLEN - VLAN - CRC... */
 #define SafeMtu  0x1c20 /* ... actually life sucks beyond ~7k */
@@ -182,12 +150,16 @@ static const int multicast_filter_limit
 #define RTL_R32(reg)  ((unsigned long) readl (ioaddr + (reg)))

 enum mac_version {
- RTL_GIGA_MAC_VER_8169 = 0x00,
- RTL_GIGA_MAC_VER_8169S = 0x01,
- RTL_GIGA_MAC_VER_8110S = 0x02,
- RTL_GIGA_MAC_VER_8169SB = 0x04,
- RTL_GIGA_MAC_VER_8110SCd = 0x05,
- RTL_GIGA_MAC_VER_8110SCe = 0x06,
+ RTL_GIGA_MAC_VER_01 = 0x00,
+ RTL_GIGA_MAC_VER_02 = 0x01,
+ RTL_GIGA_MAC_VER_03 = 0x02,
+ RTL_GIGA_MAC_VER_04 = 0x03,
+ RTL_GIGA_MAC_VER_05 = 0x04,
+ RTL_GIGA_MAC_VER_11 = 0x0b,
+ RTL_GIGA_MAC_VER_12 = 0x0c,
+ RTL_GIGA_MAC_VER_13 = 0x0d,
+ RTL_GIGA_MAC_VER_14 = 0x0e,
+ RTL_GIGA_MAC_VER_15 = 0x0f
 };

 enum phy_version {
@@ -207,12 +179,16 @@ static const struct {
  u8 mac_version;
  u32 RxConfigMask; /* Clears the bits supported by this chip */
 } rtl_chip_info[] = {
- _R("RTL8169", RTL_GIGA_MAC_VER_8169, 0xff7e1880),
- _R("RTL8169S/8110S", RTL_GIGA_MAC_VER_8169S, 0xff7e1880),
- _R("RTL8169S/8110S", RTL_GIGA_MAC_VER_8110S, 0xff7e1880),
- _R("RTL8169SB/8110SB", RTL_GIGA_MAC_VER_8169SB, 0xff7e1880),
- _R("RTL8169SC/8110SC", RTL_GIGA_MAC_VER_8110SCd, 0xff7e1880),
- _R("RTL8169SC/8110SC", RTL_GIGA_MAC_VER_8110SCe, 0xff7e1880),
+ _R("RTL8169",  RTL_GIGA_MAC_VER_01, 0xff7e1880),
+ _R("RTL8169s/8110s", RTL_GIGA_MAC_VER_02, 0xff7e1880),
+ _R("RTL8169s/8110s", RTL_GIGA_MAC_VER_03, 0xff7e1880),
+ _R("RTL8169sb/8110sb", RTL_GIGA_MAC_VER_04, 0xff7e1880),
+ _R("RTL8169sc/8110sc", RTL_GIGA_MAC_VER_05, 0xff7e1880),
+ _R("RTL8168b/8111b", RTL_GIGA_MAC_VER_11, 0xff7e1880), // PCI-E
+ _R("RTL8168b/8111b", RTL_GIGA_MAC_VER_12, 0xff7e1880), // PCI-E
+ _R("RTL8101e",  RTL_GIGA_MAC_VER_13, 0xff7e1880), // PCI-E 8139
+ _R("RTL8100e",  RTL_GIGA_MAC_VER_14, 0xff7e1880), // PCI-E 8139
+ _R("RTL8100e",  RTL_GIGA_MAC_VER_15, 0xff7e1880)  // PCI-E 8139
 };
 #undef _R

@@ -232,7 +208,10 @@ static const struct {
 };

 static struct pci_device_id rtl8169_pci_tbl[] = {
+ { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8129), 0, 0, RTL_CFG_0 },
+ { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8136), 0, 0, RTL_CFG_2 },
  { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8167), 0, 0, RTL_CFG_0 },
+ { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8168), 0, 0, RTL_CFG_2 },
  { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8169), 0, 0, RTL_CFG_0 },
  { PCI_DEVICE(PCI_VENDOR_ID_DLINK, 0x4300), 0, 0, RTL_CFG_0 },
  { PCI_DEVICE(0x1259,   0xc107), 0, 0, RTL_CFG_0 },
@@ -251,9 +230,8 @@ static struct {
 } debug = { -1 };

 enum RTL8169_registers {
- MAC0 = 0x00,  /* Ethernet hardware address. */
- MAC4 = 0x04,
- MAR0 = 0x08,  /* Multicast filter. */
+ MAC0 = 0,  /* Ethernet hardware address. */
+ MAR0 = 8,  /* Multicast filter. */
  CounterAddrLow = 0x10,
  CounterAddrHigh = 0x14,
  TxDescStartAddrLow = 0x20,
@@ -282,7 +260,6 @@ enum RTL8169_registers {
  TBI_ANAR = 0x68,
  TBI_LPAR = 0x6A,
  PHYstatus = 0x6C,
- Offset_7Ch = 0x7C,
  RxMaxSize = 0xDA,
  CPlusCmd = 0xE0,
  IntrMitigate = 0xE2,
@@ -310,6 +287,7 @@ enum RTL8169_register_content {
  RxOK = 0x01,

  /* RxStatusDesc */
+ RxFOVF = (1 << 23),
  RxRWT = (1 << 22),
  RxRES = (1 << 21),
  RxRUNT = (1 << 20),
@@ -344,10 +322,6 @@ enum RTL8169_register_content {
  /* Config1 register p.24 */
  PMEnable = (1 << 0), /* Power Management Enable */

- /* Config2 register p.26 */
- PCI_Clock_66MHz = 0x01,
- PCI_Clock_33MHz = 0x00,
-
  /* Config3 register p.25 */
  MagicPacket = (1 << 5), /* Wake up when receives a Magic Packet */
  LinkUp  = (1 << 4), /* Wake up when the cable connection is re-established 
*/
@@ -383,6 +357,13 @@ enum RTL8169_register_content {
  LinkStatus = 0x02,
  FullDup = 0x01,

+ /* _MediaType */
+ _10_Half = 0x01,
+ _10_Full = 0x02,
+ _100_Half = 0x04,
+ _100_Full = 0x08,
+ _1000_Full = 0x10,
+
  /* _TBICSRBit */
  TBILinkOK = 0x02000000,

@@ -467,7 +448,6 @@ struct rtl8169_private {
  u16 intr_mask;
  int phy_auto_nego_reg;
  int phy_1000_ctrl_reg;
- u8 mac_addr[NODE_ADDRESS_SIZE];
 #ifdef CONFIG_R8169_VLAN
  struct vlan_group *vlgrp;
 #endif
@@ -476,24 +456,14 @@ struct rtl8169_private {
  void (*phy_reset_enable)(void __iomem *);
  unsigned int (*phy_reset_pending)(void __iomem *);
  unsigned int (*link_ok)(void __iomem *);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
- struct work_struct task;
-#else
  struct delayed_work task;
-#endif
  unsigned wol_enabled : 1;
 };

 MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
 MODULE_DESCRIPTION("RealTek RTL-8169 Gigabit Ethernet driver");
-
-module_param_array(speed, int, &num_speed, 0);
-MODULE_PARM_DESC(speed, "force phy operation. Deprecated by ethtool (8).");
-module_param_array(duplex, int, &num_duplex, 0);
-MODULE_PARM_DESC(duplex, "force phy operation. Deprecated by ethtool 
(8).");
-module_param_array(autoneg, int, &num_autoneg, 0);
-MODULE_PARM_DESC(autoneg, "force phy operation. Deprecated by ethtool 
(8).");
-
+module_param_array(media, int, &num_media, 0);
+MODULE_PARM_DESC(media, "force phy operation. Deprecated by ethtool (8).");
 module_param(rx_copybreak, int, 0);
 MODULE_PARM_DESC(rx_copybreak, "Copy breakpoint for 
copy-only-tiny-frames");
 module_param(use_dac, int, 0);
@@ -505,11 +475,7 @@ MODULE_VERSION(RTL8169_VERSION);

 static int rtl8169_open(struct net_device *dev);
 static int rtl8169_start_xmit(struct sk_buff *skb, struct net_device *dev);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
-static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance, struct 
pt_regs *regs);
-#else
 static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance);
-#endif
 static int rtl8169_init_ring(struct net_device *dev);
 static void rtl8169_hw_start(struct net_device *dev);
 static int rtl8169_close(struct net_device *dev);
@@ -520,8 +486,6 @@ static int rtl8169_rx_interrupt(struct n
     void __iomem *);
 static int rtl8169_change_mtu(struct net_device *dev, int new_mtu);
 static void rtl8169_down(struct net_device *dev);
-static int rtl8169_set_mac_address(struct net_device *dev, void *p);
-void rtl8169_rar_set(struct rtl8169_private *tp, uint8_t *addr, uint32_t 
index);

 #ifdef CONFIG_R8169_NAPI
 static int rtl8169_poll(struct net_device *dev, int *budget);
@@ -630,28 +594,36 @@ static void rtl8169_check_link_status(st
  spin_unlock_irqrestore(&tp->lock, flags);
 }

-static void
-rtl8169_link_option(int idx, u8 *aut, u16 *spd, u8 *dup)
+static void rtl8169_link_option(int idx, u8 *autoneg, u16 *speed, u8 
*duplex)
 {
- unsigned char opt_speed;
- unsigned char opt_duplex;
- unsigned char opt_autoneg;
-
- opt_speed = ((idx < MAX_UNITS) && (idx >= 0)) ? speed[idx] : 0xff;
- opt_duplex = ((idx < MAX_UNITS) && (idx >= 0)) ? duplex[idx] : 0xff;
- opt_autoneg = ((idx < MAX_UNITS) && (idx >= 0)) ? autoneg[idx] : 0xff;
-
- if ((opt_speed == 0xff) |
-     (opt_duplex == 0xff) |
-     (opt_autoneg == 0xff)) {
-  *spd = SPEED_1000;
-  *dup = DUPLEX_FULL;
-  *aut = AUTONEG_ENABLE;
- } else {
-  *spd = speed[idx];
-  *dup = duplex[idx];
-  *aut = autoneg[idx];
+ struct {
+  u16 speed;
+  u8 duplex;
+  u8 autoneg;
+  u8 media;
+ } link_settings[] = {
+  { SPEED_10, DUPLEX_HALF, AUTONEG_DISABLE, _10_Half },
+  { SPEED_10, DUPLEX_FULL, AUTONEG_DISABLE, _10_Full },
+  { SPEED_100, DUPLEX_HALF, AUTONEG_DISABLE, _100_Half },
+  { SPEED_100, DUPLEX_FULL, AUTONEG_DISABLE, _100_Full },
+  { SPEED_1000, DUPLEX_FULL, AUTONEG_DISABLE, _1000_Full },
+  /* Make TBI happy */
+  { SPEED_1000, DUPLEX_FULL, AUTONEG_ENABLE, 0xff }
+ }, *p;
+ unsigned char option;
+
+ option = ((idx < MAX_UNITS) && (idx >= 0)) ? media[idx] : 0xff;
+
+ if ((option != 0xff) && !idx && netif_msg_drv(&debug))
+  printk(KERN_WARNING PFX "media option is deprecated.\n");
+
+ for (p = link_settings; p->media != 0xff; p++) {
+  if (p->media == option)
+   break;
  }
+ *autoneg = p->autoneg;
+ *speed = p->speed;
+ *duplex = p->duplex;
 }

 static void rtl8169_get_wol(struct net_device *dev, struct ethtool_wolinfo 
*wol)
@@ -777,54 +749,48 @@ static int rtl8169_set_speed_xmii(struct
  int auto_nego, giga_ctrl;

  auto_nego = mdio_read(ioaddr, MII_ADVERTISE);
- auto_nego &= ~(ADVERTISE_10HALF |
-         ADVERTISE_10FULL |
-         ADVERTISE_100HALF |
-         ADVERTISE_100FULL);
-
+ auto_nego &= ~(ADVERTISE_10HALF | ADVERTISE_10FULL |
+         ADVERTISE_100HALF | ADVERTISE_100FULL);
  giga_ctrl = mdio_read(ioaddr, MII_CTRL1000);
  giga_ctrl &= ~(ADVERTISE_1000FULL | ADVERTISE_1000HALF);

  if (autoneg == AUTONEG_ENABLE) {
-  auto_nego |= (ADVERTISE_10HALF |
-         ADVERTISE_10FULL |
-         ADVERTISE_100HALF |
-         ADVERTISE_100FULL);
-
+  auto_nego |= (ADVERTISE_10HALF | ADVERTISE_10FULL |
+         ADVERTISE_100HALF | ADVERTISE_100FULL);
   giga_ctrl |= ADVERTISE_1000FULL | ADVERTISE_1000HALF;
  } else {
-  if ((speed != SPEED_1000) &&
-      (speed != SPEED_100) &&
-      (speed != SPEED_10)) {
-   speed = SPEED_1000;
-   duplex = DUPLEX_FULL;
- }
-
-  if ((speed == SPEED_10) && (duplex == DUPLEX_HALF))
-   auto_nego |= ADVERTISE_10HALF;
-  else if ((speed == SPEED_10) && (duplex == DUPLEX_FULL))
-   auto_nego |= ADVERTISE_10HALF |
-         ADVERTISE_10FULL;
-  else if ((speed == SPEED_100) && (duplex == DUPLEX_HALF))
-   auto_nego |= ADVERTISE_100HALF |
-         ADVERTISE_10HALF |
-         ADVERTISE_10FULL;
-  else if ((speed == SPEED_100) && (duplex == DUPLEX_FULL))
-   auto_nego |= ADVERTISE_100HALF |
-         ADVERTISE_100FULL |
-         ADVERTISE_10HALF |
-         ADVERTISE_10FULL;
-  else if (speed == SPEED_1000) {
-   giga_ctrl |= ADVERTISE_1000HALF |
-         ADVERTISE_1000FULL;
-
-   auto_nego |= ADVERTISE_100HALF |
-         ADVERTISE_100FULL |
-         ADVERTISE_10HALF |
-         ADVERTISE_10FULL;
+  if (speed == SPEED_10)
+   auto_nego |= ADVERTISE_10HALF | ADVERTISE_10FULL;
+  else if (speed == SPEED_100)
+   auto_nego |= ADVERTISE_100HALF | ADVERTISE_100FULL;
+  else if (speed == SPEED_1000)
+   giga_ctrl |= ADVERTISE_1000FULL | ADVERTISE_1000HALF;
+
+  if (duplex == DUPLEX_HALF)
+   auto_nego &= ~(ADVERTISE_10FULL | ADVERTISE_100FULL);
+
+  if (duplex == DUPLEX_FULL)
+   auto_nego &= ~(ADVERTISE_10HALF | ADVERTISE_100HALF);
+
+  /* This tweak comes straight from Realtek's driver. */
+  if ((speed == SPEED_100) && (duplex == DUPLEX_HALF) &&
+      (tp->mac_version == RTL_GIGA_MAC_VER_13)) {
+   auto_nego = ADVERTISE_100HALF | ADVERTISE_CSMA;
   }
  }

+ /* The 8100e/8101e do Fast Ethernet only. */
+ if ((tp->mac_version == RTL_GIGA_MAC_VER_13) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_14) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_15)) {
+  if ((giga_ctrl & (ADVERTISE_1000FULL | ADVERTISE_1000HALF)) &&
+      netif_msg_link(tp)) {
+   printk(KERN_INFO "%s: PHY does not support 1000Mbps.\n",
+          dev->name);
+  }
+  giga_ctrl &= ~(ADVERTISE_1000FULL | ADVERTISE_1000HALF);
+ }
+
  auto_nego |= ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM;

  tp->phy_auto_nego_reg = auto_nego;
@@ -832,8 +798,7 @@ static int rtl8169_set_speed_xmii(struct

  mdio_write(ioaddr, MII_ADVERTISE, auto_nego);
  mdio_write(ioaddr, MII_CTRL1000, giga_ctrl);
- mdio_write(ioaddr, MII_BMCR, BMCR_ANENABLE |
-         BMCR_ANRESTART);
+ mdio_write(ioaddr, MII_BMCR, BMCR_ANENABLE | BMCR_ANRESTART);
  return 0;
 }

@@ -1020,7 +985,6 @@ static void rtl8169_gset_xmii(struct net

  if (status & TxFlowCtrl)
   cmd->advertising |= ADVERTISED_Asym_Pause;
-
  if (status & RxFlowCtrl)
   cmd->advertising |= ADVERTISED_Pause;

@@ -1203,16 +1167,20 @@ static void rtl8169_get_mac_version(stru
   u32 mask;
   int mac_version;
  } mac_info[] = {
-  { 0x18000000, RTL_GIGA_MAC_VER_8110SCd },
-  { 0x98000000, RTL_GIGA_MAC_VER_8110SCe },
-  { 0x1 << 28, RTL_GIGA_MAC_VER_8169SB },
-  { 0x1 << 26, RTL_GIGA_MAC_VER_8110S },
-  { 0x1 << 23, RTL_GIGA_MAC_VER_8169S },
-  { 0x00000000, RTL_GIGA_MAC_VER_8169 } /* Catch-all */
+  { 0x38800000, RTL_GIGA_MAC_VER_15 },
+  { 0x38000000, RTL_GIGA_MAC_VER_12 },
+  { 0x34000000, RTL_GIGA_MAC_VER_13 },
+  { 0x30800000, RTL_GIGA_MAC_VER_14 },
+  { 0x30000000, RTL_GIGA_MAC_VER_11 },
+  { 0x18000000, RTL_GIGA_MAC_VER_05 },
+  { 0x10000000, RTL_GIGA_MAC_VER_04 },
+  { 0x04000000, RTL_GIGA_MAC_VER_03 },
+  { 0x00800000, RTL_GIGA_MAC_VER_02 },
+  { 0x00000000, RTL_GIGA_MAC_VER_01 } /* Catch-all */
  }, *p = mac_info;
  u32 reg;

- reg = RTL_R32(TxConfig) & 0xfc800000;
+ reg = RTL_R32(TxConfig) & 0x7c800000;
  while ((reg & p->mask) != p->mask)
   p++;
  tp->mac_version = p->mac_version;
@@ -1305,7 +1273,7 @@ static void rtl8169_hw_phy_config(struct
  rtl8169_print_mac_version(tp);
  rtl8169_print_phy_version(tp);

- if (tp->mac_version <= RTL_GIGA_MAC_VER_8169)
+ if (tp->mac_version <= RTL_GIGA_MAC_VER_01)
   return;
  if (tp->phy_version >= RTL_GIGA_PHY_VER_H)
   return;
@@ -1315,7 +1283,7 @@ static void rtl8169_hw_phy_config(struct

  /* Shazam ! */

- if (tp->mac_version == RTL_GIGA_MAC_VER_8169SB) {
+ if (tp->mac_version == RTL_GIGA_MAC_VER_04) {
   mdio_write(ioaddr, 31, 0x0002);
   mdio_write(ioaddr,  1, 0x90d0);
   mdio_write(ioaddr, 31, 0x0000);
@@ -1349,7 +1317,7 @@ static void rtl8169_phy_timer(unsigned l
  void __iomem *ioaddr = tp->mmio_addr;
  unsigned long timeout = RTL8169_PHY_TIMEOUT;

- assert(tp->mac_version > RTL_GIGA_MAC_VER_8169);
+ assert(tp->mac_version > RTL_GIGA_MAC_VER_01);
  assert(tp->phy_version < RTL_GIGA_PHY_VER_H);

  if (!(tp->phy_1000_ctrl_reg & ADVERTISE_1000FULL))
@@ -1385,7 +1353,7 @@ static inline void rtl8169_delete_timer(
  struct rtl8169_private *tp = netdev_priv(dev);
  struct timer_list *timer = &tp->timer;

- if ((tp->mac_version <= RTL_GIGA_MAC_VER_8169) ||
+ if ((tp->mac_version <= RTL_GIGA_MAC_VER_01) ||
      (tp->phy_version >= RTL_GIGA_PHY_VER_H))
   return;

@@ -1397,7 +1365,7 @@ static inline void rtl8169_request_timer
  struct rtl8169_private *tp = netdev_priv(dev);
  struct timer_list *timer = &tp->timer;

- if ((tp->mac_version <= RTL_GIGA_MAC_VER_8169) ||
+ if ((tp->mac_version <= RTL_GIGA_MAC_VER_01) ||
      (tp->phy_version >= RTL_GIGA_PHY_VER_H))
   return;

@@ -1420,11 +1388,7 @@ static void rtl8169_netpoll(struct net_d
  struct pci_dev *pdev = tp->pci_dev;

  disable_irq(pdev->irq);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
- rtl8169_interrupt(pdev->irq, dev, NULL);
-#else
  rtl8169_interrupt(pdev->irq, dev);
-#endif
  enable_irq(pdev->irq);
 }
 #endif
@@ -1438,61 +1402,6 @@ static void rtl8169_release_board(struct
  free_netdev(dev);
 }

-/**
- * rtl8169_set_mac_address - Change the Ethernet Address of the NIC
- * @dev: network interface device structure
- * @p:   pointer to an address structure
- *
- * Return 0 on success, negative on failure
- **/
-static int
-rtl8169_set_mac_address(struct net_device *dev,
-   void *p)
-{
- struct rtl8169_private *tp = netdev_priv(dev);
- struct sockaddr *addr = p;
-
- if (!is_valid_ether_addr(addr->sa_data))
-  return -EADDRNOTAVAIL;
-
- memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
- memcpy(tp->mac_addr, addr->sa_data, dev->addr_len);
-
- rtl8169_rar_set(tp, tp->mac_addr, 0);
-
- return 0;
-}
-
-/******************************************************************************
- * rtl8169_rar_set - Puts an ethernet address into a receive address 
register.
- *
- * tp - The private data structure for driver
- * addr - Address to put into receive address register
- * index - Receive address register to write
- 
*****************************************************************************/
-void
-rtl8169_rar_set(struct rtl8169_private *tp,
-  uint8_t *addr,
-  uint32_t index)
-{
- void __iomem *ioaddr = tp->mmio_addr;
- uint32_t rar_low = 0;
- uint32_t rar_high = 0;
-
- rar_low = ((uint32_t) addr[0] |
-    ((uint32_t) addr[1] << 8) |
-    ((uint32_t) addr[2] << 16) |
-    ((uint32_t) addr[3] << 24));
-
- rar_high = ((uint32_t) addr[4] |
-     ((uint32_t) addr[5] << 8));
-
- RTL_W8(Cfg9346, Cfg9346_Unlock);
- RTL_W32(MAC0, rar_low);
- RTL_W32(MAC4, rar_high);
- RTL_W8(Cfg9346, Cfg9346_Lock);
-}
-
 static void rtl8169_phy_reset(struct net_device *dev,
          struct rtl8169_private *tp)
 {
@@ -1523,12 +1432,12 @@ static void rtl8169_init_phy(struct net_
  dprintk("Set MAC Reg C+CR Offset 0x82h = 0x01h\n");
  RTL_W8(0x82, 0x01);

- if (tp->mac_version < RTL_GIGA_MAC_VER_8110S) {
+ if (tp->mac_version < RTL_GIGA_MAC_VER_03) {
   dprintk("Set PCI Latency=0x40\n");
   pci_write_config_byte(tp->pci_dev, PCI_LATENCY_TIMER, 0x40);
  }

- if (tp->mac_version == RTL_GIGA_MAC_VER_8169S) {
+ if (tp->mac_version == RTL_GIGA_MAC_VER_02) {
   dprintk("Set MAC Reg C+CR Offset 0x82h = 0x01h\n");
   RTL_W8(0x82, 0x01);
   dprintk("Set PHY Reg 0x0bh = 0x00h\n");
@@ -1744,7 +1653,6 @@ rtl8169_init_one(struct pci_dev *pdev, c
  for (i = 0; i < MAC_ADDR_LEN; i++)
   dev->dev_addr[i] = RTL_R8(MAC0 + i);
  memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
- memcpy(dev->dev_addr, dev->dev_addr, dev->addr_len);

  dev->open = rtl8169_open;
  dev->hard_start_xmit = rtl8169_start_xmit;
@@ -1757,7 +1665,6 @@ rtl8169_init_one(struct pci_dev *pdev, c
  dev->irq = pdev->irq;
  dev->base_addr = (unsigned long) ioaddr;
  dev->change_mtu = rtl8169_change_mtu;
- dev->set_mac_address = rtl8169_set_mac_address;

 #ifdef CONFIG_R8169_NAPI
  dev->poll = rtl8169_poll;
@@ -1872,11 +1779,7 @@ static int rtl8169_open(struct net_devic
  if (retval < 0)
   goto err_free_rx;

-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
- INIT_WORK(&tp->task, NULL, dev);
-#else
  INIT_DELAYED_WORK(&tp->task, NULL);
-#endif

  rtl8169_hw_start(dev);

@@ -1909,11 +1812,25 @@ static void rtl8169_hw_reset(void __iome
  RTL_R8(ChipCmd);
 }

+static void rtl8169_set_rx_tx_config_registers(struct rtl8169_private *tp)
+{
+ void __iomem *ioaddr = tp->mmio_addr;
+ u32 cfg = rtl8169_rx_config;
+
+ cfg |= (RTL_R32(RxConfig) & rtl_chip_info[tp->chipset].RxConfigMask);
+ RTL_W32(RxConfig, cfg);
+
+ /* Set DMA burst size and Interframe Gap Time */
+ RTL_W32(TxConfig, (TX_DMA_BURST << TxDMAShift) |
+  (InterFrameGap << TxInterFrameGapShift));
+}
+
 static void rtl8169_hw_start(struct net_device *dev)
 {
  struct rtl8169_private *tp = netdev_priv(dev);
  void __iomem *ioaddr = tp->mmio_addr;
  struct pci_dev *pdev = tp->pci_dev;
+ u16 cmd;
  u32 i;

  /* Soft reset the chip. */
@@ -1926,43 +1843,64 @@ static void rtl8169_hw_start(struct net_
   msleep_interruptible(1);
  }

+ if (tp->mac_version == RTL_GIGA_MAC_VER_05) {
+  RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) | PCIMulRW);
+  pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, 0x08);
+ }
+
+ if (tp->mac_version == RTL_GIGA_MAC_VER_13) {
+  pci_write_config_word(pdev, 0x68, 0x00);
+  pci_write_config_word(pdev, 0x69, 0x08);
+ }
+
+ /* Undocumented stuff. */
+ if (tp->mac_version == RTL_GIGA_MAC_VER_05) {
+  /* Realtek's r1000_n.c driver uses '&& 0x01' here. Well... */
+  if ((RTL_R8(Config2) & 0x07) & 0x01)
+   RTL_W32(0x7c, 0x0007ffff);
+
+  RTL_W32(0x7c, 0x0007ff00);
+
+  pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+  cmd = cmd & 0xef;
+  pci_write_config_word(pdev, PCI_COMMAND, cmd);
+ }
+
  RTL_W8(Cfg9346, Cfg9346_Unlock);
+ if ((tp->mac_version == RTL_GIGA_MAC_VER_01) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_02) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_03) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_04))
+  RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);

  RTL_W8(EarlyTxThres, EarlyTxThld);

  /* Low hurts. Let's disable the filtering. */
  RTL_W16(RxMaxSize, 16383);

- tp->cp_cmd |= RTL_R16(CPlusCmd);
- RTL_W16(CPlusCmd, tp->cp_cmd);
-
- RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) | PCIMulRW);
- pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, 0x08);
+ if ((tp->mac_version == RTL_GIGA_MAC_VER_01) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_02) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_03) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_04))
+  rtl8169_set_rx_tx_config_registers(tp);

- pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x40);
+ cmd = RTL_R16(CPlusCmd);
+ RTL_W16(CPlusCmd, cmd);

- if (RTL_R8(Config2) & PCI_Clock_66MHz) {
-  if (tp->mac_version == RTL_GIGA_MAC_VER_8110SCd)
-   RTL_W32(Offset_7Ch, 0x000FFFFF);
-  else if (tp->mac_version == RTL_GIGA_MAC_VER_8110SCe)
-   RTL_W32(Offset_7Ch, 0x00FFFFFF);
- } else {
-  if (tp->mac_version == RTL_GIGA_MAC_VER_8110SCd)
-   RTL_W32(Offset_7Ch, 0x000FFF00);
-  else if (tp->mac_version == RTL_GIGA_MAC_VER_8110SCe)
-   RTL_W32(Offset_7Ch, 0x00FFFF00);
- }
+ tp->cp_cmd |= cmd | PCIMulRW;

- if ((tp->mac_version == RTL_GIGA_MAC_VER_8169S) ||
-     (tp->mac_version == RTL_GIGA_MAC_VER_8110S)) {
+ if ((tp->mac_version == RTL_GIGA_MAC_VER_02) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_03)) {
   dprintk(KERN_INFO PFX "Set MAC Reg C+CR Offset 0xE0. "
    "Bit-3 and bit-14 MUST be 1\n");
-  tp->cp_cmd |= (1 << 14) | PCIMulRW;
- RTL_W16(CPlusCmd, tp->cp_cmd);
+  tp->cp_cmd |= (1 << 14);
  }

+ RTL_W16(CPlusCmd, tp->cp_cmd);
+
  /*
   * Undocumented corner. Supposedly:
+  * (TxTimer << 12) | (TxPackets << 8) | (RxTimer << 4) | RxPackets
   */
  RTL_W16(IntrMitigate, 0x0000);

@@ -1971,35 +1909,34 @@ static void rtl8169_hw_start(struct net_
   * register to be written before TxDescAddrLow to work.
   * Switching from MMIO to I/O access fixes the issue as well.
   */
- RTL_W32(TxDescStartAddrLow, ((u64) tp->TxPhyAddr & DMA_32BIT_MASK));
  RTL_W32(TxDescStartAddrHigh, ((u64) tp->TxPhyAddr >> 32));
- RTL_W32(RxDescAddrLow, ((u64) tp->RxPhyAddr & DMA_32BIT_MASK));
+ RTL_W32(TxDescStartAddrLow, ((u64) tp->TxPhyAddr & DMA_32BIT_MASK));
  RTL_W32(RxDescAddrHigh, ((u64) tp->RxPhyAddr >> 32));
+ RTL_W32(RxDescAddrLow, ((u64) tp->RxPhyAddr & DMA_32BIT_MASK));
+
+ if ((tp->mac_version != RTL_GIGA_MAC_VER_01) &&
+     (tp->mac_version != RTL_GIGA_MAC_VER_02) &&
+     (tp->mac_version != RTL_GIGA_MAC_VER_03) &&
+     (tp->mac_version != RTL_GIGA_MAC_VER_04)) {
+  RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
+  rtl8169_set_rx_tx_config_registers(tp);
+ }

  RTL_W8(Cfg9346, Cfg9346_Lock);

- udelay(10);
+ /* Initially a 10 us delay. Turned it into a PCI commit. - FR */
+ RTL_R8(IntrMask);

  RTL_W32(RxMissed, 0);

+ rtl8169_set_rx_mode(dev);
+
  /* no early-rx interrupts */
  RTL_W16(MultiIntr, RTL_R16(MultiIntr) & 0xF000);

- /* Clear the interrupt status. */
- RTL_W16(IntrStatus, 0xFFFF);
-
  /* Enable all known interrupts by setting the interrupt mask. */
  RTL_W16(IntrMask, rtl8169_intr_mask);

- RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
-
- /* Set Rx Config register */
- rtl8169_set_rx_mode(dev);
-
- /* Set DMA burst size and Interframe Gap Time */
- RTL_W32(TxConfig, (TX_DMA_BURST << TxDMAShift) |
-     (InterFrameGap << TxInterFrameGapShift));
-
  netif_start_queue(dev);
 }

@@ -2194,15 +2131,6 @@ static void rtl8169_tx_clear(struct rtl8
  tp->cur_tx = tp->dirty_tx = 0;
 }

-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-static void rtl8169_schedule_work(struct net_device *dev, void (*task)(void 
*))
-{
- struct rtl8169_private *tp = netdev_priv(dev);
-
- PREPARE_WORK(&tp->task, task, dev);
- schedule_delayed_work(&tp->task, 4);
-}
-#else
 static void rtl8169_schedule_work(struct net_device *dev, work_func_t task)
 {
  struct rtl8169_private *tp = netdev_priv(dev);
@@ -2210,7 +2138,6 @@ static void rtl8169_schedule_work(struct
  PREPARE_DELAYED_WORK(&tp->task, task);
  schedule_delayed_work(&tp->task, 4);
 }
-#endif

 static void rtl8169_wait_for_quiescence(struct net_device *dev)
 {
@@ -2227,19 +2154,11 @@ static void rtl8169_wait_for_quiescence(
  netif_poll_enable(dev);
 }

-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-static void rtl8169_reinit_task(void *_data)
-#else
 static void rtl8169_reinit_task(struct work_struct *work)
-#endif
 {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
- struct net_device *dev = _data;
-#else
  struct rtl8169_private *tp =
   container_of(work, struct rtl8169_private, task.work);
  struct net_device *dev = tp->dev;
-#endif
  int ret;

  if (netif_running(dev)) {
@@ -2262,18 +2181,11 @@ static void rtl8169_reinit_task(struct w
  }
 }

-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-static void rtl8169_reset_task(void *_data)
-{
- struct net_device *dev = _data;
- struct rtl8169_private *tp = netdev_priv(dev);
-#else
 static void rtl8169_reset_task(struct work_struct *work)
 {
  struct rtl8169_private *tp =
   container_of(work, struct rtl8169_private, task.work);
  struct net_device *dev = tp->dev;
-#endif

  if (!netif_running(dev))
   return;
@@ -2315,7 +2227,7 @@ static int rtl8169_xmit_frags(struct rtl
 {
  struct skb_shared_info *info = skb_shinfo(skb);
  unsigned int cur_frag, entry;
- struct TxDesc *txd = NULL;
+ struct TxDesc *txd;

  entry = tp->cur_tx;
  for (cur_frag = 0; cur_frag < info->nr_frags; cur_frag++) {
@@ -2356,11 +2268,7 @@ static inline u32 rtl8169_tso_csum(struc
   if (mss)
    return LargeSend | ((mss & MSSMask) << MSSShift);
  }
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
- if (skb->ip_summed == CHECKSUM_HW) {
-#else
  if (skb->ip_summed == CHECKSUM_PARTIAL) {
-#endif
   const struct iphdr *ip = skb->nh.iph;

   if (ip->protocol == IPPROTO_TCP)
@@ -2625,6 +2533,10 @@ rtl8169_rx_interrupt(struct net_device *
     tp->stats.rx_length_errors++;
    if (status & RxCRC)
     tp->stats.rx_crc_errors++;
+   if (status & RxFOVF) {
+    rtl8169_schedule_work(dev, rtl8169_reset_task);
+    tp->stats.rx_fifo_errors++;
+   }
    rtl8169_mark_to_asic(desc, tp->rx_buf_sz);
   } else {
    struct sk_buff *skb = tp->Rx_skbuff[entry];
@@ -2694,11 +2606,8 @@ rtl8169_rx_interrupt(struct net_device *
 }

 /* The interrupt handler does all of the Rx thread work and cleans up after 
the Tx thread. */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
-static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance, struct 
pt_regs *regs)
-#else
-static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
-#endif
+static irqreturn_t
+rtl8169_interrupt(int irq, void *dev_instance)
 {
  struct net_device *dev = (struct net_device *) dev_instance;
  struct rtl8169_private *tp = netdev_priv(dev);
@@ -2921,6 +2830,15 @@ rtl8169_set_rx_mode(struct net_device *d
  tmp = rtl8169_rx_config | rx_mode |
        (RTL_R32(RxConfig) & rtl_chip_info[tp->chipset].RxConfigMask);

+ if ((tp->mac_version == RTL_GIGA_MAC_VER_11) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_12) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_13) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_14) ||
+     (tp->mac_version == RTL_GIGA_MAC_VER_15)) {
+  mc_filter[0] = 0xffffffff;
+  mc_filter[1] = 0xffffffff;
+ }
+
  RTL_W32(RxConfig, tmp);
  RTL_W32(MAR0 + 0, mc_filter[0]);
  RTL_W32(MAR0 + 4, mc_filter[1]);


