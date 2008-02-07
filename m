Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbYBGJtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbYBGJtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYBGJtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:49:32 -0500
Received: from brick.kernel.dk ([87.55.233.238]:3887 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYBGJtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:49:31 -0500
Date: Thu, 7 Feb 2008 10:49:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com, arjan@linux.intel.com,
       dgc@sgi.com, npiggin@suse.de, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 2/8] Add interface for queuing work on a specific CPU
Message-ID: <20080207094928.GB15220@kernel.dk>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <1202375945-29525-3-git-send-email-jens.axboe@oracle.com> <20080207014503.cf1853c2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207014503.cf1853c2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07 2008, Andrew Morton wrote:
> On Thu,  7 Feb 2008 10:18:59 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  include/linux/workqueue.h |    1 +
> >  kernel/workqueue.c        |   15 +++++++++++++++
> >  2 files changed, 16 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> > index 7f28c32..4c46944 100644
> > --- a/include/linux/workqueue.h
> > +++ b/include/linux/workqueue.h
> > @@ -179,6 +179,7 @@ __create_workqueue_key(const char *name, int singlethread,
> >  extern void destroy_workqueue(struct workqueue_struct *wq);
> >  
> >  extern int FASTCALL(queue_work(struct workqueue_struct *wq, struct work_struct *work));
> > +extern int FASTCALL(queue_work_on_cpu(struct workqueue_struct *wq, struct work_struct *work, int cpu));
> 
> -ETOOWIDE
> 
> please don't add fastcall - we're trying to remove it.

Oops yes, I'll kill the fastcall and fix the > 80 char line!

> >  extern int FASTCALL(queue_delayed_work(struct workqueue_struct *wq,
> >  			struct delayed_work *work, unsigned long delay));
> >  extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index 52db48e..551ad7e 100644
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
> 
> Oleg cc'ed as queue_work() maintainer ;)

Good point, I'll do that locally at least.

-- 
Jens Axboe

