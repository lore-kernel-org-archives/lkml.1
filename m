Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab0CBX5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:57:48 -0500
Received: from kroah.org ([198.145.64.141]:38526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab0CBX3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/62] driver-core: Add attribute argument to class_attribute show/store
Date: Tue,  2 Mar 2010 15:28:14 -0800
Message-Id: <1267572541-410-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 6e2c3b0..34a2de9 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -31,7 +31,7 @@ static ssize_t class_attr_show(struct kobject *kobj, struct attribute *attr,
 	ssize_t ret = -EIO;
 
 	if (class_attr->show)
-		ret = class_attr->show(cp->class, buf);
+		ret = class_attr->show(cp->class, class_attr, buf);
 	return ret;
 }
 
@@ -43,7 +43,7 @@ static ssize_t class_attr_store(struct kobject *kobj, struct attribute *attr,
 	ssize_t ret = -EIO;
 
 	if (class_attr->store)
-		ret = class_attr->store(cp->class, buf, count);
+		ret = class_attr->store(cp->class, class_attr, buf, count);
 	return ret;
 }
 
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index fb456b7..9121c77 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
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
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index a950241..6604fb3 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -69,7 +69,9 @@ fw_load_abort(struct firmware_priv *fw_priv)
 }
 
 static ssize_t
-firmware_timeout_show(struct class *class, char *buf)
+firmware_timeout_show(struct class *class,
+		      struct class_attribute *attr,
+		      char *buf)
 {
 	return sprintf(buf, "%d\n", loading_timeout);
 }
@@ -87,7 +89,9 @@ firmware_timeout_show(struct class *class, char *buf)
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
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 563656a..495f15e 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
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
@@ -368,7 +369,9 @@ static inline int memory_probe_init(void)
 
 /* Soft offline a page */
 static ssize_t
