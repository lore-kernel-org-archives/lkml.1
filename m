Return-Path: <linux-kernel-owner+w=401wt.eu-S1765917AbXJOT2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765917AbXJOT2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759821AbXJOT2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:28:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20109 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759837AbXJOT23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:28:29 -0400
Date: Mon, 15 Oct 2007 21:28:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20071015192822.GA2267@kernel.dk>
References: <20071015104647.14e60bc5@laptopd505.fenrus.org> <20071015114738.6b5a25c7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015114738.6b5a25c7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15 2007, Andrew Morton wrote:
> On Mon, 15 Oct 2007 10:46:47 -0700
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > 
> > Subject: Give kjournald a IOPRIO_CLASS_RT io priority
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > 
> > With latencytop, I noticed that the (in memory) atime updates during a
> > kernel build had latencies of 600 msec or longer; this is obviously not so
> > nice behavior. Other EXT3 journal related operations had similar or even
> > longer latencies.
> > 
> > Digging into this a bit more, it appears to be an interaction between EXT3
> > and CFQ in that CFQ tries to be fair to everyone, including kjournald.
> > However, in reality, kjournald is "special" in that it does a lot of journal
> > work and effectively this leads to a twisted kind of "mass priority
> > inversion" type of behavior.
> > 
> > The good news is that CFQ already has the infrastructure to make certain
> > processes special... JBD just wasn't using that quite yet.
> > 
> > The patch below makes kjournald of the IOPRIO_CLASS_RT priority to break
> > this priority inversion behavior. With this patch, the latencies for atime
> > updates (and similar operation) go down by a factor of 3x to 4x !
> > 
> 
> Seems a pretty fundamental change which could do with some careful
> benchmarking, methinks.
> 
> See, your patch amounts to "do more seeks to improve one test case". 
> Surely other testcases will worsen.  What are they?

Yes, completely agree! I think Arjans patch makes a heap of sense, but
some numbers would be great to see.

> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > 
> > 
> > diff -purN linux-2.6.23-rc9.org/fs/jbd/journal.c linux-2.6.23-rc9.lt/fs/jbd/journal.c
> > --- linux-2.6.23-rc9.org/fs/jbd/journal.c	2007-10-02 05:24:52.000000000 +0200
> > +++ linux-2.6.23-rc9.lt/fs/jbd/journal.c	2007-10-14 00:06:55.000000000 +0200
> > @@ -35,6 +35,7 @@
> >  #include <linux/kthread.h>
> >  #include <linux/poison.h>
> >  #include <linux/proc_fs.h>
> > +#include <linux/ioprio.h>
> >  
> >  #include <asm/uaccess.h>
> >  #include <asm/page.h>
> > @@ -131,6 +132,8 @@ static int kjournald(void *arg)
> >  	printk(KERN_INFO "kjournald starting.  Commit interval %ld seconds\n",
> >  			journal->j_commit_interval / HZ);
> >  
> > +	current->ioprio =  (IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT) | 4;
> > +
> 
> Might be worth a code comment?

It should not be merged as-is, instead I'll provide a function to do
this. It should also set current->io_context->ioprio_changed. Since no
IO has been done yet at this point it doesn't matter. But we should cut
a piece of set_task_ioprio() out and provide that as a kernel helper for
this sort of thing.

Even just writing it as:

current->ioprio =  (IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT) | IOPRIO_NORM;

would be more readable. Or perhaps this would suffice, given the above
restriction that IO hasn't been done yet:

current->ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, IOPRIO_NORM);

-- 
Jens Axboe

