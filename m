Return-Path: <linux-kernel-owner+w=401wt.eu-S1750907AbXEGDxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907AbXEGDxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 23:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXEGDxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 23:53:05 -0400
Received: from rwcrmhc14.comcast.net ([204.127.192.84]:61872 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXEGDxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 23:53:04 -0400
Subject: Re: [PATCH] relay: use plain timer instead of delayed work
From: Tom Zanussi <zanussi@comcast.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070506124742.GA102@tv-sign.ru>
References: <1178426780.29337.67.camel@ubuntu>
	 <20070506124742.GA102@tv-sign.ru>
Content-Type: text/plain
Date: Sun, 06 May 2007 22:29:40 -0500
Message-Id: <1178508580.4534.1.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-06 at 16:47 +0400, Oleg Nesterov wrote:
> On 05/05, Tom Zanussi wrote:
> >
> > This patch makes relay use timers instead of workqueues for reader
> > waking.
> 
> A couple of very minor nits,
> 
> > @@ -337,11 +334,11 @@ static void __relay_reset(struct rchan_buf *buf, unsigned int init)
> >  	if (init) {
> >  		init_waitqueue_head(&buf->read_wait);
> >  		kref_init(&buf->kref);
> > -		INIT_DELAYED_WORK(&buf->wake_readers, NULL);
> > -	} else {
> > -		cancel_delayed_work(&buf->wake_readers);
> > -		flush_scheduled_work();
> > -	}
> > +		init_timer(&buf->timer);
> > +		buf->timer.data = (unsigned long)buf;
> > +		buf->timer.function = wakeup_readers;
> 
> I'd suggest to use setup_timer(&buf->timer, wakeup_readers, buf);
> 
> > @@ -609,9 +605,16 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
> >  			buf->padding[old_subbuf];
> >  		smp_mb();
> >  		if (waitqueue_active(&buf->read_wait)) {
> > -			PREPARE_DELAYED_WORK(&buf->wake_readers,
> > -					     wakeup_readers);
> > -			schedule_delayed_work(&buf->wake_readers, 1);
> > +			/*
> > +			 * Calling wake_up_interruptible() from here
> > +			 * will deadlock if we happen to be logging
> > +			 * from the scheduler (trying to re-grab
> > +			 * rq->lock), so defer it.
> > +			 */
> > +			if (!timer_pending(&buf->timer)) {
> > +				buf->timer.expires = jiffies + 1;
> > +				add_timer(&buf->timer);
> > +			}
> 
> I think it is better to use __mod_timer(&buf->timer, jiffies + 1). In that
> case this "if (!timer_pending(&buf->timer))" is not strictly needed, yes?
> 
> Imho, add_timer() is almost never should be used. The only valid usage is when
> timer->expires was already set by somebody else.
> 
> Btw, thanks for your explanation about deferred wakeup.
> 

OK, and thanks for your helpful comments.  Corrected patch to follow...

Tom



