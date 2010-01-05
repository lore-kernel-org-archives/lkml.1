Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517Ab0AELul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0AELul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341Ab0AELsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:48:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36329 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab0AELsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:48:09 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201001051247.104464547@firstfloor.org>
In-Reply-To: <201001051247.104464547@firstfloor.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] [10/12] SYSDEV: Add attribute argument to class_attribute show/store
Message-Id: <20100105114807.90132B17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 12:48:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Passing the attribute to the low level IO functions allows all kinds
of cleanups, by sharing low level IO code without requiring
an own function for every piece of data.

Also drivers can extend the attributes with own data fields
and use that in the low level function.

This makes the class attributes the same as sysdev_class attributes
and plain attributes.

This will allow further cleanups in drivers.

Full tree sweep converting all users.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/base/class.c                  |    4 ++--
 drivers/base/cpu.c                    |    8 ++++++--
 drivers/base/firmware_class.c         |    8 ++++++--
 drivers/base/memory.c                 |   11 ++++++++---
 drivers/block/osdblk.c                |   12 +++++++++---
 drivers/block/pktcdvd.c               |   12 +++++++++---
 drivers/gpio/gpiolib.c                |    8 ++++++--
 drivers/gpu/drm/drm_sysfs.c           |    3 ++-
 drivers/infiniband/core/ucm.c         |    4 +++-
 drivers/infiniband/core/user_mad.c    |    4 +++-
 drivers/infiniband/core/uverbs_main.c |    4 +++-
 drivers/misc/phantom.c                |    2 +-
 drivers/mtd/ubi/build.c               |    3 ++-
 drivers/net/bonding/bond_sysfs.c      |    5 ++++-
 drivers/staging/asus_oled/asus_oled.c |    4 +++-
 drivers/uwb/driver.c                  |    5 ++++-
 include/linux/device.h                |    6 ++++--
 net/bluetooth/l2cap.c                 |    4 +++-
 net/bluetooth/rfcomm/core.c           |    4 +++-
 net/bluetooth/rfcomm/sock.c           |    4 +++-
 net/bluetooth/sco.c                   |    4 +++-
 21 files changed, 87 insertions(+), 32 deletions(-)

