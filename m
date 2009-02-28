Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbZB1ILq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbZB1ILq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbZB1ILT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:11:19 -0500
Received: from mail.openmoko.org ([88.198.124.205]:39015 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbZB1ILP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:11:15 -0500
Subject: [PATCH 1/2] spi: Add support for non-blocking synchronous transfers
To: linux-kernel@vger.kernel.org
From: Balaji Rao <balajirrao@openmoko.org>
Cc: spi-devel-general@lists.sourceforge.net, Andy Green <andy@openmoko.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Date: Sat, 28 Feb 2009 13:40:58 +0530
Message-ID: <20090228081058.31964.527.stgit@fedora.yogi>
In-Reply-To: <20090228081036.31964.80618.stgit@fedora.yogi>
References: <20090228081036.31964.80618.stgit@fedora.yogi>
User-Agent: StGit/0.14.3.343.g0584
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new function namely 'transfer_sync' is added to struct spi_master.
A function 'spi_non_blocking_transfer' is introduced , along the lines
of spi_sync and spi_async.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: spi-devel-general@lists.sourceforge.net
---
 include/linux/spi/spi.h |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 68bb1c5..4466021 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -264,6 +264,13 @@ struct spi_master {
 	int			(*transfer)(struct spi_device *spi,
 						struct spi_message *mesg);
 
+	/*
+	 * Synchronous non blocking transfer function. Should guarantee
+	 * data availability when it returns.
+	 */
+	int			(*transfer_sync)(struct spi_device *spi,
+						struct spi_message *mesg);
+
 	/* called on release() to free memory provided by spi_master */
 	void			(*cleanup)(struct spi_device *spi);
 };
@@ -573,6 +580,30 @@ spi_async(struct spi_device *spi, struct spi_message *message)
 	return spi->master->transfer(spi, message);
 }
 
+/**
+ * spi_non_blocking_transfer - Synchronous, non blocking transfer
+ * @spi: device with which data will be exchanged
+ * @message: describes the data transfers with optional completion handlers
+ * Context: any (irqs may be blocked, etc)
+ *
+ * Data is guaranteed to be written or read when this function returns.
+ * The completion callback in spi_message is optional.
+ *
+ * Note : This may not be supported by all spi masters.
+ */
+
+static inline int
+spi_non_blocking_transfer(struct spi_device *spi, struct spi_message *message)
+{
+	if (unlikely(!spi->master->transfer_sync)) {
+		dev_err(&spi->master->dev,
+				"non-blocking transfers not supported\n");
+		return -EIO;
+	}
+
+	return spi->master->transfer_sync(spi, message);
+}
+
 /*---------------------------------------------------------------------------*/
 
 /* All these synchronous SPI transfer routines are utilities layered

