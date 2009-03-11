Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbZCKSmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbZCKSmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZCKSmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:42:31 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42778 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZCKSmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:42:31 -0400
Date: Wed, 11 Mar 2009 12:42:25 -0600
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
	per kobj
Message-ID: <20090311184225.GC23138@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
	Cornelia Huck <cornelia.huck@de.ibm.com>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
	jbarnes@virtuousgeek.org, tj@kernel.org,
	linux-kernel@vger.kernel.org
References: <20090310232027.GC25665@ldl.fc.hp.com> <20090311044151.GB25840@suse.de> <20090311070359.GF25665@ldl.fc.hp.com> <20090311153228.GA21217@suse.de> <20090311184729.110761e4@gondolin> <20090311181904.GA10309@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311181904.GA10309@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> On Wed, Mar 11, 2009 at 06:47:29PM +0100, Cornelia Huck wrote:
> > On Wed, 11 Mar 2009 08:32:28 -0700,
> > Greg KH <gregkh@suse.de> wrote:
> > 
> > > Why can't you use device_unregister()?  Or, you could use device_del(),
> > > which lets you rely on the fact that the device structure is still
> > > around for a bit, but it will disappear from sysfs.  Just don't forget
> > > to do the final put_device() on it to free the memory and "really"
> > > release it.
> > > 
> > > Or am I missing something else here?
> > 
> > You can't unregister a device from one of its attribute callbacks,
> 
> Doh!  You're right, very sorry Alex for missing this.

That's ok.

> > (For the original oops, I'd rather solve the problem by making sure the
> > caller doesn't trigger removal several times - should probably be less
> > code than the proposed patch?)
> 
> Any ideas on how to do this?

I still think the original patch I proposed is the right answer.

/ac
---
 file.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)
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
