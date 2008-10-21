Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYJUMlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYJUMlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbYJUMkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:40:51 -0400
Received: from nonada.if.usp.br ([143.107.131.169]:46858 "EHLO
	nonada.if.usp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbYJUMku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:40:50 -0400
From: Joao Luis Meloni Assirati <assirati@nonada.if.usp.br>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.27.2: NETDEV WATCHDOG: eth0 (r8169): transmit timed out
Date: Tue, 21 Oct 2008 10:40:38 -0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200810201251.51836.assirati@nonada.if.usp.br> <20081020201306.GA19486@electric-eye.fr.zoreil.com>
In-Reply-To: <20081020201306.GA19486@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_G3c/IfNQ+bjdsFK"
Message-Id: <200810211040.38893.assirati@nonada.if.usp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_G3c/IfNQ+bjdsFK
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Fran=E7ois,

I tried to apply your patches (against 2.6.27.2) but they failed. I am send=
ing=20
attached the rejects.

My previous report was a bit inaccurate. The network card failure are not=20
constant, but random (something like 20% of the boots). Therefore It may be=
=20
the case that this network card does not an updated driver because of this=
=20
and because I disabled CONFIG_IRQBALANCE and the problem seems to be fixed=
=20
now. (Does CONFIG_IRQBALANCE make sense with hyperthreading instead of a re=
al=20
smp?) I will continue to test and report if something happens. If I can hel=
p=20
you with further testing, please contact me.

Best regards,
Jo=E3o Luis.

On Monday 20 October 2008 18:13:06 Francois Romieu wrote:
> Joao Luis Meloni Assirati <assirati@nonada.if.usp.br> :
> [...]
>
> > I am having some kernel messages in my Acer Aspire One under Linux
> > 2.6.27.2, followed by network-manager crashes. Below are the messages a=
nd
> > my kernel config.
> >
> > Please, CC me as I am not subscribed to the list.
>
> I am not completely sure but it could be that your laptop includes
> a kind of 8102 ethernet chipset which needs a post 2.6.27 kernel.
>
> Can you try current 2.6.27 git kernel + the patches at:
>
> http://userweb.kernel.org/~romieu/r8169/2.6.27-git8/20081020
>
> A dmesg of the patched kernel will be welcome.



--Boundary-00=_G3c/IfNQ+bjdsFK
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="r8169.c.rej"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="r8169.c.rej"

*************** static void rtl_init_mac_address(struct rtl8169_private *tp,
*** 1943,1951 ****
  				 void __iomem *ioaddr)
  {
  	struct pci_dev *pdev = tp->pci_dev;
- 	u8 cfg1;
  	int vpd_cap;
  	u8 mac[8];
  
  	cfg1 = RTL_R8(Config1);
  	if (!(cfg1  & VPD)) {
--- 1947,1956 ----
  				 void __iomem *ioaddr)
  {
  	struct pci_dev *pdev = tp->pci_dev;
  	int vpd_cap;
+ 	__le32 sig;
  	u8 mac[8];
+ 	u8 cfg1;
  
  	cfg1 = RTL_R8(Config1);
  	if (!(cfg1  & VPD)) {
*************** static void rtl_init_mac_address(struct rtl8169_private *tp,
*** 1960,1966 ****
  	if (!vpd_cap)
  		return;
  
- 	/* MAC address is stored in EEPROM at offset 0x0e
  	 * Realtek says: "The VPD address does not have to be a DWORD-aligned
  	 * address as defined in the PCI 2.2 Specifications, but the VPD data
  	 * is always consecutive 4-byte data starting from the VPD address
--- 1965,1980 ----
  	if (!vpd_cap)
  		return;
  
+ 	if (rtl_eeprom_read(pdev, vpd_cap, RTL_EEPROM_SIG_ADDR, &sig) < 0)
+ 		return;
+ 
+ 	if ((sig & RTL_EEPROM_SIG_MASK) != RTL_EEPROM_SIG) {
+ 		dev_info(&pdev->dev, "Missing EEPROM signature: %08x\n", sig);
+ 		return;
+ 	}
+ 
+ 	/*
+ 	 * MAC address is stored in EEPROM at offset 0x0e
  	 * Realtek says: "The VPD address does not have to be a DWORD-aligned
  	 * address as defined in the PCI 2.2 Specifications, but the VPD data
  	 * is always consecutive 4-byte data starting from the VPD address
*************** static void rtl_init_mac_address(struct rtl8169_private *tp,
*** 1982,1989 ****
  			 print_mac(buf, mac));
  	}
  
- 	/* Write MAC address */
- 	rtl_rar_set(tp, mac);
  }
  
  static int __devinit
--- 1996,2003 ----
  			 print_mac(buf, mac));
  	}
  
+ 	if (is_valid_ether_addr(mac))
+ 		rtl_rar_set(tp, mac);
  }
  
  static int __devinit

--Boundary-00=_G3c/IfNQ+bjdsFK--
