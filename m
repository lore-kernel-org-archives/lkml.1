Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0BLKG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 05:06:56 -0500
Received: from smtp-out.google.com ([216.239.33.17]:56304 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0BLKGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 05:06:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=TZsLxHwFteamItTbZGlogO6WsQO4KhDHMnVRgCi35KlGfqCwEFBT4YD6YI+r7dc8b
	kDqBPrft5Sx/g0H3l6l4g==
Date: Fri, 12 Feb 2010 02:06:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 6/7 -mm] oom: avoid oom killer for lowmem allocations
In-Reply-To: <20100212102841.fa148baf.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002120200050.22883@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100229410.8001@chino.kir.corp.google.com> <20100212102841.fa148baf.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010, KAMEZAWA Hiroyuki wrote:

> From viewpoint of panic-on-oom lover, this patch seems to cause regression.
> please do this check after sysctl_panic_on_oom == 2 test.
> I think it's easy. So, temporary Nack to this patch itself.
> 
> 
> And I think calling notifier is not very bad in the situation.
> ==
> void out_of_memory()
>  ..snip..
>   blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
> 
> 
> So,
> 
>         if (sysctl_panic_on_oom == 2) {
>                 dump_header(NULL, gfp_mask, order, NULL);
>                 panic("out of memory. Compulsory panic_on_oom is selected.\n");
>         }
> 
> 	if (gfp_zone(gfp_mask) < ZONE_NORMAL) /* oom-kill is useless if lowmem is exhausted. */
> 		return;
> 
> is better. I think.
> 

I can't agree with that assessment, I don't think it's a desired result to 
ever panic the machine regardless of what /proc/sys/vm/panic_on_oom is set 
to because a lowmem page allocation fails especially considering, as 
mentioned in the changelog, these allocations are never __GFP_NOFAIL and 
returning NULL is acceptable.

I've always disliked panicking the machine when a cpuset or mempolicy 
allocation fails and panic_on_oom is set to 2.  Since both such 
constraints now force an iteration of the tasklist when oom_kill_quick is 
not enabled and we strictly prohibit the consideration of tasks with 
disjoint cpuset mems or mempolicy nodes, I think I'll take this 
opportunity to get rid of the panic_on_oom == 2 behavior and ask that 
users who really do want to panic the entire machine for cpuset or 
mempolicy constrained ooms to simply set all such tasks to OOM_DISABLE.
