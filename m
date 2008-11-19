Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYKSU7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYKSU7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYKSU7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:59:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYKSU7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:59:07 -0500
Subject: Re: [patch] sched: add locking when update the task_group's
	cfs_rq[]  array.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ken Chen <kenchen@google.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
In-Reply-To: <b040c32a0811190921g557edc4dy4725fb86107c2c54@mail.gmail.com>
References: <b040c32a0811182248s1174c82avf44c720ae2d14804@mail.gmail.com>
	 <1227113662.29743.46.camel@lappy.programming.kicks-ass.net>
	 <b040c32a0811190921g557edc4dy4725fb86107c2c54@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 21:58:50 +0100
Message-Id: <1227128331.29743.61.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 09:21 -0800, Ken Chen wrote:
> On Wed, Nov 19, 2008 at 8:54 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2008-11-18 at 22:48 -0800, Ken Chen wrote:
> >> add locking when update the task_group's cfs_rq[] array.  tg_shares_up()
> >> can be potentially executed concurrently on multiple CPUs with overlaping
> >> cpu mask depending on where task_cpu() was when a task got woken up.  Lack
> >> of any locking while redistribute tg->shares over cfs_rq[] array opens up
> >> a large window for conflict updates and utimately cause corruptions to the
> >> integrity of per cpu cfs_rq shares. Add a tg_lock to protect the operations.
> >
> > I see why you want to do this, but introducing a global lock makes me
> > sad :/
> 
> I wholly agree on the scalability.  The bigger the system, the more it
> needs to protect the integrity of cfs_rq[]->shares that the sum still
> adds up to tg->shares.  Otherwise, the share distributed on each CPU's
> cfs_rq might go wildly and indirectly leads to fluctuation of
> effective total tg->shares.  However, I have the same doubt that this
> will scale on large CPU system.  Does CFS really have to iterate the
> whole task_group tree?

Yes, sadly. The weight of a per-cpu super-task representation depends on
the group's task distribution over all tasks :/

(Dhaval, could you send Ken a copy of the paper we did on this?)

The idea was that we balance the stuff usng the sched-domain tree and
update it incrementally, and on the top level sched domain fix it all
up.

Will it scale, half-way, I'd say. It races a little, but should
converge. The biggest issue is that we're running with 10 bit fixed
point math, and on large cpu machines you get into granularity problems.



