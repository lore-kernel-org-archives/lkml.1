Return-Path: <linux-kernel-owner+w=401wt.eu-S1765215AbYCDQK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765215AbYCDQK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760300AbYCDQKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:10:20 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:3415 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713AbYCDQKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:10:19 -0500
Date: Tue, 4 Mar 2008 19:09:40 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-kernel@vger.kernel.org, dhaval@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: sysfs: duplicate filename '74' can not be created
Message-ID: <20080304160940.GC19059@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc'ing /sys/kernel/uids guys]

> Mar  3 13:50:01 helena kernel: sysfs: duplicate filename '74' can not be created
> Mar  3 13:50:01 helena kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> Mar  3 13:50:01 helena kernel: Pid: 21911, comm: sshd Not tainted 2.6.24.3 #1

I see only one suspicious place: KOBJ_ADD is sent even if sysfs file
creation failed and kobject is happily removed. But this almost
certainly separate bug.



You can try this debugging patch. Post several first consecutive messages.
[crosses fingers]

--- a/kernel/user.c
+++ b/kernel/user.c
@@ -179,8 +179,11 @@ static int user_kobject_create(struct user_struct *up)
 		goto done;
 
 	error = sysfs_create_file(kobj, &up->user_attr.attr);
-	if (error)
+	if (error) {
+		printk("%s: %p->uid = %d\n", __func__, up, up->uid);
+		WARN_ON(1);
 		kobject_del(kobj);
+	}
 
 	kobject_uevent(kobj, KOBJ_ADD);
 
@@ -363,6 +366,7 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
 		}
 
 		if (sched_create_user(new) < 0) {
+			WARN_ON(1);
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
@@ -371,6 +375,7 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
 		}
 
 		if (user_kobject_create(new)) {
+			WARN_ON(1);
 			sched_destroy_user(new);
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
@@ -386,6 +391,10 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
+#ifdef CONFIG_FAIR_USER_SCHED
+			printk("%s: %p->uid = %d\n", __func__, up, up->uid);
+			WARN_ON(1);
+#endif
 			/* This case is not possible when CONFIG_FAIR_USER_SCHED
 			 * is defined, since we serialize alloc_uid() using
 			 * uids_mutex. Hence no need to call
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 7af90fc..3479c55 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -32,6 +32,8 @@ static struct user_namespace *clone_user_ns(struct user_namespace *old_ns)
 	struct user_struct *new_user;
 	int n;
 
+	printk("%s: ENTER\n", __func__);
+
 	ns = kmalloc(sizeof(struct user_namespace), GFP_KERNEL);
 	if (!ns)
 		return ERR_PTR(-ENOMEM);

