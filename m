Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYBKKwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYBKKwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbYBKKwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:52:04 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:47994 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbYBKKwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:52:00 -0500
Date: Mon, 11 Feb 2008 13:51:15 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com,
       npiggin@suse.de
Subject: Re: [PATCH 2/8] Add interface for queuing work on a specific CPU
Message-ID: <20080211105115.GC162@tv-sign.ru>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <1202375945-29525-3-git-send-email-jens.axboe@oracle.com> <20080207014503.cf1853c2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207014503.cf1853c2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay,

On 02/07, Andrew Morton wrote:
>
> On Thu,  7 Feb 2008 10:18:59 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -175,6 +175,21 @@ int fastcall queue_work(struct workqueue_struct *wq, struct work_struct *work)
> >  }
> >  EXPORT_SYMBOL_GPL(queue_work);
> >  
> > +int fastcall queue_work_on_cpu(struct workqueue_struct *wq,
> > +			       struct work_struct *work, int cpu)
> > +{
> > +	int ret = 0;
> > +
> > +	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
> > +		BUG_ON(!list_empty(&work->entry));
> > +		__queue_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
> > +		ret = 1;
> > +	}
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(queue_work_on_cpu);
> 
> Might as well change queue_work() to call this?

This is possible, but in that case queue_work_on_cpu() should use wq_per_cpu(),
not per_cpu_ptr(). (otherwise queue_work(single_threaded_wq) won't work).


A bit off-topic, the comment near queue_work() says

	* We queue the work to the CPU it was submitted, but there is no
	* guarantee that it will be processed by that CPU.

This is wrong. Unless cpu_down() happens, we do guarantee it will be processed
by that CPU. Perhaps it makes sense to fix the comment as well?

Oleg.

