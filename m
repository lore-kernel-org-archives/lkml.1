Return-Path: <linux-kernel-owner+w=401wt.eu-S1764428AbZFRPNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764428AbZFRPNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761734AbZFRPNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:13:10 -0400
Received: from mail.atmel.fr ([81.80.104.162]:38528 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761257AbZFRPNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:13:09 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: avictor.za@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk
Cc: patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       Hong Xu <hong.xu@atmel.com>
Subject: [PATCH 4/5] at91/USB: USB drivers modifications for at91sam9g10
Date: Thu, 18 Jun 2009 18:16:11 +0200
Message-Id: <1245341772-1689-5-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>
References: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hong Xu <hong.xu@atmel.com>

Modify both host and gadget USB drivers for at91sam9g10.
This add a clock management equivalent to at91sam9261 on usb drivers.
It also add the way of handling gadget pull-ups (like the at91sam9261).

Signed-off-by: Hong Xu <hong.xu@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/usb/gadget/at91_udc.c |    6 +++---
 drivers/usb/host/ohci-at91.c  |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 0b2bb8f..bfed3d9 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -892,7 +892,7 @@ static void pullup(struct at91_udc *udc, int is_on)
 
 			txvc |= AT91_UDP_TXVC_PUON;
 			at91_udp_write(udc, AT91_UDP_TXVC, txvc);
-		} else if (cpu_is_at91sam9261()) {
+		} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
 			u32	usbpucr;
 
 			usbpucr = at91_sys_read(AT91_MATRIX_USBPUCR);
@@ -910,7 +910,7 @@ static void pullup(struct at91_udc *udc, int is_on)
 
 			txvc &= ~AT91_UDP_TXVC_PUON;
 			at91_udp_write(udc, AT91_UDP_TXVC, txvc);
-		} else if (cpu_is_at91sam9261()) {
+		} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
 			u32	usbpucr;
 
 			usbpucr = at91_sys_read(AT91_MATRIX_USBPUCR);
@@ -1692,7 +1692,7 @@ static int __init at91udc_probe(struct platform_device *pdev)
 		udc->ep[3].maxpacket = 64;
 		udc->ep[4].maxpacket = 512;
 		udc->ep[5].maxpacket = 512;
-	} else if (cpu_is_at91sam9261()) {
+	} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
 		udc->ep[3].maxpacket = 64;
 	} else if (cpu_is_at91sam9263()) {
 		udc->ep[0].maxpacket = 64;
diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index b29b0fe..fb64def 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -35,7 +35,7 @@ extern int usb_disabled(void);
 
 static void at91_start_clock(void)
 {
-	if (cpu_is_at91sam9261())
+	if (cpu_is_at91sam9261() || cpu_is_at91sam9g10())
 		clk_enable(hclk);
 	clk_enable(iclk);
 	clk_enable(fclk);
@@ -46,7 +46,7 @@ static void at91_stop_clock(void)
 {
 	clk_disable(fclk);
 	clk_disable(iclk);
-	if (cpu_is_at91sam9261())
+	if (cpu_is_at91sam9261() || cpu_is_at91sam9g10())
 		clk_disable(hclk);
 	clocked = 0;
 }
@@ -142,7 +142,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 
 	iclk = clk_get(&pdev->dev, "ohci_clk");
 	fclk = clk_get(&pdev->dev, "uhpck");
-	if (cpu_is_at91sam9261())
+	if (cpu_is_at91sam9261() || cpu_is_at91sam9g10())
 		hclk = clk_get(&pdev->dev, "hck0");
 
 	at91_start_hc(pdev);
@@ -156,7 +156,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 	/* Error handling */
 	at91_stop_hc(pdev);
 
-	if (cpu_is_at91sam9261())
+	if (cpu_is_at91sam9261() || cpu_is_at91sam9g10())
 		clk_put(hclk);
 	clk_put(fclk);
 	clk_put(iclk);
@@ -193,7 +193,7 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
 	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
-	if (cpu_is_at91sam9261())
+	if (cpu_is_at91sam9261() || cpu_is_at91sam9g10())
 		clk_put(hclk);
 	clk_put(fclk);
 	clk_put(iclk);
-- 
1.5.3.7

