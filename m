Return-Path: <linux-kernel-owner+w=401wt.eu-S965225AbXAYE4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965225AbXAYE4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 23:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbXAYE4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 23:56:45 -0500
Received: from nic2.axis.se ([193.13.178.10]:57646 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933229AbXAYE4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 23:56:44 -0500
Date: Thu, 25 Jan 2007 05:56:34 +0100
Message-Id: <200701250456.l0P4uYhj017248@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: dbrownell@users.sourceforge.net
CC: mikael.starvik@axis.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: 5/5: Updates to SPI and mmc_spi: nonconst SPI cleanup(), kernel 2.6.19
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Please CC me on replies, I'm not subscribed to LKML or the SPI list.  Thanks.)

I'd like to assign NULL to kfree()d members of a structure.  I
can't do that without ugly casting (see the PXA patch) when the
structure pointed to is const-qualified.  I don't really see a
reason why the cleanup method isn't allowed to alter the object
it should clean up. :-)

No, I didn't test the PXA patch, but I verified that the
NULL-assignment doesn't stop me from doing rmmod/insmodding my
own spi_bitbang-based driver.

Signed-off-by: Hans-Peter Nilsson <hp@axis.com>

diff -upr a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c	2007-01-13 19:00:11.000000000 +0100
+++ b/drivers/spi/pxa2xx_spi.c	2007-01-25 05:19:21.000000000 +0100
@@ -1080,9 +1080,9 @@ static int setup(struct spi_device *spi)
 	return 0;
 }
 
-static void cleanup(const struct spi_device *spi)
+static void cleanup(struct spi_device *spi)
 {
-	struct chip_data *chip = spi_get_ctldata((struct spi_device *)spi);
+	struct chip_data *chip = spi_get_ctldata(spi);
 
 	kfree(chip);
 }
Only in b/drivers/spi: pxa2xx_spi.c.~1.1.1.2.~
diff -upr a/drivers/spi/spi.c b/drivers/spi/spi.c
--- a/drivers/spi/spi.c	2007-01-13 19:00:11.000000000 +0100
+++ b/drivers/spi/spi.c	2007-01-25 05:09:56.000000000 +0100
@@ -32,7 +32,7 @@
  */
 static void spidev_release(struct device *dev)
 {
-	const struct spi_device	*spi = to_spi_device(dev);
+	struct spi_device	*spi = to_spi_device(dev);
 
 	/* spi masters may cleanup for released devices */
 	if (spi->master->cleanup)
diff -upr a/drivers/spi/spi_bitbang.c b/drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c	2007-01-24 06:15:56.000000000 +0100
+++ b/drivers/spi/spi_bitbang.c	2007-01-25 05:06:49.000000000 +0100
@@ -244,7 +244,7 @@ EXPORT_SYMBOL_GPL(spi_bitbang_setup);
 /**
  * spi_bitbang_cleanup - default cleanup for per-word I/O loops
  */
-void spi_bitbang_cleanup(const struct spi_device *spi)
+void spi_bitbang_cleanup(struct spi_device *spi)
 {
 	kfree(spi->controller_state);
 }
diff -upr a/include/linux/spi/spi.h b/include/linux/spi/spi.h
--- a/include/linux/spi/spi.h	2007-01-24 03:58:32.000000000 +0100
+++ b/include/linux/spi/spi.h	2007-01-25 05:05:03.000000000 +0100
@@ -228,7 +228,7 @@ struct spi_master {
 						struct spi_message *mesg);
 
 	/* called on release() to free memory provided by spi_master */
-	void			(*cleanup)(const struct spi_device *spi);
+	void			(*cleanup)(struct spi_device *spi);
 };
 
 static inline void *spi_master_get_devdata(struct spi_master *master)
diff -upr a/include/linux/spi/spi_bitbang.h b/include/linux/spi/spi_bitbang.h
--- a/include/linux/spi/spi_bitbang.h	2006-06-25 14:58:31.000000000 +0200
+++ b/include/linux/spi/spi_bitbang.h	2007-01-25 05:10:34.000000000 +0100
@@ -55,7 +55,7 @@ struct spi_bitbang {
  * methods, if you like.
  */
 extern int spi_bitbang_setup(struct spi_device *spi);
-extern void spi_bitbang_cleanup(const struct spi_device *spi);
+extern void spi_bitbang_cleanup(struct spi_device *spi);
 extern int spi_bitbang_transfer(struct spi_device *spi, struct spi_message *m);
 extern int spi_bitbang_setup_transfer(struct spi_device *spi,
 				      struct spi_transfer *t);

brgds, H-P
