Return-Path: <linux-kernel-owner+w=401wt.eu-S1761080AbYAYISX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbYAYISX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763220AbYAYIAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:48 -0500
Received: from mx1.suse.de ([195.135.220.2]:59446 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761188AbYAYH7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 157/196] Kobject: drop child->parent ref at unregistration
Date: Thu, 24 Jan 2008 23:33:06 -0800
Message-Id: <1201246425-5058-78-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1015) reverts changes that were made to the driver core
about four years ago.  The intent back then was to avoid certain kinds
of invalid memory accesses by leaving kernel objects allocated as long
as any of their children were still allocated.  The original and
correct approach was to wait only as long as any children were still
_registered_; that's what this patch reinstates.

This fixes a problem in the SCSI core made visible by the class_device
to regular device conversion: A reference loop (scsi_device holds
reference to request_queue, which is the child of a gendisk, which is
the child of the scsi_device) prevents the data structures from being
released, even though they are deregistered okay.

It's possible that this change will cause a few bugs to surface,
things that have been hidden for several years.  They can be fixed
easily enough by having the child device take an explicit reference to
the parent whenever needed.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 1015f74..493e991 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -149,12 +149,16 @@ void kobject_init(struct kobject * kobj)
 
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
@@ -208,7 +212,6 @@ int kobject_add(struct kobject * kobj)
 	if (error) {
 		/* unlink does the kobject_put() for us */
 		unlink(kobj);
-		kobject_put(parent);
 
 		/* be noisy on error issues */
 		if (error == -EEXIST)
@@ -590,7 +593,6 @@ static void kobject_cleanup(struct kobject *kobj)
 {
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
-	struct kobject * parent = kobj->parent;
 	const char *name = kobj->k_name;
 
 	pr_debug("kobject: '%s' (%p): %s\n",
@@ -604,7 +606,6 @@ static void kobject_cleanup(struct kobject *kobj)
 	}
 	if (s)
 		kset_put(s);
-	kobject_put(parent);
 }
 
 static void kobject_release(struct kref *kref)
-- 
1.5.3.8

