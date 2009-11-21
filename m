Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZKUIQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZKUIQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 03:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZKUIQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 03:16:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57144 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZKUIQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 03:16:31 -0500
Date: Sat, 21 Nov 2009 09:16:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, Greg KH <greg@kroah.com>
Subject: [PATCH 2/3] staging/dream: Add final missing bits
Message-ID: <20091121081633.GB2597@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds final missing bits that allow drivers/staging to
compile. It replaces depends on BROKEN with depends on ARCH_MSM; that
way selecting generic_gpio should no longer cause problems.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/dream/Kconfig b/drivers/staging/dream/Kconfig
index 4afa081..ec9eb6f 100644
--- a/drivers/staging/dream/Kconfig
+++ b/drivers/staging/dream/Kconfig
@@ -1,16 +1,51 @@
 config DREAM
        tristate "HTC Dream support"
-       depends on BROKEN
+       depends on ARCH_MSM
 
 source "drivers/staging/dream/smd/Kconfig"
 
 source "drivers/staging/dream/camera/Kconfig"
 
+config MSM_AMSS_VERSION
+	int
+	default 6210 if MSM_AMSS_VERSION_6210
+	default 6220 if MSM_AMSS_VERSION_6220
+	default 6225 if MSM_AMSS_VERSION_6225
+	default 6350 if MSM_AMSS_VERSION_6350
+
+choice
+	prompt "AMSS modem firmware version"
+
+	default MSM_AMSS_VERSION_6225
+
+	config MSM_AMSS_VERSION_6210
+		bool "6.2.10"
+
+	config MSM_AMSS_VERSION_6220
+		bool "6.2.20"
+
+	config MSM_AMSS_VERSION_6225
+		bool "6.2.20 + New ADSP"
+
+	config MSM_AMSS_VERSION_6350
+		bool "6.3.50"
+endchoice
+
+config MSM_ADSP
+	tristate "MSM ADSP driver"
+	default y
+	help
+	  Provides access to registers needed by the userspace aDSP library.
 
 config INPUT_GPIO
 	tristate "GPIO driver support"
 	help
 	  Say Y here if you want to support gpio based keys, wheels etc...
 
+config GENERIC_GPIO
+	bool
+	default y
 
-
+config ANDROID_PMEM
+	bool "Android pmem allocator"
+	default y
diff --git a/drivers/staging/dream/Makefile b/drivers/staging/dream/Makefile
index 2b79151..f1e0429 100644
--- a/drivers/staging/dream/Makefile
+++ b/drivers/staging/dream/Makefile
@@ -1,4 +1,7 @@
+EXTRA_CFLAGS=-Idrivers/staging/dream/include
 obj-$(CONFIG_MSM_ADSP)		+= qdsp5/ smd/
 obj-$(CONFIG_MSM_CAMERA)	+= camera/
 obj-$(CONFIG_INPUT_GPIO)	+= gpio_axis.o gpio_event.o gpio_input.o gpio_matrix.o gpio_output.o
+obj-$(CONFIG_ANDROID_PMEM)	+= pmem.o
+obj-y				+= generic_gpio.o
 
diff --git a/drivers/staging/dream/camera/mt9t013.c b/drivers/staging/dream/camera/mt9t013.c
index 88229f2..ecb4866 100644
--- a/drivers/staging/dream/camera/mt9t013.c
+++ b/drivers/staging/dream/camera/mt9t013.c
@@ -9,7 +9,7 @@
 #include <linux/miscdevice.h>
 #include <linux/kernel.h>
 #include <media/msm_camera.h>
-#include <mach/gpio.h>
+#include <linux/gpio.h>
 #include <mach/camera.h>
 #include <asm/mach-types.h>
 #include "mt9t013.h"
diff --git a/drivers/staging/dream/gpio_chip.h b/drivers/staging/dream/gpio_chip.h
new file mode 100644
index 0000000..eab9f09
--- /dev/null
+++ b/drivers/staging/dream/gpio_chip.h
@@ -0,0 +1,38 @@
+/* arch/arm/mach-msm/gpio_chip.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_GPIO_CHIP_H
+#define _LINUX_GPIO_CHIP_H
+
+#include <linux/list.h>
+
+struct gpio_chip {
+	struct list_head list;
+	struct gpio_state *state;
+
+	unsigned int start;
+	unsigned int end;
+
+	int (*configure)(struct gpio_chip *chip, unsigned int gpio, unsigned long flags);
+	int (*get_irq_num)(struct gpio_chip *chip, unsigned int gpio, unsigned int *irqp, unsigned long *irqnumflagsp);
+	int (*read)(struct gpio_chip *chip, unsigned int gpio);
+	int (*write)(struct gpio_chip *chip, unsigned int gpio, unsigned on);
+	int (*read_detect_status)(struct gpio_chip *chip, unsigned int gpio);
+	int (*clear_detect_status)(struct gpio_chip *chip, unsigned int gpio);
+};
+
+int register_gpio_chip(struct gpio_chip *gpio_chip);
+
+#endif
diff --git a/drivers/staging/dream/include/mach/gpio.h b/drivers/staging/dream/include/mach/gpio.h
new file mode 100644
index 0000000..590573f
--- /dev/null
+++ b/drivers/staging/dream/include/mach/gpio.h
@@ -0,0 +1,47 @@
+/* linux/include/asm-arm/arch-msm/gpio.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ASM_ARCH_MSM_GPIO_H
+#define __ASM_ARCH_MSM_GPIO_H
+
+#include <linux/interrupt.h>
+
+int gpio_request(unsigned gpio, const char *label);
+void gpio_free(unsigned gpio);
+int gpio_direction_input(unsigned gpio);
+int gpio_direction_output(unsigned gpio, int value);
+int gpio_get_value(unsigned gpio);
+void gpio_set_value(unsigned gpio, int value);
+int gpio_to_irq(unsigned gpio);
+
+#include <asm-generic/gpio.h>
+
+/* extended gpio api */
+
+#define GPIOF_IRQF_MASK         0x0000ffff /* use to specify edge detection without */
+#define GPIOF_IRQF_TRIGGER_NONE 0x00010000 /* IRQF_TRIGGER_NONE is 0 which also means "as already configured" */
+#define GPIOF_INPUT             0x00020000
+#define GPIOF_DRIVE_OUTPUT      0x00040000
+#define GPIOF_OUTPUT_LOW        0x00080000
+#define GPIOF_OUTPUT_HIGH       0x00100000
+
+#define GPIOIRQF_SHARED         0x00000001 /* the irq line is shared with other inputs */
+
+extern int gpio_configure(unsigned int gpio, unsigned long flags);
+extern int gpio_read_detect_status(unsigned int gpio);
+extern int gpio_clear_detect_status(unsigned int gpio);
+
+#endif
diff --git a/drivers/staging/dream/qdsp5/adsp.c b/drivers/staging/dream/qdsp5/adsp.c
index 9069535..1fab9ce 100644
--- a/drivers/staging/dream/qdsp5/adsp.c
+++ b/drivers/staging/dream/qdsp5/adsp.c
@@ -45,6 +45,7 @@ static inline void allow_suspend(void)
 #include "adsp.h"
 
 #define INT_ADSP INT_ADSP_A9_A11
+#define MSM_AD5_BASE          IOMEM(0xE0300000)
 
 static struct adsp_info adsp_info;
 static struct msm_rpc_endpoint *rpc_cb_server_client;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
