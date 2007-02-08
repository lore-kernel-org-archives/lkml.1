Return-Path: <linux-kernel-owner+w=401wt.eu-S1422846AbXBHAbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422846AbXBHAbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422844AbXBHAbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:31:51 -0500
Received: from ns.suse.de ([195.135.220.2]:56341 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422846AbXBHAbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:31:25 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/28] Kobject: make kobject apis more robust in handling NULL pointers
Date: Wed,  7 Feb 2007 16:29:49 -0800
Message-Id: <11708946163722-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <20070208002908.GA4796@kroah.com>
References: <20070208002908.GA4796@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

It should be ok to pass in NULL for some kobject functions, so add error
checking for all exported kobject functions to be more robust.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 7ce6dc1..9aed594 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -126,6 +126,8 @@ EXPORT_SYMBOL_GPL(kobject_get_path);
  */
 void kobject_init(struct kobject * kobj)
 {
+	if (!kobj)
+		return;
 	kref_init(&kobj->kref);
 	INIT_LIST_HEAD(&kobj->entry);
 	init_waitqueue_head(&kobj->poll);
@@ -366,6 +368,8 @@ out:
 
 void kobject_del(struct kobject * kobj)
 {
+	if (!kobj)
+		return;
 	sysfs_remove_dir(kobj);
 	unlink(kobj);
 }
@@ -377,6 +381,8 @@ void kobject_del(struct kobject * kobj)
 
 void kobject_unregister(struct kobject * kobj)
 {
+	if (!kobj)
+		return;
 	pr_debug("kobject %s: unregistering\n",kobject_name(kobj));
 	kobject_uevent(kobj, KOBJ_REMOVE);
 	kobject_del(kobj);
@@ -523,6 +529,8 @@ int kset_add(struct kset * k)
 
 int kset_register(struct kset * k)
 {
+	if (!k)
+		return -EINVAL;
 	kset_init(k);
 	return kset_add(k);
 }
@@ -535,6 +543,8 @@ int kset_register(struct kset * k)
 
 void kset_unregister(struct kset * k)
 {
+	if (!k)
+		return;
 	kobject_unregister(&k->kobj);
 }
 
@@ -586,6 +596,9 @@ int subsystem_register(struct subsystem * s)
 {
 	int error;
 
+	if (!s)
+		return -EINVAL;
+
 	subsystem_init(s);
 	pr_debug("subsystem %s: registering\n",s->kset.kobj.name);
 
@@ -598,6 +611,8 @@ int subsystem_register(struct subsystem * s)
 
 void subsystem_unregister(struct subsystem * s)
 {
+	if (!s)
+		return;
 	pr_debug("subsystem %s: unregistering\n",s->kset.kobj.name);
 	kset_unregister(&s->kset);
 }
@@ -612,6 +627,10 @@ void subsystem_unregister(struct subsystem * s)
 int subsys_create_file(struct subsystem * s, struct subsys_attribute * a)
 {
 	int error = 0;
+
+	if (!s || !a)
+		return -EINVAL;
+
 	if (subsys_get(s)) {
 		error = sysfs_create_file(&s->kset.kobj,&a->attr);
 		subsys_put(s);
-- 
1.4.4.4

