Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbZFBIPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbZFBIPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759976AbZFBIOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:14:50 -0400
Received: from smtp-out.google.com ([216.239.45.13]:21235 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469AbZFBIOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:14:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=PnTruJqzMs9iRjNwWa9YtrgZEd22fgEe5M7BTpkCh8wHVUrF00xoQqixRImv1lnIV
	J5GNgIyzb2ib3oMWeOVtA==
Date: Tue, 2 Jun 2009 01:14:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <20090602075836.GB16201@wotan.suse.de>
Message-ID: <alpine.DEB.2.00.0906020104480.27792@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com> <alpine.DEB.2.00.0906011830490.6936@chino.kir.corp.google.com> <20090601225602.3482cd0d.akpm@linux-foundation.org> <alpine.DEB.2.00.0906020016060.24915@chino.kir.corp.google.com>
 <1243928095.23657.5633.camel@twins> <20090602075836.GB16201@wotan.suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Nick Piggin wrote:

> > I would really prefer if we do as Andrew suggests. Both will fix this
> > problem, so I don't see it as a different topic at all.
> 
> Well, his patch, as it stands, is a good one. Because we do have
> potential higher order GFP_NOFAIL.
> 

There's currently an inconsistency in the definition of __GFP_NOFAIL and 
its implementation.  The clearly defined purpose of the flag is:

 * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
 * cannot handle allocation failures.

Yet __GFP_NOFAIL allocations may fail if no progress is made via direct 
reclaim and order > PAGE_ALLOC_COSTLY_ORDER.  That's the behavior in the 
git HEAD and Mel's allocator rework in mmotm.

I've been addressing this implicitly by requiring __GFP_NOFAIL to always 
abide by the definition: we simply can never return NULL because the 
caller can't handle it (and, by definition, shouldn't even be responsible 
for considering it).

With my patch, we kill a memory hogging task that will free some memory so 
the allocation will succeed (or multiple tasks if insufficient contiguous 
memory is available).  Kernel allocations use __GFP_NOFAIL, so the fault 
of this memory freeing is entirely on the caller, not the page allocator.

My preference for handling this is to merge my patch (obviously :), and 
then hopefully deprecate __GFP_NOFAIL as much as possible although I don't 
suspect it could be eradicated forever.
