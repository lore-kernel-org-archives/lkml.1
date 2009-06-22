Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbZFVSwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbZFVSwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZFVSwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:52:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbZFVSwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:52:34 -0400
Date: Mon, 22 Jun 2009 11:51:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, jmorris@namei.org, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rework/fix is_single_threaded()
Message-Id: <20090622115148.5f1e5d1b.akpm@linux-foundation.org>
In-Reply-To: <20090618194238.GA17810@redhat.com>
References: <20090413214513.GA1119@redhat.com>
	<14878.1239876272@redhat.com>
	<20090416133658.GA6532@redhat.com>
	<20090416145444.GA12884@redhat.com>
	<20090618120716.fd1e4d92.akpm@linux-foundation.org>
	<20090618194238.GA17810@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009 21:42:38 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 06/18, Andrew Morton wrote:
> >
> > It appears that this patch is rather stuck.  Should I drop it?
> 
> Well, I am biased of course...
> 
> I think the patch is correct. David dislikes down_write(->mmap_sem),
> but imho it is better than the global tasklist_lock.
> 
> Looks like we can avoid ->mmap_sem too, but imho this change needs
> another patch, it is subtle.
> 
> OTOH, I can't say this patch is important, both the fixed bugs and
> improvements are minor.
> 

hm, that's still all a bit marginal/waffly.

> 
> > From: Oleg Nesterov <oleg@redhat.com>
> >
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

Maybe we should do the locking change in a separate and subsequent
patch?
