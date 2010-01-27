Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099Ab0A0Xku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab0A0Xku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029Ab0A0Xkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:40:49 -0500
Received: from smtp-out.google.com ([216.239.44.51]:50489 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab0A0Xkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:40:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SoU/FSOHIBWrO5tcyGQWYDhUFBeZ/wxORYIg0RsB8igtG2S1ME5HrltmXA39BQIAZ
	ZI9D4msv2ZXkebYYnC4OA==
Date: Wed, 27 Jan 2010 15:40:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, minchan.kim@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
In-Reply-To: <20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1001271511120.4663@chino.kir.corp.google.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com> <20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com> <20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010, KAMEZAWA Hiroyuki wrote:

> Default oom-killer uses badness calculation based on process's vm_size
> and some amounts of heuristics. Some users see proc->oom_score and
> proc->oom_adj to control oom-killed tendency under their server.
> 
> Now, we know oom-killer don't work ideally in some situaion, in PCs. Some
> enhancements are demanded. But such enhancements for oom-killer makes
> incomaptibility to oom-controls in enterprise world. So, this patch
> adds sysctl for extensions for oom-killer. Main purpose is for
> making a chance for wider test for new scheme.
> 

That's insufficient for inclusion in mainline, we don't add new sysctls so 
that new heuristics can be tried out.  It's fine to propose a new sysctl 
to define how the oom killer behaves, but the main purpose would not be 
for testing; rather, it would be to enable options that users within the 
minority would want to use.

I disagree that we should be doing this as a bitmask that defines certain 
oom killer options; we already have three seperate sysctls which also 
enable options: panic_on_oom, oom_kill_allocating_task, and 
oom_dump_tasks.  Either these existing sysctls need to be converted to the 
bitmask, breaking the long-standing legacy support, or you simply need to 
clutter procfs a little more.  I'm slightly biased toward the latter since 
it doesn't require any userspace change and tunables such as panic_on_oom 
have been around for a long time.

 [ Note: it may be possible to consolidate two of these existing sysctls
   down into one: oom_dump_tasks can be enabled by default if the tasklist
   is sufficiently short and the only use-case for oom_kill_allocating_task
   is for machines with enormously long tasklists to prevent unnecessary
   delays in selecting a bad process to kill.  Thus, we could probably
   consolidate these into one sysctl: oom_kill_quick, which would disable
   the tasklist dump and always kill current when invoked. ]

> One cause of OOM-Killer is memory shortage in lower zones.
> (If memory is enough, lowmem_reserve_ratio works well. but..)

I don't understand the reference to lowmem_reserve_ratio here, it may 
reserve lowmem from ~GFP_DMA requests but it does nothing to prevent oom 
conditions from excessive DMA page allocations.

> I saw lowmem-oom frequently on x86-32 and sometimes on ia64 in
> my cusotmer support jobs. If we just see process's vm_size at oom,
> we can never kill a process which has lowmem.

That's not always true, it may end up killing a large consumer of DMA 
memory by chance simply because the heuristics work out that way.  In 
other words, we can't say it will "never" work correctly as it is 
currently implemented.  I agree we can make it smarter, however.

> At last, there will be an oom-serial-killer.
> 

Heh.

> Now, we have per-mm lowmem usage counter. We can make use of it
> to select a good victim.
> 
> This patch does
>   - add sysctl for new bahavior.
>   - add CONSTRAINT_LOWMEM to oom's constraint type.
>   - pass constraint to __badness()

You mean badness()?  Passing the constraint works well for my 
CONSTRAINT_MEMPOLICY patch as well.

>   - change calculation based on constraint. If CONSTRAINT_LOWMEM,
>     use low_rss instead of vmsize.
> 

Nack, we can't simply use the lowmem rss as a baseline because 
/proc/pid/oom_adj, the single most powerful heuristic in badness(), is not 
defined for these dual scenarios.  There may only be a single baseline to 
define for oom_adj, otherwise it will have erradic results depending on 
the context in which the oom killer is called.  It can be used to polarize 
the heuristic depending on the total VM size which may be disadvantageous 
when using lowmem rss as the baseline.

I think the best alternative would be to strongly penalize the badness() 
points for tasks that do not have a lowmem rss when we are constrained by 
CONSTRAINT_LOWMEM, similar to how we penalize tasks not sharing current's 
mems_allowed since it (usually) doesn't help.  We do not necessarily 
always want to kill the task that is consuming the most lowmem for a 
single page allocation; we need to decide how valuable lowmem is in 
relation to overall VM size, however.
