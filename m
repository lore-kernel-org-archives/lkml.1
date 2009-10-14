Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZJNS0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZJNS0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbZJNS0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:26:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbZJNS0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:26:44 -0400
Date: Wed, 14 Oct 2009 20:20:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Fulghum <paulkf@microgate.com>,
       Boyan <btanastasov@yahoo.co.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091014182037.GA10076@redhat.com>
References: <4AD4DE4C.4010402@yahoo.co.uk> <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain> <4AD4F548.2030506@microgate.com> <alpine.LFD.2.01.0910131514100.3404@localhost.localdomain> <1255478932.19056.24.camel@localhost.localdomain> <4AD51D6B.7010509@microgate.com> <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain> <20091014125846.1a3c8d40@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910140804180.6146@localhost.localdomain> <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14, Linus Torvalds wrote:
>
> Of course, keventd itself is multi-threaded, so I'm not entirely sure even
> -that- guarantees that one 'flush_to_ldisc()' couldn't be pending on one
> CPU while it is then scheduled and then run on another CPU concurrently
> too. The WORK_STRUCT_PENDING bit guarantees exclusion from the lists and
> from being pending, but the work might be both pending and _running_ at
> the same time, afaik.

Yes.

>  void tty_flush_to_ldisc(struct tty_struct *tty)
>  {
> -	flush_to_ldisc(&tty->buf.work.work);
> +	flush_delayed_work(&tty->buf.work);
>  }

Can't comment this change because I don't understand the problem.

> + * flush_delayed_work - block until a dwork_struct's callback has terminated
> + * @dwork: the delayed work which is to be flushed
> + *
> + * Any timeout is cancelled, and any pending work is run immediately.
> + */
> +void flush_delayed_work(struct delayed_work *dwork)
> +{
> +	if (del_timer(&dwork->timer)) {
> +		struct cpu_workqueue_struct *cwq;
> +		cwq = wq_per_cpu(keventd_wq, get_cpu());
> +		__queue_work(cwq, &dwork->work);
> +		put_cpu();
> +	}
> +	flush_work(&dwork->work);
> +}

I think this is correct. If del_timer() succeeds, we "own" _PENDING bit and
dwork->work must not be queued. But afaics this helper needs del_timer_sync(),
otherwise I am not sure about the "flush" part.

Let's suppose this dwork was pending and del_timer() returns 0. Since we use
del_timer, not del_timer_sync, it is possible that delayed_work_timer_fn() is
running in parallel, and the queueing is in progress. In this case flush_work()
can just return, before delayed_work_timer_fn() actually queues this dwork.

And just in case... Of course, if dwork was pending and running on another CPU,
then flush_delayed_work(dwork) can return before the running callback terminates.
But I guess this is what we want.


As for tty_flush_to_ldisc(), what if tty->buf.work.work was not scheduled?
In this case flush_delayed_work() does nothing. Is it OK?

Oleg.

