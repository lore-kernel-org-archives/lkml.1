Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916Ab0AEItK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab0AEItK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694Ab0AEItI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:49:08 -0500
Received: from smtp1.entryit.no ([212.4.42.179]:35532 "EHLO smtp1.entryit.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab0AEItH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:49:07 -0500
From: Eirik Aanonsen <EAA@wprmedical.com>
To: "kernel@avr32linux.org" <kernel@avr32linux.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 5 Jan 2010 09:47:57 +0100
Subject: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
Thread-Topic: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
Thread-Index: AcqN48dOrjX+1T2DTKONu97r3uR6wQ==
Message-ID: <B5E0EDE940845B429B7ECCE186529F2C0641D17873@dware2702>
Accept-Language: nb-NO
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: nb-NO
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Ben Nizette [bn@niasdigital.com] and Sergei Shtylyov [sshtylyov@ru.mvista.com] for good feedback

Adding vbus_pin_inverted so that the usb detect pin can be active high or low.
This because depending on HW implementation it is better to have active low.
Also replaced the pio_get_value(udc->vbus_pin); with a call to vbus_is_present(udc);

Signed-off-by: Eirik Aanonsen <eaa@wprmedical.com>
---
 drivers/usb/gadget/atmel_usba_udc.c |    6 +++---
 drivers/usb/gadget/atmel_usba_udc.h |    1 +
 include/linux/usb/atmel_usba_udc.h  |    1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 4e970cf..e1282fc 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -320,8 +320,7 @@ static inline void usba_cleanup_debugfs(struct usba_udc *udc)
 static int vbus_is_present(struct usba_udc *udc)
 {
 	if (gpio_is_valid(udc->vbus_pin))
-		return gpio_get_value(udc->vbus_pin);
-
+		return gpio_get_value(udc->vbus_pin) ^ udc->vbus_pin_inverted;
 	/* No Vbus detection: Assume always present */
 	return 1;
 }
@@ -1763,7 +1762,7 @@ static irqreturn_t usba_vbus_irq(int irq, void *devid)
 	if (!udc->driver)
 		goto out;
 
-	vbus = gpio_get_value(udc->vbus_pin);
+	vbus = vbus_is_present(udc);
 	if (vbus != udc->vbus_prev) {
 		if (vbus) {
 			toggle_bias(1);
@@ -2000,6 +1999,7 @@ static int __init usba_udc_probe(struct platform_device *pdev)
 	if (gpio_is_valid(pdata->vbus_pin)) {
 		if (!gpio_request(pdata->vbus_pin, "atmel_usba_udc")) {
 			udc->vbus_pin = pdata->vbus_pin;
+			udc->vbus_pin_inverted = pdata->vbus_pin_inverted;
 
 			ret = request_irq(gpio_to_irq(udc->vbus_pin),
 					usba_vbus_irq, 0,
diff --git a/drivers/usb/gadget/atmel_usba_udc.h b/drivers/usb/gadget/atmel_usba_udc.h
index f7baea3..88a2e07 100644
--- a/drivers/usb/gadget/atmel_usba_udc.h
+++ b/drivers/usb/gadget/atmel_usba_udc.h
@@ -323,6 +323,7 @@ struct usba_udc {
 	struct platform_device *pdev;
 	int irq;
 	int vbus_pin;
+	int vbus_pin_inverted;
 	struct clk *pclk;
 	struct clk *hclk;
 
diff --git a/include/linux/usb/atmel_usba_udc.h b/include/linux/usb/atmel_usba_udc.h
index 6311fa2..643c4c5 100644
--- a/include/linux/usb/atmel_usba_udc.h
+++ b/include/linux/usb/atmel_usba_udc.h
@@ -15,6 +15,7 @@ struct usba_ep_data {
 
 struct usba_platform_data {
 	int			vbus_pin;
+	unsigned char vbus_pin_inverted;
 	int			num_ep;
 	struct usba_ep_data	ep[0];
 };
-- 
1.5.4.3
