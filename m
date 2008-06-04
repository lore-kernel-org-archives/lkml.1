Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbYFDRni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbYFDRni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYFDRna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:43:30 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35669 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbYFDRn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:43:29 -0400
Date: Wed, 4 Jun 2008 21:44:47 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ebiederm@xmission.com, mingo@elte.hu, torvalds@linux-foundation.org,
       roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] introduce PF_KTHREAD flag
Message-ID: <20080604174447.GA10284@tv-sign.ru>
References: <20080601153042.GA8238@tv-sign.ru> <20080603141416.43afaeba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603141416.43afaeba.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Andrew Morton wrote:
>
> On Sun, 1 Jun 2008 19:30:42 +0400
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > Introduce the new PF_KTHREAD flag to mark the kernel threads. It is set by
> > INIT_TASK() and copied to the forked childs (we could set it in kthreadd()
> > along with PF_NOFREEZE instead).
> > 
> > daemonize() was changed as well. In that case testing of PF_KTHREAD is racy,
> > but daemonize() is hopeless anyway.
> > 
> > This flag is cleared in do_execve(), before search_binary_handler(). Probably
> > not the best place, we can do this in exec_mmap() or in start_thread(), or
> > clear it along with PF_FORKNOEXEC. But I think this doesn't matter in practice,
> > and if do_execve() fails kthread should die soon.
> 
> The changelog doesn't explain why this change is being made, and I
> wasn't able to work that out.

Currently it is not possible to see if the task is kthread or not.

In most cases we don't care, all we need to know is it has ->mm or not, but..

> Similarly, I can kinda see what benefit "[PATCH 2/3] kill
> PF_BORROWED_MM in favour of PF_KTHREAD" is bringing us, but it would be
> nice to see that spelled out please.

we can't use PF_BORROWED_MM for that without task_lock(), no matter how
many barriers we add/use.

The 3rd patch is just an example. We have a lot of "p->mm != NULL" checks
in (say) oom_kill.c, and they are not right. Without PF_KTHREAD which can
be checked lockless, we need something like

	int has_mm(struct task_struct *p)
	{
		task_lock(p);
		ret = p->mm && !(p->flags & PF_BORROWED_MM);
		task_unlock(p);

		return ret;
	}


In short, PF_KTHREAD is more flexible and doesn't need task_lock(). If
it it cleared after the check, the task has the new ->mm.

Oleg.

