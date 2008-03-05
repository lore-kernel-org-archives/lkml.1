Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYCERtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYCERtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYCERs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:48:58 -0500
Received: from sacred.ru ([62.205.161.221]:58932 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbYCERs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:48:57 -0500
Message-ID: <47CEDB13.3050500@openvz.org>
Date: Wed, 05 Mar 2008 20:40:35 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 6/9] Extend the drivers/base/map.c functionality
References: <47CED717.60406@openvz.org>
In-Reply-To: <47CED717.60406@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 20:40:27 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes the following functions:

1. kobj_remap - this one will change the mapping's permissions
   or add a new one if required.

2. kobj_map_iterate will walk the map, calling the callback
   on each element.

3. kobj_map_fini is a rollback for kobj_map_finid - cleans all
   the mappings.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 drivers/base/map.c       |   84 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kobj_map.h |    6 +++
 2 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/drivers/base/map.c b/drivers/base/map.c
index 285a2d2..8e2e1c2 100644
--- a/drivers/base/map.c
+++ b/drivers/base/map.c
@@ -181,3 +181,87 @@ struct kobj_map *kobj_map_init(kobj_probe_t *base_probe, struct mutex *lock)
 	p->lock = lock;
 	return p;
 }
+
+#ifdef CONFIG_CGROUP_DEVS
+int kobj_remap(struct kobj_map *domain, dev_t dev, mode_t mode,
+		unsigned long range, struct module *module,
+		kobj_probe_t *probe, int (*lock)(dev_t, void *), void *data)
+{
+	unsigned n = MAJOR(dev + range - 1) - MAJOR(dev) + 1;
+	unsigned index = MAJOR(dev);
+	unsigned i;
+	int err = -ESRCH;
+
+	if (n > KOBJ_MAP_PROBES)
+		n = KOBJ_MAP_PROBES;
+
+	mutex_lock(domain->lock);
+	for (i = 0; i < n; i++, index++) {
+		struct probe **s;
+		for (s = &domain->probes[index % KOBJ_MAP_PROBES];
+				*s; s = &(*s)->next) {
+			struct probe *p = *s;
+			if (p->dev == dev) {
+				p->mode = mode | FMODE_LSEEK |
+					FMODE_PREAD | FMODE_PWRITE;
+				err = 0;
+				break;
+			}
+		}
+	}
+
+	if (err)
+		err = __kobj_map(domain, dev, mode, range, module,
+				probe, lock, data);
+	mutex_unlock(domain->lock);
+	return err;
+}
+
+void kobj_map_iterate(struct kobj_map *domain,
+		int (*fn)(dev_t, int, mode_t, void *), void *arg)
+{
+	int i;
+	struct probe *p;
+	dev_t skip = MKDEV(0, 0);
+
+	mutex_lock(domain->lock);
+	for (i = 0; i < KOBJ_MAP_PROBES; i++) {
+		p = domain->probes[i];
+		while (p != NULL) {
+			if (p->dev == skip)
+				goto next;
+			/*
+			 * this 'device' is special - see the kobj_map_init why
+			 */
+			if (p->dev == 1)
+				goto next;
+
+			skip = p->dev;
+			if (fn(p->dev, p->range, p->mode, arg))
+				goto done;
+next:
+			p = p->next;
+		}
+	}
+done:
+	mutex_unlock(domain->lock);
+}
+
+void kobj_map_fini(struct kobj_map *map)
+{
+	int i;
+	struct probe *p, *next;
+
+	for (i = 0; i < KOBJ_MAP_PROBES; i++) {
+		p = map->probes[i];
+		while (p->next != NULL) {
+			next = p->next;
+			kfree(p);
+			p = next;
+		}
+	}
+
+	kfree(p);
+	kfree(map);
+}
+#endif
diff --git a/include/linux/kobj_map.h b/include/linux/kobj_map.h
index 867f307..35a670d 100644
--- a/include/linux/kobj_map.h
+++ b/include/linux/kobj_map.h
@@ -11,4 +11,10 @@ void kobj_unmap(struct kobj_map *, dev_t, unsigned long);
 struct kobject *kobj_lookup(struct kobj_map *, dev_t, mode_t *, int *);
 struct kobj_map *kobj_map_init(kobj_probe_t *, struct mutex *);
 
+void kobj_map_iterate(struct kobj_map *, int (*fn)(dev_t, int, mode_t, void *),
+		void *);
+int kobj_remap(struct kobj_map *, dev_t, mode_t, unsigned long, struct module *,
+	     kobj_probe_t *, int (*)(dev_t, void *), void *);
+void kobj_map_fini(struct kobj_map *);
+
 #endif
-- 
1.5.3.4

