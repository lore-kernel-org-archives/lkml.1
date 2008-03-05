Return-Path: <linux-kernel-owner+w=401wt.eu-S1759839AbYCERHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbYCERHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbYCERHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:07:32 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:59458 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYCERHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:07:32 -0500
Date: Wed, 5 Mar 2008 20:11:09 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] orphaned pgrp fixes
Message-ID: <20080305171109.GB6723@tv-sign.ru>
References: <20080302184430.GA16362@tv-sign.ru> <20080304122654.7313227010A@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304122654.7313227010A@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Roland McGrath wrote:
>
> What seems most pedantically right for this check is:
> 		is_my_init(p, p->real_parent)
> i.e.
> 		if (task_session(p->real_parent) == task_session(p) &&
> 		    task_pgrp(p->real_parent) != pgrp &&
> 		    task_tgid_nr_ns(p->real_parent, p->nsproxy->pid_ns) != 1)
> 			return 0;
> It's excluded from counting as in your session if you consider to to be init.

Yes. Not that I really understand ;) But Eric also suggested to use
is_container_init().

> The write lock on
> tasklist_lock strictly serializes all exiting process's calls from
> exit_notify.  This call is after group_dead hits.  If some other
> process in the pgrp has ->signal->live > 0 then it has not exited yet
> and when it does it will do this same check, guaranteed to be after
> ours, and after our ->signal->live == 0.

Yes. I though about that too. But, unlike ->exit_state, signal->live
is not protected by tasklist, please see below.

> Since it's after our own
> group_dead hit, the "ignored_task" check for our own group leader is
> redundant with that.

Ah, good point. I didn't realize this when I was thinking about using
signal->live.

So perhaps it's:
> 
> 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
> 		if (task_session(p->real_parent) == task_session(p) &&
> 		    task_pgrp(p->real_parent) != pgrp &&
>  		    atomic_read(&p->signal->live) > 0 &&
> 		    task_tgid_nr_ns(p->real_parent, p->nsproxy->pid_ns) != 1)
> 			return 0;
> 	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);

I am hopeless, I can't understand orphaned pgrps.

But still. Let's suppose that pgrp should be considered as orphaned when
2 tasks A and B exit. They both exit at the same time and decrement ->live
down to zero. Now, they both can send SIGHUP to the stopped tasks.

No?

That said. Even if I am right, I agree that the signal->live check is
better. I like very much the possibility to kill the ugly "ignored_task".

> Now, about has_stopped_jobs.  It's a waste for it to be a separate loop
> across the pgrp just after we did one in will_become_orphaned_pgrp.  They
> should be merged together.

Yes sure. Looking at the code I was surprised why we don't do that.

Oleg.

