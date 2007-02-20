Return-Path: <linux-kernel-owner+w=401wt.eu-S1751005AbXBTSfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751005AbXBTSfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 13:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932103AbXBTSfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 13:35:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33451 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbXBTSfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 13:35:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: freezer problems
Date: Tue, 20 Feb 2007 19:29:01 +0100
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <20070220001209.GA15991@tv-sign.ru> <200702200132.12847.rjw@sisk.pl>
In-Reply-To: <200702200132.12847.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702201929.03776.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 February 2007 01:32, Rafael J. Wysocki wrote:
> On Tuesday, 20 February 2007 01:12, Oleg Nesterov wrote:
> > On 02/20, Rafael J. Wysocki wrote:
> > >
> > > On Monday, 19 February 2007 23:41, Oleg Nesterov wrote:
> > > > On 02/19, Rafael J. Wysocki wrote:
> > > > >
> > > > > On Monday, 19 February 2007 21:23, Oleg Nesterov wrote:
> > > > > 
> > > > > > > @@ -199,6 +189,10 @@ static void thaw_tasks(int thaw_user_spa
> > > > > > >
> > > > > > >         do_each_thread(g, p) {
> > > > > > > +               if (freezer_should_skip(p))
> > > > > > > +                       cancel_freezing(p);
> > > > > > > +       } while_each_thread(g, p);
> > > > > > > +       do_each_thread(g, p) {
> > > > > > >                 if (!freezeable(p))
> > > > > > >                         continue;
> > > > > > 
> > > > > > Any reason for 2 separate do_each_thread() loops ?
> > > > > 
> > > > > Yes.  If there is a "freeze" request pending for the vfork parent (TIF_FREEZE
> > > > > set), we have to cancel it before the child is unfrozen, since otherwise the
> > > > > parent may go freezing after we try to reset PF_FROZEN for it.
> > > > 
> > > > I see, thanks... thaw_process() doesn't take TIF_FREEZE into account.
> > > > 
> > > > But doesn't this mean we have a race?
> > > > 
> > > > Suppose that try_to_freeze_tasks() failed. It does cancel_freezing() for each
> > > > process before return, but what if some thread already checked TIF_FREEZE and
> > > > (for simplicity) it is preempted before frozen_process() in refrigerator().
> > > > 
> > > > thaw_tasks() runs, ignores this task (P), returns. P gets CPU, and becomes
> > > > frozen, but nobody will thaw it.
> > > > 
> > > > No?
> > > 
> > > Well, I think this is highly theoretical.  Namely, try_to_freeze_tasks() only
> > > fails after the timeout that's currently set to 20 sec., and it yields the CPU
> > > in each iteration of the main loop.  The task in question would have to refuse
> > > being frozen for 20 sec. and then suddenly decide to freeze itself right before
> > > try_to_freeze_tasks() checks the timeout for the very last time.  Then, it
> > > would have to get preempted at this very moment and stay unfrozen at least
> > > until thaw_tasks() starts running and in fact even longer.
> > 
> > Yes, yes, it is pure theroretical,
> > 
> > > I think we may avoid this by making try_to_freeze_tasks() sleep for some time
> > > after it has reset TIF_FREEZE for all tasks in the error path, if anyone is
> > > ever able to trigger it.
> > 
> > This makes this race  (pure theroretical) ** 2  :)
> > 
> > Still. May be it make sense to introduce cancel_freezing_and_thaw() function
> > (not right now) which stops the task from sleeping in refrigirator reliably.
> 
> Hm.  In the case discussed above we have a task that's right before calling
> frozen_process(), so we can't thaw it, because it's not frozen.  It will be
> frozen just in a while, but try_to_freeze_tasks() and thaw_tasks() have no
> way to check this.
> 
> I think to close this race the refrigerator should check TIF_FREEZE and set
> PF_FROZEN _and_ reset TIF_FREEZE under a lock that would also have to be
> taken by try_to_freeze_tasks() in the beginning of the error path.  This will
> ensure that all tasks either freeze themselves before the error path in
> try_to_freeze_tasks() is executed, or remain unfrozen.
> 
> I'll try to prepare a patch to illustrate this, but right now I'm too tired to
> do it. :-)

