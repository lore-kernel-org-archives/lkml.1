Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbXDWIyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbXDWIyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbXDWIyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:54:47 -0400
Received: from mx10.go2.pl ([193.17.41.74]:50473 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753017AbXDWIyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:54:46 -0400
Date: Mon, 23 Apr 2007 11:00:30 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070423090030.GC1684@ff.dom.local>
References: <20070419002548.72689f0e.akpm@linux-foundation.org> <20070419102122.GA93@tv-sign.ru> <20070420092201.GC1695@ff.dom.local> <20070420170836.GB470@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420170836.GB470@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 09:08:36PM +0400, Oleg Nesterov wrote:
> On 04/20, Jarek Poplawski wrote:
> >
> > On Thu, Apr 19, 2007 at 02:21:22PM +0400, Oleg Nesterov wrote:
> > ...
> > > Yes. It would be better to use cancel_work_sync() instead of flush_workqueue()
> > > to make this less possible (because cancel_work_sync() doesn't need to wait for
> > > the whole ->worklist), but we can't.
> > > 
> > > > Maybe this patch could check, if I'm not dreaming...
> > > 
> > > Also: cancel_rearming_delayed_work() will hang if it (or cancel_delayed_work())
> > > was already called.
> > > 
> > > I had some ideas how to make this interface reliable, but I can't see how to do
> > > this without uglification of the current code.
> > 
> > For some time I thought about using a flag (isn't there
> > one available after NOAUTOREL?), e.g. WORK_STRUCT_CANCEL,
> > as a sign:
> > 
> > - for a workqueue code: that the work shouldn't be queued,
> > nor executed, if possiblei, at first possible check.
> 
> Well, yes and no, afaics. (note also that NOAUTOREL has already gone).

I thought I wrote the same (sorry for my English)... 

> 
> First, this flag should be cleared after return from cancel_rearming_delayed_work().

I think this flag, if at all, probably should be cleared only
consciously by the owner of a work, maybe as a schedule_xxx_work
parameter, (but shouldn't be used from work handlers for rearming).
Mostly it should mean: we are closing (and have no time to chase
our work)...

> Also, we should add a lot of nasty checks to workqueue.c

Checking a flag isn't nasty - it's clear. IMHO current way of checking,
whether cancel succeeded, is nasty.

> 
> I _think_ we can re-use WORK_STRUCT_PENDING to improve this interface.
> Note that if we set WORK_STRUCT_PENDING, the work can't be queued, and
> dwork->timer can't be started. The only problem is that it is not so
> trivial to avoid races.

If there were no place, it would be better, then current way.
But WORK_STRUCT_PENDING couldn't be used for some error checking,
as it's now.

> 
> I'll try to do something on Sunday.
> 
> > - for a work function: to stop execution as soon as possible,
> > even without completing the usual job, at first possible check.
> 
> I doubt we need this "in general". It is easy to add some flag to the
> work_struct's container and check it in work->func() when needed.

Yes, but currently you cannot to behave like this e.g. with
"rearming" work. And maybe a common api could save some work.
But of course, if you have better way to assure this, it's OK
with me and congratulations!

Regards,
Jarek P.
