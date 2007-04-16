Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbXDPRem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbXDPRem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 13:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbXDPRej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 13:34:39 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:17381 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbXDPRd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 13:33:57 -0400
Date: Mon, 16 Apr 2007 19:36:27 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [Patch -mm 3/3] RFC: Introduce kobject->owner for refcounting.
Message-ID: <20070416193627.1db62136@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grab and release the module kobject refcount if kobj->owner is set.
This prevents calls to the release function after the module has
been unloaded.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 include/linux/kobject.h |    1 +
 lib/kobject.c           |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6.orig/include/linux/kobject.h
+++ linux-2.6/include/linux/kobject.h
@@ -51,6 +51,7 @@ enum kobject_action {
 };
 
 struct kobject {
+	struct module		* owner;
 	const char		* k_name;
 	char			name[KOBJ_NAME_LEN];
 	struct kref		kref;
--- linux-2.6.orig/lib/kobject.c
+++ linux-2.6/lib/kobject.c
@@ -177,6 +177,8 @@ void kobject_init(struct kobject * kobj)
 	INIT_LIST_HEAD(&kobj->entry);
 	init_waitqueue_head(&kobj->poll);
 	kobj->kset = kset_get(kobj->kset);
+	/* Attempt to grab reference of owning module's kobject. */
+	mod_kobject_get(kobj->owner);
 }
 
 
@@ -254,6 +256,7 @@ int kobject_shadow_add(struct kobject * 
 			printk("kobject_add failed for %s (%d)\n",
 			       kobject_name(kobj), error);
 		 dump_stack();
+		 mod_kobject_put(kobj->owner);
 	}
 
 	return error;
@@ -491,6 +494,7 @@ void kobject_cleanup(struct kobject * ko
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
 	struct kobject * parent = kobj->parent;
+	struct module * owner = kobj->owner;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
 	if (kobj->k_name != kobj->name)
@@ -503,7 +507,7 @@ void kobject_cleanup(struct kobject * ko
 			"if this is not a directory kobject, it is broken "
 			"and must be fixed.\n",
 			kobj->name);
-
+	mod_kobject_put(owner);
 	if (s)
 		kset_put(s);
 	kobject_put(parent);
