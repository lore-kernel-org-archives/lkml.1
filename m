Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZCETdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZCETdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZCETdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:33:35 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:26852 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZCETdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:33:35 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] eeprom: add kernel interface for reading/writing persistent memory
Date: Thu,  5 Mar 2009 11:33:28 -0800
Message-Id: <1236281608-18063-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface by which other kernel code can read/write
persistent memory such as i2c or SPI EEPROMs.

In additon, the at24 EEPROM driver is updated to use this interface.

In the case of at24 EEPROM, the platform code registers a 'setup'
callback with the at24_platform_data.  When the at24 driver detects an
EEPROM, it fills out the read and write functions of the
memory_accessor and calls the setup callback passing the
memory_accessor struct.  The platform code can then use the read/write
functions in the memory_accessor struct for reading and writing the
EEPROM.

Original idea, review and updates by David Brownell <david-b@pacbell.net>

Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
Applies against v2.6.29-rc7

 drivers/misc/eeprom/at24.c |   42 +++++++++++++++++++++++++++++++++++-------
 include/linux/i2c/at24.h   |    4 ++++
 include/linux/memory.h     |   11 +++++++++++
 3 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index d477552..80bf7ab 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -53,6 +53,7 @@
 
 struct at24_data {
 	struct at24_platform_data chip;
+	struct memory_accessor macc;
 	bool use_smbus;
 
 	/*
@@ -264,13 +265,6 @@ static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
 
 
 /*
- * REVISIT: export at24_bin{read,write}() to let other kernel code use
- * eeprom data. For example, it might hold a board's Ethernet address, or
- * board-specific calibration data generated on the manufacturing floor.
- */
-
-
-/*
  * Note that if the hardware write-protect pin is pulled high, the whole
  * chip is normally write protected. But there are plenty of product
  * variants here, including OTP fuses and partial chip protect.
@@ -386,6 +380,30 @@ static ssize_t at24_bin_write(struct kobject *kobj, struct bin_attribute *attr,
 
 /*-------------------------------------------------------------------------*/
 
+/*
+ * This lets other kernel code access the eeprom data. For example, it
+ * might hold a board's Ethernet address, or board-specific calibration
+ * data generated on the manufacturing floor.
+ */
+
+static ssize_t at24_read(struct memory_accessor *macc, char *buf,
+			 off_t offset, size_t count)
+{
+	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
+
+	return at24_eeprom_read(at24, buf, offset, count);
+}
+
+static ssize_t at24_write(struct memory_accessor *macc, char *buf,
+			  off_t offset, size_t count)
+{
+	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
+
+	return at24_eeprom_write(at24, buf, offset, count);
+}
+
+/*-------------------------------------------------------------------------*/
+
 static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct at24_platform_data chip;
@@ -413,6 +431,9 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		 * is recommended anyhow.
 		 */
 		chip.page_size = 1;
+
+		chip.setup = NULL;
+		chip.context = NULL;
 	}
 
 	if (!is_power_of_2(chip.byte_len))
@@ -449,6 +470,9 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		goto err_out;
 	}
 
+	at24->macc.read = at24_read;
+	at24->macc.write = at24_write;
+
 	mutex_init(&at24->lock);
 	at24->use_smbus = use_smbus;
 	at24->chip = chip;
@@ -520,6 +544,10 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		at24->write_max,
 		use_smbus ? ", use_smbus" : "");
 
+	/* export data to kernel code */
+	if (chip.setup)
+		chip.setup(&at24->macc, chip.context);
+
 	return 0;
 
 err_clients:
diff --git a/include/linux/i2c/at24.h b/include/linux/i2c/at24.h
index f6edd52..85b4f7e 100644
--- a/include/linux/i2c/at24.h
+++ b/include/linux/i2c/at24.h
@@ -2,6 +2,7 @@
 #define _LINUX_AT24_H
 
 #include <linux/types.h>
+#include <linux/memory.h>
 
 /*
  * As seen through Linux I2C, differences between the most common types of I2C
@@ -23,6 +24,9 @@ struct at24_platform_data {
 #define AT24_FLAG_READONLY	0x40	/* sysfs-entry will be read-only */
 #define AT24_FLAG_IRUGO		0x20	/* sysfs-entry will be world-readable */
 #define AT24_FLAG_TAKE8ADDR	0x10	/* take always 8 addresses (24c00) */
+
+	int             (*setup)(struct memory_accessor *, void *context);
+	void		*context;
 };
 
 #endif /* _LINUX_AT24_H */
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 3fdc108..aa97724 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -99,4 +99,15 @@ enum mem_add_context { BOOT, HOTPLUG };
 #define hotplug_memory_notifier(fn, pri) do { } while (0)
 #endif
 
+/*
+ * 'struct memory_accessor' is a generic interface to provide
+ * in-kernel access to persistent memory such as i2c or SPI EEPROMs
+ */
+struct memory_accessor {
+	ssize_t (*read)(struct memory_accessor *, char *buf, off_t offset,
+			size_t count);
+	ssize_t (*write)(struct memory_accessor *, char *buf, off_t offset,
+			 size_t count);
+};
+
 #endif /* _LINUX_MEMORY_H_ */
-- 
1.6.1.3