Index: linux-2.6.33-rc2-ak/drivers/base/cpu.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/cpu.c
+++ linux-2.6.33-rc2-ak/drivers/base/cpu.c
@@ -79,13 +79,17 @@ void unregister_cpu(struct cpu *cpu)
 }
 
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
-static ssize_t cpu_probe_store(struct class *class, const char *buf,
+static ssize_t cpu_probe_store(struct class *class,
+				struct class_attribute *attr,
+				const char *buf,
 			       size_t count)
 {
 	return arch_cpu_probe(buf, count);
 }
 
-static ssize_t cpu_release_store(struct class *class, const char *buf,
+static ssize_t cpu_release_store(struct class *class,
+				struct class_attribute *attr,
+				const char *buf,
 				 size_t count)
 {
 	return arch_cpu_release(buf, count);
Index: linux-2.6.33-rc2-ak/drivers/base/firmware_class.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/firmware_class.c
+++ linux-2.6.33-rc2-ak/drivers/base/firmware_class.c
@@ -69,7 +69,9 @@ fw_load_abort(struct firmware_priv *fw_p
 }
 
 static ssize_t
-firmware_timeout_show(struct class *class, char *buf)
+firmware_timeout_show(struct class *class,
+		      struct class_attribute *attr,
+		      char *buf)
 {
 	return sprintf(buf, "%d\n", loading_timeout);
 }
@@ -87,7 +89,9 @@ firmware_timeout_show(struct class *clas
  *	Note: zero means 'wait forever'.
  **/
 static ssize_t
-firmware_timeout_store(struct class *class, const char *buf, size_t count)
+firmware_timeout_store(struct class *class,
+			struct class_attribute *attr,
+			const char *buf, size_t count)
 {
 	loading_timeout = simple_strtol(buf, NULL, 10);
 	if (loading_timeout < 0)
Index: linux-2.6.33-rc2-ak/drivers/base/memory.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/memory.c
+++ linux-2.6.33-rc2-ak/drivers/base/memory.c
@@ -331,7 +331,8 @@ static int block_size_init(void)
  */
 #ifdef CONFIG_ARCH_MEMORY_PROBE
 static ssize_t
-memory_probe_store(struct class *class, const char *buf, size_t count)
+memory_probe_store(struct class *class, struct class_attribute *attr,
+		   const char *buf, size_t count)
 {
 	u64 phys_addr;
 	int nid;
@@ -368,7 +369,9 @@ static inline int memory_probe_init(void
 
 /* Soft offline a page */
 static ssize_t
-store_soft_offline_page(struct class *class, const char *buf, size_t count)
+store_soft_offline_page(struct class *class,
+			struct class_attribute *attr,
+			const char *buf, size_t count)
 {
 	int ret;
 	u64 pfn;
@@ -385,7 +388,9 @@ store_soft_offline_page(struct class *cl
 
 /* Forcibly offline a page, including killing processes. */
 static ssize_t
-store_hard_offline_page(struct class *class, const char *buf, size_t count)
+store_hard_offline_page(struct class *class,
+			struct class_attribute *attr,
+			const char *buf, size_t count)
 {
 	int ret;
 	u64 pfn;
Index: linux-2.6.33-rc2-ak/include/linux/device.h
===================================================================
--- linux-2.6.33-rc2-ak.orig/include/linux/device.h
+++ linux-2.6.33-rc2-ak/include/linux/device.h
@@ -251,8 +251,10 @@ extern struct device *class_find_device(
 
 struct class_attribute {
 	struct attribute attr;
-	ssize_t (*show)(struct class *class, char *buf);
-	ssize_t (*store)(struct class *class, const char *buf, size_t count);
+	ssize_t (*show)(struct class *class, struct class_attribute *attr,
+			char *buf);
+	ssize_t (*store)(struct class *class, struct class_attribute *attr,
+			const char *buf, size_t count);
 };
 
 #define CLASS_ATTR(_name, _mode, _show, _store)			\
Index: linux-2.6.33-rc2-ak/drivers/gpu/drm/drm_sysfs.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/gpu/drm/drm_sysfs.c
+++ linux-2.6.33-rc2-ak/drivers/gpu/drm/drm_sysfs.c
@@ -71,7 +71,8 @@ static int drm_class_resume(struct devic
 }
 
 /* Display the version of drm_core. This doesn't work right in current design */
-static ssize_t version_show(struct class *dev, char *buf)
+static ssize_t version_show(struct class *dev, struct class_attribute *attr,
+				char *buf)
 {
 	return sprintf(buf, "%s %d.%d.%d %s\n", CORE_NAME, CORE_MAJOR,
 		       CORE_MINOR, CORE_PATCHLEVEL, CORE_DATE);
Index: linux-2.6.33-rc2-ak/drivers/infiniband/core/ucm.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/infiniband/core/ucm.c
+++ linux-2.6.33-rc2-ak/drivers/infiniband/core/ucm.c
@@ -1297,7 +1297,9 @@ static void ib_ucm_remove_one(struct ib_
 	device_unregister(&ucm_dev->dev);
 }
 
-static ssize_t show_abi_version(struct class *class, char *buf)
+static ssize_t show_abi_version(struct class *class,
+				struct class_attribute *attr,
+				char *buf)
 {
 	return sprintf(buf, "%d\n", IB_USER_CM_ABI_VERSION);
 }
Index: linux-2.6.33-rc2-ak/drivers/infiniband/core/user_mad.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/infiniband/core/user_mad.c
+++ linux-2.6.33-rc2-ak/drivers/infiniband/core/user_mad.c
@@ -984,7 +984,9 @@ static ssize_t show_port(struct device *
 }
 static DEVICE_ATTR(port, S_IRUGO, show_port, NULL);
 
-static ssize_t show_abi_version(struct class *class, char *buf)
+static ssize_t show_abi_version(struct class *class,
+				struct class_attribute *attr,
+				char *buf)
 {
 	return sprintf(buf, "%d\n", IB_USER_MAD_ABI_VERSION);
 }
Index: linux-2.6.33-rc2-ak/drivers/infiniband/core/uverbs_main.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/infiniband/core/uverbs_main.c
+++ linux-2.6.33-rc2-ak/drivers/infiniband/core/uverbs_main.c
@@ -729,7 +729,9 @@ static ssize_t show_dev_abi_version(stru
 }
 static DEVICE_ATTR(abi_version, S_IRUGO, show_dev_abi_version, NULL);
 
-static ssize_t show_abi_version(struct class *class, char *buf)
+static ssize_t show_abi_version(struct class *class,
+				struct class_attribute *attr,
+				char *buf)
 {
 	return sprintf(buf, "%d\n", IB_USER_VERBS_ABI_VERSION);
 }
Index: linux-2.6.33-rc2-ak/drivers/misc/phantom.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/misc/phantom.c
+++ linux-2.6.33-rc2-ak/drivers/misc/phantom.c
@@ -497,7 +497,7 @@ static struct pci_driver phantom_pci_dri
 	.resume = phantom_resume
 };
 
-static ssize_t phantom_show_version(struct class *cls, char *buf)
+static ssize_t phantom_show_version(struct class *cls, struct class_attribute *attr, char *buf)
 {
 	return sprintf(buf, PHANTOM_VERSION "\n");
 }
Index: linux-2.6.33-rc2-ak/drivers/net/bonding/bond_sysfs.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/net/bonding/bond_sysfs.c
+++ linux-2.6.33-rc2-ak/drivers/net/bonding/bond_sysfs.c
@@ -51,7 +51,9 @@
  * "show" function for the bond_masters attribute.
  * The class parameter is ignored.
  */
-static ssize_t bonding_show_bonds(struct class *cls, char *buf)
+static ssize_t bonding_show_bonds(struct class *cls,
+				  struct class_attribute *attr,
+				  char *buf)
 {
 	struct net *net = current->nsproxy->net_ns;
 	struct bond_net *bn = net_generic(net, bond_net_id);
@@ -98,6 +100,7 @@ static struct net_device *bond_get_by_na
  */
 
 static ssize_t bonding_store_bonds(struct class *cls,
+				   struct class_attribute *attr,
 				   const char *buffer, size_t count)
 {
 	struct net *net = current->nsproxy->net_ns;
Index: linux-2.6.33-rc2-ak/drivers/staging/asus_oled/asus_oled.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/staging/asus_oled/asus_oled.c
+++ linux-2.6.33-rc2-ak/drivers/staging/asus_oled/asus_oled.c
@@ -755,7 +755,9 @@ static struct usb_driver oled_driver = {
 	.id_table =	id_table,
 };
 
-static ssize_t version_show(struct class *dev, char *buf)
+static ssize_t version_show(struct class *dev,
+			    struct class_attribute *attr,
+			    char *buf)
 {
 	return sprintf(buf, ASUS_OLED_UNDERSCORE_NAME " %s\n",
 		       ASUS_OLED_VERSION);
Index: linux-2.6.33-rc2-ak/net/bluetooth/l2cap.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/net/bluetooth/l2cap.c
+++ linux-2.6.33-rc2-ak/net/bluetooth/l2cap.c
@@ -3939,7 +3939,9 @@ drop:
 	return 0;
 }
 
-static ssize_t l2cap_sysfs_show(struct class *dev, char *buf)
+static ssize_t l2cap_sysfs_show(struct class *dev,
+				struct class_attribute *attr,
+				char *buf)
 {
 	struct sock *sk;
 	struct hlist_node *node;
Index: linux-2.6.33-rc2-ak/net/bluetooth/sco.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/net/bluetooth/sco.c
+++ linux-2.6.33-rc2-ak/net/bluetooth/sco.c
@@ -953,7 +953,9 @@ drop:
 	return 0;
 }
 
-static ssize_t sco_sysfs_show(struct class *dev, char *buf)
+static ssize_t sco_sysfs_show(struct class *dev,
+				struct class_attribute *attr,
+				char *buf)
 {
 	struct sock *sk;
 	struct hlist_node *node;
Index: linux-2.6.33-rc2-ak/drivers/base/class.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/class.c
+++ linux-2.6.33-rc2-ak/drivers/base/class.c
@@ -31,7 +31,7 @@ static ssize_t class_attr_show(struct ko
 	ssize_t ret = -EIO;
 
 	if (class_attr->show)
-		ret = class_attr->show(cp->class, buf);
+		ret = class_attr->show(cp->class, class_attr, buf);
 	return ret;
 }
 
@@ -43,7 +43,7 @@ static ssize_t class_attr_store(struct k
 	ssize_t ret = -EIO;
 
 	if (class_attr->store)
-		ret = class_attr->store(cp->class, buf, count);
+		ret = class_attr->store(cp->class, class_attr, buf, count);
 	return ret;
 }
 
Index: linux-2.6.33-rc2-ak/drivers/block/osdblk.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/block/osdblk.c
+++ linux-2.6.33-rc2-ak/drivers/block/osdblk.c
@@ -476,7 +476,9 @@ static void class_osdblk_release(struct
 	kfree(cls);
 }
 
-static ssize_t class_osdblk_list(struct class *c, char *data)
+static ssize_t class_osdblk_list(struct class *c,
+				struct class_attribute *attr,
+				char *data)
 {
 	int n = 0;
 	struct list_head *tmp;
@@ -500,7 +502,9 @@ static ssize_t class_osdblk_list(struct
 	return n;
 }
 
-static ssize_t class_osdblk_add(struct class *c, const char *buf, size_t count)
+static ssize_t class_osdblk_add(struct class *c,
+				struct class_attribute *attr,
+				const char *buf, size_t count)
 {
 	struct osdblk_device *osdev;
 	ssize_t rc;
@@ -592,7 +596,9 @@ err_out_mod:
 	return rc;
 }
 
-static ssize_t class_osdblk_remove(struct class *c, const char *buf,
+static ssize_t class_osdblk_remove(struct class *c,
+					struct class_attribute *attr,
+					const char *buf,
 					size_t count)
 {
 	struct osdblk_device *osdev = NULL;
Index: linux-2.6.33-rc2-ak/drivers/block/pktcdvd.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/block/pktcdvd.c
+++ linux-2.6.33-rc2-ak/drivers/block/pktcdvd.c
@@ -337,7 +337,9 @@ static void class_pktcdvd_release(struct
 {
 	kfree(cls);
 }
-static ssize_t class_pktcdvd_show_map(struct class *c, char *data)
+static ssize_t class_pktcdvd_show_map(struct class *c,
+					struct class_attribute *attr,
+					char *data)
 {
 	int n = 0;
 	int idx;
@@ -356,7 +358,9 @@ static ssize_t class_pktcdvd_show_map(st
 	return n;
 }
 
-static ssize_t class_pktcdvd_store_add(struct class *c, const char *buf,
+static ssize_t class_pktcdvd_store_add(struct class *c,
+					struct class_attribute *attr,
+					const char *buf,
 					size_t count)
 {
 	unsigned int major, minor;
@@ -376,7 +380,9 @@ static ssize_t class_pktcdvd_store_add(s
 	return -EINVAL;
 }
 
-static ssize_t class_pktcdvd_store_remove(struct class *c, const char *buf,
+static ssize_t class_pktcdvd_store_remove(struct class *c,
+					  struct class_attribute *attr,
+					  const char *buf,
 					size_t count)
 {
 	unsigned int major, minor;
Index: linux-2.6.33-rc2-ak/drivers/gpio/gpiolib.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/gpio/gpiolib.c
+++ linux-2.6.33-rc2-ak/drivers/gpio/gpiolib.c
@@ -623,7 +623,9 @@ static const struct attribute_group gpio
  * /sys/class/gpio/unexport ... write-only
  *	integer N ... number of GPIO to unexport
  */
-static ssize_t export_store(struct class *class, const char *buf, size_t len)
+static ssize_t export_store(struct class *class,
+				struct class_attribute *attr,
+				const char *buf, size_t len)
 {
 	long	gpio;
 	int	status;
@@ -653,7 +655,9 @@ done:
 	return status ? : len;
 }
 
-static ssize_t unexport_store(struct class *class, const char *buf, size_t len)
+static ssize_t unexport_store(struct class *class,
+				struct class_attribute *attr,
+				const char *buf, size_t len)
 {
 	long	gpio;
 	int	status;
Index: linux-2.6.33-rc2-ak/drivers/mtd/ubi/build.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/mtd/ubi/build.c
+++ linux-2.6.33-rc2-ak/drivers/mtd/ubi/build.c
@@ -87,7 +87,8 @@ DEFINE_MUTEX(ubi_devices_mutex);
 static DEFINE_SPINLOCK(ubi_devices_lock);
 
 /* "Show" method for files in '/<sysfs>/class/ubi/' */
-static ssize_t ubi_version_show(struct class *class, char *buf)
+static ssize_t ubi_version_show(struct class *class, struct class_attribute *attr,
+				char *buf)
 {
 	return sprintf(buf, "%d\n", UBI_VERSION);
 }
Index: linux-2.6.33-rc2-ak/drivers/uwb/driver.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/uwb/driver.c
+++ linux-2.6.33-rc2-ak/drivers/uwb/driver.c
@@ -74,13 +74,16 @@
 unsigned long beacon_timeout_ms = 500;
 
 static
-ssize_t beacon_timeout_ms_show(struct class *class, char *buf)
+ssize_t beacon_timeout_ms_show(struct class *class,
+				struct class_attribute *attr,
+				char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%lu\n", beacon_timeout_ms);
 }
 
 static
 ssize_t beacon_timeout_ms_store(struct class *class,
+				struct class_attribute *attr,
 				const char *buf, size_t size)
 {
 	unsigned long bt;
Index: linux-2.6.33-rc2-ak/net/bluetooth/rfcomm/core.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/net/bluetooth/rfcomm/core.c
+++ linux-2.6.33-rc2-ak/net/bluetooth/rfcomm/core.c
@@ -2094,7 +2094,9 @@ static struct hci_cb rfcomm_cb = {
 	.security_cfm	= rfcomm_security_cfm
 };
 
-static ssize_t rfcomm_dlc_sysfs_show(struct class *dev, char *buf)
+static ssize_t rfcomm_dlc_sysfs_show(struct class *dev,
+				     struct class_attribute *attr,
+				     char *buf)
 {
 	struct rfcomm_session *s;
 	struct list_head *pp, *p;
Index: linux-2.6.33-rc2-ak/net/bluetooth/rfcomm/sock.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/net/bluetooth/rfcomm/sock.c
+++ linux-2.6.33-rc2-ak/net/bluetooth/rfcomm/sock.c
@@ -1061,7 +1061,9 @@ done:
 	return result;
 }
 
-static ssize_t rfcomm_sock_sysfs_show(struct class *dev, char *buf)
+static ssize_t rfcomm_sock_sysfs_show(struct class *dev,
+				      struct class_attribute *attr,
+				      char *buf)
 {
 	struct sock *sk;
 	struct hlist_node *node;
