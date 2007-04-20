Return-Path: <linux-kernel-owner+w=401wt.eu-S1422887AbXDTFvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422887AbXDTFvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422895AbXDTFvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:51:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60012 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422887AbXDTFvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:51:06 -0400
Date: Thu, 19 Apr 2007 22:51:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB: kmem_cache_destroy doesn't - version 2.
In-Reply-To: <Pine.LNX.4.64.0704192236510.16503@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0704192249070.17171@schroedinger.engr.sgi.com>
References: <17960.16739.870487.497750@notabene.brown>
 <Pine.LNX.4.64.0704192215420.16306@schroedinger.engr.sgi.com>
 <17960.20796.761309.771912@notabene.brown> <Pine.LNX.4.64.0704192236510.16503@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Another approach drop the symlinks completely. Just 
write a message to the syslog informing the user that we
created an alias. If debugging is off then the user would have to consult
the syslog to find aliases.


Index: linux-2.6.21-rc6/mm/slub.c
===================================================================
--- linux-2.6.21-rc6.orig/mm/slub.c	2007-04-19 22:46:20.000000000 -0700
+++ linux-2.6.21-rc6/mm/slub.c	2007-04-19 22:48:26.000000000 -0700
@@ -158,11 +158,9 @@ LIST_HEAD(slab_caches);
 
 #ifdef CONFIG_SYSFS
 static int sysfs_slab_add(struct kmem_cache *);
-static int sysfs_slab_alias(struct kmem_cache *, const char *);
 static void sysfs_slab_remove(struct kmem_cache *);
 #else
 static int sysfs_slab_add(struct kmem_cache *s) { return 0; }
-static int sysfs_slab_alias(struct kmem_cache *s, const char *p) { return 0; }
 static void sysfs_slab_remove(struct kmem_cache *s) {}
 #endif
 
@@ -2324,8 +2322,8 @@ struct kmem_cache *kmem_cache_create(con
 		 */
 		s->objsize = max(s->objsize, (int)size);
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
-		if (sysfs_slab_alias(s, name))
-			goto err;
+		printk(KERN_INFO "SLUB: %s is an alias of %s\n",
+							name, s->name);
 	} else {
 		s = kmalloc(kmem_size, GFP_KERNEL);
 		if (s && kmem_cache_open(s, GFP_KERNEL, name,
@@ -3335,37 +3333,6 @@ static void sysfs_slab_remove(struct kme
 	kobject_del(&s->kobj);
 }
 
-/*
- * Need to buffer aliases during bootup until sysfs becomes
- * available lest we loose that information.
- */
-struct saved_alias {
-	struct kmem_cache *s;
-	const char *name;
-	struct saved_alias *next;
-};
-
-struct saved_alias *alias_list;
-
-static int sysfs_slab_alias(struct kmem_cache *s, const char *name)
-{
-	struct saved_alias *al;
-
-	if (slab_state == SYSFS)
-		return sysfs_create_link(&slab_subsys.kset.kobj,
-						&s->kobj, name);
-
-	al = kmalloc(sizeof(struct saved_alias), GFP_KERNEL);
-	if (!al)
-		return -ENOMEM;
-
-	al->s = s;
-	al->name = name;
-	al->next = alias_list;
-	alias_list = al;
-	return 0;
-}
-
 int __init slab_sysfs_init(void)
 {
 	int err;
@@ -3378,15 +3345,6 @@ int __init slab_sysfs_init(void)
 
 	finish_bootstrap();
 
-	while (alias_list) {
-		struct saved_alias *al = alias_list;
-
-		alias_list = alias_list->next;
-		err = sysfs_slab_alias(al->s, al->name);
-		BUG_ON(err);
-		kfree(al);
-	}
-
 	resiliency_test();
 	return 0;
 }
