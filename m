Return-Path: <linux-kernel-owner+w=401wt.eu-S1752382AbYLYOPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbYLYOPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYLYOPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:15:05 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:53975 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751636AbYLYOPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:15:04 -0500
Date: Thu, 25 Dec 2008 17:15:02 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] USB: fsl_qe_udc: Fix oops on QE UDC probe failure
Message-ID: <20081225141502.GA6786@oksana.dev.rtsoft.ru>
References: <20081225141402.GA30689@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081225141402.GA30689@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of probing errors the driver kfrees the udc_controller, but it
doesn't set the pointer to NULL.

When usb_gadget_register_driver is called, it checks for udc_controller
!= NULL, the check passes and the driver accesses nonexistent memory.
Fix this by setting udc_controller to NULL in case of errors.

While at it, also implement irq_of_parse_and_map()'s failure and cleanup
cases.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/gadget/fsl_qe_udc.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index d15be3d..db6fe04 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2604,6 +2604,10 @@ static int __devinit qe_udc_probe(struct of_device *ofdev,
 			(unsigned long)udc_controller);
 	/* request irq and disable DR  */
 	udc_controller->usb_irq = irq_of_parse_and_map(np, 0);
+	if (!udc_controller->usb_irq) {
+		ret = -EINVAL;
+		goto err_noirq;
+	}
 
 	ret = request_irq(udc_controller->usb_irq, qe_udc_irq, 0,
 				driver_name, udc_controller);
@@ -2625,6 +2629,8 @@ static int __devinit qe_udc_probe(struct of_device *ofdev,
 err6:
 	free_irq(udc_controller->usb_irq, udc_controller);
 err5:
+	irq_dispose_mapping(udc_controller->usb_irq);
+err_noirq:
 	if (udc_controller->nullmap) {
 		dma_unmap_single(udc_controller->gadget.dev.parent,
 			udc_controller->nullp, 256,
@@ -2648,7 +2654,7 @@ err2:
 	iounmap(udc_controller->usb_regs);
 err1:
 	kfree(udc_controller);
-
+	udc_controller = NULL;
 	return ret;
 }
 
@@ -2710,6 +2716,7 @@ static int __devexit qe_udc_remove(struct of_device *ofdev)
 	kfree(ep->txframe);
 
 	free_irq(udc_controller->usb_irq, udc_controller);
+	irq_dispose_mapping(udc_controller->usb_irq);
 
 	tasklet_kill(&udc_controller->rx_tasklet);
 
-- 
1.5.6.5

