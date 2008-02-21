Return-Path: <linux-kernel-owner+w=401wt.eu-S936293AbYBUXwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936293AbYBUXwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935879AbYBUXso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:48:44 -0500
Received: from ns2.suse.de ([195.135.220.15]:52793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935872AbYBUXsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:48:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Brandon Philips <brandon@ifup.org>, Brandon Philips <bphilips@suse.de>,
       "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/11] UIO: fix Greg's stupid changes
Date: Thu, 21 Feb 2008 15:48:04 -0800
Message-Id: <1203637687-7273-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080221234649.GB7128@kroah.com>
References: <20080221234649.GB7128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brandon Philips <brandon@ifup.org>

This fixes two bugs with UIO that cropped up recently in -rc1

1) WARNING: at fs/sysfs/file.c:334 sysfs_open_file when trying to open
   a map addr/size file - complaining about missing sysfs_ops for ktype

2) Permission denied when reading uio/uio0/maps/map0/{addr,size} when
   files are mode S_IRUGO

Also fix a typo: attr_attribute -> addr_attribute

Signed-off-by: Brandon Philips <bphilips@suse.de>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |   54 ++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 2a77e9d..e8a01f2 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -57,29 +57,29 @@ struct uio_map {
 };
 #define to_map(map) container_of(map, struct uio_map, kobj)
 
-
-static ssize_t map_attr_show(struct kobject *kobj, struct kobj_attribute *attr,
-			     char *buf)
+static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
 {
-	struct uio_map *map = to_map(kobj);
-	struct uio_mem *mem = map->mem;
-
-	if (strncmp(attr->attr.name, "addr", 4) == 0)
-		return sprintf(buf, "0x%lx\n", mem->addr);
-
-	if (strncmp(attr->attr.name, "size", 4) == 0)
-		return sprintf(buf, "0x%lx\n", mem->size);
+	return sprintf(buf, "0x%lx\n", mem->addr);
+}
 
-	return -ENODEV;
+static ssize_t map_size_show(struct uio_mem *mem, char *buf)
+{
+	return sprintf(buf, "0x%lx\n", mem->size);
 }
 
-static struct kobj_attribute attr_attribute =
-	__ATTR(addr, S_IRUGO, map_attr_show, NULL);
-static struct kobj_attribute size_attribute =
-	__ATTR(size, S_IRUGO, map_attr_show, NULL);
+struct uio_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct uio_mem *, char *);
+	ssize_t (*store)(struct uio_mem *, const char *, size_t);
+};
+
+static struct uio_sysfs_entry addr_attribute =
+	__ATTR(addr, S_IRUGO, map_addr_show, NULL);
+static struct uio_sysfs_entry size_attribute =
+	__ATTR(size, S_IRUGO, map_size_show, NULL);
 
 static struct attribute *attrs[] = {
-	&attr_attribute.attr,
+	&addr_attribute.attr,
 	&size_attribute.attr,
 	NULL,	/* need to NULL terminate the list of attributes */
 };
@@ -90,8 +90,28 @@ static void map_release(struct kobject *kobj)
 	kfree(map);
 }
 
+static ssize_t map_type_show(struct kobject *kobj, struct attribute *attr,
+			     char *buf)
+{
+	struct uio_map *map = to_map(kobj);
+	struct uio_mem *mem = map->mem;
+	struct uio_sysfs_entry *entry;
+
+	entry = container_of(attr, struct uio_sysfs_entry, attr);
+
+	if (!entry->show)
+		return -EIO;
+
+	return entry->show(mem, buf);
+}
+
+static struct sysfs_ops uio_sysfs_ops = {
+	.show = map_type_show,
+};
+
 static struct kobj_type map_attr_type = {
 	.release	= map_release,
+	.sysfs_ops	= &uio_sysfs_ops,
 	.default_attrs	= attrs,
 };
 
-- 
1.5.4

