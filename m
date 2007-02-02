Return-Path: <linux-kernel-owner+w=401wt.eu-S1423196AbXBBIRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423196AbXBBIRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 03:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423197AbXBBIRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 03:17:34 -0500
Received: from mf2.realtek.com.tw ([60.248.182.6]:3483 "EHLO
	mf2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423196AbXBBIRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 03:17:32 -0500
Message-ID: <45C2F390.4070805@realtek.com.tw>
Date: Fri, 02 Feb 2007 16:17:20 +0800
From: =?Big5?B?s1yr7bnF?= <edward_hsu@realtek.com.tw>
User-Agent: Mozilla Thunderbird 1.0.2 (Windows/20050317)
X-Accept-Language: zh-tw, en-us, en, zh
MIME-Version: 1.0
To: jeff@garzik.org
CC: linux-kernel@vger.kernel.org, hiwu@realtek.com.tw
Subject: [PATCH 2.6.19.2] r8169: support RTL8169SC/8110SC
X-MIMETrack: Itemize by SMTP Server on msx/Realtek(Release 6.5.3|September 14, 2004) at
 2007/02/02 =?Bog5?B?pFWkyCAwNDoxNzoyMA==?=,
	Serialize by Router on msx/Realtek(Release 6.5.3|September 14, 2004) at
 2007/02/02 =?Bog5?B?pFWkyCAwNDoxNzoyMg==?=,
	Serialize complete at 2007/02/02 =?Bog5?B?pFWkyCAwNDoxNzoyMg==?=
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=Big5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edward Hsu <edward_hsu@realtek.com>

patch-r8169-6.001.00 is for /driver/net/r8169.c to support
RTL8169SC/8110SC,
which is a new Realtek Gigabit PCI Ethernet Controller. RTL8110SC's PCI DID
is 0x8167, while RTL8110S and RTL8110SB share 0x8169.

Signed-off-by: Edward Hsu <edward_hsu@realtek.com>
------------------------------------------------------------------------------

--- ./drivers/net/r8169.c 2007-01-11 03:10:37.000000000 +0800
+++ ./drivers/net/r8169_n.c 2007-02-02 21:44:33.000000000 +0800
@@ -1,4 +1,29 @@
/*
+################################################################################
+#
+# Copyright(c) 1999 - 2007 Realtek Semiconductor Corp. All rights reserved.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the
Free
+# Software Foundation; either version 2 of the License, or (at your
option)
+# any later version.
+#
+# This program is distributed in the hope that it will be useful, but
WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+# more details.
+#
+# You should have received a copy of the GNU General Public License
along with
+# this program; if not, write to the Free Software Foundation, Inc., 59
+# Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# The full GNU General Public License is included in this distribution
in the
+# file called LICENSE.
+#
+################################################################################
+*/
+
+/*
=========================================================================
r8169.c: A RealTek RTL-8169 Gigabit Ethernet driver for Linux kernel 2.4.x.
--------------------------------------------------------------------
@@ -6,26 +31,26 @@
History:
Feb 4 2002 - created initially by ShuChen <shuchen@realtek.com.tw>.
May 20 2002 - Add link status force-mode and TBI mode support.
- 2004 - Massive updates. See kernel SCM system for details.
+ 2004 - Massive updates. See kernel SCM system for details.
=========================================================================
1. [DEPRECATED: use ethtool instead] The media can be forced in 5 modes.
Command: 'insmod r8169 media = SET_MEDIA'
Ex: 'insmod r8169 media = 0x04' will force PHY to operate in 100Mpbs
Half-duplex.
-
+
SET_MEDIA can be:
_10_Half = 0x01
_10_Full = 0x02
_100_Half = 0x04
_100_Full = 0x08
_1000_Full = 0x10
-
+
2. Support TBI mode.
=========================================================================
VERSION 1.1 <2002/10/4>

The bit4:0 of MII register 4 is called "selector field", and have to be
00001b to indicate support of IEEE std 802.3 during NWay process of
- exchanging Link Code Word (FLP).
+ exchanging Link Code Word (FLP).

VERSION 1.2 <2002/11/30>

@@ -51,6 +76,7 @@ VERSION 2.2LK <2005/01/25>
*/

#include <linux/module.h>
+#include <linux/version.h>
#include <linux/moduleparam.h>
#include <linux/pci.h>
#include <linux/netdevice.h>
@@ -69,22 +95,24 @@ VERSION 2.2LK <2005/01/25>
#include <asm/io.h>
#include <asm/irq.h>

+#define NODE_ADDRESS_SIZE 6
+
#ifdef CONFIG_R8169_NAPI
#define NAPI_SUFFIX "-NAPI"
#else
#define NAPI_SUFFIX ""
#endif

-#define RTL8169_VERSION "2.2LK" NAPI_SUFFIX
+#define RTL8169_VERSION "6.001.00" NAPI_SUFFIX
#define MODULENAME "r8169"
#define PFX MODULENAME ": "

#ifdef RTL8169_DEBUG
#define assert(expr) \
- if (!(expr)) { \
- printk( "Assertion failed! %s,%s,%s,line=%d\n", \
- #expr,__FILE__,__FUNCTION__,__LINE__); \
- }
+ if(!(expr)) { \
+ printk( "Assertion failed! %s,%s,%s,line=%d\n", \
+ #expr,__FILE__,__FUNCTION__,__LINE__); \
+ }
#define dprintk(fmt, args...) do { printk(PFX fmt, ## args); } while (0)
#else
#define assert(expr) do {} while (0)
@@ -109,8 +137,12 @@ VERSION 2.2LK <2005/01/25>

/* media options */
#define MAX_UNITS 8
-static int media[MAX_UNITS] = { -1, -1, -1, -1, -1, -1, -1, -1 };
-static int num_media = 0;
+static int speed[MAX_UNITS] = { -1, -1, -1, -1, -1, -1, -1, -1 };
+static int num_speed = 0;
+static int duplex[MAX_UNITS] = { -1, -1, -1, -1, -1, -1, -1, -1 };
+static int num_duplex = 0;
+static int autoneg[MAX_UNITS] = { -1, -1, -1, -1, -1, -1, -1, -1 };
+static int num_autoneg = 0;

/* Maximum events (Rx packets, etc.) to handle at each interrupt. */
static const int max_interrupt_work = 20;
@@ -123,8 +155,8 @@ static const int multicast_filter_limit
#define MAC_ADDR_LEN 6

#define RX_FIFO_THRESH 7 /* 7 means NO threshold, Rx buffer level before
first PCI xfer. */
-#define RX_DMA_BURST 6 /* Maximum PCI burst, '6' is 1024 */
-#define TX_DMA_BURST 6 /* Maximum PCI burst, '6' is 1024 */
+#define RX_DMA_BURST 7 /* Maximum PCI burst, '7' is unlimited */
+#define TX_DMA_BURST 7 /* Maximum PCI burst, '6' is 1024 */
#define EarlyTxThld 0x3F /* 0x3F means NO early transmit */
#define RxPacketMaxSize 0x3FE8 /* 16K - 1 - ETH_HLEN - VLAN - CRC... */
#define SafeMtu 0x1c20 /* ... actually life sucks beyond ~7k */
@@ -150,16 +182,12 @@ static const int multicast_filter_limit
#define RTL_R32(reg) ((unsigned long) readl (ioaddr + (reg)))

enum mac_version {
- RTL_GIGA_MAC_VER_01 = 0x00,
- RTL_GIGA_MAC_VER_02 = 0x01,
- RTL_GIGA_MAC_VER_03 = 0x02,
- RTL_GIGA_MAC_VER_04 = 0x03,
- RTL_GIGA_MAC_VER_05 = 0x04,
- RTL_GIGA_MAC_VER_11 = 0x0b,
- RTL_GIGA_MAC_VER_12 = 0x0c,
- RTL_GIGA_MAC_VER_13 = 0x0d,
- RTL_GIGA_MAC_VER_14 = 0x0e,
- RTL_GIGA_MAC_VER_15 = 0x0f
+ RTL_GIGA_MAC_VER_8169 = 0x00,
+ RTL_GIGA_MAC_VER_8169S = 0x01,
+ RTL_GIGA_MAC_VER_8110S = 0x02,
+ RTL_GIGA_MAC_VER_8169SB = 0x04,
+ RTL_GIGA_MAC_VER_8110SCd = 0x05,
+ RTL_GIGA_MAC_VER_8110SCe = 0x06,
};

enum phy_version {
@@ -171,6 +199,7 @@ enum phy_version {
RTL_GIGA_PHY_VER_H = 0x08, /* PHY Reg 0x03 bit0-3 == 0x0003 */
};

+
#define _R(NAME,MAC,MASK) \
{ .name = NAME, .mac_version = MAC, .RxConfigMask = MASK }

@@ -179,45 +208,18 @@ static const struct {
u8 mac_version;
u32 RxConfigMask; /* Clears the bits supported by this chip */
} rtl_chip_info[] = {
- _R("RTL8169", RTL_GIGA_MAC_VER_01, 0xff7e1880),
- _R("RTL8169s/8110s", RTL_GIGA_MAC_VER_02, 0xff7e1880),
- _R("RTL8169s/8110s", RTL_GIGA_MAC_VER_03, 0xff7e1880),
- _R("RTL8169sb/8110sb", RTL_GIGA_MAC_VER_04, 0xff7e1880),
- _R("RTL8169sc/8110sc", RTL_GIGA_MAC_VER_05, 0xff7e1880),
- _R("RTL8168b/8111b", RTL_GIGA_MAC_VER_11, 0xff7e1880), // PCI-E
- _R("RTL8168b/8111b", RTL_GIGA_MAC_VER_12, 0xff7e1880), // PCI-E
- _R("RTL8101e", RTL_GIGA_MAC_VER_13, 0xff7e1880), // PCI-E 8139
- _R("RTL8100e", RTL_GIGA_MAC_VER_14, 0xff7e1880), // PCI-E 8139
- _R("RTL8100e", RTL_GIGA_MAC_VER_15, 0xff7e1880) // PCI-E 8139
+ _R("RTL8169", RTL_GIGA_MAC_VER_8169, 0xff7e1880),
+ _R("RTL8169S/8110S", RTL_GIGA_MAC_VER_8169S, 0xff7e1880),
+ _R("RTL8169S/8110S", RTL_GIGA_MAC_VER_8110S, 0xff7e1880),
+ _R("RTL8169SB/8110SB", RTL_GIGA_MAC_VER_8169SB, 0xff7e1880),
+ _R("RTL8169SC/8110SC", RTL_GIGA_MAC_VER_8110SCd, 0xff7e1880),
+ _R("RTL8169SC/8110SC", RTL_GIGA_MAC_VER_8110SCe, 0xff7e1880),
};
#undef _R

-enum cfg_version {
- RTL_CFG_0 = 0x00,
- RTL_CFG_1,
- RTL_CFG_2
-};
-
-static const struct {
- unsigned int region;
- unsigned int align;
-} rtl_cfg_info[] = {
- [RTL_CFG_0] = { 1, NET_IP_ALIGN },
- [RTL_CFG_1] = { 2, NET_IP_ALIGN },
- [RTL_CFG_2] = { 2, 8 }
-};
-
static struct pci_device_id rtl8169_pci_tbl[] = {
- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8129), 0, 0, RTL_CFG_0 },
- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8136), 0, 0, RTL_CFG_2 },
- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8167), 0, 0, RTL_CFG_0 },
- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8168), 0, 0, RTL_CFG_2 },
- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8169), 0, 0, RTL_CFG_0 },
- { PCI_DEVICE(PCI_VENDOR_ID_DLINK, 0x4300), 0, 0, RTL_CFG_0 },
- { PCI_DEVICE(0x1259, 0xc107), 0, 0, RTL_CFG_0 },
- { PCI_DEVICE(0x16ec, 0x0116), 0, 0, RTL_CFG_0 },
- { PCI_VENDOR_ID_LINKSYS, 0x1032,
- PCI_ANY_ID, 0x0024, 0, 0, RTL_CFG_0 },
+ { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8169), },
+ { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8167), },
{0,},
};

