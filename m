Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbXH1Jbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbXH1Jbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 05:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbXH1Jbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 05:31:38 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:44170 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbXH1Jbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 05:31:37 -0400
Date: Tue, 28 Aug 2007 10:30:42 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fix bogus hotplug cpu warning
In-Reply-To: <20070828090709.GA24578@elte.hu>
Message-ID: <Pine.LNX.4.64.0708281022440.17987@blonde.wat.veritas.com>
References: <20070828090709.GA24578@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007, Ingo Molnar wrote:
> this commit:
> 
>  commit d243769d3f83b318813a04a9592bb7cfedc6c280
>  Author: Hugh Dickins <hugh@veritas.com>
>  Date:   Mon Aug 27 16:06:19 2007 +0100
> 
>     fix bogus hotplug cpu warning
> 
>     Fix bogus DEBUG_PREEMPT warning on x86_64, when cpu brought online 
>     after bootup: current_is_keventd is right to note its use of 
>     smp_processor_id is preempt-safe, but should use 
>     raw_smp_processor_id to avoid the warning.
> 
> -       int cpu = smp_processor_id();   /* preempt-safe: keventd is per-cpu */
> +       int cpu = raw_smp_processor_id(); /* preempt-safe: keventd is per-cpu */
> 
> is incorrect. smp_processor_id() will _not_ warn about true per-cpu 
> tasks:
> 
>         /*
>          * Kernel threads bound to a single CPU can safely use
>          * smp_processor_id():
>          */
>         this_mask = cpumask_of_cpu(this_cpu);
> 
>         if (cpus_equal(current->cpus_allowed, this_mask))
>                 goto out;
> 
> so if this check triggered for the cpu-offline code it's because keventd 
> was _not_ per-cpu (perhaps because the cpu offline code broke its 
> affinity?). So your patch hides a real bug.

No, keventd is properly per-cpu, but the task which is calling
current_is_keventd() is a normal user task, so smp_processor_id()
did warn about it.  It wouldn't make much sense to have a function
current_is_keventd() if you could only call it from a keventd, would
it ;-?  Take a look at it (kernel/workqueue.c), I believe what it does
is unusual (hence that comment about being "preempt-safe") but valid.

Hugh
