Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZDPNpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZDPNpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 09:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbZDPNpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 09:45:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40163 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbZDPNpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 09:45:22 -0400
Date: Thu, 16 Apr 2009 15:40:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, jmorris@namei.org, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rework/fix is_single_threaded()
Message-ID: <20090416134040.GB6532@redhat.com>
References: <20090413214513.GA1119@redhat.com> <20090415163243.94a00ba6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415163243.94a00ba6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15, Andrew Morton wrote:
>
> On Mon, 13 Apr 2009 23:45:13 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > - Fix the comment, is_single_threaded(p) actually means that nobody shares
> >   ->mm with p.
> >
> >   I think this helper should be renamed, and it should not have arguments.
> >   With or without this patch it must not be used unless p == current,
> >   otherwise we can't safely use p->signal or p->mm.
> >
> > - "if (atomic_read(&p->signal->count) != 1)" is not right when we have a
> >   zombie group leader, use signal->live instead.
> >
> > - Add PF_KTHREAD check to skip kernel threads which may borrow p->mm,
> >   otherwise we can return the wrong "false".
> >
> > - Use for_each_process() instead of do_each_thread(), all threads must use
> >   the same ->mm.
> >
> > - Use down_write(mm->mmap_sem) + rcu_read_lock() instead of tasklist_lock
> >   to iterate over the process list. If there is another CLONE_VM process
> >   it can't pass exit_mm() which takes the same mm->mmap_sem. We can miss
> >   a freshly forked CLONE_VM task, but this doesn't matter because we must
> >   see its parent and return false.
>
> hum.  I'm searching for a reason to merge this into 2.6.30 but I'm not
> seeing one?

No reasons to merge.

Also, David seem to have valid concerns about using ->mmap_sem. Most probably
this patch should be changed anyway. Let's see what David thinks.

Oleg.

