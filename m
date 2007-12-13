Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbXLMVBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbXLMVBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbXLMVBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:01:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:24236 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbXLMVBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:01:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="237353070"
Date: Thu, 13 Dec 2007 12:54:17 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Asit Mallick <asit.k.mallick@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: What was the problem with quicklists and x86-64?
Message-ID: <20071213205416.GA15807@linux-os.sc.intel.com>
References: <47603321.4030700@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47603321.4030700@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 11:14:41AM -0800, Jeremy Fitzhardinge wrote:
> I'm looking at unifying the various pgalloc+pgd_lists mechanisms between
> 32-bit (PAE and non-PAE) and 64-bit, so I'm trying to understand why
> these differences exist in the first place.
> 
> Change da8f153e51290e7438ba7da66234a864e5d3e1c1 reverted the use of
> quicklists for allocating pagetables, because of concerns about ordering
> with respect to tlb flushes.

Main thing to note is, while unmapping linear address space, we should not
free underlying pages, page table pages (for all hierarchies), till we flush
the active TLB caches in all the CPUs.

Violation of this can potentially cause SW failures and hard to debug issues
like
http://www.ussg.iu.edu/hypermail/linux/kernel/0205.2/1254.html

For more info, you can refer 
http://developer.intel.com/design/processor/applnots/317080.pdf

> Some questions about this:
> 
>    1. What's the difference between quicklists and normal page
>       allocation with respect to tlb flushing?

Linus and Christoph went in detail about this.

http://kerneltrap.org/mailarchive/linux-kernel/2007/9/21/271638

There were some preemption and other concerns that Linus mentioned,
and was referring to of integrating quicklists and mmu_gather operations
and not keep them separate.

>    2. Why doesn't this also affect i386's use of quicklists?
>    3. Is there some way to resolve this tlb interaction so that
>       quicklists can be used?
>    4. Failing that, what's the cost of reverting i386's use of
>       quicklists too?

I have to look at i386 code but I don't think it was using quicklists
as extensively as the previous x86_64 code does. Will take a look at it.

thanks,
suresh
