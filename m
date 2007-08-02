Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbXHBVEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbXHBVEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbXHBVEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:04:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42553 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbXHBVEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:04:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm 2/3] Freezer: Use wait queue instead of busy looping (updated)
Date: Thu, 2 Aug 2007 23:13:32 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708012328.23939.rjw@sisk.pl> <200708021938.37547.rjw@sisk.pl> <20070802184002.GA283@tv-sign.ru>
In-Reply-To: <20070802184002.GA283@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708022313.32944.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 2 August 2007 20:40, Oleg Nesterov wrote:
> On 08/02, Rafael J. Wysocki wrote:
> >
> > @@ -171,6 +186,10 @@ static int try_to_freeze_tasks(int freez
> >  
> >  	end_time = jiffies + TIMEOUT;
> >  	do {
> > +		DEFINE_WAIT(wait);
> > +
> > +		add_wait_queue(&refrigerator_waitq, &wait);
> 
> Hmm. In that case I'd sugest to use prepare_to_wait(). This means that
> multiple wakeups from refrigerator() won't do unnecessary work,

I'm not sure what you mean.

Do you mean that if we are TASK_UNINTERRUPTIBLE, then the first wake up
should remove us from the queue?

> and 
> 
> > +
> >  		todo = 0;
> >  		read_lock(&tasklist_lock);
> >  		do_each_thread(g, p) {
> > @@ -189,7 +208,12 @@ static int try_to_freeze_tasks(int freez
> >  				todo++;
> >  		} while_each_thread(g, p);
> >  		read_unlock(&tasklist_lock);
> > -		yield();			/* Yield is okay here */
> > +
> > +		set_current_state(TASK_UNINTERRUPTIBLE);
> > +		if (todo && !list_empty_careful(&wait.task_list))
> > +			schedule_timeout(WAIT_TIME);
> 
> we don't need to check list_empty_careful() before schedule, prepare_to_wait()
> sets TASK_UNINTERRUPTIBLE under wait_queue_head_t->lock.

Yes.

> Still, I personally agree with Pavel. Perhaps it is better to just replace
> yield() with schedule_timeout(a_bit).

Hmm, I think that we shouldn't wait if that's not necessary.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
