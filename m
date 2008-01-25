Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbYAYH5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbYAYH5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759558AbYAYHhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:37:00 -0500
Received: from mail.suse.de ([195.135.220.2]:55438 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762084AbYAYHg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:59 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 106/196] kobject: clean up debugging messages
Date: Thu, 24 Jan 2008 23:32:15 -0800
Message-Id: <1201246425-5058-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kobject debugging messages are a mess.  This provides a unified
message that makes them actually useful.

The format for new kobject debug messages should be:
	kobject: 'KOBJECT_NAME' (ADDRESS): FUNCTION_NAME: message.\n

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c        |   23 +++++++++++++++--------
 lib/kobject_uevent.c |   20 ++++++++++++++------
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 4d52b6f..1015f74 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -95,7 +95,8 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
 		*(path + --length) = '/';
 	}
 
-	pr_debug("%s: path = '%s'\n",__FUNCTION__,path);
+	pr_debug("kobject: '%s' (%p): %s: path = '%s'\n", kobject_name(kobj),
+		 kobj, __FUNCTION__,path);
 }
 
 /**
@@ -171,15 +172,17 @@ int kobject_add(struct kobject * kobj)
 	if (!kobj->k_name)
 		kobject_set_name(kobj, "NO_NAME");
 	if (!*kobj->k_name) {
-		pr_debug("kobject attempted to be registered with no name!\n");
+		pr_debug("kobject (%p) attempted to be registered with no "
+			 "name!\n", kobj);
 		WARN_ON(1);
 		kobject_put(kobj);
 		return -EINVAL;
 	}
 	parent = kobject_get(kobj->parent);
 
-	pr_debug("kobject %s: registering. parent: %s, set: %s\n",
-		 kobject_name(kobj), parent ? kobject_name(parent) : "<NULL>", 
+	pr_debug("kobject: '%s' (%p): %s: parent: '%s', set: '%s'\n",
+		 kobject_name(kobj), kobj, __FUNCTION__,
+		 parent ? kobject_name(parent) : "<NULL>",
 		 kobj->kset ? kobject_name(&kobj->kset->kobj) : "<NULL>" );
 
 	if (kobj->kset) {
@@ -560,7 +563,8 @@ void kobject_unregister(struct kobject * kobj)
 {
 	if (!kobj)
 		return;
-	pr_debug("kobject %s: unregistering\n",kobject_name(kobj));
+	pr_debug("kobject: '%s' (%p): %s\n",
+		 kobject_name(kobj), kobj, __FUNCTION__);
 	kobject_uevent(kobj, KOBJ_REMOVE);
 	kobject_del(kobj);
 	kobject_put(kobj);
@@ -589,7 +593,8 @@ static void kobject_cleanup(struct kobject *kobj)
 	struct kobject * parent = kobj->parent;
 	const char *name = kobj->k_name;
 
-	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
+	pr_debug("kobject: '%s' (%p): %s\n",
+		 kobject_name(kobj), kobj, __FUNCTION__);
 	if (t && t->release) {
 		t->release(kobj);
 		/* If we have a release function, we can guess that this was
@@ -621,7 +626,8 @@ void kobject_put(struct kobject * kobj)
 
 static void dynamic_kobj_release(struct kobject *kobj)
 {
-	pr_debug("%s: freeing %s\n", __FUNCTION__, kobject_name(kobj));
+	pr_debug("kobject: '%s' (%p): %s\n",
+		 kobject_name(kobj), kobj, __FUNCTION__);
 	kfree(kobj);
 }
 
@@ -803,7 +809,8 @@ struct kobject * kset_find_obj(struct kset * kset, const char * name)
 static void kset_release(struct kobject *kobj)
 {
 	struct kset *kset = container_of(kobj, struct kset, kobj);
-	pr_debug("kset %s: now freed\n", kobject_name(kobj));
+	pr_debug("kobject: '%s' (%p): %s\n",
+		 kobject_name(kobj), kobj, __FUNCTION__);
 	kfree(kset);
 }
 
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 5886147..51dc4d2 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -98,7 +98,8 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	int i = 0;
 	int retval = 0;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("kobject: '%s' (%p): %s\n",
+		 kobject_name(kobj), kobj, __FUNCTION__);
 
 	/* search the kset we belong to */
 	top_kobj = kobj;
@@ -106,7 +107,9 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 		top_kobj = top_kobj->parent;
 
 	if (!top_kobj->kset) {
-		pr_debug("kobject attempted to send uevent without kset!\n");
+		pr_debug("kobject: '%s' (%p): %s: attempted to send uevent "
+			 "without kset!\n", kobject_name(kobj), kobj,
+			 __FUNCTION__);
 		return -EINVAL;
 	}
 
@@ -116,7 +119,9 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	/* skip the event, if the filter returns zero. */
 	if (uevent_ops && uevent_ops->filter)
 		if (!uevent_ops->filter(kset, kobj)) {
-			pr_debug("kobject filter function caused the event to drop!\n");
+			pr_debug("kobject: '%s' (%p): %s: filter function "
+				 "caused the event to drop!\n",
+				 kobject_name(kobj), kobj, __FUNCTION__);
 			return 0;
 		}
 
@@ -126,7 +131,9 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	else
 		subsystem = kobject_name(&kset->kobj);
 	if (!subsystem) {
-		pr_debug("unset subsystem caused the event to drop!\n");
+		pr_debug("kobject: '%s' (%p): %s: unset subsystem caused the "
+			 "event to drop!\n", kobject_name(kobj), kobj,
+			 __FUNCTION__);
 		return 0;
 	}
 
@@ -166,8 +173,9 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	if (uevent_ops && uevent_ops->uevent) {
 		retval = uevent_ops->uevent(kset, kobj, env);
 		if (retval) {
-			pr_debug ("%s - uevent() returned %d\n",
-				  __FUNCTION__, retval);
+			pr_debug("kobject: '%s' (%p): %s: uevent() returned "
+				 "%d\n", kobject_name(kobj), kobj,
+				 __FUNCTION__, retval);
 			goto exit;
 		}
 	}
-- 
1.5.3.8

