Return-Path: <linux-kernel-owner+w=401wt.eu-S1761492AbYGKNx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761492AbYGKNx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759492AbYGKNsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:12 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34984 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759426AbYGKNr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:58 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 7/30] W1: be able to manually add and remove slaves
Date: Fri, 11 Jul 2008 17:51:22 +0400
Message-Id: <12157843061177-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs entries were added to manually add and remove slave devices.
This is useful if the automatic bus searching is disabled, and the
device ids are already known.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/w1.c |  137 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 136 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 76274ae..24312e0 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -56,6 +56,8 @@ module_param_named(slave_ttl, w1_max_slave_ttl, int, 0);
 DEFINE_MUTEX(w1_mlock);
 LIST_HEAD(w1_masters);
 
+static int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn);
+
 static int w1_master_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
@@ -349,7 +351,8 @@ static ssize_t w1_master_attribute_show_slave_count(struct device *dev, struct d
 	return count;
 }
 
-static ssize_t w1_master_attribute_show_slaves(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t w1_master_attribute_show_slaves(struct device *dev,
+	struct device_attribute *attr, char *buf)
 {
 	struct w1_master *md = dev_to_w1_master(dev);
 	int c = PAGE_SIZE;
@@ -374,6 +377,134 @@ static ssize_t w1_master_attribute_show_slaves(struct device *dev, struct device
 	return PAGE_SIZE - c;
 }
 
+static ssize_t w1_master_attribute_show_add(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	int c = PAGE_SIZE;
+	c -= snprintf(buf+PAGE_SIZE - c, c,
+		"write device id xx-xxxxxxxxxxxx to add slave\n");
+	return PAGE_SIZE - c;
+}
+
+static int w1_atoreg_num(struct device *dev, const char *buf, size_t count,
+	struct w1_reg_num *rn)
+{
+	unsigned int family;
+	u64 id;
+	int i;
+	u64 rn64_le;
+	/* The CRC value isn't read from the user because the sysfs directory
+	 * doesn't include it and most messages from the bus search don't
+	 * print it either.  It would be unreasonable for the user to then
+	 * provide it.
+	 */
+	const char *error_msg = "bad slave string format, expecting "
+		"ff-dddddddddddd\n";
+
+	if (buf[2] != '-') {
+		dev_err(dev, "%s", error_msg);
+		return -EINVAL;
+	}
+	i = sscanf(buf, "%02x-%012llx", &family, &id);
+	if (i != 2) {
+		dev_err(dev, "%s", error_msg);
+		return -EINVAL;
+	}
+	rn->family = family;
+	rn->id = id;
+
+	rn64_le = cpu_to_le64(*(u64 *)rn);
+	rn->crc = w1_calc_crc8((u8 *)&rn64_le, 7);
+
+	#if 0
+	dev_info(dev, "With CRC device is %02x.%012llx.%02x.\n",
+		  rn->family, (unsigned long long)rn->id, rn->crc);
+	#endif
+
+	return 0;
+}
+
+/* Searches the slaves in the w1_master and returns a pointer or NULL.
+ * Note: must hold the mutex
+ */
+static struct w1_slave *w1_slave_search_device(struct w1_master *dev,
+	struct w1_reg_num *rn)
+{
+	struct w1_slave *sl;
+	list_for_each_entry(sl, &dev->slist, w1_slave_entry) {
+		if (sl->reg_num.family == rn->family &&
+				sl->reg_num.id == rn->id &&
+				sl->reg_num.crc == rn->crc) {
+			return sl;
+		}
+	}
+	return NULL;
+}
+
+static ssize_t w1_master_attribute_store_add(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct w1_master *md = dev_to_w1_master(dev);
+	struct w1_reg_num rn;
+	struct w1_slave *sl;
+	ssize_t result = count;
+
+	if (w1_atoreg_num(dev, buf, count, &rn))
+		return -EINVAL;
+
+	mutex_lock(&md->mutex);
+	sl = w1_slave_search_device(md, &rn);
+	/* It would be nice to do a targeted search one the one-wire bus
+	 * for the new device to see if it is out there or not.  But the
+	 * current search doesn't support that.
+	 */
+	if (sl) {
+		dev_info(dev, "Device %s already exists\n", sl->name);
+		result = -EINVAL;
+	} else {
+		w1_attach_slave_device(md, &rn);
+	}
+	mutex_unlock(&md->mutex);
+
+	return result;
+}
+
+static ssize_t w1_master_attribute_show_remove(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	int c = PAGE_SIZE;
+	c -= snprintf(buf+PAGE_SIZE - c, c,
+		"write device id xx-xxxxxxxxxxxx to remove slave\n");
+	return PAGE_SIZE - c;
+}
+
+static ssize_t w1_master_attribute_store_remove(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct w1_master *md = dev_to_w1_master(dev);
+	struct w1_reg_num rn;
+	struct w1_slave *sl;
+	ssize_t result = count;
+
+	if (w1_atoreg_num(dev, buf, count, &rn))
+		return -EINVAL;
+
+	mutex_lock(&md->mutex);
+	sl = w1_slave_search_device(md, &rn);
+	if (sl) {
+		w1_slave_detach(sl);
+	} else {
+		dev_info(dev, "Device %02x-%012llx doesn't exists\n", rn.family,
+			(unsigned long long)rn.id);
+		result = -EINVAL;
+	}
+	mutex_unlock(&md->mutex);
+
+	return result;
+}
+
 #define W1_MASTER_ATTR_RO(_name, _mode)				\
 	struct device_attribute w1_master_attribute_##_name =	\
 		__ATTR(w1_master_##_name, _mode,		\
@@ -394,6 +525,8 @@ static W1_MASTER_ATTR_RO(timeout, S_IRUGO);
 static W1_MASTER_ATTR_RO(pointer, S_IRUGO);
 static W1_MASTER_ATTR_RW(search, S_IRUGO | S_IWUGO);
 static W1_MASTER_ATTR_RW(pullup, S_IRUGO | S_IWUGO);
+static W1_MASTER_ATTR_RW(add, S_IRUGO | S_IWUGO);
+static W1_MASTER_ATTR_RW(remove, S_IRUGO | S_IWUGO);
 
 static struct attribute *w1_master_default_attrs[] = {
 	&w1_master_attribute_name.attr,
@@ -405,6 +538,8 @@ static struct attribute *w1_master_default_attrs[] = {
 	&w1_master_attribute_pointer.attr,
 	&w1_master_attribute_search.attr,
 	&w1_master_attribute_pullup.attr,
+	&w1_master_attribute_add.attr,
+	&w1_master_attribute_remove.attr,
 	NULL
 };
 
-- 
1.4.4.4

