Return-Path: <linux-kernel-owner+w=401wt.eu-S966235AbXEHJJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966235AbXEHJJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965805AbXEHJJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:09:44 -0400
Received: from mx10.go2.pl ([193.17.41.74]:47298 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965536AbXEHJJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:09:43 -0400
Date: Tue, 8 May 2007 11:16:01 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make-cancel_rearming_delayed_work-reliable-fix
Message-ID: <20070508091601.GB1772@ff.dom.local>
References: <20070503204226.GA212@tv-sign.ru> <20070503181513.0b0aa4fb.akpm@linux-foundation.org> <20070505213213.GA1013@tv-sign.ru> <20070507103107.GD1754@ff.dom.local> <20070507103420.GA74@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507103420.GA74@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 02:34:20PM +0400, Oleg Nesterov wrote:
> On 05/07, Jarek Poplawski wrote:
...
> I am not happy with the complication this patch adds, mostly
> I hate this smb_wmb() in insert_work(). I have an idea how to
> remove it later, but this needs another patch not related to
> workqueue.c.

Probably I don't feel those barriers enough, but IMHO,
there is something wrong, if they are needed here, with
all this made per cpu.

> 
> > BTW, I'm still not convinced all additions are needed:
> > the "old" cancel_rearming_  doesn't care about checking
> > or waiting on anything after del_timer positive.
> 
> It would be very strange to do wait_on_work() only in case
> when del_timer() failed. This way we still need to do
> cancel_work_sync() after cancel_rearming_delayed_work(),
> but only when del_timer() failed, ugly. Note also that
> wait_on_work() does not sleep if work->func() is not running.
> 
> Also, consider this callback:
> 
> 	void work_handler(struct work_struct *w)
> 	{
> 		struct delayed_work dw = container_of(...);
> 
> 		queue_delayed_work(dw, delay);
> 
> 		// <------------- cancel_rearming_delayed_work()
> 
> 		cancel_delayed_work(dw);
> 		queue_delayed_work(dw, another_delay);
> 	}
> 
> Yes, this is strange and ugly. But correct! The current version
> (before this patch) can't cancel this delayed_work. The new
> implementation works correctly. So I think it is far better to
> do wait_on_work() unconditionally.

I think there are possible many curious, but correct things yet,
e.g. handler, which fires timer or another work, which rearms
this work... But maybe it would be resonable to try to separate
new things which are really necessary, so IMHO, (practical)
elimination of endless or excessive looping. If there is needed
some more functionality, maybe there should be second version
added e.g. cancel_rearming_delayed_work_sync(). Without this
you risk, people would really think the old version was better,
if you knew what you were doing. And the worst thing possible:
they'll start to use their own, lighter solutions.

I think, there is no reason, such function should need more
than one loop of one cpu workqueue to cancel any "normal" work
(or maybe two - if locking is spared), and it's really hard
to understand, why anybody should  wait all those "not mine",
so probably slow and buggy works in a queue, do their part of
needless locking/sleeping/looping and let "my" excellent
driver to be reloaded... And I think you are doing this now
with some reserves (kind of "with one hand") - because the
_PENDING flag is overloaded here and one flag still free.
I really cannot see how sparing one, two or even three flag
checks during a loop could be worth even one run_workqueue
loop more without them.

Yesterday I've written something probably against my intention:
so, if there is any CPU burning place, which could be fixed,
it's definitely worth fixing. I'm not sure what exactly place
did you mean - if spinlocking in wait_on_work - maybe it's
a sign this place isn't optimal too: it seems to me, this all
inserting/waiting for completion could be done under existing
locks e.g. in run_workqueue (maybe with some flag?).

Jarek P.
