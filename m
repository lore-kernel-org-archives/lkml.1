Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbYKWMOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbYKWMOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 07:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbYKWMOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 07:14:34 -0500
Received: from www.tglx.de ([62.245.132.106]:42804 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250AbYKWMOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 07:14:33 -0500
Date: Sun, 23 Nov 2008 13:14:20 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Mike Frysinger <vapier@gentoo.org>,
       John Ogness <jogness@linutronix.de>,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH RFC] UIO: Pass information about ioports to userspace
Message-ID: <20081123121419.GA3087@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices sometimes have memory where all or parts of it can not be mapped to
userspace. But it might still be possible to access this memory from
userspace by other means. An example are PCI cards that advertise not only
mappable memory but also ioport ranges. On x86 architectures, these can be
accessed with ioperm, iopl, inb, outb, and friends. Mike Frysinger (CCed)
reported a similar problem on Blackfin arch where it doesn't seem to be easy
to mmap non-cached memory but it can still be accessed from userspace.

This patch allows kernel drivers to pass information about such ports to
userspace. Similar to the existing mem[] array, it adds a port[] array to
struct uio_info. Each port range is described by start, size, and porttype.

If a driver fills in at least one such port range, the UIO core will simply
pass this information to userspace by creating a new directory "portio"
underneath /sys/class/uio/uioN/. Similar to the "mem" directory, it will
contain a subdirectory (portX) for each port range given.

Note that UIO simply passes this information to userspace, it performs no
action whatsoever with this data. It's userspace's responsibility to obtain
access to these ports and to solve arch dependent issues. The "porttype"
attribute tells userspace what kind of port it is dealing with.

This mechanism could also be used to give userspace information about GPIOs
related to a device. You frequently find such hardware in embedded devices,
so I added a UIO_PORT_GPIO definition. I'm not really sure if this is a good
idea since there are other solutions to this problem, but it won't hurt much
anyway.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

---
 drivers/uio/uio.c          |  154 ++++++++++++++++++++++++++++++++++++++++-----
 include/linux/uio_driver.h |   25 +++++++
 2 files changed, 162 insertions(+), 17 deletions(-)

Index: linux-2.6.28-rc/drivers/uio/uio.c
===================================================================
--- linux-2.6.28-rc.orig/drivers/uio/uio.c	2008-11-23 12:20:00.000000000 +0100
+++ linux-2.6.28-rc/drivers/uio/uio.c	2008-11-23 13:07:55.000000000 +0100
@@ -35,6 +35,7 @@
 	int			vma_count;
 	struct uio_info		*info;
 	struct kobject		*map_dir;
+	struct kobject		*portio_dir;
 };
 
 static int uio_major;
@@ -75,17 +76,17 @@
 	return sprintf(buf, "0x%lx\n", mem->addr & ~PAGE_MASK);
 }
 
