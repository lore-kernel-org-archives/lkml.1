Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbXDYNlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbXDYNlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXDYNlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:41:53 -0400
Received: from mail.screens.ru ([213.234.233.54]:33084 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbXDYNlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:41:52 -0400
Date: Wed, 25 Apr 2007 16:47:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070425124714.GA94@tv-sign.ru>
References: <20070419002548.72689f0e.akpm@linux-foundation.org> <20070419102122.GA93@tv-sign.ru> <20070420092201.GC1695@ff.dom.local> <20070420170836.GB470@tv-sign.ru> <20070423090030.GC1684@ff.dom.local> <20070423163312.GA129@tv-sign.ru> <20070424115322.GA2423@ff.dom.local> <20070424185537.GA5029@tv-sign.ru> <20070425122038.GE1613@ff.dom.local> <20070425122814.GF1613@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425122814.GF1613@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Jarek Poplawski wrote:
>
> On Wed, Apr 25, 2007 at 02:20:38PM +0200, Jarek Poplawski wrote:
> > 2 cents more...
> ... 
> > On Tue, Apr 24, 2007 at 10:55:37PM +0400, Oleg Nesterov wrote:
> > > +	do {
> > > +		retry = 1;
> 
> Of course this'll be shorter:
> 
> 		retry = 0;

No, this would be wrong. Note the comment about CPU-hotplug below,
we should retry if cwq was changed.

> > > +		spin_lock_irq(&cwq->lock);
> > > +		/* CPU_DEAD in progress may change cwq */
> > > +		if (likely(cwq == get_wq_data(work))) {
> > > +			list_del_init(&work->entry);
> > > +			__set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
> > > +			retry = try_to_del_timer_sync(&dwork->timer) < 0;
> > > +		}
> > > +		spin_unlock_irq(&cwq->lock);
> > > +	} while (unlikely(retry));

>  1. If delayed_work_timer_fn of this work is fired and is waiting
>  on the above spin_lock then, after above spin_unlock, the work
>  will be queued.

No, in that case try_to_del_timer_sync() returns -1.

>                   Probably this is also possible without timer i.e.
>  with queue_work.

Yes, thanks. While adding cpu-hotplug check I forgot to add ->current_work
check, which is needed to actually implement this

	> > Note that cancel_rearming_delayed_work() now can handle the works
	> > which re-arm itself via queue_work(), not only queue_delayed_work().

part. I'll resend after fix.

>  2. If this function is fired after setting _PENDING flag in
>  queue_delayed_work_on, but before add_timer, this
>  try_to_del_timer_sync loop would miss this, too.

same as above, thanks.

Oleg.

