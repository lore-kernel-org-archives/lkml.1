Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYA3Xw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYA3Xw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYA3XwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:52:18 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:42782
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbYA3XwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:52:17 -0500
Date: Thu, 31 Jan 2008 00:52:14 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080130235214.GC7185@v2.random>
References: <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com> <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com> <20080130000039.GA7233@v2.random> <20080130161123.GS26420@sgi.com> <20080130170451.GP7233@v2.random> <20080130173009.GT26420@sgi.com> <20080130182506.GQ7233@v2.random> <Pine.LNX.4.64.0801301147330.30568@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801301147330.30568@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 11:50:26AM -0800, Christoph Lameter wrote:
> Then we have 
> 
> invalidate_range_start(mm)
> 
> and
> 
> invalidate_range_finish(mm, start, end)
> 
> in addition to the invalidate rmap_notifier?
> 
> ---
>  include/linux/mmu_notifier.h |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/include/linux/mmu_notifier.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mmu_notifier.h	2008-01-30 11:49:02.000000000 -0800
> +++ linux-2.6/include/linux/mmu_notifier.h	2008-01-30 11:49:57.000000000 -0800
> @@ -69,10 +69,13 @@ struct mmu_notifier_ops {
>  	/*
>  	 * lock indicates that the function is called under spinlock.
>  	 */
> -	void (*invalidate_range)(struct mmu_notifier *mn,
> +	void (*invalidate_range_begin)(struct mmu_notifier *mn,
>  				 struct mm_struct *mm,
> -				 unsigned long start, unsigned long end,
>  				 int lock);
> +
> +	void (*invalidate_range_end)(struct mmu_notifier *mn,
> +				 struct mm_struct *mm,
> +				 unsigned long start, unsigned long end);
>  };

start/finish/begin/end/before/after? ;)

I'd drop the 'int lock', you should skip the before/after if
i_mmap_lock isn't null and offload it to the caller before taking the
lock. At least for the "after" call that looks a few liner change,
didn't figure out the "before" yet.

Given the amount of changes that are going on in design terms to cover
both XPMEM and GRE, can we split the minimal invalidate_page that
provides an obviously safe and feature complete mmu notifier code for
KVM, and merge that first patch that will cover KVM 100%, it will
cover GRE 90%, and then we add invalidate_range_before/after in a
separate patch and we close the remaining 10% for GRE covering
ptep_get_and_clear or whatever else ptep_*?  The mmu notifiers are
made so that are extendible in backwards compatible way. I think
invalidate_page inside ptep_clear_flush is the first fundamental block
of the mmu notifiers. Then once the fundamental is in and obviously
safe and feature complete for KVM, the rest can be added very easily
with incremental patches as far as I can tell. That would be my
preferred route ;)
