Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZIQWD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZIQWD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZIQWD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:03:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57655 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbZIQWDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:03:17 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Yi Li <yi.li@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] spi: new SPI bus lock/unlock functions
Date: Thu, 17 Sep 2009 18:03:16 -0400
Message-Id: <1253224997-7422-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

For some MMC cards over SPI bus, it needs to lock the SPI bus for its own
use.  The SPI transfer must not be interrupted by other SPI devices that
share the SPI bus with SPI MMC card.

This patch introduces 2 APIs for SPI bus locking operation.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Andrew: we've posted these in the past with no response.  could you pick
        them up please ?

 drivers/spi/spi.c       |   48 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/spi/spi.h |    7 ++++++
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 70845cc..b82b8ad 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -653,6 +653,54 @@ static void spi_complete(void *arg)
 }
 
 /**
+ * spi_lock_bus - lock SPI bus for exclusive access
+ * @spi: device which want to lock the bus
+ * Context: any
+ *
+ * Once the caller owns exclusive access to the SPI bus,
+ * only messages for this device will be transferred.
+ * Messages for other devices are queued but not transferred until
+ * the bus owner unlock the bus.
+ *
+ * The caller may call spi_lock_bus() before spi_sync() or spi_async().
+ * So this call may be used in irq and other contexts which can't sleep,
+ * as well as from task contexts which can sleep.
+ *
+ * It returns zero on success, else a negative error code.
+ */
+int spi_lock_bus(struct spi_device *spi)
+{
+	if (spi->master->lock_bus)
+		return spi->master->lock_bus(spi);
+	else
+		return 0;
+}
+EXPORT_SYMBOL_GPL(spi_lock_bus);
+
+/**
+ * spi_unlock_bus - unlock SPI bus
+ * @spi: device which want to unlock the bus
+ * Context: any
+ *
+ * The caller has called spi_lock_bus() to lock the bus. It calls
+ * spi_unlock_bus() to release the bus so messages for other devices
+ * can be transferred.
+ *
+ * If the caller did not call spi_lock_bus() before, spi_unlock_bus()
+ * should have no effect.
+ *
+ * It returns zero on success, else a negative error code.
+ */
+int spi_unlock_bus(struct spi_device *spi)
+{
+	if (spi->master->unlock_bus)
+		return spi->master->unlock_bus(spi);
+	else
+		return 0;
+}
+EXPORT_SYMBOL_GPL(spi_unlock_bus);
+
+/**
  * spi_sync - blocking/synchronous SPI data transfers
  * @spi: device with which data will be exchanged
  * @message: describes the data transfers
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index c47c4b4..c53292c 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -214,6 +214,8 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
  *	the device whose settings are being modified.
  * @transfer: adds a message to the controller's transfer queue.
  * @cleanup: frees controller-specific state
+ * @lock_bus: lock SPI bus for exclusive access
+ * @unlock_bus: unlock SPI bus so other devices can access
  *
  * Each SPI master controller can communicate with one or more @spi_device
  * children.  These make a small bus, sharing MOSI, MISO and SCK signals
@@ -286,6 +288,9 @@ struct spi_master {
 
 	/* called on release() to free memory provided by spi_master */
 	void			(*cleanup)(struct spi_device *spi);
+
+	int			(*lock_bus)(struct spi_device *spi);
+	int			(*unlock_bus)(struct spi_device *spi);
 };
 
 static inline void *spi_master_get_devdata(struct spi_master *master)
@@ -578,6 +583,8 @@ spi_async(struct spi_device *spi, struct spi_message *message)
  */
 
 extern int spi_sync(struct spi_device *spi, struct spi_message *message);
+extern int spi_lock_bus(struct spi_device *spi);
+extern int spi_unlock_bus(struct spi_device *spi);
 
 /**
  * spi_write - SPI synchronous write
-- 
1.6.5.rc1

