Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZKQIHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZKQIHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbZKQIHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:07:48 -0500
Received: from smtp-out.google.com ([216.239.33.17]:26123 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbZKQIHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:07:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=KLg4VkX8TVu0A8kbpfy9/YW/lqCwH1JI3ooJbs3z9KGChdGuv0+jbj+gbe+sf6k42
	4nxYLQ0+pcajxRSe/Uiww==
Date: Tue, 17 Nov 2009 00:07:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Kill PF_MEMALLOC abuse
In-Reply-To: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911170004380.1564@chino.kir.corp.google.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009, KOSAKI Motohiro wrote:

> 
> PF_MEMALLOC have following effects.
>   (1) Ignore zone watermark
>   (2) Don't call reclaim although allocation failure, instead return ENOMEM
>   (3) Don't invoke OOM Killer
>   (4) Don't retry internally in page alloc
> 
> Some subsystem paid attention (1) only, and start to use PF_MEMALLOC abuse.
> But, the fact is, PF_MEMALLOC is the promise of "I have lots freeable memory.
> if I allocate few memory, I can return more much meory to the system!".
> Non MM subsystem must not use PF_MEMALLOC. Memory reclaim
> need few memory, anyone must not prevent it. Otherwise the system cause
> mysterious hang-up and/or OOM Killer invokation.
> 
> if many subsystem will be able to use emergency memory without any
> usage rule, it isn't for emergency. it can become empty easily.
> 
> Plus, characteristics (2)-(4) mean PF_MEMALLOC don't fit to general
> high priority memory allocation.
> 
> Thus, We kill all PF_MEMALLOC usage in no MM subsystem.
> 

I agree in principle with removing non-VM users of PF_MEMALLOC, but I 
think it should be left to the individual subsystem maintainers to apply 
or ack since the allocations may depend on the __GFP_NORETRY | ~__GFP_WAIT 
behavior of PF_MEMALLOC.  This could be potentially dangerous for a 
PF_MEMALLOC user if allocations made by the kthread, for example, should 
never retry for orders smaller than PAGE_ALLOC_COSTLY_ORDER or block on 
direct reclaim.
