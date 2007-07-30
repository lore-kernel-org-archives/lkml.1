Return-Path: <linux-kernel-owner+w=401wt.eu-S938169AbXG3GbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938169AbXG3GbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 02:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938709AbXG3GaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 02:30:19 -0400
Received: from rex.snapgear.com ([203.143.235.140]:44889 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S938323AbXG3GaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 02:30:18 -0400
Date: Mon, 30 Jul 2007 16:29:29 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707300629.l6U6TTbe020369@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] setup and detect 2nd phy on MCF5275 in FEC driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Cruse <mcruse@definium.net>

Added code to recognize the second interface on M5275 boards.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur linux-2.6.23-rc1-git2/drivers/net/fec.c linux/drivers/net/fec.c
--- linux-2.6.23-rc1-git2/drivers/net/fec.c	2007-07-26 10:46:14.000000000 +1000
+++ linux/drivers/net/fec.c	2007-07-26 23:09:23.000000000 +1000
@@ -1426,6 +1427,29 @@
 		*gpio_pehlpar = 0xc0;
 	}
 #endif
+
+#if defined(CONFIG_M527x)
+	/* Set up gpio outputs for MII lines */
+	{
+		volatile u8 *gpio_par_fec;
+		volatile u16 *gpio_par_feci2c;
+
+		gpio_par_feci2c = (volatile u16 *)(MCF_IPSBAR + 0x100082);
+		/* Set up gpio outputs for FEC0 MII lines */
+		gpio_par_fec = (volatile u8 *)(MCF_IPSBAR + 0x100078);
+
+		*gpio_par_feci2c |= 0x0f00;
+		*gpio_par_fec |= 0xc0;
+
+#if defined(CONFIG_FEC2)
+		/* Set up gpio outputs for FEC1 MII lines */
+		gpio_par_fec = (volatile u8 *)(MCF_IPSBAR + 0x100079);
+
+		*gpio_par_feci2c |= 0x00a0;
+		*gpio_par_fec |= 0xc0;
+#endif /* CONFIG_FEC2 */
+	}
+#endif /* CONFIG_M527x */
 }
 
 static void __inline__ fec_set_mii(struct net_device *dev, struct fec_enet_private *fep)
