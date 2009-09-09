Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbZIICGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbZIICGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZIICGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:06:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34261 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZIICGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:06:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
Cc: kosaki.motohiro@jp.fujitsu.com, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, linux-mm <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1252411520.7746.68.camel@twins>
References: <20090908193712.0CCF.A69D9226@jp.fujitsu.com> <1252411520.7746.68.camel@twins>
Message-Id: <20090909103617.0CE0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Sep 2009 11:06:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > Thank you for kindly explanation. I gradually become to understand this isssue.
> > Yes, lru_add_drain_all() use schedule_on_each_cpu() and it have following code
> > 
> >         for_each_online_cpu(cpu)
> >                 flush_work(per_cpu_ptr(works, cpu));
> > 
> > However, I don't think your approach solve this issue.
> > lru_add_drain_all() flush lru_add_pvecs and lru_rotate_pvecs.
> > 
> > lru_add_pvecs is accounted when
> >   - lru move
> >       e.g. read(2), write(2), page fault, vmscan, page migration, et al
> > 
> > lru_rotate_pves is accounted when
> >   - page writeback
> > 
> > IOW, if RT-thread call write(2) syscall or page fault, we face the same
> > problem. I don't think we can assume RT-thread don't make page fault....
> > 
> > hmm, this seems difficult problem. I guess any mm code should use
> > schedule_on_each_cpu(). I continue to think this issue awhile.
> 
> This is about avoiding work when there is non, clearly when an
> application does use the kernel it creates work.
> 
> But a clearly userspace, cpu-bound process, while(1), should not get
> interrupted by things like lru_add_drain() when it doesn't have any
> pages to drain.

Yup. makes sense.
So, I think you mean you'd like to tackle this special case as fist step, right?
if yes, I agree.


> > > There is nothing that makes lru_add_drain_all() the only such site, its
> > > the one Mike posted to me, and my patch was a way to deal with that.
> > 
> > Well, schedule_on_each_cpu() is very limited used function.
> > Practically we can ignore other caller.
> 
> No, we need to inspect all callers, having only a few makes that easier.

Sorry my poor english. I meaned I don't oppose your patch approach. I don't oppose
additional work at all.


> 
> > > I also explained that its not only RT related in that the HPC folks also
> > > want to avoid unneeded work -- for them its not starvation but a
> > > performance issue.
> > 
> > I think you talked about OS jitter issue. if so, I don't think this issue
> > make serious problem.  OS jitter mainly be caused by periodic action
> >  (e.g. tick update, timer, vmstat update). it's because
> > 	little-delay x plenty-times = large-delay
> > 
> > lru_add_drain_all() is called from very limited point. e.g. mlock, shm-lock,
> > page-migration, memory-hotplug. all caller is not periodic.
> 
> Doesn't matter, if you want to reduce it, you need to address all of
> them, a process 4 nodes away calling mlock() while this partition has
> been user-bound for the last hour or so and doesn't have any lru pages
> simply needn't be woken.

Doesn't matter? You mean can we stop to discuss hits HPC performance issue
as Christoph pointed out?
hmmm, sorry, I haven't catch your point.



