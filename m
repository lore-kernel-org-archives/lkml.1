Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbYIANwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbYIANwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYIANwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:52:38 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7877 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750800AbYIANwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:52:37 -0400
Date: Mon, 1 Sep 2008 17:52:35 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Li Yang <leoli@freescale.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller
	driver
Message-ID: <20080901135235.GA677@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1219916613-28827-1-git-send-email-leoli@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <1219916613-28827-1-git-send-email-leoli@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 05:43:33PM +0800, Li Yang wrote:
> Some of Freescale SoC chips have a QE or CPM co-processor which
> supports full speed USB.  The driver adds device mode support
> of both QE and CPM USB controller to Linux USB gadget.  The
> driver is tested with MPC8360 and MPC8272, and should work with
> other models having QE/CPM given minor tweaks.
> 
> Signed-off-by: Xie Xiaobo <X.Xie@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
> This is the second submission of the driver.  This version addressed:
> Comments from Anton Vorontsov.
> A lot of cosmetic problem.
> Sparse and various kernel DEBUG warnings.

You might want to consider some of the following changes (they're
tested with
http://ozlabs.org/pipermail/linuxppc-dev/2008-September/062360.html).

- remove qe_muram -> cpm_muram defines
- configure clocks per device tree via qe_usb_clock_set(). To use this
  function we should select QE_USB.

  NOTE: currently this means that CPM build will break. :-( We should
  probably implement generic cpm_clock_source() and cpm_usb_clock_set().

  Or.. we can move this to the board file (Do we ever need to change the
  clocks in this driver? For the Host driver we need this, since it
  can switch between low and full speed).

  What do you think?

- change 8360 compatible to 8323 (8323 is the first chip with QE USB,
  device trees for 8360 boards should specify fsl,mpc8323-qe-usb
  as a compatible).

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 4dbf622..e57c298 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -153,6 +153,7 @@ config USB_FSL_USB2
 config USB_GADGET_FSL_QE
 	boolean "Freescale QE/CPM USB Device Controller"
 	depends on FSL_SOC && (QUICC_ENGINE || CPM)
+	select QE_USB
 	help
 	   Some of Freescale PowerPC processors have a Full Speed
 	   QE/CPM2 USB controller, which support device mode with 4
diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index e448610..c1a0beb 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -36,20 +36,12 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 #include <linux/usb/otg.h>
+#include <asm/cpm.h>
 #include <asm/qe.h>
 #include <asm/dma.h>
 #include <asm/reg.h>
 #include "fsl_qe_udc.h"
 
-#ifdef CONFIG_CPM2
-#include <asm/cpm.h>
-
-#define qe_muram_addr cpm_muram_addr
-#define qe_muram_offset cpm_muram_offset
-#define qe_muram_alloc cpm_muram_alloc
-#define qe_muram_free cpm_muram_free
-#endif
-
 #define DRIVER_DESC     "Freescale QE/CPM USB Device Controller driver"
 #define DRIVER_AUTHOR   "Xie XiaoBo"
 #define DRIVER_VERSION  "1.0"
@@ -2490,6 +2482,7 @@ static int __devinit qe_udc_probe(struct of_device *ofdev,
 			const struct of_device_id *match)
 {
 	struct device_node *np = ofdev->node;
+	enum qe_clock clk;
 	struct qe_ep *ep;
 	unsigned int ret = 0;
 	unsigned int i;
@@ -2499,6 +2492,16 @@ static int __devinit qe_udc_probe(struct of_device *ofdev,
 	if (!prop || strcmp(prop, "peripheral"))
 		return -ENODEV;
 
+	prop = of_get_property(np, "fsl,fullspeed-clock", NULL);
+	if (!prop)
+		return -EINVAL;
+
+	clk = qe_clock_source(prop);
+	if (clk == QE_CLK_NONE || clk == QE_CLK_DUMMY)
+		return -EINVAL;
+
+	qe_usb_clock_set(clk, USB_CLOCK);
+
 	/* Initialize the udc structure including QH member and other member */
 	udc_controller = qe_udc_config(ofdev);
 	if (!udc_controller) {
@@ -2689,7 +2692,7 @@ static int __devexit qe_udc_remove(struct of_device *ofdev)
 /*-------------------------------------------------------------------------*/
 static struct of_device_id qe_udc_match[] = {
 	{
-		.compatible = "fsl,mpc8360-qe-usb",
+		.compatible = "fsl,mpc8323-qe-usb",
 	},
 	{
 		.compatible = "fsl,mpc8272-cpm-usb",
diff --git a/drivers/usb/gadget/fsl_qe_udc.h b/drivers/usb/gadget/fsl_qe_udc.h
index e2e9639..0ff9c00 100644
--- a/drivers/usb/gadget/fsl_qe_udc.h
+++ b/drivers/usb/gadget/fsl_qe_udc.h
@@ -17,6 +17,8 @@
 #ifndef __FSL_QE_UDC_H
 #define __FSL_QE_UDC_H
 
+#define USB_CLOCK			48000000
+
 #define USB_MAX_ENDPOINTS               4
 #define USB_MAX_PIPES                   USB_MAX_ENDPOINTS
 #define USB_EP0_MAX_SIZE		64
