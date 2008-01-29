Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYA2VxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYA2VxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYA2VxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:53:09 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41373 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753243AbYA2VxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:53:07 -0500
Date: Tue, 29 Jan 2008 13:53:05 -0800 (PST)
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
In-Reply-To: <20080129213604.GW7233@v2.random>
Message-ID: <Pine.LNX.4.64.0801291343530.26824@schroedinger.engr.sgi.com>
References: <20080128202840.974253868@sgi.com> <20080128202923.849058104@sgi.com>
 <20080129162004.GL7233@v2.random> <20080129182831.GS7233@v2.random>
 <Pine.LNX.4.64.0801291219030.25629@schroedinger.engr.sgi.com>
 <20080129213604.GW7233@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Andrea Arcangeli wrote:

> > We invalidate the range *after* populating it? Isnt it okay to establish 
> > references while populate_range() runs?
> 
> It's not ok because that function can very well overwrite existing and
> present ptes (it's actually the nonlinear common case fast path for
> db). With your code the sptes created between invalidate_range and
> populate_range, will keep pointing forever to the old physical page
> instead of the newly populated one.

Seems though that the mmap_sem is taken for regular vmas writably and will 
hold off new mappings.

> I'm also asking myself if it's a smp race not to call
> mmu_notifier(invalidate_page) between ptep_clear_flush and set_pte_at
> in install_file_pte. Probably not because the guest VM running in a
> different thread would need to serialize outside the install_file_pte
> code with the task running install_file_pte, if it wants to be sure to
> write either all its data to the old or the new page. Certainly doing
> the invalidate_page inside the PT lock was obviously safe but I hope
> this is safe and this can accommodate your needs too.

But that would be doing two invalidates on one pte. One range and one page 
invalidate.

> > > diff --git a/mm/memory.c b/mm/memory.c
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -1639,8 +1639,6 @@ gotten:
> > >  	/*
> > >  	 * Re-check the pte - we dropped the lock
> > >  	 */
> > > -	mmu_notifier(invalidate_range, mm, address,
> > > -				address + PAGE_SIZE - 1, 0);
> > >  	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
> > >  	if (likely(pte_same(*page_table, orig_pte))) {
> > >  		if (old_page) {
> > 
> > What we did is to invalidate the page (?!) before taking the pte lock. In 
> > the lock we replace the pte to point to another page. This means that we 
> > need to clear stale information. So we zap it before. If another reference 
> > is established after taking the spinlock then the pte contents have 
> > changed at the cirtical section fails.
> > 
> > Before the critical section starts we have gotten an extra refcount on the 
> > original page so the page cannot vanish from under us.
> 
> The problem is the missing invalidate_page/range _after_
> ptep_clear_flush. If a spte is built between invalidate_range and
> pte_offset_map_lock, it will remain pointing to the old page
> forever. Nothing will be called to invalidate that stale spte built
> between invalidate_page/range and ptep_clear_flush. This is why for
> the last few days I kept saying the mmu notifiers have to be invoked
> _after_ ptep_clear_flush and never before (remember the export
> notifier?). No idea how you can deal with this in your code, certainly
> for KVM sptes that's backwards and unworkable ordering of operation
> (exactly as backwards are doing the tlb flush before pte_clear in
> ptep_clear_flush, think spte as a tlb, you can't flush the tlb before
> clearing/updating the pte or it's smp unsafe).

Hmmm... So we could only do an invalidate_page here? Drop the strange 
invalidate_range()?

> 
> > > @@ -1676,6 +1674,8 @@ gotten:
> > >  		page_cache_release(old_page);
> > >  unlock:
> > >  	pte_unmap_unlock(page_table, ptl);
> > > +	mmu_notifier(invalidate_range, mm, address,
> > > +				address + PAGE_SIZE - 1, 0);
> > >  	if (dirty_page) {
> > >  		if (vma->vm_file)
> > >  			file_update_time(vma->vm_file);
> > 
> > Now we invalidate the page after the transaction is complete. This means 
> > external pte can persist while we change the pte? Possibly even dirty the 
> > page?
> 
> Yes, and the only reason this can be safe is for the reason explained
> at the top of the email, if the other cpu wants to serialize to be
> sure to write in the "new" page, it has to serialize with the
> page-fault but to serialize it has to wait the page fault to return
> (example: we're not going to call futex code until the page fault
> returns).

Serialize how? mmap_sem?
 
