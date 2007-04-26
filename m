Return-Path: <linux-kernel-owner+w=401wt.eu-S1031338AbXDZQYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031338AbXDZQYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031340AbXDZQYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:24:42 -0400
Received: from mail.screens.ru ([213.234.233.54]:36594 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031338AbXDZQYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:24:41 -0400
Date: Thu, 26 Apr 2007 19:29:53 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cancel_delayed_work: use del_timer() instead of del_timer_sync()
Message-ID: <20070426152953.GA1824@tv-sign.ru>
References: <20070424215034.GA5985@tv-sign.ru> <20070425130246.GA4086@ff.dom.local> <20070425125214.GB94@tv-sign.ru> <20070426142921.GE3145@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426142921.GE3145@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26, Jarek Poplawski wrote:
>
> On Wed, Apr 25, 2007 at 04:52:14PM +0400, Oleg Nesterov wrote:
> > 
> > >                                                  It seems this
> > > change cannot do any harm, but anyway it could change a few
> > > things, e.g. with current version of cancel_rearming_delayed_work
> > > some flush_workqueue could be done needlessly, before the work
> > > is queued from timer.
> > 
> > I don't think so... Could you clarify?
> 
> With a code like:
> 
> if (!cancel_delayed_work(dwork))
> 	flush_workqueue(wq);
> 	
> if cancel_ returns 0, and there is _queue_work in progress,
> flush_ will be done once, after this work is queued.
> 
> After the patch, and the same situation flush_ also runs
> one time, but maybe without the work in a queue.

First, this is very unlikely event, and the behaviour is correct,
do you agree?

Even in this case, it is very unlikely that flush_cpu_workqueue()
will take cwq->lock before extremely short delayed_work_timer_fn.

Even if it does, work->func() likely will be completed when the
caller of flush_workqueue() will be woken by run_workquue() and
gets CPU.

Please also look at http://marc.info/?t=117699337200022&r=1

> > >                       It's not a big deal here, but if anybody
> > > did something like this without loop - it could matter.
> > > 
> > > So, probably a lot of current code should be checked, before
> > > applying and I doubt the gain is worth of this. Maybe, for
> > > safety, make this with new name as an alternative and
> > > deprecate the current version?
> > 
> > This change should not make any visible difference for the callers,
> > otherwise it is buggy.
> 
> IMHO, there is the same visible difference,
> as between del_timer and del_timer_sync.

Jarek, please, could you be more explicite ? del_timer() and
del_timer_sync() are different in many ways. What exactly will
impact the user of cancel_delaye_work ?

Oleg.

