Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbXHBQx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbXHBQx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbXHBQxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:53:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41618 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbXHBQxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:53:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Thu, 2 Aug 2007 19:02:27 +0200
User-Agent: KMail/1.9.5
Cc: Miklos Szeredi <miklos@szeredi.hu>, jbms@cmu.edu, nigel@nigel.suspend2.net,
       miltonm@bga.com, stern@rowland.harvard.edu, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm> <200707212120.04645.rjw@sisk.pl> <20070801092227.GB4808@ucw.cz>
In-Reply-To: <20070801092227.GB4808@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708021902.28379.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 1 August 2007 11:22, Pavel Machek wrote:
> Hi!
> 
> > > Hmm, wonder why this isn't affecting people with VPNs?  Probably
> > > network mounts over VPN are rare, and ever rarer to have fs activity
> > > on them during suspend.
> > > 
> > > Anyway, I think it's long overdue to stop thinking about how to "fix"
> > > fuse, and concentrate on fixing the underlying problem instead ;)
> > 
> > To conclude this branch of the thread, I have a patch in the works that may
> > help a bit with unfreezable FUSE filesystems and it only affects the freezer.
> > I'll post it when 2.6.23-rc1 is out, because it's on top of some other patches
> > that need to go first.
> 
> I'm interested... which one is that?

Appended, on top of this:
https://lists.linux-foundation.org/pipermail/linux-pm/2007-July/014521.html

Greetings,
Rafael


---
 kernel/power/process.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

Index: linux-2.6.23-rc1/kernel/power/process.c
===================================================================
--- linux-2.6.23-rc1.orig/kernel/power/process.c	2007-07-24 00:14:07.000000000 +0200
+++ linux-2.6.23-rc1/kernel/power/process.c	2007-07-24 00:14:17.000000000 +0200
@@ -30,6 +30,14 @@
  */
 #define MAX_WAITS 5
 
+/*
+ * If the freezing of tasks fails, we attempt to thaw tasks that have already
+ * been frozen to give a chance the other tasks to freeze, in case one or more
+ * of them are blocked by the frozen ones.  If this fails MAX_ATTEMPTS times
+ * in a row, we give up.
+ */
+#define MAX_ATTEMPTS 10
+
 #define FREEZER_KERNEL_THREADS 0
 #define FREEZER_USER_SPACE 1
 
@@ -192,14 +200,21 @@ static void cancel_freezing(struct task_
 static int try_to_freeze_tasks(int freeze_user_space)
 {
 	struct task_struct *g, *p;
-	unsigned int todo, waits;
+	unsigned int todo, waits, attempts;
 	unsigned long ret;
 	struct timeval start, end;
 	s64 elapsed_csecs64;
 	unsigned int elapsed_csecs;
+	char *tick = "-\\|/";
+
+	printk(" ");
+	attempts = 0;
 
 	do_gettimeofday(&start);
 
+ Repeat:
+	printk("\b%c", tick[attempts++ % 4]);
+
 	refrigerator_called = 0;
 	waits = 0;
 	do {
@@ -235,11 +250,43 @@ static int try_to_freeze_tasks(int freez
 		}
 	} while (todo);
 
+	if (todo && attempts <= MAX_ATTEMPTS) {
+		/*
+		 * Some tasks have not been able to freeze.  They might be stuck
+		 * in TASK_UNINTERRUPTIBLE waiting for the frozen tasks.  Try to
+		 * thaw the tasks that have frozen without clearing the freeze
+		 * requests of the remaining tasks and repeat.
+		 */
+		read_lock(&tasklist_lock);
+		do_each_thread(g, p) {
+			if (frozen(p)) {
+				p->flags &= ~PF_FROZEN;
+				wake_up_process(p);
+			}
+		} while_each_thread(g, p);
+		read_unlock(&tasklist_lock);
+
+		ret = wait_event_timeout(refrigerator_waitq,
+						refrigerator_called, TIMEOUT);
+		if (!ret) {
+			/*
+			 * There is a little hope that we will succeed, but at
+			 * least we want to know which tasks have not been
+			 * frozen.  Thus, we are going to repeat once.
+			 */
+			attempts = MAX_ATTEMPTS;
+		}
+
+		goto Repeat;
+	}
+
 	do_gettimeofday(&end);
 	elapsed_csecs64 = timeval_to_ns(&end) - timeval_to_ns(&start);
 	do_div(elapsed_csecs64, NSEC_PER_SEC / 100);
 	elapsed_csecs = elapsed_csecs64;
 
+	printk("\b");
+
 	if (todo) {
 		/* This does not unfreeze processes that are already frozen
 		 * (we have slightly ugly calling convention in that respect,
