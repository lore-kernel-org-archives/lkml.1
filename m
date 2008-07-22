Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbYGVFis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbYGVFis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbYGVFZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:08 -0400
Received: from ns1.suse.de ([195.135.220.2]:53954 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757054AbYGVFZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/79] driver core: remove KOBJ_NAME_LEN define
Date: Mon, 21 Jul 2008 22:19:15 -0700
Message-Id: <1216703983-21448-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Kobjects do not have a limit in name size since a while, so stop
pretending that they do.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/plat-omap/mailbox.c        |    2 +-
 arch/sparc64/kernel/vio.c           |    2 +-
 drivers/message/fusion/mptbase.c    |    3 ++-
 drivers/message/fusion/mptbase.h    |    4 ++--
 drivers/message/fusion/mptfc.c      |    4 ++--
 drivers/pci/hotplug/acpiphp.h       |    4 ++--
 drivers/scsi/hosts.c                |    4 ++--
 drivers/scsi/scsi_transport_fc.c    |    9 +++++----
 drivers/scsi/scsi_transport_iscsi.c |    4 ++--
 fs/partitions/check.c               |    2 +-
 include/linux/device.h              |    3 +--
 include/linux/kobject.h             |    1 -
 include/linux/spi/spi.h             |    2 +-
 include/scsi/scsi_host.h            |    2 +-
 include/scsi/scsi_transport_fc.h    |    4 ++--
 include/scsi/scsi_transport_iscsi.h |    2 +-
 16 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
index 6f33f58..848fdca 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/arch/arm/plat-omap/mailbox.c
@@ -334,7 +334,7 @@ static int omap_mbox_init(struct omap_mbox *mbox)
 	}
 
 	mbox->dev.class = &omap_mbox_class;
-	strlcpy(mbox->dev.bus_id, mbox->name, KOBJ_NAME_LEN);
+	strlcpy(mbox->dev.bus_id, mbox->name, BUS_ID_SIZE);
 	dev_set_drvdata(&mbox->dev, mbox);
 
 	ret = device_register(&mbox->dev);
