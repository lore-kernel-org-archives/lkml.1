Return-Path: <linux-kernel-owner+w=401wt.eu-S1762903AbXLMQv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903AbXLMQv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbXLMQvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:51:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48311 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbXLMQvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:51:48 -0500
Date: Thu, 13 Dec 2007 17:50:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: vincent.fortier1@ec.gc.ca, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071213165059.GC4865@elte.hu>
References: <1197554397.19869.3.camel@lov.site> <1197558120.4936.34.camel@kayak.wul.qc.ec.gc.ca> <1197562981.19869.5.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197562981.19869.5.camel@lov.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kay Sievers <kay.sievers@vrfy.org> wrote:

> > > > > +   sa->attr.owner = NULL;
> > > > >     sa->attr.name = name;
> > > >
> > > > i'm wondering why doesnt this affect 2.6.23 and later? Does sysfs
> > > > initialize the owner field to NULL automatically?
> > > 
> > > Attibutes do not have an owner anymore:
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7b595756ec1f49e0049a9e01a1298d53a7faaa15
> > 
> > This one also fails to apply properly at the exact same place has 
> > Ingo's previously posted patch.  Would need to backport his one.
> 
> It depends on a completely reworked sysfs logic, I don't think it 
> makes any sense to backport that.

well, if it fixes a live bug in a still supported stable kernel 
release...

Vincent, could you try to just get rid of all actual uses of 
se->attr.owner, within fs/sysfs/*.c? Something like the patch below. 
(totally untested - might be fatally broken as well)

	Ingo

---
 fs/sysfs/bin.c  |    7 -------
 fs/sysfs/file.c |   13 -------------
 2 files changed, 20 deletions(-)

Index: linux-cfs-2.6.22.13.q/fs/sysfs/bin.c
===================================================================
--- linux-cfs-2.6.22.13.q.orig/fs/sysfs/bin.c
+++ linux-cfs-2.6.22.13.q/fs/sysfs/bin.c
@@ -125,11 +125,6 @@ static int open(struct inode * inode, st
 	if (!kobj || !attr)
 		goto Done;
 
-	/* Grab the module reference for this attribute if we have one */
-	error = -ENODEV;
-	if (!try_module_get(attr->attr.owner)) 
-		goto Done;
-
 	error = -EACCES;
 	if ((file->f_mode & FMODE_WRITE) && !(attr->write || attr->mmap))
 		goto Error;
@@ -145,7 +140,6 @@ static int open(struct inode * inode, st
     goto Done;
 
  Error:
-	module_put(attr->attr.owner);
  Done:
 	if (error)
 		kobject_put(kobj);
@@ -159,7 +153,6 @@ static int release(struct inode * inode,
 	u8 * buffer = file->private_data;
 
 	kobject_put(kobj);
-	module_put(attr->attr.owner);
 	kfree(buffer);
 	return 0;
 }
Index: linux-cfs-2.6.22.13.q/fs/sysfs/file.c
===================================================================
--- linux-cfs-2.6.22.13.q.orig/fs/sysfs/file.c
+++ linux-cfs-2.6.22.13.q/fs/sysfs/file.c
@@ -257,12 +257,6 @@ static int sysfs_open_file(struct inode 
 	if (!kobj || !attr)
 		goto Einval;
 
-	/* Grab the module reference for this attribute if we have one */
-	if (!try_module_get(attr->owner)) {
-		error = -ENODEV;
-		goto Done;
-	}
-
 	/* if the kobject has no ktype, then we assume that it is a subsystem
 	 * itself, and use ops for it.
 	 */
@@ -332,7 +326,6 @@ static int sysfs_open_file(struct inode 
 	goto Done;
  Eaccess:
 	error = -EACCES;
-	module_put(attr->owner);
  Done:
 	if (error)
 		kobject_put(kobj);
@@ -343,14 +336,12 @@ static int sysfs_release(struct inode * 
 {
 	struct kobject * kobj = to_kobj(filp->f_path.dentry->d_parent);
 	struct attribute * attr = to_attr(filp->f_path.dentry);
-	struct module * owner = attr->owner;
 	struct sysfs_buffer * buffer = filp->private_data;
 
 	if (buffer)
 		remove_from_collection(buffer, inode);
 	kobject_put(kobj);
 	/* After this point, attr should not be accessed. */
-	module_put(owner);
 
 	if (buffer) {
 		if (buffer->page)
@@ -615,7 +606,6 @@ static void sysfs_schedule_callback_work
 
 	(ss->func)(ss->data);
 	kobject_put(ss->kobj);
-	module_put(ss->owner);
 	kfree(ss);
 }
 
@@ -644,11 +634,8 @@ int sysfs_schedule_callback(struct kobje
 {
 	struct sysfs_schedule_callback_struct *ss;
 
-	if (!try_module_get(owner))
-		return -ENODEV;
 	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
 	if (!ss) {
-		module_put(owner);
 		return -ENOMEM;
 	}
 	kobject_get(kobj);
