Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbYIMETx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbYIMETx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 00:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbYIMETP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 00:19:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34984
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752652AbYIMETI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 00:19:08 -0400
Date: Fri, 12 Sep 2008 21:18:58 -0700 (PDT)
Message-Id: <20080912.211858.223900301.davem@davemloft.net>
To: linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       joy@entuzijast.net
Subject: [PATCH 2/2]: serial: Allow 8250 to be used on sparc.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


serial: Allow 8250 to be used on sparc.

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
---
 arch/sparc/include/asm/serial.h |    6 ++++++
 drivers/serial/8250.c           |   18 +++++++++++++++++-
 drivers/serial/Kconfig          |    1 -
 drivers/serial/Makefile         |   15 ++++++++++-----
 4 files changed, 33 insertions(+), 7 deletions(-)
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
index 342e12f..dac80fd 100644
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
@@ -2669,7 +2673,6 @@ static struct uart_driver serial8250_reg = {
 	.dev_name		= "ttyS",
 	.major			= TTY_MAJOR,
 	.minor			= 64,
-	.nr			= UART_NR,
 	.cons			= SERIAL8250_CONSOLE,
 };
 
@@ -2954,7 +2957,12 @@ static int __init serial8250_init(void)
 	for (i = 0; i < NR_IRQS; i++)
 		spin_lock_init(&irq_lists[i].lock);
 
+#ifdef CONFIG_SPARC
+	ret = sunserial_register_minors(&serial8250_reg, UART_NR);
+#else
+	serial8250_reg.nr = UART_NR;
 	ret = uart_register_driver(&serial8250_reg);
+#endif
 	if (ret)
 		goto out;
 
@@ -2979,7 +2987,11 @@ static int __init serial8250_init(void)
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
@@ -2998,7 +3010,11 @@ static void __exit serial8250_exit(void)
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
index 77cb342..db54763 100644
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
index 7e7383e..7bc1292 100644
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
-- 
1.5.6.5.GIT

