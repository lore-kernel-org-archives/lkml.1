Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbXDFTSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbXDFTSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXDFTSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:18:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbXDFTST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:18:19 -0400
Date: Fri, 6 Apr 2007 21:18:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: [patch] sched: get rid of p->children use in show_task()
Message-ID: <20070406191806.GA15291@elte.hu>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org> <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu> <m11wix73ut.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11wix73ut.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > no. Two _completely separate_ lists.
> >
> > i.e. a to-be-reaped task will still be on the main list _too_. The 
> > main list is for all the PID semantics rules. The reap-list is just 
> > for wait4() processing. The two would be completely separate.
> 
> And what pray tell except for heuristics is the list of children used 
> for?

yeah - by all means get rid of it, but first separate the data 
structures along uses. Then all the 'why should we iterate two lists in 
sequence' questions vanish.

> I could find a use in the scheduler (oldest_child and younger/older_sibling).

this can be zapped today. The patch below does it - the scheduler use 
was purely historic. oldest_child/older_sibling used to have a role but 
it has none today.

> I could find a use in mm/oom_kill.

hm, this use is pretty valid although not user-detectable.

> I could find a use in irixsig where it roles it's own version of 
> wait4.

zappable too.

> Perhaps I was blind but that was about it.
> 
> I didn't see the child list implementing any semantics we really care 
> about to user space.

i think you are right.

	Ingo

Subject: [patch] sched: get rid of p->children use in show_task()
From: Ingo Molnar <mingo@elte.hu>

the p->parent PID printout gives us all the information about the
task tree that we need - the eldest_child()/older_sibling()/
younger_sibling() printouts are mostly historic and i do not
remember ever having used those fields. (IMO in fact they confuse
the SysRq-T output.) So remove them.

This code has sentimental value though, those fields and
printouts are one of the oldest ones still surviving from
Linux v0.95's kernel/sched.c:

        if (p->p_ysptr || p->p_osptr)
                printk("   Younger sib=%d, older sib=%d\n\r",
                        p->p_ysptr ? p->p_ysptr->pid : -1,
                        p->p_osptr ? p->p_osptr->pid : -1);
        else
                printk("\n\r");

written 15 years ago, in early 1992.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   35 +----------------------------------
 1 file changed, 1 insertion(+), 34 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4687,27 +4687,6 @@ out_unlock:
 	return retval;
 }
 
-static inline struct task_struct *eldest_child(struct task_struct *p)
-{
-	if (list_empty(&p->children))
-		return NULL;
-	return list_entry(p->children.next,struct task_struct,sibling);
-}
-
-static inline struct task_struct *older_sibling(struct task_struct *p)
-{
-	if (p->sibling.prev==&p->parent->children)
-		return NULL;
-	return list_entry(p->sibling.prev,struct task_struct,sibling);
-}
-
-static inline struct task_struct *younger_sibling(struct task_struct *p)
-{
-	if (p->sibling.next==&p->parent->children)
-		return NULL;
-	return list_entry(p->sibling.next,struct task_struct,sibling);
-}
-
 static const char stat_nam[] = "RSDTtZX";
 
 static void show_task(struct task_struct *p)
@@ -4738,19 +4717,7 @@ static void show_task(struct task_struct
 		free = (unsigned long)n - (unsigned long)end_of_stack(p);
 	}
 #endif
-	printk("%5lu %5d %6d ", free, p->pid, p->parent->pid);
-	if ((relative = eldest_child(p)))
-		printk("%5d ", relative->pid);
-	else
-		printk("      ");
-	if ((relative = younger_sibling(p)))
-		printk("%7d", relative->pid);
-	else
-		printk("       ");
-	if ((relative = older_sibling(p)))
-		printk(" %5d", relative->pid);
-	else
-		printk("      ");
+	printk("%5lu %5d %6d", free, p->pid, p->parent->pid);
 	if (!p->mm)
 		printk(" (L-TLB)\n");
 	else
