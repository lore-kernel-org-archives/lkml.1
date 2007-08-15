Return-Path: <linux-kernel-owner+w=401wt.eu-S1759347AbXHOMXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbXHOMXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 08:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbXHOMWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:22:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbXHOMWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:22:54 -0400
Date: Wed, 15 Aug 2007 14:22:53 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
Message-ID: <20070815122253.GA15268@wotan.suse.de>
References: <20070814142103.204771292@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814142103.204771292@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 07:21:03AM -0700, Christoph Lameter wrote:
> The following patchset implements recursive reclaim. Recursive reclaim
> is necessary if we run out of memory in the writeout patch from reclaim.
> 
> This is f.e. important for stacked filesystems or anything that does
> complicated processing in the writeout path.

Filesystems (most of them) that require compilcated allocations at
writeout time suck. That said, especially with network ones, it
seems like making them preallocate or reserve required memory isn't
progressing very smoothly. I think these patchsets are definitely
worth considering as an alternative. 

No substantial comments though. I've been sick all week.

 

> Recursive reclaim works because it limits itself to only reclaim pages
> that do not require writeout. It will only remove clean pages from the LRU.
> The dirty throttling of the VM during regular reclaim insures that the amount
> of dirty pages is limited. If recursive reclaim causes too many clean pages
> to be removed then regular reclaim will throttle all processes until the
> dirty ratio is restored. This means that the amount of memory that can
> be reclaimed via recursive reclaim is limited to clean memory. The default
> ratio is 10%. This means that recursive reclaim can reclaim 90% of memory
> before failing. Reclaiming excessive amounts of clean pages may have a
> significant performance impact because this means that executable pages
> will be removed. However, it ensures that we will no longer fail in the
> writeout path.
> 
> A patch is included to test this functionality. The test involved allocating
> 12 Megabytes from the reclaim paths when __PF_MEMALLOC is set. This is enough
> to exhaust the reserves.
> 
> -- 
