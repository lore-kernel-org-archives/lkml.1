Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbYKRH57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbYKRH57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYKRH4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:56:22 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:11095 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYKRH4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:56:20 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690618"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Yi Li <yi.li@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] spi: Add two new APIs spi_lock_bus() and spi_unlock_bus() to spi framework.
Date: Tue, 18 Nov 2008 15:57:46 +0800
Message-Id: <1226995067-4484-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226995067-4484-1-git-send-email-cooloney@kernel.org>
References: <1226995067-4484-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

For some MMC card over SPI bus, it needs to lock the SPI bus for its own
use. The SPI transfer can not be interrupted by other SPI devices
which sharing the SPI bus with SPI MMC card.

This patch introduces 2 APIs for SPI bus locking operation.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi.c       |   48 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/spi/spi.h |    7 ++++++
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 3734dc9..03b8747 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -591,6 +591,54 @@ static void spi_complete(void *arg)
 }
 
 /**
+ * spi_lock_bus - lock SPI bus for exclusive access
+ * @@spi: device which want to lock the bus
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
+ * @@spi: device which want to unlock the bus
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
index 4be01bb..c8819e3 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -209,6 +209,8 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
  *	the device whose settings are being modified.
  * @transfer: adds a message to the controller's transfer queue.
  * @cleanup: frees controller-specific state
+ * @lock_bus: lock SPI bus for exclusive access
+ * @unlock_bus: unlock SPI bus so other devices can access
  *
  * Each SPI master controller can communicate with one or more @spi_device
  * children.  These make a small bus, sharing MOSI, MISO and SCK signals
@@ -264,6 +266,9 @@ struct spi_master {
 
 	/* called on release() to free memory provided by spi_master */
 	void			(*cleanup)(struct spi_device *spi);
+
+	int			(*lock_bus)(struct spi_device *spi);
+	int			(*unlock_bus)(struct spi_device *spi);
 };
 
 static inline void *spi_master_get_devdata(struct spi_master *master)
@@ -579,6 +584,8 @@ spi_async(struct spi_device *spi, struct spi_message *message)
  */
 
 extern int spi_sync(struct spi_device *spi, struct spi_message *message);
+extern int spi_lock_bus(struct spi_device *spi);
+extern int spi_unlock_bus(struct spi_device *spi);
 
 /**
  * spi_write - SPI synchronous write
-- 
1.5.6.3
