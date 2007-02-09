Return-Path: <linux-kernel-owner+w=401wt.eu-S1945958AbXBIAzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945958AbXBIAzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945961AbXBIAzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:55:45 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51174 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945958AbXBIAzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:55:43 -0500
Message-ID: <45CBC689.2020606@garzik.org>
Date: Thu, 08 Feb 2007 19:55:37 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Edward Hsu <edward_hsu@realtek.com>
CC: romieu@fr.zoreil.com, linux-kernel@vger.kernel.org, hiwu@realtek.com.tw
Subject: Re: [PATCH 2.6.20] r8169.c: support RTL8169SC/8110SC
References: <000301c74b64$a2eaad10$083415ac@realtek.com.tw>
In-Reply-To: <000301c74b64$a2eaad10$083415ac@realtek.com.tw>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Edward Hsu wrote:
> This patch is for /driver/net/r8169.c to support RTL8169SC/8110SC,
> which is a new Realtek Gigabit PCI Ethernet Controller. RTL8110SC's PCI DID
> is 0x8167, while RTL8110S and RTL8110SB share 0x8169.
> 
> Signed-off-by: Edward Hsu <edward_hsu@realtek.com>
> ------------------------------------------------------------------------------
> 
> --- ./drivers/net/r8169_n.c 2007-02-09 01:12:43.000000000 +0800
> +++ ./drivers/net/r8169.c 2007-02-05 02:44:54.000000000 +0800
> @@ -1,29 +1,4 @@
>  /*
> -################################################################################
> -#
> -# Copyright(c) 1999 - 2007 Realtek Semiconductor Corp. All rights reserved.
> -#
> -# This program is free software; you can redistribute it and/or modify it
> -# under the terms of the GNU General Public License as published by the 
> Free

Unfortunately this patch has been created backwards:
	diff -u file.new file.old
when it should be created from
	diff -u ./drivers/net/r8169.c.old \
		./drivers/net/r8169.c

Additionally, your patch was word-wrapped by your email program, which 
prevents software from importing the patch into a kernel source tree.


>  enum RTL8169_registers {
> - MAC0 = 0x00,  /* Ethernet hardware address. */
> - MAC4 = 0x04,
> - MAR0 = 0x08,  /* Multicast filter. */
> + MAC0 = 0,  /* Ethernet hardware address. */
> + MAR0 = 8,  /* Multicast filter. */
>   CounterAddrLow = 0x10,
>   CounterAddrHigh = 0x14,
>   TxDescStartAddrLow = 0x20,

Let's keep the existing style of code.  The other MAC registers are 
listed in the "0xnn" hexidecimal style.


> @@ -282,7 +260,6 @@ enum RTL8169_registers {
>   TBI_ANAR = 0x68,
>   TBI_LPAR = 0x6A,
>   PHYstatus = 0x6C,
> - Offset_7Ch = 0x7C,
>   RxMaxSize = 0xDA,
>   CPlusCmd = 0xE0,
>   IntrMitigate = 0xE2,

Is there a better name for this register?  :)


> @@ -476,24 +456,14 @@ struct rtl8169_private {
>   void (*phy_reset_enable)(void __iomem *);
>   unsigned int (*phy_reset_pending)(void __iomem *);
>   unsigned int (*link_ok)(void __iomem *);
> -#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
> - struct work_struct task;
> -#else
>   struct delayed_work task;
> -#endif
>   unsigned wol_enabled : 1;
>  };
> 
>  MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
>  MODULE_DESCRIPTION("RealTek RTL-8169 Gigabit Ethernet driver");
> -
> -module_param_array(speed, int, &num_speed, 0);
> -MODULE_PARM_DESC(speed, "force phy operation. Deprecated by ethtool (8).");
> -module_param_array(duplex, int, &num_duplex, 0);
> -MODULE_PARM_DESC(duplex, "force phy operation. Deprecated by ethtool 
> (8).");
> -module_param_array(autoneg, int, &num_autoneg, 0);
> -MODULE_PARM_DESC(autoneg, "force phy operation. Deprecated by ethtool 
> (8).");
> -
> +module_param_array(media, int, &num_media, 0);
> +MODULE_PARM_DESC(media, "force phy operation. Deprecated by ethtool (8).");
>  module_param(rx_copybreak, int, 0);
>  MODULE_PARM_DESC(rx_copybreak, "Copy breakpoint for 
> copy-only-tiny-frames");
>  module_param(use_dac, int, 0);
> @@ -505,11 +475,7 @@ MODULE_VERSION(RTL8169_VERSION);
> 
>  static int rtl8169_open(struct net_device *dev);
>  static int rtl8169_start_xmit(struct sk_buff *skb, struct net_device *dev);
> -#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
> -static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance, struct 
> pt_regs *regs);
> -#else
>  static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance);
> -#endif
>  static int rtl8169_init_ring(struct net_device *dev);
>  static void rtl8169_hw_start(struct net_device *dev);
>  static int rtl8169_close(struct net_device *dev);

While we understand that RealTek may need to support multiple kernel 
versions, drivers in the official kernel.org kernel typically do not 
contain compatibility code for older kernel versions.


> + if ((tp->mac_version == RTL_GIGA_MAC_VER_11) ||
> +     (tp->mac_version == RTL_GIGA_MAC_VER_12) ||
> +     (tp->mac_version == RTL_GIGA_MAC_VER_13) ||
> +     (tp->mac_version == RTL_GIGA_MAC_VER_14) ||
> +     (tp->mac_version == RTL_GIGA_MAC_VER_15)) {
> +  mc_filter[0] = 0xffffffff;
> +  mc_filter[1] = 0xffffffff;
> + }

Can you help us understand this code change?  This change appears to 
disable multicast on these MAC versions.

	Jeff


