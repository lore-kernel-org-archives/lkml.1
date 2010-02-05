Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab0BEIwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 03:52:01 -0500
Received: from smtp1.entryit.no ([212.4.42.179]:30054 "EHLO smtp1.entryit.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229Ab0BEIwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 03:52:00 -0500
From: Eirik Aanonsen <EAA@wprmedical.com>
To: Greg KH <greg@kroah.com>
CC: "kernel@avr32linux.org" <kernel@avr32linux.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 5 Feb 2010 09:49:25 +0100
Subject: RE: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
Thread-Topic: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
Thread-Index: AcqfpEybfFhFKupAQX6EKt+48WD2bgGm4FRQ
Message-ID: <B5E0EDE940845B429B7ECCE186529F2C065D09FB89@dware2702>
References: <B5E0EDE940845B429B7ECCE186529F2C0641D177FD@dware2702>
 <20100115185457.GG12146@kroah.com>
 <B5E0EDE940845B429B7ECCE186529F2C0641D181F7@dware2702>
 <20100119044912.GB10262@kroah.com>
 <B5E0EDE940845B429B7ECCE186529F2C0641D18303@dware2702>
 <20100127224053.GB25655@kroah.com>
In-Reply-To: <20100127224053.GB25655@kroah.com>
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

...
> 
> The patch below is somehow corrupted, and I couldn't figure out why.
> 
> Care to regenerate it and send it again?
> 
> Sorry for the delay,
> 
> greg k-h

Hi

Trying again

Eirik



Adding vbus_pin_inverted so that the usb detect pin can be active high or low depending on HW implementation
 also replaced the gpio_get_value(udc->vbus_pin); with a call to vbus_is_present(udc);
This allows the driver to be loaded and save about 0,15W on the consumption.

Signed-off-by: Eirik Aanonsen <eaa@wprmedical.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c |    7 +++++--
 drivers/usb/gadget/atmel_usba_udc.c |    5 +++--
 drivers/usb/gadget/atmel_usba_udc.h |    1 +
 include/linux/usb/atmel_usba_udc.h  |    1 +
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 1aa1ea5..83d55f0 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1767,10 +1767,13 @@ at32_add_device_usba(unsigned int id, struct usba_platform_data *data)
 					  ARRAY_SIZE(usba0_resource)))
 		goto out_free_pdev;
 
-	if (data)
+	if (data) {
 		usba_data.pdata.vbus_pin = data->vbus_pin;
-	else
+		usba_data.pdata.vbus_pin_inverted = data->vbus_pin_inverted;
+	} else {
 		usba_data.pdata.vbus_pin = -EINVAL;
+		usba_data.pdata.vbus_pin_inverted = -EINVAL;
+	}
 
 	data = &usba_data.pdata;
 	data->num_ep = ARRAY_SIZE(at32_usba_ep);
diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 4e970cf..93344d7 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -320,7 +320,7 @@ static inline void usba_cleanup_debugfs(struct usba_udc *udc)
 static int vbus_is_present(struct usba_udc *udc)
 {
 	if (gpio_is_valid(udc->vbus_pin))
-		return gpio_get_value(udc->vbus_pin);
+		return gpio_get_value(udc->vbus_pin) ^ udc->vbus_pin_inverted;
 
 	/* No Vbus detection: Assume always present */
 	return 1;
@@ -1763,7 +1763,7 @@ static irqreturn_t usba_vbus_irq(int irq, void *devid)
 	if (!udc->driver)
 		goto out;
 
-	vbus = gpio_get_value(udc->vbus_pin);
+	vbus = vbus_is_present(udc);
 	if (vbus != udc->vbus_prev) {
 		if (vbus) {
 			toggle_bias(1);
@@ -2000,6 +2000,7 @@ static int __init usba_udc_probe(struct platform_device *pdev)
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
index 6311fa2..baf41c8 100644
--- a/include/linux/usb/atmel_usba_udc.h
+++ b/include/linux/usb/atmel_usba_udc.h
@@ -15,6 +15,7 @@ struct usba_ep_data {
 
 struct usba_platform_data {
 	int			vbus_pin;
+	int		 	vbus_pin_inverted;
 	int			num_ep;
 	struct usba_ep_data	ep[0];
 };
-- 
1.5.4.3
