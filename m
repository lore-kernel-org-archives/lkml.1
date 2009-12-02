Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZLBBQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZLBBQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZLBBQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:16:19 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:36755 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753221AbZLBBQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:16:18 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] add PATA host controller support for Cirrus Logic's EP93xx CPUs
Date: Tue, 1 Dec 2009 20:16:21 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB03AB@mi8nycmail19.Mi8.com>
In-Reply-To: <200912020206.59659.bzolnier@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] add PATA host controller support for Cirrus Logic's EP93xx CPUs
Thread-Index: Acpy6+WcLqERhlINQCOTmR8AvofUuQAAG3zg
References: <200911261651.40928.bzolnier@gmail.com> <4B15BAA1.2010408@bluewatersys.com> <200912020206.59659.bzolnier@gmail.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Ryan Mallon" <ryan@bluewatersys.com>
Cc: <linux-ide@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>,
       "Sergei Shtylyov" <sshtylyov@ru.montavista.com>,
       "Joao Ramos" <joao.ramos@inov.pt>
X-OriginalArrivalTime: 02 Dec 2009 01:16:23.0411 (UTC) FILETIME=[0FF68430:01CA72ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 01, 2009 6:07 PM, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 02 December 2009 01:53:53 am Ryan Mallon wrote:
>> Bartlomiej Zolnierkiewicz wrote:
>>> Based on the older IDE host driver by Joao Ramos and review comments
>>> for it from Sergei Shtylyov.  Not yet tested with the real hardware.
>>>
>> 
>> Hi Bartlomiej,
>> 
>> I have got as far as patching this into my kernel and doing a build test
>> (still need to find a hard-disk to test). I got some build errors, see
>> below:
>
> Hi,
>
> Many thanks for picking this driver up.
>
> The following preparatory libata one-liner is needed to make it build:
>
>	http://patchwork.kernel.org/patch/62926/
>
> and you may also need to update ep93xx ide gpio patch:
>
>	http://thread.gmane.org/gmane.linux.ports.arm.kernel/57688/focus=58730
>
> to current kernels to make the hardware work.

Ryan,

I updated the core parts of this patch with the ide gpio stuff.  This will
patch cleanly to 2.6.32-rc8 but will have problems after the 2.6.33 merge
due to the core keypad support already in Russell's tree.

But, for what it's worth....

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index b4357c3..7c12c71 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -728,6 +728,91 @@ void __init ep93xx_register_fb(struct ep93xxfb_mach_info *data)
 	platform_device_register(&ep93xx_fb_device);
 }
 
+
+/*************************************************************************
+ * EP93xx ide peripheral handling
+ *************************************************************************/
+static struct resource ep93xx_ide_resources[] = {
+	{
+		.start	= EP93XX_IDE_PHYS_BASE,
+		.end	= EP93XX_IDE_PHYS_BASE + 0x38 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= IRQ_EP93XX_EXT3,
+		.end	= IRQ_EP93XX_EXT3,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device ep93xx_ide_device = {
+	.name		= "ep93xx-ide",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(ep93xx_ide_resources),
+	.resource	= ep93xx_ide_resources,
+};
+
+void __init ep93xx_register_ide(void)
+{
+	platform_device_register(&ep93xx_ide_device);
+}
+
+int ep93xx_ide_aquire_gpio(struct platform_device *pdev)
+{
+	int i, err;
+
+	for (i = 0; i < 8; i++) {
+		err = gpio_request(EP93XX_GPIO_LINE_E(i),
+				   dev_name(&pdev->dev));
+		if (err)
+			goto fail_gpio_e;
+		err = gpio_request(EP93XX_GPIO_LINE_F(i),
+				   dev_name(&pdev->dev));
+		if (err)
+			goto fail_gpio_f;
+		err = gpio_request(EP93XX_GPIO_LINE_G(i),
+				   dev_name(&pdev->dev));
+		if (err)
+			goto fail_gpio_g;
+	}
+
+	ep93xx_devcfg_clear_bits(EP93XX_SYSCON_DEVCFG_EONIDE |
+				 EP93XX_SYSCON_DEVCFG_GONIDE |
+				 EP93XX_SYSCON_DEVCFG_HONIDE);
+
+	return 0;
+
+fail_gpio_g:
+	gpio_free(EP93XX_GPIO_LINE_F(i));
+fail_gpio_f:
+	gpio_free(EP93XX_GPIO_LINE_E(i));
+fail_gpio_e:
+	for ( ; i >= 0; --i) {
+		gpio_free(EP93XX_GPIO_LINE_E(i));
+		gpio_free(EP93XX_GPIO_LINE_F(i));
+		gpio_free(EP93XX_GPIO_LINE_G(i));
+	}
+	return err;
+}
+EXPORT_SYMBOL(ep93xx_ide_aquire_gpio);
+
+void ep93xx_ide_release_gpio(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		gpio_free(EP93XX_GPIO_LINE_E(i));
+		gpio_free(EP93XX_GPIO_LINE_F(i));
+		gpio_free(EP93XX_GPIO_LINE_G(i));
+	}
+
+	ep93xx_devcfg_set_bits(EP93XX_SYSCON_DEVCFG_EONIDE |
+			       EP93XX_SYSCON_DEVCFG_GONIDE |
+			       EP93XX_SYSCON_DEVCFG_HONIDE);
+}
+EXPORT_SYMBOL(ep93xx_ide_release_gpio);
+
+
 extern void ep93xx_gpio_init(void);
 
 void __init ep93xx_init_devices(void)
diff --git a/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h b/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
index b1f937e..bda1930 100644
--- a/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
+++ b/arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h
@@ -83,6 +83,7 @@
 
 #define EP93XX_BOOT_ROM_BASE		EP93XX_AHB_IOMEM(0x00090000)
 
+#define EP93XX_IDE_PHYS_BASE		EP93XX_AHB_PHYS(0x000a0000)
 #define EP93XX_IDE_BASE			EP93XX_AHB_IOMEM(0x000a0000)
 
 #define EP93XX_VIC1_BASE		EP93XX_AHB_IOMEM(0x000b0000)
diff --git a/arch/arm/mach-ep93xx/include/mach/platform.h b/arch/arm/mach-ep93xx/include/mach/platform.h
index 469fd96..43e8f4d 100644
--- a/arch/arm/mach-ep93xx/include/mach/platform.h
+++ b/arch/arm/mach-ep93xx/include/mach/platform.h
@@ -39,6 +39,9 @@ void ep93xx_register_fb(struct ep93xxfb_mach_info *data);
 void ep93xx_register_pwm(int pwm0, int pwm1);
 int ep93xx_pwm_acquire_gpio(struct platform_device *pdev);
 void ep93xx_pwm_release_gpio(struct platform_device *pdev);
+void ep93xx_register_ide(void);
+int ep93xx_ide_aquire_gpio(struct platform_device *pdev);
+void ep93xx_ide_release_gpio(struct platform_device *pdev);
 
 void ep93xx_init_devices(void);
 extern struct sys_timer ep93xx_timer; 
