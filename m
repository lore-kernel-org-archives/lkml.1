Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbYAYHij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbYAYHij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759430AbYAYHSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:18:25 -0500
Received: from mx1.suse.de ([195.135.220.2]:52917 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759422AbYAYHSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:18:23 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 067/196] kset: convert slub to use kset_create
Date: Thu, 24 Jan 2008 23:10:05 -0800
Message-Id: <1201245134-4876-67-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/slub.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 40bdf41..886131c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3962,7 +3962,7 @@ static struct kset_uevent_ops slab_uevent_ops = {
 	.filter = uevent_filter,
 };
 
-static decl_subsys(slab, &slab_uevent_ops);
+static struct kset *slab_kset;
 
 #define ID_STR_LENGTH 64
 
@@ -4015,7 +4015,7 @@ static int sysfs_slab_add(struct kmem_cache *s)
 		 * This is typically the case for debug situations. In that
 		 * case we can catch duplicate names easily.
 		 */
-		sysfs_remove_link(&slab_subsys.kobj, s->name);
+		sysfs_remove_link(&slab_kset->kobj, s->name);
 		name = s->name;
 	} else {
 		/*
@@ -4026,7 +4026,7 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	}
 
 	kobject_set_name(&s->kobj, name);
-	s->kobj.kset = &slab_subsys;
+	s->kobj.kset = slab_kset;
 	s->kobj.ktype = &slab_ktype;
 	kobject_init(&s->kobj);
 	err = kobject_add(&s->kobj);
@@ -4071,9 +4071,8 @@ static int sysfs_slab_alias(struct kmem_cache *s, const char *name)
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
@@ -4092,8 +4091,8 @@ static int __init slab_sysfs_init(void)
 	struct kmem_cache *s;
 	int err;
 
-	err = subsystem_register(&slab_subsys);
-	if (err) {
+	slab_kset = kset_create_and_add("slab", &slab_uevent_ops, NULL);
+	if (!slab_kset) {
 		printk(KERN_ERR "Cannot register slab subsystem.\n");
 		return -ENOSYS;
 	}
-- 
1.5.3.8

