Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbYCER1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbYCER1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYCER1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:27:07 -0500
Received: from sacred.ru ([62.205.161.221]:51667 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbYCER1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:27:05 -0500
Message-ID: <47CED780.8060206@openvz.org>
Date: Wed, 05 Mar 2008 20:25:20 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 1/9] Avoid magic constants in drivers/base/map.c
References: <47CED717.60406@openvz.org>
In-Reply-To: <47CED717.60406@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 20:25:12 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of chains in the kobj_map structure is hard-coded
with a magic constant of 255. Make a named one instead.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 drivers/base/map.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/base/map.c b/drivers/base/map.c
index e87017f..7de565f 100644
--- a/drivers/base/map.c
+++ b/drivers/base/map.c
@@ -16,6 +16,8 @@
 #include <linux/kobject.h>
 #include <linux/kobj_map.h>
 
+#define KOBJ_MAP_PROBES	255
+
 struct kobj_map {
 	struct probe {
 		struct probe *next;
@@ -25,7 +27,7 @@ struct kobj_map {
 		kobj_probe_t *get;
 		int (*lock)(dev_t, void *);
 		void *data;
-	} *probes[255];
+	} *probes[KOBJ_MAP_PROBES];
 	struct mutex *lock;
 };
 
@@ -38,8 +40,8 @@ int kobj_map(struct kobj_map *domain, dev_t dev, unsigned long range,
 	unsigned i;
 	struct probe *p;
 
-	if (n > 255)
-		n = 255;
+	if (n > KOBJ_MAP_PROBES)
+		n = KOBJ_MAP_PROBES;
 
 	p = kmalloc(sizeof(struct probe) * n, GFP_KERNEL);
 
@@ -56,7 +58,7 @@ int kobj_map(struct kobj_map *domain, dev_t dev, unsigned long range,
 	}
 	mutex_lock(domain->lock);
 	for (i = 0, p -= n; i < n; i++, p++, index++) {
-		struct probe **s = &domain->probes[index % 255];
+		struct probe **s = &domain->probes[index % KOBJ_MAP_PROBES];
 		while (*s && (*s)->range < range)
 			s = &(*s)->next;
 		p->next = *s;
@@ -73,13 +75,14 @@ void kobj_unmap(struct kobj_map *domain, dev_t dev, unsigned long range)
 	unsigned i;
 	struct probe *found = NULL;
 
-	if (n > 255)
-		n = 255;
+	if (n > KOBJ_MAP_PROBES)
+		n = KOBJ_MAP_PROBES;
 
 	mutex_lock(domain->lock);
 	for (i = 0; i < n; i++, index++) {
 		struct probe **s;
-		for (s = &domain->probes[index % 255]; *s; s = &(*s)->next) {
+		for (s = &domain->probes[index % KOBJ_MAP_PROBES];
+				*s; s = &(*s)->next) {
 			struct probe *p = *s;
 			if (p->dev == dev && p->range == range) {
 				*s = p->next;
@@ -101,7 +104,7 @@ struct kobject *kobj_lookup(struct kobj_map *domain, dev_t dev, int *index)
 
 retry:
 	mutex_lock(domain->lock);
-	for (p = domain->probes[MAJOR(dev) % 255]; p; p = p->next) {
+	for (p = domain->probes[MAJOR(dev) % KOBJ_MAP_PROBES]; p; p = p->next) {
 		struct kobject *(*probe)(dev_t, int *, void *);
 		struct module *owner;
 		void *data;
@@ -148,7 +151,7 @@ struct kobj_map *kobj_map_init(kobj_probe_t *base_probe, struct mutex *lock)
 	base->dev = 1;
 	base->range = ~0;
 	base->get = base_probe;
-	for (i = 0; i < 255; i++)
+	for (i = 0; i < KOBJ_MAP_PROBES; i++)
 		p->probes[i] = base;
 	p->lock = lock;
 	return p;
-- 
1.5.3.4

