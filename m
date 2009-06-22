Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZFVPFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZFVPFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZFVPFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:05:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44077 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbZFVPFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:05:07 -0400
Subject: Re: [Patch] mm tracepoints update - use case.
From: Larry Woodman <lwoodman@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?Q?Fr=E9=A6=98=E9=A7=BBic?= Weisbecker 
	<fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rostedt@goodmis.org
In-Reply-To: <20090622122755.21F6.A69D9226@jp.fujitsu.com>
References: <1245352954.3212.67.camel@dhcp-100-19-198.bos.redhat.com>
	 <4A3A9844.8030004@redhat.com> <20090622122755.21F6.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 11:04:17 -0400
Message-Id: <1245683057.3212.89.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 12:37 +0900, KOSAKI Motohiro wrote:

Thanks for the feedback KOSAKI!


> > Larry Woodman wrote:
> > 
> > >> - Please don't display mm and/or another kernel raw pointer.
> > >>   if we assume non stop system, we can't use kernel-dump. Thus kernel pointer
> > >>   logging is not so useful.
> > > 
> > > OK, I just dont know how valuable the trace output is with out some raw
> > > data like the mm_struct.
> > 
> > I believe that we do want something like the mm_struct in
> > the trace info, so we can figure out which process was
> > allocating pages, etc...
> 
> Yes.
> I think we need to print tgid, it is needed to imporove CONFIG_MM_OWNER.
> current CONFIG_MM_OWNER back-pointer point to semi-random task_struct.

All of the tracepoints contain command, pid, CPU and timestamp and
tracepoint name information.  Are you saying I should capture more
information in specific mm tracepoints like the tgid and if the answer
is yes, what would we need this for?


cat-10962 [005]  1877.984589: mm_anon_fault:
cat-10962 [005]  1877.984638: mm_anon_fault:
cat-10962 [005]  1877.984658: sched_switch:
cat-10962 [005]  1877.988359: sched_switch:

> 
> 
> > >> - Please consider how do this feature works on mem-cgroup.
> > >>   (IOW, please don't ignore many "if (scanning_global_lru())")
> > 
> > Good point, we want to trace cgroup vs non-cgroup reclaims,
> > too.
> 
> thank you.

All of the mm tracepoints are located above the cgroup specific calls.
This means that they will capture the same exact data reguardless of
whether cgroups are used or not.  Are you saying I should capture
whether the data was specific to a cgroup or it was from the global
LRUs?

  
> 
> > 
> > >> - tracepoint caller shouldn't have any assumption of displaying representation.
> > >>   e.g.
> > >>     wrong)  trace_mm_pagereclaim_pgout(mapping, page->index<<PAGE_SHIFT, PageAnon(page));
> > >>     good)   trace_mm_pagereclaim_pgout(mapping, page)
> > > 
> > > OK.
> > > 
> > >>   that's general and good callback and/or hook manner.
> > 
> > How do we figure those out from the page pointer at the time
> > the tracepoint triggers?
> > 
> > I believe that it would be useful to export that info in the
> > trace point, since we cannot expect the userspace trace tool
> > to figure out these things from the struct page address.
> > 
> > Or did I overlook something here?
> 
> current, TRACE_EVENT have two step information trasformation.
> 
>  - step1 - TP_fast_assign()
>    it is called from tracepoint directly. it makes ring-buffer representaion.
>  - step2 - TP_printk
>    it is called when reading debug/tracing/trace file. it makes printable
>    representation from ring-buffer data.
> 
> example:
> 
> trace_sched_switch() has three argument, rq, prev, next.
> 
> --------------------------------------------------
> static inline void
> context_switch(struct rq *rq, struct task_struct *prev,
>                struct task_struct *next)
> {
> (snip)
>         trace_sched_switch(rq, prev, next);
> 
> -------------------------------------------------
> 
> TP_fast_assing extract data from argument pointer.
> -----------------------------------------------------
>         TP_fast_assign(
>                 memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
>                 __entry->prev_pid       = prev->pid;
>                 __entry->prev_prio      = prev->prio;
>                 __entry->prev_state     = prev->state;
>                 memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
>                 __entry->next_pid       = next->pid;
>                 __entry->next_prio      = next->prio;
>         ),
> -----------------------------------------------------
> 
> 
> I think mm tracepoint can do the same way.

The sched_switch tracepoint tells us the name of the outgoing and
incomming process during a context switch so this information is very
significant to that tracepoint.  What mm tracepoint would I need to add
such information without it being redundant?

Thanks, Larry Woodman

> 
> 
> 
> 

