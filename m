Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbZIAPYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbZIAPYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 11:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbZIAPYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 11:24:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbZIAPYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 11:24:33 -0400
Date: Tue, 1 Sep 2009 17:19:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, arjan@infradead.org, jeremy@goop.org,
       mschmidt@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] kthreads: Fix startup synchronization boot crash
Message-ID: <20090901151926.GA32484@redhat.com>
References: <20090829182718.10f566b1@leela> <tip-23386d63bbb3199cf247313ec088878d72debcfd@git.kernel.org> <20090901100351.GA3361@elte.hu> <20090901113914.GA23578@elte.hu> <20090901130436.GA22514@redhat.com> <20090901131440.GA29783@elte.hu> <20090901133709.GA24041@redhat.com> <20090901150848.GB5394@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090901150848.GB5394@hack>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01, Américo Wang wrote:
>
> On Tue, Sep 01, 2009 at 03:37:09PM +0200, Oleg Nesterov wrote:
> >On 09/01, Ingo Molnar wrote:
> >>
> >> * Oleg Nesterov <oleg@redhat.com> wrote:
> >>
> >> > Yes, this should work. But I _think_ we can make the better fix...
> >> >
> >> > I'll try to make the patch soon. Afaics we don't need
> >> > kthreadd_task_init_done.
> >>
> >> ok.
> >
> >Just in case, the patch is ready. I need to re-check my thinking
> >and test it somehow...
> >
> >- remove kthreadd_task initialization from rest_init()
> >
> >- change kthreadd() to initialize kthreadd_task = current
> >
> >- change the main loop in kthreadd() to take kthread_create_lock
> >  before the first schedule() (just shift schedule() down)
>
> This is the only part that I can't understand, why moving it down?

This way kthreadd() always takes kthread_create_lock before it
schedules.

IOW. Before the patch, kthreadd() does

	for (;;) {
		if (list_empty(kthread_create_list))
			schedule();

		lock(kthread_create_lock);
		while (!list_empty(&kthread_create_list))
			... create kthreads ...
		unlock(kthread_create_lock);
	}

This means kthread_create() can't do

	if (!kthreadd_task)
		wake_up_process(kthreadd_task);

we can read kthreadd_task before kthreadd() sets kthreadd_task = current,
and it is possible that kthreadd() has already checked list_empty() == T.

But if we shift schedule() down, so that kthreadd() does

	for (;;) {
		lock(kthread_create_lock);
		while (!list_empty(&kthread_create_list))
			... create kthreads ...
		unlock(kthread_create_lock);

		if (list_empty(kthread_create_list))
			schedule();
	}

Then we can rely on kthread_create_lock: either kthreadd must see the
addition to create_list, or kthreadd() must see kthreadd_task != NULL.

Because both checks, !kthreadd_task and list_empty(), are done after
lock+unlock of the same lock. The 2nd task which takes the lock must
see the changes which were done by the 1st task which locked this lock.

Do you see any holes?

Oleg.

