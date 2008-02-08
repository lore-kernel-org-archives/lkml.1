Return-Path: <linux-kernel-owner+w=401wt.eu-S934112AbYBHKCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112AbYBHKCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 05:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932422AbYBHKC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 05:02:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:62583 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932597AbYBHKC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 05:02:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=ZN26plYhGoR6MEQxOy88AXnY+Dzq2xxm5LM/2BzfOMWGs19UDvJZf+KUSgjtOoQi4SeTDbsyWtneLX4XaH058bIMakmDtAmTFzaYqIgj8C0MhvKKJX0/HITagoTrBbwGg9t8bXb2dFYXAijxLRy+YDui4KQLkve+EeblgkaueVE=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ben@fluff.org, Magnus Damm <magnus.damm@gmail.com>,
       linux-sh@vger.kernel.org
Date: Fri, 08 Feb 2008 18:57:42 +0900
Message-Id: <20080208095742.2041.46016.sendpatchset@clockwork.opensource.se>
Subject: [PATCH] sm501: Add uart support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the sm501 mfd with 8250 uart support. We're currently
doing this in the board specific r2d-1 code already, but it would be nice to
do move things into the mfd since it's more chip specific than board specific.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/mfd/sm501.c         |   86 ++++++++++++++++++++++++++++++++++---------
 include/linux/serial_8250.h |    1 
 2 files changed, 70 insertions(+), 17 deletions(-)

--- 0001/drivers/mfd/sm501.c
+++ work/drivers/mfd/sm501.c	2008-02-08 18:40:33.000000000 +0900
@@ -22,6 +22,7 @@
 
 #include <linux/sm501.h>
 #include <linux/sm501-regs.h>
+#include <linux/serial_8250.h>
 
 #include <asm/io.h>
 
