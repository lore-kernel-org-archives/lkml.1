Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbYJGWW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbYJGWW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbYJGWWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:22:44 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:33872 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059AbYJGWWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:22:42 -0400
Date: Wed, 8 Oct 2008 00:22:02 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?unknown-8bit?B?Si5BLiBNYWdhbGzDs24=?= <jamagallon@ono.com>
Cc: Greg KH <greg@kroah.com>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       Bruno =?unknown-8bit?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Ivan Vecera <ivecera@redhat.com>,
       Edward Hsu <edward_hsu@realtek.com.tw>
Subject: Re: Update request for r8169
Message-ID: <20081007222202.GA9393@electric-eye.fr.zoreil.com>
References: <20081006021614.1c7fcaff@werewolf.home> <20081006035945.GA26148@kroah.com> <20081006071229.GA23039@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081006071229.GA23039@electric-eye.fr.zoreil.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu <romieu@fr.zoreil.com> :
[...]
> Btw I'll push Ivan Vecera's MAC address restore and Bruno Prémont WoL
> patches too.

Both can be retrieved from the 'r8169' branch in repository

git://git.kernel.org/pub/scm/linux/kernel/git/romieu/netdev-2.6.git r8169

Those who base their work on 2.6.27-rc can use the patchkit available
at http://userweb.kernel.org/~romieu/r8169/2.6.26-rc9. It includes the
r8169 driver related patches which are already in davem net-next (patches
#0001 to #0009 inclusive) and provides the same r8169 content as the
r8169 branch (patches #0010 to #0026).

The r8169 branch is based on davem's net-next branch as described below.

Its content will be sent on netdev as individual patches later this week.

Distance from 'davem-next' (b39d66a81fb4f5ab555f86a2e49f3714f8369a3d)
---------------------------------------------------------------------

f87849784ebe816104a59aef4d8ef20ae1cadbec
e71e7382a33526356a1766eafc4241f146dc6d63
0253ee37571e428fb13be9c3a0bbf69193311f9a
925aac68a093252ca991a1a4754c29b4483c25dd
4aa6f103ef5ff32330e5a847e8cb229c3c38491d
ae7407ac0b3118036cb70c991339e2a523a9a029
a6bad6a5acf18d046b5839dc2177c0ffb7b2ee5f
1ee57f3ef538415407cb3a63072eaa0a9aad98ce
bedf5ed4284e43b1252b63b6a99fb8755a232b50
f3b926ae7a429f9fda7d71f94dc49d99e4228c26
bd0915698baf34e144b0f69fb712e72bfe0d39e0
080abb6230862771c8b853bea02cd9fbf1baa0d8
732913f95ed5402df16918040a7ddbed9e8a2cbe
8724cc67762debeaaefe94b1da567b8b87f01ac7
13fee6cbde7e923761b7d02823fae306e36c446b
834fee3e6ab93bc3f5142e056698d018a0186c62
ee8e6cdf29e88ae7e2628084257d12de13cc6dd1

Diffstat
--------

 drivers/net/r8169.c |  551 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 525 insertions(+), 26 deletions(-)

Shortlog
--------

Bruno Prémont (2):
      r8169: check the status of the WoL feature on init
      r8169: notify WoL settings to the device layer

Francois Romieu (14):
      r8169: wake up the PHY of the 8168
      r8169: update phy init parameters
      r8169: new phy init parameters for the 8168b
      r8169: shuffle some registers handling around (8168 operation only)
      r8169: make room for more specific 8168 hardware start procedure
      r8169: 8168b Tx performance tweak
      r8169: sync existing 8168 device hardware start sequences with vendor driver
      r8169: add a new 8168c flavor
      r8169: add a new 8168c flavor (bis)
      r8169: add a new 8168cp flavor
      r8169: change default behavior for mildly identified 8168c chipsets
      r8169: support additional 8168cp chipset
      r8169: preliminary 8168d support
      r8169: add shutdown handler

Ivan Vecera (1):
      r8169: read MAC address from EEPROM on init

Patch
-----

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index fb899c6..45bdd87 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -109,7 +109,12 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_17 = 0x10, // 8168Bf
 	RTL_GIGA_MAC_VER_18 = 0x12, // 8168CP
 	RTL_GIGA_MAC_VER_19 = 0x13, // 8168C
-	RTL_GIGA_MAC_VER_20 = 0x14  // 8168C
+	RTL_GIGA_MAC_VER_20 = 0x14, // 8168C
+	RTL_GIGA_MAC_VER_21 = 0x15, // 8168C
+	RTL_GIGA_MAC_VER_22 = 0x16, // 8168C
+	RTL_GIGA_MAC_VER_23 = 0x17, // 8168CP
+	RTL_GIGA_MAC_VER_24 = 0x18, // 8168CP
+	RTL_GIGA_MAC_VER_25 = 0x19  // 8168D
 };
 
 #define _R(NAME,MAC,MASK) \
@@ -139,7 +144,12 @@ static const struct {
 	_R("RTL8101e",		RTL_GIGA_MAC_VER_16, 0xff7e1880), // PCI-E
 	_R("RTL8168cp/8111cp",	RTL_GIGA_MAC_VER_18, 0xff7e1880), // PCI-E
 	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_19, 0xff7e1880), // PCI-E
-	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_20, 0xff7e1880)  // PCI-E
+	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_20, 0xff7e1880), // PCI-E
+	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_21, 0xff7e1880), // PCI-E
+	_R("RTL8168c/8111c",	RTL_GIGA_MAC_VER_22, 0xff7e1880), // PCI-E
+	_R("RTL8168cp/8111cp",	RTL_GIGA_MAC_VER_23, 0xff7e1880), // PCI-E
+	_R("RTL8168cp/8111cp",	RTL_GIGA_MAC_VER_24, 0xff7e1880), // PCI-E
+	_R("RTL8168d/8111d",	RTL_GIGA_MAC_VER_25, 0xff7e1880)  // PCI-E
 };
 #undef _R
 
