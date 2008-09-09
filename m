Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYIIXLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYIIXLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYIIXLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:11:09 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:60462 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbYIIXLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=v9l0/8PMzu2oQXVfua4VXC4QSvzJQtNqyt7xl4IcYBclE4lj9oPBXebBTuUW7BBgGG
         CD8PRX7BO+uazFGhDpQv3CbMZBArp/uPZGjqNd4gZLxaXy7KyK6ymkYikHcEzC7aYjdE
         aROo4Mdbzj13vSQfgpmWtyesm3MGC6OALzrjs=
Message-ID: <f7848160809091611w50270265hc149baeaf267775e@mail.gmail.com>
Date: Tue, 9 Sep 2008 19:11:02 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: sysfs - kill owner field from attribute
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       htejun@gmail.com, gregkh@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun's commit 7b595756ec1f49e0049a9e01a1298d53a7faaa15 made sysfs
attribute->owner unnecessary.
But the field was left in the structure to ease the merge. It's been
over a year since that change and it is now time to start killing
attribute->owner along with its users - one arch at a time!

This patch is attempt #1 to get rid of attribute->owner only for
CONFIG_X86_64 or CONFIG_X86_32 .
We will deal with other arches later on as and when possible - avr32
will be the next since that is something I can test.
Compile (make allyesconfig / make allmodconfig / custom config) and boot tested.

I would prefer to have this in -mm or one of the other trees for some
time before hitting mainline just to make sure there are no issues.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

 drivers/acpi/battery.c              |    2 +-
 drivers/acpi/sbs.c                  |    2 +-
 drivers/acpi/system.c               |    1 -
 drivers/block/aoe/aoeblk.c          |    2 +-
 drivers/block/nbd.c                 |    2 +-
 drivers/firmware/iscsi_ibft.c       |    1 -
 drivers/i2c/chips/at24.c            |    1 -
 drivers/i2c/chips/ds1682.c          |    1 -
 drivers/infiniband/core/cm.c        |    2 +-
 drivers/memstick/core/mspro_block.c |    1 -
 drivers/power/power_supply_sysfs.c  |    2 +-
 drivers/rtc/rtc-cmos.c              |    1 -
 drivers/rtc/rtc-ds1305.c            |    1 -
 drivers/rtc/rtc-ds1307.c            |    1 -
 drivers/rtc/rtc-ds1511.c            |    1 -
 drivers/rtc/rtc-m48t59.c            |    1 -
 drivers/rtc/rtc-stk17ta8.c          |    1 -
 drivers/scsi/arcmsr/arcmsr_attr.c   |    3 ---
 drivers/w1/slaves/w1_ds2760.c       |    1 -
 include/linux/sysfs.h               |    7 +++++--
 20 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index b1c723f..70f7f60 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -431,7 +431,7 @@ static ssize_t acpi_battery_alarm_store(struct device *dev,
 }

 static struct device_attribute alarm_attr = {
-	.attr = {.name = "alarm", .mode = 0644, .owner = THIS_MODULE},
+	.attr = {.name = "alarm", .mode = 0644},
 	.show = acpi_battery_alarm_show,
 	.store = acpi_battery_alarm_store,
 };
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 10a3651..7b011e7 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -463,7 +463,7 @@ static ssize_t acpi_battery_alarm_store(struct device *dev,
 }

 static struct device_attribute alarm_attr = {
-	.attr = {.name = "alarm", .mode = 0644, .owner = THIS_MODULE},
+	.attr = {.name = "alarm", .mode = 0644},
 	.show = acpi_battery_alarm_show,
 	.store = acpi_battery_alarm_store,
 };
