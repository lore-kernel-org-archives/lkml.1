Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbXENJTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbXENJTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbXENJTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:19:02 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:37836
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755198AbXENJTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:19:01 -0400
Date: Mon, 14 May 2007 11:21:36 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 5/5] Use mutex instead of semaphore in the MTD DataFlash driver
Message-ID: <20070514092136.GK29206@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	dwmw2@infradead.org, linux-mtd@lists.infradead.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070514090256.GF29206@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514090256.GF29206@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The MTD DataFlash driver uses a semaphore as mutex. Use the mutex API
instead
of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index a987e91..a5ed6d2 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/mutex.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 
@@ -89,7 +90,7 @@ struct dataflash {
 	unsigned short		page_offset;	/* offset in flash address */
 	unsigned int		page_size;	/* of bytes per page */
 
-	struct semaphore	lock;
+	struct mutex		lock;
 	struct spi_device	*spi;
 
 	struct mtd_info		mtd;
@@ -167,7 +168,7 @@ static int dataflash_erase(struct mtd_info *mtd, struct erase_info *instr)
 	x.len = 4;
 	spi_message_add_tail(&x, &msg);
 
-	down(&priv->lock);
+	mutex_lock(&priv->lock);
 	while (instr->len > 0) {
 		unsigned int	pageaddr;
 		int		status;
@@ -210,7 +211,7 @@ static int dataflash_erase(struct mtd_info *mtd, struct erase_info *instr)
 			instr->len -= priv->page_size;
 		}
 	}
-	up(&priv->lock);
+	mutex_unlock(&priv->lock);
 
 	/* Inform MTD subsystem that erase is complete */
 	instr->state = MTD_ERASE_DONE;
@@ -266,7 +267,7 @@ static int dataflash_read(struct mtd_info *mtd, loff_t from, size_t len,
 	x[1].len = len;
 	spi_message_add_tail(&x[1], &msg);
 
-	down(&priv->lock);
+	mutex_lock(&priv->lock);
 
 	/* Continuous read, max clock = f(car) which may be less than
 	 * the peak rate available.  Some chips support commands with
@@ -279,7 +280,7 @@ static int dataflash_read(struct mtd_info *mtd, loff_t from, size_t len,
 	/* plus 4 "don't care" bytes */
 
 	status = spi_sync(priv->spi, &msg);
-	up(&priv->lock);
+	mutex_unlock(&priv->lock);
 
 	if (status >= 0) {
 		*retlen = msg.actual_length - 8;
@@ -336,7 +337,7 @@ static int dataflash_write(struct mtd_info *mtd, loff_t to, size_t len,
 	else
 		writelen = len;
 
-	down(&priv->lock);
+	mutex_lock(&priv->lock);
 	while (remaining > 0) {
 		DEBUG(MTD_DEBUG_LEVEL3, "write @ %i:%i len=%i\n",
 			pageaddr, offset, writelen);
@@ -441,7 +442,7 @@ static int dataflash_write(struct mtd_info *mtd, loff_t to, size_t len,
 		else
 			writelen = remaining;
 	}
-	up(&priv->lock);
+	mutex_unlock(&priv->lock);
 
 	return status;
 }
@@ -463,7 +464,7 @@ add_dataflash(struct spi_device *spi, char *name,
 	if (!priv)
 		return -ENOMEM;
 
-	init_MUTEX(&priv->lock);
+	mutex_init(&priv->lock);
 	priv->spi = spi;
 	priv->page_size = pagesize;
 	priv->page_offset = pageoffset;

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

            Nothing is more despicable than respect based on fear
                              (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
