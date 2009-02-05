Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbZBENre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbZBENre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 08:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbZBENrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 08:47:25 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:33500 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbZBENrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 08:47:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BTkxWSjabQVjF5JVrKUt5SwSOv5JGVEr+GGFGqV9pC0X+gDr96blvogSaU8HWafizP
         kFEzCYDN2IIiEXXQ6A0BmEDxd/SOY7RsVZBlDh5tgl4C5sHlIOdrXNaCaK2S9bOWsO0E
         81XSXey+dJswZX1TQwnPtu/tp0Vdhec7Xbb78=
Date: Thu, 5 Feb 2009 14:47:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
Message-ID: <20090205134716.GB5853@nowhere>
References: <497838F0.7020408@cn.fujitsu.com> <20090122093046.GC5891@nowhere> <20090122093649.GD24758@elte.hu> <c62985530901220306p78ea541cs28912a844297b304@mail.gmail.com> <1232622615.4890.114.camel@laptop> <498AA0F1.2030003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <498AA0F1.2030003@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,


On Thu, Feb 05, 2009 at 04:18:57PM +0800, Lai Jiangshan wrote:
> Peter Zijlstra wrote:
> > On Thu, 2009-01-22 at 12:06 +0100, Frédéric Weisbecker wrote:
> > 
> >> Actually I don't understand when Lai says that it will actually not flush.
> > 
> > Yeah, his changelog is an utter mistery to many..
> > 
> > 
> 
> ----
> Suppose what I wanted to say is A, but sometimes I wrote B for my poor
> English, and people got C when they read it. Thank you, Peter.
> ----


Me too! My poor english takes me double time to explain something :-)


> "if (cwq->thread == current)" is a narrowed checking. lockdep can perform
> the proper checking. I think we could hardly write some code which can
> perform the proper checking when lockdep is off.
> 
> Why "if (cwq->thread == current)" is a narrowed checking,
> It hasn't tested "if (brother_cwq->thread == current)". (*brother* cwq)
> 
> DEADLOCK EXAMPLE for explain my above option:
> 
> (work_func0() and work_func1() are work callback, and they
> calls flush_workqueue())
> 
> CPU#0					CPU#1
> run_workqueue()                         run_workqueue()
>   work_func0()                            work_func1()
>     flush_workqueue()                       flush_workqueue()
>       flush_cpu_workqueue(0)                  .
>       flush_cpu_workqueue(cpu#1)              flush_cpu_workqueue(cpu#0)
>         waiting work_func1() in cpu#1           waiting work_func0 in cpu#0


Heh you're right, I did not imagine this one.
But this race condition should be rare, and still, lockdep should have
warned before concerning the recursion flushing, hopefully assuming the developer
built lockdep.


> DEADLOCK!
> So we do not allow recursion.
> And "BUG_ON(cwq->thread == current)" is not enough(but it's better
> than we don't have this line, I think). we should use lockdep to detect
> recursion when we develop.
> 
> Answer other email-thread:
> 
> Peter Zijlstra wrote:
> > On Thu, 2009-01-22 at 14:03 +0800, Lai Jiangshan wrote:
> >> void do_some_cleanup(void)
> >> {
> >>         find_all_queued_work_struct_and_mark_it_old();
> >>         flush_workqueue(workqueue);
> >>         /* we can destroy old work_struct for we have flushed them */
> >>         destroy_old_work_structs();
> >> }
> >>
> >> if work->func() called do_some_cleanup(), it's very probably a bug.
> > 
> > Of course it is, if only because calling flush on the same workqueue is
> > pretty dumb.
> 
> flush_workqueue() should ensure works are finished, but this example shows
> the work hasn't finished, so flush_workqueue()'s code is not right.
> 
> See also flush_workqueue()'s doc:
>  * We sleep until all works which were queued on entry have been handled,
>  * but we are not livelocked by new incoming ones.
> 
> And this example show a bug(destroy the work which still be used)
> for recursion. So in my changlog:
> 
> I said it hide deadlock:
>    "We use recursion run_workqueue to hidden deadlock when
>    keventd trying to flush its own queue."
> 
> I said it will be bug(for flush_workqueue() and it's doc is inconsistent):
>    "It's bug. When flush_workqueue()(nested in a work callback)returns,
>    the workqueue is not really flushed, the sequence statement of
>    this work callback will do some thing bad."
> 
> And I concluded:
>    "So we should not allow workqueue trying to flush its own queue."
> 
> If it still mistery, I will explain more.
> I will change my changlog too, I sincerely hope you help me more.
> 
> Thanks, Lai
> 
> > 
> > But I'm still not getting it, flush_workqueue() provides the guarantee
> > that all work enqueued previous to the call will be finished thereafter.
> 
> In my example, flush_workqueue() can't guarantee.
> 
> > 
> > The self-flush stuff you propose to rip out doesn't violate that
> > guarantee afaict.
> > 
> > Suppose we have a workqueue Q, with pending work W1..Wn.
> > 
> > Suppose W5 will have the nested flush, it will then recursively complete
> > W6..Wn+i, where i accounts for any concurrent worklet additions.
> > 
> > Therefore it will have completed (at least) those worklets that were
> > enqueued at the time flush got called.
> > 
> > So, to get back at your changelog.
> > 
> >  1) yes lockdep will complain -- for good reasons, and I'm all for
> > getting rid of this mis-feature.
> > 
> >  2) I've no clue what you're on about
> > 
> >  3) more mystery.
> 

