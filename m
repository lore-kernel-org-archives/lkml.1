Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbZJOMxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbZJOMxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 08:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbZJOMxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 08:53:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152AbZJOMxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 08:53:05 -0400
Date: Thu, 15 Oct 2009 14:47:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Fulghum <paulkf@microgate.com>,
       Boyan <btanastasov@yahoo.co.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091015124730.GA9398@redhat.com>
References: <1255478932.19056.24.camel@localhost.localdomain> <4AD51D6B.7010509@microgate.com> <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain> <20091014125846.1a3c8d40@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910140804180.6146@localhost.localdomain> <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain> <20091014182037.GA10076@redhat.com> <alpine.LFD.2.01.0910141131050.6146@localhost.localdomain> <20091014195215.GA12936@redhat.com> <alpine.LFD.2.01.0910141344250.6146@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910141344250.6146@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14, Linus Torvalds wrote:
>
> Yeah. Basically, we want to make sure that it has been called *since it
> was scheduled*. In case it has already been called and is no longer
> pending at all, not calling it again is fine.
>
> It's just that we didn't have any way to do that "force the pending
> delayed work to be scheduled", so instead we ran the scheduled function by
> hand synchronously. Which then seems to have triggered other problems.

Yes. But I am not sure these problems are new. I do not understand this
code even remotely, but from a quick grep it seems to me it is possible
that flush_to_ldisc() can race with itself even without tty_flush_to_ldisc()
which calls work->func() by hand.

> So I don't think it really matters in practice, but I do think that we
> have that nasty hole in workqueues in general with overlapping work. I
> wish I could think of a way to fix it.

I don't entirely agree this is a hole, I mean everything works "as expected".
But yes, I agree, users often do not realize that multithreaded workqueues
imply overlapping works (unless the caller takes care). And in this case
work->func() should solve the races itself.

Perhaps it makes sense to introduce something like

	// same as queue_work(), but ensures work->func() can't race with itself

	int queue_work_xxx(struct workqueue_struct *wq, struct work_struct *work)
	{
		int ret = 0;

		if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
			struct cpu_workqueue_struct *cwq = get_wq_data(work);
			int cpu = get_cpu();

			// "cwq->current_work != work" is not strictly needed,
			// but we don't want to pin this work to the single CPU.

			if (!cwq || cwq->current_work != work)
				cwq = wq_per_cpu(wq, cpu);

			__queue_work(cwq, work);
			put_cpu();
			ret = 1;
		}

		return ret;
	}

This way we can never have multiple instances of the same work running on
different CPUs. Assuming, of course, the caller never mixes queue_work_xxx()
with queue_work(). The logic for queue_delayed_work_xxx() is similar.

But, this can race with cpu_down(). I think this is solvable but needs
more locking. I mean, the caller of queue_work_xxx() must not use the old
get_wq_data(work) if this CPU is already dead, but a simple cpu_online()
is not enough, we can race with workqueue_cpu_callback(CPU_POST_DEAD)
flushing this cwq, in this case we should carefully insert this work
into the almost-dead queue.

Or, perhaps better, instead of new helper, we can probably use the free
bit in work_struct->data to mark this work/dwork as "single-instance-work".
In this case __queue_work and queue_delayed_work_on should check this bit.

Do you think this makes sense and can close the hole?

If yes, I'll try to do this on Weekend.

Oleg.

