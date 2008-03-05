Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbYCERme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbYCERme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYCERm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:42:26 -0500
Received: from sacred.ru ([62.205.161.221]:37653 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbYCERmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:42:25 -0500
Message-ID: <47CED93C.5030107@openvz.org>
Date: Wed, 05 Mar 2008 20:32:44 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 3/9] Add a mode on the struct probe
References: <47CED717.60406@openvz.org>
In-Reply-To: <47CED717.60406@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 20:32:35 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea of the set is to make the dev_t to struct kobj map
be per-cgroup, and provide a permissions for this mapping.
This mode mask will operate with FMODE_xxx modes.

To achieve this, I add the mode_t mode on the struct probe,
which sets this mapping, and move the locked part of the 
kobj_map() into a separate function, which also accepts the 
mode to be set on the probe.

By default all the modes are provided for a map.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 drivers/base/map.c |   31 ++++++++++++++++++++++++++-----
 1 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/base/map.c b/drivers/base/map.c
index 7de565f..c7e28a1 100644
--- a/drivers/base/map.c
+++ b/drivers/base/map.c
@@ -15,6 +15,7 @@
 #include <linux/kdev_t.h>
 #include <linux/kobject.h>
 #include <linux/kobj_map.h>
+#include <linux/fs.h>
 
 #define KOBJ_MAP_PROBES	255
 
@@ -22,6 +23,7 @@ struct kobj_map {
 	struct probe {
 		struct probe *next;
 		dev_t dev;
+		mode_t mode;
 		unsigned long range;
 		struct module *owner;
 		kobj_probe_t *get;
@@ -31,9 +33,9 @@ struct kobj_map {
 	struct mutex *lock;
 };
 
-int kobj_map(struct kobj_map *domain, dev_t dev, unsigned long range,
-	     struct module *module, kobj_probe_t *probe,
-	     int (*lock)(dev_t, void *), void *data)
+static int __kobj_map(struct kobj_map *domain, dev_t dev, mode_t mode,
+		unsigned long range, struct module *module,
+		kobj_probe_t *probe, int (*lock)(dev_t, void *), void *data)
 {
 	unsigned n = MAJOR(dev + range - 1) - MAJOR(dev) + 1;
 	unsigned index = MAJOR(dev);
@@ -55,8 +57,15 @@ int kobj_map(struct kobj_map *domain, dev_t dev, unsigned long range,
 		p->dev = dev;
 		p->range = range;
 		p->data = data;
+		/*
+		 * When opening a device we want to (dis)allow only
+		 * read or write. But sys_open() can provide more
+		 * modes like lseek or pread. So, these FMODE-s are
+		 * always 'on'.
+		 */
+		p->mode = mode | FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
 	}
-	mutex_lock(domain->lock);
+
 	for (i = 0, p -= n; i < n; i++, p++, index++) {
 		struct probe **s = &domain->probes[index % KOBJ_MAP_PROBES];
 		while (*s && (*s)->range < range)
@@ -64,10 +73,22 @@ int kobj_map(struct kobj_map *domain, dev_t dev, unsigned long range,
 		p->next = *s;
 		*s = p;
 	}
-	mutex_unlock(domain->lock);
 	return 0;
 }
 
+int kobj_map(struct kobj_map *domain, dev_t dev, unsigned long range,
+	     struct module *module, kobj_probe_t *probe,
+	     int (*lock)(dev_t, void *), void *data)
+{
+	int err;
+
+	mutex_lock(domain->lock);
+	err = __kobj_map(domain, dev, FMODE_READ | FMODE_WRITE, range,
+			module, probe, lock, data);
+	mutex_unlock(domain->lock);
+	return err;
+}
+
 void kobj_unmap(struct kobj_map *domain, dev_t dev, unsigned long range)
 {
 	unsigned n = MAJOR(dev + range - 1) - MAJOR(dev) + 1;
-- 
1.5.3.4

