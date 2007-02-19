Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbXBSV2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbXBSV2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932657AbXBSV2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:28:02 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55514 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932704AbXBSV2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:28:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: freezer problems
Date: Mon, 19 Feb 2007 22:21:27 +0100
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702190019.23215.rjw@sisk.pl> <20070219202349.GA87@tv-sign.ru>
In-Reply-To: <20070219202349.GA87@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702192221.35219.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 February 2007 21:23, Oleg Nesterov wrote:
> On 02/19, Rafael J. Wysocki wrote:
> >
> > On Sunday, 18 February 2007 23:01, Oleg Nesterov wrote:
> > > > --- linux-2.6.20-mm2.orig/include/asm-i386/thread_info.h	2007-02-18 19:49:34.000000000 +0100
> > > > +++ linux-2.6.20-mm2/include/asm-i386/thread_info.h	2007-02-18 19:50:37.000000000 +0100
> > > > @@ -135,6 +135,7 @@ static inline struct thread_info *curren
> > > >  #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
> > > >  #define TIF_FREEZE		19	/* is freezing for suspend */
> > > >  #define TIF_FORCED_TF		20	/* true if TF in eflags artificially */
> > > > +#define TIF_FREEZER_SKIP	21	/* task freezer should not count us */
> > > 
> > > Do we need to put this flag into thread_info? It is always modified by
> > > "current", so it could live in task_struct->flags instead.
> > 
> > I thought we were running low on the task_struct->flags bits. :-)
> 
> Didn't think about that :)

Seriously, I'm not sure.  There are 23 PF_* flags already defined, while
for example on x86_64 there are 17 TIF_* flags defined which is not that
much better.

> > Apart from this, we may need to set it from somewhere else in the future.
> 
> I doubt. In any case, since you provided the nice helpers, it would be very
> easy to convert from thread to process flags. My main concern is that we
> have 24 include/asm-*/thread_info.h files, but only 1 include/linux/sched.h.
> It seems more easy to start with PF_ flags at first.

OK

> > @@ -1393,7 +1394,10 @@ long do_fork(unsigned long clone_flags,
> >
> > 		if (clone_flags & CLONE_VFORK) {
> > +                       freezer_do_not_count(current);
> > 			  wait_for_completion(&vfork);
> > +                       try_to_freeze();
> > +                       freezer_count(current);
> 
> freezer_do_not_count() implies that we must do try_to_freeze() later, I'd
> suggest to shift try_to_freeze() into freezer_count(). Actually, I think that
> freezer_do_not_count/freezer_count should be "(void)", like try_to_freeze().
> IOW,
> 
> 	freezer_do_not_count()
> 	... sleep in 'D' state ...
> 	freezer_count()
> 
> means that current doesn't hold any "important" locks, may be considered as
> frozen, it can do nothing except enter refrigerator if it gets CPU.
> 
> (Please feel free to ignore, this is a matter of taste of course).

Well, if we use a PF_* flag for that, it's also a matter of correctness (only
current should be able to set its flags).

> > @@ -199,6 +189,10 @@ static void thaw_tasks(int thaw_user_spa
> >
> >         read_lock(&tasklist_lock);
> >         do_each_thread(g, p) {
> > +               if (freezer_should_skip(p))
> > +                       cancel_freezing(p);
> > +       } while_each_thread(g, p);
> > +       do_each_thread(g, p) {
> >                 if (!freezeable(p))
> >                         continue;
> 
> Any reason for 2 separate do_each_thread() loops ?

Yes.  If there is a "freeze" request pending for the vfork parent (TIF_FREEZE
set), we have to cancel it before the child is unfrozen, since otherwise the
parent may go freezing after we try to reset PF_FROZEN for it.

> I think this patch is correct, but I still can't convince myself I really
> understand freezer :)

Oh, that takes time.  It took me a year or so. ;-)

Here's the updated patch.  It hasn't been tested yet, but at least it compiles
(on x86_64).

 include/linux/sched.h   |    1 +
 include/linux/freezer.h |   30 ++++++++++++++++++++++++++++--
 kernel/fork.c           |    3 +++
 kernel/power/process.c  |   27 ++++++++++++---------------
 4 files changed, 44 insertions(+), 17 deletions(-)

Index: linux-2.6.20-mm2/include/linux/sched.h
===================================================================
--- linux-2.6.20-mm2.orig/include/linux/sched.h
+++ linux-2.6.20-mm2/include/linux/sched.h
@@ -1189,6 +1189,7 @@ static inline void put_task_struct(struc
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
+#define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
Index: linux-2.6.20-mm2/include/linux/freezer.h
===================================================================
--- linux-2.6.20-mm2.orig/include/linux/freezer.h
+++ linux-2.6.20-mm2/include/linux/freezer.h
@@ -71,7 +71,31 @@ static inline int try_to_freeze(void)
 		return 0;
 }
 
-extern void thaw_some_processes(int all);
+/*
+ * Tell the freezer not to count current task as freezeable
+ */
+static inline void freezer_do_not_count(void)
+{
+	current->flags |= PF_FREEZER_SKIP;
+}
+
+/*
+ * Try to freeze the current task and tell the freezer to count it as freezeable
+ * again
+ */
+static inline void freezer_count(void)
+{
+	try_to_freeze();
+	current->flags &= ~PF_FREEZER_SKIP;
+}
+
+/*
+ * Check if the task should be counted as freezeable by the freezer
+ */
+static inline int freezer_should_skip(struct task_struct *p)
+{
+	return !!(p->flags & PF_FREEZER_SKIP);
+}
 
 #else
 static inline int frozen(struct task_struct *p) { return 0; }
@@ -86,5 +110,7 @@ static inline void thaw_processes(void) 
 
 static inline int try_to_freeze(void) { return 0; }
 
-
+static inline void freezer_do_not_count(void) {}
+static inline void freezer_count(void) {}
+static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 #endif
Index: linux-2.6.20-mm2/kernel/fork.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/fork.c
+++ linux-2.6.20-mm2/kernel/fork.c
@@ -50,6 +50,7 @@
 #include <linux/taskstats_kern.h>
 #include <linux/random.h>
 #include <linux/ptrace.h>
+#include <linux/freezer.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1393,7 +1394,9 @@ long do_fork(unsigned long clone_flags,
 		tracehook_report_clone_complete(clone_flags, nr, p);
 
 		if (clone_flags & CLONE_VFORK) {
+			freezer_do_not_count();
 			wait_for_completion(&vfork);
+			freezer_count();
 			tracehook_report_vfork_done(p, nr);
 		}
 	} else {
Index: linux-2.6.20-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/power/process.c
+++ linux-2.6.20-mm2/kernel/power/process.c
@@ -117,22 +117,12 @@ static unsigned int try_to_freeze_tasks(
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
-			todo++;
+			freeze_process(p);
+			if (!freezer_should_skip(p))
+				todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 		yield();			/* Yield is okay here */
@@ -199,6 +189,13 @@ static void thaw_tasks(int thaw_user_spa
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
+		if (is_user_space(p) == !thaw_user_space)
+			continue;
+
+		if (freezer_should_skip(p))
+			cancel_freezing(p);
+	} while_each_thread(g, p);
+	do_each_thread(g, p) {
 		if (!freezeable(p))
 			continue;
 
