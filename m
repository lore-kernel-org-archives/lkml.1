Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbXHGHUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbXHGHUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 03:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbXHGHTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 03:19:54 -0400
Received: from ozlabs.org ([203.10.76.45]:33984 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbXHGHTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 03:19:53 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 07 Aug 2007 17:19:45 +1000
Subject: [RFC/PATCH 0/12] WIP mmu_gather and PTE accessors work
Message-Id: <1186471185.826251.312410898174.qpush@grosgo>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a snapshot of my current work on PTE accessors and
mmu_gather. It's not complete but it should show the direction
I'm heading toward.

The main goals are:

 - Make mmu_gather used for all page table walk operations that
also need to invalidate TLB entries, thus obsoleting flush_tlb_range()
and flush_tlb_mm() as generic APIs to the TLB flushing.

 - Make mmu_gather stack based. The cleans quite a bit of stuff up,
and once fully done, should allow to reduce latencies caused by the
need to use get_cpu() for a long time.

 - Make mmu_gather more flexible so that archs who need to do more than
what the standard implementation does don't have to copy all of it and
do their own implementation.

 - Make mmu_gather suitable for batching on powerpc :-) This involves
mostly adding a hook before PTE pages are unlocked and some work on
the interaction between PTE accessors and tlb_remove_tlb_entry()

 - Remove other remaings of flush_tlb_*, keeping only for now
flush_tlb_kernel_range() which will be harder to "fix" (provided we
want to do it at all)

 - Go through all remaining page table accessors, remove all the unused
ones (there's still a few), there should be only a handful left and redo
the documentation accordingly.

These goals are _NOT_ yet met by this patch serie and some of the bits
in there may want to be done a bit differently. As I did the patches,
and hacked various archs, I got a better visibility on what is done and
why and thus some of my initial directions end up not looking so good.

Most notably, the MMF_DEAD flag doesn't sound like such a good idea
anymore and I'm considering instead replacing ptep_get_and_clear()
and tlb_remove_tlb_entry() with a version that takes the batch as an
argument.

Also, I haven't fully moved the batch off the per-cpu, only "part 1" is
there at this stage.

However, I'll be travelling for a while and won't have much time to work
on it until I'm back mid september, so I decided now was a good time to
post what I have for comments and discussions on the approach taken.

Cheers,
Ben.
