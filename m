Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbZCSRcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbZCSRcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbZCSRbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:31:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:48910 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbZCSRbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:31:52 -0400
Subject: Re: sched: delayed cleanup of user_struct
From: Kay Sievers <kay.sievers@vrfy.org>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090319093446.GA6372@linux.vnet.ibm.com>
References: <1236623837.2791.1.camel@nga>
	 <20090309184940.GA9507@linux.vnet.ibm.com> <1236696478.2823.2.camel@nga>
	 <20090319093446.GA6372@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 18:28:46 +0100
Message-Id: <1237483726.5227.3.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 15:04 +0530, Dhaval Giani wrote:
> On Tue, Mar 10, 2009 at 03:47:58PM +0100, Kay Sievers wrote:
> > On Tue, 2009-03-10 at 00:19 +0530, Dhaval Giani wrote:
> > > On Mon, Mar 09, 2009 at 07:37:17PM +0100, Kay Sievers wrote:
> > 
> > > > This change delays the execution of the (already existing) scheduled
> > > > work, to cleanup the uid after 0.5 seconds, so the allocated and announced
> > > > uid can possibly be re-used by another process.
> > 
> > > makes sense. I do have a patch though which changes some of the cleanup
> > > code (fixing a memory leak) in -mm. These two patches will conflict.
> > 
> > Ah, I see. Updated. Could you give this a try on top of your changes?

> Looks good to me!
> Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Added. Thanks.
 
> > +/* uidhash_lock must be held */
> 
> There is already a comment mentioning this before the set of routines
> starts.

Ah, good. Removed.

Greg,
can you pick this up?

Thanks,
Kay



From: Kay Sievers <kay.sievers@vrfy.org>
Subject: sched: delayed cleanup of user_struct

During bootup performance tracing we see repeated occurrences of
/sys/kernel/uid/* events for the same uid, leading to a,
in this case, rather pointless userspace processing for the
same uid over and over.

This is usually caused by tools which change their uid to "nobody",
to run without privileges to read data supplied by untrusted users.

This change delays the execution of the (already existing) scheduled
work, to cleanup the uid after one second, so the allocated and announced
uid can possibly be re-used by another process.

This is the current behavior, where almost every invocation of a
binary, which changes the uid, creates two events:
  $ read START < /sys/kernel/uevent_seqnum; \
  for i in `seq 100`; do su --shell=/bin/true bin; done; \
  read END < /sys/kernel/uevent_seqnum; \
  echo $(($END - $START))
  178

With the delayed cleanup, we get only two events, and userspace finishes
a bit faster too:
  $ read START < /sys/kernel/uevent_seqnum; \
  for i in `seq 100`; do su --shell=/bin/true bin; done; \
  read END < /sys/kernel/uevent_seqnum; \
  echo $(($END - $START))
  1

Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 include/linux/sched.h |    2 +-
 kernel/user.c         |   25 +++++++++++--------------
 2 files changed, 12 insertions(+), 15 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -670,7 +670,7 @@ struct user_struct {
 	struct task_group *tg;
 #ifdef CONFIG_SYSFS
 	struct kobject kobj;
-	struct work_struct work;
+	struct delayed_work work;
 #endif
 #endif
 };
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -82,7 +82,9 @@ static struct user_struct *uid_hash_find
 
 	hlist_for_each_entry(user, h, hashent, uidhash_node) {
 		if (user->uid == uid) {
-			atomic_inc(&user->__count);
+			/* possibly resurrect an "almost deleted" object */
+			if (atomic_inc_return(&user->__count) == 1)
+				cancel_delayed_work(&user->work);
 			return user;
 		}
 	}
@@ -283,12 +285,12 @@ int __init uids_sysfs_init(void)
 	return uids_user_create(&root_user);
 }
 
-/* work function to remove sysfs directory for a user and free up
+/* delayed work function to remove sysfs directory for a user and free up
  * corresponding structures.
  */
 static void cleanup_user_struct(struct work_struct *w)
 {
-	struct user_struct *up = container_of(w, struct user_struct, work);
+	struct user_struct *up = container_of(w, struct user_struct, work.work);
 	unsigned long flags;
 	int remove_user = 0;
 
@@ -297,15 +299,12 @@ static void cleanup_user_struct(struct w
 	 */
 	uids_mutex_lock();
 
-	local_irq_save(flags);
-
-	if (atomic_dec_and_lock(&up->__count, &uidhash_lock)) {
+	spin_lock_irqsave(&uidhash_lock, flags);
+	if (atomic_read(&up->__count) == 0) {
 		uid_hash_remove(up);
 		remove_user = 1;
-		spin_unlock_irqrestore(&uidhash_lock, flags);
-	} else {
-		local_irq_restore(flags);
 	}
+	spin_unlock_irqrestore(&uidhash_lock, flags);
 
 	if (!remove_user)
 		goto done;
@@ -331,12 +330,8 @@ done:
  */
 static void free_user(struct user_struct *up, unsigned long flags)
 {
-	/* restore back the count */
-	atomic_inc(&up->__count);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
-
-	INIT_WORK(&up->work, cleanup_user_struct);
-	schedule_work(&up->work);
+	schedule_delayed_work(&up->work, msecs_to_jiffies(1000));
 }
 
 #else	/* CONFIG_USER_SCHED && CONFIG_SYSFS */
@@ -442,6 +437,8 @@ struct user_struct *alloc_uid(struct use
 		if (uids_user_create(new))
 			goto out_destoy_sched;
 
+		INIT_DELAYED_WORK(&new->work, cleanup_user_struct);
+
 		/*
 		 * Before adding this, check whether we raced
 		 * on adding the same user already..



