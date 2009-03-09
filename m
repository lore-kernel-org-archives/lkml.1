Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbZCISkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbZCISkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZCISkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:40:10 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:63614 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZCISkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:40:08 -0400
Subject: sched: delayed cleanup of user_struct
From: Kay Sievers <kay.sievers@vrfy.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 19:37:17 +0100
Message-Id: <1236623837.2791.1.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: sched: delayed cleanup of user_struct

During bootup performance tracing we see repeated occurrences of
/sys/kernel/uid/* events for the same uid, leading to a,
in this case, rather pointless userspace processing for the
same uid over and over.

This is usally caused by tools which change their uid to "nobody",
to run without privileges to read data supplied by untrusted users.

This change delays the execution of the (already existing) scheduled
work, to cleanup the uid after 0.5 seconds, so the allocated and announced
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

Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 include/linux/sched.h |    2 +-
 kernel/user.c         |   28 +++++++++++++---------------
 2 files changed, 14 insertions(+), 16 deletions(-)

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
@@ -75,6 +75,7 @@ static void uid_hash_remove(struct user_
 	put_user_ns(up->user_ns);
 }
 
+/* uidhash_lock must be held */
 static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
 {
 	struct user_struct *user;
@@ -82,7 +83,9 @@ static struct user_struct *uid_hash_find
 
 	hlist_for_each_entry(user, h, hashent, uidhash_node) {
 		if (user->uid == uid) {
-			atomic_inc(&user->__count);
+			/* possibly resurrect an "almost deleted" object */
+			if (atomic_inc_return(&user->__count) == 1)
+				cancel_delayed_work(&user->work);
 			return user;
 		}
 	}
@@ -283,12 +286,12 @@ int __init uids_sysfs_init(void)
 	return uids_user_create(&root_user);
 }
 
-/* work function to remove sysfs directory for a user and free up
+/* delayed work function to remove the user and free up
  * corresponding structures.
  */
-static void remove_user_sysfs_dir(struct work_struct *w)
+static void remove_user_delayed(struct work_struct *w)
 {
-	struct user_struct *up = container_of(w, struct user_struct, work);
+	struct user_struct *up = container_of(w, struct user_struct, work.work);
 	unsigned long flags;
 	int remove_user = 0;
 
@@ -299,15 +302,12 @@ static void remove_user_sysfs_dir(struct
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
@@ -331,12 +331,8 @@ done:
  */
 static void free_user(struct user_struct *up, unsigned long flags)
 {
-	/* restore back the count */
-	atomic_inc(&up->__count);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
-
-	INIT_WORK(&up->work, remove_user_sysfs_dir);
-	schedule_work(&up->work);
+	schedule_delayed_work(&up->work, msecs_to_jiffies(500));
 }
 
 #else	/* CONFIG_USER_SCHED && CONFIG_SYSFS */
@@ -442,6 +438,8 @@ struct user_struct *alloc_uid(struct use
 		if (uids_user_create(new))
 			goto out_destoy_sched;
 
+		INIT_DELAYED_WORK(&new->work, remove_user_delayed);
+
 		/*
 		 * Before adding this, check whether we raced
 		 * on adding the same user already..


