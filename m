Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZEVTjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZEVTjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbZEVTjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:39:10 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:57130 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbZEVTjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:39:09 -0400
Message-ID: <4A16FFA7.5010005@oracle.com>
Date: Fri, 22 May 2009 12:40:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Pavel Machek <pavel@ucw.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
References: <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <20090514213403.GB14741@elf.ucw.cz> <1242337299.28440.47.camel@nimitz> <20090515130547.GA1976@elf.ucw.cz> <alpine.DEB.1.10.0905151358430.26559@qirst.com> <20090515200213.GA1406@ucw.cz> <alpine.DEB.1.10.0905151713230.26489@qirst.com> <20090519203944.GD1362@ucw.cz> <alpine.DEB.1.10.0905221500390.5204@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0905221500390.5204@qirst.com>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A16FF10.016A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Subject: Remove misleading kernel log entries about "Out of Memory" conditions
> 
> What we traditionally call an "out of memory" failure is mostly not really
> related to having enough physical memory. "out of memory" occurs when the
> memory reclaim attempts fail to provide enough memory for an allocation.
> 
> Typically there is a misconfiguration or kernel bug that is at the root
> of an out of memory issue. The message suggests that the machine does
> not have enough memory which is not true.
> 
> People have done strange things as a result of these messages. Some
> put more physical memory into their machines others limit the memory
> use of their applications with ulimit. Having a clear message avoids
> these reactions.
> 
> So change the messages to describe what actually went wrong.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  mm/oom_kill.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/mm/oom_kill.c
> ===================================================================
> --- linux-2.6.orig/mm/oom_kill.c	2009-05-12 12:37:52.000000000 -0500
> +++ linux-2.6/mm/oom_kill.c	2009-05-12 12:44:36.000000000 -0500
> @@ -387,7 +387,7 @@ static int oom_kill_process(struct task_
>  	struct task_struct *c;
> 
>  	if (printk_ratelimit()) {
> -		printk(KERN_WARNING "%s invoked oom-killer: "
> +		printk(KERN_WARNING "%s invoked process-killer: "
>  			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
>  			current->comm, gfp_mask, order, current->oomkilladj);
>  		task_lock(current);
> @@ -519,7 +519,7 @@ static void __out_of_memory(gfp_t gfp_ma
> 
>  	if (sysctl_oom_kill_allocating_task)
>  		if (!oom_kill_process(current, gfp_mask, order, 0, NULL,
> -				"Out of memory (oom_kill_allocating_task)"))
> +				"Failure to reclaim enough memory (oom_kill_allocating_task)"))
>  			return;
>  retry:
>  	/*
> @@ -534,11 +534,11 @@ retry:
>  	/* Found nothing?!?! Either we hang forever, or we panic. */
>  	if (!p) {
>  		read_unlock(&tasklist_lock);
> -		panic("Out of memory and no killable processes...\n");
> +		panic("Failure to reclaim enough memory and no killable processes...\n");
>  	}
> 
>  	if (oom_kill_process(p, gfp_mask, order, points, NULL,
> -			     "Out of memory"))
> +			     "Memory reclaim failure"))
>  		goto retry;
>  }
> 
> @@ -563,7 +563,7 @@ void pagefault_out_of_memory(void)
>  		goto rest_and_return;
> 
>  	if (sysctl_panic_on_oom)
> -		panic("out of memory from page fault. panic_on_oom is selected.\n");
> +		panic("failure to reclaim enough memory. panic_on_oom is selected.\n");
> 
>  	read_lock(&tasklist_lock);
>  	__out_of_memory(0, 0); /* unknown gfp_mask and order */
> @@ -600,7 +600,7 @@ void out_of_memory(struct zonelist *zone
>  		return;
> 
>  	if (sysctl_panic_on_oom == 2)
> -		panic("out of memory. Compulsory panic_on_oom is selected.\n");
> +		panic("failure to reclaim enough memory. Compulsory panic_on_oom is selected.\n");
> 
>  	/*
>  	 * Check if there were limitations on the allocation (only relevant for
> @@ -617,7 +617,7 @@ void out_of_memory(struct zonelist *zone
> 
>  	case CONSTRAINT_NONE:
>  		if (sysctl_panic_on_oom)
> -			panic("out of memory. panic_on_oom is selected\n");
> +			panic("failure to enough reclaim memory. panic_on_oom is selected\n");

huh?

But I think that normal users won't know what reclaiming memory is anyway,
so the patch doesn't help IMO.

>  		/* Fall-through */
>  	case CONSTRAINT_CPUSET:
>  		__out_of_memory(gfp_mask, order);


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
