Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbYFWUsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbYFWUsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658AbYFWUsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:48:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755499AbYFWUsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:48:14 -0400
Date: Mon, 23 Jun 2008 13:47:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: oleg@tv-sign.ru, ebiederm@xmission.com, mingo@elte.hu,
       torvalds@linux-foundation.org, roland@redhat.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH 1/3] introduce PF_KTHREAD flag
Message-Id: <20080623134706.f5e1ef32.akpm@linux-foundation.org>
In-Reply-To: <20080623134037.8566f651.akpm@linux-foundation.org>
References: <20080601153042.GA8238@tv-sign.ru>
	<20080623134037.8566f651.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 13:40:37 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

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
> > 
> > Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> > 
> >  include/linux/sched.h     |    1 +
> >  include/linux/init_task.h |    2 +-
> >  kernel/exit.c             |    2 +-
> >  fs/exec.c                 |    1 +
> >  4 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > --- 26-rc2/include/linux/sched.h~2_MAKE_PF_KTHREAD	2008-05-18 15:44:16.000000000 +0400
> > +++ 26-rc2/include/linux/sched.h	2008-05-18 20:08:13.000000000 +0400
> > @@ -1508,6 +1508,7 @@ static inline void put_task_struct(struc
> >  #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
> >  #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
> >  #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
> > +#define PF_KTHREAD	0x80000000	/* I am a kernel thread */
> 
> Well "Freezer: Introduce PF_FREEZER_NOSIG" has cheerily come in
> afterwards and stolen 0x80000000 from us.  I'll redo this patch to use,
> umm, 0x00000020.  Please check that this is OK (if it isn't someone
> needs thwapping for not adding a dont-use-this comment).
> 

OK, it seems that in a later patch we switched to 0x00200000 anyway.

"Freezer: Introduce PF_FREEZER_NOSIG" has trashed this patch
series so I'll need to drop introduce-pf_kthread-flag.patch and
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch and
coredump-zap_threads-must-skip-kernel-threads.patch.

I don't yet know how much additional damage will happen as a result.
