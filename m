Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbZH0JJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbZH0JJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZH0JJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:09:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45819 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZH0JJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:09:01 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: tj@kernel.org, alan@lxorguk.ukuu.org.uk, jeff@garzik.org,
       dhowells@redhat.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 3/3] libata: switch pio task from workqueue to slow-work
Date: Thu, 27 Aug 2009 11:08:42 +0200
Message-Id: <1251364122-9592-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1251364122-9592-3-git-send-email-jens.axboe@oracle.com>
References: <1251364122-9592-1-git-send-email-jens.axboe@oracle.com>
 <1251364122-9592-2-git-send-email-jens.axboe@oracle.com>
 <1251364122-9592-3-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A workqueue isn't a good fit for the pio task:

- It does not require per-CPU support, thus wasting many threads.
- The pio task would like to have more than one thread per CPU
  in some cases, for the single CPU case of having more than one
  pio device active.

So convert to slow-work instead, this is now possible with support
for delayed slow work and cancellation.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/ata/libata-core.c |   35 ++++++++++++++++++++++-------------
 drivers/ata/libata-sff.c  |    2 +-
 drivers/ata/libata.h      |    2 +-
 include/linux/libata.h    |    3 ++-
 4 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 072ba5e..e3f55a2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -95,7 +95,6 @@ static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
 unsigned int ata_print_id = 1;
-static struct workqueue_struct *ata_wq;
 
 struct workqueue_struct *ata_aux_wq;
 
@@ -1700,7 +1699,7 @@ void ata_pio_queue_task(struct ata_port *ap, void *data, unsigned long delay)
 	ap->port_task_data = data;
 
 	/* may fail if ata_port_flush_task() in progress */
-	queue_delayed_work(ata_wq, &ap->port_task, msecs_to_jiffies(delay));
+	delayed_slow_work_enqueue(&ap->port_task, msecs_to_jiffies(delay));
 }
 
 /**
@@ -1717,7 +1716,7 @@ void ata_port_flush_task(struct ata_port *ap)
 {
 	DPRINTK("ENTER\n");
 
-	cancel_rearming_delayed_work(&ap->port_task);
+	cancel_delayed_slow_work(&ap->port_task);
 
 	if (ata_msg_ctl(ap))
 		ata_port_printk(ap, KERN_DEBUG, "%s: EXIT\n", __func__);
@@ -5600,6 +5599,20 @@ int sata_link_init_spd(struct ata_link *link)
 	return 0;
 }
 
+static int ata_slow_work_get(struct slow_work *work)
+{
+	return 0;
+}
+
+static const struct slow_work_ops ata_work_ops_sff = {
+	.get_ref	= ata_slow_work_get,
+	.execute	= ata_pio_task,
+};
+
+static const struct slow_work_ops ata_work_ops = {
+	.get_ref	= ata_slow_work_get,
+};
+
 /**
  *	ata_port_alloc - allocate and initialize basic ATA port resources
  *	@host: ATA host this allocated port belongs to
@@ -5641,9 +5654,9 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 #endif
 
 #ifdef CONFIG_ATA_SFF
-	INIT_DELAYED_WORK(&ap->port_task, ata_pio_task);
+	delayed_slow_work_init(&ap->port_task, &ata_work_ops_sff);
 #else
-	INIT_DELAYED_WORK(&ap->port_task, NULL);
+	delayed_slow_work_init(&ap->port_task, &ata_work_ops);
 #endif
 	INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
 	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
@@ -6580,19 +6593,15 @@ static int __init ata_init(void)
 {
 	ata_parse_force_param();
 
-	ata_wq = create_workqueue("ata");
-	if (!ata_wq)
-		goto free_force_tbl;
-
 	ata_aux_wq = create_singlethread_workqueue("ata_aux");
 	if (!ata_aux_wq)
-		goto free_wq;
+		goto free_force_tbl;
+
+	slow_work_register_user();
 
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;
 
-free_wq:
-	destroy_workqueue(ata_wq);
 free_force_tbl:
 	kfree(ata_force_tbl);
 	return -ENOMEM;
@@ -6601,8 +6610,8 @@ free_force_tbl:
 static void __exit ata_exit(void)
 {
 	kfree(ata_force_tbl);
-	destroy_workqueue(ata_wq);
 	destroy_workqueue(ata_aux_wq);
+	slow_work_unregister_user();
 }
 
 subsys_initcall(ata_init);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index bbbb1fa..f795ab7 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1454,7 +1454,7 @@ fsm_start:
 }
 EXPORT_SYMBOL_GPL(ata_sff_hsm_move);
 
-void ata_pio_task(struct work_struct *work)
+void ata_pio_task(struct slow_work *work)
 {
 	struct ata_port *ap =
 		container_of(work, struct ata_port, port_task.work);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 89a1e00..d48d14d 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -202,7 +202,7 @@ static inline int sata_pmp_attach(struct ata_device *dev)
 extern void ata_dev_select(struct ata_port *ap, unsigned int device,
                            unsigned int wait, unsigned int can_sleep);
 extern u8 ata_irq_on(struct ata_port *ap);
-extern void ata_pio_task(struct work_struct *work);
+extern void ata_pio_task(struct slow_work *work);
 #endif /* CONFIG_ATA_SFF */
 
 #endif /* __LIBATA_H__ */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e5b6e33..6830c82 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -34,6 +34,7 @@
 #include <linux/io.h>
 #include <linux/ata.h>
 #include <linux/workqueue.h>
+#include <linux/slow-work.h>
 #include <scsi/scsi_host.h>
 #include <linux/acpi.h>
 #include <linux/cdrom.h>
@@ -734,7 +735,7 @@ struct ata_port {
 	struct device 		*dev;
 
 	void			*port_task_data;
-	struct delayed_work	port_task;
+	struct delayed_slow_work	port_task;
 	struct delayed_work	hotplug_task;
 	struct work_struct	scsi_rescan_task;
 
-- 
1.6.4.1.207.g68ea

