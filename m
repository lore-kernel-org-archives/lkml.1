Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZBOS0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZBOS0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZBOS0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:26:16 -0500
Received: from bu3sch.de ([62.75.166.246]:59154 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbZBOS0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:26:15 -0500
From: Michael Buesch <mb@bu3sch.de>
To: David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] spi-gpio: Implement spidelay() for busses that need it.
Date: Sun, 15 Feb 2009 19:22:59 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       openwrt-devel@lists.openwrt.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151923.00120.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the SPI-GPIO delay function for busses that need speed limitation.
If the special all-inline API is used, the delay is disabled at compiletime.
Otherwise it's an unlikely condition that can be disabled via max_speed_hz.
So it should have minimal or zero impact on the speed of implementations without delay.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

I need this delay when using a slow microcontroller attached via SPI-GPIO
to a fast embedded router device.

Index: linux-2.6/drivers/spi/spi_gpio.c
===================================================================
--- linux-2.6.orig/drivers/spi/spi_gpio.c	2009-02-15 16:27:16.000000000 +0100
+++ linux-2.6/drivers/spi/spi_gpio.c	2009-02-15 19:19:36.000000000 +0100
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/delay.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_bitbang.h>
@@ -69,6 +70,7 @@ struct spi_gpio {
  *		#define	SPI_MOSI_GPIO	120
  *		#define	SPI_SCK_GPIO	121
  *		#define	SPI_N_CHIPSEL	4
+ *		#undef NEED_SPIDELAY
  *		#include "spi_gpio.c"
  */
 
@@ -76,6 +78,7 @@ struct spi_gpio {
 #define DRIVER_NAME	"spi_gpio"
 
 #define GENERIC_BITBANG	/* vs tight inlines */
+#define NEED_SPIDELAY	1
 
 /* all functions referencing these symbols must define pdata */
 #define SPI_MISO_GPIO	((pdata)->miso)
@@ -120,12 +123,20 @@ static inline int getmiso(const struct s
 #undef pdata
 
 /*
- * NOTE:  this clocks "as fast as we can".  It "should" be a function of the
- * requested device clock.  Software overhead means we usually have trouble
- * reaching even one Mbit/sec (except when we can inline bitops), so for now
- * we'll just assume we never need additional per-bit slowdowns.
+ * NOTE:  to clock "as fast as we can", set spi_device.max_speed_hz
+ * and spi_transfer.speed_hz to 0.
+ * Otherwise this is a function of the requested device clock.
+ * Software overhead means we usually have trouble
+ * reaching even one Mbit/sec (except when we can inline bitops). So on small
+ * embedded devices with fast SPI slaves you usually don't need a delay.
  */
-#define spidelay(nsecs)	do {} while (0)
+static inline void spidelay(unsigned nsecs)
+{
+#ifdef NEED_SPIDELAY
+	if (unlikely(nsecs))
+		ndelay(nsecs);
+#endif /* NEED_SPIDELAY */
+}
 
 #define	EXPAND_BITBANG_TXRX
 #include <linux/spi/spi_bitbang.h>

-- 
Greetings, Michael.
