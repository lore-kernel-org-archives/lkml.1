Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZGVF0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZGVF0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZGVF0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:26:20 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:59799 "EHLO
	master.douglaskthompson" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750909AbZGVF0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:26:19 -0400
Date: Tue, 21 Jul 2009 23:26:18 -0600
From: dougthompson@xmission.com
To: borislav.petkov@amd.com, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/1] edac: fix amd64_edac ecc probe
Message-ID: <4a66a2fa.nomWoVo6gwi9Ls7j%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

1) Current code indicates an error and the amd64_edac module
fails to complete initialization, but remains loaded in memory:

On the good path of BIOS enabled ECC and no override, the 'ret' value is 1 by
omission and returns a non-zero failure code to the probe() function.

This in turns fails the initialization code path. Added an explicit setting
of ret = 0 on a success, thus allowing the module to properly initialize.

(interesting result of the pci_probe is even though an error is returned
by EDAC to the PCI probing code, the module remains IN memory and loaded.
Manual rmmod is necessary. Upon reading the pci probe code, it indicates
allowing "other" drivers to attempt to attach to it. This seems to be
a bug to me on the part of the PCI probing code, leaving the module 
LOADED when it indicates failure)

2) Added explicit returns above a above a couple of error exits,
so that successful exiting would not leave debug output, indicating a
false error condition

3) Align TOP_MEM output


Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
 amd64_edac.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6.31-rc3/drivers/edac/amd64_edac.c
===================================================================
--- linux-2.6.31-rc3.orig/drivers/edac/amd64_edac.c	2009-07-20 20:55:57.000000000 -0600
+++ linux-2.6.31-rc3/drivers/edac/amd64_edac.c	2009-07-20 21:21:33.000000000 -0600
@@ -868,8 +868,10 @@ static void amd64_read_dbam_reg(struct a
 			goto err_reg;
 	}
 
+	return;
+
 err_reg:
-	debugf0("Error reading F2x%03x.\n", reg);
+	debugf0("Error (%d) reading F2x%03x.\n", err, reg);
 }
 
 /*
@@ -2548,7 +2550,7 @@ static void amd64_read_mc_registers(stru
 	 */
 	rdmsrl(MSR_K8_TOP_MEM1, msr_val);
 	pvt->top_mem = msr_val >> 23;
-	debugf0("  TOP_MEM=0x%08llx\n", pvt->top_mem);
+	debugf0("  TOP_MEM= 0x%08llx\n", pvt->top_mem);
 
 	/* check first whether TOP_MEM2 is enabled */
 	rdmsrl(MSR_K8_SYSCFG, msr_val);
@@ -2634,6 +2636,8 @@ static void amd64_read_mc_registers(stru
 
 	amd64_dump_misc_regs(pvt);
 
+	return;
+
 err_reg:
 	debugf0("Reading an MC register failed\n");
 
@@ -2977,6 +2981,9 @@ static int amd64_check_ecc_enabled(struc
 			"ECC is enabled by BIOS, Proceeding "
 			"with EDAC module initialization\n");
 
+		/* Signal good ECC status, for go with module loading */
+		ret = 0;
+
 		/* CLEAR the override, since BIOS controlled it */
 		ecc_enable_override = 0;
 	}
