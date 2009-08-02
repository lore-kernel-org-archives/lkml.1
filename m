Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbZHBHBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbZHBHBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 03:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZHBHBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 03:01:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50581 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbZHBHBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 03:01:21 -0400
Date: Sun, 2 Aug 2009 08:55:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] cpusets: rework guarantee_online_cpus() to fix
	deadlock with cpu_down()
Message-ID: <20090802065504.GA27164@redhat.com>
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com> <20090729212216.GB16970@redhat.com> <20090729230043.GA28175@redhat.com> <4A70FD26.1010800@cn.fujitsu.com> <20090730175108.GC3617@redhat.com> <4A725594.8020205@cn.fujitsu.com> <20090801044236.GA23975@redhat.com> <4A74F767.7060401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A74F767.7060401@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Lai Jiangshan wrote:
>
> Oleg Nesterov wrote:
>
> >
> > 	- do NOT scan cs->parent cpusets. If there are no online CPUs in
> > 	  cs->cpus_allowed, we use cpu_online_mask. This is only possible
> > 	  when we are called by cpu_down() hooks, in that case
> > 	  cpuset_track_online_cpus(CPU_DEAD) will fix things later.
> >
>
>
> We must scan cs->parent cpusets.
> A task is constrained by a cpuset,

Yes, the task esacpes its cpuset. With or without this patch.
Because cs->cpus_allowed has no online CPUs.

> it must be constrained
> this cpuset's parent too.

It will be constained again, after scan_for_empty_cpusets(), no?

The only difference this patch adds is that a task temporary uses
cpu_online_mask when its cs->cpuset_allowed becomes empty. Why
this is so bad? This can only happen when CPU dies and cs becomes
empty, force majeure.

Even without this patch, the task is not actually constrained by
its cs->parent. Yes, we use ->parent->cpus_allowed. But this mask
can be changed right after guarantee_online_cpus() returns. And
since this task does not belong to cs->parent cpuset,
update_tasks_cpumask() will not fix this task. Again, until
cpuset_track_online_cpus().

Could you explain what problem this patch adds?

> cpuset_lock() is not awful at all.

OK it is not awful. But surely it complicates things. And currently
it is buggy.

Oleg.

