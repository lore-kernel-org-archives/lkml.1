Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbXJWEOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbXJWEOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbXJWEOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:14:44 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4563 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750846AbXJWEOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:14:44 -0400
Date: Tue, 23 Oct 2007 00:14:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices
In-Reply-To: <1193097681.2107.9.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0710230001560.13902-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, Kay Sievers wrote:

> There is definitely something wrong, I tried all sorts of options now,
> and a second machine, and I can never get the behavior you see. I even
> booted with init=/bin/sh.
> But true, looking at the kobject debugging for loop devices, and usb
> storage driven by the ub driver, all looks fine without the additional
> put.

Yes; I haven't been able to figure out why we get different results.

> There must be something going wrong with the block patch in conjunction
> with the crazy SCSI release logic.

I don't know -- there's nothing obviously wrong with the block patch 
except the extra put_device.  But you're right that the SCSI logic is 
crazy.  The scsi_device is the parent of the gendisk, which is the 
parent of the request_queue.  But the scsi_device holds a reference to 
the request_queue, which is dropped in the scsi_device's release 
routine!  That doesn't make much sense to me, and it is complicated by 
the fact that deleting a kobject doesn't drop the kobject's reference 
to its parent -- only releasing the kobject does.

In fact, for my development work I normally use a patch which makes 
kobjects behave better: They do drop the reference to their parent when 
they are deleted.  This actually is nothing more than a reversion of a 
patch added several years ago to try and cover up some of the 
weaknesses of the SCSI stack!  Now that the SCSI stack is in better 
shape, maybe my patch should be included in the mainstream kernel.  The 
patch is below; see what you think.

> Can you send me your .config? Just
> for a check, maybe you have some option, enabled/disabled that changes
> the behavior, and possibly brings us closer to find the bug.

I'll send it to you off-list.

Unfortunately I don't have much time to work on debugging this right
now; I'm on vacation this week.

Alan Stern


Index: usb-2.6/lib/kobject.c
===================================================================
--- usb-2.6.orig/lib/kobject.c
+++ usb-2.6/lib/kobject.c
@@ -206,12 +206,16 @@ void kobject_init(struct kobject * kobj)
 
 static void unlink(struct kobject * kobj)
 {
+	struct kobject *parent = kobj->parent;
+
 	if (kobj->kset) {
 		spin_lock(&kobj->kset->list_lock);
 		list_del_init(&kobj->entry);
 		spin_unlock(&kobj->kset->list_lock);
 	}
+	kobj->parent = NULL;
 	kobject_put(kobj);
+	kobject_put(parent);
 }
 
 /**
@@ -255,7 +259,6 @@ int kobject_add(struct kobject * kobj)
 	if (error) {
 		/* unlink does the kobject_put() for us */
 		unlink(kobj);
-		kobject_put(parent);
 
 		/* be noisy on error issues */
 		if (error == -EEXIST)
@@ -498,7 +501,6 @@ void kobject_cleanup(struct kobject * ko
 {
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
-	struct kobject * parent = kobj->parent;
 	const char *name = kobj->k_name;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
@@ -515,7 +517,6 @@ void kobject_cleanup(struct kobject * ko
 	}
 	if (s)
 		kset_put(s);
-	kobject_put(parent);
 }
 
 static void kobject_release(struct kref *kref)

