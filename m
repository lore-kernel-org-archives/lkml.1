Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbXBQWaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbXBQWaX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 17:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933062AbXBQWaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 17:30:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46810 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbXBQWaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 17:30:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Date: Sat, 17 Feb 2007 23:24:43 +0100
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702171224.46626.rjw@sisk.pl> <20070217213406.GA541@tv-sign.ru>
In-Reply-To: <20070217213406.GA541@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702172324.44892.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 17 February 2007 22:34, Oleg Nesterov wrote:
> Rafael, I am trying to understand try_to_freeze_tasks(), and I have a
> couple of questions.
> 
> 	static inline int is_user_space(struct task_struct *p)
> 	{
> 		return p->mm && !(p->flags & PF_BORROWED_MM);
> 	}
> 
> This doesn't look right. First, an exiting task has ->mm == NULL after
> do_exit()->exit_mm(). Probably not a problem. However, PF_BORROWED_MM
> check is racy without task_lock(), so we can have a false positive as
> well. Is it ok? We can freeze aio_wq prematurely.

Right now aio_wq is not freezeable (PF_NOFREEZE).

> 
> 
> 	try_to_freeze_tasks:
> 
> 		do_each_thread(g, p) {
> 
> 			if (p->state == TASK_TRACED && frozen(p->parent)) {
> 
> Why we are doing this check outside of "if (is_user_space(p))" ?
> Not a bug of course, but looks strange.

For no particular reason.

> 
> 				cancel_freezing(p);
> 				continue;
> 
> Is it right? Shouldn't we increment "todo" counter?

No.  It would be wrong to do that, because TASK_TRACED tasks with frozen
parents cannot be frozen any further.

> 
> 			}
> 			if (is_user_space(p)) {
> 				if (!freeze_user_space)
> 					continue;
> 
> 				/* Freeze the task unless there is a vfork
> 				 * completion pending
> 				 */
> 				if (!p->vfork_done)
> 					freeze_process(p);
> 
> 
> Racy. do_fork(CLONE_VFORK) first does copy_process() which puts 'p' on
> the task list and unlocks tasklist_lock. This means that 'p' is visible
> to try_to_freeze_tasks(), and p->vfork_done == NULL. try_to_freeze_tasks()
> sets TIF_FREEZE.
> 
> Now, do_fork() continues, sets ->vfork_done, p goes to user space, notices
> the fake signal and goes to refrigerator while its parent is blocked on
> "struct completion vfork". Freezing failed.

You are right, but this has never happened, AFAICS.

> So, shouldn't we do
> 
> 	if (p->vfork_done)
> 		cancel_freezing(p);
> 
> instead?

I don't think so.  If p hasn't got TIF_FREEZE set yet or it has already been
frozen, cancel_freezing(p) is a noop.

Alternatively, we can move the check into refrigerator(), like this:

---
 kernel/power/process.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

Index: linux-2.6.20-git13/kernel/power/process.c
===================================================================
--- linux-2.6.20-git13.orig/kernel/power/process.c
+++ linux-2.6.20-git13/kernel/power/process.c
@@ -39,6 +39,11 @@ void refrigerator(void)
 	/* Hmm, should we be allowed to suspend when there are realtime
 	   processes around? */
 	long save;
+
+	/* Freeze the task unless there is a vfork completion pending */
+	if (current->vfork_done)
+		return;
+
 	save = current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
 
@@ -112,22 +117,10 @@ static unsigned int try_to_freeze_tasks(
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
-
+			if (is_user_space(p) == !!freeze_user_space) {
 				freeze_process(p);
+				todo++;
 			}
-			todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 		yield();			/* Yield is okay here */


