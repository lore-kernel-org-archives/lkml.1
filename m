Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXIMXuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXIMXuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932914AbXIMXpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:45:22 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41165 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913AbXIMXpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:45:19 -0400
Date: Thu, 13 Sep 2007 16:43:45 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: kobjects: fix up improper use of the kobject name field
Message-ID: <20070913234345.GL10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913233751.GA10856@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


A number of different drivers incorrect access the kobject name field
directly.  This is not correct as the name might not be in the array.
Use the proper accessor function instead.

---
 block/elevator.c          |    2 +-
 block/ll_rw_blk.c         |    2 +-
 drivers/acpi/bus.c        |    2 +-
 drivers/cpufreq/cpufreq.c |    2 +-
 drivers/md/md.c           |    3 +--
 fs/partitions/check.c     |   12 +++++++-----
 net/bridge/br_sysfs_br.c  |    2 +-
 7 files changed, 13 insertions(+), 12 deletions(-)

--- a/block/elevator.c
+++ b/block/elevator.c
@@ -186,7 +186,7 @@ static elevator_t *elevator_alloc(struct
 	eq->ops = &e->ops;
 	eq->elevator_type = e;
 	kobject_init(&eq->kobj);
-	snprintf(eq->kobj.name, KOBJ_NAME_LEN, "%s", "iosched");
+	kobject_set_name(&eq->kobj, "%s", "iosched");
 	eq->kobj.ktype = &elv_ktype;
 	mutex_init(&eq->sysfs_lock);
 
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1841,7 +1841,7 @@ struct request_queue *blk_alloc_queue_no
 
 	init_timer(&q->unplug_timer);
 
-	snprintf(q->kobj.name, KOBJ_NAME_LEN, "%s", "queue");
+	kobject_set_name(&q->kobj, "%s", "queue");
 	q->kobj.ktype = &queue_ktype;
 	kobject_init(&q->kobj);
 
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -194,7 +194,7 @@ int acpi_bus_set_power(acpi_handle handl
 
 	if (!device->flags.power_manageable) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device `[%s]' is not power manageable\n",
-				device->dev.kobj.name));
+				kobject_name(&device->dev.kobj)));
 		return -ENODEV;
 	}
 	/*
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -828,7 +828,7 @@ static int cpufreq_add_dev (struct sys_d
 	/* prepare interface data */
 	policy->kobj.parent = &sys_dev->kobj;
 	policy->kobj.ktype = &ktype_cpufreq;
-	strlcpy(policy->kobj.name, "cpufreq", KOBJ_NAME_LEN);
+	kobject_set_name(&policy->kobj, "cpufreq");
 
 	ret = kobject_register(&policy->kobj);
 	if (ret) {
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3085,8 +3085,7 @@ static struct kobject *md_probe(dev_t de
 	mddev->gendisk = disk;
 	mutex_unlock(&disks_mutex);
 	mddev->kobj.parent = &disk->kobj;
-	mddev->kobj.k_name = NULL;
-	snprintf(mddev->kobj.name, KOBJ_NAME_LEN, "%s", "md");
+	kobject_set_name(&mddev->kobj, "%s", "md");
 	mddev->kobj.ktype = &md_ktype;
 	if (kobject_register(&mddev->kobj))
 		printk(KERN_WARNING "md: cannot register %s/md - name in use\n",
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -381,10 +381,12 @@ void add_partition(struct gendisk *disk,
 	p->partno = part;
 	p->policy = disk->policy;
 
-	if (isdigit(disk->kobj.name[strlen(disk->kobj.name)-1]))
-		snprintf(p->kobj.name,KOBJ_NAME_LEN,"%sp%d",disk->kobj.name,part);
+	if (isdigit(disk->kobj.k_name[strlen(disk->kobj.k_name)-1]))
+		kobject_set_name(&p->kobj, "%sp%d",
+				 kobject_name(&disk->kobj), part);
 	else
-		snprintf(p->kobj.name,KOBJ_NAME_LEN,"%s%d",disk->kobj.name,part);
+		kobject_set_name(&p->kobj, "%s%d",
+				 kobject_name(&disk->kobj),part);
 	p->kobj.parent = &disk->kobj;
 	p->kobj.ktype = &ktype_part;
 	kobject_init(&p->kobj);
@@ -477,9 +479,9 @@ void register_disk(struct gendisk *disk)
 	struct hd_struct *p;
 	int err;
 
-	strlcpy(disk->kobj.name,disk->disk_name,KOBJ_NAME_LEN);
+	kobject_set_name(&disk->kobj, "%s", disk->disk_name);
 	/* ewww... some of these buggers have / in name... */
-	s = strchr(disk->kobj.name, '/');
+	s = strchr(disk->kobj.k_name, '/');
 	if (s)
 		*s = '!';
 	if ((err = kobject_add(&disk->kobj)))
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -435,7 +435,7 @@ int br_sysfs_addbr(struct net_device *de
 	err = kobject_register(&br->ifobj);
 	if (err) {
 		pr_info("%s: can't add kobject (directory) %s/%s\n",
-			__FUNCTION__, dev->name, br->ifobj.name);
+			__FUNCTION__, dev->name, kobject_name(&br->ifobj));
 		goto out3;
 	}
 	return 0;
