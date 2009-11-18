Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbZKRSSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbZKRSSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbZKRSSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:18:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49215 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124AbZKRSSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:18:39 -0500
Date: Wed, 18 Nov 2009 19:18:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, San Mehat <san@google.com>,
       Iliyan Malchev <malchev@google.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Status of Dream series
Message-ID: <20091118181824.GK25150@elf.ucw.cz>
References: <20091111104748.GA26975@elf.ucw.cz>
 <1258135899.6411.7.camel@c-dwalke-linux.qualcomm.com>
 <20091118170238.GE20887@elf.ucw.cz>
 <1258537122.8014.2.camel@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258537122.8014.2.camel@ubuntu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Russell, what is the status of the "Dream" series? 
> > > > 
> > > >  [PATCH 1/3] msm: make debugging UART (for DEBUG_LL) configurable
> > > >  [PATCH 2/3] msm: add minimal board file for HTC Dream device
> > > >  [PATCH 3/3] msm: Add memory map for HTC Dream
> > > > 
> > > > Daniel Walker offered to maintain arch-msm tree, would that help? 
> > > 
> > > Yeah, I can do it for now, but I can't accept patches for it via this
> > > email address.. I'm in the processes of setting up the right address for
> > > it .. Might take till next week tho.
> > 
> > Ok, can I just add your acked-by, and send them to akpm/rmk? These
> > three are simple enough...
> 
> Didn't Russell have some pending comments? Anyway, I have them already
> in my korg git tree. So I can move them forward from there , but it's
> temporary ..

Here's fixed #2. I guess we can add rmk's reviewed-by (and yours?) and
send them forward?
								Pavel

---

This is just enough to get the device booting and serial console
working.  Sufficient for debugging further MSM7k/Dream Support.
This will support HTC Dream / T-Mobile G1 / Android ADP1 (which
are all the same hardware, known as "trout" to the ARM machine
database).

Signed-off-by: Brian Swetland <swetland@google.com>
Reviewed-by: GeunSik Lim <geunsik.lim@samsung.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

---
arch/arm/mach-msm/Kconfig       |    6 +++
 arch/arm/mach-msm/Makefile      |    1 +
 arch/arm/mach-msm/board-dream.c |   84 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/board-dream.h |    5 ++
 4 files changed, 96 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-dream.c
 create mode 100644 arch/arm/mach-msm/board-dream.h

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 35f2a90..f780086 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -34,4 +34,10 @@ config MACH_HALIBUT
 	help
 	  Support for the Qualcomm SURF7201A eval board.
 
+config MACH_TROUT
+	default y
+	bool "HTC Dream (aka trout)"
+	help
+	  Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
+
 endif
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 1aa4700..91e6f5c 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -6,3 +6,4 @@ obj-y += clock.o clock-7x01a.o
 
 obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o
 
+obj-$(CONFIG_MACH_TROUT) += board-dream.o
diff --git a/arch/arm/mach-msm/board-dream.c b/arch/arm/mach-msm/board-dream.c
new file mode 100644
index 0000000..6eae7e3
--- /dev/null
+++ b/arch/arm/mach-msm/board-dream.c
@@ -0,0 +1,82 @@
+/* linux/arch/arm/mach-msm/board-dream.c
+ *
+ * Copyright (C) 2009 Google, Inc.
+ * Author: Brian Swetland <swetland@google.com>
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
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+#include <mach/board.h>
+#include <mach/hardware.h>
+#include <mach/msm_iomap.h>
+
+#include "devices.h"
+#include "board-dream.h"
+
+static struct platform_device *devices[] __initdata = {
+	&msm_device_uart3,
+	&msm_device_smd,
+	&msm_device_nand,
+	&msm_device_hsusb,
+	&msm_device_i2c,
+};
+
+extern struct sys_timer msm_timer;
+
+static void __init trout_init_irq(void)
+{
+	msm_init_irq();
+}
+
+static void __init trout_init(void)
+{
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+}
+
+static struct map_desc trout_io_desc[] __initdata = {
+	{
+		.virtual = TROUT_CPLD_BASE,
+		.pfn     = __phys_to_pfn(TROUT_CPLD_START),
+		.length  = TROUT_CPLD_SIZE,
+		.type    = MT_DEVICE_NONSHARED
+	}
+};
+
+static void __init trout_map_io(void)
+{
+	msm_map_common_io();
+	iotable_init(trout_io_desc, ARRAY_SIZE(trout_io_desc));
+
+#ifdef CONFIG_MSM_DEBUG_UART3
+	/* route UART3 to the "H2W" extended usb connector */
+	writeb(0x80, TROUT_CPLD_BASE + 0x00);
+#endif
+
+	msm_clock_init();
+}
+
+MACHINE_START(TROUT, "HTC Dream")
+	.phys_io	= MSM_DEBUG_UART_PHYS,
+	.io_pg_offst	= ((MSM_DEBUG_UART_BASE) >> 18) & 0xfffc,
+	.boot_params	= 0x10000100,
+	.map_io		= trout_map_io,
+	.init_irq	= trout_init_irq,
+	.init_machine	= trout_init,
+	.timer		= &msm_timer,
+MACHINE_END
diff --git a/arch/arm/mach-msm/board-dream.h b/arch/arm/mach-msm/board-dream.h
new file mode 100644
index 0000000..4f345a5
--- /dev/null
+++ b/arch/arm/mach-msm/board-dream.h
@@ -0,0 +1,5 @@
+
+#define TROUT_CPLD_BASE   0xE8100000
+#define TROUT_CPLD_START  0x98000000
+#define TROUT_CPLD_SIZE   SZ_4K
+

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
