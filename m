Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbZA1Dru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbZA1Dru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZA1DrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:47:13 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58388 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269AbZA1DrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:47:11 -0500
From: Bron Gondwana <brong@fastmail.fm>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>, Davide Libenzi <davidel@xmailserver.org>,
       Bron Gondwana <brong@fastmail.fm>
Subject: [PATCH 3/3] epoll: add /proc/sys/fs/epoll/limits interface
Date: Wed, 28 Jan 2009 14:47:09 +1100
Message-Id: <dee6fa12898a769bb1fbe0efc33bb10f69e8f550.1233114169.git.brong@fastmail.fm>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <13dcb10200fc15315208edf2cff70c5de7fc3954.1233114169.git.brong@fastmail.fm>
References: <20090128033824.GA1662@brong.net>
 <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm>
 <13dcb10200fc15315208edf2cff70c5de7fc3954.1233114169.git.brong@fastmail.fm>
In-Reply-To: <20090128033824.GA1662@brong.net>
References: <20090128033824.GA1662@brong.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a 6 value vector containing max_user_instances and
max_user_watches constants as well as the current userid and
highest value for any user of these items.

Signed-off-by: Bron Gondwana <brong@fastmail.fm>
---
 Documentation/filesystems/proc.txt |   22 +++++++++++++++++++
 fs/eventpoll.c                     |   41 +++++++++++++++++++++++++----------
 include/linux/eventpoll.h          |   16 ++++++++++++++
 kernel/user.c                      |   33 +++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index c4debd3..18a69b5 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -2260,6 +2260,28 @@ low memory, divided for the "watch" cost in bytes.
 
 Setting max_user_watches to '0' makes it unlimited.
 
