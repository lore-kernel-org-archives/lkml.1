Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbYAYIEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbYAYIEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764064AbYAYH7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:46 -0500
Received: from mx1.suse.de ([195.135.220.2]:59322 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764044AbYAYH7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 163/196] Kobject: remove kobject_add() as no one uses it anymore
Date: Thu, 24 Jan 2008 23:33:12 -0800
Message-Id: <1201246425-5058-84-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old kobject_add() function is on longer in use, so let us remove it
from the public scope (kset mess in the kobject.c file still uses it,
but that can be cleaned up later very simply.)

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    1 -
 lib/kobject.c           |   22 ++++++++--------------
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index bb68684..8b0aa71 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -80,7 +80,6 @@ static inline const char * kobject_name(const struct kobject * kobj)
 
 extern void kobject_init(struct kobject *);
 extern void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype);
-extern int __must_check kobject_add(struct kobject *);
 extern int __must_check kobject_add_ng(struct kobject *kobj,
 				       struct kobject *parent,
 				       const char *fmt, ...);
diff --git a/lib/kobject.c b/lib/kobject.c
index 493e991..d04789f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -144,7 +144,7 @@ void kobject_init(struct kobject * kobj)
  *	Remove the kobject from the kset list and decrement
  *	its parent's refcount.
  *	This is separated out, so we can use it in both 
- *	kobject_del() and kobject_add() on error.
+ *	kobject_del() and kobject_add_internal() on error.
  */
 
 static void unlink(struct kobject * kobj)
@@ -161,12 +161,7 @@ static void unlink(struct kobject * kobj)
 	kobject_put(parent);
 }
 
-/**
- *	kobject_add - add an object to the hierarchy.
- *	@kobj:	object.
- */
-
-int kobject_add(struct kobject * kobj)
+static int kobject_add_internal(struct kobject *kobj)
 {
 	int error = 0;
 	struct kobject * parent;
@@ -215,13 +210,13 @@ int kobject_add(struct kobject * kobj)
 
 		/* be noisy on error issues */
 		if (error == -EEXIST)
-			printk(KERN_ERR "kobject_add failed for %s with "
+			printk(KERN_ERR "%s failed for %s with "
 			       "-EEXIST, don't try to register things with "
 			       "the same name in the same directory.\n",
-			       kobject_name(kobj));
+			       __FUNCTION__, kobject_name(kobj));
 		else
-			printk(KERN_ERR "kobject_add failed for %s (%d)\n",
-			       kobject_name(kobj), error);
+			printk(KERN_ERR "%s failed for %s (%d)\n",
+			       __FUNCTION__, kobject_name(kobj), error);
 		dump_stack();
 	}
 
@@ -351,7 +346,7 @@ static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
 		return retval;
 	}
 	kobj->parent = parent;
-	return kobject_add(kobj);
+	return kobject_add_internal(kobj);
 }
 
 /**
@@ -742,7 +737,7 @@ struct sysfs_ops kobj_sysfs_ops = {
 
 int kset_add(struct kset * k)
 {
-	return kobject_add(&k->kobj);
+	return kobject_add_internal(&k->kobj);
 }
 
 
@@ -897,7 +892,6 @@ EXPORT_SYMBOL(kobject_register);
 EXPORT_SYMBOL(kobject_unregister);
 EXPORT_SYMBOL(kobject_get);
 EXPORT_SYMBOL(kobject_put);
-EXPORT_SYMBOL(kobject_add);
 EXPORT_SYMBOL(kobject_del);
 
 EXPORT_SYMBOL(kset_register);
-- 
1.5.3.8