@@ -760,6 +770,8 @@ static int rtl8169_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	else
 		tp->features &= ~RTL_FEATURE_WOL;
 
+	device_set_wakeup_enable(&tp->pci_dev->dev, wol->wolopts);
+
 	spin_unlock_irq(&tp->lock);
 
 	return 0;
@@ -864,9 +876,13 @@ static int rtl8169_set_speed_xmii(struct net_device *dev,
 
 	auto_nego |= ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM;
 
-	if ((tp->mac_version == RTL_GIGA_MAC_VER_12) ||
-	    (tp->mac_version == RTL_GIGA_MAC_VER_17)) {
-		/* Vendor specific (0x1f) and reserved (0x0e) MII registers. */
+	if ((tp->mac_version == RTL_GIGA_MAC_VER_11) ||
+	    (tp->mac_version == RTL_GIGA_MAC_VER_12) ||
+	    (tp->mac_version >= RTL_GIGA_MAC_VER_17)) {
+		/*
+		 * Wake up the PHY.
+		 * Vendor specific (0x1f) and reserved (0x0e) MII registers.
+		 */
 		mdio_write(ioaddr, 0x1f, 0x0000);
 		mdio_write(ioaddr, 0x0e, 0x0000);
 	}
@@ -1211,11 +1227,19 @@ static void rtl8169_get_mac_version(struct rtl8169_private *tp,
 		u32 val;
 		int mac_version;
 	} mac_info[] = {
-		/* 8168B family. */
-		{ 0x7c800000, 0x3c800000,	RTL_GIGA_MAC_VER_18 },
+		/* 8168D family. */
+		{ 0x7c800000, 0x28000000,	RTL_GIGA_MAC_VER_25 },
+
+		/* 8168C family. */
+		{ 0x7cf00000, 0x3ca00000,	RTL_GIGA_MAC_VER_24 },
+		{ 0x7cf00000, 0x3c900000,	RTL_GIGA_MAC_VER_23 },
+		{ 0x7cf00000, 0x3c800000,	RTL_GIGA_MAC_VER_18 },
+		{ 0x7c800000, 0x3c800000,	RTL_GIGA_MAC_VER_24 },
 		{ 0x7cf00000, 0x3c000000,	RTL_GIGA_MAC_VER_19 },
 		{ 0x7cf00000, 0x3c200000,	RTL_GIGA_MAC_VER_20 },
-		{ 0x7c800000, 0x3c000000,	RTL_GIGA_MAC_VER_20 },
+		{ 0x7cf00000, 0x3c300000,	RTL_GIGA_MAC_VER_21 },
+		{ 0x7cf00000, 0x3c400000,	RTL_GIGA_MAC_VER_22 },
+		{ 0x7c800000, 0x3c000000,	RTL_GIGA_MAC_VER_22 },
 
 		/* 8168B family. */
 		{ 0x7cf00000, 0x38000000,	RTL_GIGA_MAC_VER_12 },
@@ -1345,7 +1369,31 @@ static void rtl8169sb_hw_phy_config(void __iomem *ioaddr)
 	rtl_phy_write(ioaddr, phy_reg_init, ARRAY_SIZE(phy_reg_init));
 }
 
-static void rtl8168cp_hw_phy_config(void __iomem *ioaddr)
+static void rtl8168bb_hw_phy_config(void __iomem *ioaddr)
+{
+	struct phy_reg phy_reg_init[] = {
+		{ 0x10, 0xf41b },
+		{ 0x1f, 0x0000 }
+	};
+
+	mdio_write(ioaddr, 0x1f, 0x0001);
+	mdio_patch(ioaddr, 0x16, 1 << 0);
+
+	rtl_phy_write(ioaddr, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+}
+
+static void rtl8168bef_hw_phy_config(void __iomem *ioaddr)
+{
+	struct phy_reg phy_reg_init[] = {
+		{ 0x1f, 0x0001 },
+		{ 0x10, 0xf41b },
+		{ 0x1f, 0x0000 }
+	};
+
+	rtl_phy_write(ioaddr, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+}
+
+static void rtl8168cp_1_hw_phy_config(void __iomem *ioaddr)
 {
 	struct phy_reg phy_reg_init[] = {
 		{ 0x1f, 0x0000 },
@@ -1358,7 +1406,22 @@ static void rtl8168cp_hw_phy_config(void __iomem *ioaddr)
 	rtl_phy_write(ioaddr, phy_reg_init, ARRAY_SIZE(phy_reg_init));
 }
 
-static void rtl8168c_hw_phy_config(void __iomem *ioaddr)
+static void rtl8168cp_2_hw_phy_config(void __iomem *ioaddr)
+{
+	struct phy_reg phy_reg_init[] = {
+		{ 0x1f, 0x0001 },
+		{ 0x1d, 0x3d98 },
+		{ 0x1f, 0x0000 }
+	};
+
+	mdio_write(ioaddr, 0x1f, 0x0000);
+	mdio_patch(ioaddr, 0x14, 1 << 5);
+	mdio_patch(ioaddr, 0x0d, 1 << 5);
+
+	rtl_phy_write(ioaddr, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+}
+
+static void rtl8168c_1_hw_phy_config(void __iomem *ioaddr)
 {
 	struct phy_reg phy_reg_init[] = {
 		{ 0x1f, 0x0001 },
@@ -1374,26 +1437,142 @@ static void rtl8168c_hw_phy_config(void __iomem *ioaddr)
 		{ 0x1f, 0x0003 },
 		{ 0x12, 0xc096 },
 		{ 0x16, 0x000a },
-		{ 0x1f, 0x0000 }
+		{ 0x1f, 0x0000 },
+		{ 0x1f, 0x0000 },
+		{ 0x09, 0x2000 },
+		{ 0x09, 0x0000 }
 	};
 
 	rtl_phy_write(ioaddr, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+
+	mdio_patch(ioaddr, 0x14, 1 << 5);
+	mdio_patch(ioaddr, 0x0d, 1 << 5);
+	mdio_write(ioaddr, 0x1f, 0x0000);
 }
 
-static void rtl8168cx_hw_phy_config(void __iomem *ioaddr)
+static void rtl8168c_2_hw_phy_config(void __iomem *ioaddr)
 {
 	struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0000 },
+		{ 0x1f, 0x0001 },
 		{ 0x12, 0x2300 },
+		{ 0x03, 0x802f },
+		{ 0x02, 0x4f02 },
+		{ 0x01, 0x0409 },
+		{ 0x00, 0xf099 },
+		{ 0x04, 0x9800 },
+		{ 0x04, 0x9000 },
+		{ 0x1d, 0x3d98 },
+		{ 0x1f, 0x0002 },
+		{ 0x0c, 0x7eb8 },
+		{ 0x06, 0x0761 },
 		{ 0x1f, 0x0003 },
 		{ 0x16, 0x0f0a },
-		{ 0x1f, 0x0000 },
+		{ 0x1f, 0x0000 }
+	};
+
+	rtl_phy_write(ioaddr, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+
+	mdio_patch(ioaddr, 0x16, 1 << 0);
+	mdio_patch(ioaddr, 0x14, 1 << 5);
+	mdio_patch(ioaddr, 0x0d, 1 << 5);
+	mdio_write(ioaddr, 0x1f, 0x0000);
+}
+
+static void rtl8168c_3_hw_phy_config(void __iomem *ioaddr)
+{
+	struct phy_reg phy_reg_init[] = {
+		{ 0x1f, 0x0001 },
+		{ 0x12, 0x2300 },
+		{ 0x1d, 0x3d98 },
 		{ 0x1f, 0x0002 },
 		{ 0x0c, 0x7eb8 },
+		{ 0x06, 0x5461 },
+		{ 0x1f, 0x0003 },
+		{ 0x16, 0x0f0a },
 		{ 0x1f, 0x0000 }
 	};
 
 	rtl_phy_write(ioaddr, phy_reg_init, ARRAY_SIZE(phy_reg_init));
+
+	mdio_patch(ioaddr, 0x16, 1 << 0);
+	mdio_patch(ioaddr, 0x14, 1 << 5);
+	mdio_patch(ioaddr, 0x0d, 1 << 5);
+	mdio_write(ioaddr, 0x1f, 0x0000);
+}
+
+static void rtl8168c_4_hw_phy_config(void __iomem *ioaddr)
+{
+	rtl8168c_3_hw_phy_config(ioaddr);
+}
+
+static void rtl8168d_hw_phy_config(void __iomem *ioaddr)
+{
+	struct phy_reg phy_reg_init_0[] = {
+		{ 0x1f, 0x0001 },
+		{ 0x09, 0x2770 },
+		{ 0x08, 0x04d0 },
+		{ 0x0b, 0xad15 },
+		{ 0x0c, 0x5bf0 },
+		{ 0x1c, 0xf101 },
+		{ 0x1f, 0x0003 },
+		{ 0x14, 0x94d7 },
+		{ 0x12, 0xf4d6 },
+		{ 0x09, 0xca0f },
+		{ 0x1f, 0x0002 },
+		{ 0x0b, 0x0b10 },
+		{ 0x0c, 0xd1f7 },
+		{ 0x1f, 0x0002 },
+		{ 0x06, 0x5461 },
+		{ 0x1f, 0x0002 },
+		{ 0x05, 0x6662 },
+		{ 0x1f, 0x0000 },
+		{ 0x14, 0x0060 },
+		{ 0x1f, 0x0000 },
+		{ 0x0d, 0xf8a0 },
+		{ 0x1f, 0x0005 },
+		{ 0x05, 0xffc2 }
+	};
+
+	rtl_phy_write(ioaddr, phy_reg_init_0, ARRAY_SIZE(phy_reg_init_0));
+
+	if (mdio_read(ioaddr, 0x06) == 0xc400) {
+		struct phy_reg phy_reg_init_1[] = {
+			{ 0x1f, 0x0005 },
+			{ 0x01, 0x0300 },
+			{ 0x1f, 0x0000 },
+			{ 0x11, 0x401c },
+			{ 0x16, 0x4100 },
+			{ 0x1f, 0x0005 },
+			{ 0x07, 0x0010 },
+			{ 0x05, 0x83dc },
+			{ 0x06, 0x087d },
+			{ 0x05, 0x8300 },
+			{ 0x06, 0x0101 },
+			{ 0x06, 0x05f8 },
+			{ 0x06, 0xf9fa },
+			{ 0x06, 0xfbef },
+			{ 0x06, 0x79e2 },
+			{ 0x06, 0x835f },
+			{ 0x06, 0xe0f8 },
+			{ 0x06, 0x9ae1 },
+			{ 0x06, 0xf89b },
+			{ 0x06, 0xef31 },
+			{ 0x06, 0x3b65 },
+			{ 0x06, 0xaa07 },
+			{ 0x06, 0x81e4 },
+			{ 0x06, 0xf89a },
+			{ 0x06, 0xe5f8 },
+			{ 0x06, 0x9baf },
+			{ 0x06, 0x06ae },
+			{ 0x05, 0x83dc },
+			{ 0x06, 0x8300 },
+		};
+
+		rtl_phy_write(ioaddr, phy_reg_init_1,
+			      ARRAY_SIZE(phy_reg_init_1));
+	}
+
+	mdio_write(ioaddr, 0x1f, 0x0000);
 }
 
 static void rtl8102e_hw_phy_config(void __iomem *ioaddr)
@@ -1434,15 +1613,38 @@ static void rtl_hw_phy_config(struct net_device *dev)
 	case RTL_GIGA_MAC_VER_09:
 		rtl8102e_hw_phy_config(ioaddr);
 		break;
+	case RTL_GIGA_MAC_VER_11:
+		rtl8168bb_hw_phy_config(ioaddr);
+		break;
+	case RTL_GIGA_MAC_VER_12:
+		rtl8168bef_hw_phy_config(ioaddr);
+		break;
+	case RTL_GIGA_MAC_VER_17:
+		rtl8168bef_hw_phy_config(ioaddr);
+		break;
 	case RTL_GIGA_MAC_VER_18:
-		rtl8168cp_hw_phy_config(ioaddr);
+		rtl8168cp_1_hw_phy_config(ioaddr);
 		break;
 	case RTL_GIGA_MAC_VER_19:
-		rtl8168c_hw_phy_config(ioaddr);
+		rtl8168c_1_hw_phy_config(ioaddr);
 		break;
 	case RTL_GIGA_MAC_VER_20:
-		rtl8168cx_hw_phy_config(ioaddr);
+		rtl8168c_2_hw_phy_config(ioaddr);
+		break;
+	case RTL_GIGA_MAC_VER_21:
+		rtl8168c_3_hw_phy_config(ioaddr);
+		break;
+	case RTL_GIGA_MAC_VER_22:
+		rtl8168c_4_hw_phy_config(ioaddr);
+		break;
+	case RTL_GIGA_MAC_VER_23:
+	case RTL_GIGA_MAC_VER_24:
+		rtl8168cp_2_hw_phy_config(ioaddr);
+		break;
+	case RTL_GIGA_MAC_VER_25:
+		rtl8168d_hw_phy_config(ioaddr);
 		break;
+
 	default:
 		break;
 	}
@@ -1710,6 +1912,83 @@ static void rtl_disable_msi(struct pci_dev *pdev, struct rtl8169_private *tp)
 	}
 }
 
+static int rtl_eeprom_read(struct pci_dev *pdev, int cap, int addr, __le32 *val)
+{
+	int ret, count = 100;
+	u16 status = 0;
+	u32 value;
+
+	ret = pci_write_config_word(pdev, cap + PCI_VPD_ADDR, addr);
+	if (ret < 0)
+		return ret;
+
+	do {
+		udelay(10);
+		ret = pci_read_config_word(pdev, cap + PCI_VPD_ADDR, &status);
+		if (ret < 0)
+			return ret;
+	} while (!(status & PCI_VPD_ADDR_F) && --count);
+
+	if (!(status & PCI_VPD_ADDR_F))
+		return -ETIMEDOUT;
+
+	ret = pci_read_config_dword(pdev, cap + PCI_VPD_DATA, &value);
+	if (ret < 0)
+		return ret;
+
+	*val = cpu_to_le32(value);
+
+	return 0;
+}
+
+static void rtl_read_mac_address_from_eeprom(struct rtl8169_private *tp,
+					     void __iomem *ioaddr)
+{
+	struct pci_dev *pdev = tp->pci_dev;
+	int vpd_cap;
+	u8 mac[8];
+	u8 cfg1;
+
+	cfg1 = RTL_R8(Config1);
+	if (!(cfg1 & VPD)) {
+		if (netif_msg_probe(tp))
+			dev_info(&pdev->dev, "VPD access disabled, enabling\n");
+		RTL_W8(Cfg9346, Cfg9346_Unlock);
+		RTL_W8(Config1, cfg1 | VPD);
+		RTL_W8(Cfg9346, Cfg9346_Lock);
+	}
+
+	vpd_cap = pci_find_capability(pdev, PCI_CAP_ID_VPD);
+	if (!vpd_cap)
+		return;
+
+	/*
+	 * MAC address is stored in EEPROM at offset 0x0e
+	 * Realtek says: "The VPD address does not have to be a DWORD-aligned
+	 * address as defined in the PCI 2.2 Specifications, but the VPD data
+	 * is always consecutive 4-byte data starting from the VPD address
+	 * specified."
+	 */
+	if (rtl_eeprom_read(pdev, vpd_cap, 0x000e, (__le32 *)&mac[0]) < 0 ||
+	    rtl_eeprom_read(pdev, vpd_cap, 0x0012, (__le32 *)&mac[4]) < 0) {
+		if (netif_msg_probe(tp)) {
+			dev_warn(&pdev->dev,
+				 "reading MAC address from EEPROM failed\n");
+		}
+		return;
+	}
+
+	if (netif_msg_probe(tp)) {
+		DECLARE_MAC_BUF(buf);
+
+		dev_info(&pdev->dev, "MAC address found in EEPROM: %s\n",
+			 print_mac(buf, mac));
+	}
+
+	/* Write MAC address */
+	rtl_rar_set(tp, mac);
+}
+
 static int __devinit
 rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -1857,6 +2136,11 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	RTL_W8(Cfg9346, Cfg9346_Unlock);
 	RTL_W8(Config1, RTL_R8(Config1) | PMEnable);
 	RTL_W8(Config5, RTL_R8(Config5) & PMEStatus);
+
+	if ((RTL_R8(Config3) & (LinkUp | MagicPacket)) ||
+	    (RTL_R8(Config5) & (UWF | BWF | MWF)))
+		tp->features |= RTL_FEATURE_WOL;
+
 	tp->features |= rtl_try_msi(pdev, ioaddr, cfg);
 	RTL_W8(Cfg9346, Cfg9346_Lock);
 
@@ -1879,7 +2163,11 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev->do_ioctl = rtl8169_ioctl;
 	}
 
-	/* Get MAC address.  FIXME: read EEPROM */
+	spin_lock_init(&tp->lock);
+
+	rtl_read_mac_address_from_eeprom(tp, ioaddr);
+
+	/* Get MAC address */
 	for (i = 0; i < MAC_ADDR_LEN; i++)
 		dev->dev_addr[i] = RTL_R8(MAC0 + i);
 	memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
@@ -1919,8 +2207,6 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->timer.data = (unsigned long) dev;
 	tp->timer.function = rtl8169_phy_timer;
 
-	spin_lock_init(&tp->lock);
-
 	rc = register_netdev(dev);
 	if (rc < 0)
 		goto err_out_msi_5;
@@ -1943,6 +2229,8 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	rtl8169_init_phy(dev, tp);
 
+	device_set_wakeup_enable(&pdev->dev, tp->features & RTL_FEATURE_WOL);
+
 out:
 	return rc;
 
@@ -2252,6 +2540,164 @@ static void rtl_ephy_init(void __iomem *ioaddr, struct ephy_info *e, int len)
 	}
 }
 
