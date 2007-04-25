Return-Path: <linux-kernel-owner+w=401wt.eu-S1031093AbXDYPmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031093AbXDYPmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031099AbXDYPmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:42:47 -0400
Received: from mail.screens.ru ([213.234.233.54]:47954 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031097AbXDYPmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:42:46 -0400
Date: Wed, 25 Apr 2007 18:47:59 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070425144759.GA201@tv-sign.ru>
References: <20070419102122.GA93@tv-sign.ru> <20070420092201.GC1695@ff.dom.local> <20070420170836.GB470@tv-sign.ru> <20070423090030.GC1684@ff.dom.local> <20070423163312.GA129@tv-sign.ru> <20070424115322.GA2423@ff.dom.local> <20070424185537.GA5029@tv-sign.ru> <20070425122038.GE1613@ff.dom.local> <20070425122814.GF1613@ff.dom.local> <20070425124714.GA94@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425124714.GA94@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Oleg Nesterov wrote:
>
> On 04/25, Jarek Poplawski wrote:
> >
> >                   Probably this is also possible without timer i.e.
> >  with queue_work.
> 
> Yes, thanks. While adding cpu-hotplug check I forgot to add ->current_work
> check, which is needed to actually implement this
> 
> 	> > Note that cancel_rearming_delayed_work() now can handle the works
> 	> > which re-arm itself via queue_work(), not only queue_delayed_work().
> 
> part. I'll resend after fix.

Hm. But can't we do better? Looks like we don't need to check ->current_work,

	void cancel_rearming_delayed_work(struct delayed_work *dwork)
	{
		struct work_struct *work = &dwork->work;
		struct cpu_workqueue_struct *cwq = get_wq_data(work);
		int done;

		do {
			done = 1;
			spin_lock_irq(&cwq->lock);

			if (!list_empty(&work->entry))
				list_del_init(&work->entry);
			else if (test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
				done = del_timer(&dwork->timer)

			spin_unlock_irq(&cwq->lock);
		} while (!done);

		/*
		 * Nobody can clear WORK_STRUCT_PENDING. This means that the
		 * work can't be re-queued and the timer can't be re-started.
		 */
		needs_a_good_name(cwq->wq, work);
		work_clear_pending(work);
	}

Jarek, I didn't think much about this, just a new idea. I am posting this code
in a hope you can review it while I sleep on this... CPU-hotplug is ignored for
now. Note that this version doesn't need the change in run_workqueue().

Oleg.

