Return-Path: <linux-kernel-owner+w=401wt.eu-S1751294AbXBRPPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbXBRPPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 10:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbXBRPPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 10:15:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48994 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbXBRPPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 10:15:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Date: Sun, 18 Feb 2007 16:09:45 +0100
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <20070218113124.GA100@tv-sign.ru> <200702181314.29214.rjw@sisk.pl>
In-Reply-To: <200702181314.29214.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181609.47334.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 February 2007 13:14, Rafael J. Wysocki wrote:
> On Sunday, 18 February 2007 12:31, Oleg Nesterov wrote:
> > On 02/18, Rafael J. Wysocki wrote:
> > >
> > > On Sunday, 18 February 2007 00:47, Oleg Nesterov wrote:
> > > > 
> > > > However, this means that sys_vfork() makes impossible to freeze processes
> > > > until child exits/execs. Not good.
> > > 
> > > Yes, but this also is the current behavior.
> > 
> > Yes, yes, I see.
> > 
> > I forgot to say that we have another problem: coredumping.
> > 
> > A thread which does do_coredump() send SIGKILL to ->mm users, and sleeps
> > on ->mm->core_startup_done. Now it can't be frozen if sub-thread goes to
> > refrigerator. I think this could be solved easily if we add a check to
> > refrigerator() as you suggested for ->vfork_donw.
> > 
> > > I think the real solution would be to use an interruptible completion in the
> > > vfork code.  It was discussed some time ago and, IIRC, Ingo had an experimental
> > > patch that implemented it.  Still, for the suspend this really is not an issue
> > > in practice, so it wasn't merged.
> > 
> > It is not (afaics) so trivial to do rightly, and with this change the parent
> > will be seen as TASK_INTERRUPTIBLE even without freezer in progress.
> > 
> > A very vague idea: what if parent will do
> > 
> > 	current->flags |= PF_PLEASE_CONSIDER_ME_AS_FROZEN_BUT_SET_TIF_FREEZE
> > 	wait_for_completion(&vfork);
> > 	try_to_freeze();
> > 
> > ?
> 
> This should work, but we'll need a separate process flag for it.  If that's
> acceptable, I'd call it PF_VFORK_PARENT

Hm, what about the following patch instead?

The problem is that if the child enters the refrigeratior, we can't freeze the
parent, because it's uninterruptible, but the child knows the parent will be
uninterruptible until it exits, so the child can mark the parent as frozen.

 kernel/power/process.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

Index: linux-2.6.20-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/power/process.c	2007-02-18 15:43:30.000000000 +0100
+++ linux-2.6.20-mm2/kernel/power/process.c	2007-02-18 16:09:53.000000000 +0100
@@ -39,6 +39,13 @@ void refrigerator(void)
 	/* Hmm, should we be allowed to suspend when there are realtime
 	   processes around? */
 	long save;
+
+	/* The parent is uninterruptible and will stay so until this task exits,
+	 * so we can mark it as frozen.
+	 */
+	if (current->vfork_done)
+		frozen_process(current->parent);
+
 	save = current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
 
@@ -53,6 +60,9 @@ void refrigerator(void)
 	}
 	pr_debug("%s left refrigerator\n", current->comm);
 	current->state = save;
+
+	if (current->vfork_done && frozen(current->parent))
+		current->parent->flags &= ~PF_FROZEN;
 }
 
 static inline void freeze_process(struct task_struct *p)
@@ -117,21 +127,10 @@ static unsigned int try_to_freeze_tasks(
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
