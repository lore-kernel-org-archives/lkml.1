Return-Path: <linux-kernel-owner+w=401wt.eu-S933906AbXGYQxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906AbXGYQxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765711AbXGYQxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:53:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:50073 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765218AbXGYQxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:53:32 -0400
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
From: Vitaly Bordug <vitb@kernel.crashing.org>
Subject: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver for CF
	interface
Date: Wed, 25 Jul 2007 20:53:26 +0400
Message-ID: <20070725165326.5331.19920.stgit@localhost.localdomain>
In-Reply-To: <20070725165318.5331.23795.stgit@localhost.localdomain>
References: <20070725165318.5331.23795.stgit@localhost.localdomain>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This updates relevant platform code (freescale mpc8349itx target) 
to make the CompactFlash work in TrueIDE mode. 

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

---

 arch/powerpc/boot/dts/mpc8349emitx.dts    |    9 ++++
 arch/powerpc/platforms/83xx/mpc834x_itx.c |   70 +++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/mpc8349emitx.dts b/arch/powerpc/boot/dts/mpc8349emitx.dts
index db0d003..f8f0e8a 100644
--- a/arch/powerpc/boot/dts/mpc8349emitx.dts
+++ b/arch/powerpc/boot/dts/mpc8349emitx.dts
@@ -37,6 +37,15 @@
 		reg = <00000000 10000000>;
 	};
 
+	ide@f0000000 {
+		compatible = "mmio-ide";
+		device_type = "ide";
+		reg = <f0000000 10 f000020c 4>;
+		ioport_shift = <1>;
+		interrupts = <17 8>;
+		interrupt-parent = < &ipic >;
+	};
+
 	soc8349@e0000000 {
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/powerpc/platforms/83xx/mpc834x_itx.c b/arch/powerpc/platforms/83xx/mpc834x_itx.c
index 40a0194..d63a104 100644
--- a/arch/powerpc/platforms/83xx/mpc834x_itx.c
+++ b/arch/powerpc/platforms/83xx/mpc834x_itx.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
+#include <linux/pata_platform.h>
 
 #include <asm/system.h>
 #include <asm/atomic.h>
@@ -43,6 +44,75 @@ unsigned long isa_io_base = 0;
 unsigned long isa_mem_base = 0;
 #endif
 
+static int __init mmio_ide_of_init(void)
+{
+	struct device_node *np;
+	unsigned int i;
+
+	for (np = NULL, i = 0;
+	     (np = of_find_compatible_node(np, "ide", "mmio-ide")) != NULL;
+	     i++) {
+		int ret = 0;
+		struct resource res[3];
+		struct platform_device *pdev = NULL;
+		static struct pata_platform_info pdata;
+
+		memset(res, 0, sizeof(res));
+
+		ret = of_address_to_resource(np, 0, &res[0]);
+		if (ret) {
+			printk(KERN_ERR "mmio-ide.%d: unable to get "
+			       "resource from OF\n", i);
+			goto err0;
+		}
+
+		ret = of_address_to_resource(np, 1, &res[1]);
+		if (ret) {
+			printk(KERN_ERR "mmio-ide.%d: unable to get "
+			       "resource from OF\n", i);
+			goto err0;
+		}
+
+		res[2].start = res[2].end = irq_of_parse_and_map(np, 0);
+		if (res[2].start == NO_IRQ) {
+			printk(KERN_ERR "mmio-ide.%d: no IRQ\n", i);
+			goto err0;
+		}
+		res[2].name = "pata_platform";
+		res[2].flags = IORESOURCE_IRQ;
+
+		pdata.ioport_shift = *((u32 *)of_get_property(np,
+					"ioport_shift", NULL));
+
+		pdev = platform_device_alloc("pata_platform", i);
+		if (!pdev)
+			goto err1;
+
+		ret = platform_device_add_data(pdev, &pdata, sizeof(pdata));
+		if (ret)
+			goto err1;
+
+		ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
+		if (ret)
+			goto err1;
+
+		ret = platform_device_register(pdev);
+		if (ret)
+			goto err1;
+
+		continue;
+err1:
+		printk(KERN_ERR "mmio-ide.%d: registration failed\n", i);
+		platform_device_del(pdev); /* it will free everything */
+err0:
+		/* Even if some device failed, try others */
+		continue;
+	}
+
+	return 0;
+}
+device_initcall(mmio_ide_of_init);
+
 /* ************************************************************************
  *
  * Setup the architecture

