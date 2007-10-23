Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbXJWU41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbXJWU41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXJWU4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:56:00 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:34483 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbXJWUz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:55:59 -0400
Message-Id: <20071023205515.775882722@ldl.fc.hp.com>
References: <20071023204843.442608289@ldl.fc.hp.com>
User-Agent: quilt/0.45-1
Date: Tue, 23 Oct 2007 14:48:45 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
Subject: [patch 2/2] rtc: fallback to requesting only the ports we actually use
Content-Disposition: inline; filename=rtc-resource-size
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Firmware like PNPBIOS or ACPI can report the address space consumed by the
RTC.  The actual space consumed may be less than the size (RTC_IO_EXTENT)
assumed by the RTC driver.

The PNP core doesn't request resources yet, but I'd like to make it do so.
If/when it does, the RTC_IO_EXTENT request may fail, which prevents the RTC
driver from loading.

Since we only use the RTC index and data registers at RTC_PORT(0) and
RTC_PORT(1), we can fall back to requesting just enough space for those.

If the PNP core requests resources, this results in typical I/O port usage
like this:

    0070-0073 : 00:06		<-- PNP device 00:06 responds to 70-73
      0070-0071 : rtc		<-- RTC driver uses only 70-71

instead of the current:

    0070-0077 : rtc		<-- RTC_IO_EXTENT == 8

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/drivers/char/rtc.c
===================================================================
--- w.orig/drivers/char/rtc.c	2007-10-23 14:41:23.000000000 -0600
+++ w/drivers/char/rtc.c	2007-10-23 14:41:30.000000000 -0600
@@ -918,12 +918,29 @@
 };
 #endif
 
+static resource_size_t rtc_size;
+
+static struct resource * __init rtc_request_region(resource_size_t size)
+{
+	struct resource *r;
+
+	if (RTC_IOMAPPED)
+		r = request_region(RTC_PORT(0), size, "rtc");
+	else
+		r = request_mem_region(RTC_PORT(0), size, "rtc");
+
+	if (r)
+		rtc_size = size;
+
+	return r;
+}
+
 static void rtc_release_region(void)
 {
 	if (RTC_IOMAPPED)
-		release_region(RTC_PORT(0), RTC_IO_EXTENT);
+		release_region(RTC_PORT(0), rtc_size);
 	else
-		release_mem_region(RTC_PORT(0), RTC_IO_EXTENT);
+		release_mem_region(RTC_PORT(0), rtc_size);
 }
 
 static int __init rtc_init(void)
@@ -976,10 +993,17 @@
 	}
 no_irq:
 #else
-	if (RTC_IOMAPPED)
-		r = request_region(RTC_PORT(0), RTC_IO_EXTENT, "rtc");
-	else
-		r = request_mem_region(RTC_PORT(0), RTC_IO_EXTENT, "rtc");
+	r = rtc_request_region(RTC_IO_EXTENT);
+
+	/*
+	 * If we've already requested a smaller range (for example, because
+	 * PNPBIOS or ACPI told us how the device is configured), the request
+	 * above might fail because it's too big.
+	 *
+	 * If so, request just the range we actually use.
+	 */
+	if (!r)
+		r = rtc_request_region(RTC_IO_EXTENT_USED);
 	if (!r) {
 #ifdef RTC_IRQ
 		rtc_has_irq = 0;
Index: w/include/linux/mc146818rtc.h
===================================================================
--- w.orig/include/linux/mc146818rtc.h	2007-10-23 14:41:23.000000000 -0600
+++ w/include/linux/mc146818rtc.h	2007-10-23 14:41:30.000000000 -0600
@@ -109,8 +109,11 @@
 #ifndef ARCH_RTC_LOCATION	/* Override by <asm/mc146818rtc.h>? */
 
 #define RTC_IO_EXTENT	0x8
+#define RTC_IO_EXTENT_USED	0x2
 #define RTC_IOMAPPED	1	/* Default to I/O mapping. */
 
+#else
+#define RTC_IO_EXTENT_USED      RTC_IO_EXTENT
 #endif /* ARCH_RTC_LOCATION */
 
 #endif /* _MC146818RTC_H */

--
