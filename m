Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYJNTdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYJNTdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 15:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYJNTdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 15:33:33 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:32770 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbYJNTdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 15:33:33 -0400
Date: Tue, 14 Oct 2008 21:33:16 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?unknown-8bit?B?Si5BLiBNYWdhbGzDs24=?= <jamagallon@ono.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
Message-ID: <20081014193316.GA8223@electric-eye.fr.zoreil.com>
References: <20081014010202.71d13eaf@werewolf.home> <20081013.161228.74135367.davem@davemloft.net> <20081014012429.3f2924e3@werewolf.home> <20081014023003.07b6d745@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081014023003.07b6d745@werewolf.home>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón <jamagallon@ono.com> :
[...]
> Oct 14 02:27:45 one kernel: r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> Oct 14 02:27:45 one kernel: r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> Oct 14 02:27:45 one kernel: r8169 0000:02:00.0: setting latency timer to 64
> Oct 14 02:27:45 one kernel: eth0: RTL8102e at 0xdfffe000, 00:00:00:00:00:00, XID 24a00000 IRQ 219

The MAC address does not look sane. Does the revert below cure it ?

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index c821da2..5b8f8ba 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1911,74 +1911,6 @@ static void rtl_disable_msi(struct pci_dev *pdev, struct rtl8169_private *tp)
 	}
 }
 
-static int rtl_eeprom_read(struct pci_dev *pdev, int cap, int addr, __le32 *val)
-{
-	int ret, count = 100;
-	u16 status = 0;
-	u32 value;
-
-	ret = pci_write_config_word(pdev, cap + PCI_VPD_ADDR, addr);
-	if (ret < 0)
-		return ret;
-
-	do {
-		udelay(10);
-		ret = pci_read_config_word(pdev, cap + PCI_VPD_ADDR, &status);
-		if (ret < 0)
-			return ret;
-	} while (!(status & PCI_VPD_ADDR_F) && --count);
-
-	if (!(status & PCI_VPD_ADDR_F))
-		return -ETIMEDOUT;
-
-	ret = pci_read_config_dword(pdev, cap + PCI_VPD_DATA, &value);
-	if (ret < 0)
-		return ret;
-
-	*val = cpu_to_le32(value);
-
-	return 0;
-}
-
-static void rtl_init_mac_address(struct rtl8169_private *tp,
-				 void __iomem *ioaddr)
-{
-	struct pci_dev *pdev = tp->pci_dev;
-	u8 cfg1;
-	int vpd_cap;
-	u8 mac[8];
-	DECLARE_MAC_BUF(buf);
-
-	cfg1 = RTL_R8(Config1);
-	if (!(cfg1  & VPD)) {
-		dprintk("VPD access not enabled, enabling\n");
-		RTL_W8(Cfg9346, Cfg9346_Unlock);
-		RTL_W8(Config1, cfg1 | VPD);
-		RTL_W8(Cfg9346, Cfg9346_Lock);
-	}
-
-	vpd_cap = pci_find_capability(pdev, PCI_CAP_ID_VPD);
-	if (!vpd_cap)
-		return;
-
-	/* MAC address is stored in EEPROM at offset 0x0e
-	 * Realtek says: "The VPD address does not have to be a DWORD-aligned
-	 * address as defined in the PCI 2.2 Specifications, but the VPD data
-	 * is always consecutive 4-byte data starting from the VPD address
-	 * specified."
-	 */
-	if (rtl_eeprom_read(pdev, vpd_cap, 0x000e, (__le32*)&mac[0]) < 0 ||
-	    rtl_eeprom_read(pdev, vpd_cap, 0x0012, (__le32*)&mac[4]) < 0) {
-		dprintk("Reading MAC address from EEPROM failed\n");
-		return;
-	}
-
-	dprintk("MAC address found in EEPROM: %s\n", print_mac(buf, mac));
-
-	/* Write MAC address */
-	rtl_rar_set(tp, mac);
-}
-
 static int __devinit
 rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -2156,8 +2088,6 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	tp->mmio_addr = ioaddr;
 
-	rtl_init_mac_address(tp, ioaddr);
-
 	/* Get MAC address */
 	for (i = 0; i < MAC_ADDR_LEN; i++)
 		dev->dev_addr[i] = RTL_R8(MAC0 + i);
