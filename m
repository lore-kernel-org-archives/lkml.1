Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbZLKSc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbZLKSc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758502AbZLKScX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:32:23 -0500
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:60350 "EHLO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZLKScW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:32:22 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] i2c-iop3xx.c: fix memory resource
Date: Fri, 11 Dec 2009 13:32:28 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB1063@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] i2c-iop3xx.c: fix memory resource
Thread-Index: Acp6kErfcU5CCDaIRoG2a/4Et0JlWw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
       <linux-i2c@vger.kernel.org>
Cc: <khali@linux-fr.org>, "Ben Dooks" <ben-linux@fluff.org>,
       "Lennert Buytenhek" <buytenh@wantstofly.org>,
       <dan.j.williams@intel.com>
X-OriginalArrivalTime: 11 Dec 2009 18:32:28.0461 (UTC) FILETIME=[4AF01DD0:01CA7A90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c-iop3xx driver requires a resource region of 0x18 bytes and
currently uses the magic number IOP3XX_I2C_IO_SIZE (defined in
i2c-iop3xx.h) to indicate this.  All of the users of this driver
have a platform memory resource so use resource_size() instead of
the magic number.  This requires fixing a couple of the memory
resources since they were either off by 1 or just wrong.

The private data member ioaddr should be a void __iomem *.  This
removes a couple unnecessary casts.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Dan Williams <dan.j.williams@intel.com>

---

diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index 5c147fb..e408a9e 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -124,7 +124,7 @@ static struct platform_device iop13xx_uart1 = {
 static struct resource iop13xx_i2c_0_resources[] = {
 	[0] = {
 		.start = IOP13XX_I2C0_PHYS,
-		.end = IOP13XX_I2C0_PHYS + 0x18,
+		.end = IOP13XX_I2C0_PHYS + 0x17,
 		.flags = IORESOURCE_MEM,
 	},
 	[1] = {
@@ -137,7 +137,7 @@ static struct resource iop13xx_i2c_0_resources[] = {
 static struct resource iop13xx_i2c_1_resources[] = {
 	[0] = {
 		.start = IOP13XX_I2C1_PHYS,
-		.end = IOP13XX_I2C1_PHYS + 0x18,
+		.end = IOP13XX_I2C1_PHYS + 0x17,
 		.flags = IORESOURCE_MEM,
 	},
 	[1] = {
@@ -150,7 +150,7 @@ static struct resource iop13xx_i2c_1_resources[] = {
 static struct resource iop13xx_i2c_2_resources[] = {
 	[0] = {
 		.start = IOP13XX_I2C2_PHYS,
-		.end = IOP13XX_I2C2_PHYS + 0x18,
+		.end = IOP13XX_I2C2_PHYS + 0x17,
 		.flags = IORESOURCE_MEM,
 	},
 	[1] = {
diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index cfd52fb..068319f 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -347,7 +347,7 @@ static struct platform_device *ixp4xx_devices[] __initdata = {
 static struct resource ixp46x_i2c_resources[] = {
 	[0] = {
 		.start 	= 0xc8011000,
-		.end	= 0xc801101c,
+		.end	= 0xc8011017,
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index 5901707..5378455 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -410,8 +410,8 @@ iop3xx_i2c_remove(struct platform_device *pdev)
 		IOP3XX_ICR_RXFULL_IE | IOP3XX_ICR_TXEMPTY_IE);
 	__raw_writel(cr, adapter_data->ioaddr + CR_OFFSET);
 
-	iounmap((void __iomem*)adapter_data->ioaddr);
-	release_mem_region(res->start, IOP3XX_I2C_IO_SIZE);
+	iounmap(adapter_data->ioaddr);
+	release_mem_region(res->start, resource_size(res));
 	kfree(adapter_data);
 	kfree(padapter);
 
@@ -446,7 +446,7 @@ iop3xx_i2c_probe(struct platform_device *pdev)
 		goto free_both;
 	}
 
-	if (!request_mem_region(res->start, IOP3XX_I2C_IO_SIZE, pdev->name)) {
+	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
 		ret = -EBUSY;
 		goto free_both;
 	}
@@ -454,7 +454,7 @@ iop3xx_i2c_probe(struct platform_device *pdev)
 	/* set the adapter enumeration # */
 	adapter_data->id = i2c_id++;
 
-	adapter_data->ioaddr = (u32)ioremap(res->start, IOP3XX_I2C_IO_SIZE);
+	adapter_data->ioaddr = ioremap(res->start, resource_size(res));
 	if (!adapter_data->ioaddr) {
 		ret = -ENOMEM;
 		goto release_region;
@@ -499,10 +499,10 @@ iop3xx_i2c_probe(struct platform_device *pdev)
 	return 0;
 
 unmap:
-	iounmap((void __iomem*)adapter_data->ioaddr);
+	iounmap(adapter_data->ioaddr);
 
 release_region:
-	release_mem_region(res->start, IOP3XX_I2C_IO_SIZE);
+	release_mem_region(res->start, resource_size(res));
 
 free_both:
 	kfree(adapter_data);
diff --git a/drivers/i2c/busses/i2c-iop3xx.h b/drivers/i2c/busses/i2c-iop3xx.h
index 8485861..eeba965 100644
--- a/drivers/i2c/busses/i2c-iop3xx.h
+++ b/drivers/i2c/busses/i2c-iop3xx.h
@@ -94,10 +94,8 @@
 #define	CCR_OFFSET		0x10
 #define	BMR_OFFSET		0x14
 
-#define	IOP3XX_I2C_IO_SIZE	0x18
-
 struct i2c_algo_iop3xx_data {
-	u32 ioaddr;
+	void __iomem *ioaddr;
 	wait_queue_head_t waitq;
 	spinlock_t lock;
 	u32 SR_enabled, SR_received; 
