Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbZBFQum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbZBFQum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZBFQuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:50:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56535 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbZBFQuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:50:04 -0500
Date: Fri, 6 Feb 2009 17:46:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
Message-ID: <20090206164649.GA24887@redhat.com>
References: <497838F0.7020408@cn.fujitsu.com> <20090122093046.GC5891@nowhere> <20090122093649.GD24758@elte.hu> <c62985530901220306p78ea541cs28912a844297b304@mail.gmail.com> <1232622615.4890.114.camel@laptop> <498AA0F1.2030003@cn.fujitsu.com> <20090205170156.GA25517@redhat.com> <498B9055.8020407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B9055.8020407@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06, Lai Jiangshan wrote:
>
> Oleg Nesterov wrote:
> > On 02/05, Lai Jiangshan wrote:
> >> DEADLOCK EXAMPLE for explain my above option:
> >>
> >> (work_func0() and work_func1() are work callback, and they
> >> calls flush_workqueue())
> >>
> >> CPU#0					CPU#1
> >> run_workqueue()                         run_workqueue()
> >>   work_func0()                            work_func1()
> >>     flush_workqueue()                       flush_workqueue()
> >>       flush_cpu_workqueue(0)                  .
> >>       flush_cpu_workqueue(cpu#1)              flush_cpu_workqueue(cpu#0)
> >>         waiting work_func1() in cpu#1           waiting work_func0 in cpu#0
> >>
> >> DEADLOCK!
> >
> > I am not sure. Note that when work_func0() calls run_workqueue(),
> > it will clear cwq->current_work, so another flush_ on CPU#1 will
> > not wait for work_func0, no?
>
> cwq->current_work is changed only when
> !list_empty(&cwq->worklist)
> in run_workqueue().
>
> so cwq->current_work may not be changed.

Ah, indeed.

Thanks for correcting me!

Oleg.

