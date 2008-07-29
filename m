Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbYG2Ms2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbYG2Ms2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYG2MsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:48:21 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42752 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYG2MsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:48:20 -0400
Date: Tue, 29 Jul 2008 16:52:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch, minor] workqueue: consistently use 'err' in __create_workqueue_key()
Message-ID: <20080729125201.GC177@tv-sign.ru>
References: <1217277694.20627.9.camel@earth> <20080729110250.GA177@tv-sign.ru> <b647ffbd0807290458n23dbe79et45cb27273e4fc2ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0807290458n23dbe79et45cb27273e4fc2ae@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Dmitry Adamushko wrote:
>
> 2008/7/29 Oleg Nesterov <oleg@tv-sign.ru>:
> > On 07/28, Dmitry Adamushko wrote:
> >>
> >> I guess error handling is a bit illogical in __create_workqueue_key()
> >
> > Please see below,
> >
> >>               for_each_possible_cpu(cpu) {
> >>                       cwq = init_cpu_workqueue(wq, cpu);
> >> -                     if (err || !cpu_online(cpu))
> >> +                     if (!cpu_online(cpu))
> >>                               continue;
> >>                       err = create_workqueue_thread(cwq, cpu);
> >> +                     if (err)
> >> +                             break;
> >
> > This was done on purpose. The code above does init_cpu_workqueue(cpu)
> > for each possible cpu, even if we fail to create cwq->thread for some
> > cpu. This way destroy_workqueue() (called below) shouldn't worry about
> > the partially initialized workqueues.
> >
> > The patch above should work, but it assumes that destroy_workqueue()
> > must do nothing with cwq if cwq->thread == NULL, this is not very
> > robust.
>
> Yes, I saw this test and that's why I decided that destroy_workqueue()
> is able (designed) to deal with partially-initialized objects.

No, no. cwq->thread == NULL just means that it has no ->thread and
nothing more, it does not mean cwq was not initialized, see below.

> Note, for the race scenario with cpu-hotplug (which I've overlooked
> indeed) which you describe below, we also seem to depend on the same
> "cwq->thread == NULL" test in cleanup_workqueue_thread() as follows:
>
> assume, cpu_down(cpu) -> CPU_POST_DEAD -> cleanup_workqueue_thread()
> gets called for a partially initialized workqueue for 'cpu' for which
> create_workqueue_thread() has previously failed in
> create_worqueue_key().

Well, it _is_ initialized, but yes cwq->thread can be NULL,

> >
> > And, more importantly. Let's suppose __create_workqueue_key() does
> > "break" and drops cpu_add_remove_lock. Then we race with cpu-hotplug
> > which can hit the uninitialized cwq. This is fixable, but needs other
> > complication.
>
> And I'd say this behavior (of having a partially-created object
> visible to the outside world) is not that robust. e.g. the
> aforementioned race would be eliminated if we place a wq on the global
> list only when it's been successfully initialized.

Note that start_workqueue_thread() and cleanup_workqueue_thread() has
to check cwq->thread != NULL anyway, suppose that CPU_UP_PREPARE fails.


Yes, we can change __create_workqueue_key() to check err == 0 before
list_add(), but this just adds more checks without any gain.


Note also that in fact it is better to do start_workqueue_thread()
even if create_workqueue_thread(). This doesn't matter with the
current implementation, but start_workqueue_thread() ensures that
cwq->thread can be kthread_stop()'ed, and start_workqueue_thread()
can be changed so it can fail even if kthread_create() succeeds.

Oleg.

