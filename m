Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab0BPH31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 02:29:27 -0500
Received: from smtp-out.google.com ([216.239.33.17]:44042 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab0BPH30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 02:29:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=pDRV2zbU5V0DpijP78KmDfU8vKhmJ4Q/fd9EkaORUPcgC1OskKPURptwCiiyhbwmz
	0p0sxIkEwD8NfX6wT5SZA==
Date: Mon, 15 Feb 2010 23:29:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 8/9 v2] oom: avoid oom killer for lowmem
 allocations
In-Reply-To: <20100216142856.72F4.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002152324140.7470@chino.kir.corp.google.com>
References: <20100216085706.c7af93e1.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002151606320.14484@chino.kir.corp.google.com> <20100216142856.72F4.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, KOSAKI Motohiro wrote:

> No current user? I don't think so.
> 
> 	int bio_integrity_prep(struct bio *bio)
> 	{
> 	(snip)
> 	        buf = kmalloc(len, GFP_NOIO | __GFP_NOFAIL | q->bounce_gfp);
> 
> and 
> 
> 	void blk_queue_bounce_limit(struct request_queue *q, u64 dma_mask)
> 	{
> 	(snip)
> 	        if (dma) {
> 	                init_emergency_isa_pool();
> 	                q->bounce_gfp = GFP_NOIO | GFP_DMA;
> 	                q->limits.bounce_pfn = b_pfn;
> 	        }
> 
> 
> 
> I don't like rumor based discussion, I like fact based one.
> 

The GFP_NOIO will prevent the oom killer from being called, it requires 
__GFP_FS.

I can change this to invoke the should_alloc_retry() logic by testing for 
!(gfp_mask & __GFP_NOFAIL), but there's nothing else the page allocator 
can currently do to increase its probability of allocating pages; the 
memory compaction patchset might be particularly helpful for these types 
of scenarios.
