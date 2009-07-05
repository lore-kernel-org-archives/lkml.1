Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbZGEGhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbZGEGhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 02:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZGEGgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 02:36:52 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:35495 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbZGEGgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 02:36:51 -0400
Date: Sun, 5 Jul 2009 08:36:52 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] drivers/edac: Use resource_size
Message-ID: <Pine.LNX.4.64.0907050836250.27464@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use the function resource_size, which reduces the chance of introducing
off-by-one errors in calculating the resource size.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct resource *res;
@@

- (res->end - res->start) + 1
+ resource_size(res)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/edac/cpc925_edac.c  |    6 +++---
 drivers/edac/mv64x60_edac.c |   22 +++++++++++-----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -u -p a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
--- a/drivers/edac/cpc925_edac.c 2009-06-24 21:18:49.000000000 +0200
+++ b/drivers/edac/cpc925_edac.c 2009-07-04 21:38:59.000000000 +0200
@@ -885,14 +885,14 @@ static int __devinit cpc925_probe(struct
 
 	if (!devm_request_mem_region(&pdev->dev,
 				     r->start,
-				     r->end - r->start + 1,
+				     resource_size(r),
 				     pdev->name)) {
 		cpc925_printk(KERN_ERR, "Unable to request mem region\n");
 		res = -EBUSY;
 		goto err1;
 	}
 
-	vbase = devm_ioremap(&pdev->dev, r->start, r->end - r->start + 1);
+	vbase = devm_ioremap(&pdev->dev, r->start, resource_size(r));
 	if (!vbase) {
 		cpc925_printk(KERN_ERR, "Unable to ioremap device\n");
 		res = -ENOMEM;
@@ -953,7 +953,7 @@ err3:
 	cpc925_mc_exit(mci);
 	edac_mc_free(mci);
 err2:
-	devm_release_mem_region(&pdev->dev, r->start, r->end-r->start+1);
+	devm_release_mem_region(&pdev->dev, r->start, resource_size(r));
 err1:
 	devres_release_group(&pdev->dev, cpc925_probe);
 out:
diff -u -p a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
--- a/drivers/edac/mv64x60_edac.c 2009-03-28 23:34:54.000000000 +0100
+++ b/drivers/edac/mv64x60_edac.c 2009-07-04 21:39:00.000000000 +0200
@@ -90,7 +90,7 @@ static int __init mv64x60_pci_fixup(stru
 		return -ENOENT;
 	}
 
-	pci_serr = ioremap(r->start, r->end - r->start + 1);
+	pci_serr = ioremap(r->start, resource_size(r));
 	if (!pci_serr)
 		return -ENOMEM;
 
@@ -140,7 +140,7 @@ static int __devinit mv64x60_pci_err_pro
 
 	if (!devm_request_mem_region(&pdev->dev,
 				     r->start,
-				     r->end - r->start + 1,
+				     resource_size(r),
 				     pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
@@ -150,7 +150,7 @@ static int __devinit mv64x60_pci_err_pro
 
 	pdata->pci_vbase = devm_ioremap(&pdev->dev,
 					r->start,
-					r->end - r->start + 1);
+					resource_size(r));
 	if (!pdata->pci_vbase) {
 		printk(KERN_ERR "%s: Unable to setup PCI err regs\n", __func__);
 		res = -ENOMEM;
@@ -306,7 +306,7 @@ static int __devinit mv64x60_sram_err_pr
 
 	if (!devm_request_mem_region(&pdev->dev,
 				     r->start,
-				     r->end - r->start + 1,
+				     resource_size(r),
 				     pdata->name)) {
 		printk(KERN_ERR "%s: Error while request mem region\n",
 		       __func__);
@@ -316,7 +316,7 @@ static int __devinit mv64x60_sram_err_pr
 
 	pdata->sram_vbase = devm_ioremap(&pdev->dev,
 					 r->start,
-					 r->end - r->start + 1);
+					 resource_size(r));
 	if (!pdata->sram_vbase) {
 		printk(KERN_ERR "%s: Unable to setup SRAM err regs\n",
 		       __func__);
@@ -474,7 +474,7 @@ static int __devinit mv64x60_cpu_err_pro
 
 	if (!devm_request_mem_region(&pdev->dev,
 				     r->start,
-				     r->end - r->start + 1,
+				     resource_size(r),
 				     pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
@@ -484,7 +484,7 @@ static int __devinit mv64x60_cpu_err_pro
 
 	pdata->cpu_vbase[0] = devm_ioremap(&pdev->dev,
 					   r->start,
-					   r->end - r->start + 1);
+					   resource_size(r));
 	if (!pdata->cpu_vbase[0]) {
 		printk(KERN_ERR "%s: Unable to setup CPU err regs\n", __func__);
 		res = -ENOMEM;
@@ -501,7 +501,7 @@ static int __devinit mv64x60_cpu_err_pro
 
 	if (!devm_request_mem_region(&pdev->dev,
 				     r->start,
-				     r->end - r->start + 1,
+				     resource_size(r),
 				     pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
@@ -511,7 +511,7 @@ static int __devinit mv64x60_cpu_err_pro
 
 	pdata->cpu_vbase[1] = devm_ioremap(&pdev->dev,
 					   r->start,
-					   r->end - r->start + 1);
+					   resource_size(r));
 	if (!pdata->cpu_vbase[1]) {
 		printk(KERN_ERR "%s: Unable to setup CPU err regs\n", __func__);
 		res = -ENOMEM;
@@ -726,7 +726,7 @@ static int __devinit mv64x60_mc_err_prob
 
 	if (!devm_request_mem_region(&pdev->dev,
 				     r->start,
-				     r->end - r->start + 1,
+				     resource_size(r),
 				     pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
@@ -736,7 +736,7 @@ static int __devinit mv64x60_mc_err_prob
 
 	pdata->mc_vbase = devm_ioremap(&pdev->dev,
 				       r->start,
-				       r->end - r->start + 1);
+				       resource_size(r));
 	if (!pdata->mc_vbase) {
 		printk(KERN_ERR "%s: Unable to setup MC err regs\n", __func__);
 		res = -ENOMEM;
