Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbYCERyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbYCERyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYCERyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:54:07 -0500
Received: from sacred.ru ([62.205.161.221]:54973 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYCERyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:54:06 -0500
Message-ID: <47CEDC62.5070907@openvz.org>
Date: Wed, 05 Mar 2008 20:46:10 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 8/9] Provide functions to manipulate block device mappings
References: <47CED717.60406@openvz.org>
In-Reply-To: <47CED717.60406@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 20:46:02 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This routines were already done for char devices, these ones
are for block devices. Everything is the same, but the locks,
probe and match callbacks and kobj-to-device conversions.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 block/genhd.c         |   67 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/genhd.h |    8 ++++++
 2 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index a619158..f407f62 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -204,6 +204,73 @@ void unlink_gendisk(struct gendisk *disk)
 			      disk->minors);
 }
 
+#ifdef CONFIG_CGROUP_DEVS
+int bdev_add_to_map(struct kobj_map *map, dev_t dev, int all, mode_t mode)
+{
+	int tmp;
+	struct kobject *kobj;
+	struct device *d;
+	struct gendisk *disk;
+
+	kobj = kobj_lookup(bdev_map, dev, NULL, &tmp);
+	if (kobj == NULL)
+		return -ENODEV;
+
+	d = kobj_to_dev(kobj);
+	disk = dev_to_disk(d);
+	tmp = kobj_remap(map, dev, mode, all ? MINORBITS : 1, NULL,
+			exact_match, exact_lock, disk);
+	if (tmp < 0) {
+		put_disk(disk);
+		return tmp;
+	}
+
+	return 0;
+}
+
+int bdev_del_from_map(struct kobj_map *map, dev_t dev, int all)
+{
+	int tmp;
+	struct kobject *kobj;
+	struct device *d;
+	struct gendisk *disk;
+
+	kobj = kobj_lookup(map, dev, NULL, &tmp);
+	if (kobj == NULL)
+		return -ENODEV;
+
+	d = kobj_to_dev(kobj);
+	disk = dev_to_disk(d);
+	kobj_unmap(map, dev, all ? MINORBITS : 1);
+
+	/*
+	 * one put for the kobj_lookup above and one for
+	 * the kobj_lookup in bdev_add_to_map
+	 */
+	put_disk(disk);
+	put_disk(disk);
+	return 0;
+}
+
+void bdev_iterate_map(struct kobj_map *map,
+		int (*fn)(dev_t, int, mode_t, void *), void *x)
+{
+	kobj_map_iterate(map, fn, x);
+}
+
+static struct kobject *base_probe(dev_t devt, int *part, void *data);
+
+struct kobj_map *bdev_map_init(void)
+{
+	return kobj_map_init(base_probe, &block_class_lock);
+}
+
+void bdev_map_fini(struct kobj_map *map)
+{
+	kobj_map_fini(map);
+}
+#endif
+
 /**
  * get_gendisk - get partitioning information for a given device
  * @dev: device to get partitioning information for
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e09df44..c5483fc 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -373,6 +373,14 @@ extern void del_gendisk(struct gendisk *gp);
 extern void unlink_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, mode_t *mode, int *part);
 
+struct kobj_map;
+extern int bdev_add_to_map(struct kobj_map *, dev_t dev, int all, mode_t mode);
+extern int bdev_del_from_map(struct kobj_map *map, dev_t dev, int all);
+extern void bdev_iterate_map(struct kobj_map *map,
+		int (*fn)(dev_t, int, mode_t, void *), void *x);
+extern struct kobj_map *bdev_map_init(void);
+extern void bdev_map_fini(struct kobj_map *map);
+
 extern void set_device_ro(struct block_device *bdev, int flag);
 extern void set_disk_ro(struct gendisk *disk, int flag);
 
-- 
1.5.3.4

