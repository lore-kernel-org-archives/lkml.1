Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbYHFNY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbYHFNY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbYHFNUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:20:11 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:53655 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754073AbYHFNUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:20:04 -0400
From: Marc Zyngier <maz@misterjones.org>
To: linux-kernel@vger.kernel.org
Cc: Amit Walambe <amit.walambe@eurotech-ltd.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Marc Zyngier <maz@misterjones.org>,
       Marc Zyngier <marc.zyngier@altran.com>
Subject: [PATCH 4/5] Add support for the Arcom/Eurotech Viper SBC CompactFlash card slot.
Date: Wed,  6 Aug 2008 15:19:53 +0200
Message-Id: <1ab30e3a57088af0e4c578dd0be728a4533fd9a4.1218018637.git.marc.zyngier@altran.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <b6f70421a31e59e19a0aaa79d068fa34876e60b7.1218018637.git.marc.zyngier@altran.com>
References: <>
 <1218028794-850-1-git-send-email-maz@misterjones.org>
 <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
 <15b4632ba095731c7c6c384de0698e2ef84fa775.1218018637.git.marc.zyngier@altran.com>
 <b6f70421a31e59e19a0aaa79d068fa34876e60b7.1218018637.git.marc.zyngier@altran.com>
In-Reply-To: <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
References: <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
X-SA-Exim-Connect-IP: 81.255.32.141
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, amit.walambe@eurotech-ltd.co.uk, linux@dominikbrodowski.net, maz@misterjones.org, marc.zyngier@altran.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>
---
 drivers/pcmcia/Kconfig        |    2 +-
 drivers/pcmcia/Makefile       |    1 +
 drivers/pcmcia/pxa2xx_viper.c |  183 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 185 insertions(+), 1 deletions(-)
 create mode 100644 drivers/pcmcia/pxa2xx_viper.c

diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index e0f8840..de57e7e 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -220,7 +220,7 @@ config PCMCIA_PXA2XX
 	tristate "PXA2xx support"
 	depends on ARM && ARCH_PXA && PCMCIA
 	depends on (ARCH_LUBBOCK || MACH_MAINSTONE || PXA_SHARPSL \
-		    || MACH_ARMCORE || ARCH_PXA_PALM)
+		    || MACH_ARMCORE || ARCH_PXA_PALM || ARCH_VIPER)
 	help
 	  Say Y here to include support for the PXA2xx PCMCIA controller
 
diff --git a/drivers/pcmcia/Makefile b/drivers/pcmcia/Makefile
index 269a9e9..76e8590 100644
--- a/drivers/pcmcia/Makefile
+++ b/drivers/pcmcia/Makefile
@@ -72,5 +72,6 @@ pxa2xx_cs-$(CONFIG_ARCH_LUBBOCK)		+= pxa2xx_lubbock.o sa1111_generic.o
 pxa2xx_cs-$(CONFIG_MACH_MAINSTONE)		+= pxa2xx_mainstone.o
 pxa2xx_cs-$(CONFIG_PXA_SHARPSL)			+= pxa2xx_sharpsl.o
 pxa2xx_cs-$(CONFIG_MACH_ARMCORE)		+= pxa2xx_cm_x270.o
+pxa2xx_cs-$(CONFIG_ARCH_VIPER)			+= pxa2xx_viper.o
 pxa2xx_cs-$(CONFIG_MACH_PALMTX)		+= pxa2xx_palmtx.o
 
