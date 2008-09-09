Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbYIIUec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbYIIUec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYIIUeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:34:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:13339 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYIIUeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=f2jUUi78meJq9Hi3sZ2V9ucf2mJZ0z+ZNanMu66826m/kQCxyXi3D8dFx7Plna81qG
         iXuxLTegvFcZGCa9aGUpaqyJfFhI2Ox06Hzh+YLcsQd9g5hm62IPaJ+w80GHYEqpc8KQ
         CqI+/ujxs0chw9TA/9phZo+5KEtQGbWm+Az+4=
Message-ID: <48C6DDC9.4060309@gmail.com>
Date: Tue, 09 Sep 2008 22:34:17 +0200
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: galak@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [POWERPC] unsigned hwirq cannot be negative
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is not tested
---
fsl_msi_alloc_hwirqs() converts an int from bitmap_find_free_region()
into an irq_hw_number_t, but this can be an -ENOMEM. This is tested
in fsl_setup_msi_irqs(), but incorrectly: irq_hw_number_t is
unsigned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 2c5187c..a2aa59a 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -67,7 +67,7 @@ static struct irq_host_ops fsl_msi_host_ops = {
 	.map = fsl_msi_host_map,
 };
 
-static irq_hw_number_t fsl_msi_alloc_hwirqs(struct fsl_msi *msi, int num)
+static int fsl_msi_alloc_hwirqs(struct fsl_msi *msi, int num)
 {
 	unsigned long flags;
 	int order = get_count_order(num);
@@ -205,13 +205,13 @@ static int fsl_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	struct fsl_msi *msi_data = fsl_msi;
 
 	list_for_each_entry(entry, &pdev->msi_list, list) {
-		hwirq = fsl_msi_alloc_hwirqs(msi_data, 1);
-		if (hwirq < 0) {
-			rc = hwirq;
+		rc = fsl_msi_alloc_hwirqs(msi_data, 1);
+		if (rc < 0) {
 			pr_debug("%s: fail allocating msi interrupt\n",
 					__func__);
 			goto out_free;
 		}
+		hwirq = rc;
 
 		virq = irq_create_mapping(msi_data->irqhost, hwirq);
 
