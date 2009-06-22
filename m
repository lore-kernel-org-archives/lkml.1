Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbZFVU3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbZFVU3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZFVU3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:29:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZFVU3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:29:11 -0400
Date: Mon, 22 Jun 2009 19:14:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, jmorris@namei.org, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rework/fix is_single_threaded()
Message-ID: <20090622171431.GA5010@redhat.com>
References: <20090413214513.GA1119@redhat.com> <14878.1239876272@redhat.com> <20090416133658.GA6532@redhat.com> <20090416145444.GA12884@redhat.com> <20090618120716.fd1e4d92.akpm@linux-foundation.org> <20090618194238.GA17810@redhat.com> <20090622115148.5f1e5d1b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622115148.5f1e5d1b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22, Andrew Morton wrote:
>
> hm, that's still all a bit marginal/waffly.
>
> >
> > > From: Oleg Nesterov <oleg@redhat.com>
> > >
> > > - Fix the comment, is_single_threaded(p) actually means that nobody shares
> > >   ->mm with p.
> > >
> > >   I think this helper should be renamed, and it should not have arguments.
> > >   With or without this patch it must not be used unless p == current,
> > >   otherwise we can't safely use p->signal or p->mm.
> > >
> > > - "if (atomic_read(&p->signal->count) != 1)" is not right when we have a
> > >   zombie group leader, use signal->live instead.
> > >
> > > - Add PF_KTHREAD check to skip kernel threads which may borrow p->mm,
> > >   otherwise we can return the wrong "false".
> > >
> > > - Use for_each_process() instead of do_each_thread(), all threads must use
> > >   the same ->mm.
> > >
> > > - Use down_write(mm->mmap_sem) + rcu_read_lock() instead of tasklist_lock
> > >   to iterate over the process list. If there is another CLONE_VM process
> > >   it can't pass exit_mm() which takes the same mm->mmap_sem. We can miss
> > >   a freshly forked CLONE_VM task, but this doesn't matter because we must
> > >   see its parent and return false.
>
> Maybe we should do the locking change in a separate and subsequent
> patch?

Sure, I can split these changes. Or we can just forget about this patch.


But what is the problem with this patch?

David, do you still dislike ->mmap_sem? I didn't see other objections,
and again, imho tasklist_lock is worse.

Oleg.