@@ -651,13 +652,14 @@ static void sm501_device_release(struct 
 */
 
 static struct platform_device *
-sm501_create_subdev(struct sm501_devdata *sm,
-		    char *name, unsigned int res_count)
+sm501_create_subdev(struct sm501_devdata *sm, char *name,
+		    unsigned int res_count, unsigned int platform_data_size)
 {
 	struct sm501_device *smdev;
 
 	smdev = kzalloc(sizeof(struct sm501_device) +
-			sizeof(struct resource) * res_count, GFP_KERNEL);
+			(sizeof(struct resource) * res_count) +
+			platform_data_size, GFP_KERNEL);
 	if (!smdev)
 		return NULL;
 
@@ -665,11 +667,15 @@ sm501_create_subdev(struct sm501_devdata
 
 	smdev->pdev.name = name;
 	smdev->pdev.id = sm->pdev_id;
-	smdev->pdev.resource = (struct resource *)(smdev+1);
-	smdev->pdev.num_resources = res_count;
-
 	smdev->pdev.dev.parent = sm->dev;
 
+	if (res_count) {
+		smdev->pdev.resource = (struct resource *)(smdev+1);
+		smdev->pdev.num_resources = res_count;
+	}
+	if (platform_data_size)
+		smdev->pdev.dev.platform_data = (void *)(smdev+1);
+
 	return &smdev->pdev;
 }
 
@@ -757,7 +763,7 @@ static int sm501_register_usbhost(struct
 {
 	struct platform_device *pdev;
 
-	pdev = sm501_create_subdev(sm, "sm501-usb", 3);
+	pdev = sm501_create_subdev(sm, "sm501-usb", 3, 0);
 	if (!pdev)
 		return -ENOMEM;
 
@@ -768,12 +774,55 @@ static int sm501_register_usbhost(struct
 	return sm501_register_device(sm, pdev);
 }
 
+static void sm501_setup_uart_data(struct sm501_devdata *sm,
+				  struct plat_serial8250_port *uart_data,
+				  unsigned int offset)
+{
+	uart_data->membase = sm->regs + offset;
+	uart_data->mapbase = sm->io_res->start + offset;
+	uart_data->iotype = UPIO_MEM;
+	uart_data->irq = sm->irq;
+	uart_data->flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_SHARE_IRQ;
+	uart_data->regshift = 2;
+	uart_data->uartclk = (9600 * 16);
+}
+
+static int sm501_register_uart(struct sm501_devdata *sm, int devices)
+{
+	struct platform_device *pdev;
+	struct plat_serial8250_port *uart_data;
+
+	pdev = sm501_create_subdev(sm, "serial8250", 0,
+				   sizeof(struct plat_serial8250_port) * 3);
+	if (!pdev)
+		return -ENOMEM;
+
+	uart_data = pdev->dev.platform_data;
+
+	if (devices & SM501_USE_UART0) {
+		sm501_setup_uart_data(sm, uart_data++, 0x30000);
+		sm501_unit_power(sm->dev, SM501_GATE_UART0, 1);
+		sm501_modify_reg(sm->dev, SM501_IRQ_MASK, 1 << 12, 0);
+		sm501_modify_reg(sm->dev, SM501_GPIO63_32_CONTROL, 0x01e0, 0);
+	}
+	if (devices & SM501_USE_UART1) {
+		sm501_setup_uart_data(sm, uart_data++, 0x30020);
+		sm501_unit_power(sm->dev, SM501_GATE_UART1, 1);
+		sm501_modify_reg(sm->dev, SM501_IRQ_MASK, 1 << 13, 0);
+		sm501_modify_reg(sm->dev, SM501_GPIO63_32_CONTROL, 0x1e00, 0);
+	}
+
+	pdev->id = PLAT8250_DEV_SM501;
+
+	return sm501_register_device(sm, pdev);
+}
+
 static int sm501_register_display(struct sm501_devdata *sm,
 				  resource_size_t *mem_avail)
 {
 	struct platform_device *pdev;
 
-	pdev = sm501_create_subdev(sm, "sm501-fb", 4);
+	pdev = sm501_create_subdev(sm, "sm501-fb", 4, 0);
 	if (!pdev)
 		return -ENOMEM;
 
@@ -891,6 +940,7 @@ static unsigned int sm501_mem_local[] = 
 
 static int sm501_init_dev(struct sm501_devdata *sm)
 {
+	struct sm501_initdata *idata;
 	resource_size_t mem_avail;
 	unsigned long dramctrl;
 	unsigned long devid;
@@ -908,6 +958,9 @@ static int sm501_init_dev(struct sm501_d
 		return -EINVAL;
 	}
 
+	/* disable irqs */
+	writel(0, sm->regs + SM501_IRQ_MASK);
+
 	dramctrl = readl(sm->regs + SM501_DRAM_CONTROL);
 	mem_avail = sm501_mem_local[(dramctrl >> 13) & 0x7];
 
@@ -924,15 +977,14 @@ static int sm501_init_dev(struct sm501_d
 
 	/* check to see if we have some device initialisation */
 
-	if (sm->platdata) {
-		struct sm501_platdata *pdata = sm->platdata;
-
-		if (pdata->init) {
-			sm501_init_regs(sm, sm->platdata->init);
-
-			if (pdata->init->devices & SM501_USE_USB_HOST)
-				sm501_register_usbhost(sm, &mem_avail);
-		}
+	idata = sm->platdata ? sm->platdata->init : NULL;
+	if (idata) {
+		sm501_init_regs(sm, idata);
+
+		if (idata->devices & SM501_USE_USB_HOST)
+			sm501_register_usbhost(sm, &mem_avail);
+		if (idata->devices & (SM501_USE_UART0 | SM501_USE_UART1))
+			sm501_register_uart(sm, idata->devices);
 	}
 
 	ret = sm501_check_clocks(sm);
--- 0001/include/linux/serial_8250.h
+++ work/include/linux/serial_8250.h	2008-02-08 18:39:11.000000000 +0900
@@ -46,6 +46,7 @@ enum {
 	PLAT8250_DEV_HUB6,
 	PLAT8250_DEV_MCA,
 	PLAT8250_DEV_AU1X00,
+	PLAT8250_DEV_SM501,
 };
 
 /*
