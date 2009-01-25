Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbZAYLBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbZAYLBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 06:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbZAYLBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 06:01:31 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37549 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbZAYLBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 06:01:30 -0500
Date: Sun, 25 Jan 2009 22:01:27 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090125110126.GA11598@brong.net>
References: <20081203193901.715896543@mini.kroah.org> <20081203194849.GQ8950@kroah.com> <1232686261.9977.1296303473@webmail.messagingengine.com> <20090123051620.GA8122@suse.de> <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20090124130334.GA8031@brong.net>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 25, 2009 at 12:03:34AM +1100, Bron Gondwana wrote:
> The attached patches do this - the first bumps the default to 1024, and
> the second adds /proc/sys/fs/epoll/limits which contains 4 values.  The
> first two are the maximum current value for each field, and the second
> two are the values of max_user_instances and max_user_watches again,
> similar to the file-max interface.

And this third one (on top of the other two) adds the UIDs of the most
heavily using users to the "limits" file, to help you track them down.

Bron ( pretty sure there's tabdamage and crap in there, but I'd like
       some feedback that I'm otherwise on the right track before I
       polish these up and Signed-off-by: them )


--ReaqsoxgOBHFXBhH
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0003-epoll-also-show-owner-uids-in-epoll-limits-output.patch"

>From 5295e0fb786bb20411d14a88fe0195672f1e0dd6 Mon Sep 17 00:00:00 2001
From: Bron Gondwana <brong@fastmail.fm>
Date: Sun, 25 Jan 2009 21:43:36 +1100
Subject: [PATCH] epoll: also show owner uids in epoll/limits output

So - the data is in epoll/limits is probably more useful if the uid
of each of the maximum counts is available for easy tracking down.
This patch adds it.
---
 fs/eventpoll.c            |    6 ++++--
 include/linux/eventpoll.h |    5 ++++-
 kernel/user.c             |   13 ++++++++++---
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f9cba5b..2113795 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -259,7 +259,9 @@ static int zero;
 static int epoll_user_instances(ctl_table *table, int write, struct file *filp,
                      void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-        user_epoll_maximums(&epoll_limits.num_user_instances, 
+        user_epoll_maximums(&epoll_limits.instances_uid,
+                            &epoll_limits.num_user_instances, 
+                            &epoll_limits.watches_uid,
                             &epoll_limits.num_user_watches);
         return proc_dointvec(table, write, filp, buffer, lenp, ppos);
 }
@@ -284,7 +286,7 @@ ctl_table epoll_table[] = {
 	{
 		.procname	= "limits",
 		.data		= &epoll_limits,
-		.maxlen		= 4*sizeof(int),
+		.maxlen		= 6*sizeof(int),
 		.mode		= 0444,
 		.proc_handler	= &epoll_user_instances,
 		.extra1		= &zero,
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 38bec62..8258d0a 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -61,7 +61,9 @@ struct file;
  * Configuration options available inside /proc/sys/fs/epoll/
  */
 struct epoll_limits_struct {
+	uid_t instances_uid;             /* read only */
         int num_user_instances;          /* read only */
+	uid_t watches_uid;               /* read only */
         int num_user_watches;            /* read only */
         int max_user_instances;          /* tunable */
         int max_user_watches;            /* tunable */
@@ -107,7 +109,8 @@ static inline void eventpoll_release(struct file *file)
 }
 
 extern struct epoll_limits_struct epoll_limits;
-extern void user_epoll_maximums(int *num_devs, int *num_watches);
+extern void user_epoll_maximums(uid_t *user_devs,    int *num_devs, 
+                                uid_t *user_watches, int *num_watches);
 
 #else
 
diff --git a/kernel/user.c b/kernel/user.c
index 4d03a95..ef8769a 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -382,7 +382,8 @@ struct user_struct *find_user(uid_t uid)
 }
 
 #ifdef CONFIG_EPOLL
-void user_epoll_maximums(int *max_devs, int *max_watches)
+void user_epoll_maximums(uid_t *user_devs,    int *max_devs, 
+                         uid_t *user_watches, int *max_watches)
 {
 	unsigned long flags;
 	struct user_struct *user;
@@ -390,16 +391,22 @@ void user_epoll_maximums(int *max_devs, int *max_watches)
 	int n;
 
 	*max_devs = 0;
+	*user_devs = root_user.uid;
 	*max_watches = 0;
+	*user_watches = root_user.uid;
 
 	spin_lock_irqsave(&uidhash_lock, flags);
 
 	for(n = 0; n < UIDHASH_SZ; ++n) {
 		hlist_for_each_entry(user, h, init_user_ns.uidhash_table + n, uidhash_node) {
-			if (user->epoll_devs.counter > *max_devs) 
+			if (user->epoll_devs.counter > *max_devs) {
 				*max_devs = user->epoll_devs.counter;
-			if (user->epoll_watches.counter > *max_watches) 
+				*user_devs = user->uid;
+			}
+			if (user->epoll_watches.counter > *max_watches) {
 				*max_watches = user->epoll_watches.counter;
+				*user_watches = user->uid;
+			}
 		}
 	}
 
-- 
1.5.6.3


--ReaqsoxgOBHFXBhH--
