Return-Path: <linux-kernel-owner+w=401wt.eu-S935596AbXJPWiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935596AbXJPWiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXJPWiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:38:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:47212 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbXJPWiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P7ZDGSOWGJk5h6ZTcA0Ty+Q17zulZWwfNWWJ8/ftcKNwBioZ+o7bJHIzs55bEenJk5zXZXZkQdRpZY2ANZMgLc9NbsYb89dwwVrwyROErBTBYq2kXfx9QLECvqLKHjWwuhqLPhro2sRVqOUNTw4SKBZWdpjLY9XIUd7IbVZ+bQ0=
Message-ID: <b647ffbd0710161538r7908956ci5cdec0ed01102097@mail.gmail.com>
Date: Wed, 17 Oct 2007 00:38:07 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] scheduler updates for v2.6.24
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Paul Jackson" <pj@sgi.com>
In-Reply-To: <20071015185307.GA26763@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071015141723.GA29486@elte.hu>
	 <20071015113527.6bf91baf.akpm@linux-foundation.org>
	 <20071015185307.GA26763@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/2007, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > On Mon, 15 Oct 2007 16:17:23 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> >
> > > Linus, please pull the latest scheduler git tree from:
> > >
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> >
> > Did Paul Jackson's crash get fixed?
>
> yes - that crash was a showstopper that was holding up the pull request
> for 2 days. Paul bisected it down to the culprit and the fix was to do
> this in wake_up_new_task():
>
> -       if (!p->sched_class->task_new || !current->se.on_rq) {
> +       if (!p->sched_class->task_new || !current->se.on_rq || !rq->cfs.curr) {
>
> (during early bootup the cfs_rq has no curr pointer yet.) It's not clear
> why this race did not trigger earlier.

an update on this issue:

shortly, SD_BALANCE_FORK is required to trigger this problem and
hence, only NUMA machines could have been affected by it (and only
ia64 and x86 have SD_BALANCE_FORK in SD_NODE_INIT).

more details:

it's perfectly legitimate for 'rq->cfs.curr' to be NULL in
task_new_fair() in the case when this_cpu != task_cpu(p) (p -- is a
newly created task).

why this_cpu != task_cpu(p) :

do_fork() --> copy_process() --> sched_fork() -->
cpu = sched_balance_self(this_cpu, SD_BALANCE_FORK)

chose a different cpu for the new task and there is _no_
'class_sched_fair' task running on this cpu at the moment (that's why
rq->cfs.curr == NULL).

[ thanks a lot to Paul for providing debugging information ]

btw., it's not the 'curr->vruntime < se->vruntime' part in
task_new_fair() that gave us the oops (it's only executed in the case
of this_cpu == task_cpu(p)) _but_ it's rather:

[*] check_spread(cfs_rq, curr) which also accesses 'curr->vruntime'.

> (and the two checks can probably
> be consolidated into a single "!rq->cfs.curr" condition.)

2 checks are required as 'current' and rq->cfs.curr are not the same :-)
It also should work if we just get rid of [*] or add an adiitional
(curr != NULL) check there.

just as a additional observation:

there are lots of per-cpu threads (like events/cpu, ksoftirq/cpu,
etc.) being created on start-up (x NUMBER_OF_CPUS) and SD_SCHED_FORK
(actually, sched_balance_self() from sched_fork()) is just an overhead
in this case...
although, sched_balance_self() is likely to be responsible for a minor
% of the time taken to create a new context so optimizing it away
(esp. for some corner cases) won't improve the start-up time
noticeable.


>
>         Ingo
> -

-- 
Best regards,
Dmitry Adamushko
