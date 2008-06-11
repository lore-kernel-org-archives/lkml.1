Return-Path: <linux-kernel-owner+w=401wt.eu-S1762674AbYFKQGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762674AbYFKQGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760830AbYFKQGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:06:34 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39939 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbYFKQGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:06:33 -0400
Date: Wed, 11 Jun 2008 20:08:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       menage@google.com, linux-kernel@vger.kernel.org,
       Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: workqueue cpu affinity
Message-ID: <20080611160815.GA150@tv-sign.ru>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com> <1213080240.31518.5.camel@twins> <484E9FE8.9040504@qualcomm.com> <20080610170005.GA6038@tv-sign.ru> <1213118386.19005.9.camel@lappy.programming.kicks-ass.net> <484EE303.9070007@qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484EE303.9070007@qualcomm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10, Max Krasnyansky wrote:
>
> Here is some backgound on this. Full cpu isolation requires some tweaks to the
> workqueue handling. Either the workqueue threads need to be moved (which is my
> current approach), or work needs to be redirected when it's submitted.

_IF_ we have to do this, I think it is much better to move cwq->thread.

> Peter Zijlstra wrote:
> > The advantage of creating a more flexible or fine-grained flush is that
> > large machine also profit from it.
> I agree, our current workqueue flush scheme is expensive because it has to
> schedule on each online cpu. So yes improving flush makes sense in general.

Yes, it is easy to implement flush_work(struct work_struct *work) which
only waits for that work, so it can't hang unless it was enqueued on the
isolated cpu.

But in most cases it is enough to just do

	if (cancel_work_sync(work))
		work->func(work);

Or we can add flush_workqueue_cpus(struct workqueue_struct *wq, cpumask_t *cpu_map).

But I don't think we should change the behaviour of flush_workqueue().

> This will require a bit of surgery across the entire tree. There is a lot of
> code that calls flush_scheduled_work()

Almost all of them should be changed to use cancel_work_sync().

Oleg.

