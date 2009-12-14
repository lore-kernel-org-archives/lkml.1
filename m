Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZLNAK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZLNAK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbZLNAKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:10:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34374 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbZLMX6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:10 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       torvalds@linux-foundation.org, rjw@sisk.pl, kay.sievers@vrfy.org,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: [PATCH 1/4] Constify struct kset_uevent_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:01 +0100
Message-Id: <697b0f21b69441ca8f8bfb44775bdf4fffb8a5b9.1260663000.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663000.git.re.emese@gmail.com>
References: <cover.1260663000.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/base/bus.c      |    2 +-
 drivers/base/core.c     |    2 +-
 drivers/base/memory.c   |    2 +-
 include/linux/kobject.h |   10 +++++-----
 lib/kobject.c           |    4 ++--
 lib/kobject_uevent.c    |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 63c143e..c47cd56 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -154,7 +154,7 @@ static int bus_uevent_filter(struct kset *kset, struct kobject *kobj)
 	return 0;
 }
 
-static struct kset_uevent_ops bus_uevent_ops = {
+static const struct kset_uevent_ops bus_uevent_ops = {
 	.filter = bus_uevent_filter,
 };
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index f1290cb..37e079b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -252,7 +252,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 	return retval;
 }
 
-static struct kset_uevent_ops device_uevent_ops = {
+static const struct kset_uevent_ops device_uevent_ops = {
 	.filter =	dev_uevent_filter,
 	.name =		dev_uevent_name,
 	.uevent =	dev_uevent,
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 989429c..2272b00 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -44,7 +44,7 @@ static int memory_uevent(struct kset *kset, struct kobject *obj, struct kobj_uev
 	return retval;
 }
 
-static struct kset_uevent_ops memory_uevent_ops = {
+static const struct kset_uevent_ops memory_uevent_ops = {
 	.name		= memory_uevent_name,
 	.uevent		= memory_uevent,
 };
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 58ae8e0..57a1eaa 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -118,9 +118,9 @@ struct kobj_uevent_env {
 };
 
 struct kset_uevent_ops {
-	int (*filter)(struct kset *kset, struct kobject *kobj);
-	const char *(*name)(struct kset *kset, struct kobject *kobj);
-	int (*uevent)(struct kset *kset, struct kobject *kobj,
+	int (* const filter)(struct kset *kset, struct kobject *kobj);
+	const char *(* const name)(struct kset *kset, struct kobject *kobj);
+	int (* const uevent)(struct kset *kset, struct kobject *kobj,
 		      struct kobj_uevent_env *env);
 };
 
@@ -155,14 +155,14 @@ struct kset {
 	struct list_head list;
 	spinlock_t list_lock;
 	struct kobject kobj;
-	struct kset_uevent_ops *uevent_ops;
+	const struct kset_uevent_ops *uevent_ops;
 };
 
 extern void kset_init(struct kset *kset);
 extern int __must_check kset_register(struct kset *kset);
 extern void kset_unregister(struct kset *kset);
 extern struct kset * __must_check kset_create_and_add(const char *name,
-						struct kset_uevent_ops *u,
+						const struct kset_uevent_ops *u,
 						struct kobject *parent_kobj);
 
 static inline struct kset *to_kset(struct kobject *kobj)
diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..cecf5a0 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -789,7 +789,7 @@ static struct kobj_type kset_ktype = {
  * If the kset was not able to be created, NULL will be returned.
  */
 static struct kset *kset_create(const char *name,
-				struct kset_uevent_ops *uevent_ops,
+				const struct kset_uevent_ops *uevent_ops,
 				struct kobject *parent_kobj)
 {
 	struct kset *kset;
@@ -832,7 +832,7 @@ static struct kset *kset_create(const char *name,
  * If the kset was not able to be created, NULL will be returned.
  */
 struct kset *kset_create_and_add(const char *name,
-				 struct kset_uevent_ops *uevent_ops,
+				 const struct kset_uevent_ops *uevent_ops,
 				 struct kobject *parent_kobj)
 {
 	struct kset *kset;
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 920a3ca..c9d3a3e 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -95,7 +95,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	const char *subsystem;
 	struct kobject *top_kobj;
 	struct kset *kset;
-	struct kset_uevent_ops *uevent_ops;
+	const struct kset_uevent_ops *uevent_ops;
 	u64 seq;
 	int i = 0;
 	int retval = 0;
-- 
1.6.5.3

