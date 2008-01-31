Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbYAaKwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbYAaKwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760762AbYAaKwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:52:45 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:54567
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbYAaKwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:52:44 -0500
Date: Thu, 31 Jan 2008 11:52:41 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       steiner@sgi.com, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [patch 2/6] mmu_notifier: Callbacks to invalidate
	address ranges
Message-ID: <20080131105241.GH7185@v2.random>
References: <20080130000039.GA7233@v2.random> <20080130161123.GS26420@sgi.com> <20080130170451.GP7233@v2.random> <20080130173009.GT26420@sgi.com> <20080130182506.GQ7233@v2.random> <Pine.LNX.4.64.0801301147330.30568@schroedinger.engr.sgi.com> <20080130235214.GC7185@v2.random> <Pine.LNX.4.64.0801301555550.1722@schroedinger.engr.sgi.com> <20080131003434.GE7185@v2.random> <Pine.LNX.4.64.0801301728110.2454@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801301728110.2454@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 05:46:21PM -0800, Christoph Lameter wrote:
> Well the GRU uses follow_page() instead of get_user_pages. Performance is 
> a major issue for the GRU. 

GRU is a external TLB, we have to allocate RAM instead but we do it
through the regular userland paging mechanism. Performance is a major
issue for kvm too, but the result of get_user_pages is used to fill a
spte, so then the cpu will use the spte in hardware to fill its
tlb, we won't have to keep calling follow_page in software to fill the
tlb like GRU has to do, so you can imagine the difference in cpu
utilization spent in those paths (plus our requirement to allocate
memory).

> Hmmmm.. Could we go to a scheme where we do not have to increase the page 
> count? Modifications of the page struct require dirtying a cache line and 

I doubt the atomic_inc is measurable given the rest of overhead like
building the rmap for each new spte.

There's no technical reason for not wanting proper reference counting
other than microoptimization. What will work for GRU will work for KVM
too regardless of whatever reference counting. Each mmu-notifier user
should be free to do what it think it's better/safer or more
convenient (and for anybody calling get_user_pages having the
refcounting on external references is natural and zero additional
cost).

> it seems that we do not need an increased page count if we have an
> invalidate_range_start() that clears all the external references 
> and stops the establishment of new ones and invalidate_range_end() that 
> reenables new external references?
> 
> Then we do not need the frequent invalidate_page() calls.

The increased page count is _mandatory_ to safely use range_start/end
called outside the locks with _end called after releasing the old
page. sptes will build themself the whole time until the pte_clear is
called on the main linux pte. We don't want to clutter the VM fast
paths with additional locks to stop the kvm pagefault while the VM is
in the _range_start/end critical section like xpmem has to do be
safe. So you're contradicting yourself by suggesting not to use
invalidate_page and not to use a increased page count at the same
time. And I need invalidate_page anyway for rmap.c which can't be
provided as an invalidate_range and it can't sleep either.
