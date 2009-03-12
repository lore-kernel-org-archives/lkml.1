Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbZCLWCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbZCLWCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 18:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZCLWCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 18:02:36 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:30127 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbZCLWCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 18:02:35 -0400
Date: Thu, 12 Mar 2009 16:02:31 -0600
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: cornelia.huck@de.ibm.com, Tejun Heo <tj@kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
	per kobj
Message-ID: <20090312220231.GC31042@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
	cornelia.huck@de.ibm.com, Tejun Heo <tj@kernel.org>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
	jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
References: <20090310232027.GC25665@ldl.fc.hp.com> <20090311044151.GB25840@suse.de> <20090311070359.GF25665@ldl.fc.hp.com> <49B76640.6010109@kernel.org> <20090312002737.GB17345@ldl.fc.hp.com> <20090312032228.GA25419@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312032228.GA25419@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> On Wed, Mar 11, 2009 at 06:27:37PM -0600, Alex Chiang wrote:
> > 
> > I haven't dived into the SCSI code yet, but they are doing some
> > sort of magic that I don't understand with their state machine.
> > 
> > Regardless, I think we have two issues.
> > 
> > 	1. The existing callback mechanism that everyone hates
> > 	has a "bug".
> > 
> > 	2. Your suicide patches haven't made it into mainline yet.
> > 
> > The reason that I think that the "bug" is with the callback
> > mechanism is because any caller can repeatedly schedule suicide
> > over and over again, and the callback handler will eventually get
> > a stale pointer. Rather than make all the callsites handle the
> > locking, doesn't it make more sense for the infrastructure to do
> > it?
> > 
> > I realize we're trying to fix something that everyone wants to go
> > away, but the PCI rescan patches add some pretty useful
> > functionality and pretty much ready to go except for this. I
> > could add the bookkeeping into my suicide path, but that's
> > actually a slightly bigger patch, because now I have to malloc my
> > own callback structs. And again, I think it's more appropriate to
> > put that sort of code into the core.
> > 
> > Can we fix 1 in the short term and move towards 2 as the real
> > solution?
> 
> I have no objection to this plan.
> 
> thanks,
> 
> greg k-h

From: Alex Chiang <achiang@hp.com>

sysfs: only allow one scheduled removal callback per kobj

The only way for a sysfs attribute to remove itself (without
deadlock) is to use the sysfs_schedule_callback() interface.

Vegard Nossum discovered that a poorly written sysfs ->store
callback can repeatedly schedule remove callbacks on the same
device over and over, e.g.

	$ while true ; do echo 1 > /sys/devices/.../remove ; done

If the 'remove' attribute uses the sysfs_schedule_callback API
and also does not protect itself from concurrent accesses, its
callback handler will be called multiple times, and will
eventually attempt to perform operations on a freed kobject,
leading to many problems.

Instead of requiring all callers of sysfs_schedule_callback to
implement their own synchronization, provide the protection in
the infrastructure.

Now, sysfs_schedule_callback will only allow one scheduled
callback per kobject. On subsequent calls with the same kobject,
return -EAGAIN.

This is a short term fix. The long term fix is to allow sysfs
attributes to remove themselves directly, without any of this
callback hokey pokey.

Cc: cornelia.huck@de.ibm.com
Reported-by: vegard.nossum@gmail.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---
Greg, I think this is .30 material; we're late in the -rc cycle
now and we're changing the semantics of an API.

Cornelia, I understand your earlier point about a smaller patch
in the caller, but I think pushing the code down into the
infrastructure is the right thing to do. Also, I wasn't brave
enough to patch your ccwgroup_ungroup_store(), but I think you
won't need the gdev->onoff stuff anymore in that code path.

Thanks.
---
 file.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)
---
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 1f4a3f8..289c43a 100644
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
 
@@ -695,15 +701,25 @@ static void sysfs_schedule_callback_work(struct work_struct *work)
  * until @func returns.
  *
  * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated, -ENODEV if a reference to @owner isn't available.
+ * be allocated, -ENODEV if a reference to @owner isn't available,
+ * -EAGAIN if a callback has already been scheduled for @kobj.
  */
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
+			return -EAGAIN;
+		}
+	mutex_unlock(&sysfs_workq_mutex);
+
 	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
 	if (!ss) {
 		module_put(owner);
@@ -715,6 +731,10 @@ int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
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