-struct uio_sysfs_entry {
+struct map_sysfs_entry {
 	struct attribute attr;
 	ssize_t (*show)(struct uio_mem *, char *);
 	ssize_t (*store)(struct uio_mem *, const char *, size_t);
 };
 
-static struct uio_sysfs_entry addr_attribute =
+static struct map_sysfs_entry addr_attribute =
 	__ATTR(addr, S_IRUGO, map_addr_show, NULL);
-static struct uio_sysfs_entry size_attribute =
+static struct map_sysfs_entry size_attribute =
 	__ATTR(size, S_IRUGO, map_size_show, NULL);
-static struct uio_sysfs_entry offset_attribute =
+static struct map_sysfs_entry offset_attribute =
 	__ATTR(offset, S_IRUGO, map_offset_show, NULL);
 
 static struct attribute *attrs[] = {
@@ -106,9 +107,9 @@
 {
 	struct uio_map *map = to_map(kobj);
 	struct uio_mem *mem = map->mem;
-	struct uio_sysfs_entry *entry;
+	struct map_sysfs_entry *entry;
 
-	entry = container_of(attr, struct uio_sysfs_entry, attr);
+	entry = container_of(attr, struct map_sysfs_entry, attr);
 
 	if (!entry->show)
 		return -EIO;
@@ -116,16 +117,88 @@
 	return entry->show(mem, buf);
 }
 
-static struct sysfs_ops uio_sysfs_ops = {
+static struct sysfs_ops map_sysfs_ops = {
 	.show = map_type_show,
 };
 
 static struct kobj_type map_attr_type = {
 	.release	= map_release,
-	.sysfs_ops	= &uio_sysfs_ops,
+	.sysfs_ops	= &map_sysfs_ops,
 	.default_attrs	= attrs,
 };
 
+struct uio_portio {
+	struct kobject kobj;
+	struct uio_port *port;
+};
+#define to_portio(portio) container_of(portio, struct uio_portio, kobj)
+
+static ssize_t portio_start_show(struct uio_port *port, char *buf)
+{
+	return sprintf(buf, "0x%lx\n", port->start);
+}
+
+static ssize_t portio_size_show(struct uio_port *port, char *buf)
+{
+	return sprintf(buf, "0x%lx\n", port->size);
+}
+
+static ssize_t portio_porttype_show(struct uio_port *port, char *buf)
+{
+	return sprintf(buf, "0x%x\n", port->porttype);
+}
+
+struct portio_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct uio_port *, char *);
+	ssize_t (*store)(struct uio_port *, const char *, size_t);
+};
+
+static struct portio_sysfs_entry portio_start_attribute =
+	__ATTR(start, S_IRUGO, portio_start_show, NULL);
+static struct portio_sysfs_entry portio_size_attribute =
+	__ATTR(size, S_IRUGO, portio_size_show, NULL);
+static struct portio_sysfs_entry portio_porttype_attribute =
+	__ATTR(porttype, S_IRUGO, portio_porttype_show, NULL);
+
+static struct attribute *portio_attrs[] = {
+	&portio_start_attribute.attr,
+	&portio_size_attribute.attr,
+	&portio_porttype_attribute.attr,
+	NULL,
+};
+
+static void portio_release(struct kobject *kobj)
+{
+	struct uio_portio *portio = to_portio(kobj);
+	kfree(portio);
+}
+
+static ssize_t portio_type_show(struct kobject *kobj, struct attribute *attr,
+			     char *buf)
+{
+	struct uio_portio *portio = to_portio(kobj);
+	struct uio_port *port = portio->port;
+	struct portio_sysfs_entry *entry;
+
+	entry = container_of(attr, struct portio_sysfs_entry, attr);
+
+	if (!entry->show)
+		return -EIO;
+
+	return entry->show(port, buf);
+}
+
+static struct sysfs_ops portio_sysfs_ops = {
+	.show = portio_type_show,
+};
+
+static struct kobj_type portio_attr_type = {
+	.release	= portio_release,
+	.sysfs_ops	= &portio_sysfs_ops,
+	.default_attrs	= portio_attrs,
+};
+
 static ssize_t show_name(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
@@ -177,10 +250,13 @@
 static int uio_dev_add_attributes(struct uio_device *idev)
 {
 	int ret;
-	int mi;
+	int mi, pi;
 	int map_found = 0;
+	int portio_found = 0;
 	struct uio_mem *mem;
 	struct uio_map *map;
+	struct uio_port *port;
+	struct uio_portio *portio;
 
 	ret = sysfs_create_group(&idev->dev->kobj, &uio_attr_grp);
 	if (ret)
@@ -195,25 +271,58 @@
 			idev->map_dir = kobject_create_and_add("maps",
 							&idev->dev->kobj);
 			if (!idev->map_dir)
-				goto err;
+				goto err_map;
 		}
 		map = kzalloc(sizeof(*map), GFP_KERNEL);
 		if (!map)
-			goto err;
+			goto err_map;
 		kobject_init(&map->kobj, &map_attr_type);
 		map->mem = mem;
 		mem->map = map;
 		ret = kobject_add(&map->kobj, idev->map_dir, "map%d", mi);
 		if (ret)
-			goto err;
+			goto err_map;
 		ret = kobject_uevent(&map->kobj, KOBJ_ADD);
 		if (ret)
-			goto err;
+			goto err_map;
+	}
+
+	for (pi = 0; pi < MAX_UIO_PORT_REGIONS; pi++) {
+		port = &idev->info->port[pi];
+		if (port->size == 0)
+			break;
+		if (!portio_found) {
+			portio_found = 1;
+			idev->portio_dir = kobject_create_and_add("portio",
+							&idev->dev->kobj);
+			if (!idev->portio_dir)
+				goto err_portio;
+		}
+		portio = kzalloc(sizeof(*portio), GFP_KERNEL);
+		if (!portio)
+			goto err_portio;
+		kobject_init(&portio->kobj, &portio_attr_type);
+		portio->port = port;
+		port->portio = portio;
+		ret = kobject_add(&portio->kobj, idev->portio_dir,
+							"port%d", pi);
+		if (ret)
+			goto err_portio;
+		ret = kobject_uevent(&portio->kobj, KOBJ_ADD);
+		if (ret)
+			goto err_portio;
 	}
 
 	return 0;
 
-err:
+err_portio:
+	for (pi--; pi >= 0; pi--) {
+		port = &idev->info->port[pi];
+		portio = port->portio;
+		kobject_put(&portio->kobj);
+	}
+	kobject_put(idev->portio_dir);
+err_map:
 	for (mi--; mi>=0; mi--) {
 		mem = &idev->info->mem[mi];
 		map = mem->map;
@@ -228,15 +337,26 @@
 
 static void uio_dev_del_attributes(struct uio_device *idev)
 {
-	int mi;
+	int i;
 	struct uio_mem *mem;
-	for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
-		mem = &idev->info->mem[mi];
+	struct uio_port *port;
+
+	for (i = 0; i < MAX_UIO_MAPS; i++) {
+		mem = &idev->info->mem[i];
 		if (mem->size == 0)
 			break;
 		kobject_put(&mem->map->kobj);
 	}
 	kobject_put(idev->map_dir);
+
+	for (i = 0; i < MAX_UIO_PORT_REGIONS; i++) {
+		port = &idev->info->port[i];
+		if (port->size == 0)
+			break;
+		kobject_put(&port->portio->kobj);
+	}
+	kobject_put(idev->portio_dir);
+
 	sysfs_remove_group(&idev->dev->kobj, &uio_attr_grp);
 }
 
Index: linux-2.6.28-rc/include/linux/uio_driver.h
===================================================================
--- linux-2.6.28-rc.orig/include/linux/uio_driver.h	2008-11-23 12:20:00.000000000 +0100
+++ linux-2.6.28-rc/include/linux/uio_driver.h	2008-11-23 13:07:55.000000000 +0100
@@ -38,6 +38,24 @@
 
 #define MAX_UIO_MAPS	5
 
+struct uio_portio;
+
+/**
+ * struct uio_port - description of a UIO port region
+ * @start:		start of port region
+ * @size:		size of port region
+ * @porttype:		type of port (see UIO_PORT_* below)
+ * @portio:		for use by the UIO core only.
+ */
+struct uio_port {
+	unsigned long		start;
+	unsigned long		size;
+	int			porttype;
+	struct uio_portio	*portio;
+};
+
+#define MAX_UIO_PORT_REGIONS	5
+
 struct uio_device;
 
 /**
@@ -60,6 +78,7 @@
 	char			*name;
 	char			*version;
 	struct uio_mem		mem[MAX_UIO_MAPS];
+	struct uio_port		port[MAX_UIO_PORT_REGIONS];
 	long			irq;
 	unsigned long		irq_flags;
 	void			*priv;
@@ -92,4 +111,10 @@
 #define UIO_MEM_LOGICAL	2
 #define UIO_MEM_VIRTUAL 3
 
+/* defines for uio_port->porttype */
+#define UIO_PORT_NONE	0
+#define UIO_PORT_X86	1
+#define UIO_PORT_GPIO	2
+#define UIO_PORT_OTHER	3
+
 #endif /* _LINUX_UIO_DRIVER_H_ */
