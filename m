Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbXCKRqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbXCKRqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 13:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933885AbXCKRqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 13:46:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40446 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933883AbXCKRqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 13:46:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Date: Sun, 11 Mar 2007 18:49:08 +0100
User-Agent: KMail/1.9.5
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Anton Blanchard <anton@samba.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702260800.49603.rjw@sisk.pl> <20070303005843.GG2373@linux.vnet.ibm.com> <20070303173240.GA249@tv-sign.ru>
In-Reply-To: <20070303173240.GA249@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703111849.09966.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 3 March 2007 18:32, Oleg Nesterov wrote:
> On 03/02, Paul E. McKenney wrote:
> >
> > On Sat, Mar 03, 2007 at 02:33:37AM +0300, Oleg Nesterov wrote:
> > > On 03/02, Paul E. McKenney wrote:
> > > >
> > > > One way to embed try_to_freeze() into kthread_should_stop() might be
> > > > as follows:
> > > > 
> > > > 	int kthread_should_stop(void)
> > > > 	{
> > > > 		if (kthread_stop_info.k == current)
> > > > 			return 1;
> > > > 		try_to_freeze();
> > > > 		return 0;
> > > > 	}
> > > 
> > > I think this is dangerous. For example, worker_thread() will probably
> > > need some special actions after return from refrigerator. Also, a kernel
> > > thread may check kthread_should_stop() in the place where try_to_freeze()
> > > is not safe.
> > > 
> > > Perhaps we should introduce a new helper which does this.
> > 
> > Good point -- the return value from try_to_freeze() is lost if one uses
> > the above approach.  About one third of the calls to try_to_freeze()
> > in 2.6.20 pay attention to the return value.
> > 
> > One approach would be to have a kthread_should_stop_nofreeze() for those
> > cases, and let the default be to try to freeze.
> 
> I personally think we should do the opposite, add kthread_should_stop_check_freeze()
> or something. kthread_should_stop() is like signal_pending(), we can use
> it under spin_lock (and it is probably used this way by some out-of-tree
> driver). The new helper is obviously "might_sleep()".

Something like this, perhaps:

 include/linux/kthread.h |    1 +
 kernel/kthread.c        |   16 ++++++++++++++++
 kernel/rcutorture.c     |    5 ++---
 3 files changed, 19 insertions(+), 3 deletions(-)

Index: linux-2.6.21-rc3-mm2/kernel/kthread.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/kernel/kthread.c	2007-03-08 21:58:48.000000000 +0100
+++ linux-2.6.21-rc3-mm2/kernel/kthread.c	2007-03-11 18:32:59.000000000 +0100
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 #include <asm/semaphore.h>
 
 /*
@@ -60,6 +61,21 @@ int kthread_should_stop(void)
 }
 EXPORT_SYMBOL(kthread_should_stop);
 
+/**
+ * kthread_should_stop_check_freeze - check if the thread should return now and
+ * if not, check if there is a freezing request pending for it.
+ */
+int kthread_should_stop_check_freeze(void)
+{
+	might_sleep();
+	if (kthread_stop_info.k == current)
+		return 1;
+
+	try_to_freeze();
+	return 0;
+}
+EXPORT_SYMBOL(kthread_should_stop_check_freeze);
+
 static void kthread_exit_files(void)
 {
 	struct fs_struct *fs;
Index: linux-2.6.21-rc3-mm2/include/linux/kthread.h
===================================================================
--- linux-2.6.21-rc3-mm2.orig/include/linux/kthread.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc3-mm2/include/linux/kthread.h	2007-03-11 18:37:10.000000000 +0100
@@ -29,5 +29,6 @@ struct task_struct *kthread_create(int (
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 int kthread_stop(struct task_struct *k);
 int kthread_should_stop(void);
+int kthread_should_stop_check_freeze(void);
 
 #endif /* _LINUX_KTHREAD_H */
Index: linux-2.6.21-rc3-mm2/kernel/rcutorture.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/kernel/rcutorture.c	2007-03-11 11:39:06.000000000 +0100
+++ linux-2.6.21-rc3-mm2/kernel/rcutorture.c	2007-03-11 18:45:00.000000000 +0100
@@ -540,10 +540,9 @@ rcu_torture_writer(void *arg)
 		}
 		rcu_torture_current_version++;
 		oldbatch = cur_ops->completed();
-		try_to_freeze();
-	} while (!kthread_should_stop() && !fullstop);
+	} while (!kthread_should_stop_check_freeze() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
-	while (!kthread_should_stop())
+	while (!kthread_should_stop_check_freeze())
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
