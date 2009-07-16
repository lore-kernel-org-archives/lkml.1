Return-Path: <linux-kernel-owner+w=401wt.eu-S933216AbZGPT6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbZGPT6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933206AbZGPT6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:58:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34055 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116AbZGPT6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:58:19 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] libata: Allow ports to be flagged as hotpluggable
Date: Thu, 16 Jul 2009 20:58:08 +0100
Message-Id: <1247774290-4194-2-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1247774290-4194-1-git-send-email-mjg@redhat.com>
References: <1247774290-4194-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 78.86.230.144
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace may wish to make policy decisions based on whether a host
supports native hotplug or not - for example, AHCI link power management
disables hotplug, so may only be desirable on non-hotplug ports. Add
support for marking hosts as hotpluggable in order to allow userspace to
treat them appropriately.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/ata/ahci.c        |    1 +
 drivers/ata/libata-scsi.c |   23 +++++++++++++++++++++++
 include/linux/libata.h    |    6 +++++-
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 336eb1e..4863da9 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -331,6 +331,7 @@ static struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_link_power_management_policy,
 	&dev_attr_em_message_type,
 	&dev_attr_em_message,
+	&dev_attr_sata_hotplug,
 	NULL
 };
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d0dfeef..47b0cac 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -370,12 +370,35 @@ DEVICE_ATTR(sw_activity, S_IWUSR | S_IRUGO, ata_scsi_activity_show,
 			ata_scsi_activity_store);
 EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
 
+static ssize_t
+ata_scsi_sata_hotplug_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+
+	if (ap->flags & ATA_FLAG_SATA &&
+	    !(ap->flags & ATA_FLAG_NO_SATA_HOTPLUG))
+		return sprintf(buf, "1\n");
+	else
+		return sprintf(buf, "0\n");
+}
+DEVICE_ATTR(sata_hotplug, S_IRUGO,
+		  ata_scsi_sata_hotplug_show, NULL);
+EXPORT_SYMBOL_GPL(dev_attr_sata_hotplug);
+
 struct device_attribute *ata_common_sdev_attrs[] = {
 	&dev_attr_unload_heads,
 	NULL
 };
 EXPORT_SYMBOL_GPL(ata_common_sdev_attrs);
 
+struct device_attribute *ata_common_shost_attrs[] = {
+	&dev_attr_sata_hotplug,
+	NULL
+};
+EXPORT_SYMBOL_GPL(ata_common_shost_attrs);
+
 static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
 				   void (*done)(struct scsi_cmnd *))
 {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 79b6d7f..e644227 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -190,6 +190,7 @@ enum {
 	ATA_FLAG_NO_POWEROFF_SPINDOWN = (1 << 11), /* don't spindown before poweroff */
 	ATA_FLAG_NO_HIBERNATE_SPINDOWN = (1 << 12), /* don't spindown before hibernation */
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
+	ATA_FLAG_NO_SATA_HOTPLUG = (1 << 14), /* port doesn't support hotplug */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
@@ -480,6 +481,7 @@ extern struct device_attribute dev_attr_unload_heads;
 extern struct device_attribute dev_attr_em_message_type;
 extern struct device_attribute dev_attr_em_message;
 extern struct device_attribute dev_attr_sw_activity;
+extern struct device_attribute dev_attr_sata_hotplug;
 
 enum sw_activity {
 	OFF,
@@ -1145,6 +1147,7 @@ extern void ata_std_error_handler(struct ata_port *ap);
 extern const struct ata_port_operations ata_base_port_ops;
 extern const struct ata_port_operations sata_port_ops;
 extern struct device_attribute *ata_common_sdev_attrs[];
+extern struct device_attribute *ata_common_shost_attrs[];
 
 #define ATA_BASE_SHT(drv_name)					\
 	.module			= THIS_MODULE,			\
@@ -1160,7 +1163,8 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.slave_configure	= ata_scsi_slave_config,	\
 	.slave_destroy		= ata_scsi_slave_destroy,	\
 	.bios_param		= ata_std_bios_param,		\
-	.sdev_attrs		= ata_common_sdev_attrs
+	.sdev_attrs		= ata_common_sdev_attrs,	\
+	.shost_attrs		= ata_common_shost_attrs
 
 #define ATA_NCQ_SHT(drv_name)					\
 	ATA_BASE_SHT(drv_name),					\
-- 
1.6.2.5

