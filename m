Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbXD0FqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbXD0FqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbXD0FqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:46:12 -0400
Received: from mx2.go2.pl ([193.17.41.42]:40805 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755344AbXD0FqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:46:10 -0400
Date: Fri, 27 Apr 2007 07:52:02 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070427055202.GB997@ff.dom.local>
References: <20070420170836.GB470@tv-sign.ru> <20070423090030.GC1684@ff.dom.local> <20070423163312.GA129@tv-sign.ru> <20070424115322.GA2423@ff.dom.local> <20070424185537.GA5029@tv-sign.ru> <20070425122038.GE1613@ff.dom.local> <20070425122814.GF1613@ff.dom.local> <20070425124714.GA94@tv-sign.ru> <20070426131311.GD3145@ff.dom.local> <20070426164436.GB1933@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426164436.GB1933@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 08:44:36PM +0400, Oleg Nesterov wrote:
> On 04/26, Jarek Poplawski wrote:
> >
> > On Wed, Apr 25, 2007 at 04:47:14PM +0400, Oleg Nesterov wrote:
> > ...
> > > > > > +		spin_lock_irq(&cwq->lock);
> > > > > > +		/* CPU_DEAD in progress may change cwq */
> > > > > > +		if (likely(cwq == get_wq_data(work))) {
> > > > > > +			list_del_init(&work->entry);
> > > > > > +			__set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
> > > > > > +			retry = try_to_del_timer_sync(&dwork->timer) < 0;
> > > > > > +		}
> > > > > > +		spin_unlock_irq(&cwq->lock);
> > > > > > +	} while (unlikely(retry));
> > > 
> > > >  1. If delayed_work_timer_fn of this work is fired and is waiting
> > > >  on the above spin_lock then, after above spin_unlock, the work
> > > >  will be queued.
> > > 
> > > No, in that case try_to_del_timer_sync() returns -1.
> > 
> > Yes. But I think it's safe only after moving work_clear_pending
> > in run_workqueue under a lock; probably otherwise there is a
> > possibility this flag could be cleared, after above unlock.  
> 
> It doesn't matter in this particular case because we are going to retry
> anyway. But yes, this patch moves work_clear_pending() under lock, because
> otherwise it could be cleared by run_workqueue() if this work is about
> to be executed, but was already deleted from list.

...and it seems to be the same what I meant...
I wanted only to make agree (now it's only for historical reasons)
the lock on _PENDING could matter in run_workqueue.

Jarek P.
