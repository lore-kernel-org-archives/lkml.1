Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbXBYTYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbXBYTYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbXBYTYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:24:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56461 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbXBYTYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:24:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Aneesh Kumar" <aneesh.kumar@gmail.com>
Subject: Re: [RFC][PATCH 4/7] Freezer: Fix vfork problem
Date: Sun, 25 Feb 2007 20:17:20 +0100
User-Agent: KMail/1.9.5
Cc: "Pavel Machek" <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org,
       mingo@elte.hu, vatsa@in.ibm.com, dipankar@in.ibm.com,
       venkatesh.pallipadi@intel.com, "Oleg Nesterov" <oleg@tv-sign.ru>
References: <200702231116.23607.rjw@sisk.pl> <cc723f590702250728ra1bbb10l190ab73ce3d6fc77@mail.gmail.com> <cc723f590702250740t1fec263cq5378027527c3d9f8@mail.gmail.com>
In-Reply-To: <cc723f590702250740t1fec263cq5378027527c3d9f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702252017.22077.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 February 2007 16:40, Aneesh Kumar wrote:
> On 2/25/07, Aneesh Kumar <aneesh.kumar@gmail.com> wrote:
> > On 2/25/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Sunday, 25 February 2007 15:33, Aneesh Kumar wrote:
> > > > On 2/25/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
[--snip--]
> 
> Thinking about this  i guess we have a problem with the above approach
> i outlined. if we have one task that is waiting on the event and more
> than one that can generate the event then the above logic would not
> work. Also with cases other than vfork; logic of tracking the waiting
> task gets complex. I guess what we have right now is better.

I assume by "righ now" you mean the latest version of my patch. ;-)

Still, having pondered the Pavel's suggestion for a while I think it's doable
without the addtitional process flag.  Patch below.

Greetings,
Rafael

 include/linux/completion.h |   13 ++++++++++++-
 kernel/fork.c              |    2 +-
 kernel/power/process.c     |   20 ++++++--------------
 kernel/sched.c             |    8 ++++++--
 4 files changed, 25 insertions(+), 18 deletions(-)

Index: linux-2.6.20-mm2/include/linux/completion.h
===================================================================
--- linux-2.6.20-mm2.orig/include/linux/completion.h	2007-02-25 14:02:54.000000000 +0100
+++ linux-2.6.20-mm2/include/linux/completion.h	2007-02-25 20:20:35.000000000 +0100
@@ -42,7 +42,18 @@ static inline void init_completion(struc
 	init_waitqueue_head(&x->wait);
 }
 
-extern void FASTCALL(wait_for_completion(struct completion *));
+extern void FASTCALL(__wait_for_completion(struct completion *, int));
+
+static inline void wait_for_completion(struct completion *x)
+{
+	__wait_for_completion(x, 0);
+}
+
+static inline void wait_for_completion_freezable(struct completion *x)
+{
+	__wait_for_completion(x, 1);
+}
+
 extern int FASTCALL(wait_for_completion_interruptible(struct completion *x));
 extern unsigned long FASTCALL(wait_for_completion_timeout(struct completion *x,
 						   unsigned long timeout));
Index: linux-2.6.20-mm2/kernel/sched.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/sched.c	2007-02-25 14:02:54.000000000 +0100
+++ linux-2.6.20-mm2/kernel/sched.c	2007-02-25 20:20:35.000000000 +0100
@@ -3803,7 +3803,8 @@ void fastcall complete_all(struct comple
 }
 EXPORT_SYMBOL(complete_all);
 
-void fastcall __sched wait_for_completion(struct completion *x)
+void fastcall __sched
+__wait_for_completion(struct completion *x, int freezable)
 {
 	might_sleep();
 
@@ -3817,6 +3818,9 @@ void fastcall __sched wait_for_completio
 			__set_current_state(TASK_UNINTERRUPTIBLE);
 			spin_unlock_irq(&x->wait.lock);
 			schedule();
+			if (freezable)
+				try_to_freeze();
+
 			spin_lock_irq(&x->wait.lock);
 		} while (!x->done);
 		__remove_wait_queue(&x->wait, &wait);
@@ -3824,7 +3828,7 @@ void fastcall __sched wait_for_completio
 	x->done--;
 	spin_unlock_irq(&x->wait.lock);
 }
-EXPORT_SYMBOL(wait_for_completion);
+EXPORT_SYMBOL(__wait_for_completion);
 
 unsigned long fastcall __sched
 wait_for_completion_timeout(struct completion *x, unsigned long timeout)
Index: linux-2.6.20-mm2/kernel/fork.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/fork.c	2007-02-25 20:17:25.000000000 +0100
+++ linux-2.6.20-mm2/kernel/fork.c	2007-02-25 20:20:35.000000000 +0100
@@ -1393,7 +1393,7 @@ long do_fork(unsigned long clone_flags,
 		tracehook_report_clone_complete(clone_flags, nr, p);
 
 		if (clone_flags & CLONE_VFORK) {
-			wait_for_completion(&vfork);
+			wait_for_completion_freezable(&vfork);
 			tracehook_report_vfork_done(p, nr);
 		}
 	} else {
Index: linux-2.6.20-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/power/process.c	2007-02-25 20:17:25.000000000 +0100
+++ linux-2.6.20-mm2/kernel/power/process.c	2007-02-25 20:20:35.000000000 +0100
@@ -48,6 +48,9 @@ void refrigerator(void)
 		task_unlock(current);
 		return;
 	}
+	if (current->vfork_done)
+		wake_up_process(current->parent);
+
 	save = current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
 
@@ -127,21 +130,10 @@ static unsigned int try_to_freeze_tasks(
 				cancel_freezing(p);
 				continue;
 			}
-			if (is_user_space(p)) {
-				if (!freeze_user_space)
-					continue;
-
-				/* Freeze the task unless there is a vfork
-				 * completion pending
-				 */
-				if (!p->vfork_done)
-					freeze_process(p);
-			} else {
-				if (freeze_user_space)
-					continue;
+			if (is_user_space(p) == !freeze_user_space)
+				continue;
 
-				freeze_process(p);
-			}
+			freeze_process(p);
 			todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
