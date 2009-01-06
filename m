Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbZAFS4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbZAFS4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZAFS4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:56:43 -0500
Received: from adelie.canonical.com ([91.189.90.139]:50107 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZAFS4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:56:42 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
Date: Tue,  6 Jan 2009 18:56:38 +0000
Message-Id: <1231268198-12556-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.0.4.911.gc990
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we are using an explicit udev rule to trigger loading of the
mmc-block module when an MMC or SD card is detected:

    SUBSYSTEM=="mmc", RUN+="/sbin/modprobe -Qba mmc-block"

It makes much more sense for the mmc bus driver and the mmc-block module to
share MODALIAS information so that they are linked automatically.

Add MODALIAS attributes to the uevents as generated, and add the
corresponding MODULE_ALIAS marks to the mmc-block module so that it is
automatically loaded by udev.  I have followed the example set by the
SCSI subsystem in pushing out numeric typed aliases:

	mmc:t-0xNN

Where NN is the MMC type as defined in include/linux/mmc/card.h.
Numeric types are used to allow automatic handling of new unknown types
in the core.  The matches are open on the right to allow additional
fields to be added as required in the future.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/mmc/card/block.c |    3 +++
 drivers/mmc/core/bus.c   |    5 +++++
 include/linux/mmc/card.h |   10 +++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 45b1f43..5d1c5ad 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -41,6 +41,9 @@
 
 #include "queue.h"
 
+MODULE_ALIAS_MMC_DEVICE(MMC_TYPE_MMC);
+MODULE_ALIAS_MMC_DEVICE(MMC_TYPE_SD);
+
 /*
  * max 8 partitions per card
  */
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index f210a8e..35ec7c3 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -84,6 +84,11 @@ mmc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 	}
 
 	retval = add_uevent_var(env, "MMC_NAME=%s", mmc_card_name(card));
+	if (retval)
+		return retval;
+
+	retval = add_uevent_var(env, "MODALIAS=" MMC_DEVICE_MODALIAS_FMT,
+		card->type);
 
 	return retval;
 }
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 403aa50..97a461e 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -86,9 +86,9 @@ struct mmc_card {
 	struct device		dev;		/* the device */
 	unsigned int		rca;		/* relative card address of device */
 	unsigned int		type;		/* card type */
-#define MMC_TYPE_MMC		0		/* MMC card */
-#define MMC_TYPE_SD		1		/* SD card */
-#define MMC_TYPE_SDIO		2		/* SDIO card */
+#define MMC_TYPE_MMC		0x00		/* MMC card */
+#define MMC_TYPE_SD		0x01		/* SD card */
+#define MMC_TYPE_SDIO		0x02		/* SDIO card */
 	unsigned int		state;		/* (our) card state */
 #define MMC_STATE_PRESENT	(1<<0)		/* present in sysfs */
 #define MMC_STATE_READONLY	(1<<1)		/* card is read-only */
@@ -150,4 +150,8 @@ struct mmc_driver {
 extern int mmc_register_driver(struct mmc_driver *);
 extern void mmc_unregister_driver(struct mmc_driver *);
 
+#define MODULE_ALIAS_MMC_DEVICE(type) \
+	MODULE_ALIAS("mmc:t-" __stringify(type) "*")
+#define MMC_DEVICE_MODALIAS_FMT "mmc:t-0x%02x"
+
 #endif
-- 
1.6.0.4.911.gc990

