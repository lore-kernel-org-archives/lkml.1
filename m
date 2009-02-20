Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbZBTC2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbZBTC2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZBTC2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:28:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbZBTC2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:28:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] forget_original_parent: split out the un-ptrace part
In-Reply-To: Oleg Nesterov's message of  Wednesday, 11 February 2009 22:12:16 +0100 <20090211211216.GA16847@redhat.com>
References: <20090211211216.GA16847@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090220022746.8852CFC2F7@magilla.sf.frob.com>
Date: Thu, 19 Feb 2009 18:27:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline int task_detached(struct task_struct *p)

Maybe take the opportunity to make it bool?
Clearly trivial, but a bit of implicit documentation that doesn't hurt.

> @@ -911,7 +825,10 @@ static void forget_original_parent(struc
>  	write_unlock_irq(&tasklist_lock);
>  	BUG_ON(!list_empty(&father->children));
>  
> -	ptrace_exit_finish(father, &ptrace_dead);
> +	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
> +		list_del_init(&p->ptrace_entry);
> +		release_task(p);
> +	}
>  }

I know it's removed by the next patch anyway.  But I wouldn't mind a comment
in this patch saying "kludge overload of ptrace_entry should go away soon".

> +/*
> + * Called with irqs disabled, returns true if childs should reap themselves.

s/childs/children/

Make this bool too.

> +/*
> + * Detach all tasks we were using ptrace on.
> + */
> +void exit_ptrace(struct task_struct *tracer)
> +{
> +	struct task_struct *p, *n;
> +	LIST_HEAD(ptrace_dead);

I think this can do a short-circuit for the common case and avoid the lock:

	if (list_empty(&tracer->ptraced))
		return;

It might even be worthwhile making it an inline that does the short-circuit
check before calling out to ptrace.c at all.

I see your patch 4/4 on this.  In fact, I think the short-circuit
optimization of these two cases should be two separate patches.  They are
for the same motivation and the same kind of optimization, but the details
of what the race issues might be are quite distinct between the two.

Moreover, the exit_ptrace optimization is removing the new lock overhead we
introduce in this patch.  The real-child optimization is just a new
optimization beyond the status quo.  It can really be considered wholly
after this whole series (and probably just punted because it gets so hairy).

For the ptrace case, I started out thinking it was trivially clear that no
false positives are possible here.  The tracer can't do ptrace_attach() or
do_fork(), it's exiting.  But ptrace_traceme() can sneak in here.  (I don't
see how release_task() could be a problem at all.  Going from nonempty to
empty could only cause false negatives--which are always harmless--not false
positives.)  

You didn't mention ptrace_traceme() in your 4/4 message.  Off hand I don't
see what keeps it safe when we go to dropping the tasklist_lock between
exit_ptrace and changing children's real_parent links.  In fact, that seems
like a new hole, period--without the short-circuit optimization.  
Am I overlooking something here?

That seems addressed by e.g.:

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -534,7 +534,7 @@ repeat:
 		 * Set the ptrace bit in the process ptrace flags.
 		 * Then link us on our parent's ptraced list.
 		 */
-		if (!ret) {
+		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
 			current->ptrace |= PT_PTRACED;
 			__ptrace_link(current, current->real_parent);
 		}



Thanks,
Roland