diff --git a/arch/sparc64/kernel/vio.c b/arch/sparc64/kernel/vio.c
index e78b351..ecbb8b6 100644
--- a/arch/sparc64/kernel/vio.c
+++ b/arch/sparc64/kernel/vio.c
@@ -224,7 +224,7 @@ static struct vio_dev *vio_create_one(struct mdesc_handle *hp, u64 mp,
 	if (!strcmp(type, "domain-services-port"))
 		bus_id_name = "ds";
 
-	if (strlen(bus_id_name) >= KOBJ_NAME_LEN - 4) {
+	if (strlen(bus_id_name) >= BUS_ID_SIZE - 4) {
 		printk(KERN_ERR "VIO: bus_id_name [%s] is too long.\n",
 		       bus_id_name);
 		return NULL;
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 75e599b..34402c4 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1670,7 +1670,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_DELAYED_WORK(&ioc->fault_reset_work, mpt_fault_reset_work);
 	spin_lock_init(&ioc->fault_reset_work_lock);
 
-	snprintf(ioc->reset_work_q_name, KOBJ_NAME_LEN, "mpt_poll_%d", ioc->id);
+	snprintf(ioc->reset_work_q_name, sizeof(ioc->reset_work_q_name),
+		 "mpt_poll_%d", ioc->id);
 	ioc->reset_work_q =
 		create_singlethread_workqueue(ioc->reset_work_q_name);
 	if (!ioc->reset_work_q) {
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 6adab64..dff048c 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -707,12 +707,12 @@ typedef struct _MPT_ADAPTER
 	u8			 fc_link_speed[2];
 	spinlock_t		 fc_rescan_work_lock;
 	struct work_struct	 fc_rescan_work;
-	char			 fc_rescan_work_q_name[KOBJ_NAME_LEN];
+	char			 fc_rescan_work_q_name[20];
 	struct workqueue_struct *fc_rescan_work_q;
 	struct scsi_cmnd	**ScsiLookup;
 	spinlock_t		  scsi_lookup_lock;
 
-	char			 reset_work_q_name[KOBJ_NAME_LEN];
+	char			 reset_work_q_name[20];
 	struct workqueue_struct *reset_work_q;
 	struct delayed_work	 fault_reset_work;
 	spinlock_t		 fault_reset_work_lock;
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index fc31ca6..b36cae9 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1326,8 +1326,8 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* initialize workqueue */
 
-	snprintf(ioc->fc_rescan_work_q_name, KOBJ_NAME_LEN, "mptfc_wq_%d",
-		sh->host_no);
+	snprintf(ioc->fc_rescan_work_q_name, sizeof(ioc->fc_rescan_work_q_name),
+		 "mptfc_wq_%d", sh->host_no);
 	ioc->fc_rescan_work_q =
 		create_singlethread_workqueue(ioc->fc_rescan_work_q_name);
 	if (!ioc->fc_rescan_work_q)
diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index eecf7cb..5a58b07 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -36,7 +36,7 @@
 #define _ACPIPHP_H
 
 #include <linux/acpi.h>
-#include <linux/kobject.h>	/* for KOBJ_NAME_LEN */
+#include <linux/kobject.h>
 #include <linux/mutex.h>
 #include <linux/pci_hotplug.h>
 
@@ -51,7 +51,7 @@
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format, MY_NAME , ## arg)
 
 /* name size which is used for entries in pcihpfs */
-#define SLOT_NAME_SIZE	KOBJ_NAME_LEN		/* {_SUN} */
+#define SLOT_NAME_SIZE	20		/* {_SUN} */
 
 struct acpiphp_bridge;
 struct acpiphp_slot;
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 78dad28..fed0b02 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -232,8 +232,8 @@ int scsi_add_host(struct Scsi_Host *shost, struct device *dev)
 	}
 
 	if (shost->transportt->create_work_queue) {
-		snprintf(shost->work_q_name, KOBJ_NAME_LEN, "scsi_wq_%d",
-			shost->host_no);
+		snprintf(shost->work_q_name, sizeof(shost->work_q_name),
+			 "scsi_wq_%d", shost->host_no);
 		shost->work_q = create_singlethread_workqueue(
 					shost->work_q_name);
 		if (!shost->work_q) {
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 5fd64e7..a272b9a 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -417,15 +417,16 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 	fc_host->next_vport_number = 0;
 	fc_host->npiv_vports_inuse = 0;
 
-	snprintf(fc_host->work_q_name, KOBJ_NAME_LEN, "fc_wq_%d",
-		shost->host_no);
+	snprintf(fc_host->work_q_name, sizeof(fc_host->work_q_name),
+		 "fc_wq_%d", shost->host_no);
 	fc_host->work_q = create_singlethread_workqueue(
 					fc_host->work_q_name);
 	if (!fc_host->work_q)
 		return -ENOMEM;
 
-	snprintf(fc_host->devloss_work_q_name, KOBJ_NAME_LEN, "fc_dl_%d",
-		shost->host_no);
+	snprintf(fc_host->devloss_work_q_name,
+		 sizeof(fc_host->devloss_work_q_name),
+		 "fc_dl_%d", shost->host_no);
 	fc_host->devloss_work_q = create_singlethread_workqueue(
 					fc_host->devloss_work_q_name);
 	if (!fc_host->devloss_work_q) {
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 06748f3..043c392 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -247,8 +247,8 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 	atomic_set(&ihost->nr_scans, 0);
 	mutex_init(&ihost->mutex);
 
-	snprintf(ihost->scan_workq_name, KOBJ_NAME_LEN, "iscsi_scan_%d",
-		shost->host_no);
+	snprintf(ihost->scan_workq_name, sizeof(ihost->scan_workq_name),
+		 "iscsi_scan_%d", shost->host_no);
 	ihost->scan_workq = create_singlethread_workqueue(
 						ihost->scan_workq_name);
 	if (!ihost->scan_workq)
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 6149e4b..efef715 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -401,7 +401,7 @@ void register_disk(struct gendisk *disk)
 	disk->dev.parent = disk->driverfs_dev;
 	disk->dev.devt = MKDEV(disk->major, disk->first_minor);
 
-	strlcpy(disk->dev.bus_id, disk->disk_name, KOBJ_NAME_LEN);
+	strlcpy(disk->dev.bus_id, disk->disk_name, BUS_ID_SIZE);
 	/* ewww... some of these buggers have / in the name... */
 	s = strchr(disk->dev.bus_id, '/');
 	if (s)
diff --git a/include/linux/device.h b/include/linux/device.h
index 0e1d24c..fba1bb0 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -29,8 +29,7 @@
 /* DEVICE_NAME_HALF is really less than half to accommodate slop */
 #define DEVICE_NAME_HALF	__stringify(20)
 #define DEVICE_ID_SIZE		32
-#define BUS_ID_SIZE		KOBJ_NAME_LEN
-
+#define BUS_ID_SIZE		20
 
 struct device;
 struct device_driver;
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 39e709f..d542faa 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -26,7 +26,6 @@
 #include <linux/wait.h>
 #include <asm/atomic.h>
 
-#define KOBJ_NAME_LEN			20
 #define UEVENT_HELPER_PATH_LEN		256
 #define UEVENT_NUM_ENVP			32	/* number of env pointers */
 #define UEVENT_BUFFER_SIZE		2048	/* buffer for the variables */
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 387e428..b9a76c9 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -733,7 +733,7 @@ struct spi_board_info {
 	 * controller_data goes to spi_device.controller_data,
 	 * irq is copied too
 	 */
-	char		modalias[KOBJ_NAME_LEN];
+	char		modalias[32];
 	const void	*platform_data;
 	void		*controller_data;
 	int		irq;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 1834fdf..a594bac 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -623,7 +623,7 @@ struct Scsi_Host {
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-	char work_q_name[KOBJ_NAME_LEN];
+	char work_q_name[20];
 	struct workqueue_struct *work_q;
 
 	/*
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 06f72ba..878373c 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -489,9 +489,9 @@ struct fc_host_attrs {
 	u16 npiv_vports_inuse;
 
 	/* work queues for rport state manipulation */
-	char work_q_name[KOBJ_NAME_LEN];
+	char work_q_name[20];
 	struct workqueue_struct *work_q;
-	char devloss_work_q_name[KOBJ_NAME_LEN];
+	char devloss_work_q_name[20];
 	struct workqueue_struct *devloss_work_q;
 };
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index f5444e0..8b6c91d 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -198,7 +198,7 @@ struct iscsi_cls_host {
 	atomic_t nr_scans;
 	struct mutex mutex;
 	struct workqueue_struct *scan_workq;
-	char scan_workq_name[KOBJ_NAME_LEN];
+	char scan_workq_name[20];
 };
 
 extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
-- 
1.5.6.3

