Return-Path: <linux-kernel-owner+w=401wt.eu-S1031446AbXEDRJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031446AbXEDRJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031447AbXEDRJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:09:34 -0400
Received: from mail.screens.ru ([213.234.233.54]:40918 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031446AbXEDRJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:09:32 -0400
Date: Fri, 4 May 2007 21:09:16 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070504170916.GA95@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru> <20070503181513.0b0aa4fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503181513.0b0aa4fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03, Andrew Morton wrote:
>
> On Fri, 4 May 2007 00:42:26 +0400
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > Disadvantages:
> > 
> > 	- this patch adds wmb() to insert_work().
> > 
> > 	- slowdowns the fast path (when del_timer() succeeds on entry) of
> > 	  cancel_rearming_delayed_work(), because wait_on_work() is called
> > 	  unconditionally. In that case, compared to the old version, we are
> > 	  doing "unneeded" lock/unlock for each online CPU.
> > 
> > 	  On the other hand, this means we don't need to use cancel_work_sync()
> > 	  after cancel_rearming_delayed_work().
> > 
> > 	- complicates the code (.text grows by 130 bytes).
> > 
> 
> hm, this is getting complex.

Yes, and I can't say I like this patch very much.

First, I am not really sure it is terribly useful. Yes, cancel_rearming_delayed_work
sucks, but did we have any problem in practice? The most annoying problem is that it
cant't cancel @dwork which doesn't re-arm itself unconditionally. But this is not so
common, and ata_port_flush_task() shows an example how to do this. However, it also
shows that this is not so trivial, and work->func() should participate.

Also, we can solve this problem in more simple way. For example, we can shift
"timer->function = delayed_work_timer_fn" from queue_delayed_work() to INIT_DELAYED_WORK().
Then, roughly,

	cancel_rearming_delayed_work(dwork)
	{
		dwork->timer->function = do_nothing_timer_fn;
		del_timer_sync(&dwork->timer);
		wait_on_work(&dwork->work);
		dwork->timer->function = delayed_work_timer_fn;
		del_timer(&dwork->timer);
		work_clear_pending(&dwork->work
	}
	
But this is so hackish, and doesn't work if work->func() use queue_work() or
queue_delayed_work(delay = 0) to re-arm itself. Perhaps we can forbid this,
and make a simpler patch.

> > +	while (!try_to_grab_pending(work))
> > +		;
> 
> The patch adds a couple of spinloops.  Normally we put a cpu_relax() into
> such loops.  It can make a very large difference under some circumstances.

Ah, yes. I'll send a fix along with a little comments update.

Oleg.

