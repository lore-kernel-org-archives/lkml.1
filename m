Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885AbZIYWfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbZIYWfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZIYWfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:35:46 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:51699 "EHLO
	master.douglaskthompson" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750946AbZIYWfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:35:46 -0400
Date: Fri, 25 Sep 2009 16:35:49 -0600
From: dougthompson@xmission.com
To: nils.carlson@ludd.ltu.se, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/3] edac: i5100 add 6 ranks per channel
Message-ID: <4abd45c5.OGce65S4p0TsQq50%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nils Carlson <nils.carlson@ludd.ltu.se>

This patch adds support for 6 ranks per channel to the i5100
chipset. I have tested the patch as far as possible with correctible
errors and things appear good. The DIMM mapping is correct for our
board, but boards may differ.

Signed-off-by: Nils Carlson <nils.carlson@ludd.ltu.se>
Acked-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>

---
Index: linux-2.6.31/drivers/edac/i5100_edac.c
===================================================================
--- linux-2.6.31.orig/drivers/edac/i5100_edac.c
+++ linux-2.6.31/drivers/edac/i5100_edac.c
@@ -9,6 +9,11 @@
  * Intel 5100X Chipset Memory Controller Hub (MCH) - Datasheet
  *      http://download.intel.com/design/chipsets/datashts/318378.pdf
  *
+ * The intel 5100 has two independent channels. EDAC core currently
+ * can not reflect this configuration so instead the chip-select
+ * rows for each respective channel are layed out one after another,
+ * the first half belonging to channel 0, the second half belonging
+ * to channel 1.
  */
 #include <linux/module.h>
 #include <linux/init.h>
@@ -734,7 +739,6 @@ static int i5100_read_spd_byte(const str
  * fill dimm chip select map
  *
  * FIXME:
- *   o only valid for 4 ranks per channel
  *   o not the only way to may chip selects to dimm slots
  *   o investigate if there is some way to obtain this map from the bios
  */
@@ -743,8 +747,6 @@ static void __devinit i5100_init_dimm_cs
 	struct i5100_priv *priv = mci->pvt_info;
 	int i;
 
-	WARN_ON(priv->ranksperchan != 4);
-
 	for (i = 0; i < I5100_MAX_DIMM_SLOTS_PER_CHAN; i++) {
 		int j;
 
@@ -753,12 +755,21 @@ static void __devinit i5100_init_dimm_cs
 	}
 
 	/* only 2 chip selects per slot... */
-	priv->dimm_csmap[0][0] = 0;
-	priv->dimm_csmap[0][1] = 3;
-	priv->dimm_csmap[1][0] = 1;
-	priv->dimm_csmap[1][1] = 2;
-	priv->dimm_csmap[2][0] = 2;
-	priv->dimm_csmap[3][0] = 3;
+	if (priv->ranksperchan == 4) {
+		priv->dimm_csmap[0][0] = 0;
+		priv->dimm_csmap[0][1] = 3;
+		priv->dimm_csmap[1][0] = 1;
+		priv->dimm_csmap[1][1] = 2;
+		priv->dimm_csmap[2][0] = 2;
+		priv->dimm_csmap[3][0] = 3;
+	} else {
+		priv->dimm_csmap[0][0] = 0;
+		priv->dimm_csmap[0][1] = 1;
+		priv->dimm_csmap[1][0] = 2;
+		priv->dimm_csmap[1][1] = 3;
+		priv->dimm_csmap[2][0] = 4;
+		priv->dimm_csmap[2][1] = 5;
+	}
 }
 
 static void __devinit i5100_init_dimm_layout(struct pci_dev *pdev,
@@ -905,13 +916,6 @@ static int __devinit i5100_init_one(stru
 	pci_read_config_dword(pdev, I5100_MS, &dw);
 	ranksperch = !!(dw & (1 << 8)) * 2 + 4;
 
-	if (ranksperch != 4) {
-		/* FIXME: get 6 ranks / channel to work - need hw... */
-		printk(KERN_INFO "i5100_edac: unsupported configuration.\n");
-		ret = -ENODEV;
-		goto bail_pdev;
-	}
-
 	/* enable error reporting... */
 	pci_read_config_dword(pdev, I5100_EMASK_MEM, &dw);
 	dw &= ~I5100_FERR_NF_MEM_ANY_MASK;
