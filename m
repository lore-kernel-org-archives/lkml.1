Return-Path: <linux-kernel-owner+w=401wt.eu-S1767127AbXDTPkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767127AbXDTPkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767130AbXDTPkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:40:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44121 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1767127AbXDTPkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:40:40 -0400
Date: Fri, 20 Apr 2007 11:40:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <46284F2A.4000401@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0704201136590.2616-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a patch to do what I mentioned earlier.  Not tested -- it may 
expose some existing bugs.  It may even break something, but I'm not aware 
of anything that depends on it explicitly.

Greg, do you know of anything in particular that depends on a kobjects not 
being released before their children are released?

This is meant to be used without any of the other changes Cornelia and I 
have posted.  Although it might not hurt to have them all present...

Alan Stern



Index: usb-2.6/lib/kobject.c
===================================================================
--- usb-2.6.orig/lib/kobject.c
+++ usb-2.6/lib/kobject.c
@@ -192,12 +192,15 @@ void kobject_init(struct kobject * kobj)
 
 static void unlink(struct kobject * kobj)
 {
+	struct kobject *parent = kobj->parent;
+
 	if (kobj->kset) {
 		spin_lock(&kobj->kset->list_lock);
 		list_del_init(&kobj->entry);
 		spin_unlock(&kobj->kset->list_lock);
 	}
 	kobject_put(kobj);
+	kobject_put(parent);
 }
 
 /**
@@ -241,7 +244,6 @@ int kobject_shadow_add(struct kobject * 
 	if (error) {
 		/* unlink does the kobject_put() for us */
 		unlink(kobj);
-		kobject_put(parent);
 
 		/* be noisy on error issues */
 		if (error == -EEXIST)
@@ -489,7 +491,6 @@ void kobject_cleanup(struct kobject * ko
 {
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
-	struct kobject * parent = kobj->parent;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
 	if (kobj->k_name != kobj->name)
@@ -505,7 +506,6 @@ void kobject_cleanup(struct kobject * ko
 
 	if (s)
 		kset_put(s);
-	kobject_put(parent);
 }
 
 static void kobject_release(struct kref *kref)

