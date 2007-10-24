Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbXJXNZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbXJXNZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbXJXNZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:25:00 -0400
Received: from flatline.sindominio.net ([82.144.4.26]:37148 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbXJXNY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:24:58 -0400
X-Greylist: delayed 1549 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 09:24:58 EDT
Date: Wed, 24 Oct 2007 14:59:09 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: mhoffman@lightlink.com, Jean Delvare <khali@linux-fr.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] Hardware Monitor LM70: Convert semaphore to mutex
Message-ID: <20071024125909.GA9095@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	mhoffman@lightlink.com, Jean Delvare <khali@linux-fr.org>,
	Greg Kroah-Hartman <gregkh@suse.de>, lm-sensors@lm-sensors.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware Monitor LM70: Convert the semaphore lm70->sem to the mutex
API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index dd36688..d435f00 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -31,14 +31,15 @@
 #include <linux/err.h>
 #include <linux/sysfs.h>
 #include <linux/hwmon.h>
+#include <linux/mutex.h>
 #include <linux/spi/spi.h>
-#include <asm/semaphore.h>
+
 
 #define DRVNAME		"lm70"
 
 struct lm70 {
 	struct device *hwmon_dev;
-	struct semaphore sem;
+	struct mutex lock;
 };
 
 /* sysfs hook function */
@@ -51,7 +52,7 @@ static ssize_t lm70_sense_temp(struct device *dev,
 	s16 raw=0;
 	struct lm70 *p_lm70 = dev_get_drvdata(&spi->dev);
 
-	if (down_interruptible(&p_lm70->sem))
+	if (mutex_lock_interruptible(&p_lm70->lock))
 		return -ERESTARTSYS;
 
 	/*
@@ -83,7 +84,7 @@ static ssize_t lm70_sense_temp(struct device *dev,
 	val = ((int)raw/32) * 250;
 	status = sprintf(buf, "%d\n", val); /* millidegrees Celsius */
 out:
-	up(&p_lm70->sem);
+	mutex_unlock(&p_lm70->lock);
 	return status;
 }
 
@@ -112,7 +113,7 @@ static int __devinit lm70_probe(struct spi_device *spi)
 	if (!p_lm70)
 		return -ENOMEM;
 
-	init_MUTEX(&p_lm70->sem);
+	mutex_init(&p_lm70->lock);
 
 	/* sysfs hook */
 	p_lm70->hwmon_dev = hwmon_device_register(&spi->dev);
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
