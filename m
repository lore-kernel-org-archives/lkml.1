Return-Path: <linux-kernel-owner+w=401wt.eu-S1764661AbYCGTc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764661AbYCGTc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758786AbYCGTct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:32:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305AbYCGTcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:32:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: do_tkill: don't use tasklist_lock
In-Reply-To: Oleg Nesterov's message of  Friday, 7 March 2008 12:58:13 +0300 <20080307095813.GA8894@tv-sign.ru>
References: <20080307095813.GA8894@tv-sign.ru>
X-Shopping-List: (1) Hazardous acoustic ignition detergents
   (2) Mesozoic Turkey wine
   (3) Marxist Convulsion aggressors
   (4) Rampant carnations
Message-Id: <20080307193159.1AFF127010F@magilla.localdomain>
Date: Fri,  7 Mar 2008 11:31:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Convert do_tkill() to use rcu_read_lock() + lock_task_sighand() to avoid
> taking tasklist lock.

That part looks good.

> Note that we don't return an error if lock_task_sighand() fails, we
> pretend the task dies after receiving the signal. Otherwise, we should
> fight with the nasty races with mt-exec without having any advantage.

To clarify, this is not a change from the existing behavior.
So your change is fine regardless of this issue.

The case you have in mind is that p was the old group_leader
being replaced by another thread that exec'd, right?

It is the most obscure of nits, but I think it can be wrong to drop a
signal in this case.  If it's a fatal signal (especially SIGKILL),
then either the thread group should be killed or the call should
return an error.  

For the exec case, if p->sighand is cleared that means the
release_task(leader) call at the end of de_thread started.  So by
now, the pid has been transferred to the exec'ing thread.  If we just
restart the lookup, it will find the new thread (or not, and we can
return -ESRCH).

I'm inclined to do that, but it certainly should be a second patch
after this one.


Thanks,
Roland
