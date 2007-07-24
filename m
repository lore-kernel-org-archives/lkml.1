Return-Path: <linux-kernel-owner+w=401wt.eu-S932604AbXGXOza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbXGXOza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758198AbXGXOy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:54:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:51779 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbXGXOy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:54:56 -0400
Message-ID: <46A612C8.6090804@qumranet.com>
Date: Tue, 24 Jul 2007 17:55:04 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 7/8]KVM: swap out guest pages
References: <1185173505.2645.71.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1185173505.2645.71.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> Make KVM guest pages be allocated dynamically and able to be swaped out.
>
> One issue: all inodes returned from anon_inode_getfd are shared,
> if one module changes field of the inode, other moduels might break.
> Should we introduce a new API to not share inode?
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  
> +static int kvm_set_page_dirty(struct page *page)
> +{
> +	if (!PageDirty(page))
> +		SetPageDirty(page);
> +	return 0;
> +}
> +
> +static int kvm_writepage(struct page *page, struct writeback_control *wbc)
> +{
> +	struct address_space *mapping = page->mapping;
> +	struct kvm *kvm = address_space_to_kvm(mapping);
> +	int ret = 0;
> +
> +	/*
> +	 * gfn_to_page is called with kvm->lock hold, which might invoke page
> +	 * reclaim. So the .writepage should check if we already hold the lock
> +	 * to avoid deadlock.
> +	 */
> +	if (!mutex_trylock(&kvm->lock)) {
> +		set_page_dirty(page);
> +		return AOP_WRITEPAGE_ACTIVATE;
> +	}
> +
> +	/*
> +	 * We just zap vcpu 0's page table. For a SMP guest, we should zap all
> + 	 * vcpus'. It's better shadow page table is per-vm.
> +	 */
> +	if (PagePrivate(page))
> +		kvm_mmu_zap_pagetbl(&kvm->vcpus[0], page->index);
> +
> +	ret = kvm_move_to_swap(page);
> +	if (ret) {
> +		set_page_dirty(page);
> +		goto out;
> +	}
> +	unlock_page(page);
> +out:
> +	mutex_unlock(&kvm->lock);
> +
> +	return ret;
> +}
> +
>   

Perhaps we can use this as a base for userspace-allocated memory.  We 
still have a kvm inode and address_space; but instead of calling 
kvm_move_to_swap(), we use the memory slot and virtual address offset to 
locate the underlying address_space and call that ->writepage().

So:
  kvm_writepage() removes any shadow page table references
  the underlying ->writepage() does the work of paging to the underlying 
store

We need to figure out how to avoid the underlying ->writepage() from not 
within the context of kvm_writepage().  Maybe have a page flag 
signifying layered address spaces?

[it probably violates fifteen different mm assumptions; I need to study 
that code]

An alternative would be to have kvm set a page flag signifying it has 
references to the page when it installs it in a shadow pte.  The mm 
would notice the flag and call kvm to clear it below proceeding with 
normal ->writepage().

-- 
error compiling committee.c: too many arguments to function

