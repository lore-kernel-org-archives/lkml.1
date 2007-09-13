Return-Path: <linux-kernel-owner+w=401wt.eu-S1765072AbXIMXrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765072AbXIMXrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbXIMXpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:45:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57149 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbXIMXpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:45:00 -0400
Date: Thu, 13 Sep 2007 16:40:12 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Driver core: remove subsys_get()
Message-ID: <20070913234012.GE10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913233751.GA10856@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
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

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -728,7 +728,7 @@ EXPORT_SYMBOL_GPL(device_reprobe);
 
 struct bus_type *get_bus(struct bus_type *bus)
 {
-	return bus ? container_of(subsys_get(&bus->subsys),
+	return bus ? container_of(kset_get(&bus->subsys),
 				struct bus_type, subsys) : NULL;
 }
 
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -93,7 +93,7 @@ void class_remove_file(struct class * cl
 static struct class *class_get(struct class *cls)
 {
 	if (cls)
-		return container_of(subsys_get(&cls->subsys), struct class, subsys);
+		return container_of(kset_get(&cls->subsys), struct class, subsys);
 	return NULL;
 }
 
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -231,13 +231,6 @@ extern void subsystem_init(struct kset *
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
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -679,7 +679,7 @@ int subsys_create_file(struct kset *s, s
 	if (!s || !a)
 		return -EINVAL;
 
-	if (subsys_get(s)) {
+	if (kset_get(s)) {
 		error = sysfs_create_file(&s->kobj, &a->attr);
 		kset_put(s);
 	}
