Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbZCPVhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbZCPVhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbZCPVga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:36:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:26328 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760348AbZCPVg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:36:29 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v3 2/3] Implement the new memory_accessor interface for I2C EEPROM
Date: Mon, 16 Mar 2009 14:36:18 -0700
Message-Id: <1237239379-24186-3-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1237239379-24186-2-git-send-email-khilman@deeprootsystems.com>
References: <1237239379-24186-1-git-send-email-khilman@deeprootsystems.com>
 <1237239379-24186-2-git-send-email-khilman@deeprootsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of at24, the platform code registers a 'setup' callback
with the at24_platform_data.  When the at24 driver detects an EEPROM,
it fills out the read and write functions of the memory_accessor and
calls the setup callback passing the memory_accessor struct.  The
platform code can then use the read/write functions in the
memory_accessor struct for reading and writing the EEPROM.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/misc/eeprom/at24.c |   67 +++++++++++++++++++++++++++++++++++--------
 include/linux/i2c/at24.h   |    4 ++
 2 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index d477552..d184dfa 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -53,6 +53,7 @@
 
 struct at24_data {
 	struct at24_platform_data chip;
+	struct memory_accessor macc;
 	bool use_smbus;
 
 	/*
@@ -225,14 +226,11 @@ static ssize_t at24_eeprom_read(struct at24_data *at24, char *buf,
 		return status;
 }
 
-static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
+static ssize_t at24_read(struct at24_data *at24,
 		char *buf, loff_t off, size_t count)
 {
-	struct at24_data *at24;
 	ssize_t retval = 0;
 
-	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
-
 	if (unlikely(!count))
 		return count;
 
@@ -262,12 +260,14 @@ static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
 	return retval;
 }
 
+static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct at24_data *at24;
 
-/*
- * REVISIT: export at24_bin{read,write}() to let other kernel code use
- * eeprom data. For example, it might hold a board's Ethernet address, or
- * board-specific calibration data generated on the manufacturing floor.
- */
+	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
+	return at24_read(at24, buf, off, count);
+}
 
 
 /*
@@ -347,14 +347,11 @@ static ssize_t at24_eeprom_write(struct at24_data *at24, char *buf,
 	return -ETIMEDOUT;
 }
 
-static ssize_t at24_bin_write(struct kobject *kobj, struct bin_attribute *attr,
+static ssize_t at24_write(struct at24_data *at24,
 		char *buf, loff_t off, size_t count)
 {
-	struct at24_data *at24;
 	ssize_t retval = 0;
 
-	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
-
 	if (unlikely(!count))
 		return count;
 
@@ -384,6 +381,39 @@ static ssize_t at24_bin_write(struct kobject *kobj, struct bin_attribute *attr,
 	return retval;
 }
 
+static ssize_t at24_bin_write(struct kobject *kobj, struct bin_attribute *attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct at24_data *at24;
+
+	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
+	return at24_write(at24, buf, off, count);
+}
+
+/*-------------------------------------------------------------------------*/
+
+/*
+ * This lets other kernel code access the eeprom data. For example, it
+ * might hold a board's Ethernet address, or board-specific calibration
+ * data generated on the manufacturing floor.
+ */
+
+static ssize_t at24_macc_read(struct memory_accessor *macc, char *buf,
+			 off_t offset, size_t count)
+{
+	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
+
+	return at24_read(at24, buf, offset, count);
+}
+
+static ssize_t at24_macc_write(struct memory_accessor *macc, char *buf,
+			  off_t offset, size_t count)
+{
+	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
+
+	return at24_write(at24, buf, offset, count);
+}
+
 /*-------------------------------------------------------------------------*/
 
 static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
@@ -413,6 +443,9 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		 * is recommended anyhow.
 		 */
 		chip.page_size = 1;
+
+		chip.setup = NULL;
+		chip.context = NULL;
 	}
 
 	if (!is_power_of_2(chip.byte_len))
@@ -463,6 +496,8 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	at24->bin.read = at24_bin_read;
 	at24->bin.size = chip.byte_len;
 
+	at24->macc.read = at24_macc_read;
+
 	writable = !(chip.flags & AT24_FLAG_READONLY);
 	if (writable) {
 		if (!use_smbus || i2c_check_functionality(client->adapter,
@@ -470,6 +505,8 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 			unsigned write_max = chip.page_size;
 
+			at24->macc.write = at24_macc_write;
+
 			at24->bin.write = at24_bin_write;
 			at24->bin.attr.mode |= S_IWUSR;
 
@@ -520,6 +557,10 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		at24->write_max,
 		use_smbus ? ", use_smbus" : "");
 
+	/* export data to kernel code */
+	if (chip.setup)
+		chip.setup(&at24->macc, chip.context);
+
 	return 0;
 
 err_clients:
diff --git a/include/linux/i2c/at24.h b/include/linux/i2c/at24.h
index f6edd52..8ace930 100644
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
+	void		(*setup)(struct memory_accessor *, void *context);
+	void		*context;
 };
 
 #endif /* _LINUX_AT24_H */
-- 
1.6.1.3

