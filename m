Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYJ0WaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYJ0WaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYJ0WaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:30:07 -0400
Received: from khc.piap.pl ([195.187.100.11]:56904 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbYJ0WaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:30:02 -0400
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] r8169: revert "read MAC address from EEPROM on init"
References: <20081026160249.GA25443@electric-eye.fr.zoreil.com>
In-Reply-To: <20081026160249.GA25443@electric-eye.fr.zoreil.com> (Francois Romieu's message of "Sun\, 26 Oct 2008 17\:02\:49 +0100")
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 27 Oct 2008 23:29:59 +0100
Message-ID: <m3mygplli0.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Reposting to lkml only, Gnus likes to eat quoting from email addresses
under specific circumstances and then vger doesn't pass them through]

Francois Romieu <romieu@fr.zoreil.com> writes:

> -static int rtl_eeprom_read(struct pci_dev *pdev, int cap, int addr, __le32 *val)
> -{
> -	int ret, count = 100;
> -	u16 status = 0;
> -	u32 value;
> -
> -	ret = pci_write_config_word(pdev, cap + PCI_VPD_ADDR, addr);
> -	if (ret < 0)
> -		return ret;
> -
> -	do {
> -		udelay(10);
> -		ret = pci_read_config_word(pdev, cap + PCI_VPD_ADDR, &status);
> -		if (ret < 0)
> -			return ret;
> -	} while (!(status & PCI_VPD_ADDR_F) && --count);
> -
> -	if (!(status & PCI_VPD_ADDR_F))
> -		return -ETIMEDOUT;
> -
> -	ret = pci_read_config_dword(pdev, cap + PCI_VPD_DATA, &value);
> -	if (ret < 0)
> -		return ret;
> -
> -	*val = cpu_to_le32(value);
> -
> -	return 0;

Ahh, just PCI VPD.

IMHO the above shouldn't hurt anyone, in theory. You only write to
VPD_ADDR, and to change actual VPD data (i.e., EEPROM), you need to
write to VPD_DATA.

Anyone should be allowed to do that even for unknown PCI devices
without a problem.

> -static void rtl_init_mac_address(struct rtl8169_private *tp,

> -	if (!(cfg1  & VPD)) {
> -		if (netif_msg_probe(tp))
> -			dev_info(&pdev->dev, "VPD access disabled, enabling\n");
> -		RTL_W8(Cfg9346, Cfg9346_Unlock);
> -		RTL_W8(Config1, cfg1 | VPD);
> -		RTL_W8(Cfg9346, Cfg9346_Lock);

Now I wonder what do they say the above does exactly.
Unfortunately the docs don't seem to be public.

> -	 * MAC address is stored in EEPROM at offset 0x0e
> -	 * Realtek says: "The VPD address does not have to be a DWORD-aligned
> -	 * address as defined in the PCI 2.2 Specifications, but the VPD data
> -	 * is always consecutive 4-byte data starting from the VPD address
> -	 * specified."

Nice.

> -	if (netif_msg_probe(tp)) {
> -		DECLARE_MAC_BUF(buf);
> -
> -		dev_info(&pdev->dev, "MAC address found in EEPROM: %s\n",
> -			 print_mac(buf, mac));
> -	}
> -
> -	if (is_valid_ether_addr(mac))
> -		rtl_rar_set(tp, mac);
> -}

No RTL_W8(Config1, cfg1 | ~VPD) to disable (perhaps R/W) access?

Though obviously first reading a good address from the EEPROM and then
erasing first 32 bits is a different story. I wonder if changing the
MAC address by hand works (using ifconfig, to arbitrary address).

-- 
Krzysztof Halasa