+limits
+------
+
+The limits file contains information that can be used to judge the
+appropriateness of your max_user_instances and max_user_watches settings.
+
+This file is read-only, and contains 6 integer values:
+
+instances_uid      - the UID of the user with the most instances
+num_user_instances - the number of epoll instances the above UID has
+max_user_instances - the configured maximum (for comparison)
+watches_uid        - the UID of the user with the most watches
+num_user_watches   - the number of epoll watches the above UID has
+max_user_watches   - the configured maximum (for comparison)
+
+By comparing the "num" and "max" values you can see if you are getting
+close to the limit, and then use the UID field to see which user is
+responsible.
+
+(caveat: a daemon like Postfix might create the epoll watch before
+dropping privileges - in this case the watch will be charged to root)
+
 
 ------------------------------------------------------------------------------
 
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index c6d5c1d..dd4351b 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -234,10 +234,7 @@ struct ep_pqueue {
 /*
  * Configuration options available inside /proc/sys/fs/epoll/
  */
-/* Maximum number of epoll devices, per user */
-static int max_user_instances __read_mostly;
-/* Maximum number of epoll watched descriptors, per user */
-static int max_user_watches __read_mostly;
+struct epoll_limits_struct epoll_limits;
 
 /*
  * This mutex is used to serialize ep_free() and eventpoll_release_file().
@@ -259,10 +256,20 @@ static struct kmem_cache *pwq_cache __read_mostly;
 
 static int zero;
 
+static int epoll_counts(ctl_table *table, int write, struct file *filp,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	user_epoll_maximums(&epoll_limits.instances_uid,
+			    &epoll_limits.num_user_instances, 
+			    &epoll_limits.watches_uid,
+			    &epoll_limits.num_user_watches);
+	return proc_dointvec(table, write, filp, buffer, lenp, ppos);
+}
+
 ctl_table epoll_table[] = {
 	{
 		.procname	= "max_user_instances",
-		.data		= &max_user_instances,
+		.data		= &epoll_limits.max_user_instances,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
@@ -270,12 +277,20 @@ ctl_table epoll_table[] = {
 	},
 	{
 		.procname	= "max_user_watches",
-		.data		= &max_user_watches,
+		.data		= &epoll_limits.max_user_watches,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
+	{
+		.procname	= "limits",
+		.data		= &epoll_limits,
+		.maxlen		= 6*sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &epoll_counts,
+		.extra1		= &zero,
+	},
 	{ .ctl_name = 0 }
 };
 #endif /* CONFIG_SYSCTL */
@@ -582,8 +597,9 @@ static int ep_alloc(struct eventpoll **pep)
 
 	user = get_current_user();
 	error = -EMFILE;
-	if (unlikely(max_user_instances &&
-	            (max_user_instances < atomic_read(&user->epoll_devs))))
+	if (unlikely(epoll_limits.max_user_instances &&
+		    (epoll_limits.max_user_instances <
+		     atomic_read(&user->epoll_devs))))
 		goto free_uid;
 	error = -ENOMEM;
 	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
@@ -761,8 +777,9 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	struct epitem *epi;
 	struct ep_pqueue epq;
 
-	if (unlikely(max_user_watches &&
-                    (max_user_watches < atomic_read(&ep->user->epoll_watches))))
+	if (unlikely(epoll_limits.max_user_watches &&
+		    (epoll_limits.max_user_watches < 
+		     atomic_read(&ep->user->epoll_watches))))
 		return -ENOSPC;
 	if (!(epi = kmem_cache_alloc(epi_cache, GFP_KERNEL)))
 		return -ENOMEM;
@@ -1366,8 +1383,8 @@ static int __init eventpoll_init(void)
 	struct sysinfo si;
 
 	si_meminfo(&si);
-	max_user_instances = 1024;
-	max_user_watches = (((si.totalram - si.totalhigh) / 32) << PAGE_SHIFT) /
+	epoll_limits.max_user_instances = 1024;
+	epoll_limits.max_user_watches = (((si.totalram - si.totalhigh) / 32) << PAGE_SHIFT) /
 		EP_ITEM_COST;
 
 	/* Initialize the structure used to perform safe poll wait head wake ups */
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index f1e1d3c..65565ef 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -57,6 +57,18 @@ struct file;
 
 #ifdef CONFIG_EPOLL
 
+/*
+ * Configuration options available inside /proc/sys/fs/epoll/
+ */
+struct epoll_limits_struct {
+	uid_t instances_uid;             /* read only */
+	int num_user_instances;          /* read only */
+	int max_user_instances;          /* tunable */
+	uid_t watches_uid;               /* read only */
+	int num_user_watches;            /* read only */
+	int max_user_watches;            /* tunable */
+};
+
 /* Used to initialize the epoll bits inside the "struct file" */
 static inline void eventpoll_init_file(struct file *file)
 {
@@ -96,6 +108,10 @@ static inline void eventpoll_release(struct file *file)
 	eventpoll_release_file(file);
 }
 
+extern struct epoll_limits_struct epoll_limits;
+extern void user_epoll_maximums(uid_t *user_devs,    int *num_devs, 
+                                uid_t *user_watches, int *num_watches);
+
 #else
 
 static inline void eventpoll_init_file(struct file *file) {}
diff --git a/kernel/user.c b/kernel/user.c
index 477b666..08e2b4f 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -381,6 +381,39 @@ struct user_struct *find_user(uid_t uid)
 	return ret;
 }
 
+#ifdef CONFIG_EPOLL
+void user_epoll_maximums(uid_t *user_devs,    int *max_devs, 
+			 uid_t *user_watches, int *max_watches)
+{
+	unsigned long flags;
+	struct user_struct *user;
+	struct hlist_node *h;
+	int n;
+
+	*max_devs = 0;
+	*user_devs = root_user.uid;
+	*max_watches = 0;
+	*user_watches = root_user.uid;
+
+	spin_lock_irqsave(&uidhash_lock, flags);
+
+	for(n = 0; n < UIDHASH_SZ; ++n) {
+		hlist_for_each_entry(user, h, init_user_ns.uidhash_table + n, uidhash_node) {
+			if (user->epoll_devs.counter > *max_devs) {
+				*max_devs = user->epoll_devs.counter;
+				*user_devs = user->uid;
+			}
+			if (user->epoll_watches.counter > *max_watches) {
+				*max_watches = user->epoll_watches.counter;
+				*user_watches = user->uid;
+			}
+		}
+	}
+
+	spin_unlock_irqrestore(&uidhash_lock, flags);
+}
+#endif /* CONFIG_EPOLL */
+
 void free_uid(struct user_struct *up)
 {
 	unsigned long flags;
-- 
1.5.6.3

