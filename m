Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbYF0SVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbYF0SVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758647AbYF0SUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:20:52 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11659 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757736AbYF0SUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:20:49 -0400
Date: Fri, 27 Jun 2008 12:13:03 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 3/13] EDAC i5100 fix enable ecc hardware
Message-ID: <48652daf.fShaj4RN6jgP6Beq%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Arthur Jones <ajones@riverbed.com>

Applied to linux-2.6.26-rc5-mm3

Patch file for the i5100_edac module

It is possible that the BIOS did not enable
ECC at boot time.  We check for that case and
fail to load if it is true.

Signed-off-by:	Arthur Jones <ajones@riverbed.com>
Signed-off-by:	Arthur Jones <ajones@riverbed.com>
---
 drivers/edac/i5100_edac.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

Index: linux-2.6.26-rc5/drivers/edac/i5100_edac.c
===================================================================
--- linux-2.6.26-rc5.orig/drivers/edac/i5100_edac.c
+++ linux-2.6.26-rc5/drivers/edac/i5100_edac.c
@@ -24,6 +24,8 @@
 /* register addresses and bit field accessors... */
 
 /* device 16, func 1 */
+#define I5100_MC		0x40	/* Memory Control Register */
+#define		I5100_MC_ERRDETEN(a)	((a) >> 5 & 1)
 #define I5100_MS		0x44	/* Memory Status Register */
 #define I5100_SPDDATA		0x48	/* Serial Presence Detect Status Reg */
 #define		I5100_SPDDATA_RDO(a)	((a) >> 15 & 1)
@@ -688,6 +690,14 @@ static int __devinit i5100_init_one(stru
 		goto bail;
 	}
 
+	/* ECC enabled? */
+	pci_read_config_dword(pdev, I5100_MC, &dw);
+	if (!I5100_MC_ERRDETEN(dw)) {
+		printk(KERN_INFO "i5100_edac: ECC not enabled.\n");
+		ret = -ENODEV;
+		goto bail;
+	}
+
 	/* figure out how many ranks, from strapped state of 48GB_Mode input */
 	pci_read_config_dword(pdev, I5100_MS, &dw);
 	ranksperch = !!(dw & (1 << 8)) * 2 + 4;
