Return-Path: <linux-kernel-owner+w=401wt.eu-S1765535AbXFRVFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765535AbXFRVFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762163AbXFRVDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:03:47 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:52768 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759940AbXFRVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:03:44 -0400
Message-Id: <20070618210342.119095947@fluff.org.uk>
References: <20070618205620.284044146@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 21:56:24 +0100
From: ben@fluff.org.uk
To: ben@fluff.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sm5xx-devel@lists.berlios.de
Cc: Ben Dooks <ben-linux@fluff.org>
Subject: [patch #2 4/6] SM501: Clock updates and checks
Content-Disposition: inline; filename=simtec-drivers-mfd-sm501-clockupdate.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that the M1XCLK and MCLK are sourced from
the same PLL (and refuse to bind the driver if they
are not).

Update the PCI to safe initialisation values, as 72MHz
is the maximum clock for 33MHz PCI bus mastering.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.21-quilt8/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.21-quilt8.orig/drivers/mfd/sm501.c	2007-06-07 12:42:22.000000000 +0100
+++ linux-2.6.21-quilt8/drivers/mfd/sm501.c	2007-06-07 13:01:02.000000000 +0100
@@ -845,6 +845,24 @@ static void sm501_init_regs(struct sm501
 		dev_info(sm->dev, "setting MCLK to %ld\n", init->mclk);
 		sm501_set_clock(sm->dev, SM501_CLOCK_MCLK, init->mclk);
 	}
+
+}
+
+/* Check the PLL sources for the M1CLK and M1XCLK
+ *
+ * If the M1CLK and M1XCLKs are not sourced from the same PLL, then
+ * there is a risk (see errata AB-5) that the SM501 will cease proper
+ * function. If this happens, then it is likely the SM501 will
+ * hang the system.
+*/
+
+static int sm501_check_clocks(struct sm501_devdata *sm)
+{
+	unsigned long pwrmode = readl(sm->regs + SM501_CURRENT_CLOCK);
+	unsigned long msrc = (pwrmode & SM501_POWERMODE_M_SRC);
+	unsigned long m1src = (pwrmode & SM501_POWERMODE_M1_SRC);
+
+	return ((msrc == 0 && m1src != 0) || (msrc != 0 && m1src == 0));
 }
 
 static unsigned int sm501_mem_local[] = {
@@ -901,6 +919,12 @@ static int sm501_init_dev(struct sm501_d
 		}
 	}
 
+	ret = sm501_check_clocks(sm);
+	if (ret) {
+		dev_err(sm->dev, "M1X and M clocks sourced from different PLLs\n");
+		return -EINVAL;
+	}
+
 	/* always create a framebuffer */
 	sm501_register_display(sm, &mem_avail);
 
@@ -1034,8 +1058,12 @@ static struct sm501_initdata sm501_pci_i
 	},
 
 	.devices	= SM501_USE_ALL,
-	.mclk		= 100 * MHZ,
-	.m1xclk		= 160 * MHZ,
+
+	/* Errata AB-3 says that 72MHz is the fastest available
+	 * for 33MHZ PCI with proper bus-mastering operation */
+
+	.mclk		= 72 * MHZ,
+	.m1xclk		= 144 * MHZ,
 };
 
 static struct sm501_platdata_fbsub sm501_pdata_fbsub = {
Index: linux-2.6.21-quilt8/include/linux/sm501-regs.h
===================================================================
--- linux-2.6.21-quilt8.orig/include/linux/sm501-regs.h	2007-06-07 12:41:34.000000000 +0100
+++ linux-2.6.21-quilt8/include/linux/sm501-regs.h	2007-06-07 12:42:22.000000000 +0100
@@ -64,6 +64,11 @@
 #define SM501_DEBUG_CONTROL		(0x000034)
 
 /* power management */
+#define SM501_POWERMODE_P2X_SRC		(1<<29)
+#define SM501_POWERMODE_V2X_SRC		(1<<20)
+#define SM501_POWERMODE_M_SRC		(1<<12)
+#define SM501_POWERMODE_M1_SRC		(1<<4)
+
 #define SM501_CURRENT_GATE		(0x000038)
 #define SM501_CURRENT_CLOCK		(0x00003C)
 #define SM501_POWER_MODE_0_GATE		(0x000040)

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
