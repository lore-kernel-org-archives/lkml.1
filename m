Return-Path: <linux-kernel-owner+w=401wt.eu-S1765422AbYCGUOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765422AbYCGUOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759678AbYCGUOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:14:36 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:58384 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759552AbYCGUOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:14:35 -0500
Date: Fri, 7 Mar 2008 23:13:46 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: do_tkill: don't use tasklist_lock
Message-ID: <20080307201346.GA107@tv-sign.ru>
References: <20080307095813.GA8894@tv-sign.ru> <20080307193159.1AFF127010F@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307193159.1AFF127010F@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07, Roland McGrath wrote:
> 
> > Note that we don't return an error if lock_task_sighand() fails, we
> > pretend the task dies after receiving the signal. Otherwise, we should
> > fight with the nasty races with mt-exec without having any advantage.
> 
> To clarify, this is not a change from the existing behavior.
> So your change is fine regardless of this issue.
> 
> The case you have in mind is that p was the old group_leader
> being replaced by another thread that exec'd, right?

Yes.

> It is the most obscure of nits, but I think it can be wrong to drop a
> signal in this case.  If it's a fatal signal (especially SIGKILL),
> then either the thread group should be killed or the call should
> return an error.

Yes, we are not consistent here with or without this patch.

Btw, a question: we are buggy or just "not perfect" ? After all, the
main thread actually exits although this is just linux's implementation
detail.

> For the exec case, if p->sighand is cleared that means the
> release_task(leader) call at the end of de_thread started.  So by
> now, the pid has been transferred to the exec'ing thread.  If we just
> restart the lookup, it will find the new thread (or not, and we can
> return -ESRCH).

Yep. kill_pid_info() does exactly this. Initially I was going to repeat
this logic,

> I'm inclined to do that, but it certainly should be a second patch
> after this one.

but actually it doesn't buy much here.

Suppose that the main thread is already dead (dequeued SIGKILL), but
not yet released. This window is not that small. In that window (before
de_thread() switches pids) any private signal (even SIGKILL) sent to the
main thread will be silently lost.

To do a proper fix, we should change de_thread() so that the new leader
also "inherits" old_leader->pending signals.

This is certainly possible as a separate change.

Oleg.

