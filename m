Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbXDWUuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbXDWUuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXDWUuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:50:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41201 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751208AbXDWUuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:50:00 -0400
Date: Mon, 23 Apr 2007 13:49:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB: kmem_cache_destroy doesn't - version 2.
In-Reply-To: <17964.21972.961812.744601@notabene.brown>
Message-ID: <Pine.LNX.4.64.0704231340180.512@schroedinger.engr.sgi.com>
References: <17960.16739.870487.497750@notabene.brown>
 <Pine.LNX.4.64.0704192215420.16306@schroedinger.engr.sgi.com>
 <17960.20796.761309.771912@notabene.brown> <Pine.LNX.4.64.0704192236510.16503@schroedinger.engr.sgi.com>
 <17964.21972.961812.744601@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Would this work? Contains a solution somewhat along the lines of your 
thoughts on the subject.


SLAB: Fix sysfs directory handling

This fixes the problem that SLUB does not track the names of aliased
slabs by changing the way that SLUB manages the files in /sys/slab.

If the slab that is being created is not mergeable (usually the
case if we are debugging) then do not create any aliases. If an alias
exists that we conflict with then remove it before creating the
directory for the unmergeable slab. If there is a true slab cache there
and not an alias then we fail since there is a true duplication of
slab cache names. So debugging allows the detection of slab name
duplication as usual.

If the slab is mergeable then we create a directory with a unique name
created from the slab size, slab options and the pointer to the kmem_cache
structure (disambiguation). All names referring to the slabs will
then be created as symlinks to that unique name. These symlinks are
not going to be removed on kmem_cache_destroy() since we only carry
a counter for the number of aliases. If a new symlink is created
then it may just replace an existing one. This means that one can create
a gazillion slabs with the same name (if they all refer to mergeable
caches). Doing so will only increase the alias count. So we have the 
potential of not detecting duplicate slab names (SLUB works fine
with duplicate slab names anyways). We will detect the duplications when
debugging is enabled because we will then no longer generate symlinks and 
special unique names.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc6/mm/slub.c
===================================================================
--- linux-2.6.21-rc6.orig/mm/slub.c	2007-04-23 13:08:41.000000000 -0700
+++ linux-2.6.21-rc6/mm/slub.c	2007-04-23 13:09:10.000000000 -0700
@@ -3307,16 +3307,66 @@ static struct kset_uevent_ops slab_ueven
 
 decl_subsys(slab, &slab_ktype, &slab_uevent_ops);
 
+#define ID_STR_LENGTH 30
+
+/* Create a unique string id for a slab cache:
+ * format
+ * :[flags-]size:[memory address of kmemcache]
+ */
+static char *create_unique_id(struct kmem_cache *s)
+{
+	char *name = kmalloc(ID_STR_LENGTH, GFP_KERNEL);
+	char *p = name;
+
+	BUG_ON(!name);
+
+	*p++ = ':';
+	/*
+	 * First flags affecting slabcache operations */
+	if (s->flags & SLAB_CACHE_DMA)
+		*p++ = 'd';
+	if (s->flags & SLAB_RECLAIM_ACCOUNT)
+		*p++ = 'a';
+	if (s->flags & SLAB_DESTROY_BY_RCU)
+		*p++ = 'r';
+	/* Debug flags */
+	if (s->flags & SLAB_RED_ZONE)
+		*p++ = 'Z';
+	if (s->flags & SLAB_POISON)
+		*p++ = 'P';
+	if (s->flags & SLAB_STORE_USER)
+		*p++ = 'U';
+	if (p != name + 1)
+		*p++ = '-';
+	p += sprintf(p,"%06d:0x%p" ,s->size, s);
+	BUG_ON(p > name + ID_STR_LENGTH - 1);
+	return name;
+}
+
 static int sysfs_slab_add(struct kmem_cache *s)
 {
 	int err;
+	const char *name;
 
 	if (slab_state < SYSFS)
 		/* Defer until later */
 		return 0;
-
+	if (s->flags & SLUB_NEVER_MERGE) {
+		/*
+		 * Slabcache can never be merged so we can use the name proper.
+		 * This is typically the case for debug situations. In that
+		 * case we can catch duplicate names easily.
+		 */
+		sysfs_remove_link(&slab_subsys.kset.kobj, s->name);
+		name = s->name;
+	} else
+		/*
+		 * Create a unique name for the slab as a target
+		 * for the symlinks.
+		 */
+		name = create_unique_id(s);
 	kobj_set_kset_s(s, slab_subsys);
-	kobject_set_name(&s->kobj, s->name);
+	kobject_set_name(&s->kobj, name);
 	kobject_init(&s->kobj);
 	err = kobject_add(&s->kobj);
 	if (err)
@@ -3326,6 +3376,8 @@ static int sysfs_slab_add(struct kmem_ca
 	if (err)
 		return err;
 	kobject_uevent(&s->kobj, KOBJ_ADD);
+	if (!(s->flags & SLUB_NEVER_MERGE))
+		sysfs_slab_alias(s, s->name);
 	return 0;
 }
 
@@ -3351,9 +3403,14 @@ static int sysfs_slab_alias(struct kmem_
 {
 	struct saved_alias *al;
 
-	if (slab_state == SYSFS)
+	if (slab_state == SYSFS) {
+		/*
+		 * If we have a leftover link then remove it.
+		 */
+		sysfs_remove_link(&slab_subsys.kset.kobj, name);
 		return sysfs_create_link(&slab_subsys.kset.kobj,
 						&s->kobj, name);
+	}
 
 	al = kmalloc(sizeof(struct saved_alias), GFP_KERNEL);
 	if (!al)


