Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbZJNU4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbZJNU4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758724AbZJNU4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:56:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756549AbZJNU4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:56:51 -0400
Date: Wed, 14 Oct 2009 13:55:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Fulghum <paulkf@microgate.com>,
       Boyan <btanastasov@yahoo.co.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <20091014195215.GA12936@redhat.com>
Message-ID: <alpine.LFD.2.01.0910141344250.6146@localhost.localdomain>
References: <4AD4F548.2030506@microgate.com> <alpine.LFD.2.01.0910131514100.3404@localhost.localdomain> <1255478932.19056.24.camel@localhost.localdomain> <4AD51D6B.7010509@microgate.com> <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain>
 <20091014125846.1a3c8d40@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910140804180.6146@localhost.localdomain> <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain> <20091014182037.GA10076@redhat.com> <alpine.LFD.2.01.0910141131050.6146@localhost.localdomain>
 <20091014195215.GA12936@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Oct 2009, Oleg Nesterov wrote:

> On 10/14, Linus Torvalds wrote:
> >
> > On Wed, 14 Oct 2009, Oleg Nesterov wrote:
> > >
> > > >  void tty_flush_to_ldisc(struct tty_struct *tty)
> > > >  {
> > > > -	flush_to_ldisc(&tty->buf.work.work);
> > > > +	flush_delayed_work(&tty->buf.work);
> > > >  }
> > >
> > > Can't comment this change because I don't understand the problem.
> >
> > The work function is "flush_to_ldisc()", and what we want to make sure of
> > is that the work has been called.
> 
> Thanks... This contradicts with
> 
> > > As for tty_flush_to_ldisc(), what if tty->buf.work.work was not scheduled?
> > > In this case flush_delayed_work() does nothing. Is it OK?
> >
> > Yes. In fact, it would be a bonus over our current "we always call that
> > flush function whether it was scheduled or not" code.
> 
> But I guess I understand what you meant.

Yeah. Basically, we want to make sure that it has been called *since it 
was scheduled*. In case it has already been called and is no longer 
pending at all, not calling it again is fine.

It's just that we didn't have any way to do that "force the pending 
delayed work to be scheduled", so instead we ran the scheduled function by 
hand synchronously. Which then seems to have triggered other problems.

> > If the del_timer() fails, the timer might still be running on another CPU
> > right at that moment, but not quite have queued the work yet. And then
> > we'd potentially get the wrong 'cwq' in flush_work() (we'd use the 'saved'
> > work), and not wait for it.
> 
> Or we can get the right cwq, but since the work is not queued and it is not
> cwq->current_work, flush_work() correctly assumes there is nothing to do.

Yes.

> > I wonder if we could mark the case of "workqueue is on timer" by setting
> > the "work->entry" list to some special value. That way
> >
> > 	list_empty(&work->entry)
> >
> > would always mean "it's neither pending _nor_ scheduled", and
> > flush_delayed_work() could have a fast-case check that at the top:
> >
> > 	if (list_empty(&work->entry))
> > 		return;
> 
> Yes, but we already have this - delayed_work_pending(). If it is
> false, it is neither pending nor scheduled. But it may be running,
> we can check cwq->current_work.

Yes. But I was more worried about the locks that "del_timer_sync()" does: 
the timer locks are more likely to be contended than the workqueue locks.

Maybe. I dunno.

> > > And just in case... Of course, if dwork was pending and running on another CPU,
> > > then flush_delayed_work(dwork) can return before the running callback terminates.
> > > But I guess this is what we want.
> >
> > No, we want to wait for the callback to terminate, so we do want to hit
> > that 'flush_work()' case.
> 
> Hmm. Now I am confused.
> 
> OK. Lets suppose dwork's callback is running on CPU 0.
> 
> A thread running on CPU 1 does queue_delayed_work(dwork, delay).
> 
> Now, flush_workqueue() will flush the 2nd "queue_delayed_work" correctly,
> but it can return before "running on CPU 0" completes.

Well, this is actually similar to the larger issue of "the tty layer 
doesn't want to ever run two works concurrently". So we already hit the 
concurrency bug.

That said, I had an earlier patch that should make that concurrency case 
be ok (you were not cc'd on that, because that was purely internal to the 
tty layer). And I think we want to do that regardless, especially since it 
_can_ happen with workqueues too (although I suspect it's rare enough in 
practice that nobody cares).

And to some degree, true races are ok. If somebody is writing data on 
another CPU at the same time as we are trying to flush it, not getting the 
flush is fine. The case we have really cared about we had real 
synchronization between the writer and the reader (ie the writer who added 
the delayed work will have done a wakeup and other things to let the 
reader know).

The reason for flushing it was that without the flush, the reader wouldn't 
necessarily see the data even though it's "old" by then - a delay of a 
jiffy is a _loong_ time.. So the flush doesn't need to be horribly exact, 
and after we have flushed, we will take locks that should serialize with 
the flusher.

So I don't think it really matters in practice, but I do think that we 
have that nasty hole in workqueues in general with overlapping work. I 
wish I could think of a way to fix it.

			Linus
