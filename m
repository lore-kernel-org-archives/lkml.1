Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbXHUV3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbXHUV3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbXHUV3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:29:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53140 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752226AbXHUV3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:29:45 -0400
Date: Tue, 21 Aug 2007 14:29:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water marks
In-Reply-To: <1187730812.5463.12.camel@lappy>
Message-ID: <Pine.LNX.4.64.0708211418120.3267@schroedinger.engr.sgi.com>
References: <20070820215040.937296148@sgi.com>  <1187692586.6114.211.camel@twins>
  <Pine.LNX.4.64.0708211347480.3082@schroedinger.engr.sgi.com>
 <1187730812.5463.12.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Peter Zijlstra wrote:

> It quickly ends up with all of memory in the laundry list and then
> recursing into __alloc_pages which will fail to make progress and OOMs.

Hmmmm... Okay that needs to be addressed. Reserves need to be used and we 
only should enter reclaim if that runs out (like the first patch that I 
did).

> But aside from the numerous issues with the patch set as presented, I'm
> not seeing the seeing the big picture, why are you doing this.

I want general improvements to reclaim to address the issues that you see 
and other issues related to reclaim instead of the strange code that makes 
PF_MEMALLOC allocs compete for allocations from a single slab and putting 
logic into the kernel to decide which allocs to fail. We can reclaim after 
all. Its just a matter of finding the right way to do this. 

> Anonymous pages are a there to stay, and we cannot tell people how to
> use them. So we need some free or freeable pages in order to avoid the
> vm deadlock that arises from all memory dirty.

No one is trying to abolish Anonymous pages. Free memory is readily 
available on demand if one calls reclaim. Your scheme introduces complex 
negotiations over a few scraps of memory when large amounts of memory 
would still be readily available if one would do the right thing and call 
into reclaim.

> 'Optimizing' this by switching to freeable pages has mainly
> disadvantages IMHO, finding them scrambles LRU order and complexifies
> relcaim and all that for a relatively small gain in space for clean
> pagecache pages.

Sounds like you would like to change the way we handle memory in general 
in the VM? Reclaim (and thus finding freeable pages) is basic to Linux 
memory management.

> Please, stop writing patches and write down a solid proposal of how you
> envision the VM working in the various scenarios and why its better than
> the current approach.

Sorry I just got into this a short time ago and I may need a few cycles 
to get this all straight. An approach that uses memory instead of 
ignoring available memory is certainly better.
