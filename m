Return-Path: <linux-kernel-owner+w=401wt.eu-S1757094AbYC1Qt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbYC1Qt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYC1QtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:49:17 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:18829 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYC1QtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:49:16 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP
Date: Fri, 28 Mar 2008 10:53:06 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
       irda-users@lists.sourceforge.net, linux-next@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281053.08495.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap PNP probe code in #ifdef CONFIG_PNP.

Without this change, we'll have unresolved references to
pnp_get_resource() function when CONFIG_PNP=n.  (This is a
new interface that's not in mainline yet.)

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/net/irda/smsc-ircc2.c
===================================================================
--- work7.orig/drivers/net/irda/smsc-ircc2.c	2008-03-28 10:47:07.000000000 -0600
+++ work7/drivers/net/irda/smsc-ircc2.c	2008-03-28 10:47:10.000000000 -0600
@@ -79,9 +79,13 @@
 MODULE_DESCRIPTION("SMC IrCC SIR/FIR controller driver");
 MODULE_LICENSE("GPL");
 
+#ifdef CONFIG_PNP
 static int smsc_nopnp = 1;
 module_param_named(nopnp, smsc_nopnp, bool, 0);
 MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings, defaults to true");
+#else
+#define smsc_nopnp 1
+#endif
 
 #define DMA_INVAL 255
 static int ircc_dma = DMA_INVAL;
@@ -366,6 +370,10 @@
                iobase + IRCC_MASTER);
 }
 
+static int pnp_driver_registered;
+
+#ifdef CONFIG_PNP
+
 /* PNP hotplug support */
 static const struct pnp_device_id smsc_ircc_pnp_table[] = {
 	{ .id = "SMCf010", .driver_data = 0 },
@@ -374,8 +382,6 @@
 };
 MODULE_DEVICE_TABLE(pnp, smsc_ircc_pnp_table);
 
-static int pnp_driver_registered;
-
 static int __init smsc_ircc_pnp_probe(struct pnp_dev *dev,
 				      const struct pnp_device_id *dev_id)
 {
@@ -403,6 +409,10 @@
 	.probe		= smsc_ircc_pnp_probe,
 };
 
+#else
+static struct pnp_driver smsc_ircc_pnp_driver;
+#endif
+
 
 /*******************************************************************************
  *
