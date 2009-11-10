Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbZKJREt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbZKJREt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbZKJREs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:04:48 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:28589 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260AbZKJREr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:04:47 -0500
Date: Tue, 10 Nov 2009 09:04:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PTCH -next] staging/iio: fix ring buffer build
Message-Id: <20091110090428.08797a9a.randy.dunlap@oracle.com>
In-Reply-To: <20091109192246.aa0dfd93.sfr@canb.auug.org.au>
References: <20091109192246.aa0dfd93.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AF99D26.007E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

max1363 uses both the iio hardware ring buffer and software
ring buffer interfaces, but its Makefile and Kconfig do not
reflect that usage, so its build breaks.  Add a new Kconfig
symbol to reflect that usage and change max1363.h & Makefile
to use the new Kconfig symbol.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/adc/Kconfig   |    9 +++++++++
 drivers/staging/iio/adc/Makefile  |    2 +-
 drivers/staging/iio/adc/max1363.h |    6 +++---
 3 files changed, 13 insertions(+), 4 deletions(-)

--- linux-next-20091109.orig/drivers/staging/iio/adc/Kconfig
+++ linux-next-20091109/drivers/staging/iio/adc/Kconfig
@@ -12,3 +12,12 @@ config MAX1363
 	  convertors (ADC). (max1361, max1362, max1363, max1364, max1136,
 	  max1136, max1137, max1138, max1139, max1236, max1237, max11238,
 	  max1239) Provides direct access via sysfs.
+
+config MAX1363_RING_BUFFER
+	bool "MAXIM max1363: use ring buffer"
+	depends on MAX1363
+	select IIO_RING_BUFFER
+	select IIO_SW_RING
+	help
+	  Say yes here to include ring buffer support in the MAX1363
+	  ADC driver.
--- linux-next-20091109.orig/drivers/staging/iio/adc/Makefile
+++ linux-next-20091109/drivers/staging/iio/adc/Makefile
@@ -3,6 +3,6 @@
 #
 
 max1363-y := max1363_core.o
-max1363-$(CONFIG_IIO_RING_BUFFER) += max1363_ring.o
+max1363-$(CONFIG_MAX1363_RING_BUFFER) += max1363_ring.o
 
 obj-$(CONFIG_MAX1363) += max1363.o
--- linux-next-20091109.orig/drivers/staging/iio/adc/max1363.h
+++ linux-next-20091109/drivers/staging/iio/adc/max1363.h
@@ -228,7 +228,7 @@ struct max1363_state {
 	struct iio_trigger		*trig;
 	struct regulator		*reg;
 };
-#ifdef CONFIG_IIO_RING_BUFFER
+#ifdef CONFIG_MAX1363_RING_BUFFER
 
 ssize_t max1363_scan_from_ring(struct device *dev,
 			       struct device_attribute *attr,
@@ -239,7 +239,7 @@ void max1363_ring_cleanup(struct iio_dev
 int max1363_initialize_ring(struct iio_ring_buffer *ring);
 void max1363_uninitialize_ring(struct iio_ring_buffer *ring);
 
-#else /* CONFIG_IIO_RING_BUFFER */
+#else /* CONFIG_MAX1363_RING_BUFFER */
 
 static inline void max1363_uninitialize_ring(struct iio_ring_buffer *ring)
 {
@@ -265,5 +265,5 @@ max1363_register_ring_funcs_and_init(str
 };
 
 static inline void max1363_ring_cleanup(struct iio_dev *indio_dev) {};
-#endif /* CONFIG_IIO_RING_BUFFER */
+#endif /* CONFIG_MAX1363_RING_BUFFER */
 #endif /* _MAX1363_H_ */
