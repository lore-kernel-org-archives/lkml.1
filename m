Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbXDIEVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbXDIEVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 00:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbXDIETc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 00:19:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:60306 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752820AbXDIETC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 00:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=PsPFGEhWulZ/bs1uqctEwrpZs3GJJ7MKeOBog6WtwSuY6Um9x/lUEpXYYlWoBX3kFcu89uhAhQwgGvsxVeQfOIBeyoN4lTo5mn9ym6VoRMAlSacU/DhlbjZ9YdSB5pWQd6NJ3OZ+B4zX3M1A8QxnR55id+6OQxjD/g4Xv0flrOM=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 14/14] sysfs: kill unnecessary attribute->owner
In-Reply-To: <11760923261269-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Mon, 9 Apr 2007 13:18:49 +0900
Message-Id: <11760923293601-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs is now completely out of driver/module lifetime game.  After
deletion, a sysfs node doesn't access anything outside sysfs proper,
so there's no reason to hold onto the attribute owners.  Note that
often the wrong modules were accounted for as owners leading to
accessing removed modules.

This patch kills now unnecessary attribute->owner.  Note that with
this change, userland holding a sysfs node does not prevent the
backing module from being unloaded.

For more info regarding lifetime rule cleanup, please read the
following message.

  http://article.gmane.org/gmane.linux.kernel/510293

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/base/class.c                        |    2 --
 drivers/base/core.c                         |    4 ----
 drivers/base/firmware_class.c               |    2 +-
 drivers/block/pktcdvd.c                     |    3 +--
 drivers/char/ipmi/ipmi_msghandler.c         |   10 ----------
 drivers/cpufreq/cpufreq_stats.c             |    3 +--
 drivers/cpufreq/cpufreq_userspace.c         |    2 +-
 drivers/cpufreq/freq_table.c                |    1 -
 drivers/firmware/dcdbas.h                   |    3 +--
 drivers/firmware/dell_rbu.c                 |    6 +++---
 drivers/firmware/edd.c                      |    2 +-
 drivers/firmware/efivars.c                  |    6 +++---
 drivers/i2c/chips/eeprom.c                  |    1 -
 drivers/i2c/chips/max6875.c                 |    1 -
 drivers/infiniband/core/sysfs.c             |    1 -
 drivers/input/mouse/psmouse.h               |    1 -
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c |   13 -------------
 drivers/misc/asus-laptop.c                  |    3 +--
 drivers/pci/hotplug/acpiphp_ibm.c           |    1 -
 drivers/pci/pci-sysfs.c                     |    4 ----
 drivers/pcmcia/socket_sysfs.c               |    2 +-
 drivers/rtc/rtc-ds1553.c                    |    1 -
 drivers/rtc/rtc-ds1742.c                    |    1 -
 drivers/scsi/arcmsr/arcmsr_attr.c           |    3 ---
 drivers/scsi/lpfc/lpfc_attr.c               |    2 --
 drivers/scsi/qla2xxx/qla_attr.c             |    6 ------
 drivers/spi/at25.c                          |    1 -
 drivers/video/aty/radeon_base.c             |    2 --
 drivers/video/backlight/backlight.c         |    2 +-
 drivers/video/backlight/lcd.c               |    2 +-
 drivers/w1/slaves/w1_ds2433.c               |    1 -
 drivers/w1/slaves/w1_therm.c                |    1 -
 drivers/w1/w1.c                             |    2 --
 fs/ecryptfs/main.c                          |    2 --
 fs/ocfs2/cluster/masklog.c                  |    1 -
 fs/partitions/check.c                       |    1 -
 fs/sysfs/bin.c                              |   19 +++++--------------
 fs/sysfs/file.c                             |   21 +++++----------------
 include/linux/sysdev.h                      |    3 +--
 include/linux/sysfs.h                       |    7 +++----
 kernel/module.c                             |    9 +++------
 kernel/params.c                             |    1 -
 net/bridge/br_sysfs_br.c                    |    3 +--
 net/bridge/br_sysfs_if.c                    |    3 +--
 44 files changed, 35 insertions(+), 130 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index d596812..064c1de 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -624,7 +624,6 @@ int class_device_add(struct class_device *class_dev)
 		goto out3;
 	class_dev->uevent_attr.attr.name = "uevent";
 	class_dev->uevent_attr.attr.mode = S_IWUSR;
-	class_dev->uevent_attr.attr.owner = parent_class->owner;
 	class_dev->uevent_attr.store = store_uevent;
 	error = class_device_create_file(class_dev, &class_dev->uevent_attr);
 	if (error)
@@ -639,7 +638,6 @@ int class_device_add(struct class_device *class_dev)
 		}
 		attr->attr.name = "dev";
 		attr->attr.mode = S_IRUGO;
