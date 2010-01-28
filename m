Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828Ab0A1KEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0A1KEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 05:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187Ab0A1KEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 05:04:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab0A1KEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 05:04:37 -0500
Date: Thu, 28 Jan 2010 11:03:27 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>, cl@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Fix unmap_vma() bug related to mmu_notifiers
Message-ID: <20100128100327.GF24242@random.random>
References: <20100125174556.GA23003@sgi.com>
 <20100125190052.GF5756@random.random>
 <20100125211033.GA24272@sgi.com>
 <20100125211615.GH5756@random.random>
 <20100126212904.GE6653@sgi.com>
 <20100126213853.GY30452@random.random>
 <20100128031841.GG6616@sgi.com>
 <20100128034943.GH6616@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128034943.GH6616@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 09:49:44PM -0600, Robin Holt wrote:
> > I think that with the SRCU patch, we have enough.  Is that true or have
> > I missed something?
> 
> I wasn't quite complete in my previous email.  Your srcu patch
> plus Jack's patch to move the tlb_gather_mmu to after the
> mmu_notifier_invalidate_range_start().

My pmdp_clear_flush_notify with transparent hugepage will give some
trouble because it's using mmu_notifier_invalidate_range_start to
provide backwards compatible API to mmu notifier users like GRU that
may be mapping physical hugepages with 4k secondary tlb mappings
(which have to be all invalidated not only the first one). So that
would still require the full series as it's like if the rmap code
would be using mmu_notifier_invalidate_range_start. But we can
probably get away by forcing all mmu notifier methods to provide a
mmu_notifier_invalidate_hugepage.

But in addition to srcu surely you also need i_mmap_lock_to_sem for
unmap_mapping_range_vma taking i_mmap_lock, basically you missed
truncate. Which then in cascade requires free_pgtables,
rwsem-contended, unmap_vmas (the latter are for the tlb gather
required to be in atomic context to avoid scheduling to other cpus
while holding the tlb gather).

So you only avoid the need of anon-vma switching to rwsem (because
there's no range-vmtruncate but only rmap uses it on a page-by-page
basis with mmu_notifier_invalidate_page). So at that point IMHO you
can as well add a CONFIG_MMU_NOTIFIER_SLEEPABLE and allow scheduling
everywhere in mmu notifier IMHO, but if you prefer to avoid changing
anon_vma lock to rwsem and add refcounting that is ok with me too. I
just think it'd be cleaner to switch them all to sleepable code if we
have to provide for it and most of the work on the i_mmap_lock side is
mandatory anyway.
