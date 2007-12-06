Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbXLFLHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbXLFLHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 06:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbXLFLHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 06:07:31 -0500
Received: from mail.atmel.fr ([81.80.104.162]:57936 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbXLFLHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 06:07:30 -0500
Message-ID: <4757D7F3.8040904@atmel.com>
Date: Thu, 06 Dec 2007 12:07:31 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Andrew Victor <linux@maxim.org.za>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb: at91_udc: correct hanging while disconnecting usb cable
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct hanging while disconnecting the USB device 
cable. Prevent a race between vbus and UDP interrupts.
This bug was tracked on at91sam9260ek boards.

Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com> 
---

A usb resume interrupt was firing after the vbus 
interrupt : the IP was then already stoped and not able 
to deal with it (no more clock). A simple interrupt disabling 
is ok as the "end of bus reset" irq is non maskable and ok 
to resume the USB device IP.

--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -908,6 +908,7 @@ static void pullup(struct at91_udc *udc,
 
 	if (is_on) {
 		clk_on(udc);
+		at91_udp_write(udc, AT91_UDP_ICR, AT91_UDP_RXRSM);
 		at91_udp_write(udc, AT91_UDP_TXVC, 0);
 		if (cpu_is_at91rm9200())
 			at91_set_gpio_value(udc->board.pullup_pin, 1);
@@ -925,6 +926,7 @@ static void pullup(struct at91_udc *udc,
 		}
 	} else {
 		stop_activity(udc);
+		at91_udp_write(udc, AT91_UDP_IDR, AT91_UDP_RXRSM);
 		at91_udp_write(udc, AT91_UDP_TXVC, AT91_UDP_TXVC_TXVDIS);
 		if (cpu_is_at91rm9200())
 			at91_set_gpio_value(udc->board.pullup_pin, 0);