diff --git a/drivers/pcmcia/pxa2xx_viper.c b/drivers/pcmcia/pxa2xx_viper.c
new file mode 100644
index 0000000..9ac96c3
--- /dev/null
+++ b/drivers/pcmcia/pxa2xx_viper.c
@@ -0,0 +1,183 @@
+/*
+ * VIPER PCMCIA support
+ *   Copyright 2004 Arcom Control Systems
+ *
+ * Maintained by Marc Zyngier <maz@misterjones.org>
+ * 			      <marc.zyngier@altran.com>
+ *
+ * Based on:
+ *   iPAQ h2200 PCMCIA support
+ *   Copyright 2004 Koen Kooi <koen@vestingbar.nl>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive for
+ * more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+
+#include <pcmcia/ss.h>
+
+#include <asm/hardware.h>
+#include <asm/irq.h>
+
+#include <asm/arch/pxa-regs.h>
+#include <asm/arch/viper.h>
+
+#include "soc_common.h"
+#include "pxa2xx_base.h"
+
+static void viper_cf_rst(int state)
+{
+	if (state)
+		viper_icr_set_bit(VIPER_ICR_CF_RST);
+	else
+		viper_icr_clear_bit(VIPER_ICR_CF_RST);
+
+}
+
+static struct pcmcia_irqs irqs[] = {
+	{ 0, VIPER_CF_CD_IRQ,  "PCMCIA_CD" }
+};
+
+static int viper_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
+{
+	unsigned long flags;
+
+	skt->irq = VIPER_CF_RDY_IRQ;
+
+	if (gpio_request(VIPER_CF_CD_GPIO, "CF detect"))
+		goto err_request_cd;
+
+	if (gpio_request(VIPER_CF_RDY_GPIO, "CF ready"))
+		goto err_request_rdy;
+
+	if (gpio_request(VIPER_CF_POWER_GPIO, "CF power"))
+		goto err_request_pwr;
+
+	local_irq_save(flags);
+
+	/* GPIO 82 is the CF power enable line. initially off */
+	if (gpio_direction_output(VIPER_CF_POWER_GPIO, 0) ||
+	    gpio_direction_input(VIPER_CF_CD_GPIO) ||
+	    gpio_direction_input(VIPER_CF_RDY_GPIO)) {
+		local_irq_restore(flags);
+		goto err_dir;
+	}
+
+	local_irq_restore(flags);
+
+	return soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
+
+err_dir:
+	gpio_free(VIPER_CF_POWER_GPIO);
+err_request_pwr:
+	gpio_free(VIPER_CF_RDY_GPIO);
+err_request_rdy:
+	gpio_free(VIPER_CF_CD_GPIO);
+err_request_cd:
+	printk(KERN_ERR "viper: Failed to setup PCMCIA GPIOs\n");
+	return -1;
+}
+
+/*
+ * Release all resources.
+ */
+static void viper_pcmcia_hw_shutdown(struct soc_pcmcia_socket *skt)
+{
+	soc_pcmcia_free_irqs(skt, irqs, ARRAY_SIZE(irqs));
+	gpio_free(VIPER_CF_POWER_GPIO);
+	gpio_free(VIPER_CF_RDY_GPIO);
+	gpio_free(VIPER_CF_CD_GPIO);
+}
+
+static void viper_pcmcia_socket_state(struct soc_pcmcia_socket *skt,
+				      struct pcmcia_state *state)
+{
+	state->detect = gpio_get_value(VIPER_CF_CD_GPIO) ? 0 : 1;
+	state->ready  = gpio_get_value(VIPER_CF_RDY_GPIO) ? 1 : 0;
+	state->bvd1   = 1;
+	state->bvd2   = 1;
+	state->wrprot = 0;
+	state->vs_3v  = 1; /* Can only apply 3.3V */
+	state->vs_Xv  = 0;
+}
+
+static int viper_pcmcia_configure_socket(struct soc_pcmcia_socket *skt,
+					 const socket_state_t *state)
+{
+	/* Silently ignore Vpp, output enable, speaker enable. */
+	viper_cf_rst(state->flags & SS_RESET);
+
+	/* Apply socket voltage */
+	switch (state->Vcc) {
+	case 0:
+		gpio_set_value(VIPER_CF_POWER_GPIO, 0);
+		break;
+	case 33:
+		gpio_set_value(VIPER_CF_POWER_GPIO, 1);
+		break;
+	default:
+		printk(KERN_ERR "%s: Unsupported Vcc:%d\n",
+		       __func__, state->Vcc);
+		return -1;
+	}
+
+	return 0;
+}
+
+static void viper_pcmcia_socket_init(struct soc_pcmcia_socket *skt)
+{
+}
+
+static void viper_pcmcia_socket_suspend(struct soc_pcmcia_socket *skt)
+{
+}
+
+static struct pcmcia_low_level viper_pcmcia_ops = {
+	.owner          	= THIS_MODULE,
+	.hw_init        	= viper_pcmcia_hw_init,
+	.hw_shutdown		= viper_pcmcia_hw_shutdown,
+	.socket_state		= viper_pcmcia_socket_state,
+	.configure_socket	= viper_pcmcia_configure_socket,
+	.socket_init		= viper_pcmcia_socket_init,
+	.socket_suspend		= viper_pcmcia_socket_suspend,
+	.nr         		= 1,
+	.quirks			= PXA2XX_QUIRK_NEEDS_MECR_NOS,
+};
+
+static struct platform_device *viper_pcmcia_device;
+
+static int __init viper_pcmcia_init(void)
+{
+	int ret;
+
+	viper_pcmcia_device = platform_device_alloc("pxa2xx-pcmcia", -1);
+	if (!viper_pcmcia_device)
+		return -ENOMEM;
+
+	viper_pcmcia_device->dev.platform_data = &viper_pcmcia_ops;
+
+	ret = platform_device_add(viper_pcmcia_device);
+
+	if (ret)
+		platform_device_put(viper_pcmcia_device);
+
+	return ret;
+}
+
+static void __exit viper_pcmcia_exit(void)
+{
+	platform_device_unregister(viper_pcmcia_device);
+}
+
+module_init(viper_pcmcia_init);
+module_exit(viper_pcmcia_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.5.4.3

