Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbXDZRjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbXDZRjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbXDZRjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:39:12 -0400
Received: from mail.screens.ru ([213.234.233.54]:40866 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909AbXDZRjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:39:10 -0400
Date: Thu, 26 Apr 2007 20:44:36 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070426164436.GB1933@tv-sign.ru>
References: <20070420092201.GC1695@ff.dom.local> <20070420170836.GB470@tv-sign.ru> <20070423090030.GC1684@ff.dom.local> <20070423163312.GA129@tv-sign.ru> <20070424115322.GA2423@ff.dom.local> <20070424185537.GA5029@tv-sign.ru> <20070425122038.GE1613@ff.dom.local> <20070425122814.GF1613@ff.dom.local> <20070425124714.GA94@tv-sign.ru> <20070426131311.GD3145@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426131311.GD3145@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26, Jarek Poplawski wrote:
>
> On Wed, Apr 25, 2007 at 04:47:14PM +0400, Oleg Nesterov wrote:
> ...
> > > > > +		spin_lock_irq(&cwq->lock);
> > > > > +		/* CPU_DEAD in progress may change cwq */
> > > > > +		if (likely(cwq == get_wq_data(work))) {
> > > > > +			list_del_init(&work->entry);
> > > > > +			__set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
> > > > > +			retry = try_to_del_timer_sync(&dwork->timer) < 0;
> > > > > +		}
> > > > > +		spin_unlock_irq(&cwq->lock);
> > > > > +	} while (unlikely(retry));
> > 
> > >  1. If delayed_work_timer_fn of this work is fired and is waiting
> > >  on the above spin_lock then, after above spin_unlock, the work
> > >  will be queued.
> > 
> > No, in that case try_to_del_timer_sync() returns -1.
> 
> Yes. But I think it's safe only after moving work_clear_pending
> in run_workqueue under a lock; probably otherwise there is a
> possibility this flag could be cleared, after above unlock.  

It doesn't matter in this particular case because we are going to retry
anyway. But yes, this patch moves work_clear_pending() under lock, because
otherwise it could be cleared by run_workqueue() if this work is about
to be executed, but was already deleted from list.

Oleg.

