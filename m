Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZIAPAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZIAPAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 11:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZIAPAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 11:00:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbZIAPA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 11:00:29 -0400
Date: Tue, 1 Sep 2009 16:55:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: arjan@infradead.org, jeremy@goop.org, mschmidt@redhat.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] kthreads: Fix startup synchronization boot crash
Message-ID: <20090901145526.GA31317@redhat.com>
References: <20090829182718.10f566b1@leela> <tip-23386d63bbb3199cf247313ec088878d72debcfd@git.kernel.org> <20090901100351.GA3361@elte.hu> <20090901113914.GA23578@elte.hu> <20090901130436.GA22514@redhat.com> <20090901131440.GA29783@elte.hu> <20090901133709.GA24041@redhat.com> <20090901135925.GA9083@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901135925.GA9083@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 09/01, Ingo Molnar wrote:
> > >
> > > * Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > > Yes, this should work. But I _think_ we can make the better fix...
> > > >
> > > > I'll try to make the patch soon. Afaics we don't need
> > > > kthreadd_task_init_done.
> > >
> > > ok.
> >
> > Just in case, the patch is ready. [...]
>
> yes - that's roughly the cleanup i referred to in the commit log.
>
> way too late for -rc8 though - the minimal fix i did _might_ be
> eligible.
>
> agreed?

Agreed. Then I will sent the patch on top of this change.

But. May be your minimal patch needs a small tweak ?

rest_init()->complete(&kthreadd_task_init_done) assumes that exactly
_one_ caller of kthread_create() can race with kernel_thread(kthreadd).
Perhap we need complete_all() ?


But I must admit, now I don't understand what happens,

	The modification of that variable is protected by the BKL, but
	the _ordering_ of the initial task (which becomes the idle
	thread of CPU0) and the init task (which is spawned by the
	initial task) is not synchronized.

	So we can occasionally end up init running sooner than
	rest_init()

How? rest_init() can't be preempted and it holds BKL. And kernel_init()
takes BKL before anything else. Confused...

Oleg.