@@ -230,8 +232,9 @@ static struct {
} debug = { -1 };

enum RTL8169_registers {
- MAC0 = 0, /* Ethernet hardware address. */
- MAR0 = 8, /* Multicast filter. */
+ MAC0 = 0x00, /* Ethernet hardware address. */
+ MAC4 = 0x04,
+ MAR0 = 0x08, /* Multicast filter. */
CounterAddrLow = 0x10,
CounterAddrHigh = 0x14,
TxDescStartAddrLow = 0x20,
@@ -260,6 +263,7 @@ enum RTL8169_registers {
TBI_ANAR = 0x68,
TBI_LPAR = 0x6A,
PHYstatus = 0x6C,
+ Offset_7Ch = 0x7C,
RxMaxSize = 0xDA,
CPlusCmd = 0xE0,
IntrMitigate = 0xE2,
@@ -287,11 +291,10 @@ enum RTL8169_register_content {
RxOK = 0x01,

/* RxStatusDesc */
- RxFOVF = (1 << 23),
- RxRWT = (1 << 22),
- RxRES = (1 << 21),
- RxRUNT = (1 << 20),
- RxCRC = (1 << 19),
+ RxRES = 0x00200000,
+ RxCRC = 0x00080000,
+ RxRUNT = 0x00100000,
+ RxRWT = 0x00400000,

/* ChipCmdBits */
CmdReset = 0x10,
@@ -322,6 +325,10 @@ enum RTL8169_register_content {
/* Config1 register p.24 */
PMEnable = (1 << 0), /* Power Management Enable */

+ /* Config2 register p.26 */
+ PCI_Clock_66MHz = 0x01,
+ PCI_Clock_33MHz = 0x00,
+
/* Config3 register p.25 */
MagicPacket = (1 << 5), /* Wake up when receives a Magic Packet */
LinkUp = (1 << 4), /* Wake up when the cable connection is re-established */
@@ -357,6 +364,31 @@ enum RTL8169_register_content {
LinkStatus = 0x02,
FullDup = 0x01,

+ /* GIGABIT_PHY_registers */
+ PHY_CTRL_REG = 0,
+ PHY_STAT_REG = 1,
+ PHY_AUTO_NEGO_REG = 4,
+ PHY_1000_CTRL_REG = 9,
+
+ /* GIGABIT_PHY_REG_BIT */
+ PHY_Restart_Auto_Nego = 0x0200,
+ PHY_Enable_Auto_Nego = 0x1000,
+
+ /* PHY_STAT_REG = 1 */
+ PHY_Auto_Neco_Comp = 0x0020,
+
+ /* PHY_AUTO_NEGO_REG = 4 */
+ PHY_Cap_10_Half = 0x0020,
+ PHY_Cap_10_Full = 0x0040,
+ PHY_Cap_100_Half = 0x0080,
+ PHY_Cap_100_Full = 0x0100,
+
+ /* PHY_1000_CTRL_REG = 9 */
+ PHY_Cap_1000_Full = 0x0200,
+ PHY_Cap_1000_Half = 0x0100,
+
+ PHY_Cap_Null = 0x0,
+
/* _MediaType */
_10_Half = 0x01,
_10_Full = 0x02,
@@ -440,13 +472,13 @@ struct rtl8169_private {
dma_addr_t RxPhyAddr;
struct sk_buff *Rx_skbuff[NUM_RX_DESC]; /* Rx data buffers */
struct ring_info tx_skb[NUM_TX_DESC]; /* Tx data buffers */
- unsigned align;
unsigned rx_buf_sz;
struct timer_list timer;
u16 cp_cmd;
u16 intr_mask;
int phy_auto_nego_reg;
int phy_1000_ctrl_reg;
+ uint8_t mac_addr[NODE_ADDRESS_SIZE];
#ifdef CONFIG_R8169_VLAN
struct vlan_group *vlgrp;
#endif
@@ -461,8 +493,14 @@ struct rtl8169_private {

MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
MODULE_DESCRIPTION("RealTek RTL-8169 Gigabit Ethernet driver");
-module_param_array(media, int, &num_media, 0);
-MODULE_PARM_DESC(media, "force phy operation. Deprecated by ethtool (8).");
+
+module_param_array(speed, int, &num_speed, 0);
+MODULE_PARM_DESC(speed, "force phy operation. Deprecated by ethtool (8).");
+module_param_array(duplex, int, &num_duplex, 0);
+MODULE_PARM_DESC(duplex, "force phy operation. Deprecated by ethtool
(8).");
+module_param_array(autoneg, int, &num_autoneg, 0);
+MODULE_PARM_DESC(autoneg, "force phy operation. Deprecated by ethtool
(8).");
+
module_param(rx_copybreak, int, 0);
MODULE_PARM_DESC(rx_copybreak, "Copy breakpoint for copy-only-tiny-frames");
module_param(use_dac, int, 0);
@@ -474,7 +512,12 @@ MODULE_VERSION(RTL8169_VERSION);

static int rtl8169_open(struct net_device *dev);
static int rtl8169_start_xmit(struct sk_buff *skb, struct net_device *dev);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
+static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance,
struct pt_regs *regs);
+#else
static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance);
+
+#endif
static int rtl8169_init_ring(struct net_device *dev);
static void rtl8169_hw_start(struct net_device *dev);
static int rtl8169_close(struct net_device *dev);
@@ -485,6 +528,8 @@ static int rtl8169_rx_interrupt(struct n
void __iomem *);
static int rtl8169_change_mtu(struct net_device *dev, int new_mtu);
static void rtl8169_down(struct net_device *dev);
+static int rtl8169_set_mac_address(struct net_device *dev, void *p);
+void rtl8169_rar_set(struct rtl8169_private *tp, uint8_t *addr,
uint32_t index);

#ifdef CONFIG_R8169_NAPI
static int rtl8169_poll(struct net_device *dev, int *budget);
@@ -495,7 +540,12 @@ static const u16 rtl8169_intr_mask =
static const u16 rtl8169_napi_event =
RxOK | RxOverflow | RxFIFOOver | TxOK | TxErr;
static const unsigned int rtl8169_rx_config =
- (RX_FIFO_THRESH << RxCfgFIFOShift) | (RX_DMA_BURST << RxCfgDMAShift);
+ (RX_FIFO_THRESH << RxCfgFIFOShift) | (RX_DMA_BURST << RxCfgDMAShift);
+
+#define PHY_Cap_10_Half_Or_Less PHY_Cap_10_Half
+#define PHY_Cap_10_Full_Or_Less PHY_Cap_10_Full | PHY_Cap_10_Half_Or_Less
+#define PHY_Cap_100_Half_Or_Less PHY_Cap_100_Half | PHY_Cap_10_Full_Or_Less
+#define PHY_Cap_100_Full_Or_Less PHY_Cap_100_Full |
PHY_Cap_100_Half_Or_Less

static void mdio_write(void __iomem *ioaddr, int RegAddr, int value)
{
@@ -505,7 +555,7 @@ static void mdio_write(void __iomem *ioa

for (i = 20; i > 0; i--) {
/* Check if the RTL8169 has completed writing to the specified MII
register */
- if (!(RTL_R32(PHYAR) & 0x80000000))
+ if (!(RTL_R32(PHYAR) & 0x80000000))
break;
udelay(25);
}
@@ -549,7 +599,7 @@ static unsigned int rtl8169_tbi_reset_pe

static unsigned int rtl8169_xmii_reset_pending(void __iomem *ioaddr)
{
- return mdio_read(ioaddr, MII_BMCR) & BMCR_RESET;
+ return mdio_read(ioaddr, 0) & 0x8000;
}

static unsigned int rtl8169_tbi_link_ok(void __iomem *ioaddr)
@@ -571,8 +621,8 @@ static void rtl8169_xmii_reset_enable(vo
{
unsigned int val;

- val = (mdio_read(ioaddr, MII_BMCR) | BMCR_RESET) & 0xffff;
- mdio_write(ioaddr, MII_BMCR, val);
+ val = (mdio_read(ioaddr, PHY_CTRL_REG) | 0x8000) & 0xffff;
+ mdio_write(ioaddr, PHY_CTRL_REG, val);
}

static void rtl8169_check_link_status(struct net_device *dev,
@@ -593,39 +643,36 @@ static void rtl8169_check_link_status(st
spin_unlock_irqrestore(&tp->lock, flags);
}

-static void rtl8169_link_option(int idx, u8 *autoneg, u16 *speed, u8
*duplex)
-{
- struct {
- u16 speed;
- u8 duplex;
- u8 autoneg;
- u8 media;
- } link_settings[] = {
- { SPEED_10, DUPLEX_HALF, AUTONEG_DISABLE, _10_Half },
- { SPEED_10, DUPLEX_FULL, AUTONEG_DISABLE, _10_Full },
- { SPEED_100, DUPLEX_HALF, AUTONEG_DISABLE, _100_Half },
- { SPEED_100, DUPLEX_FULL, AUTONEG_DISABLE, _100_Full },
- { SPEED_1000, DUPLEX_FULL, AUTONEG_DISABLE, _1000_Full },
- /* Make TBI happy */
- { SPEED_1000, DUPLEX_FULL, AUTONEG_ENABLE, 0xff }
- }, *p;
- unsigned char option;
-
- option = ((idx < MAX_UNITS) && (idx >= 0)) ? media[idx] : 0xff;
-
- if ((option != 0xff) && !idx && netif_msg_drv(&debug))
- printk(KERN_WARNING PFX "media option is deprecated.\n");
-
- for (p = link_settings; p->media != 0xff; p++) {
- if (p->media == option)
- break;
+static void
+rtl8169_link_option(int idx,
+ u8 *aut,
+ u16 *spd,
+ u8 *dup)
+{
+ unsigned char opt_speed;
+ unsigned char opt_duplex;
+ unsigned char opt_autoneg;
+
+ opt_speed = ((idx < MAX_UNITS) && (idx >= 0)) ? speed[idx] : 0xff;
+ opt_duplex = ((idx < MAX_UNITS) && (idx >= 0)) ? duplex[idx] : 0xff;
+ opt_autoneg = ((idx < MAX_UNITS) && (idx >= 0)) ? autoneg[idx] : 0xff;
+
+ if ((opt_speed == 0xff) |
+ (opt_duplex == 0xff) |
+ (opt_autoneg == 0xff)) {
+ *spd = SPEED_1000;
+ *dup = DUPLEX_FULL;
+ *aut = AUTONEG_ENABLE;
+ } else {
+ *spd = speed[idx];
+ *dup = duplex[idx];
+ *aut = autoneg[idx];
}
- *autoneg = p->autoneg;
- *speed = p->speed;
- *duplex = p->duplex;
}

-static void rtl8169_get_wol(struct net_device *dev, struct
ethtool_wolinfo *wol)
+static void
+rtl8169_get_wol(struct net_device *dev,
+ struct ethtool_wolinfo *wol)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
@@ -652,15 +699,17 @@ static void rtl8169_get_wol(struct net_d
if (options & UWF)
wol->wolopts |= WAKE_UCAST;
if (options & BWF)
- wol->wolopts |= WAKE_BCAST;
+ wol->wolopts |= WAKE_BCAST;
if (options & MWF)
- wol->wolopts |= WAKE_MCAST;
+ wol->wolopts |= WAKE_MCAST;

out_unlock:
spin_unlock_irq(&tp->lock);
}

-static int rtl8169_set_wol(struct net_device *dev, struct
ethtool_wolinfo *wol)
+static int
+rtl8169_set_wol(struct net_device *dev,
+ struct ethtool_wolinfo *wol)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
@@ -699,8 +748,9 @@ static int rtl8169_set_wol(struct net_de
return 0;
}

-static void rtl8169_get_drvinfo(struct net_device *dev,
- struct ethtool_drvinfo *info)
+static void
+rtl8169_get_drvinfo(struct net_device *dev,
+ struct ethtool_drvinfo *info)
{
struct rtl8169_private *tp = netdev_priv(dev);

@@ -709,13 +759,17 @@ static void rtl8169_get_drvinfo(struct n
strcpy(info->bus_info, pci_name(tp->pci_dev));
}

-static int rtl8169_get_regs_len(struct net_device *dev)
+static int
+rtl8169_get_regs_len(struct net_device *dev)
{
return R8169_REGS_SIZE;
}

-static int rtl8169_set_speed_tbi(struct net_device *dev,
- u8 autoneg, u16 speed, u8 duplex)
+static int
+rtl8169_set_speed_tbi(struct net_device *dev,
+ u8 autoneg,
+ u16 speed,
+ u8 duplex)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
@@ -740,82 +794,95 @@ static int rtl8169_set_speed_tbi(struct
return ret;
}

-static int rtl8169_set_speed_xmii(struct net_device *dev,
- u8 autoneg, u16 speed, u8 duplex)
+static int
+rtl8169_set_speed_xmii(struct net_device *dev,
+ u8 autoneg,
+ u16 speed,
+ u8 duplex)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
int auto_nego, giga_ctrl;

- auto_nego = mdio_read(ioaddr, MII_ADVERTISE);
- auto_nego &= ~(ADVERTISE_10HALF | ADVERTISE_10FULL |
- ADVERTISE_100HALF | ADVERTISE_100FULL);
- giga_ctrl = mdio_read(ioaddr, MII_CTRL1000);
- giga_ctrl &= ~(ADVERTISE_1000FULL | ADVERTISE_1000HALF);
+ auto_nego = mdio_read(ioaddr, PHY_AUTO_NEGO_REG);
+ auto_nego &= ~(PHY_Cap_10_Half |
+ PHY_Cap_10_Full |
+ PHY_Cap_100_Half |
+ PHY_Cap_100_Full);
+
+ giga_ctrl = mdio_read(ioaddr, PHY_1000_CTRL_REG);
+ giga_ctrl &= ~(PHY_Cap_1000_Full | PHY_Cap_Null);

if (autoneg == AUTONEG_ENABLE) {
- auto_nego |= (ADVERTISE_10HALF | ADVERTISE_10FULL |
- ADVERTISE_100HALF | ADVERTISE_100FULL);
- giga_ctrl |= ADVERTISE_1000FULL | ADVERTISE_1000HALF;
- } else {
- if (speed == SPEED_10)
- auto_nego |= ADVERTISE_10HALF | ADVERTISE_10FULL;
- else if (speed == SPEED_100)
- auto_nego |= ADVERTISE_100HALF | ADVERTISE_100FULL;
- else if (speed == SPEED_1000)
- giga_ctrl |= ADVERTISE_1000FULL | ADVERTISE_1000HALF;
-
- if (duplex == DUPLEX_HALF)
- auto_nego &= ~(ADVERTISE_10FULL | ADVERTISE_100FULL);
-
- if (duplex == DUPLEX_FULL)
- auto_nego &= ~(ADVERTISE_10HALF | ADVERTISE_100HALF);
-
- /* This tweak comes straight from Realtek's driver. */
- if ((speed == SPEED_100) && (duplex == DUPLEX_HALF) &&
- (tp->mac_version == RTL_GIGA_MAC_VER_13)) {
- auto_nego = ADVERTISE_100HALF | ADVERTISE_CSMA;
- }
- }
+ auto_nego |= (PHY_Cap_10_Half |
+ PHY_Cap_10_Full |
+ PHY_Cap_100_Half |
+ PHY_Cap_100_Full);

- /* The 8100e/8101e do Fast Ethernet only. */
- if ((tp->mac_version == RTL_GIGA_MAC_VER_13) ||
- (tp->mac_version == RTL_GIGA_MAC_VER_14) ||
- (tp->mac_version == RTL_GIGA_MAC_VER_15)) {
- if ((giga_ctrl & (ADVERTISE_1000FULL | ADVERTISE_1000HALF)) &&
- netif_msg_link(tp)) {
- printk(KERN_INFO "%s: PHY does not support 1000Mbps.\n",
- dev->name);
+ giga_ctrl |= PHY_Cap_1000_Full | PHY_Cap_1000_Half;
+ } else {
+ if ((speed != SPEED_1000) &&
+ (speed != SPEED_100) &&
+ (speed != SPEED_10)) {
+ speed = SPEED_1000;
+ duplex = DUPLEX_FULL;
+ }
+
+ if ((speed == SPEED_10) && (duplex == DUPLEX_HALF))
+ auto_nego |= PHY_Cap_10_Half;
+ else if ((speed == SPEED_10) && (duplex == DUPLEX_FULL))
+ auto_nego |= PHY_Cap_10_Half |
+ PHY_Cap_10_Full;
+ else if ((speed == SPEED_100) && (duplex == DUPLEX_HALF))
+ auto_nego |= PHY_Cap_100_Half |
+ PHY_Cap_10_Half |
+ PHY_Cap_10_Full;
+ else if ((speed == SPEED_100) && (duplex == DUPLEX_FULL))
+ auto_nego |= PHY_Cap_100_Half |
+ PHY_Cap_100_Full |
+ PHY_Cap_10_Half |
+ PHY_Cap_10_Full;
+ else if (speed == SPEED_1000) {
+ giga_ctrl |= PHY_Cap_1000_Half |
+ PHY_Cap_1000_Full;
+
+ auto_nego |= PHY_Cap_100_Half |
+ PHY_Cap_100_Full |
+ PHY_Cap_10_Half |
+ PHY_Cap_10_Full;
}
- giga_ctrl &= ~(ADVERTISE_1000FULL | ADVERTISE_1000HALF);
}

- auto_nego |= ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM;
-
tp->phy_auto_nego_reg = auto_nego;
tp->phy_1000_ctrl_reg = giga_ctrl;

- mdio_write(ioaddr, MII_ADVERTISE, auto_nego);
- mdio_write(ioaddr, MII_CTRL1000, giga_ctrl);
- mdio_write(ioaddr, MII_BMCR, BMCR_ANENABLE | BMCR_ANRESTART);
+ mdio_write(ioaddr, PHY_AUTO_NEGO_REG, auto_nego);
+ mdio_write(ioaddr, PHY_1000_CTRL_REG, giga_ctrl);
+ mdio_write(ioaddr, PHY_CTRL_REG, PHY_Enable_Auto_Nego |
+ PHY_Restart_Auto_Nego);
return 0;
}

-static int rtl8169_set_speed(struct net_device *dev,
- u8 autoneg, u16 speed, u8 duplex)
+static int
+rtl8169_set_speed(struct net_device *dev,
+ u8 autoneg,
+ u16 speed,
+ u8 duplex)
{
struct rtl8169_private *tp = netdev_priv(dev);
int ret;

ret = tp->set_speed(dev, autoneg, speed, duplex);

- if (netif_running(dev) && (tp->phy_1000_ctrl_reg & ADVERTISE_1000FULL))
+ if (netif_running(dev) && (tp->phy_1000_ctrl_reg & PHY_Cap_1000_Full))
mod_timer(&tp->timer, jiffies + RTL8169_PHY_TIMEOUT);

return ret;
}

-static int rtl8169_set_settings(struct net_device *dev, struct
ethtool_cmd *cmd)
+static int
+rtl8169_set_settings(struct net_device *dev,
+ struct ethtool_cmd *cmd)
{
struct rtl8169_private *tp = netdev_priv(dev);
unsigned long flags;
@@ -824,18 +891,21 @@ static int rtl8169_set_settings(struct n
spin_lock_irqsave(&tp->lock, flags);
ret = rtl8169_set_speed(dev, cmd->autoneg, cmd->speed, cmd->duplex);
spin_unlock_irqrestore(&tp->lock, flags);
-
+
return ret;
}

-static u32 rtl8169_get_rx_csum(struct net_device *dev)
+static u32
+rtl8169_get_rx_csum(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);

return tp->cp_cmd & RxChkSum;
}

-static int rtl8169_set_rx_csum(struct net_device *dev, u32 data)
+static int
+rtl8169_set_rx_csum(struct net_device *dev,
+ u32 data)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
@@ -858,15 +928,17 @@ static int rtl8169_set_rx_csum(struct ne

#ifdef CONFIG_R8169_VLAN

-static inline u32 rtl8169_tx_vlan_tag(struct rtl8169_private *tp,
- struct sk_buff *skb)
+static inline u32
+rtl8169_tx_vlan_tag(struct rtl8169_private *tp,
+ struct sk_buff *skb)
{
return (tp->vlgrp && vlan_tx_tag_present(skb)) ?
TxVlanTag | swab16(vlan_tx_tag_get(skb)) : 0x00;
}

-static void rtl8169_vlan_rx_register(struct net_device *dev,
- struct vlan_group *grp)
+static void
+rtl8169_vlan_rx_register(struct net_device *dev,
+ struct vlan_group *grp)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
@@ -883,7 +955,9 @@ static void rtl8169_vlan_rx_register(str
spin_unlock_irqrestore(&tp->lock, flags);
}

-static void rtl8169_vlan_rx_kill_vid(struct net_device *dev, unsigned
short vid)
+static void
+rtl8169_vlan_rx_kill_vid(struct net_device *dev,
+ unsigned short vid)
{
struct rtl8169_private *tp = netdev_priv(dev);
unsigned long flags;
@@ -894,8 +968,10 @@ static void rtl8169_vlan_rx_kill_vid(str
spin_unlock_irqrestore(&tp->lock, flags);
}

-static int rtl8169_rx_vlan_skb(struct rtl8169_private *tp, struct
RxDesc *desc,
- struct sk_buff *skb)
+static int
+rtl8169_rx_vlan_skb(struct rtl8169_private *tp,
+ struct RxDesc *desc,
+ struct sk_buff *skb)
{
u32 opts2 = le32_to_cpu(desc->opts2);
int ret;
@@ -912,21 +988,26 @@ static int rtl8169_rx_vlan_skb(struct rt

#else /* !CONFIG_R8169_VLAN */

-static inline u32 rtl8169_tx_vlan_tag(struct rtl8169_private *tp,
- struct sk_buff *skb)
+static inline u32
+rtl8169_tx_vlan_tag(struct rtl8169_private *tp,
+ struct sk_buff *skb)
{
return 0;
}

-static int rtl8169_rx_vlan_skb(struct rtl8169_private *tp, struct
RxDesc *desc,
- struct sk_buff *skb)
+static int
+rtl8169_rx_vlan_skb(struct rtl8169_private *tp,
+ struct RxDesc *desc,
+ struct sk_buff *skb)
{
return -1;
}

#endif

-static void rtl8169_gset_tbi(struct net_device *dev, struct ethtool_cmd
*cmd)
+static void
+rtl8169_gset_tbi(struct net_device *dev,
+ struct ethtool_cmd *cmd)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
@@ -945,7 +1026,9 @@ static void rtl8169_gset_tbi(struct net_
cmd->duplex = DUPLEX_FULL; /* Always set */
}

-static void rtl8169_gset_xmii(struct net_device *dev, struct
ethtool_cmd *cmd)
+static void
+rtl8169_gset_xmii(struct net_device *dev,
+ struct ethtool_cmd *cmd)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
@@ -957,20 +1040,20 @@ static void rtl8169_gset_xmii(struct net
SUPPORTED_100baseT_Full |
SUPPORTED_1000baseT_Full |
SUPPORTED_Autoneg |
- SUPPORTED_TP;
+ SUPPORTED_TP;

cmd->autoneg = 1;
cmd->advertising = ADVERTISED_TP | ADVERTISED_Autoneg;

- if (tp->phy_auto_nego_reg & ADVERTISE_10HALF)
+ if (tp->phy_auto_nego_reg & PHY_Cap_10_Half)
cmd->advertising |= ADVERTISED_10baseT_Half;
- if (tp->phy_auto_nego_reg & ADVERTISE_10FULL)
+ if (tp->phy_auto_nego_reg & PHY_Cap_10_Full)
cmd->advertising |= ADVERTISED_10baseT_Full;
- if (tp->phy_auto_nego_reg & ADVERTISE_100HALF)
+ if (tp->phy_auto_nego_reg & PHY_Cap_100_Half)
cmd->advertising |= ADVERTISED_100baseT_Half;
- if (tp->phy_auto_nego_reg & ADVERTISE_100FULL)
+ if (tp->phy_auto_nego_reg & PHY_Cap_100_Full)
cmd->advertising |= ADVERTISED_100baseT_Full;
- if (tp->phy_1000_ctrl_reg & ADVERTISE_1000FULL)
+ if (tp->phy_1000_ctrl_reg & PHY_Cap_1000_Full)
cmd->advertising |= ADVERTISED_1000baseT_Full;

status = RTL_R8(PHYstatus);
@@ -982,16 +1065,13 @@ static void rtl8169_gset_xmii(struct net
else if (status & _10bps)
cmd->speed = SPEED_10;

- if (status & TxFlowCtrl)
- cmd->advertising |= ADVERTISED_Asym_Pause;
- if (status & RxFlowCtrl)
- cmd->advertising |= ADVERTISED_Pause;
-
cmd->duplex = ((status & _1000bpsF) || (status & FullDup)) ?
DUPLEX_FULL : DUPLEX_HALF;
}

-static int rtl8169_get_settings(struct net_device *dev, struct
ethtool_cmd *cmd)
+static int
+rtl8169_get_settings(struct net_device *dev,
+ struct ethtool_cmd *cmd)
{
struct rtl8169_private *tp = netdev_priv(dev);
unsigned long flags;
@@ -1004,28 +1084,33 @@ static int rtl8169_get_settings(struct n
return 0;
}

-static void rtl8169_get_regs(struct net_device *dev, struct
ethtool_regs *regs,
- void *p)
+static void
+rtl8169_get_regs(struct net_device *dev,
+ struct ethtool_regs *regs,
+ void *p)
{
- struct rtl8169_private *tp = netdev_priv(dev);
- unsigned long flags;
+ struct rtl8169_private *tp = netdev_priv(dev);
+ unsigned long flags;

- if (regs->len > R8169_REGS_SIZE)
- regs->len = R8169_REGS_SIZE;
+ if (regs->len > R8169_REGS_SIZE)
+ regs->len = R8169_REGS_SIZE;

- spin_lock_irqsave(&tp->lock, flags);
- memcpy_fromio(p, tp->mmio_addr, regs->len);
- spin_unlock_irqrestore(&tp->lock, flags);
+ spin_lock_irqsave(&tp->lock, flags);
+ memcpy_fromio(p, tp->mmio_addr, regs->len);
+ spin_unlock_irqrestore(&tp->lock, flags);
}

-static u32 rtl8169_get_msglevel(struct net_device *dev)
+static u32
+rtl8169_get_msglevel(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);

return tp->msg_enable;
}

-static void rtl8169_set_msglevel(struct net_device *dev, u32 value)
+static void
+rtl8169_set_msglevel(struct net_device *dev,
+ u32 value)
{
struct rtl8169_private *tp = netdev_priv(dev);

@@ -1064,13 +1149,16 @@ struct rtl8169_counters {
u16 tx_underun;
};

-static int rtl8169_get_stats_count(struct net_device *dev)
+static int
+rtl8169_get_stats_count(struct net_device *dev)
{
return ARRAY_SIZE(rtl8169_gstrings);
}

-static void rtl8169_get_ethtool_stats(struct net_device *dev,
- struct ethtool_stats *stats, u64 *data)
+static void
+rtl8169_get_ethtool_stats(struct net_device *dev,
+ struct ethtool_stats *stats,
+ u64 *data)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
@@ -1097,7 +1185,7 @@ static void rtl8169_get_ethtool_stats(st
RTL_W32(CounterAddrLow, 0);
RTL_W32(CounterAddrHigh, 0);

- data[0] = le64_to_cpu(counters->tx_packets);
+ data[0] = le64_to_cpu(counters->tx_packets);
data[1] = le64_to_cpu(counters->rx_packets);
data[2] = le64_to_cpu(counters->tx_errors);
data[3] = le32_to_cpu(counters->rx_errors);
@@ -1114,7 +1202,10 @@ static void rtl8169_get_ethtool_stats(st
pci_free_consistent(tp->pci_dev, sizeof(*counters), counters, paddr);
}

-static void rtl8169_get_strings(struct net_device *dev, u32 stringset,
u8 *data)
+static void
+rtl8169_get_strings(struct net_device *dev,
+ u32 stringset,
+ u8 *data)
{
switch(stringset) {
case ETH_SS_STATS:
@@ -1124,7 +1215,7 @@ static void rtl8169_get_strings(struct n
}


-static const struct ethtool_ops rtl8169_ethtool_ops = {
+static struct ethtool_ops rtl8169_ethtool_ops = {
.get_drvinfo = rtl8169_get_drvinfo,
.get_regs_len = rtl8169_get_regs_len,
.get_link = ethtool_op_get_link,
@@ -1149,48 +1240,69 @@ static const struct ethtool_ops rtl8169_
.get_perm_addr = ethtool_op_get_perm_addr,
};

-static void rtl8169_write_gmii_reg_bit(void __iomem *ioaddr, int reg,
int bitnum,
- int bitval)
+static void
+rtl8169_write_gmii_reg_bit(void __iomem *ioaddr,
+ int reg,
+ int bitnum,
+ int bitval)
{
int val;

val = mdio_read(ioaddr, reg);
val = (bitval == 1) ?
val | (bitval << bitnum) : val & ~(0x0001 << bitnum);
- mdio_write(ioaddr, reg, val & 0xffff);
+ mdio_write(ioaddr, reg, val & 0xffff);
}

-static void rtl8169_get_mac_version(struct rtl8169_private *tp, void
__iomem *ioaddr)
+static void
+rtl8169_get_mac_version(struct rtl8169_private *tp,
+ void __iomem *ioaddr)
{
const struct {
u32 mask;
int mac_version;
} mac_info[] = {
- { 0x38800000, RTL_GIGA_MAC_VER_15 },
- { 0x38000000, RTL_GIGA_MAC_VER_12 },
- { 0x34000000, RTL_GIGA_MAC_VER_13 },
- { 0x30800000, RTL_GIGA_MAC_VER_14 },
- { 0x30000000, RTL_GIGA_MAC_VER_11 },
- { 0x18000000, RTL_GIGA_MAC_VER_05 },
- { 0x10000000, RTL_GIGA_MAC_VER_04 },
- { 0x04000000, RTL_GIGA_MAC_VER_03 },
- { 0x00800000, RTL_GIGA_MAC_VER_02 },
- { 0x00000000, RTL_GIGA_MAC_VER_01 } /* Catch-all */
+ { 0x18000000, RTL_GIGA_MAC_VER_8110SCd },
+ { 0x98000000, RTL_GIGA_MAC_VER_8110SCe },
+ { 0x1 << 28, RTL_GIGA_MAC_VER_8169SB },
+ { 0x1 << 26, RTL_GIGA_MAC_VER_8110S },
+ { 0x1 << 23, RTL_GIGA_MAC_VER_8169S },
+ { 0x00000000, RTL_GIGA_MAC_VER_8169 } /* Catch-all */
}, *p = mac_info;
u32 reg;

- reg = RTL_R32(TxConfig) & 0x7c800000;
+ reg = RTL_R32(TxConfig) & 0xfc800000;
while ((reg & p->mask) != p->mask)
p++;
tp->mac_version = p->mac_version;
}

-static void rtl8169_print_mac_version(struct rtl8169_private *tp)
+static void
+rtl8169_print_mac_version(struct rtl8169_private *tp)
{
- dprintk("mac_version = 0x%02x\n", tp->mac_version);
+ struct {
+ int version;
+ char *msg;
+ } mac_print[] = {
+ { RTL_GIGA_MAC_VER_8110S, "RTL_GIGA_MAC_VER_8110S" },
+ { RTL_GIGA_MAC_VER_8169S, "RTL_GIGA_MAC_VER_8169S" },
+ { RTL_GIGA_MAC_VER_8169, "RTL_GIGA_MAC_VER_8169" },
+ { 0, NULL }
+ }, *p;
+
+ for (p = mac_print; p->msg; p++) {
+ if (tp->mac_version == p->version) {
+ dprintk("mac_version == %s (%04d)\n", p->msg,
+ p->version);
+ return;
+ }
+ }
+ dprintk("mac_version == Unknown\n");
}

-static void rtl8169_get_phy_version(struct rtl8169_private *tp, void
__iomem *ioaddr)
+static void
+rtl8169_get_phy_version(struct rtl8169_private *tp,
+ void __iomem *ioaddr)
{
const struct {
u16 mask;
@@ -1204,13 +1316,14 @@ static void rtl8169_get_phy_version(stru
}, *p = phy_info;
u16 reg;

- reg = mdio_read(ioaddr, MII_PHYSID2) & 0xffff;
+ reg = mdio_read(ioaddr, 3) & 0xffff;
while ((reg & p->mask) != p->set)
p++;
tp->phy_version = p->phy_version;
}

-static void rtl8169_print_phy_version(struct rtl8169_private *tp)
+static void
+rtl8169_print_phy_version(struct rtl8169_private *tp)
{
struct {
int version;
@@ -1233,7 +1346,8 @@ static void rtl8169_print_phy_version(st
dprintk("phy_version == Unknown\n");
}

-static void rtl8169_hw_phy_config(struct net_device *dev)
+static void
+rtl8169_hw_phy_config(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
@@ -1272,7 +1386,7 @@ static void rtl8169_hw_phy_config(struct
rtl8169_print_mac_version(tp);
rtl8169_print_phy_version(tp);

- if (tp->mac_version <= RTL_GIGA_MAC_VER_01)
+ if (tp->mac_version <= RTL_GIGA_MAC_VER_8169)
return;
if (tp->phy_version >= RTL_GIGA_PHY_VER_H)
return;
@@ -1282,7 +1396,7 @@ static void rtl8169_hw_phy_config(struct

/* Shazam ! */

- if (tp->mac_version == RTL_GIGA_MAC_VER_04) {
+ if (tp->mac_version == RTL_GIGA_MAC_VER_8169SB) {
mdio_write(ioaddr, 31, 0x0001);
mdio_write(ioaddr, 9, 0x273a);
mdio_write(ioaddr, 14, 0x7bfb);
@@ -1313,7 +1427,8 @@ static void rtl8169_hw_phy_config(struct
mdio_write(ioaddr, 31, 0x0000); //w 31 2 0 0
}

-static void rtl8169_phy_timer(unsigned long __opaque)
+static void
+rtl8169_phy_timer(unsigned long __opaque)
{
struct net_device *dev = (struct net_device *)__opaque;
struct rtl8169_private *tp = netdev_priv(dev);
@@ -1321,16 +1436,16 @@ static void rtl8169_phy_timer(unsigned l
void __iomem *ioaddr = tp->mmio_addr;
unsigned long timeout = RTL8169_PHY_TIMEOUT;

- assert(tp->mac_version > RTL_GIGA_MAC_VER_01);
+ assert(tp->mac_version > RTL_GIGA_MAC_VER_8169);
assert(tp->phy_version < RTL_GIGA_PHY_VER_H);

- if (!(tp->phy_1000_ctrl_reg & ADVERTISE_1000FULL))
+ if (!(tp->phy_1000_ctrl_reg & PHY_Cap_1000_Full))
return;

spin_lock_irq(&tp->lock);

if (tp->phy_reset_pending(ioaddr)) {
- /*
+ /*
* A busy loop could burn quite a few cycles on nowadays CPU.
* Let's delay the execution of the timer for a few ticks.
*/
@@ -1352,24 +1467,26 @@ out_unlock:
spin_unlock_irq(&tp->lock);
}

-static inline void rtl8169_delete_timer(struct net_device *dev)
+static inline void
+rtl8169_delete_timer(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);
struct timer_list *timer = &tp->timer;

- if ((tp->mac_version <= RTL_GIGA_MAC_VER_01) ||
+ if ((tp->mac_version <= RTL_GIGA_MAC_VER_8169) ||
(tp->phy_version >= RTL_GIGA_PHY_VER_H))
return;

del_timer_sync(timer);
}

-static inline void rtl8169_request_timer(struct net_device *dev)
+static inline void
+rtl8169_request_timer(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);
struct timer_list *timer = &tp->timer;

- if ((tp->mac_version <= RTL_GIGA_MAC_VER_01) ||
+ if ((tp->mac_version <= RTL_GIGA_MAC_VER_8169) ||
(tp->phy_version >= RTL_GIGA_PHY_VER_H))
return;

@@ -1386,19 +1503,26 @@ static inline void rtl8169_request_timer
* without having to re-enable interrupts. It's not called while
* the interrupt routine is executing.
*/
-static void rtl8169_netpoll(struct net_device *dev)
+static void
+rtl8169_netpoll(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);
struct pci_dev *pdev = tp->pci_dev;

disable_irq(pdev->irq);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
+ rtl8169_interrupt(pdev->irq, dev, NULL);
+#else
rtl8169_interrupt(pdev->irq, dev);
+#endif
enable_irq(pdev->irq);
}
#endif

-static void rtl8169_release_board(struct pci_dev *pdev, struct
net_device *dev,
- void __iomem *ioaddr)
+static void
+rtl8169_release_board(struct pci_dev *pdev,
+ struct net_device *dev,
+ void __iomem *ioaddr)
{
iounmap(ioaddr);
pci_release_regions(pdev);
@@ -1406,87 +1530,79 @@ static void rtl8169_release_board(struct
free_netdev(dev);
}

-static void rtl8169_init_phy(struct net_device *dev, struct
rtl8169_private *tp)
+/**
+ * rtl8169_set_mac_address - Change the Ethernet Address of the NIC
+ * @dev: network interface device structure
+ * @p: pointer to an address structure
+ *
+ * Return 0 on success, negative on failure
+ **/
+static int
+rtl8169_set_mac_address(struct net_device *dev,
+ void *p)
{
- void __iomem *ioaddr = tp->mmio_addr;
- static int board_idx = -1;
- u8 autoneg, duplex;
- u16 speed;
-
- board_idx++;
-
- rtl8169_hw_phy_config(dev);
-
- dprintk("Set MAC Reg C+CR Offset 0x82h = 0x01h\n");
- RTL_W8(0x82, 0x01);
-
- if (tp->mac_version < RTL_GIGA_MAC_VER_03) {
- dprintk("Set PCI Latency=0x40\n");
- pci_write_config_byte(tp->pci_dev, PCI_LATENCY_TIMER, 0x40);
- }
-
- if (tp->mac_version == RTL_GIGA_MAC_VER_02) {
- dprintk("Set MAC Reg C+CR Offset 0x82h = 0x01h\n");
- RTL_W8(0x82, 0x01);
- dprintk("Set PHY Reg 0x0bh = 0x00h\n");
- mdio_write(ioaddr, 0x0b, 0x0000); //w 0x0b 15 0 0
- }
+ struct rtl8169_private *tp = netdev_priv(dev);
+ struct sockaddr *addr = p;

- rtl8169_link_option(board_idx, &autoneg, &speed, &duplex);
+ if (!is_valid_ether_addr(addr->sa_data))
+ return -EADDRNOTAVAIL;

- rtl8169_set_speed(dev, autoneg, speed, duplex);
+ memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+ memcpy(tp->mac_addr, addr->sa_data, dev->addr_len);

- if ((RTL_R8(PHYstatus) & TBI_Enable) && netif_msg_link(tp))
- printk(KERN_INFO PFX "%s: TBI auto-negotiating\n", dev->name);
+ rtl8169_rar_set(tp, tp->mac_addr, 0);
+
+ return 0;
}

-static int rtl8169_ioctl(struct net_device *dev, struct ifreq *ifr, int
cmd)
-{
- struct rtl8169_private *tp = netdev_priv(dev);
- struct mii_ioctl_data *data = if_mii(ifr);
+/******************************************************************************
+ * rtl8169_rar_set - Puts an ethernet address into a receive address
register.
+ *
+ * tp - The private data structure for driver
+ * addr - Address to put into receive address register
+ * index - Receive address register to write
+
*****************************************************************************/
+void
+rtl8169_rar_set(struct rtl8169_private *tp,
+ uint8_t *addr,
+ uint32_t index)
+{
+ void __iomem *ioaddr = tp->mmio_addr;
+ uint32_t rar_low = 0;
+ uint32_t rar_high = 0;
+
+ rar_low = ((uint32_t) addr[0] |
+ ((uint32_t) addr[1] << 8) |
+ ((uint32_t) addr[2] << 16) |
+ ((uint32_t) addr[3] << 24));

- if (!netif_running(dev))
- return -ENODEV;
+ rar_high = ((uint32_t) addr[4] |
+ ((uint32_t) addr[5] << 8));

- switch (cmd) {
- case SIOCGMIIPHY:
- data->phy_id = 32; /* Internal PHY */
- return 0;
-
- case SIOCGMIIREG:
- data->val_out = mdio_read(tp->mmio_addr, data->reg_num & 0x1f);
- return 0;
-
- case SIOCSMIIREG:
- if (!capable(CAP_NET_ADMIN))
- return -EPERM;
- mdio_write(tp->mmio_addr, data->reg_num & 0x1f, data->val_in);
- return 0;
- }
- return -EOPNOTSUPP;
+ RTL_W8(Cfg9346, Cfg9346_Unlock);
+ RTL_W32(MAC0, rar_low);
+ RTL_W32(MAC4, rar_high);
+ RTL_W8(Cfg9346, Cfg9346_Lock);
}

static int __devinit
-rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+rtl8169_init_board(struct pci_dev *pdev,
+ struct net_device **dev_out,
+ void __iomem **ioaddr_out)
{
- const unsigned int region = rtl_cfg_info[ent->driver_data].region;
- struct rtl8169_private *tp;
- struct net_device *dev;
void __iomem *ioaddr;
- unsigned int pm_cap;
- int i, rc;
+ struct net_device *dev;
+ struct rtl8169_private *tp;
+ int rc = -ENOMEM, i, acpi_idle_state = 0, pm_cap;

- if (netif_msg_drv(&debug)) {
- printk(KERN_INFO "%s Gigabit Ethernet driver %s loaded\n",
- MODULENAME, RTL8169_VERSION);
- }
+ assert(ioaddr_out != NULL);

+ /* dev zeroed in alloc_etherdev */
dev = alloc_etherdev(sizeof (*tp));
- if (!dev) {
+ if (dev == NULL) {
if (netif_msg_drv(&debug))
dev_err(&pdev->dev, "unable to alloc new ethernet\n");
- rc = -ENOMEM;
- goto out;
+ goto err_out;
}

SET_MODULE_OWNER(dev);
@@ -1499,53 +1615,48 @@ rtl8169_init_one(struct pci_dev *pdev, c
if (rc < 0) {
if (netif_msg_probe(tp))
dev_err(&pdev->dev, "enable failure\n");
- goto err_out_free_dev_1;
+ goto err_out_free_dev;
}

rc = pci_set_mwi(pdev);
if (rc < 0)
- goto err_out_disable_2;
+ goto err_out_disable;

/* save power state before pci_enable_device overwrites it */
pm_cap = pci_find_capability(pdev, PCI_CAP_ID_PM);
if (pm_cap) {
- u16 pwr_command, acpi_idle_state;
+ u16 pwr_command;

pci_read_config_word(pdev, pm_cap + PCI_PM_CTRL, &pwr_command);
acpi_idle_state = pwr_command & PCI_PM_CTRL_STATE_MASK;
} else {
- if (netif_msg_probe(tp)) {
+ if (netif_msg_probe(tp))
dev_err(&pdev->dev,
- "PowerManagement capability not found.\n");
- }
+ "PowerManagement capability not found.\n");
}

/* make sure PCI base addr 1 is MMIO */
- if (!(pci_resource_flags(pdev, region) & IORESOURCE_MEM)) {
- if (netif_msg_probe(tp)) {
+ if (!(pci_resource_flags(pdev, 1) & IORESOURCE_MEM)) {
+ if (netif_msg_probe(tp))
dev_err(&pdev->dev,
- "region #%d not an MMIO resource, aborting\n",
- region);
- }
+ "region #1 not an MMIO resource, aborting\n");
rc = -ENODEV;
- goto err_out_mwi_3;
+ goto err_out_mwi;
}
-
/* check for weird/broken PCI region reporting */
- if (pci_resource_len(pdev, region) < R8169_REGS_SIZE) {
- if (netif_msg_probe(tp)) {
+ if (pci_resource_len(pdev, 1) < R8169_REGS_SIZE) {
+ if (netif_msg_probe(tp))
dev_err(&pdev->dev,
- "Invalid PCI region size(s), aborting\n");
- }
+ "Invalid PCI region size(s), aborting\n");
rc = -ENODEV;
- goto err_out_mwi_3;
+ goto err_out_mwi;
}

rc = pci_request_regions(pdev, MODULENAME);
if (rc < 0) {
if (netif_msg_probe(tp))
dev_err(&pdev->dev, "could not request regions.\n");
- goto err_out_mwi_3;
+ goto err_out_mwi;
}

tp->cp_cmd = PCIMulRW | RxChkSum;
@@ -1557,23 +1668,22 @@ rtl8169_init_one(struct pci_dev *pdev, c
} else {
rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
if (rc < 0) {
- if (netif_msg_probe(tp)) {
+ if (netif_msg_probe(tp))
dev_err(&pdev->dev,
- "DMA configuration failed.\n");
- }
- goto err_out_free_res_4;
+ "DMA configuration failed.\n");
+ goto err_out_free_res;
}
}

pci_set_master(pdev);

/* ioremap MMIO region */
- ioaddr = ioremap(pci_resource_start(pdev, region), R8169_REGS_SIZE);
- if (!ioaddr) {
+ ioaddr = ioremap(pci_resource_start(pdev, 1), R8169_REGS_SIZE);
+ if (ioaddr == NULL) {
if (netif_msg_probe(tp))
dev_err(&pdev->dev, "cannot remap MMIO, aborting\n");
rc = -EIO;
- goto err_out_free_res_4;
+ goto err_out_free_res;
}

/* Unneeded ? Don't mess with Mrs. Murphy. */
@@ -1583,10 +1693,10 @@ rtl8169_init_one(struct pci_dev *pdev, c
RTL_W8(ChipCmd, CmdReset);

/* Check that the chip has finished the reset. */
- for (i = 100; i > 0; i--) {
+ for (i = 1000; i > 0; i--) {
if ((RTL_R8(ChipCmd) & CmdReset) == 0)
break;
- msleep_interruptible(1);
+ udelay(10);
}

/* Identify chip attached to board */
@@ -1604,8 +1714,8 @@ rtl8169_init_one(struct pci_dev *pdev, c
/* Unknown chip: assume array element #0, original RTL-8169 */
if (netif_msg_probe(tp)) {
dev_printk(KERN_DEBUG, &pdev->dev,
- "unknown chip version, assuming %s\n",
- rtl_chip_info[0].name);
+ "unknown chip version, assuming %s\n",
+ rtl_chip_info[0].name);
}
i++;
}
@@ -1616,6 +1726,57 @@ rtl8169_init_one(struct pci_dev *pdev, c
RTL_W8(Config5, RTL_R8(Config5) & PMEStatus);
RTL_W8(Cfg9346, Cfg9346_Lock);

+ *ioaddr_out = ioaddr;
+ *dev_out = dev;
+out:
+ return rc;
+
+err_out_free_res:
+ pci_release_regions(pdev);
+
+err_out_mwi:
+ pci_clear_mwi(pdev);
+
+err_out_disable:
+ pci_disable_device(pdev);
+
+err_out_free_dev:
+ free_netdev(dev);
+err_out:
+ *ioaddr_out = NULL;
+ *dev_out = NULL;
+ goto out;
+}
+
+static int __devinit
+rtl8169_init_one(struct pci_dev *pdev,
+ const struct pci_device_id *ent)
+{
+ struct net_device *dev = NULL;
+ struct rtl8169_private *tp;
+ void __iomem *ioaddr = NULL;
+ static int board_idx = -1;
+ u8 autoneg, duplex;
+ u16 speed;
+ int i, rc;
+
+ assert(pdev != NULL);
+ assert(ent != NULL);
+
+ board_idx++;
+
+ if (netif_msg_drv(&debug)) {
+ printk(KERN_INFO "%s Gigabit Ethernet driver %s loaded\n",
+ MODULENAME, RTL8169_VERSION);
+ }
+
+ rc = rtl8169_init_board(pdev, &dev, &ioaddr);
+ if (rc)
+ return rc;
+
+ tp = netdev_priv(dev);
+ assert(ioaddr != NULL);
+
if (RTL_R8(PHYstatus) & TBI_Enable) {
tp->set_speed = rtl8169_set_speed_tbi;
tp->get_settings = rtl8169_gset_tbi;
@@ -1623,21 +1784,20 @@ rtl8169_init_one(struct pci_dev *pdev, c
tp->phy_reset_pending = rtl8169_tbi_reset_pending;
tp->link_ok = rtl8169_tbi_link_ok;

- tp->phy_1000_ctrl_reg = ADVERTISE_1000FULL; /* Implied by TBI */
+ tp->phy_1000_ctrl_reg = PHY_Cap_1000_Full; /* Implied by TBI */
} else {
tp->set_speed = rtl8169_set_speed_xmii;
tp->get_settings = rtl8169_gset_xmii;
tp->phy_reset_enable = rtl8169_xmii_reset_enable;
tp->phy_reset_pending = rtl8169_xmii_reset_pending;
tp->link_ok = rtl8169_xmii_link_ok;
-
- dev->do_ioctl = rtl8169_ioctl;
}

/* Get MAC address. FIXME: read EEPROM */
for (i = 0; i < MAC_ADDR_LEN; i++)
dev->dev_addr[i] = RTL_R8(MAC0 + i);
memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
+ memcpy(dev->dev_addr, dev->dev_addr, dev->addr_len);

dev->open = rtl8169_open;
dev->hard_start_xmit = rtl8169_start_xmit;
@@ -1650,6 +1810,7 @@ rtl8169_init_one(struct pci_dev *pdev, c
dev->irq = pdev->irq;
dev->base_addr = (unsigned long) ioaddr;
dev->change_mtu = rtl8169_change_mtu;
+ dev->set_mac_address = rtl8169_set_mac_address;

#ifdef CONFIG_R8169_NAPI
dev->poll = rtl8169_poll;
@@ -1669,13 +1830,19 @@ rtl8169_init_one(struct pci_dev *pdev, c
tp->intr_mask = 0xffff;
tp->pci_dev = pdev;
tp->mmio_addr = ioaddr;
- tp->align = rtl_cfg_info[ent->driver_data].align;

spin_lock_init(&tp->lock);

rc = register_netdev(dev);
- if (rc < 0)
- goto err_out_unmap_5;
+ if (rc) {
+ rtl8169_release_board(pdev, dev, ioaddr);
+ return rc;
+ }
+
+ if (netif_msg_probe(tp)) {
+ printk(KERN_DEBUG "%s: Identified chip type is '%s'.\n",
+ dev->name, rtl_chip_info[tp->chipset].name);
+ }

pci_set_drvdata(pdev, dev);

@@ -1684,29 +1851,23 @@ rtl8169_init_one(struct pci_dev *pdev, c
"%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x, "
"IRQ %d\n",
dev->name,
- rtl_chip_info[tp->chipset].name,
+ rtl_chip_info[ent->driver_data].name,
dev->base_addr,
dev->dev_addr[0], dev->dev_addr[1],
dev->dev_addr[2], dev->dev_addr[3],
dev->dev_addr[4], dev->dev_addr[5], dev->irq);
}

- rtl8169_init_phy(dev, tp);
+ rtl8169_hw_phy_config(dev);

-out:
- return rc;
+ rtl8169_link_option(board_idx, &autoneg, &speed, &duplex);

-err_out_unmap_5:
- iounmap(ioaddr);
-err_out_free_res_4:
- pci_release_regions(pdev);
-err_out_mwi_3:
- pci_clear_mwi(pdev);
-err_out_disable_2:
- pci_disable_device(pdev);
-err_out_free_dev_1:
- free_netdev(dev);
- goto out;
+ rtl8169_set_speed(dev, autoneg, speed, duplex);
+
+ if ((RTL_R8(PHYstatus) & TBI_Enable) && netif_msg_link(tp))
+ printk(KERN_INFO PFX "%s: TBI auto-negotiating\n", dev->name);
+
+ return 0;
}

static void __devexit
@@ -1723,15 +1884,17 @@ rtl8169_remove_one(struct pci_dev *pdev)
pci_set_drvdata(pdev, NULL);
}

-static void rtl8169_set_rxbufsize(struct rtl8169_private *tp,
- struct net_device *dev)
+static void
+rtl8169_set_rxbufsize(struct rtl8169_private *tp,
+ struct net_device *dev)
{
unsigned int mtu = dev->mtu;

tp->rx_buf_sz = (mtu > RX_BUF_SIZE) ? mtu + ETH_HLEN + 8 : RX_BUF_SIZE;
}

-static int rtl8169_open(struct net_device *dev)
+static int
+rtl8169_open(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);
struct pci_dev *pdev = tp->pci_dev;
@@ -1785,7 +1948,8 @@ err_free_irq:
goto out;
}

-static void rtl8169_hw_reset(void __iomem *ioaddr)
+static void
+rtl8169_hw_reset(void __iomem *ioaddr)
{
/* Disable interrupts */
rtl8169_irq_mask_and_ack(ioaddr);
@@ -1801,102 +1965,95 @@ static void
rtl8169_hw_start(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);
- void __iomem *ioaddr = tp->mmio_addr;
struct pci_dev *pdev = tp->pci_dev;
+ void __iomem *ioaddr = tp->mmio_addr;
u32 i;

/* Soft reset the chip. */
RTL_W8(ChipCmd, CmdReset);

/* Check that the chip has finished the reset. */
- for (i = 100; i > 0; i--) {
+ for (i = 1000; i > 0; i--) {
if ((RTL_R8(ChipCmd) & CmdReset) == 0)
break;
- msleep_interruptible(1);
+ udelay(10);
}

- if (tp->mac_version == RTL_GIGA_MAC_VER_13) {
- pci_write_config_word(pdev, 0x68, 0x00);
- pci_write_config_word(pdev, 0x69, 0x08);
- }
-
- /* Undocumented stuff. */
- if (tp->mac_version == RTL_GIGA_MAC_VER_05) {
- u16 cmd;
-
- /* Realtek's r1000_n.c driver uses '&& 0x01' here. Well... */
- if ((RTL_R8(Config2) & 0x07) & 0x01)
- RTL_W32(0x7c, 0x0007ffff);
-
- RTL_W32(0x7c, 0x0007ff00);
-
- pci_read_config_word(pdev, PCI_COMMAND, &cmd);
- cmd = cmd & 0xef;
- pci_write_config_word(pdev, PCI_COMMAND, cmd);
- }
-
-
RTL_W8(Cfg9346, Cfg9346_Unlock);
+
RTL_W8(EarlyTxThres, EarlyTxThld);

/* Low hurts. Let's disable the filtering. */
RTL_W16(RxMaxSize, 16383);

- /* Set Rx Config register */
- i = rtl8169_rx_config |
- (RTL_R32(RxConfig) & rtl_chip_info[tp->chipset].RxConfigMask);
- RTL_W32(RxConfig, i);
+ tp->cp_cmd |= RTL_R16(CPlusCmd);
+ RTL_W16(CPlusCmd, tp->cp_cmd);

- /* Set DMA burst size and Interframe Gap Time */
- RTL_W32(TxConfig, (TX_DMA_BURST << TxDMAShift) |
- (InterFrameGap << TxInterFrameGapShift));
+ RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) | PCIMulRW);
+ pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, 0x08);

- tp->cp_cmd |= RTL_R16(CPlusCmd) | PCIMulRW;
+ pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x40);

- if ((tp->mac_version == RTL_GIGA_MAC_VER_02) ||
- (tp->mac_version == RTL_GIGA_MAC_VER_03)) {
+ if (RTL_R8(Config2) & PCI_Clock_66MHz) {
+ if (tp->mac_version == RTL_GIGA_MAC_VER_8110SCd)
+ RTL_W32(Offset_7Ch, 0x000FFFFF);
+ else if (tp->mac_version == RTL_GIGA_MAC_VER_8110SCe)
+ RTL_W32(Offset_7Ch, 0x00FFFFFF);
+ } else {
+ if (tp->mac_version == RTL_GIGA_MAC_VER_8110SCd)
+ RTL_W32(Offset_7Ch, 0x000FFF00);
+ else if (tp->mac_version == RTL_GIGA_MAC_VER_8110SCe)
+ RTL_W32(Offset_7Ch, 0x00FFFF00);
+ }
+
+ if ((tp->mac_version == RTL_GIGA_MAC_VER_8169S) ||
+ (tp->mac_version == RTL_GIGA_MAC_VER_8110S)) {
dprintk(KERN_INFO PFX "Set MAC Reg C+CR Offset 0xE0. "
"Bit-3 and bit-14 MUST be 1\n");
- tp->cp_cmd |= (1 << 14);
+ tp->cp_cmd |= (1 << 14) | PCIMulRW;
+ RTL_W16(CPlusCmd, tp->cp_cmd);
}

- RTL_W16(CPlusCmd, tp->cp_cmd);
-
/*
* Undocumented corner. Supposedly:
- * (TxTimer << 12) | (TxPackets << 8) | (RxTimer << 4) | RxPackets
*/
RTL_W16(IntrMitigate, 0x0000);

- /*
- * Magic spell: some iop3xx ARM board needs the TxDescAddrHigh
- * register to be written before TxDescAddrLow to work.
- * Switching from MMIO to I/O access fixes the issue as well.
- */
- RTL_W32(TxDescStartAddrHigh, ((u64) tp->TxPhyAddr >> 32));
RTL_W32(TxDescStartAddrLow, ((u64) tp->TxPhyAddr & DMA_32BIT_MASK));
- RTL_W32(RxDescAddrHigh, ((u64) tp->RxPhyAddr >> 32));
+ RTL_W32(TxDescStartAddrHigh, ((u64) tp->TxPhyAddr >> 32));
RTL_W32(RxDescAddrLow, ((u64) tp->RxPhyAddr & DMA_32BIT_MASK));
- RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
+ RTL_W32(RxDescAddrHigh, ((u64) tp->RxPhyAddr >> 32));
+
RTL_W8(Cfg9346, Cfg9346_Lock);

- /* Initially a 10 us delay. Turned it into a PCI commit. - FR */
- RTL_R8(IntrMask);
+ udelay(10);

RTL_W32(RxMissed, 0);

- rtl8169_set_rx_mode(dev);
-
/* no early-rx interrupts */
RTL_W16(MultiIntr, RTL_R16(MultiIntr) & 0xF000);

+ /* Clear the interrupt status. */
+ RTL_W16(IntrStatus, 0xFFFF);
+
/* Enable all known interrupts by setting the interrupt mask. */
RTL_W16(IntrMask, rtl8169_intr_mask);

+ RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
+
+ /* Set Rx Config register */
+ rtl8169_set_rx_mode(dev);
+
+ /* Set DMA burst size and Interframe Gap Time */
+ RTL_W32(TxConfig, (TX_DMA_BURST << TxDMAShift) |
+ (InterFrameGap << TxInterFrameGapShift));
+
netif_start_queue(dev);
}

-static int rtl8169_change_mtu(struct net_device *dev, int new_mtu)
+static int
+rtl8169_change_mtu(struct net_device *dev,
+ int new_mtu)
{
struct rtl8169_private *tp = netdev_priv(dev);
int ret = 0;
@@ -1927,14 +2084,17 @@ out:
return ret;
}

-static inline void rtl8169_make_unusable_by_asic(struct RxDesc *desc)
+static inline void
+rtl8169_make_unusable_by_asic(struct RxDesc *desc)
{
desc->addr = 0x0badbadbadbadbadull;
desc->opts1 &= ~cpu_to_le32(DescOwn | RsvdMask);
}

-static void rtl8169_free_rx_skb(struct rtl8169_private *tp,
- struct sk_buff **sk_buff, struct RxDesc *desc)
+static void
+rtl8169_free_rx_skb(struct rtl8169_private *tp,
+ struct sk_buff **sk_buff,
+ struct RxDesc *desc)
{
struct pci_dev *pdev = tp->pci_dev;

@@ -1945,34 +2105,40 @@ static void rtl8169_free_rx_skb(struct r
rtl8169_make_unusable_by_asic(desc);
}

-static inline void rtl8169_mark_to_asic(struct RxDesc *desc, u32 rx_buf_sz)
+static inline void
+rtl8169_mark_to_asic(struct RxDesc *desc,
+ u32 rx_buf_sz)
{
u32 eor = le32_to_cpu(desc->opts1) & RingEnd;

desc->opts1 = cpu_to_le32(DescOwn | eor | rx_buf_sz);
}

-static inline void rtl8169_map_to_asic(struct RxDesc *desc, dma_addr_t
mapping,
- u32 rx_buf_sz)
+static inline void
+rtl8169_map_to_asic(struct RxDesc *desc,
+ dma_addr_t mapping,
+ u32 rx_buf_sz)
{
desc->addr = cpu_to_le64(mapping);
wmb();
rtl8169_mark_to_asic(desc, rx_buf_sz);
}

-static int rtl8169_alloc_rx_skb(struct pci_dev *pdev, struct sk_buff
**sk_buff,
- struct RxDesc *desc, int rx_buf_sz,
- unsigned int align)
+static int
+rtl8169_alloc_rx_skb(struct pci_dev *pdev,
+ struct sk_buff **sk_buff,
+ struct RxDesc *desc,
+ int rx_buf_sz)
{
struct sk_buff *skb;
dma_addr_t mapping;
int ret = 0;

- skb = dev_alloc_skb(rx_buf_sz + align);
+ skb = dev_alloc_skb(rx_buf_sz + NET_IP_ALIGN);
if (!skb)
goto err_out;

- skb_reserve(skb, align);
+ skb_reserve(skb, NET_IP_ALIGN);
*sk_buff = skb;

mapping = pci_map_single(pdev, skb->data, rx_buf_sz,
@@ -1989,7 +2155,8 @@ err_out:
goto out;
}

-static void rtl8169_rx_clear(struct rtl8169_private *tp)
+static void
+rtl8169_rx_clear(struct rtl8169_private *tp)
{
int i;

@@ -2001,36 +2168,42 @@ static void rtl8169_rx_clear(struct rtl8
}
}

-static u32 rtl8169_rx_fill(struct rtl8169_private *tp, struct
net_device *dev,
- u32 start, u32 end)
+static u32
+rtl8169_rx_fill(struct rtl8169_private *tp,
+ struct net_device *dev,
+ u32 start,
+ u32 end)
{
u32 cur;
-
+
for (cur = start; end - cur > 0; cur++) {
int ret, i = cur % NUM_RX_DESC;

if (tp->Rx_skbuff[i])
continue;
-
+
ret = rtl8169_alloc_rx_skb(tp->pci_dev, tp->Rx_skbuff + i,
- tp->RxDescArray + i, tp->rx_buf_sz, tp->align);
+ tp->RxDescArray + i, tp->rx_buf_sz);
if (ret < 0)
break;
}
return cur - start;
}

-static inline void rtl8169_mark_as_last_descriptor(struct RxDesc *desc)
+static inline void
+rtl8169_mark_as_last_descriptor(struct RxDesc *desc)
{
desc->opts1 |= cpu_to_le32(RingEnd);
}

-static void rtl8169_init_ring_indexes(struct rtl8169_private *tp)
+static void
+rtl8169_init_ring_indexes(struct rtl8169_private *tp)
{
tp->dirty_tx = tp->dirty_rx = tp->cur_tx = tp->cur_rx = 0;
}

-static int rtl8169_init_ring(struct net_device *dev)
+static int
+rtl8169_init_ring(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);

@@ -2051,8 +2224,10 @@ err_out:
return -ENOMEM;
}

-static void rtl8169_unmap_tx_skb(struct pci_dev *pdev, struct ring_info
*tx_skb,
- struct TxDesc *desc)
+static void
+rtl8169_unmap_tx_skb(struct pci_dev *pdev,
+ struct ring_info *tx_skb,
+ struct TxDesc *desc)
{
unsigned int len = tx_skb->len;

@@ -2063,7 +2238,8 @@ static void rtl8169_unmap_tx_skb(struct
tx_skb->len = 0;
}

-static void rtl8169_tx_clear(struct rtl8169_private *tp)
+static void
+rtl8169_tx_clear(struct rtl8169_private *tp)
{
unsigned int i;

@@ -2087,7 +2263,9 @@ static void rtl8169_tx_clear(struct rtl8
tp->cur_tx = tp->dirty_tx = 0;
}

-static void rtl8169_schedule_work(struct net_device *dev, void
(*task)(void *))
+static void
+rtl8169_schedule_work(struct net_device *dev,
+ void (*task)(void *))
{
struct rtl8169_private *tp = netdev_priv(dev);

@@ -2095,7 +2273,8 @@ static void rtl8169_schedule_work(struct
schedule_delayed_work(&tp->task, 4);
}

-static void rtl8169_wait_for_quiescence(struct net_device *dev)
+static void
+rtl8169_wait_for_quiescence(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
@@ -2110,7 +2289,8 @@ static void rtl8169_wait_for_quiescence(
netif_poll_enable(dev);
}

-static void rtl8169_reinit_task(void *_data)
+static void
+rtl8169_reinit_task(void *_data)
{
struct net_device *dev = _data;
int ret;
@@ -2135,7 +2315,8 @@ static void rtl8169_reinit_task(void *_d
}
}

-static void rtl8169_reset_task(void *_data)
+static void
+rtl8169_reset_task(void *_data)
{
struct net_device *dev = _data;
struct rtl8169_private *tp = netdev_priv(dev);
@@ -2165,7 +2346,8 @@ static void rtl8169_reset_task(void *_da
}
}

-static void rtl8169_tx_timeout(struct net_device *dev)
+static void
+rtl8169_tx_timeout(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);

@@ -2175,12 +2357,14 @@ static void rtl8169_tx_timeout(struct ne
rtl8169_schedule_work(dev, rtl8169_reset_task);
}

-static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct
sk_buff *skb,
- u32 opts1)
+static int
+rtl8169_xmit_frags(struct rtl8169_private *tp,
+ struct sk_buff *skb,
+ u32 opts1)
{
struct skb_shared_info *info = skb_shinfo(skb);
unsigned int cur_frag, entry;
- struct TxDesc *txd;
+ struct TxDesc *txd = NULL;

entry = tp->cur_tx;
for (cur_frag = 0; cur_frag < info->nr_frags; cur_frag++) {
@@ -2205,7 +2389,7 @@ static int rtl8169_xmit_frags(struct rtl
tp->tx_skb[entry].len = len;
}

- if (cur_frag) {
+ if (cur_frag && txd ) {
tp->tx_skb[entry].skb = skb;
txd->opts1 |= cpu_to_le32(LastFrag);
}
@@ -2213,7 +2397,9 @@ static int rtl8169_xmit_frags(struct rtl
return cur_frag;
}

-static inline u32 rtl8169_tso_csum(struct sk_buff *skb, struct
net_device *dev)
+static inline u32
+rtl8169_tso_csum(struct sk_buff *skb,
+ struct net_device *dev)
{
if (dev->features & NETIF_F_TSO) {
u32 mss = skb_shinfo(skb)->gso_size;
@@ -2221,7 +2407,12 @@ static inline u32 rtl8169_tso_csum(struc
if (mss)
return LargeSend | ((mss & MSSMask) << MSSShift);
}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
+ if (skb->ip_summed == CHECKSUM_HW) {
+#else
if (skb->ip_summed == CHECKSUM_PARTIAL) {
+#endif
const struct iphdr *ip = skb->nh.iph;

if (ip->protocol == IPPROTO_TCP)
@@ -2230,10 +2421,13 @@ static inline u32 rtl8169_tso_csum(struc
return IPCS | UDPCS;
WARN_ON(1); /* we need a WARN() */
}
+
return 0;
}

-static int rtl8169_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static int
+rtl8169_start_xmit(struct sk_buff *skb,
+ struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);
unsigned int frags, entry = tp->cur_tx % NUM_TX_DESC;
@@ -2242,8 +2436,8 @@ static int rtl8169_start_xmit(struct sk_
dma_addr_t mapping;
u32 status, len;
u32 opts1;
- int ret = NETDEV_TX_OK;
-
+ int ret = 0;
+
if (unlikely(TX_BUFFS_AVAIL(tp) < skb_shinfo(skb)->nr_frags)) {
if (netif_msg_drv(tp)) {
printk(KERN_ERR
@@ -2307,13 +2501,14 @@ out:

err_stop:
netif_stop_queue(dev);
- ret = NETDEV_TX_BUSY;
+ ret = 1;
err_update_stats:
tp->stats.tx_dropped++;
goto out;
}

-static void rtl8169_pcierr_interrupt(struct net_device *dev)
+static void
+rtl8169_pcierr_interrupt(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);
struct pci_dev *pdev = tp->pci_dev;
@@ -2358,7 +2553,8 @@ static void rtl8169_pcierr_interrupt(str
}

static void
-rtl8169_tx_interrupt(struct net_device *dev, struct rtl8169_private *tp,
+rtl8169_tx_interrupt(struct net_device *dev,
+ struct rtl8169_private *tp,
void __iomem *ioaddr)
{
unsigned int dirty_tx, tx_left;
@@ -2405,12 +2601,14 @@ rtl8169_tx_interrupt(struct net_device *
}
}

-static inline int rtl8169_fragmented_frame(u32 status)
+static inline int
+rtl8169_fragmented_frame(u32 status)
{
return (status & (FirstFrag | LastFrag)) != (FirstFrag | LastFrag);
}

-static inline void rtl8169_rx_csum(struct sk_buff *skb, struct RxDesc
*desc)
+static inline void
+rtl8169_rx_csum(struct sk_buff *skb, struct RxDesc *desc)
{
u32 opts1 = le32_to_cpu(desc->opts1);
u32 status = opts1 & RxProtoMask;
@@ -2423,18 +2621,20 @@ static inline void rtl8169_rx_csum(struc
skb->ip_summed = CHECKSUM_NONE;
}

-static inline int rtl8169_try_rx_copy(struct sk_buff **sk_buff, int
pkt_size,
- struct RxDesc *desc, int rx_buf_sz,
- unsigned int align)
+static inline int
+rtl8169_try_rx_copy(struct sk_buff **sk_buff,
+ int pkt_size,
+ struct RxDesc *desc,
+ int rx_buf_sz)
{
int ret = -1;

if (pkt_size < rx_copybreak) {
struct sk_buff *skb;

- skb = dev_alloc_skb(pkt_size + align);
+ skb = dev_alloc_skb(pkt_size + NET_IP_ALIGN);
if (skb) {
- skb_reserve(skb, align);
+ skb_reserve(skb, NET_IP_ALIGN);
eth_copy_and_sum(skb, sk_buff[0]->data, pkt_size, 0);
*sk_buff = skb;
rtl8169_mark_to_asic(desc, rx_buf_sz);
@@ -2445,7 +2645,8 @@ static inline int rtl8169_try_rx_copy(st
}

static int
-rtl8169_rx_interrupt(struct net_device *dev, struct rtl8169_private *tp,
+rtl8169_rx_interrupt(struct net_device *dev,
+ struct rtl8169_private *tp,
void __iomem *ioaddr)
{
unsigned int cur_rx, rx_left;
@@ -2459,7 +2660,7 @@ rtl8169_rx_interrupt(struct net_device *
rx_left = NUM_RX_DESC + tp->dirty_rx - cur_rx;
rx_left = rtl8169_rx_quota(rx_left, (u32) dev->quota);

- for (; rx_left > 0; rx_left--, cur_rx++) {
+ for (; rx_left > 0; rx_left--) {
unsigned int entry = cur_rx % NUM_RX_DESC;
struct RxDesc *desc = tp->RxDescArray + entry;
u32 status;
@@ -2480,10 +2681,6 @@ rtl8169_rx_interrupt(struct net_device *
tp->stats.rx_length_errors++;
if (status & RxCRC)
tp->stats.rx_crc_errors++;
- if (status & RxFOVF) {
- rtl8169_schedule_work(dev, rtl8169_reset_task);
- tp->stats.rx_fifo_errors++;
- }
rtl8169_mark_to_asic(desc, tp->rx_buf_sz);
} else {
struct sk_buff *skb = tp->Rx_skbuff[entry];
@@ -2504,13 +2701,13 @@ rtl8169_rx_interrupt(struct net_device *
}

rtl8169_rx_csum(skb, desc);
-
+
pci_dma_sync_single_for_cpu(tp->pci_dev,
le64_to_cpu(desc->addr), tp->rx_buf_sz,
PCI_DMA_FROMDEVICE);

if (rtl8169_try_rx_copy(&skb, pkt_size, desc,
- tp->rx_buf_sz, tp->align)) {
+ tp->rx_buf_sz)) {
pci_action = pci_unmap_single;
tp->Rx_skbuff[entry] = NULL;
}
@@ -2529,6 +2726,17 @@ rtl8169_rx_interrupt(struct net_device *
tp->stats.rx_bytes += pkt_size;
tp->stats.rx_packets++;
}
+
+ //Work around for AMD plateform
+ if (((desc->opts2 & 0xFFFE000) != 0) &&
+ (tp->mac_version == RTL_GIGA_MAC_VER_8110SCd)) {
+ printk("%s: vlan_tag:%x\n", dev->name, desc->opts2);
+
+ desc->opts2 = 0;
+ cur_rx = cur_rx + 2;
+ } else {
+ cur_rx++;
+ }
}

count = cur_rx - tp->cur_rx;
@@ -2553,8 +2761,16 @@ rtl8169_rx_interrupt(struct net_device *
}

/* The interrupt handler does all of the Rx thread work and cleans up
after the Tx thread. */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
static irqreturn_t
-rtl8169_interrupt(int irq, void *dev_instance)
+rtl8169_interrupt(int irq,
+ void *dev_instance,
+ struct pt_regs *regs)
+#else
+static irqreturn_t
+rtl8169_interrupt(int irq,
+ void *dev_instance)
+#endif
{
struct net_device *dev = (struct net_device *) dev_instance;
struct rtl8169_private *tp = netdev_priv(dev);
@@ -2600,7 +2816,7 @@ rtl8169_interrupt(int irq, void *dev_ins
__netif_rx_schedule(dev);
else if (netif_msg_intr(tp)) {
printk(KERN_INFO "%s: interrupt %04x taken in poll\n",
- dev->name, status);
+ dev->name, status);
}
break;
#else
@@ -2629,7 +2845,9 @@ out:
}

#ifdef CONFIG_R8169_NAPI
-static int rtl8169_poll(struct net_device *dev, int *budget)
+static int
+rtl8169_poll(struct net_device *dev,
+ int *budget)
{
unsigned int work_done, work_to_do = min(*budget, dev->quota);
struct rtl8169_private *tp = netdev_priv(dev);
@@ -2658,12 +2876,12 @@ static int rtl8169_poll(struct net_devic
}
#endif

-static void rtl8169_down(struct net_device *dev)
+static void
+rtl8169_down(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
unsigned int poll_locked = 0;
- unsigned int intrmask;

rtl8169_delete_timer(dev);

@@ -2702,11 +2920,8 @@ core_down:
* 2) dev->change_mtu
* -> rtl8169_poll can not be issued again and re-enable the
* interruptions. Let's simply issue the IRQ down sequence again.
- *
- * No loop if hotpluged or major error (0xffff).
*/
- intrmask = RTL_R16(IntrMask);
- if (intrmask && (intrmask != 0xffff))
+ if (RTL_R16(IntrMask))
goto core_down;

rtl8169_tx_clear(tp);
@@ -2714,7 +2929,8 @@ core_down:
rtl8169_rx_clear(tp);
}

-static int rtl8169_close(struct net_device *dev)
+static int
+rtl8169_close(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);
struct pci_dev *pdev = tp->pci_dev;
@@ -2777,15 +2993,6 @@ rtl8169_set_rx_mode(struct net_device *d
tmp = rtl8169_rx_config | rx_mode |
(RTL_R32(RxConfig) & rtl_chip_info[tp->chipset].RxConfigMask);

- if ((tp->mac_version == RTL_GIGA_MAC_VER_11) ||
- (tp->mac_version == RTL_GIGA_MAC_VER_12) ||
- (tp->mac_version == RTL_GIGA_MAC_VER_13) ||
- (tp->mac_version == RTL_GIGA_MAC_VER_14) ||
- (tp->mac_version == RTL_GIGA_MAC_VER_15)) {
- mc_filter[0] = 0xffffffff;
- mc_filter[1] = 0xffffffff;
- }
-
RTL_W32(RxConfig, tmp);
RTL_W32(MAR0 + 0, mc_filter[0]);
RTL_W32(MAR0 + 4, mc_filter[1]);
@@ -2799,7 +3006,8 @@ rtl8169_set_rx_mode(struct net_device *d
*
* Get TX/RX statistics for rtl8169
*/
-static struct net_device_stats *rtl8169_get_stats(struct net_device *dev)
+static struct net_device_stats
+*rtl8169_get_stats(struct net_device *dev)
{
struct rtl8169_private *tp = netdev_priv(dev);
void __iomem *ioaddr = tp->mmio_addr;
@@ -2811,13 +3019,15 @@ static struct net_device_stats *rtl8169_
RTL_W32(RxMissed, 0);
spin_unlock_irqrestore(&tp->lock, flags);
}
-
+
return &tp->stats;
}

#ifdef CONFIG_PM

-static int rtl8169_suspend(struct pci_dev *pdev, pm_message_t state)
+static int
+rtl8169_suspend(struct pci_dev *pdev,
+ pm_message_t state)
{
struct net_device *dev = pci_get_drvdata(pdev);
struct rtl8169_private *tp = netdev_priv(dev);
@@ -2845,7 +3055,8 @@ out:
return 0;
}

-static int rtl8169_resume(struct pci_dev *pdev)
+static int
+rtl8169_resume(struct pci_dev *pdev)
{
struct net_device *dev = pci_get_drvdata(pdev);

@@ -2879,7 +3090,7 @@ static struct pci_driver rtl8169_pci_dri
static int __init
rtl8169_init_module(void)
{
- return pci_register_driver(&rtl8169_pci_driver);
+ return pci_module_init(&rtl8169_pci_driver);
}

static void __exit