-		attr->attr.owner = parent_class->owner;
 		attr->show = show_dev;
 		error = class_device_create_file(class_dev, attr);
 		if (error) {
diff --git a/drivers/base/core.c b/drivers/base/core.c
index d7fcf82..37930d0 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -563,8 +563,6 @@ int device_add(struct device *dev)
 
 	dev->uevent_attr.attr.name = "uevent";
 	dev->uevent_attr.attr.mode = S_IWUSR;
-	if (dev->driver)
-		dev->uevent_attr.attr.owner = dev->driver->owner;
 	dev->uevent_attr.store = store_uevent;
 	error = device_create_file(dev, &dev->uevent_attr);
 	if (error)
@@ -579,8 +577,6 @@ int device_add(struct device *dev)
 		}
 		attr->attr.name = "dev";
 		attr->attr.mode = S_IRUGO;
-		if (dev->driver)
-			attr->attr.owner = dev->driver->owner;
 		attr->show = show_dev;
 		error = device_create_file(dev, attr);
 		if (error) {
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c0a979a..8791d06 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -276,7 +276,7 @@ out:
 }
 
 static struct bin_attribute firmware_attr_data_tmpl = {
-	.attr = {.name = "data", .mode = 0644, .owner = THIS_MODULE},
+	.attr = {.name = "data", .mode = 0644},
 	.size = 0,
 	.read = firmware_data_read,
 	.write = firmware_data_write,
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index a4fb703..4c6b33d 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -146,8 +146,7 @@ static void pkt_kobj_release(struct kobject *kobj)
  **********************************************************/
 
 #define DEF_ATTR(_obj,_name,_mode) \
-	static struct attribute _obj = { \
-		.name = _name, .owner = THIS_MODULE, .mode = _mode }
+	static struct attribute _obj = { .name = _name, .mode = _mode }
 
 /**********************************************************
   /sys/class/pktcdvd/pktcdvd[0-7]/
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 8e222f2..b5df7e6 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2171,52 +2171,42 @@ static int create_files(struct bmc_device *bmc)
 	int err;
 
 	bmc->device_id_attr.attr.name = "device_id";
-	bmc->device_id_attr.attr.owner = THIS_MODULE;
 	bmc->device_id_attr.attr.mode = S_IRUGO;
 	bmc->device_id_attr.show = device_id_show;
 
 	bmc->provides_dev_sdrs_attr.attr.name = "provides_device_sdrs";
-	bmc->provides_dev_sdrs_attr.attr.owner = THIS_MODULE;
 	bmc->provides_dev_sdrs_attr.attr.mode = S_IRUGO;
 	bmc->provides_dev_sdrs_attr.show = provides_dev_sdrs_show;
 
 	bmc->revision_attr.attr.name = "revision";
-	bmc->revision_attr.attr.owner = THIS_MODULE;
 	bmc->revision_attr.attr.mode = S_IRUGO;
 	bmc->revision_attr.show = revision_show;
 
 	bmc->firmware_rev_attr.attr.name = "firmware_revision";
-	bmc->firmware_rev_attr.attr.owner = THIS_MODULE;
 	bmc->firmware_rev_attr.attr.mode = S_IRUGO;
 	bmc->firmware_rev_attr.show = firmware_rev_show;
 
 	bmc->version_attr.attr.name = "ipmi_version";
-	bmc->version_attr.attr.owner = THIS_MODULE;
 	bmc->version_attr.attr.mode = S_IRUGO;
 	bmc->version_attr.show = ipmi_version_show;
 
 	bmc->add_dev_support_attr.attr.name = "additional_device_support";
-	bmc->add_dev_support_attr.attr.owner = THIS_MODULE;
 	bmc->add_dev_support_attr.attr.mode = S_IRUGO;
 	bmc->add_dev_support_attr.show = add_dev_support_show;
 
 	bmc->manufacturer_id_attr.attr.name = "manufacturer_id";
-	bmc->manufacturer_id_attr.attr.owner = THIS_MODULE;
 	bmc->manufacturer_id_attr.attr.mode = S_IRUGO;
 	bmc->manufacturer_id_attr.show = manufacturer_id_show;
 
 	bmc->product_id_attr.attr.name = "product_id";
-	bmc->product_id_attr.attr.owner = THIS_MODULE;
 	bmc->product_id_attr.attr.mode = S_IRUGO;
 	bmc->product_id_attr.show = product_id_show;
 
 	bmc->guid_attr.attr.name = "guid";
-	bmc->guid_attr.attr.owner = THIS_MODULE;
 	bmc->guid_attr.attr.mode = S_IRUGO;
 	bmc->guid_attr.show = guid_show;
 
 	bmc->aux_firmware_rev_attr.attr.name = "aux_firmware_revision";
-	bmc->aux_firmware_rev_attr.attr.owner = THIS_MODULE;
 	bmc->aux_firmware_rev_attr.attr.mode = S_IRUGO;
 	bmc->aux_firmware_rev_attr.show = aux_firmware_rev_show;
 
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index d1c7cac..7c9589a 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -25,8 +25,7 @@ static spinlock_t cpufreq_stats_lock;
 
 #define CPUFREQ_STATDEVICE_ATTR(_name,_mode,_show) \
 static struct freq_attr _attr_##_name = {\
-	.attr = {.name = __stringify(_name), .owner = THIS_MODULE, \
-		.mode = _mode, }, \
+	.attr = {.name = __stringify(_name), .mode = _mode, }, \
 	.show = _show,\
 };
 
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index 860345c..a648970 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -120,7 +120,7 @@ store_speed (struct cpufreq_policy *policy, const char *buf, size_t count)
 
 static struct freq_attr freq_attr_scaling_setspeed =
 {
-	.attr = { .name = "scaling_setspeed", .mode = 0644, .owner = THIS_MODULE },
+	.attr = { .name = "scaling_setspeed", .mode = 0644 },
 	.show = show_speed,
 	.store = store_speed,
 };
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index e749092..5409f3a 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -199,7 +199,6 @@ static ssize_t show_available_freqs (struct cpufreq_policy *policy, char *buf)
 struct freq_attr cpufreq_freq_attr_scaling_available_freqs = {
 	.attr = { .name = "scaling_available_frequencies",
 		  .mode = 0444,
-		  .owner=THIS_MODULE
 		},
 	.show = show_available_freqs,
 };
diff --git a/drivers/firmware/dcdbas.h b/drivers/firmware/dcdbas.h
index 58a8518..dcdba0f 100644
--- a/drivers/firmware/dcdbas.h
+++ b/drivers/firmware/dcdbas.h
@@ -67,8 +67,7 @@
 #define DCDBAS_BIN_ATTR_RW(_name) \
 struct bin_attribute bin_attr_##_name = { \
 	.attr =  { .name = __stringify(_name), \
-		   .mode = 0600, \
-		   .owner = THIS_MODULE }, \
+		   .mode = 0600 }, \
 	.read =  _name##_read, \
 	.write = _name##_write, \
 }
diff --git a/drivers/firmware/dell_rbu.c b/drivers/firmware/dell_rbu.c
index fc702e4..f8afecb 100644
--- a/drivers/firmware/dell_rbu.c
+++ b/drivers/firmware/dell_rbu.c
@@ -687,18 +687,18 @@ static ssize_t write_rbu_packet_size(struct kobject *kobj, char *buffer,
 }
 
 static struct bin_attribute rbu_data_attr = {
-	.attr = {.name = "data",.owner = THIS_MODULE,.mode = 0444},
+	.attr = {.name = "data", .mode = 0444},
 	.read = read_rbu_data,
 };
 
 static struct bin_attribute rbu_image_type_attr = {
-	.attr = {.name = "image_type",.owner = THIS_MODULE,.mode = 0644},
+	.attr = {.name = "image_type", .mode = 0644},
 	.read = read_rbu_image_type,
 	.write = write_rbu_image_type,
 };
 
 static struct bin_attribute rbu_packet_size_attr = {
-	.attr = {.name = "packet_size",.owner = THIS_MODULE,.mode = 0644},
+	.attr = {.name = "packet_size", .mode = 0644},
 	.read = read_rbu_packet_size,
 	.write = write_rbu_packet_size,
 };
diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index d8806e4..1523227 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -74,7 +74,7 @@ static struct edd_device *edd_devices[EDD_MBR_SIG_MAX];
 
 #define EDD_DEVICE_ATTR(_name,_mode,_show,_test) \
 struct edd_attribute edd_attr_##_name = { 	\
-	.attr = {.name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE },	\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,				\
 	.test	= _test,				\
 };
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index c6281cc..b84b2b4 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -131,21 +131,21 @@ struct efivar_attribute {
 
 #define EFI_ATTR(_name, _mode, _show, _store) \
 struct subsys_attribute efi_attr_##_name = { \
-	.attr = {.name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE}, \
+	.attr = {.name = __stringify(_name), .mode = _mode}, \
 	.show = _show, \
 	.store = _store, \
 };
 
 #define EFIVAR_ATTR(_name, _mode, _show, _store) \
 struct efivar_attribute efivar_attr_##_name = { \
-	.attr = {.name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE}, \
+	.attr = {.name = __stringify(_name), .mode = _mode}, \
 	.show = _show, \
 	.store = _store, \
 };
 
 #define VAR_SUBSYS_ATTR(_name, _mode, _show, _store) \
 struct subsys_attribute var_subsys_attr_##_name = { \
-	.attr = {.name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE}, \
+	.attr = {.name = __stringify(_name), .mode = _mode}, \
 	.show = _show, \
 	.store = _store, \
 };
diff --git a/drivers/i2c/chips/eeprom.c b/drivers/i2c/chips/eeprom.c
index bfce13c..5990dd5 100644
--- a/drivers/i2c/chips/eeprom.c
+++ b/drivers/i2c/chips/eeprom.c
@@ -143,7 +143,6 @@ static struct bin_attribute eeprom_attr = {
 	.attr = {
 		.name = "eeprom",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = EEPROM_SIZE,
 	.read = eeprom_read,
diff --git a/drivers/i2c/chips/max6875.c b/drivers/i2c/chips/max6875.c
index 76645c1..1405ce5 100644
--- a/drivers/i2c/chips/max6875.c
+++ b/drivers/i2c/chips/max6875.c
@@ -152,7 +152,6 @@ static struct bin_attribute user_eeprom_attr = {
 	.attr = {
 		.name = "eeprom",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = USER_EEPROM_SIZE,
 	.read = max6875_read,
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 000c086..f4006e7 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -479,7 +479,6 @@ alloc_group_attrs(ssize_t (*show)(struct ib_port *,
 
 		element->attr.attr.name  = element->name;
 		element->attr.attr.mode  = S_IRUGO;
-		element->attr.attr.owner = THIS_MODULE;
 		element->attr.show       = show;
 		element->index		 = i;
 
diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index cf1de95..4a5bddf 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -117,7 +117,6 @@ static struct psmouse_attribute psmouse_attr_##_name = {			\
 		.attr	= {							\
 			.name	= __stringify(_name),				\
 			.mode	= _mode,					\
-			.owner	= THIS_MODULE,					\
 		},								\
 		.show	= psmouse_attr_show_helper,				\
 		.store	= psmouse_attr_set_helper,				\
diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
index 91396fd..f0251a7 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
@@ -516,40 +516,32 @@ static void pvr2_sysfs_add_control(struct pvr2_sysfs *sfp,int ctl_id)
 	}
 	sfp->item_last = cip;
 
-	cip->attr_name.attr.owner = THIS_MODULE;
 	cip->attr_name.attr.name = "name";
 	cip->attr_name.attr.mode = S_IRUGO;
 	cip->attr_name.show = fp->show_name;
 
-	cip->attr_type.attr.owner = THIS_MODULE;
 	cip->attr_type.attr.name = "type";
 	cip->attr_type.attr.mode = S_IRUGO;
 	cip->attr_type.show = fp->show_type;
 
-	cip->attr_min.attr.owner = THIS_MODULE;
 	cip->attr_min.attr.name = "min_val";
 	cip->attr_min.attr.mode = S_IRUGO;
 	cip->attr_min.show = fp->show_min;
 
-	cip->attr_max.attr.owner = THIS_MODULE;
 	cip->attr_max.attr.name = "max_val";
 	cip->attr_max.attr.mode = S_IRUGO;
 	cip->attr_max.show = fp->show_max;
 
-	cip->attr_val.attr.owner = THIS_MODULE;
 	cip->attr_val.attr.name = "cur_val";
 	cip->attr_val.attr.mode = S_IRUGO;
 
-	cip->attr_custom.attr.owner = THIS_MODULE;
 	cip->attr_custom.attr.name = "custom_val";
 	cip->attr_custom.attr.mode = S_IRUGO;
 
-	cip->attr_enum.attr.owner = THIS_MODULE;
 	cip->attr_enum.attr.name = "enum_val";
 	cip->attr_enum.attr.mode = S_IRUGO;
 	cip->attr_enum.show = fp->show_enum;
 
-	cip->attr_bits.attr.owner = THIS_MODULE;
 	cip->attr_bits.attr.name = "bit_val";
 	cip->attr_bits.attr.mode = S_IRUGO;
 	cip->attr_bits.show = fp->show_bits;
@@ -614,12 +606,10 @@ static void pvr2_sysfs_add_debugifc(struct pvr2_sysfs *sfp)
 
 	dip = kzalloc(sizeof(*dip),GFP_KERNEL);
 	if (!dip) return;
-	dip->attr_debugcmd.attr.owner = THIS_MODULE;
 	dip->attr_debugcmd.attr.name = "debugcmd";
 	dip->attr_debugcmd.attr.mode = S_IRUGO|S_IWUSR|S_IWGRP;
 	dip->attr_debugcmd.show = debugcmd_show;
 	dip->attr_debugcmd.store = debugcmd_store;
-	dip->attr_debuginfo.attr.owner = THIS_MODULE;
 	dip->attr_debuginfo.attr.name = "debuginfo";
 	dip->attr_debuginfo.attr.mode = S_IRUGO;
 	dip->attr_debuginfo.show = debuginfo_show;
@@ -795,7 +785,6 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 		return;
 	}
 
-	sfp->attr_v4l_minor_number.attr.owner = THIS_MODULE;
 	sfp->attr_v4l_minor_number.attr.name = "v4l_minor_number";
 	sfp->attr_v4l_minor_number.attr.mode = S_IRUGO;
 	sfp->attr_v4l_minor_number.show = v4l_minor_number_show;
@@ -809,7 +798,6 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 		sfp->v4l_minor_number_created_ok = !0;
 	}
 
-	sfp->attr_v4l_radio_minor_number.attr.owner = THIS_MODULE;
 	sfp->attr_v4l_radio_minor_number.attr.name = "v4l_radio_minor_number";
 	sfp->attr_v4l_radio_minor_number.attr.mode = S_IRUGO;
 	sfp->attr_v4l_radio_minor_number.show = v4l_radio_minor_number_show;
@@ -823,7 +811,6 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 		sfp->v4l_radio_minor_number_created_ok = !0;
 	}
 
-	sfp->attr_unit_number.attr.owner = THIS_MODULE;
 	sfp->attr_unit_number.attr.name = "unit_number";
 	sfp->attr_unit_number.attr.mode = S_IRUGO;
 	sfp->attr_unit_number.show = unit_number_show;
diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
index 4b23212..fe2f29c 100644
--- a/drivers/misc/asus-laptop.c
+++ b/drivers/misc/asus-laptop.c
@@ -673,8 +673,7 @@ static void asus_hotk_notify(acpi_handle handle, u32 event, void *data)
 	struct device_attribute dev_attr_##_name = {			\
 		.attr = {						\
 			.name = __stringify(_name),			\
-			.mode = 0,					\
-			.owner = THIS_MODULE },				\
+			.mode = 0 },					\
 		.show   = NULL,						\
 		.store  = NULL,						\
 	}
diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index 7f03881..4d5998a 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -117,7 +117,6 @@ static struct notification ibm_note;
 static struct bin_attribute ibm_apci_table_attr = {
 	    .attr = {
 		    .name = "apci_table",
-		    .owner = THIS_MODULE,
 		    .mode = S_IRUGO,
 	    },
 	    .read = ibm_read_apci_table,
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index cd913a2..d803ddf 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -499,7 +499,6 @@ static int pci_create_resource_files(struct pci_dev *pdev)
 			sprintf(res_attr_name, "resource%d", i);
 			res_attr->attr.name = res_attr_name;
 			res_attr->attr.mode = S_IRUSR | S_IWUSR;
-			res_attr->attr.owner = THIS_MODULE;
 			res_attr->size = pci_resource_len(pdev, i);
 			res_attr->mmap = pci_mmap_resource;
 			res_attr->private = &pdev->resource[i];
@@ -582,7 +581,6 @@ static struct bin_attribute pci_config_attr = {
 	.attr =	{
 		.name = "config",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 256,
 	.read = pci_read_config,
@@ -593,7 +591,6 @@ static struct bin_attribute pcie_config_attr = {
 	.attr =	{
 		.name = "config",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 4096,
 	.read = pci_read_config,
@@ -627,7 +624,6 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 			rom_attr->size = pci_resource_len(pdev, PCI_ROM_RESOURCE);
 			rom_attr->attr.name = "rom";
 			rom_attr->attr.mode = S_IRUSR;
-			rom_attr->attr.owner = THIS_MODULE;
 			rom_attr->read = pci_read_rom;
 			rom_attr->write = pci_write_rom;
 			retval = sysfs_create_bin_file(&pdev->dev.kobj, rom_attr);
diff --git a/drivers/pcmcia/socket_sysfs.c b/drivers/pcmcia/socket_sysfs.c
index ea5765c..b7f321d 100644
--- a/drivers/pcmcia/socket_sysfs.c
+++ b/drivers/pcmcia/socket_sysfs.c
@@ -367,7 +367,7 @@ static struct device_attribute *pccard_socket_attributes[] = {
 };
 
 static struct bin_attribute pccard_cis_attr = {
-	.attr = { .name = "cis", .mode = S_IRUGO | S_IWUSR, .owner = THIS_MODULE},
+	.attr = { .name = "cis", .mode = S_IRUGO | S_IWUSR },
 	.size = 0x200,
 	.read = pccard_show_cis,
 	.write = pccard_store_cis,
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index e27176c..b3f4c4e 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -290,7 +290,6 @@ static struct bin_attribute ds1553_nvram_attr = {
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUGO | S_IWUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = RTC_OFFSET,
 	.read = ds1553_nvram_read,
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index d68288b..1638acd 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -159,7 +159,6 @@ static struct bin_attribute ds1742_nvram_attr = {
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUGO | S_IWUGO,
-		.owner = THIS_MODULE,
 	},
 	.read = ds1742_nvram_read,
 	.write = ds1742_nvram_write,
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index 12497da..b08cbac 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -189,7 +189,6 @@ static struct bin_attribute arcmsr_sysfs_message_read_attr = {
 	.attr = {
 		.name = "mu_read",
 		.mode = S_IRUSR ,
-		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.read = arcmsr_sysfs_iop_message_read,
@@ -199,7 +198,6 @@ static struct bin_attribute arcmsr_sysfs_message_write_attr = {
 	.attr = {
 		.name = "mu_write",
 		.mode = S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.write = arcmsr_sysfs_iop_message_write,
@@ -209,7 +207,6 @@ static struct bin_attribute arcmsr_sysfs_message_clear_attr = {
 	.attr = {
 		.name = "mu_clear",
 		.mode = S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 1,
 	.write = arcmsr_sysfs_iop_message_clear,
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f247e78..c8ce90b 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1145,7 +1145,6 @@ static struct bin_attribute sysfs_ctlreg_attr = {
 	.attr = {
 		.name = "ctlreg",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 256,
 	.read = sysfs_ctlreg_read,
@@ -1356,7 +1355,6 @@ static struct bin_attribute sysfs_mbox_attr = {
 	.attr = {
 		.name = "mbox",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = sizeof(MAILBOX_t),
 	.read = sysfs_mbox_read,
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 8081b63..9658725 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -73,7 +73,6 @@ static struct bin_attribute sysfs_fw_dump_attr = {
 	.attr = {
 		.name = "fw_dump",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 0,
 	.read = qla2x00_sysfs_read_fw_dump,
@@ -149,7 +148,6 @@ static struct bin_attribute sysfs_nvram_attr = {
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 512,
 	.read = qla2x00_sysfs_read_nvram,
@@ -198,7 +196,6 @@ static struct bin_attribute sysfs_optrom_attr = {
 	.attr = {
 		.name = "optrom",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = OPTROM_SIZE_24XX,
 	.read = qla2x00_sysfs_read_optrom,
@@ -279,7 +276,6 @@ static struct bin_attribute sysfs_optrom_ctl_attr = {
 	.attr = {
 		.name = "optrom_ctl",
 		.mode = S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 0,
 	.write = qla2x00_sysfs_write_optrom_ctl,
@@ -327,7 +323,6 @@ static struct bin_attribute sysfs_vpd_attr = {
 	.attr = {
 		.name = "vpd",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 0,
 	.read = qla2x00_sysfs_read_vpd,
@@ -375,7 +370,6 @@ static struct bin_attribute sysfs_sfp_attr = {
 	.attr = {
 		.name = "sfp",
 		.mode = S_IRUSR | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = SFP_DEV_SIZE * 2,
 	.read = qla2x00_sysfs_read_sfp,
diff --git a/drivers/spi/at25.c b/drivers/spi/at25.c
index 8efa07e..fde1ded 100644
--- a/drivers/spi/at25.c
+++ b/drivers/spi/at25.c
@@ -314,7 +314,6 @@ static int at25_probe(struct spi_device *spi)
 	 */
 	at25->bin.attr.name = "eeprom";
 	at25->bin.attr.mode = S_IRUSR;
-	at25->bin.attr.owner = THIS_MODULE;
 	at25->bin.read = at25_bin_read;
 
 	at25->bin.size = at25->chip.byte_len;
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 1bf6f42..fe4e2a4 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -2123,7 +2123,6 @@ static ssize_t radeon_show_edid2(struct kobject *kobj, char *buf, loff_t off, si
 static struct bin_attribute edid1_attr = {
 	.attr   = {
 		.name	= "edid1",
-		.owner	= THIS_MODULE,
 		.mode	= 0444,
 	},
 	.size	= EDID_LENGTH,
@@ -2133,7 +2132,6 @@ static struct bin_attribute edid1_attr = {
 static struct bin_attribute edid2_attr = {
 	.attr   = {
 		.name	= "edid2",
-		.owner	= THIS_MODULE,
 		.mode	= 0444,
 	},
 	.size	= EDID_LENGTH,
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index c65e81f..7e06223 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -172,7 +172,7 @@ static struct class backlight_class = {
 
 #define DECLARE_ATTR(_name,_mode,_show,_store)			\
 {							 	\
-	.attr	= { .name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE },	\
+	.attr	= { .name = __stringify(_name), .mode = _mode }, \
 	.show	= _show,					\
 	.store	= _store,					\
 }
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 6ef8f0a..648b53c 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -157,7 +157,7 @@ static struct class lcd_class = {
 
 #define DECLARE_ATTR(_name,_mode,_show,_store)			\
 {							 	\
-	.attr	= { .name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE },	\
+	.attr	= { .name = __stringify(_name), .mode = _mode }, \
 	.show	= _show,					\
 	.store	= _store,					\
 }
diff --git a/drivers/w1/slaves/w1_ds2433.c b/drivers/w1/slaves/w1_ds2433.c
index 8ea17a5..4e13aa7 100644
--- a/drivers/w1/slaves/w1_ds2433.c
+++ b/drivers/w1/slaves/w1_ds2433.c
@@ -252,7 +252,6 @@ static struct bin_attribute w1_f23_bin_attr = {
 	.attr = {
 		.name = "eeprom",
 		.mode = S_IRUGO | S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = W1_EEPROM_SIZE,
 	.read = w1_f23_read_bin,
diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 732db47..721261b 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -48,7 +48,6 @@ static struct bin_attribute w1_therm_bin_attr = {
 	.attr = {
 		.name = "w1_slave",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = W1_SLAVE_DATA_SIZE,
 	.read = w1_therm_read_bin,
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 63c0724..c1ee648 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -128,7 +128,6 @@ static struct bin_attribute w1_slave_attr_bin_id = {
       .attr = {
               .name = "id",
               .mode = S_IRUGO,
-              .owner = THIS_MODULE,
       },
       .size = 8,
       .read = w1_slave_read_id,
@@ -167,7 +166,6 @@ static struct bin_attribute w1_default_attr = {
       .attr = {
               .name = "rw",
               .mode = S_IRUGO | S_IWUSR,
-              .owner = THIS_MODULE,
       },
       .size = PAGE_SIZE,
       .read = w1_default_read,
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index fc4a3a2..6669a25 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -842,8 +842,6 @@ static int __init ecryptfs_init(void)
 		goto out;
 	}
 	kset_set_kset_s(&ecryptfs_subsys, fs_subsys);
-	sysfs_attr_version.attr.owner = THIS_MODULE;
-	sysfs_attr_version_str.attr.owner = THIS_MODULE;
 	rc = do_sysfs_registration();
 	if (rc) {
 		printk(KERN_ERR "sysfs registration failed\n");
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 636593b..fd741ce 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -74,7 +74,6 @@ struct mlog_attribute {
 #define define_mask(_name) {			\
 	.attr = {				\
 		.name = #_name,			\
-		.owner = THIS_MODULE,		\
 		.mode = S_IRUGO | S_IWUSR,	\
 	},					\
 	.mask = ML_##_name,			\
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 8a7d003..694b369 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -393,7 +393,6 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
 			.mode = S_IRUSR | S_IRGRP | S_IROTH,
-			.owner = THIS_MODULE,
 		};
 
 		sysfs_create_file(&p->kobj, &addpartattr);
diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 69bb8da..bca0a3f 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -175,25 +175,20 @@ static int open(struct inode * inode, struct file * file)
 	if (!sysfs_get_active(attr_sd))
 		return -ENODEV;
 
-	/* Grab the module reference for this attribute */
-	error = -ENODEV;
-	if (!try_module_get(attr->attr.owner))
-		goto err_sput;
-
 	error = -EACCES;
 	if ((file->f_mode & FMODE_WRITE) && !(attr->write || attr->mmap))
-		goto err_mput;
+		goto err_out;
 	if ((file->f_mode & FMODE_READ) && !(attr->read || attr->mmap))
-		goto err_mput;
+		goto err_out;
 
 	error = -ENOMEM;
 	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
 	if (!bb)
-		goto err_mput;
+		goto err_out;
 
 	bb->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!bb->buffer)
-		goto err_mput;
+		goto err_out;
 
 	mutex_init(&bb->mutex);
 	file->private_data = bb;
@@ -203,9 +198,7 @@ static int open(struct inode * inode, struct file * file)
 	sysfs_get(attr_sd);
 	return 0;
 
- err_mput:
-	module_put(attr->attr.owner);
- err_sput:
+ err_out:
 	sysfs_put_active(attr_sd);
 	kfree(bb);
 	return error;
@@ -214,13 +207,11 @@ static int open(struct inode * inode, struct file * file)
 static int release(struct inode * inode, struct file * file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
 	struct bin_buffer *bb = file->private_data;
 
 	if (bb->mmapped)
 		sysfs_put_active_two(attr_sd);
 	sysfs_put(attr_sd);
-	module_put(attr->attr.owner);
 	kfree(bb->buffer);
 	kfree(bb);
 	return 0;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 37b5ee5..db691a5 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -271,7 +271,6 @@ sysfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct attribute *attr = attr_sd->s_elem.attr.attr;
 	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
@@ -281,11 +280,6 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	if (!sysfs_get_active_two(attr_sd))
 		return -ENODEV;
 
-	/* Grab the module reference for this attribute */
-	error = -ENODEV;
-	if (!try_module_get(attr->owner))
-		goto err_sput;
-
 	/* if the kobject has no ktype, then we assume that it is a subsystem
 	 * itself, and use ops for it.
 	 */
@@ -302,7 +296,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 * or the subsystem have no operations.
 	 */
 	if (!ops)
-		goto err_mput;
+		goto err_out;
 
 	/* File needs write support.
 	 * The inode's perms must say it's ok, 
@@ -310,7 +304,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 */
 	if (file->f_mode & FMODE_WRITE) {
 		if (!(inode->i_mode & S_IWUGO) || !ops->store)
-			goto err_mput;
+			goto err_out;
 	}
 
 	/* File needs read support.
@@ -319,7 +313,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 */
 	if (file->f_mode & FMODE_READ) {
 		if (!(inode->i_mode & S_IRUGO) || !ops->show)
-			goto err_mput;
+			goto err_out;
 	}
 
 	/* No error? Great, allocate a buffer for the file, and store it
@@ -328,7 +322,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	error = -ENOMEM;
 	buffer = kzalloc(sizeof(struct sysfs_buffer), GFP_KERNEL);
 	if (!buffer)
-		goto err_mput;
+		goto err_out;
 
 	init_MUTEX(&buffer->sem);
 	buffer->needs_read_fill = 1;
@@ -340,9 +334,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	sysfs_get(attr_sd);
 	return 0;
 
- err_mput:
-	module_put(attr->owner);
- err_sput:
+ err_out:
 	sysfs_put_active_two(attr_sd);
 	return error;
 }
@@ -350,12 +342,9 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 static int sysfs_release(struct inode * inode, struct file * filp)
 {
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
-	struct attribute *attr = attr_sd->s_elem.attr.attr;
 	struct sysfs_buffer *buffer = filp->private_data;
 
 	sysfs_put(attr_sd);
-	/* After this point, attr should not be accessed. */
-	module_put(attr->owner);
 
 	if (buffer) {
 		if (buffer->page)
diff --git a/include/linux/sysdev.h b/include/linux/sysdev.h
index 389ccf8..6e7c398 100644
--- a/include/linux/sysdev.h
+++ b/include/linux/sysdev.h
@@ -100,8 +100,7 @@ struct sysdev_attribute {
 
 #define _SYSDEV_ATTR(_name,_mode,_show,_store)			\
 {								\
-	.attr = { .name = __stringify(_name), .mode = _mode,	\
-		 .owner = THIS_MODULE },			\
+	.attr = { .name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,					\
 	.store	= _store,					\
 }
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index c79944a..882f6f7 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -22,7 +22,6 @@ struct dentry;
 
 struct attribute {
 	const char		* name;
-	struct module 		* owner;
 	mode_t			mode;
 };
 
@@ -39,14 +38,14 @@ struct attribute_group {
  */
 
 #define __ATTR(_name,_mode,_show,_store) { \
-	.attr = {.name = __stringify(_name), .mode = _mode, .owner = THIS_MODULE },	\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,					\
 	.store	= _store,					\
 }
 
 #define __ATTR_RO(_name) { \
-	.attr	= { .name = __stringify(_name), .mode = 0444, .owner = THIS_MODULE },	\
-	.show	= _name##_show,	\
+	.attr	= { .name = __stringify(_name), .mode = 0444 },	\
+	.show	= _name##_show,					\
 }
 
 #define __ATTR_NULL { .attr = { .name = NULL } }
diff --git a/kernel/module.c b/kernel/module.c
index dcdb32b..13fa1df 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -485,8 +485,7 @@ static void free_modinfo_##field(struct module *mod)                  \
         mod->field = NULL;                                            \
 }                                                                     \
 static struct module_attribute modinfo_##field = {                    \
-	.attr = { .name = __stringify(field), .mode = 0444,           \
-		  .owner = THIS_MODULE },                             \
+	.attr = { .name = __stringify(field), .mode = 0444 },         \
 	.show = show_modinfo_##field,                                 \
 	.setup = setup_modinfo_##field,                               \
 	.test = modinfo_##field##_exists,                             \
@@ -790,7 +789,7 @@ static ssize_t show_refcnt(struct module_attribute *mattr,
 }
 
 static struct module_attribute refcnt = {
-	.attr = { .name = "refcnt", .mode = 0444, .owner = THIS_MODULE },
+	.attr = { .name = "refcnt", .mode = 0444 },
 	.show = show_refcnt,
 };
 
@@ -848,7 +847,7 @@ static ssize_t show_initstate(struct module_attribute *mattr,
 }
 
 static struct module_attribute initstate = {
-	.attr = { .name = "initstate", .mode = 0444, .owner = THIS_MODULE },
+	.attr = { .name = "initstate", .mode = 0444 },
 	.show = show_initstate,
 };
 
@@ -1029,7 +1028,6 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
 		sattr->mattr.show = module_sect_show;
 		sattr->mattr.store = NULL;
 		sattr->mattr.attr.name = sattr->name;
-		sattr->mattr.attr.owner = mod;
 		sattr->mattr.attr.mode = S_IRUGO;
 		*(gattr++) = &(sattr++)->mattr.attr;
 	}
@@ -1087,7 +1085,6 @@ int module_add_modinfo_attrs(struct module *mod)
 		if (!attr->test ||
 		    (attr->test && attr->test(mod))) {
 			memcpy(temp_attr, attr, sizeof(*temp_attr));
-			temp_attr->attr.owner = mod;
 			error = sysfs_create_file(&mod->mkobj.kobj,&temp_attr->attr);
 			++temp_attr;
 		}
diff --git a/kernel/params.c b/kernel/params.c
index e265b13..3a1d5bc 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -487,7 +487,6 @@ param_sysfs_setup(struct module_kobject *mk,
 			pattr->mattr.show = param_attr_show;
 			pattr->mattr.store = param_attr_store;
 			pattr->mattr.attr.name = (char *)&kp->name[name_skip];
-			pattr->mattr.attr.owner = mk->mod;
 			pattr->mattr.attr.mode = kp->perm;
 			*(gattr++) = &(pattr++)->mattr.attr;
 		}
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 01a22ad..40b0972 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -365,8 +365,7 @@ static ssize_t brforward_read(struct kobject *kobj, char *buf,
 
 static struct bin_attribute bridge_forward = {
 	.attr = { .name = SYSFS_BRIDGE_FDB,
-		  .mode = S_IRUGO,
-		  .owner = THIS_MODULE, },
+		  .mode = S_IRUGO, },
 	.read = brforward_read,
 };
 
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index 0bc2aef..8ea600c 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -29,8 +29,7 @@ struct brport_attribute {
 #define BRPORT_ATTR(_name,_mode,_show,_store)		        \
 struct brport_attribute brport_attr_##_name = { 	        \
 	.attr = {.name = __stringify(_name), 			\
-		 .mode = _mode, 				\
-		 .owner = THIS_MODULE, },			\
+		 .mode = _mode },				\
 	.show	= _show,					\
 	.store	= _store,					\
 };
-- 
1.5.0.3