-store_soft_offline_page(struct class *class, const char *buf, size_t count)
+store_soft_offline_page(struct class *class,
+			struct class_attribute *attr,
+			const char *buf, size_t count)
 {
 	int ret;
 	u64 pfn;
@@ -385,7 +388,9 @@ store_soft_offline_page(struct class *class, const char *buf, size_t count)
 
 /* Forcibly offline a page, including killing processes. */
 static ssize_t
-store_hard_offline_page(struct class *class, const char *buf, size_t count)
+store_hard_offline_page(struct class *class,
+			struct class_attribute *attr,
+			const char *buf, size_t count)
 {
 	int ret;
 	u64 pfn;
diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index a808b15..eb2091a 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -476,7 +476,9 @@ static void class_osdblk_release(struct class *cls)
 	kfree(cls);
 }
 
-static ssize_t class_osdblk_list(struct class *c, char *data)
+static ssize_t class_osdblk_list(struct class *c,
+				struct class_attribute *attr,
+				char *data)
 {
 	int n = 0;
 	struct list_head *tmp;
@@ -500,7 +502,9 @@ static ssize_t class_osdblk_list(struct class *c, char *data)
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
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index b72935b..73d815d 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -337,7 +337,9 @@ static void class_pktcdvd_release(struct class *cls)
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
@@ -356,7 +358,9 @@ static ssize_t class_pktcdvd_show_map(struct class *c, char *data)
 	return n;
 }
 
-static ssize_t class_pktcdvd_store_add(struct class *c, const char *buf,
+static ssize_t class_pktcdvd_store_add(struct class *c,
+					struct class_attribute *attr,
+					const char *buf,
 					size_t count)
 {
 	unsigned int major, minor;
@@ -376,7 +380,9 @@ static ssize_t class_pktcdvd_store_add(struct class *c, const char *buf,
 	return -EINVAL;
 }
 
-static ssize_t class_pktcdvd_store_remove(struct class *c, const char *buf,
+static ssize_t class_pktcdvd_store_remove(struct class *c,
+					  struct class_attribute *attr,
+					  const char *buf,
 					size_t count)
 {
 	unsigned int major, minor;
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 350842a..3a77eaa 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -623,7 +623,9 @@ static const struct attribute_group gpiochip_attr_group = {
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
diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 7e42b7e..b95aaf2 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -71,7 +71,8 @@ static int drm_class_resume(struct device *dev)
 }
 
 /* Display the version of drm_core. This doesn't work right in current design */
-static ssize_t version_show(struct class *dev, char *buf)
+static ssize_t version_show(struct class *dev, struct class_attribute *attr,
+				char *buf)
 {
 	return sprintf(buf, "%s %d.%d.%d %s\n", CORE_NAME, CORE_MAJOR,
 		       CORE_MINOR, CORE_PATCHLEVEL, CORE_DATE);
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index f504c9b..98c1643 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1297,7 +1297,9 @@ static void ib_ucm_remove_one(struct ib_device *device)
 	device_unregister(&ucm_dev->dev);
 }
 
-static ssize_t show_abi_version(struct class *class, char *buf)
+static ssize_t show_abi_version(struct class *class,
+				struct class_attribute *attr,
+				char *buf)
 {
 	return sprintf(buf, "%d\n", IB_USER_CM_ABI_VERSION);
 }
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 7de0296..113dd0d 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -984,7 +984,9 @@ static ssize_t show_port(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(port, S_IRUGO, show_port, NULL);
 
-static ssize_t show_abi_version(struct class *class, char *buf)
+static ssize_t show_abi_version(struct class *class,
+				struct class_attribute *attr,
+				char *buf)
 {
 	return sprintf(buf, "%d\n", IB_USER_MAD_ABI_VERSION);
 }
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 5f284ff..ef541b9 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -729,7 +729,9 @@ static ssize_t show_dev_abi_version(struct device *device,
 }
 static DEVICE_ATTR(abi_version, S_IRUGO, show_dev_abi_version, NULL);
 
-static ssize_t show_abi_version(struct class *class, char *buf)
+static ssize_t show_abi_version(struct class *class,
+				struct class_attribute *attr,
+				char *buf)
 {
 	return sprintf(buf, "%d\n", IB_USER_VERBS_ABI_VERSION);
 }
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 04c2726..d30ae95 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -497,7 +497,7 @@ static struct pci_driver phantom_pci_driver = {
 	.resume = phantom_resume
 };
 
-static ssize_t phantom_show_version(struct class *cls, char *buf)
+static ssize_t phantom_show_version(struct class *cls, struct class_attribute *attr, char *buf)
 {
 	return sprintf(buf, PHANTOM_VERSION "\n");
 }
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 14cec04..bd1d28d 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -87,7 +87,8 @@ DEFINE_MUTEX(ubi_devices_mutex);
 static DEFINE_SPINLOCK(ubi_devices_lock);
 
 /* "Show" method for files in '/<sysfs>/class/ubi/' */
-static ssize_t ubi_version_show(struct class *class, char *buf)
+static ssize_t ubi_version_show(struct class *class, struct class_attribute *attr,
+				char *buf)
 {
 	return sprintf(buf, "%d\n", UBI_VERSION);
 }
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 5acd557..b8bec08 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
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
@@ -98,6 +100,7 @@ static struct net_device *bond_get_by_name(struct net *net, const char *ifname)
  */
 
 static ssize_t bonding_store_bonds(struct class *cls,
+				   struct class_attribute *attr,
 				   const char *buffer, size_t count)
 {
 	struct net *net = current->nsproxy->net_ns;
diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 43c57b7..d11e897 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -759,7 +759,9 @@ static struct usb_driver oled_driver = {
 	.id_table =	id_table,
 };
 
-static ssize_t version_show(struct class *dev, char *buf)
+static ssize_t version_show(struct class *dev,
+			    struct class_attribute *attr,
+			    char *buf)
 {
 	return sprintf(buf, ASUS_OLED_UNDERSCORE_NAME " %s\n",
 		       ASUS_OLED_VERSION);
diff --git a/drivers/uwb/driver.c b/drivers/uwb/driver.c
index da77e41..08bd6db 100644
--- a/drivers/uwb/driver.c
+++ b/drivers/uwb/driver.c
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
diff --git a/include/linux/device.h b/include/linux/device.h
index b30527d..190f8d3 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -251,8 +251,10 @@ extern struct device *class_find_device(struct class *class,
 
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
diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index 400efa2..4db7ae2 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -3937,7 +3937,9 @@ drop:
 	return 0;
 }
 
-static ssize_t l2cap_sysfs_show(struct class *dev, char *buf)
+static ssize_t l2cap_sysfs_show(struct class *dev,
+				struct class_attribute *attr,
+				char *buf)
 {
 	struct sock *sk;
 	struct hlist_node *node;
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 89f4a59..db8a68e 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -2098,7 +2098,9 @@ static struct hci_cb rfcomm_cb = {
 	.security_cfm	= rfcomm_security_cfm
 };
 
-static ssize_t rfcomm_dlc_sysfs_show(struct class *dev, char *buf)
+static ssize_t rfcomm_dlc_sysfs_show(struct class *dev,
+				     struct class_attribute *attr,
+				     char *buf)
 {
 	struct rfcomm_session *s;
 	struct list_head *pp, *p;
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 4b5968d..ca87d6a 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
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
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index dd8f6ec..f93b939 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
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
-- 
1.7.0.1

