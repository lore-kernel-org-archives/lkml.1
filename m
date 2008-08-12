Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbYHLOmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbYHLOmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbYHLOjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:39:39 -0400
Received: from multi.imgtec.com ([194.200.65.239]:46465 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbYHLOjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:39:25 -0400
From: Will Newton <will.newton@imgtec.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       leoli@freescale.com, Will Newton <will.newton@gmail.com>
Subject: [PATCH 11/11] fsl_usb2_udc: Fix oops on probe failure.
Date: Tue, 12 Aug 2008 15:39:17 +0100
Message-Id: <1218551957-17091-12-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1218551957-17091-11-git-send-email-will.newton@imgtec.com>
References: <1218551957-17091-1-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-2-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-3-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-4-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-5-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-6-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-7-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-8-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-9-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-10-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-11-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 12 Aug 2008 14:39:18.0634 (UTC) FILETIME=[33976CA0:01C8FC89]
X-SEF-Processed: 6_0_1_111__2008_08_12_15_39_21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

In some circumstances when fsl_udc_probe fails udc_controller is freed but
the pointer remains non-NULL. fsl_udc_remove will then try and teardown
the partly initialized and freed controller structure resulting in an oops.
This patch ensures udc_controller is either NULL or fully initialized after
fsl_udc_probe.

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Li Yang <leoli@freescale.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 79c36eb..eff48f3 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -2244,21 +2244,21 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-		kfree(udc_controller);
-		return -ENXIO;
+		ret = -ENXIO;
+		goto err_kfree;
 	}
 
 	if (!request_mem_region(res->start, res->end - res->start + 1,
 				driver_name)) {
 		ERR("request mem region for %s failed\n", pdev->name);
-		kfree(udc_controller);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto err_kfree;
 	}
 
 	dr_regs = ioremap(res->start, res->end - res->start + 1);
 	if (!dr_regs) {
 		ret = -ENOMEM;
-		goto err1;
+		goto err_release_mem_region;
 	}
 
 	usb_sys_regs = (struct usb_sys_interface *)
@@ -2269,7 +2269,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 	if (!(dccparams & DCCPARAMS_DC)) {
 		ERR("This SOC doesn't support device role\n");
 		ret = -ENODEV;
-		goto err2;
+		goto err_iounmap;
 	}
 	/* Get max device endpoints */
 	/* DEN is bidirectional ep number, max_ep doubles the number */
@@ -2278,7 +2278,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 	udc_controller->irq = platform_get_irq(pdev, 0);
 	if (!udc_controller->irq) {
 		ret = -ENODEV;
-		goto err2;
+		goto err_iounmap;
 	}
 
 	ret = request_irq(udc_controller->irq, fsl_udc_irq, IRQF_SHARED,
@@ -2286,14 +2286,14 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		ERR("cannot request irq %d err %d\n",
 				udc_controller->irq, ret);
-		goto err2;
+		goto err_iounmap;
 	}
 
 	/* Initialize the udc structure including QH member and other member */
 	if (struct_udc_setup(udc_controller, pdev)) {
 		ERR("Can't initialize udc data structure\n");
 		ret = -ENOMEM;
-		goto err3;
+		goto err_free_irq;
 	}
 
 	/* initialize usb hw reg except for regs for EP,
@@ -2314,7 +2314,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 	udc_controller->gadget.dev.parent = &pdev->dev;
 	ret = device_register(&udc_controller->gadget.dev);
 	if (ret < 0)
-		goto err3;
+		goto err_free_irq;
 
 	/* setup QH and epctrl for ep0 */
 	ep0_setup(udc_controller);
@@ -2344,20 +2344,22 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 			DTD_ALIGNMENT, UDC_DMA_BOUNDARY);
 	if (udc_controller->td_pool == NULL) {
 		ret = -ENOMEM;
-		goto err4;
+		goto err_unregister;
 	}
 	create_proc_file();
 	return 0;
 
-err4:
+err_unregister:
 	device_unregister(&udc_controller->gadget.dev);
-err3:
+err_free_irq:
 	free_irq(udc_controller->irq, udc_controller);
-err2:
+err_iounmap:
 	iounmap(dr_regs);
-err1:
+err_release_mem_region:
 	release_mem_region(res->start, res->end - res->start + 1);
+err_kfree:
 	kfree(udc_controller);
+	udc_controller = NULL;
 	return ret;
 }
 
-- 
1.5.5.2

