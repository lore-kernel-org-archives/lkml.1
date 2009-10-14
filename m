Return-Path: <linux-kernel-owner+w=401wt.eu-S932589AbZJNT5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbZJNT5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbZJNT5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:57:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759293AbZJNT5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:57:44 -0400
Date: Wed, 14 Oct 2009 21:52:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Fulghum <paulkf@microgate.com>,
       Boyan <btanastasov@yahoo.co.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091014195215.GA12936@redhat.com>
References: <4AD4F548.2030506@microgate.com> <alpine.LFD.2.01.0910131514100.3404@localhost.localdomain> <1255478932.19056.24.camel@localhost.localdomain> <4AD51D6B.7010509@microgate.com> <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain> <20091014125846.1a3c8d40@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910140804180.6146@localhost.localdomain> <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain> <20091014182037.GA10076@redhat.com> <alpine.LFD.2.01.0910141131050.6146@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910141131050.6146@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14, Linus Torvalds wrote:
>
> On Wed, 14 Oct 2009, Oleg Nesterov wrote:
> >
> > >  void tty_flush_to_ldisc(struct tty_struct *tty)
> > >  {
> > > -	flush_to_ldisc(&tty->buf.work.work);
> > > +	flush_delayed_work(&tty->buf.work);
> > >  }
> >
> > Can't comment this change because I don't understand the problem.
>
> The work function is "flush_to_ldisc()", and what we want to make sure of
> is that the work has been called.

Thanks... This contradicts with

> > As for tty_flush_to_ldisc(), what if tty->buf.work.work was not scheduled?
> > In this case flush_delayed_work() does nothing. Is it OK?
>
> Yes. In fact, it would be a bonus over our current "we always call that
> flush function whether it was scheduled or not" code.

But I guess I understand what you meant.

> If the del_timer() fails, the timer might still be running on another CPU
> right at that moment, but not quite have queued the work yet. And then
> we'd potentially get the wrong 'cwq' in flush_work() (we'd use the 'saved'
> work), and not wait for it.

Or we can get the right cwq, but since the work is not queued and it is not
cwq->current_work, flush_work() correctly assumes there is nothing to do.

> I wonder if we could mark the case of "workqueue is on timer" by setting
> the "work->entry" list to some special value. That way
>
> 	list_empty(&work->entry)
>
> would always mean "it's neither pending _nor_ scheduled", and
> flush_delayed_work() could have a fast-case check that at the top:
>
> 	if (list_empty(&work->entry))
> 		return;

Yes, but we already have this - delayed_work_pending(). If it is
false, it is neither pending nor scheduled. But it may be running,
we can check cwq->current_work.

The problem is, should we check all CPUs to detect the running case?
please see below.

> > And just in case... Of course, if dwork was pending and running on another CPU,
> > then flush_delayed_work(dwork) can return before the running callback terminates.
> > But I guess this is what we want.
>
> No, we want to wait for the callback to terminate, so we do want to hit
> that 'flush_work()' case.

Hmm. Now I am confused.

OK. Lets suppose dwork's callback is running on CPU 0.

A thread running on CPU 1 does queue_delayed_work(dwork, delay).

Now, flush_workqueue() will flush the 2nd "queue_delayed_work" correctly,
but it can return before "running on CPU 0" completes.

If this is not what we want, then we have to iterate over all CPUs.


As for optimization, I think you are right and flush_delayed_work()
can do
	if (delayed_work_pending() && del_timer_sync()) {
		...
	}
	flush_work();

Assuming that we should not check all CPUs. And in this case perhaps we can
even do something like

	if (!delayed_work_pending() &&
	    get_wq_data()->current_work != dwork)
		return;

but this needs barriers, and run_workqueue() needs mb__before_clear_bit().


I'll try to think more tomorrow, but I doubt it is possible to avoid
del_timer_sync() logic. Whatever we do, if we hit the queueing in progress
we should spin until it is finished.

Oleg.

