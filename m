Return-Path: <linux-kernel-owner+w=401wt.eu-S1764343AbYAaABn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764343AbYAaABn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbYAaABe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:01:34 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60065 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753725AbYAaABd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:01:33 -0500
Date: Wed, 30 Jan 2008 16:01:31 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080130235214.GC7185@v2.random>
Message-ID: <Pine.LNX.4.64.0801301555550.1722@schroedinger.engr.sgi.com>
References: <20080129211759.GV7233@v2.random>
 <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com>
 <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com>
 <20080130000039.GA7233@v2.random> <20080130161123.GS26420@sgi.com>
 <20080130170451.GP7233@v2.random> <20080130173009.GT26420@sgi.com>
 <20080130182506.GQ7233@v2.random> <Pine.LNX.4.64.0801301147330.30568@schroedinger.engr.sgi.com>
 <20080130235214.GC7185@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Andrea Arcangeli wrote:

> > -	void (*invalidate_range)(struct mmu_notifier *mn,
> > +	void (*invalidate_range_begin)(struct mmu_notifier *mn,
> >  				 struct mm_struct *mm,
> > -				 unsigned long start, unsigned long end,
> >  				 int lock);
> > +
> > +	void (*invalidate_range_end)(struct mmu_notifier *mn,
> > +				 struct mm_struct *mm,
> > +				 unsigned long start, unsigned long end);
> >  };
> 
> start/finish/begin/end/before/after? ;)

Well lets pick one and then stick to it.

> I'd drop the 'int lock', you should skip the before/after if
> i_mmap_lock isn't null and offload it to the caller before taking the
> lock. At least for the "after" call that looks a few liner change,
> didn't figure out the "before" yet.

How we offload that? Before the scan of the rmaps we do not have the 
mmstruct. So we'd need another notifier_rmap_callback.

> Given the amount of changes that are going on in design terms to cover
> both XPMEM and GRE, can we split the minimal invalidate_page that
> provides an obviously safe and feature complete mmu notifier code for
> KVM, and merge that first patch that will cover KVM 100%, it will

The obvious solution does not scale. You will have a callback for every 
page and there may be a million of those if you have a 4GB process.

> made so that are extendible in backwards compatible way. I think
> invalidate_page inside ptep_clear_flush is the first fundamental block
> of the mmu notifiers. Then once the fundamental is in and obviously
> safe and feature complete for KVM, the rest can be added very easily
> with incremental patches as far as I can tell. That would be my
> preferred route ;)

We need to have a coherent notifier solution that works for multiple 
scenarios. I think a working invalidate_range would also be required for 
KVM. KVM and GRUB are very similar so they should be able to use the same 
mechanisms and we need to properly document how that mechanism is safe. 
Either both take a page refcount or none.



