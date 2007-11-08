Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbXKHOQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbXKHOQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 09:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbXKHOQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 09:16:14 -0500
Received: from rtr.ca ([76.10.145.34]:2209 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbXKHOQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 09:16:13 -0500
Message-ID: <47331A2C.6050005@rtr.ca>
Date: Thu, 08 Nov 2007 09:16:12 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] r8169 fix regression on ASUS motherboards (updated again)
References: <4731E2AB.5080703@rtr.ca> <4731FDB7.8010505@rtr.ca> <20071107220455.GA15367@electric-eye.fr.zoreil.com> <47323A69.5050206@rtr.ca> <47323B6B.9000909@rtr.ca> <47324843.4050602@rtr.ca> <20071108002112.GD15367@electric-eye.fr.zoreil.com>
In-Reply-To: <20071108002112.GD15367@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
>
> Ok, I have pushed the patch below for Jeff to pull at korg.
> 
>>From 1dd7681bc2ff171341ea5cae957f8ecb5c0c102e Mon Sep 17 00:00:00 2001
> From: Mark Lord <mlord@pobox.com>
> Date: Thu, 8 Nov 2007 01:03:04 +0100
> Subject: [PATCH] r8169: revert 7da97ec96a0934319c7fbedd3d38baf533e20640 (partly)
> 
> Various symptoms depending on the .config options:
> - the card stops working after some (short) time
> - the card does not work at all
> - the card disappears (nothing in lspci/dmesg)
> 
> A real power-off is needed to recover the card.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
> ---
>  drivers/net/r8169.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index 9dbab3f..a37cf82 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@ -1328,6 +1328,7 @@ static void rtl_hw_phy_config(struct net_device *dev)
>  		break;
>  	case RTL_GIGA_MAC_VER_11:
>  	case RTL_GIGA_MAC_VER_12:
> +		break;
>  	case RTL_GIGA_MAC_VER_17:
>  		rtl8168b_hw_phy_config(ioaddr);
>  		break;
..

Stop the presses:  Another person has now reported back to me.
This guy has the VER_17 chip inside a notebook, and the same problem.

So the unified fix for all of these is to just get rid of rtl8168b_hw_phy_config(),
as that code is all that is really different from 2.6.23 (where all is okay).

Updated patch below.

* * * * *

Fix r8169B regression on ASUS motherboards (and MSI, and..)

Third/final iteration.
This replaces the earlier versions of this patch.
This one fixes *all* versions of r6169 *B* variant,
restoring the init code back to what it was in 2.6.23.

The r8169 ethernet driver worked fine in 2.6.23, but fails
in 2.6.24-rc* for the onboard ethernet of some ASUS (MAC_VER_11)
and MSI (MAC_VER_12) motherboards, and also for some notebooks
(MAC_VER_17) that use this chip.

Various symptoms depending on the .config options:
- the card stops working after some (short) time
- the card does not work at all
- the card disappears (nothing in lspci/dmesg)

A real power-off is needed to recover the card.

This patch fixes it again.

Signed-off-by: Mark Lord <mlord@pobox.com>

--- linux-2.6.24-rc2/drivers/net/r8169.c	2007-11-06 22:56:24.000000000 -0500
+++ linux/drivers/net/r8169.c	2007-11-08 09:05:08.000000000 -0500
@@ -1247,13 +1247,6 @@
 }
 static void rtl8168b_hw_phy_config(void __iomem *ioaddr)
 {
-	struct phy_reg phy_reg_init[] = {
-		{ 0x1f, 0x0000 },
-		{ 0x10, 0xf41b },
-		{ 0x1f, 0x0000 }
-	};
-
-	rtl_phy_write(ioaddr, phy_reg_init, ARRAY_SIZE(phy_reg_init));
 }
 
 static void rtl8168cp_hw_phy_config(void __iomem *ioaddr)