diff --git a/drivers/acpi/system.c b/drivers/acpi/system.c
index 91dec44..24e80fd 100644
--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -115,7 +115,6 @@ static void acpi_table_attr_init(struct
acpi_table_attr *table_attr,
 	table_attr->attr.read = acpi_table_show;
 	table_attr->attr.attr.name = table_attr->name;
 	table_attr->attr.attr.mode = 0444;
-	table_attr->attr.attr.owner = THIS_MODULE;

 	return;
 }
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 0c39782..9298ccf 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -90,7 +90,7 @@ static DEVICE_ATTR(state, S_IRUGO, aoedisk_show_state, NULL);
 static DEVICE_ATTR(mac, S_IRUGO, aoedisk_show_mac, NULL);
 static DEVICE_ATTR(netif, S_IRUGO, aoedisk_show_netif, NULL);
 static struct device_attribute dev_attr_firmware_version = {
-	.attr = { .name = "firmware-version", .mode = S_IRUGO, .owner = THIS_MODULE },
+	.attr = { .name = "firmware-version", .mode = S_IRUGO },
 	.show = aoedisk_show_fwver,
 };

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 1778e4a..3f4d51b 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -391,7 +391,7 @@ static ssize_t pid_show(struct device *dev,
 }

 static struct device_attribute pid_attr = {
-	.attr = { .name = "pid", .mode = S_IRUGO, .owner = THIS_MODULE },
+	.attr = { .name = "pid", .mode = S_IRUGO},
 	.show = pid_show,
 };

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index b91ef63..38ac7bf 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -732,7 +732,6 @@ static int __init ibft_create_attribute(struct
ibft_kobject *kobj_data,

 	attr->attr.name = name;
 	attr->attr.mode = S_IRUSR;
-	attr->attr.owner = THIS_MODULE;

 	attr->hdr = hdr;
 	attr->show = show;
diff --git a/drivers/i2c/chips/at24.c b/drivers/i2c/chips/at24.c
index 2a4acb2..d477552 100644
--- a/drivers/i2c/chips/at24.c
+++ b/drivers/i2c/chips/at24.c
@@ -460,7 +460,6 @@ static int at24_probe(struct i2c_client *client,
const struct i2c_device_id *id)
 	 */
 	at24->bin.attr.name = "eeprom";
 	at24->bin.attr.mode = chip.flags & AT24_FLAG_IRUGO ? S_IRUGO : S_IRUSR;
-	at24->bin.attr.owner = THIS_MODULE;
 	at24->bin.read = at24_bin_read;
 	at24->bin.size = chip.byte_len;

diff --git a/drivers/i2c/chips/ds1682.c b/drivers/i2c/chips/ds1682.c
index 23be4d4..f3ee4a1 100644
--- a/drivers/i2c/chips/ds1682.c
+++ b/drivers/i2c/chips/ds1682.c
@@ -190,7 +190,6 @@ static struct bin_attribute ds1682_eeprom_attr = {
 	.attr = {
 		.name = "eeprom",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = DS1682_EEPROM_SIZE,
 	.read = ds1682_eeprom_read,
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 922d35f..b992e32 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -122,7 +122,7 @@ struct cm_counter_attribute {

 #define CM_COUNTER_ATTR(_name, _index) \
 struct cm_counter_attribute cm_##_name##_counter_attr = { \
-	.attr = { .name = __stringify(_name), .mode = 0444, .owner = THIS_MODULE }, \
+	.attr = { .name = __stringify(_name), .mode = 0444 }, \
 	.index = _index \
 }

diff --git a/drivers/memstick/core/mspro_block.c
b/drivers/memstick/core/mspro_block.c
index 44b1817..c7c0849 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1029,7 +1029,6 @@ static int mspro_block_read_attributes(struct
memstick_dev *card)

 		s_attr->dev_attr.attr.name = s_attr->name;
 		s_attr->dev_attr.attr.mode = S_IRUGO;
-		s_attr->dev_attr.attr.owner = THIS_MODULE;
 		s_attr->dev_attr.show = mspro_block_attr_show(s_attr->id);

 		if (!rc)
diff --git a/drivers/power/power_supply_sysfs.c
b/drivers/power/power_supply_sysfs.c
index fe2aeb1..23ae846 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -30,7 +30,7 @@

 #define POWER_SUPPLY_ATTR(_name)					\
 {									\
-	.attr = { .name = #_name, .mode = 0444, .owner = THIS_MODULE },	\
+	.attr = { .name = #_name, .mode = 0444 },	\
 	.show = power_supply_show_property,				\
 	.store = NULL,							\
 }
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index b184367..a9afa3e 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -539,7 +539,6 @@ static struct bin_attribute nvram = {
 	.attr = {
 		.name	= "nvram",
 		.mode	= S_IRUGO | S_IWUSR,
-		.owner	= THIS_MODULE,
 	},

 	.read	= cmos_nvram_read,
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index b91d02a..06f79bc 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -606,7 +606,6 @@ ds1305_nvram_write(struct kobject *kobj, struct
bin_attribute *attr,
 static struct bin_attribute nvram = {
 	.attr.name	= "nvram",
 	.attr.mode	= S_IRUGO | S_IWUSR,
-	.attr.owner	= THIS_MODULE,
 	.read		= ds1305_nvram_read,
 	.write		= ds1305_nvram_write,
 	.size		= DS1305_NVRAM_LEN,
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index bbf97e6..272c354 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -307,7 +307,6 @@ static struct bin_attribute nvram = {
 	.attr = {
 		.name	= "nvram",
 		.mode	= S_IRUGO | S_IWUSR,
-		.owner	= THIS_MODULE,
 	},

 	.read	= ds1307_nvram_read,
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 0f0d27d..12b445f 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -494,7 +494,6 @@ static struct bin_attribute ds1511_nvram_attr = {
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUGO | S_IWUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = DS1511_RAM_MAX,
 	.read = ds1511_nvram_read,
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index 013e6c1..8636f3f 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -354,7 +354,6 @@ static struct bin_attribute m48t59_nvram_attr = {
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.read = m48t59_nvram_read,
 	.write = m48t59_nvram_write,
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index 31d3c8c..9f10027 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -292,7 +292,6 @@ static struct bin_attribute stk17ta8_nvram_attr = {
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = RTC_OFFSET,
 	.read = stk17ta8_nvram_read,
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c
b/drivers/scsi/arcmsr/arcmsr_attr.c
index 69f8346..5877f29 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -189,7 +189,6 @@ static struct bin_attribute
arcmsr_sysfs_message_read_attr = {
 	.attr = {
 		.name = "mu_read",
 		.mode = S_IRUSR ,
-		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.read = arcmsr_sysfs_iop_message_read,
@@ -199,7 +198,6 @@ static struct bin_attribute
arcmsr_sysfs_message_write_attr = {
 	.attr = {
 		.name = "mu_write",
 		.mode = S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.write = arcmsr_sysfs_iop_message_write,
@@ -209,7 +207,6 @@ static struct bin_attribute
arcmsr_sysfs_message_clear_attr = {
 	.attr = {
 		.name = "mu_clear",
 		.mode = S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 1,
 	.write = arcmsr_sysfs_iop_message_clear,
diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
index ed6b057..1f09d4e 100644
--- a/drivers/w1/slaves/w1_ds2760.c
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -80,7 +80,6 @@ static struct bin_attribute w1_ds2760_bin_attr = {
 	.attr = {
 		.name = "w1_slave",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = DS2760_DATA_SIZE,
 	.read = w1_ds2760_read_bin,
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 37fa241..7868248 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -21,12 +21,15 @@ struct kobject;
 struct module;

 /* FIXME
- * The *owner field is no longer used, but leave around
- * until the tree gets cleaned up fully.
+ * The *owner field is no longer used.
+ * x86 tree has been cleaned up. The owner
+ * attribute is still left for other arches.
  */
 struct attribute {
 	const char		*name;
+#if !defined(CONFIG_X86_64) && !defined(CONFIG_X86_32)
 	struct module		*owner;
+#endif
 	mode_t			mode;
 };
