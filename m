Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXJLWWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXJLWWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760980AbXJLWSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:18 -0400
Received: from ns2.suse.de ([195.135.220.15]:49617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759295AbXJLWSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/75] Driver core: remove subsys_get()
Date: Fri, 12 Oct 2007 15:16:13 -0700
Message-Id: <1192227481691-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922274772578-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more subsystems, it's a kset now so remove the function and
the only two users, which are in the driver core.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c      |    2 +-
 drivers/base/class.c    |    2 +-
 include/linux/kobject.h |    7 -------
 lib/kobject.c           |    2 +-
 4 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 2f77593..bc38085 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -728,7 +728,7 @@ EXPORT_SYMBOL_GPL(device_reprobe);
 
 struct bus_type *get_bus(struct bus_type *bus)
 {
-	return bus ? container_of(subsys_get(&bus->subsys),
+	return bus ? container_of(kset_get(&bus->subsys),
 				struct bus_type, subsys) : NULL;
 }
 
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 50e3413..3e9b04c 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -93,7 +93,7 @@ void class_remove_file(struct class * cls, const struct class_attribute * attr)
 static struct class *class_get(struct class *cls)
 {
 	if (cls)
-		return container_of(subsys_get(&cls->subsys), struct class, subsys);
+		return container_of(kset_get(&cls->subsys), struct class, subsys);
 	return NULL;
 }
 
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 45effed..c0fb535 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -231,13 +231,6 @@ extern void subsystem_init(struct kset *);
 extern int __must_check subsystem_register(struct kset *);
 extern void subsystem_unregister(struct kset *);
 
-static inline struct kset *subsys_get(struct kset *s)
-{
-	if (s)
-		return kset_get(s);
-	return NULL;
-}
-
 struct subsys_attribute {
 	struct attribute attr;
 	ssize_t (*show)(struct kset *, char *);
diff --git a/lib/kobject.c b/lib/kobject.c
index 0aa4e90..1326041 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -679,7 +679,7 @@ int subsys_create_file(struct kset *s, struct subsys_attribute *a)
 	if (!s || !a)
 		return -EINVAL;
 
-	if (subsys_get(s)) {
+	if (kset_get(s)) {
 		error = sysfs_create_file(&s->kobj, &a->attr);
 		kset_put(s);
 	}
-- 
1.5.3.4

