Return-Path: <linux-kernel-owner+w=401wt.eu-S1030820AbXDXACr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030820AbXDXACr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030914AbXDXACr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:02:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:31206 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030820AbXDXACm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:02:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,443,1170662400"; 
   d="scan'208"; a="218359337:sNHT29367821"
Date: Mon, 23 Apr 2007 17:00:10 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 5/7] genhd: send async notification on media change
Message-Id: <20070423170010.5514072e.kristen.c.accardi@intel.com>
In-Reply-To: <20070424074856.005152262@intel.com>
References: <20070424074856.005152262@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Send an uevent to user space to indicate that a media change event has occurred.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/block/genhd.c
===================================================================
--- 2.6-git.orig/block/genhd.c
+++ 2.6-git/block/genhd.c
@@ -643,6 +643,25 @@ struct seq_operations diskstats_op = {
 	.show	= diskstats_show
 };
 
+static void media_change_notify_thread(struct work_struct *work)
+{
+	struct gendisk *gd = container_of(work, struct gendisk, async_notify);
+	char event[] = "MEDIA_CHANGE=1";
+	char *envp[] = { event, NULL };
+
+	/*
+	 * set enviroment vars to indicate which event this is for
+	 * so that user space will know to go check the media status.
+	 */
+	kobject_uevent_env(&gd->kobj, KOBJ_CHANGE, envp);
+}
+
+void genhd_media_change_notify(struct gendisk *disk)
+{
+	schedule_work(&disk->async_notify);
+}
+EXPORT_SYMBOL_GPL(genhd_media_change_notify);
+
 struct gendisk *alloc_disk(int minors)
 {
 	return alloc_disk_node(minors, -1);
@@ -672,6 +691,8 @@ struct gendisk *alloc_disk_node(int mino
 		kobj_set_kset_s(disk,block_subsys);
 		kobject_init(&disk->kobj);
 		rand_initialize_disk(disk);
+		INIT_WORK(&disk->async_notify,
+			media_change_notify_thread);
 	}
 	return disk;
 }
Index: 2.6-git/include/linux/genhd.h
===================================================================
--- 2.6-git.orig/include/linux/genhd.h
+++ 2.6-git/include/linux/genhd.h
@@ -66,6 +66,7 @@ struct partition {
 #include <linux/smp.h>
 #include <linux/string.h>
 #include <linux/fs.h>
+#include <linux/workqueue.h>
 
 struct partition {
 	unsigned char boot_ind;		/* 0x80 - active */
@@ -139,6 +140,7 @@ struct gendisk {
 #else
 	struct disk_stats dkstats;
 #endif
+	struct work_struct async_notify;
 };
 
 /* Structure for sysfs attributes on block devices */
@@ -419,7 +421,7 @@ extern struct gendisk *alloc_disk_node(i
 extern struct gendisk *alloc_disk(int minors);
 extern struct kobject *get_disk(struct gendisk *disk);
 extern void put_disk(struct gendisk *disk);
-
+extern void genhd_media_change_notify(struct gendisk *disk);
 extern void blk_register_region(dev_t dev, unsigned long range,
 			struct module *module,
 			struct kobject *(*probe)(dev_t, int *, void *),

-- 
