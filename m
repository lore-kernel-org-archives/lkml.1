Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZBGEPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZBGEPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 23:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZBGEPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 23:15:31 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:48876 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbZBGEPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 23:15:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DjpSWRlePa6lhLlTX9CpT/eJMiam4R6grep6NO9YW86tHMpAtaGWHWfS/nmRhdHxZM
         f2r3Bobvd7h5433CxhZfkJhctGHMx/MpyPJtArbqkwxSx1rqQyJtOr3MZK2rF9B8v6j+
         T4f/FS7NVJH4ES1w8kARVehq+DiyckDRVD4s4=
MIME-Version: 1.0
Date: Sat, 7 Feb 2009 13:15:25 +0900
Message-ID: <4e1455be0902062015i1ff94b28p93588e61b7860618@mail.gmail.com>
Subject: [PATCH] OMAP3 GPIO: Fix getting the value of the GPIO output pin
From: Joonyoung Shim <dofmind@gmail.com>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the GPIO pin is output, must read the value from OMAP24XX_GPIO_DATAOUT
register in __omap_get_gpio_datain().

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index f856a90..296773a 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -428,7 +428,11 @@ static int __omap_get_gpio_datain(int gpio)
 #endif
 #if defined(CONFIG_ARCH_OMAP24XX) || defined(CONFIG_ARCH_OMAP34XX)
 	case METHOD_GPIO_24XX:
-		reg += OMAP24XX_GPIO_DATAIN;
+		if (__raw_readl(reg + OMAP24XX_GPIO_OE)
+					& (1 << get_gpio_index(gpio)))
+			reg += OMAP24XX_GPIO_DATAIN;
+		else
+			reg += OMAP24XX_GPIO_DATAOUT;
 		break;
 #endif
 	default:
