Return-Path: <linux-kernel-owner+w=401wt.eu-S1761845AbZJNSwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761845AbZJNSwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbZJNSwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:52:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756416AbZJNSww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:52:52 -0400
Date: Wed, 14 Oct 2009 11:51:23 -0700 (PDT)
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
In-Reply-To: <20091014182037.GA10076@redhat.com>
Message-ID: <alpine.LFD.2.01.0910141131050.6146@localhost.localdomain>
References: <4AD4DE4C.4010402@yahoo.co.uk> <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain> <4AD4F548.2030506@microgate.com> <alpine.LFD.2.01.0910131514100.3404@localhost.localdomain> <1255478932.19056.24.camel@localhost.localdomain>
 <4AD51D6B.7010509@microgate.com> <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain> <20091014125846.1a3c8d40@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910140804180.6146@localhost.localdomain> <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain>
 <20091014182037.GA10076@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Oct 2009, Oleg Nesterov wrote:
> 
> >  void tty_flush_to_ldisc(struct tty_struct *tty)
> >  {
> > -	flush_to_ldisc(&tty->buf.work.work);
> > +	flush_delayed_work(&tty->buf.work);
> >  }
> 
> Can't comment this change because I don't understand the problem.

The work function is "flush_to_ldisc()", and what we want to make sure of 
is that the work has been called. We used to just call the work function 
directly - but that meant that now one CPU might be running that "direct" 
call, while another CPU might be running flush_to_ldisc through keventd.

So this makes the "flush_to_ldisc()" is now instead always called through 
keventd (but there's still a possibility that two keventd threads run it 
concurrently - although that is going to be _very_ rare).

> 
> > + * flush_delayed_work - block until a dwork_struct's callback has terminated
> > + * @dwork: the delayed work which is to be flushed
> > + *
> > + * Any timeout is cancelled, and any pending work is run immediately.
> > + */
> > +void flush_delayed_work(struct delayed_work *dwork)
> > +{
> > +	if (del_timer(&dwork->timer)) {
> > +		struct cpu_workqueue_struct *cwq;
> > +		cwq = wq_per_cpu(keventd_wq, get_cpu());
> > +		__queue_work(cwq, &dwork->work);
> > +		put_cpu();
> > +	}
> > +	flush_work(&dwork->work);
> > +}
> 
> I think this is correct. If del_timer() succeeds, we "own" _PENDING bit and
> dwork->work must not be queued. But afaics this helper needs del_timer_sync(),
> otherwise I am not sure about the "flush" part.

Hmm. I wanted to avoid del_timer_sync(), because it's so expensive for the 
case when the timer isn't running at all, but I do think you're correct.

If the del_timer() fails, the timer might still be running on another CPU 
right at that moment, but not quite have queued the work yet. And then 
we'd potentially get the wrong 'cwq' in flush_work() (we'd use the 'saved' 
work), and not wait for it.

I wonder if we could mark the case of "workqueue is on timer" by setting 
the "work->entry" list to some special value. That way

	list_empty(&work->entry)

would always mean "it's neither pending _nor_ scheduled", and 
flush_delayed_work() could have a fast-case check that at the top:

	if (list_empty(&work->entry))
		return;

or similar. When we do the 'insert_work()' in the timer function, the 
'list_empty()' invariant wouldn't change, so you could do that locklessly.

Of course, I've just talked about how much I hate subtle locking in the 
tty layer. This would be subtle, but we could document it, and it would be 
in the core kernel rather than a driver layer. 

> And just in case... Of course, if dwork was pending and running on another CPU,
> then flush_delayed_work(dwork) can return before the running callback terminates.
> But I guess this is what we want.

No, we want to wait for the callback to terminate, so we do want to hit 
that 'flush_work()' case.

> As for tty_flush_to_ldisc(), what if tty->buf.work.work was not scheduled?
> In this case flush_delayed_work() does nothing. Is it OK?

Yes. In fact, it would be a bonus over our current "we always call that 
flush function whether it was scheduled or not" code.

			Linus
