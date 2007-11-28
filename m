Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbXK1UmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbXK1UmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756881AbXK1UmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:42:03 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59417 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755978AbXK1UmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:42:01 -0500
Date: Wed, 28 Nov 2007 15:42:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH] kobject: make sure kobj->ktype is set before kobject_init
In-Reply-To: <1196279172.3242.119.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0711281532150.2729-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1020) adds a check to kobject_init() to insure that the
ktype field is not NULL.  This is just for safety's sake; as far as I
know there are no remaining places where the field is left unset.  But
ironically, kset_init() did fail to set it!  The patch fixes that and
removes some redundant initialization in kset_createa().

The patch also fixes up elevator_init(), where ktype was set after
calling kobject_init() instead of before.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Kay Sievers <kay.sievers@vrfy.org>

---

Here is the check we discussed.  I'm a little behind on Kay's most 
recent updates; I hope this doesn't clash with them.

There may be some other places where ktype gets set after 
kobject_init() rather than before.  My testing can't be termendously 
thorough.  But they should all be easy to fix (like elevator.c was).


Index: usb-2.6/lib/kobject.c
===================================================================
--- usb-2.6.orig/lib/kobject.c
+++ usb-2.6/lib/kobject.c
@@ -188,6 +188,7 @@ void kobject_init(struct kobject * kobj)
 		return;
 	WARN_ON(atomic_read(&kobj->kref.refcount));
 	verify_dynamic_kobject_allocation(kobj);
+	WARN_ON(!kobj->ktype);
 	kref_init(&kobj->kref);
 	INIT_LIST_HEAD(&kobj->entry);
 	kobj->kset = kset_get(kobj->kset);
@@ -624,18 +625,6 @@ struct kobject *kobject_create_and_regis
 }
 EXPORT_SYMBOL_GPL(kobject_create_and_register);
 
-/**
- *	kset_init - initialize a kset for use
- *	@k:	kset 
- */
-
-void kset_init(struct kset * k)
-{
-	kobject_init(&k->kobj);
-	INIT_LIST_HEAD(&k->list);
-	spin_lock_init(&k->list_lock);
-}
-
 /* default kobject attribute operations */
 static ssize_t kobj_attr_show(struct kobject *kobj, struct attribute *attr,
 			      char *buf)
@@ -751,6 +740,19 @@ static struct kobj_type kset_ktype = {
 };
 
 /**
+ *	kset_init - initialize a kset for use
+ *	@k:	kset
+ */
+
+void kset_init(struct kset * k)
+{
+	k->kobj.ktype = &kset_ktype;
+	kobject_init(&k->kobj);
+	INIT_LIST_HEAD(&k->list);
+	spin_lock_init(&k->list_lock);
+}
+
+/**
  * kset_create - create a struct kset dynamically
  *
  * @name: the name for the kset
@@ -779,12 +781,10 @@ static struct kset *kset_create(const ch
 	kset->kobj.parent = parent_kobj;
 
 	/*
-	 * The kobject of this kset will have a type of kset_ktype and belong to
-	 * no kset itself.  That way we can properly free it when it is
+	 * The kobject of this kset will have a type of kset_ktype and belong
+	 * to no kset itself.  That way we can properly free it when it is
 	 * finished being used.
 	 */
-	kset->kobj.ktype = &kset_ktype;
-	kset->kobj.kset = NULL;
 
 	return kset;
 }
Index: usb-2.6/block/elevator.c
===================================================================
--- usb-2.6.orig/block/elevator.c
+++ usb-2.6/block/elevator.c
@@ -185,9 +185,9 @@ static elevator_t *elevator_alloc(struct
 
 	eq->ops = &e->ops;
 	eq->elevator_type = e;
-	kobject_init(&eq->kobj);
 	kobject_set_name(&eq->kobj, "%s", "iosched");
 	eq->kobj.ktype = &elv_ktype;
+	kobject_init(&eq->kobj);
 	mutex_init(&eq->sysfs_lock);
 
 	eq->hash = kmalloc_node(sizeof(struct hlist_head) * ELV_HASH_ENTRIES,

