Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbZFXU3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbZFXU3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZFXU25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:28:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37298 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760946AbZFXU24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:28:56 -0400
Date: Wed, 24 Jun 2009 19:13:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Ratan Nalumasu <rnalumasu@gmail.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 2/2] change __wake_up_parent() to use filtered
	wakeup
Message-ID: <20090624171357.GA30435@redhat.com>
References: <20090622170437.GA4906@redhat.com> <20090624091316.73D0F4059B@magilla.sf.frob.com> <20090624152143.GB23848@redhat.com> <20090624185701.AA74C4059B@magilla.sf.frob.com> <20090624161111.GA27890@redhat.com> <20090624194239.A29174059B@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624194239.A29174059B@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Roland McGrath wrote:
>
> do_notify_parent_cldstop:
>
> 	if (task_ptrace(tsk))
> 		parent = tsk->parent;
> 	else {
> 		tsk = tsk->group_leader;
> 		parent = tsk->real_parent;
> 	}
> 	...
> 	__wake_up_parent(tsk, parent);
>
> In the "else" case, parent is not necessarily tsk->parent.  That is, if
> an untraced thread calls do_notify_parent_cldstop() but its group_leader
> is ptrace_reparented().  Then waitee->group_leader->real_parent is who
> gets the wakeup, but __wake_up_parent->child_wait_wakeup would check
> only waiter == waitee->group_leader->parent.

... and in this case we do not wake up ->group_leader->real_parent.

But this is fine? It doesn't make sense to wake up, wait_consider_task()
will notice task_ptrace() and do nothing?

I really need to think with a fresh head, but it seems to me we could add
BUG_ON(p->parent != parent) into wait_consider_task() after "if (ptrace...)"
check.

And this "proves" your check in child_wait_callback() is correct, with
__WNOTHREAD do_wait_thread(parent) is always called with parent ==
sleeper, the caller of do_wait().

No?


Btw, this reminds me that wait_consider_task() doesn't need the "parent"
argument. I noticed this after adding wait_opts, but forgot to send a
patch.

Oleg.

