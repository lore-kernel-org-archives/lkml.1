Return-Path: <linux-kernel-owner+w=401wt.eu-S964813AbXC3LIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813AbXC3LIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 07:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965084AbXC3LIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 07:08:15 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3708 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964813AbXC3LIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 07:08:14 -0400
Date: Fri, 30 Mar 2007 12:08:00 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: [RFC] pata_platform for ARM RiscPC
Message-ID: <20070330110800.GB21653@flint.arm.linux.org.uk>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Garzik <jgarzik@pobox.com>
References: <20070330110022.GA21653@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330110022.GA21653@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add pata_platform device for RiscPC, thereby converting the primary
IDE channel on the machine to PATA.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---

Since this is dependent on the previous patch (to avoid build errors)
this needs to wait until the devm_ioport patch is merged.  I'll
therefore push this through the ARM tree at the appropriate time.

 arch/arm/mach-rpc/riscpc.c |   35 +++++++++++++++++++++++++++++++++++
 drivers/ata/Kconfig        |    2 +-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-rpc/riscpc.c b/arch/arm/mach-rpc/riscpc.c
index 208a2b5..711a2db 100644
--- a/arch/arm/mach-rpc/riscpc.c
+++ b/arch/arm/mach-rpc/riscpc.c
@@ -17,6 +17,7 @@
 #include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/serial_8250.h>
+#include <linux/pata_platform.h>
 
 #include <asm/elf.h>
 #include <asm/io.h>
@@ -159,11 +160,45 @@ static struct plat_serial8250_port serial_platform_data[] = {
 	},
 };
 
+static struct pata_platform_info pata_platform_data = {
+	.ioport_shift		= 2,
+};
+
+static struct resource pata_resources[] = {
+	[0] = {
+		.start		= 0x030107c0,
+		.end		= 0x030107df,
+		.flags		= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start		= 0x03010fd8,
+		.end		= 0x03010fdb,
+		.flags		= IORESOURCE_MEM,
+	},
+	[2] = {
+		.start		= IRQ_HARDDISK,
+		.end		= IRQ_HARDDISK,
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device pata_device = {
+	.name			= "pata_platform",
+	.id			= -1,
+	.num_resources		= ARRAY_SIZE(pata_resources),
+	.resource		= pata_resources,
+	.dev			= {
+		.platform_data	= &pata_platform_data,
+		.coherent_dma_mask = ~0,	/* grumble */
+	},
+};
+
 static struct platform_device *devs[] __initdata = {
 	&iomd_device,
 	&kbd_device,
 	&serial_device,
 	&acornfb_device,
+	&pata_device,
 };
 
 static int __init rpc_init(void)
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index d16b5b0..d8a9758 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -545,7 +545,7 @@ config PATA_WINBOND_VLB
 
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
-	depends on EMBEDDED
+	depends on EMBEDDED || ARCH_RPC
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
