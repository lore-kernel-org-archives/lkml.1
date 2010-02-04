Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0BDGqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 01:46:20 -0500
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:50789 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753485Ab0BDGqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 01:46:18 -0500
Date: Wed, 03 Feb 2010 23:46:17 -0700
From: dougthompson@xmission.com
To: ptyser@xes-inc.com, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 3/7] edac: mpc85xx mask ecc syndrome correctly
Message-ID: <4b6a6d39.J71G67KApK17nfMk%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Tyser <ptyser@xes-inc.com>

With a 64-bit wide data bus only the lowest 8-bits of the ECC syndrome
are relevant.  With a 32-bit wide data bus only the lowest 16-bits are
relevant on most architectures.

Without this change, the ECC syndrome displayed can be mildly confusing,
eg:

  EDAC MPC85xx MC1: syndrome: 0x25252525

When in reality the ECC syndrome is 0x25.

A variety of Freescale manual's say a variety of different things about
how to decode the CAPTURE_ECC (syndrome) register.  I don't have a
system with a 32-bit bus to test on, but I believe the change is
correct.  It'd be good to get an ACK from someone at Freescale
about this change though.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
 drivers/edac/mpc85xx_edac.c |   12 +++++++++++-
 drivers/edac/mpc85xx_edac.h |    3 +++
 2 files changed, 14 insertions(+), 1 deletions(-)

Index: linux-2.6.33-rc4/drivers/edac/mpc85xx_edac.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/edac/mpc85xx_edac.c	2010-01-13 00:16:00.000000000 -0700
+++ linux-2.6.33-rc4/drivers/edac/mpc85xx_edac.c	2010-01-13 00:16:06.000000000 -0700
@@ -672,6 +672,7 @@ static void mpc85xx_mc_check(struct mem_
 {
 	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
 	struct csrow_info *csrow;
+	u32 bus_width;
 	u32 err_detect;
 	u32 syndrome;
 	u32 err_addr;
@@ -692,6 +693,15 @@ static void mpc85xx_mc_check(struct mem_
 	}
 
 	syndrome = in_be32(pdata->mc_vbase + MPC85XX_MC_CAPTURE_ECC);
+
+	/* Mask off appropriate bits of syndrome based on bus width */
+	bus_width = (in_be32(pdata->mc_vbase + MPC85XX_MC_DDR_SDRAM_CFG) &
+			DSC_DBW_MASK) ? 32 : 64;
+	if (bus_width == 64)
+		syndrome &= 0xff;
+	else
+		syndrome &= 0xffff;
+
 	err_addr = in_be32(pdata->mc_vbase + MPC85XX_MC_CAPTURE_ADDRESS);
 	pfn = err_addr >> PAGE_SHIFT;
 
@@ -707,7 +717,7 @@ static void mpc85xx_mc_check(struct mem_
 	mpc85xx_mc_printk(mci, KERN_ERR, "Capture Data Low: %#8.8x\n",
 			  in_be32(pdata->mc_vbase +
 				  MPC85XX_MC_CAPTURE_DATA_LO));
-	mpc85xx_mc_printk(mci, KERN_ERR, "syndrome: %#8.8x\n", syndrome);
+	mpc85xx_mc_printk(mci, KERN_ERR, "syndrome: %#2.2x\n", syndrome);
 	mpc85xx_mc_printk(mci, KERN_ERR, "err addr: %#8.8x\n", err_addr);
 	mpc85xx_mc_printk(mci, KERN_ERR, "PFN: %#8.8x\n", pfn);
 
Index: linux-2.6.33-rc4/drivers/edac/mpc85xx_edac.h
===================================================================
--- linux-2.6.33-rc4.orig/drivers/edac/mpc85xx_edac.h	2010-01-13 00:15:28.000000000 -0700
+++ linux-2.6.33-rc4/drivers/edac/mpc85xx_edac.h	2010-01-13 00:16:06.000000000 -0700
@@ -48,6 +48,9 @@
 #define DSC_MEM_EN	0x80000000
 #define DSC_ECC_EN	0x20000000
 #define DSC_RD_EN	0x10000000
+#define DSC_DBW_MASK	0x00180000
+#define DSC_DBW_32	0x00080000
+#define DSC_DBW_64	0x00000000
 
 #define DSC_SDTYPE_MASK		0x07000000
 