+static void rtl_disable_clock_request(struct pci_dev *pdev)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+	struct rtl8169_private *tp = netdev_priv(dev);
+	int cap = tp->pcie_cap;
+
+	if (cap) {
+		u16 ctl;
+
+		pci_read_config_word(pdev, cap + PCI_EXP_LNKCTL, &ctl);
+		ctl &= ~PCI_EXP_LNKCTL_CLKREQ_EN;
+		pci_write_config_word(pdev, cap + PCI_EXP_LNKCTL, ctl);
+	}
+}
+
+#define R8168_CPCMD_QUIRK_MASK (\
+	EnableBist | \
+	Mac_dbgo_oe | \
+	Force_half_dup | \
+	Force_rxflow_en | \
+	Force_txflow_en | \
+	Cxpl_dbg_sel | \
+	ASF | \
+	PktCntrDisable | \
+	Mac_dbgo_sel)
+
+static void rtl_hw_start_8168bb(void __iomem *ioaddr, struct pci_dev *pdev)
+{
+	RTL_W8(Config3, RTL_R8(Config3) & ~Beacon_en);
+
+	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R8168_CPCMD_QUIRK_MASK);
+
+	rtl_tx_performance_tweak(pdev,
+		(0x5 << MAX_READ_REQUEST_SHIFT) | PCI_EXP_DEVCTL_NOSNOOP_EN);
+}
+
+static void rtl_hw_start_8168bef(void __iomem *ioaddr, struct pci_dev *pdev)
+{
+	rtl_hw_start_8168bb(ioaddr, pdev);
+
+	RTL_W8(EarlyTxThres, EarlyTxThld);
+
+	RTL_W8(Config4, RTL_R8(Config4) & ~(1 << 0));
+}
+
+static void __rtl_hw_start_8168cp(void __iomem *ioaddr, struct pci_dev *pdev)
+{
+	RTL_W8(Config1, RTL_R8(Config1) | Speed_down);
+
+	RTL_W8(Config3, RTL_R8(Config3) & ~Beacon_en);
+
+	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+
+	rtl_disable_clock_request(pdev);
+
+	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R8168_CPCMD_QUIRK_MASK);
+}
+
+static void rtl_hw_start_8168cp_1(void __iomem *ioaddr, struct pci_dev *pdev)
+{
+	static struct ephy_info e_info_8168cp[] = {
+		{ 0x01, 0,	0x0001 },
+		{ 0x02, 0x0800,	0x1000 },
+		{ 0x03, 0,	0x0042 },
+		{ 0x06, 0x0080,	0x0000 },
+		{ 0x07, 0,	0x2000 }
+	};
+
+	rtl_csi_access_enable(ioaddr);
+
+	rtl_ephy_init(ioaddr, e_info_8168cp, ARRAY_SIZE(e_info_8168cp));
+
+	__rtl_hw_start_8168cp(ioaddr, pdev);
+}
+
+static void rtl_hw_start_8168cp_2(void __iomem *ioaddr, struct pci_dev *pdev)
+{
+	rtl_csi_access_enable(ioaddr);
+
+	RTL_W8(Config3, RTL_R8(Config3) & ~Beacon_en);
+
+	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+
+	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R8168_CPCMD_QUIRK_MASK);
+}
+
+static void rtl_hw_start_8168cp_3(void __iomem *ioaddr, struct pci_dev *pdev)
+{
+	rtl_csi_access_enable(ioaddr);
+
+	RTL_W8(Config3, RTL_R8(Config3) & ~Beacon_en);
+
+	/* Magic. */
+	RTL_W8(DBG_REG, 0x20);
+
+	RTL_W8(EarlyTxThres, EarlyTxThld);
+
+	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+
+	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R8168_CPCMD_QUIRK_MASK);
+}
+
+static void rtl_hw_start_8168c_1(void __iomem *ioaddr, struct pci_dev *pdev)
+{
+	static struct ephy_info e_info_8168c_1[] = {
+		{ 0x02, 0x0800,	0x1000 },
+		{ 0x03, 0,	0x0002 },
+		{ 0x06, 0x0080,	0x0000 }
+	};
+
+	rtl_csi_access_enable(ioaddr);
+
+	RTL_W8(DBG_REG, 0x06 | FIX_NAK_1 | FIX_NAK_2);
+
+	rtl_ephy_init(ioaddr, e_info_8168c_1, ARRAY_SIZE(e_info_8168c_1));
+
+	__rtl_hw_start_8168cp(ioaddr, pdev);
+}
+
+static void rtl_hw_start_8168c_2(void __iomem *ioaddr, struct pci_dev *pdev)
+{
+	static struct ephy_info e_info_8168c_2[] = {
+		{ 0x01, 0,	0x0001 },
+		{ 0x03, 0x0400,	0x0220 }
+	};
+
+	rtl_csi_access_enable(ioaddr);
+
+	rtl_ephy_init(ioaddr, e_info_8168c_2, ARRAY_SIZE(e_info_8168c_2));
+
+	__rtl_hw_start_8168cp(ioaddr, pdev);
+}
+
+static void rtl_hw_start_8168c_3(void __iomem *ioaddr, struct pci_dev *pdev)
+{
+	rtl_hw_start_8168c_2(ioaddr, pdev);
+}
+
+static void rtl_hw_start_8168c_4(void __iomem *ioaddr, struct pci_dev *pdev)
+{
+	rtl_csi_access_enable(ioaddr);
+
+	__rtl_hw_start_8168cp(ioaddr, pdev);
+}
+
+static void rtl_hw_start_8168d(void __iomem *ioaddr, struct pci_dev *pdev)
+{
+	rtl_csi_access_enable(ioaddr);
+
+	rtl_disable_clock_request(pdev);
+
+	RTL_W8(EarlyTxThres, EarlyTxThld);
+
+	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+
+	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R8168_CPCMD_QUIRK_MASK);
+}
+
 static void rtl_hw_start_8168(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
@@ -2264,14 +2710,10 @@ static void rtl_hw_start_8168(struct net_device *dev)
 
 	rtl_set_rx_max_size(ioaddr);
 
-	rtl_set_rx_tx_config_registers(tp);
-
 	tp->cp_cmd |= RTL_R16(CPlusCmd) | PktCntrDisable | INTT_1;
 
 	RTL_W16(CPlusCmd, tp->cp_cmd);
 
-	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
-
 	RTL_W16(IntrMitigate, 0x5151);
 
 	/* Work around for RxFIFO overflow. */
@@ -2282,14 +2724,65 @@ static void rtl_hw_start_8168(struct net_device *dev)
 
 	rtl_set_rx_tx_desc_registers(tp, ioaddr);
 
-	RTL_W8(Cfg9346, Cfg9346_Lock);
+	rtl_set_rx_mode(dev);
+
+	RTL_W32(TxConfig, (TX_DMA_BURST << TxDMAShift) |
+		(InterFrameGap << TxInterFrameGapShift));
 
 	RTL_R8(IntrMask);
 
-	rtl_set_rx_mode(dev);
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_11:
+		rtl_hw_start_8168bb(ioaddr, pdev);
+	break;
+
+	case RTL_GIGA_MAC_VER_12:
+	case RTL_GIGA_MAC_VER_17:
+		rtl_hw_start_8168bef(ioaddr, pdev);
+	break;
+
+	case RTL_GIGA_MAC_VER_18:
+		rtl_hw_start_8168cp_1(ioaddr, pdev);
+	break;
+
+	case RTL_GIGA_MAC_VER_19:
+		rtl_hw_start_8168c_1(ioaddr, pdev);
+	break;
+
+	case RTL_GIGA_MAC_VER_20:
+		rtl_hw_start_8168c_2(ioaddr, pdev);
+	break;
+
+	case RTL_GIGA_MAC_VER_21:
+		rtl_hw_start_8168c_3(ioaddr, pdev);
+	break;
+
+	case RTL_GIGA_MAC_VER_22:
+		rtl_hw_start_8168c_4(ioaddr, pdev);
+	break;
+
+	case RTL_GIGA_MAC_VER_23:
+		rtl_hw_start_8168cp_2(ioaddr, pdev);
+	break;
+
+	case RTL_GIGA_MAC_VER_24:
+		rtl_hw_start_8168cp_3(ioaddr, pdev);
+	break;
+
+	case RTL_GIGA_MAC_VER_25:
+		rtl_hw_start_8168d(ioaddr, pdev);
+	break;
+
+	default:
+		printk(KERN_ERR PFX "%s: unknown chipset (mac_version = %d).\n",
+			dev->name, tp->mac_version);
+	break;
+	}
 
 	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
 
+	RTL_W8(Cfg9346, Cfg9346_Lock);
+
 	RTL_W16(MultiIntr, RTL_R16(MultiIntr) & 0xF000);
 
 	RTL_W16(IntrMask, tp->intr_event);
@@ -3393,6 +3886,11 @@ out:
 	return 0;
 }
 
+static void rtl_shutdown(struct pci_dev *pdev)
+{
+	rtl8169_suspend(pdev, PMSG_SUSPEND);
+}
+
 #endif /* CONFIG_PM */
 
 static struct pci_driver rtl8169_pci_driver = {
@@ -3403,6 +3901,7 @@ static struct pci_driver rtl8169_pci_driver = {
 #ifdef CONFIG_PM
 	.suspend	= rtl8169_suspend,
 	.resume		= rtl8169_resume,
+	.shutdown	= rtl_shutdown,
 #endif
 };
 
-- 
Ueimor
