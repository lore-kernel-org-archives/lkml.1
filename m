Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYJMJnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYJMJnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760595AbYJMJgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:36:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48621 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759331AbYJMJgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:36:35 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 29/80] serial: allow 8250 to be used on sparc
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:36:31 +0100
Message-ID: <20081013093626.21645.81444.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

This requires three changes:

1) Remove !SPARC restriction in Kconfig.

2) Move Sparc specific serial drivers before 8250, so that serial
   console devices don't change names on us, even if 8250 finds
   devices.

3) Since the Sparc specific serial drivers try to use the
   same major/minor device namespace as 8250, some coordination
   is necessary.  Use the sunserial_*() layer routines to allocate
   minor number space within TTY_MAJOR when CONFIG_SPARC.

   This has no effect on other platforms.

Thanks to Josip Rodin for bringing up this issue and testing
plus debugging various revisions of this patch.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 arch/sparc/include/asm/serial.h |    6 ++++++
 drivers/serial/8250.c           |   21 +++++++++++++++++----
 drivers/serial/Kconfig          |    1 -
 drivers/serial/Makefile         |   15 ++++++++++-----
 4 files changed, 33 insertions(+), 10 deletions(-)
 create mode 100644 arch/sparc/include/asm/serial.h


diff --git a/arch/sparc/include/asm/serial.h b/arch/sparc/include/asm/serial.h
new file mode 100644
index 0000000..f90d61c
--- /dev/null
+++ b/arch/sparc/include/asm/serial.h
@@ -0,0 +1,6 @@
+#ifndef __SPARC_SERIAL_H
+#define __SPARC_SERIAL_H
+
+#define BASE_BAUD ( 1843200 / 16 )
+
+#endif /* __SPARC_SERIAL_H */
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index ed593c4..db2cdc1 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -44,6 +44,10 @@
 
 #include "8250.h"
 
+#ifdef CONFIG_SPARC
+#include "suncore.h"
+#endif
+
 /*
  * Configuration:
  *   share_irqs - whether we pass IRQF_SHARED to request_irq().  This option
@@ -2676,7 +2680,6 @@ static struct uart_driver serial8250_reg = {
 	.dev_name		= "ttyS",
 	.major			= TTY_MAJOR,
 	.minor			= 64,
-	.nr			= UART_NR,
 	.cons			= SERIAL8250_CONSOLE,
 };
 
@@ -2958,10 +2961,12 @@ static int __init serial8250_init(void)
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
-	for (i = 0; i < NR_IRQS; i++)
-		spin_lock_init(&irq_lists[i].lock);
-
+#ifdef CONFIG_SPARC
+	ret = sunserial_register_minors(&serial8250_reg, UART_NR);
+#else
+	serial8250_reg.nr = UART_NR;
 	ret = uart_register_driver(&serial8250_reg);
+#endif
 	if (ret)
 		goto out;
 
@@ -2986,7 +2991,11 @@ static int __init serial8250_init(void)
  put_dev:
 	platform_device_put(serial8250_isa_devs);
  unreg_uart_drv:
+#ifdef CONFIG_SPARC
+	sunserial_unregister_minors(&serial8250_reg, UART_NR);
+#else
 	uart_unregister_driver(&serial8250_reg);
+#endif
  out:
 	return ret;
 }
@@ -3005,7 +3014,11 @@ static void __exit serial8250_exit(void)
 	platform_driver_unregister(&serial8250_isa_driver);
 	platform_device_unregister(isa_dev);
 
+#ifdef CONFIG_SPARC
+	sunserial_unregister_minors(&serial8250_reg, UART_NR);
+#else
 	uart_unregister_driver(&serial8250_reg);
+#endif
 }
 
 module_init(serial8250_init);
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 0db2045..31786b3 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -9,7 +9,6 @@ menu "Serial drivers"
 # The new 8250/16550 serial drivers
 config SERIAL_8250
 	tristate "8250/16550 and compatible serial support"
-	depends on (BROKEN || !SPARC)
 	select SERIAL_CORE
 	---help---
 	  This selects whether you want to include the driver for the standard
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index 1462eb3..0c17c8d 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -4,6 +4,16 @@
 
 obj-$(CONFIG_SERIAL_CORE) += serial_core.o
 obj-$(CONFIG_SERIAL_21285) += 21285.o
+
+# These Sparc drivers have to appear before others such as 8250
+# which share ttySx minor node space.  Otherwise console device
+# names change and other unplesantries.
+obj-$(CONFIG_SERIAL_SUNCORE) += suncore.o
+obj-$(CONFIG_SERIAL_SUNHV) += sunhv.o
+obj-$(CONFIG_SERIAL_SUNZILOG) += sunzilog.o
+obj-$(CONFIG_SERIAL_SUNSU) += sunsu.o
+obj-$(CONFIG_SERIAL_SUNSAB) += sunsab.o
+
 obj-$(CONFIG_SERIAL_8250) += 8250.o
 obj-$(CONFIG_SERIAL_8250_PNP) += 8250_pnp.o
 obj-$(CONFIG_SERIAL_8250_GSC) += 8250_gsc.o
@@ -31,12 +41,7 @@ obj-$(CONFIG_SERIAL_S3C2400) += s3c2400.o
 obj-$(CONFIG_SERIAL_S3C2410) += s3c2410.o
 obj-$(CONFIG_SERIAL_S3C2412) += s3c2412.o
 obj-$(CONFIG_SERIAL_S3C2440) += s3c2440.o
-obj-$(CONFIG_SERIAL_SUNCORE) += suncore.o
-obj-$(CONFIG_SERIAL_SUNHV) += sunhv.o
-obj-$(CONFIG_SERIAL_SUNZILOG) += sunzilog.o
 obj-$(CONFIG_SERIAL_IP22_ZILOG) += ip22zilog.o
-obj-$(CONFIG_SERIAL_SUNSU) += sunsu.o
-obj-$(CONFIG_SERIAL_SUNSAB) += sunsab.o
 obj-$(CONFIG_SERIAL_MUX) += mux.o
 obj-$(CONFIG_SERIAL_68328) += 68328serial.o
 obj-$(CONFIG_SERIAL_68360) += 68360serial.o

