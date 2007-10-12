Return-Path: <linux-kernel-owner+w=401wt.eu-S932766AbXJLWY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbXJLWY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761071AbXJLWSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759692AbXJLWSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/75] kobjects: fix up improper use of the kobject name field
Date: Fri, 12 Oct 2007 15:16:16 -0700
Message-Id: <11922274941588-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922274901810-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
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
 drivers/net/ibmveth.c     |    2 +-
 drivers/pci/setup-irq.c   |    2 +-
 fs/partitions/check.c     |   12 +++++++-----
 fs/sysfs/dir.c            |    2 +-
 net/bridge/br_sysfs_br.c  |    2 +-
 10 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index c6d153d..b9c518a 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -186,7 +186,7 @@ static elevator_t *elevator_alloc(struct request_queue *q,
 	eq->ops = &e->ops;
 	eq->elevator_type = e;
 	kobject_init(&eq->kobj);
-	snprintf(eq->kobj.name, KOBJ_NAME_LEN, "%s", "iosched");
+	kobject_set_name(&eq->kobj, "%s", "iosched");
 	eq->kobj.ktype = &elv_ktype;
 	mutex_init(&eq->sysfs_lock);
 
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index cd9d2c5..d875673 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1854,7 +1854,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	init_timer(&q->unplug_timer);
 
-	snprintf(q->kobj.name, KOBJ_NAME_LEN, "%s", "queue");
+	kobject_set_name(&q->kobj, "%s", "queue");
 	q->kobj.ktype = &queue_ktype;
 	kobject_init(&q->kobj);
 
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index feab124..cbfc815 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -194,7 +194,7 @@ int acpi_bus_set_power(acpi_handle handle, int state)
 
 	if (!device->flags.power_manageable) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device `[%s]' is not power manageable\n",
-				device->dev.kobj.name));
+				kobject_name(&device->dev.kobj)));
 		return -ENODEV;
 	}
 	/*
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2f6a73c..2ce3de5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -828,7 +828,7 @@ static int cpufreq_add_dev (struct sys_device * sys_dev)
 	/* prepare interface data */
 	policy->kobj.parent = &sys_dev->kobj;
 	policy->kobj.ktype = &ktype_cpufreq;
-	strlcpy(policy->kobj.name, "cpufreq", KOBJ_NAME_LEN);
+	kobject_set_name(&policy->kobj, "cpufreq");
 
 	ret = kobject_register(&policy->kobj);
 	if (ret) {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index e8f102e..acf1b81 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3076,8 +3076,7 @@ static struct kobject *md_probe(dev_t dev, int *part, void *data)
 	mddev->gendisk = disk;
 	mutex_unlock(&disks_mutex);
 	mddev->kobj.parent = &disk->kobj;
-	mddev->kobj.k_name = NULL;
-	snprintf(mddev->kobj.name, KOBJ_NAME_LEN, "%s", "md");
+	kobject_set_name(&mddev->kobj, "%s", "md");
 	mddev->kobj.ktype = &md_ktype;
 	if (kobject_register(&mddev->kobj))
 		printk(KERN_WARNING "md: cannot register %s/md - name in use\n",
diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index 4ac161e..7d7758f 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -1183,7 +1183,7 @@ static int __devinit ibmveth_probe(struct vio_dev *dev, const struct vio_device_
 					 pool_count[i], pool_size[i],
 					 pool_active[i]);
 		kobj->parent = &dev->dev.kobj;
-		sprintf(kobj->name, "pool%d", i);
+		kobject_set_name(kobj, "pool%d", i);
 		kobj->ktype = &ktype_veth_pool;
 		kobject_register(kobj);
 	}
diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
index 568f187..05ca2ed 100644
--- a/drivers/pci/setup-irq.c
+++ b/drivers/pci/setup-irq.c
@@ -48,7 +48,7 @@ pdev_fixup_irq(struct pci_dev *dev,
 	dev->irq = irq;
 
 	pr_debug("PCI: fixup irq: (%s) got %d\n",
-		dev->dev.kobj.name, dev->irq);
+		kobject_name(&dev->dev.kobj), dev->irq);
 
 	/* Always tell the device, so the driver knows what is
 	   the real IRQ to use; the device does not use it. */
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 783c57e..722e12e 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -381,10 +381,12 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
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
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 83e76b3..ea33b66 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1013,7 +1013,7 @@ again:
 		goto again;
 	}
 
-	new_dentry = lookup_one_len(kobj->name, new_parent, strlen(kobj->name));
+	new_dentry = lookup_one_len(kobject_name(kobj), new_parent, strlen(kobject_name(kobj)));
 	if (IS_ERR(new_dentry)) {
 		error = PTR_ERR(new_dentry);
 		goto out_unlock;
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index c65f54e..3312e8f 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -435,7 +435,7 @@ int br_sysfs_addbr(struct net_device *dev)
 	err = kobject_register(&br->ifobj);
 	if (err) {
 		pr_info("%s: can't add kobject (directory) %s/%s\n",
-			__FUNCTION__, dev->name, br->ifobj.name);
+			__FUNCTION__, dev->name, kobject_name(&br->ifobj));
 		goto out3;
 	}
 	return 0;
-- 
1.5.3.4

