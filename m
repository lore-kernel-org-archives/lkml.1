Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbZAXNDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbZAXNDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 08:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZAXNDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 08:03:46 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38796 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbZAXNDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 08:03:45 -0500
Date: Sun, 25 Jan 2009 00:03:34 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Greg KH <gregkh@suse.de>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090124130334.GA8031@brong.net>
References: <20081203193901.715896543@mini.kroah.org> <20081203194849.GQ8950@kroah.com> <1232686261.9977.1296303473@webmail.messagingengine.com> <20090123051620.GA8122@suse.de> <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20090123170631.GB11566@suse.de>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 23, 2009 at 09:06:31AM -0800, Greg KH wrote:
> On Fri, Jan 23, 2009 at 08:47:45PM +1100, Bron Gondwana wrote:
> > 2) if we're going to stick with 128, is there any way to query the 
> >    kernel as to how close to the limit it's getting? [...]
> 
> Good idea, we should report this somewhere for the very reasons you
> suggest.  Can you write up a patch to do this?  If not, I'll see what I
> can do.

The attached patches do this - the first bumps the default to 1024, and
the second adds /proc/sys/fs/epoll/limits which contains 4 values.  The
first two are the maximum current value for each field, and the second
two are the values of max_user_instances and max_user_watches again,
similar to the file-max interface.

Any particular reason why the naming is so different?  I would have used
"max" for the current maximum, but the name is already taken by the
limit keys!

By the way, I have approximately no experience with any of this, so
coding standards criticism or "stuff should go elsewhere" suggestions
would be very gratefully received.  This is pretty much the first set
of code I managed that compiled, booted and gave me plausible values.

You can also find the attached in the brong-epoll branch on
http://github.com/brong/linux-2.6/ - I'm working against Linus'
latest.

Thanks,

Bron.

--/04w6evG8XlLl3ft
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-epoll-increase-default-max_user_instances-to-1024.patch"

>From 75d6d0390275db53a7ac59fbcc7b7a74b849ec06 Mon Sep 17 00:00:00 2001
From: Bron Gondwana <brong@fastmail.fm>
Date: Sat, 24 Jan 2009 15:08:40 +1100
Subject: [PATCH] epoll: increase default max_user_instances to 1024

Both postfix and apache use an epoll instance per child, which
leads to significant scalability issues with max_user_instances
set so low.  Bump the default to 1024 so medium sized sites are
not impacted.
---
 fs/eventpoll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ba2f9ec..16eb817 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1366,7 +1366,7 @@ static int __init eventpoll_init(void)
 	struct sysinfo si;
 
 	si_meminfo(&si);
-	max_user_instances = 128;
+	max_user_instances = 1024;
 	max_user_watches = (((si.totalram - si.totalhigh) / 32) << PAGE_SHIFT) /
 		EP_ITEM_COST;
 
-- 
1.5.6.3


--/04w6evG8XlLl3ft
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-epoll-add-proc-sys-fs-epoll-limits-interface.patch"

>From 15633a356bbb32431adcd5788977185cf4f8f5be Mon Sep 17 00:00:00 2001
From: Bron Gondwana <brong@fastmail.fm>
Date: Sat, 24 Jan 2009 23:32:41 +1100
Subject: [PATCH] epoll: add /proc/sys/fs/epoll/limits interface

This is a 4 value vector containing max_user_instances and
max_user_watches constants as well as the current highest value
for any user of these items.
---
 fs/eventpoll.c            |   33 +++++++++++++++++++++++----------
 include/linux/eventpoll.h |   13 +++++++++++++
 kernel/user.c             |   26 ++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 10 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 16eb817..f9cba5b 100644
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
@@ -259,10 +256,18 @@ static struct kmem_cache *pwq_cache __read_mostly;
 
 static int zero;
 
+static int epoll_user_instances(ctl_table *table, int write, struct file *filp,
+                     void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+        user_epoll_maximums(&epoll_limits.num_user_instances, 
+                            &epoll_limits.num_user_watches);
+        return proc_dointvec(table, write, filp, buffer, lenp, ppos);
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
@@ -270,12 +275,20 @@ ctl_table epoll_table[] = {
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
+		.maxlen		= 4*sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &epoll_user_instances,
+		.extra1		= &zero,
+	},
 	{ .ctl_name = 0 }
 };
 #endif /* CONFIG_SYSCTL */
@@ -583,7 +596,7 @@ static int ep_alloc(struct eventpoll **pep)
 	user = get_current_user();
 	error = -EMFILE;
 	if (unlikely(atomic_read(&user->epoll_devs) >=
-			max_user_instances))
+			epoll_limits.max_user_instances))
 		goto free_uid;
 	error = -ENOMEM;
 	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
@@ -762,7 +775,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	struct ep_pqueue epq;
 
 	if (unlikely(atomic_read(&ep->user->epoll_watches) >=
-		     max_user_watches))
+		     epoll_limits.max_user_watches))
 		return -ENOSPC;
 	if (!(epi = kmem_cache_alloc(epi_cache, GFP_KERNEL)))
 		return -ENOMEM;
@@ -1366,8 +1379,8 @@ static int __init eventpoll_init(void)
 	struct sysinfo si;
 
 	si_meminfo(&si);
-	max_user_instances = 1024;
-	max_user_watches = (((si.totalram - si.totalhigh) / 32) << PAGE_SHIFT) /
+	epoll_limits.max_user_instances = 1024;
+	epoll_limits.max_user_watches = (((si.totalram - si.totalhigh) / 32) << PAGE_SHIFT) /
 		EP_ITEM_COST;
 
 	/* Initialize the structure used to perform safe poll wait head wake ups */
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index f1e1d3c..38bec62 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -57,6 +57,16 @@ struct file;
 
 #ifdef CONFIG_EPOLL
 
+/*
+ * Configuration options available inside /proc/sys/fs/epoll/
+ */
+struct epoll_limits_struct {
+        int num_user_instances;          /* read only */
+        int num_user_watches;            /* read only */
+        int max_user_instances;          /* tunable */
+        int max_user_watches;            /* tunable */
+};
+
 /* Used to initialize the epoll bits inside the "struct file" */
 static inline void eventpoll_init_file(struct file *file)
 {
@@ -96,6 +106,9 @@ static inline void eventpoll_release(struct file *file)
 	eventpoll_release_file(file);
 }
 
+extern struct epoll_limits_struct epoll_limits;
+extern void user_epoll_maximums(int *num_devs, int *num_watches);
+
 #else
 
 static inline void eventpoll_init_file(struct file *file) {}
diff --git a/kernel/user.c b/kernel/user.c
index 477b666..4d03a95 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -381,6 +381,32 @@ struct user_struct *find_user(uid_t uid)
 	return ret;
 }
 
+#ifdef CONFIG_EPOLL
+void user_epoll_maximums(int *max_devs, int *max_watches)
+{
+	unsigned long flags;
+	struct user_struct *user;
+	struct hlist_node *h;
+	int n;
+
+	*max_devs = 0;
+	*max_watches = 0;
+
+	spin_lock_irqsave(&uidhash_lock, flags);
+
+	for(n = 0; n < UIDHASH_SZ; ++n) {
+		hlist_for_each_entry(user, h, init_user_ns.uidhash_table + n, uidhash_node) {
+			if (user->epoll_devs.counter > *max_devs) 
+				*max_devs = user->epoll_devs.counter;
+			if (user->epoll_watches.counter > *max_watches) 
+				*max_watches = user->epoll_watches.counter;
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


--/04w6evG8XlLl3ft--
