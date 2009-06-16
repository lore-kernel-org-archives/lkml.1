Return-Path: <linux-kernel-owner+w=401wt.eu-S935709AbZFPFvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935709AbZFPFvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZFPFuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:50:51 -0400
Received: from kroah.org ([198.145.64.141]:48287 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbZFPFuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:50:51 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/64] sched: delayed cleanup of user_struct
Date: Mon, 15 Jun 2009 22:45:51 -0700
Message-Id: <1245131213-24168-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

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
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sched.h |    2 +-
 kernel/user.c         |   67 ++++++++++++++++++++++++++++--------------------
 2 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c900aa5..7531b1c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -674,7 +674,7 @@ struct user_struct {
 	struct task_group *tg;
 #ifdef CONFIG_SYSFS
 	struct kobject kobj;
-	struct work_struct work;
+	struct delayed_work work;
 #endif
 #endif
 
diff --git a/kernel/user.c b/kernel/user.c
index 850e0ba..2c000e7 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -75,21 +75,6 @@ static void uid_hash_remove(struct user_struct *up)
 	put_user_ns(up->user_ns);
 }
 
-static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
-{
-	struct user_struct *user;
-	struct hlist_node *h;
-
-	hlist_for_each_entry(user, h, hashent, uidhash_node) {
-		if (user->uid == uid) {
-			atomic_inc(&user->__count);
-			return user;
-		}
-	}
-
-	return NULL;
-}
-
 #ifdef CONFIG_USER_SCHED
 
 static void sched_destroy_user(struct user_struct *up)
@@ -119,6 +104,23 @@ static int sched_create_user(struct user_struct *up) { return 0; }
 
 #if defined(CONFIG_USER_SCHED) && defined(CONFIG_SYSFS)
 
+static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
+{
+	struct user_struct *user;
+	struct hlist_node *h;
+
+	hlist_for_each_entry(user, h, hashent, uidhash_node) {
+		if (user->uid == uid) {
+			/* possibly resurrect an "almost deleted" object */
+			if (atomic_inc_return(&user->__count) == 1)
+				cancel_delayed_work(&user->work);
+			return user;
+		}
+	}
+
+	return NULL;
+}
+
 static struct kset *uids_kset; /* represents the /sys/kernel/uids/ directory */
 static DEFINE_MUTEX(uids_mutex);
 
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
 
@@ -297,15 +299,12 @@ static void cleanup_user_struct(struct work_struct *w)
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
@@ -331,16 +330,28 @@ done:
  */
 static void free_user(struct user_struct *up, unsigned long flags)
 {
-	/* restore back the count */
-	atomic_inc(&up->__count);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
-
-	INIT_WORK(&up->work, cleanup_user_struct);
-	schedule_work(&up->work);
+	INIT_DELAYED_WORK(&up->work, cleanup_user_struct);
+	schedule_delayed_work(&up->work, msecs_to_jiffies(1000));
 }
 
 #else	/* CONFIG_USER_SCHED && CONFIG_SYSFS */
 
+static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
+{
+	struct user_struct *user;
+	struct hlist_node *h;
+
+	hlist_for_each_entry(user, h, hashent, uidhash_node) {
+		if (user->uid == uid) {
+			atomic_inc(&user->__count);
+			return user;
+		}
+	}
+
+	return NULL;
+}
+
 int uids_sysfs_init(void) { return 0; }
 static inline int uids_user_create(struct user_struct *up) { return 0; }
 static inline void uids_mutex_lock(void) { }
-- 
1.6.3.2

