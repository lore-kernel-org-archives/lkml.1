Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbYJNUEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbYJNUEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYJNUEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:04:09 -0400
Received: from smtp3.ono.com ([62.42.230.176]:37228 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752850AbYJNUEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:04:08 -0400
Date: Tue, 14 Oct 2008 22:03:57 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
Message-ID: <20081014220357.64266be8@werewolf.home>
In-Reply-To: <20081014193316.GA8223@electric-eye.fr.zoreil.com>
References: <20081014010202.71d13eaf@werewolf.home>
	<20081013.161228.74135367.davem@davemloft.net>
	<20081014012429.3f2924e3@werewolf.home>
	<20081014023003.07b6d745@werewolf.home>
	<20081014193316.GA8223@electric-eye.fr.zoreil.com>
X-Mailer: Claws Mail 3.6.1cvs2 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 21:33:16 +0200, Francois Romieu <romieu@fr.zoreil.com> wrote:

> J.A. Magallón <jamagallon@ono.com> :
> [...]
> > Oct 14 02:27:45 one kernel: r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> > Oct 14 02:27:45 one kernel: r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> > Oct 14 02:27:45 one kernel: r8169 0000:02:00.0: setting latency timer to 64
> > Oct 14 02:27:45 one kernel: eth0: RTL8102e at 0xdfffe000, 00:00:00:00:00:00, XID 24a00000 IRQ 219
> 
> The MAC address does not look sane. Does the revert below cure it ?
> 
> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index c821da2..5b8f8ba 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@ -1911,74 +1911,6 @@ static void rtl_disable_msi(struct pci_dev *pdev, struct rtl8169_private *tp)
>  	}
>  }
>  
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
> -}
> -
> -static void rtl_init_mac_address(struct rtl8169_private *tp,
> -				 void __iomem *ioaddr)
> -{
> -	struct pci_dev *pdev = tp->pci_dev;
> -	u8 cfg1;
> -	int vpd_cap;
> -	u8 mac[8];
> -	DECLARE_MAC_BUF(buf);
> -
> -	cfg1 = RTL_R8(Config1);
> -	if (!(cfg1  & VPD)) {
> -		dprintk("VPD access not enabled, enabling\n");
> -		RTL_W8(Cfg9346, Cfg9346_Unlock);
> -		RTL_W8(Config1, cfg1 | VPD);
> -		RTL_W8(Cfg9346, Cfg9346_Lock);
> -	}
> -
> -	vpd_cap = pci_find_capability(pdev, PCI_CAP_ID_VPD);
> -	if (!vpd_cap)
> -		return;
> -
> -	/* MAC address is stored in EEPROM at offset 0x0e
> -	 * Realtek says: "The VPD address does not have to be a DWORD-aligned
> -	 * address as defined in the PCI 2.2 Specifications, but the VPD data
> -	 * is always consecutive 4-byte data starting from the VPD address
> -	 * specified."
> -	 */
> -	if (rtl_eeprom_read(pdev, vpd_cap, 0x000e, (__le32*)&mac[0]) < 0 ||
> -	    rtl_eeprom_read(pdev, vpd_cap, 0x0012, (__le32*)&mac[4]) < 0) {
> -		dprintk("Reading MAC address from EEPROM failed\n");
> -		return;
> -	}
> -
> -	dprintk("MAC address found in EEPROM: %s\n", print_mac(buf, mac));
> -
> -	/* Write MAC address */
> -	rtl_rar_set(tp, mac);
> -}
> -
>  static int __devinit
>  rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
> @@ -2156,8 +2088,6 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	tp->mmio_addr = ioaddr;
>  
> -	rtl_init_mac_address(tp, ioaddr);
> -
>  	/* Get MAC address */
>  	for (i = 0; i < MAC_ADDR_LEN; i++)
>  		dev->dev_addr[i] = RTL_R8(MAC0 + i);

Yes. I have updated to git4, and it works with this patch.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