Something like this, perhaps:

---
 include/linux/freezer.h |   10 +++-------
 kernel/power/process.c  |   18 ++++++++++++++++--
 2 files changed, 19 insertions(+), 9 deletions(-)

Index: linux-2.6.20-mm2/include/linux/freezer.h
===================================================================
--- linux-2.6.20-mm2.orig/include/linux/freezer.h
+++ linux-2.6.20-mm2/include/linux/freezer.h
@@ -58,17 +58,13 @@ static inline void frozen_process(struct
 	clear_tsk_thread_flag(p, TIF_FREEZE);
 }
 
-extern void refrigerator(void);
+extern int refrigerator(void);
 extern int freeze_processes(void);
 extern void thaw_processes(void);
 
 static inline int try_to_freeze(void)
 {
-	if (freezing(current)) {
-		refrigerator();
-		return 1;
-	} else
-		return 0;
+	return refrigerator();
 }
 
 /*
@@ -104,7 +100,7 @@ static inline void freeze(struct task_st
 static inline int thaw_process(struct task_struct *p) { return 1; }
 static inline void frozen_process(struct task_struct *p) { BUG(); }
 
-static inline void refrigerator(void) {}
+static inline int refrigerator(void) { return 0; }
 static inline int freeze_processes(void) { BUG(); return 0; }
 static inline void thaw_processes(void) {}
 
Index: linux-2.6.20-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/power/process.c
+++ linux-2.6.20-mm2/kernel/power/process.c
@@ -24,6 +24,8 @@
 #define FREEZER_KERNEL_THREADS 0
 #define FREEZER_USER_SPACE 1
 
+spinlock_t refrigerator_lock;
+
 static inline int freezeable(struct task_struct * p)
 {
 	if ((p == current) ||
@@ -34,15 +36,23 @@ static inline int freezeable(struct task
 }
 
 /* Refrigerator is place where frozen processes are stored :-). */
-void refrigerator(void)
+int refrigerator(void)
 {
 	/* Hmm, should we be allowed to suspend when there are realtime
 	   processes around? */
 	long save;
+
+	spin_lock(&refrigerator_lock);
+	if (freezing(current)) {
+		frozen_process(current);
+		spin_unlock(&refrigerator_lock);
+	} else {
+		spin_unlock(&refrigerator_lock);
+		return 0;
+	}
 	save = current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
 
-	frozen_process(current);
 	spin_lock_irq(&current->sighand->siglock);
 	recalc_sigpending(); /* We sent fake signal, clean it up */
 	spin_unlock_irq(&current->sighand->siglock);
@@ -53,6 +63,7 @@ void refrigerator(void)
 	}
 	pr_debug("%s left refrigerator\n", current->comm);
 	current->state = save;
+	return 1;
 }
 
 static inline void freeze_process(struct task_struct *p)
@@ -143,6 +154,7 @@ static unsigned int try_to_freeze_tasks(
 					"kernel threads",
 				TIMEOUT / HZ, todo);
 		read_lock(&tasklist_lock);
+		spin_lock(&refrigerator_lock);
 		do_each_thread(g, p) {
 			if (is_user_space(p) == !freeze_user_space)
 				continue;
@@ -152,6 +164,7 @@ static unsigned int try_to_freeze_tasks(
 
 			cancel_freezing(p);
 		} while_each_thread(g, p);
+		spin_unlock(&refrigerator_lock);
 		read_unlock(&tasklist_lock);
 	}
 
@@ -169,6 +182,7 @@ int freeze_processes(void)
 	unsigned int nr_unfrozen;
 
 	printk("Stopping tasks ... ");
+	spin_lock_init(&refrigerator_lock);
 	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE);
 	if (nr_unfrozen)
 		return nr_unfrozen;
