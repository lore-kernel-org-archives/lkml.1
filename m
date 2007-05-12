Return-Path: <linux-kernel-owner+w=401wt.eu-S933997AbXELAMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbXELAMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbXELALx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:11:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32984 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048AbXELALw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:11:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Date: Sat, 12 May 2007 02:16:36 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl> <200705120122.07177.rjw@sisk.pl> <20070511162530.2f98bda2.akpm@linux-foundation.org>
In-Reply-To: <20070511162530.2f98bda2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705120216.37814.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 May 2007 01:25, Andrew Morton wrote:
> On Sat, 12 May 2007 01:22:06 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Saturday, 12 May 2007 00:56, Linus Torvalds wrote:
> > > 
> > > On Fri, 11 May 2007, Rafael J. Wysocki wrote:
> > > > 
> > > > For user space processes this condition is always true.
> > > > 
> > > > For kernel threads:
> > > > (1) the change of tsk->mm from NULL to a nonzero value is only made in
> > > > fs/aio.c:use_mm() along with the setting of PF_BORROWED_MM under
> > > > the task_lock(),
> > > > (2) the change of tsk->mm from a nonzero value to NULL is only made in
> > > > fs/aio.c:unuse_mm() along with the resetting of PF_BORROWED_MM
> > > > under the task_lock().
> > > > Therefore, by taking the task_lock() here we make sure that the condition
> > > > is alyways false when we check it for kernel threads.
> > > 
> > > Why *test* it then and return anything?
> > > 
> > > Why not just doa "task_lock(p); task_unlock(p);" with no return value? 
> > > 
> > > As it is, it sounds like either the code is buggy, or it's pointless.
> > 
> > I'm not sure what you mean.
> > 
> > We use this function (ie. kernel/power/process.c:is_user_space()) to
> > distinguish kernel threads from user space processes.  Therefore we make it
> > always return true for user space processes and always return false for kernel
> > threads.  In the latter case we need to use the task_lock() to ensure that the
> > result is as desired (ie. false), because otherwise it might be racing with
> > either fs/aio.c:use_mm() or fs/aio.c:unuse_mm().
> > 
> 
> ah, OK.
> 
> static void use_mm(struct mm_struct *mm)
> {
> 	struct mm_struct *active_mm;
> 	struct task_struct *tsk = current;
> 
> 	task_lock(tsk);
> 	tsk->flags |= PF_BORROWED_MM;
> 	active_mm = tsk->active_mm;
> 	atomic_inc(&mm->mm_count);
> 	tsk->mm = mm;
> 	tsk->active_mm = mm;
> 	/*
> 	 * Note that on UML this *requires* PF_BORROWED_MM to be set, otherwise
> 	 * it won't work. Update it accordingly if you change it here
> 	 */
> 	switch_mm(active_mm, mm, tsk);
> 	task_unlock(tsk);
> 
> So is_user_space() requires that the state of p->mm and p->flags be
> consistent: it doesn't want to be looking at those two things in that
> three-statement window above.
> 
> Good changelogging and commenting save quite a bit of time and email.

Very true.

I have added a comment to the patch, so that we remeber why the task_lock()
is there.  Please replace the original patch with this one (unless you think it's
worse ;-)).

---
From: Rafael J. Wysocki <rjw@sisk.pl>

The reading of PF_BORROWED_MM in is_user_space() without task_lock() is racy. 
Fix it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/process.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c
+++ linux-2.6/kernel/power/process.c
@@ -8,6 +8,7 @@
 
 #undef DEBUG
 
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
 #include <linux/module.h>
@@ -88,7 +89,18 @@ static void cancel_freezing(struct task_
 
 static inline int is_user_space(struct task_struct *p)
 {
-	return p->mm && !(p->flags & PF_BORROWED_MM);
+	int ret;
+
+	/*
+	 * task_lock() is acquired to avoid evaluating the condition while the
+	 * state of p->mm and p->flags is not consistent, which may happen,
+	 * for example, if this function is executed in parallel with
+	 * fs/aio.c:unuse_mm()
+	 */
+	task_lock(p);
+	ret = p->mm && !(p->flags & PF_BORROWED_MM);
+	task_unlock(p);
+	return ret;
 }
 
 static unsigned int try_to_freeze_tasks(int freeze_user_space)

