Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbYCERou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbYCERou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762602AbYCERof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:44:35 -0500
Received: from sacred.ru ([62.205.161.221]:38092 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757861AbYCERoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:44:34 -0500
Message-ID: <47CEDBD1.5030307@openvz.org>
Date: Wed, 05 Mar 2008 20:43:45 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 7/9] Provide functions to manipulate char device mappings
References: <47CED717.60406@openvz.org>
In-Reply-To: <47CED717.60406@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 20:43:36 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The character devices currently have a global map for
devices and its own locks and callbacks for devices
probing. So here are the functions that provide the way
to play with character devices maps. 

They are cdev_map_init/cdev_map_fini to create/destroy 
one, cdev_add_to_map/cdev_del_from_map to map/unmap devices,
and cdev_iterate_map for uniformity.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 fs/char_dev.c        |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cdev.h |    7 +++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index d042446..7a4c1bd 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -476,6 +476,69 @@ int cdev_add(struct cdev *p, dev_t dev, unsigned count)
 	return kobj_map(cdev_map, dev, count, NULL, exact_match, exact_lock, p);
 }
 
+#ifdef CONFIG_CGROUP_DEVS
+int cdev_add_to_map(struct kobj_map *map, dev_t dev, int all, mode_t mode)
+{
+	int tmp;
+	struct kobject *k;
+	struct cdev *c;
+
+	k = kobj_lookup(cdev_map, dev, NULL, &tmp);
+	if (k == NULL)
+		return -ENODEV;
+
+	c = container_of(k, struct cdev, kobj);
+	tmp = kobj_remap(map, dev, mode, all ? MINORMASK : 1, NULL,
+			exact_match, exact_lock, c);
+	if (tmp < 0) {
+		cdev_put(c);
+		return tmp;
+	}
+
+	return 0;
+}
+
+int cdev_del_from_map(struct kobj_map *map, dev_t dev, int all)
+{
+	int tmp;
+	struct kobject *k;
+	struct cdev *c;
+
+	k = kobj_lookup(map, dev, NULL, &tmp);
+	if (k == NULL)
+		return -ENODEV;
+
+	c = container_of(k, struct cdev, kobj);
+	kobj_unmap(map, dev, all ? MINORMASK : 1);
+
+	/*
+	 * one put for the kobj_lookup above and one for
+	 * the kobj_lookup in cdev_add_to_map
+	 */
+	cdev_put(c);
+	cdev_put(c);
+	return 0;
+}
+
+void cdev_iterate_map(struct kobj_map *map,
+		int (*fn)(dev_t, int, mode_t, void *), void *x)
+{
+	kobj_map_iterate(map, fn, x);
+}
+
+static struct kobject *base_probe(dev_t dev, int *part, void *data);
+
+struct kobj_map *cdev_map_init(void)
+{
+	return kobj_map_init(base_probe, &chrdevs_lock);
+}
+
+void cdev_map_fini(struct kobj_map *map)
+{
+	kobj_map_fini(map);
+}
+#endif
+
 static void cdev_unmap(dev_t dev, unsigned count)
 {
 	kobj_unmap(cdev_map, dev, count);
diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index 1e29b13..14d377b 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -33,5 +33,12 @@ void cd_forget(struct inode *);
 
 extern struct backing_dev_info directly_mappable_cdev_bdi;
 
+struct kobj_map;
+int cdev_add_to_map(struct kobj_map *map, dev_t dev, int all, mode_t mode);
+int cdev_del_from_map(struct kobj_map *map, dev_t dev, int all);
+struct kobj_map *cdev_map_init(void);
+void cdev_map_fini(struct kobj_map *map);
+void cdev_iterate_map(struct kobj_map *,
+		int (*fn)(dev_t, int, mode_t, void *), void *);
 #endif
 #endif
-- 
1.5.3.4

