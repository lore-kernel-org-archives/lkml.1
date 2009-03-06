Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZCFF1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZCFF1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 00:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZCFFYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 00:24:07 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:47809 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZCFFYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 00:24:03 -0500
Date: Fri, 6 Mar 2009 10:53:19 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>, serue@us.ibm.com,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, dhowells@redhat.com
Subject: [PATCH] Fix a memory leak when freeing up non init usernamespaces
	users
Message-ID: <20090306052319.GD4809@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix a memory leak when freeing up non init usernamespaces users

We were returning early in the sysfs directory cleanup function
if the user belonged to a non init usernamespace. Due to this a lot
of the cleanup was not done and we were left with a leak. Fix the leak.

Reported-by: Serge Hallyn <serue@linux.vnet.ibm.com>
Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Tested-by: Serge Hallyn <serue@us.ibm.com>
---
 kernel/user.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/user.c
===================================================================
--- linux-2.6.orig/kernel/user.c
+++ linux-2.6/kernel/user.c
@@ -286,14 +286,12 @@ int __init uids_sysfs_init(void)
 /* work function to remove sysfs directory for a user and free up
  * corresponding structures.
  */
-static void remove_user_sysfs_dir(struct work_struct *w)
+static void cleanup_user_struct(struct work_struct *w)
 {
 	struct user_struct *up = container_of(w, struct user_struct, work);
 	unsigned long flags;
 	int remove_user = 0;
 
-	if (up->user_ns != &init_user_ns)
-		return;
 	/* Make uid_hash_remove() + sysfs_remove_file() + kobject_del()
 	 * atomic.
 	 */
@@ -312,9 +310,11 @@ static void remove_user_sysfs_dir(struct
 	if (!remove_user)
 		goto done;
 
-	kobject_uevent(&up->kobj, KOBJ_REMOVE);
-	kobject_del(&up->kobj);
-	kobject_put(&up->kobj);
+	if (up->user_ns == &init_user_ns) {
+		kobject_uevent(&up->kobj, KOBJ_REMOVE);
+		kobject_del(&up->kobj);
+		kobject_put(&up->kobj);
+	}
 
 	sched_destroy_user(up);
 	key_put(up->uid_keyring);
@@ -335,7 +335,7 @@ static void free_user(struct user_struct
 	atomic_inc(&up->__count);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
 
-	INIT_WORK(&up->work, remove_user_sysfs_dir);
+	INIT_WORK(&up->work, cleanup_user_struct);
 	schedule_work(&up->work);
 }
 
-- 
regards,
Dhaval
