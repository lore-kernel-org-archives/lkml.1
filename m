Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYC1Quq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYC1Quq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbYC1Qui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:50:38 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:34790 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYC1Quh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:50:37 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [patch] nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Date: Fri, 28 Mar 2008 10:54:43 -0600
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
To: "Undisclosed.Recipients:"@smtp1.fc.hp.com
Message-Id: <200803281054.44836.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap PNP probe code in #ifdef CONFIG_PNP.

Without this change, we'll have unresolved references to
pnp_get_resource() function when CONFIG_PNP=n.  (This is a
new interface that's not in mainline yet.)

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/net/irda/nsc-ircc.c
===================================================================
--- work7.orig/drivers/net/irda/nsc-ircc.c	2008-03-28 10:47:07.000000000 -0600
+++ work7/drivers/net/irda/nsc-ircc.c	2008-03-28 10:47:12.000000000 -0600
@@ -100,7 +100,6 @@
 static int nsc_ircc_init_108(nsc_chip_t *chip, chipio_t *info);
 static int nsc_ircc_init_338(nsc_chip_t *chip, chipio_t *info);
 static int nsc_ircc_init_39x(nsc_chip_t *chip, chipio_t *info);
-static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *id);
 
 /* These are the known NSC chips */
 static nsc_chip_t chips[] = {
@@ -145,8 +144,10 @@
 	"No dongle connected",
 };
 
-/* PNP probing */
 static chipio_t pnp_info;
+
+#ifdef CONFIG_PNP
+/* PNP probing */
 static const struct pnp_device_id nsc_ircc_pnp_table[] = {
 	{ .id = "NSC6001", .driver_data = 0 },
 	{ .id = "IBM0071", .driver_data = 0 },
@@ -155,11 +156,16 @@
 
 MODULE_DEVICE_TABLE(pnp, nsc_ircc_pnp_table);
 
+static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *id);
+
 static struct pnp_driver nsc_ircc_pnp_driver = {
 	.name = "nsc-ircc",
 	.id_table = nsc_ircc_pnp_table,
 	.probe = nsc_ircc_pnp_probe,
 };
+#else
+static struct pnp_driver nsc_ircc_pnp_driver;
+#endif
 
 /* Some prototypes */
 static int  nsc_ircc_open(chipio_t *info);
@@ -916,6 +922,7 @@
 	return 0;
 }
 
+#ifdef CONFIG_PNP
 /* PNP probing */
 static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *id)
 {
@@ -952,6 +959,7 @@
 
 	return 0;
 }
+#endif
 
 /*
  * Function nsc_ircc_setup (info)
