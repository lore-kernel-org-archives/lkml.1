Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbYFLQeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbYFLQeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYFLQd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:33:56 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39309 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYFLQd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:33:56 -0400
Date: Thu, 12 Jun 2008 20:35:35 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       menage@google.com, linux-kernel@vger.kernel.org,
       Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: workqueue cpu affinity
Message-ID: <20080612163535.GA12135@tv-sign.ru>
References: <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com> <1213080240.31518.5.camel@twins> <484E9FE8.9040504@qualcomm.com> <20080610170005.GA6038@tv-sign.ru> <1213118386.19005.9.camel@lappy.programming.kicks-ass.net> <484EE303.9070007@qualcomm.com> <20080611160815.GA150@tv-sign.ru> <485025CB.8050505@qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485025CB.8050505@qualcomm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11, Max Krasnyansky wrote:
>
> Oleg Nesterov wrote:
> > 
> > Yes, it is easy to implement flush_work(struct work_struct *work) which
> > only waits for that work, so it can't hang unless it was enqueued on the
> > isolated cpu.
> > 
> > But in most cases it is enough to just do
> > 
> > 	if (cancel_work_sync(work))
> > 		work->func(work);
> Cool. That would work.
> btw Somehow I thought that you already implemented flush_work(). I do not see
> it 2.6.25 but I could've sworn that I saw a patch flying by. Must have been
> something else. Do you mind adding that ?

Well... I don't think Andrew will take this patch right now... OK, I'll send
the preparation patch with comments. Do you see an immediate user for this
helper?

> > Or we can add flush_workqueue_cpus(struct workqueue_struct *wq, cpumask_t *cpu_map).
> That'd be special casing. I mean something will have to know what cpus cannot
> be flushed.

OK, we can make it flush_workqueue_except_isolated_cpus(struct workqueue_struct *wq).

> I liked your proposal above much better.

it was Peter who suggested this ;)

> > But I don't think we should change the behaviour of flush_workqueue().
> > 
> >> This will require a bit of surgery across the entire tree. There is a lot of
> >> code that calls flush_scheduled_work()
> > 
> > Almost all of them should be changed to use cancel_work_sync().
> 
> That'd be a lot of changes.
>
> git grep flush_scheduled_work | wc
>     154     376    8674
> 
> Hmm, I guess maybe not that bad. I might actually do that :-).

Cool! I _bet_ you will find a lot of bugs ;)

Oleg.

