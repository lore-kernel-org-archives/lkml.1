Return-Path: <linux-kernel-owner+w=401wt.eu-S1762736AbXKCAHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736AbXKCAHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbXKCABi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:34850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761722AbXKCABh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 23/54] kset: convert slub to use kset_create
Date: Fri,  2 Nov 2007 16:59:01 -0700
Message-Id: <1194047972-9850-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/slub.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b821fdb..9957683 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -21,6 +21,7 @@
 #include <linux/ctype.h>
 #include <linux/kallsyms.h>
 #include <linux/memory.h>
+#include <linux/err.h>
 
 /*
  * Lock order:
@@ -3978,7 +3979,7 @@ static struct kset_uevent_ops slab_uevent_ops = {
 	.filter = uevent_filter,
 };
 
-static decl_subsys(slab, &slab_uevent_ops);
+static struct kset *slab_kset;
 
 #define ID_STR_LENGTH 64
 
@@ -4031,7 +4032,7 @@ static int sysfs_slab_add(struct kmem_cache *s)
 		 * This is typically the case for debug situations. In that
 		 * case we can catch duplicate names easily.
 		 */
-		sysfs_remove_link(&slab_subsys.kobj, s->name);
+		sysfs_remove_link(&slab_kset->kobj, s->name);
 		name = s->name;
 	} else {
 		/*
@@ -4042,7 +4043,7 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	}
 
 	kobject_set_name(&s->kobj, name);
-	s->kobj.kset = &slab_subsys;
+	s->kobj.kset = slab_kset;
 	s->kobj.ktype = &slab_ktype;
 	kobject_init(&s->kobj);
 	err = kobject_add(&s->kobj);
@@ -4087,9 +4088,8 @@ static int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 		/*
 		 * If we have a leftover link then remove it.
 		 */
-		sysfs_remove_link(&slab_subsys.kobj, name);
-		return sysfs_create_link(&slab_subsys.kobj,
-						&s->kobj, name);
+		sysfs_remove_link(&slab_kset->kobj, name);
+		return sysfs_create_link(&slab_kset->kobj, &s->kobj, name);
 	}
 
 	al = kmalloc(sizeof(struct saved_alias), GFP_KERNEL);
@@ -4108,10 +4108,11 @@ static int __init slab_sysfs_init(void)
 	struct kmem_cache *s;
 	int err;
 
-	err = subsystem_register(&slab_subsys);
-	if (err) {
+	slab_kset = kset_create_and_register("slab", &slab_uevent_ops,
+					     NULL, NULL);
+	if (IS_ERR(slab_kset)) {
 		printk(KERN_ERR "Cannot register slab subsystem.\n");
-		return -ENOSYS;
+		return PTR_ERR(slab_kset);
 	}
 
 	slab_state = SYSFS;
-- 
1.5.3.4

