Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZCJXUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZCJXUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZCJXUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:20:31 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:18715 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZCJXUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:20:30 -0400
Date: Tue, 10 Mar 2009 17:20:27 -0600
From: Alex Chiang <achiang@hp.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, gregkh@suse.de, tj@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH, RFC] sysfs: only allow one scheduled removal callback per
	kobj
Message-ID: <20090310232027.GC25665@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
	jbarnes@virtuousgeek.org, gregkh@suse.de, tj@kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard, sysfs folks,

Vegard was nice enough to test my PCI remove/rescan patches under
kmemcheck. Maybe "torture" is a more appropriate term. ;)

My patch series introduces a sysfs "remove" attribute for PCI
devices, which will remove that device (and child devices).

	http://thread.gmane.org/gmane.linux.kernel.pci/3495

Vegard decided that he wanted to do something like:

	# while true ; do echo 1 > /sys/bus/pci/devices/.../remove ; done

which caused a nasty oops in my code. You can see the results of
his testing in the thread I referenced above.

After looking at my code for a bit, I decided that maybe it
wasn't completely my fault. ;) See, I'm using device_schedule_callback()
which really is a wrapper around sysfs_schedule_callback() which
is the way that a sysfs attribute is supposed to remove itself to
prevent deadlock.

The problem that Vegard's test exposed is that if you repeatedly
call a sysfs attribute that's supposed to remove itself using
device_schedule_callback, we'll keep scheduling work queue tasks
with a kobj that we really want to release.

[nb, I bet that /sys/bus/scsi/devices/.../delete will exhibit the
same problems]

This is very racy, and at some point, whatever remove handler
we've scheduled with device_schedule_callback will end up
referencing a freed kobj.

I came up with the below patch which changes the semantics of
device/sysfs_schedule_callback. We now only allow one in-flight
callback per kobj, and return -EBUSY if that kobj already has a
callback scheduled for it.

This patch, along with my updated 07/11 patch in my series,
prevents at least the first oops that Vegard reported, and I
suspect it prevents the second kmemcheck error too, although I
haven't tested under kmemcheck (yet*).

I'm looking for comments on the approach I took, specifically:

	- are we ok with the new restriction I imposed?
	- is it ok to return -EBUSY to our callers?
	- is the simple linked list proof of concept
	  implementation going to scale too poorly?

To answer my own first two questions, I checked for callers of
both device_ and sysfs_schedule_callback, and it looks like
everyone is using it the same way: to schedule themselves for
removal. That is, although the interface could be used to
schedule any sort of callback, the only use case is the removal
use case. I don't think it will be a problem to limit ourselves
to one remove callback per kobj.

Maybe this patch really wants to be a new interface called
sysfs_schedule_callback_once or _single, where we check for an
already-scheduled callback for a kobj, and if we pass, then we
simply continue on to the existing, unchanged
sysfs_schedule_callback. I don't feel too strongly about creating
a new interface, but my belief is that changing the semantics of
the existing interface is probably the better solution.

My opinion on my own third question is that removing a device is
not in the performance path, so a simple linked list is
sufficient.

Depending on the feedback here, I'll resend this patch with a
full changelog (and giving credit to Vegard/kmemcheck as Ingo
requested I do) or I can rework it.

Thanks.

/ac

*: I googled for kmemcheck and the most recent tree I found was
from 2008. Is that really true? Do the patches apply to current
upstream?
---
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 1f4a3f8..e05a172 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -659,13 +659,16 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
 EXPORT_SYMBOL_GPL(sysfs_remove_file_from_group);
 
 struct sysfs_schedule_callback_struct {
-	struct kobject 		*kobj;
+	struct list_head	workq_list;
+	struct kobject		*kobj;
 	void			(*func)(void *);
 	void			*data;
 	struct module		*owner;
 	struct work_struct	work;
 };
 
+static DEFINE_MUTEX(sysfs_workq_mutex);
+static LIST_HEAD(sysfs_workq);
 static void sysfs_schedule_callback_work(struct work_struct *work)
 {
 	struct sysfs_schedule_callback_struct *ss = container_of(work,
@@ -674,6 +677,9 @@ static void sysfs_schedule_callback_work(struct work_struct *work)
 	(ss->func)(ss->data);
 	kobject_put(ss->kobj);
 	module_put(ss->owner);
+	mutex_lock(&sysfs_workq_mutex);
+	list_del(&ss->workq_list);
+	mutex_unlock(&sysfs_workq_mutex);
 	kfree(ss);
 }
 
@@ -700,10 +706,19 @@ static void sysfs_schedule_callback_work(struct work_struct *work)
 int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
 		void *data, struct module *owner)
 {
-	struct sysfs_schedule_callback_struct *ss;
+	struct sysfs_schedule_callback_struct *ss, *tmp;
 
 	if (!try_module_get(owner))
 		return -ENODEV;
+
+	mutex_lock(&sysfs_workq_mutex);
+	list_for_each_entry_safe(ss, tmp, &sysfs_workq, workq_list)
+		if (ss->kobj == kobj) {
+			mutex_unlock(&sysfs_workq_mutex);
+			return -EBUSY;
+		}
+	mutex_unlock(&sysfs_workq_mutex);
+
 	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
 	if (!ss) {
 		module_put(owner);
@@ -715,6 +730,10 @@ int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
 	ss->data = data;
 	ss->owner = owner;
 	INIT_WORK(&ss->work, sysfs_schedule_callback_work);
+	INIT_LIST_HEAD(&ss->workq_list);
+	mutex_lock(&sysfs_workq_mutex);
+	list_add_tail(&ss->workq_list, &sysfs_workq);
+	mutex_unlock(&sysfs_workq_mutex);
 	schedule_work(&ss->work);
 	return 0;
 }
