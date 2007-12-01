Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbXLANtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbXLANtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 08:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXLANs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 08:48:56 -0500
Received: from mail0.scram.de ([78.47.204.202]:34868 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbXLANsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 08:48:55 -0500
X-Spam-Score: -3.906
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <47516646.9000803@scram.de>
Date: Sat, 01 Dec 2007 14:48:54 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Jeff Garzik <jeff@garzik.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 1/3] [NET] phy/fixed.c: rework to not duplicate PHY layer
 functionality
References: <20071126142906.19642.45540.stgit@localhost.localdomain>
In-Reply-To: <20071126142906.19642.45540.stgit@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

> With that patch fixed.c now fully emulates MDIO bus, thus no need
> to duplicate PHY layer functionality. That, in turn, drastically
> simplifies the code, and drops down line count.
>
> As an additional bonus, now there is no need to register MDIO bus
> for each PHY, all emulated PHYs placed on the platform fixed MDIO bus.
> There is also no more need to pre-allocate PHYs via .config option,
> this is all now handled dynamically.
>
> p.s. Don't even try to understand patch content! Better: apply patch
> and look into resulting drivers/net/phy/fixed.c.
>   
If i understand your code correctly, you seem to rely on the fact 
that fixed_phy_add() is called before the fixed MDIO bus is scanned for 
devices. How is this supposed to work for modules or for the 
PPC_CPM_NEW_BINDING mode where the device tree is no longer scanned 
during fs_soc initialization but during device initialization?

I tried to add fixed-phy support to fs_enet, but the fixed phy is not 
found this way.

--- a/drivers/net/fs_enet/fs_enet-main.c
+++ b/drivers/net/fs_enet/fs_enet-main.c
@@ -36,6 +36,7 @@
 #include <linux/fs.h>
 #include <linux/platform_device.h>
 #include <linux/phy.h>
+#include <linux/phy_fixed.h>
 
 #include <linux/vmalloc.h>
 #include <asm/pgtable.h>
@@ -1174,8 +1175,24 @@ static int __devinit find_phy(struct device_node *np,
        struct device_node *phynode, *mdionode;
        struct resource res;
        int ret = 0, len;
+       const u32 *data;
+       struct fixed_phy_status status = {};
+
+       data  = of_get_property(np, "fixed-link", NULL);
+       if (data) {
+               status.link = 1;
+               status.duplex = data[1];
+               status.speed  = data[2];
+
+               ret = fixed_phy_add(PHY_POLL, data[0], &status);
+               if (ret)
+                       return ret;
+
+               snprintf(fpi->bus_id, 16, PHY_ID_FMT, 0, *data);
+               return 0;
+       }
 
-       const u32 *data = of_get_property(np, "phy-handle", &len);
+       data = of_get_property(np, "phy-handle", &len);
        if (!data || len != 4)
                return -EINVAL;

Thanks,
Jochen
