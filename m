Return-Path: <linux-kernel-owner+w=401wt.eu-S1765986AbXGYNUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765986AbXGYNUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765512AbXGYNUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:20:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:61804 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765265AbXGYNUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oimdZQy91azrTmifqIAfbYtBYD6Ra/BLceZz4HXPwQAPHfqyOaUZUMjC7mlbEqelgIkzKyJJ/L3AP6zhi1VMpomigq5tb2ct+C+u+ZtkSuvwMC8AcT8TJMdnEuh18PMGy1zN8l0qlORtUu6XmmHZF05xg9C1rwdklsG9cHKv1X4=
Message-ID: <288dbef70707250620u5483d5dbxbcc461f8f685acdc@mail.gmail.com>
Date: Wed, 25 Jul 2007 21:20:17 +0800
From: "Shaohua Li" <shaoh.li@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [kvm-devel] [RFC 7/8]KVM: swap out guest pages
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <288dbef70707250455p656b09cft20ebc7a013e8a76f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185173505.2645.71.camel@sli10-conroe.sh.intel.com>
	 <46A612C8.6090804@qumranet.com>
	 <288dbef70707250455p656b09cft20ebc7a013e8a76f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/25, Shaohua Li <shaoh.li@gmail.com>:
> 2007/7/24, Avi Kivity <avi@qumranet.com>:
> > Shaohua Li wrote:
> > > Make KVM guest pages be allocated dynamically and able to be swaped out.
> > >
> > > One issue: all inodes returned from anon_inode_getfd are shared,
> > > if one module changes field of the inode, other moduels might break.
> > > Should we introduce a new API to not share inode?
> > >
> > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > ---
> > >
> > > +static int kvm_set_page_dirty(struct page *page)
> > > +{
> > > +     if (!PageDirty(page))
> > > +             SetPageDirty(page);
> > > +     return 0;
> > > +}
> > > +
> > > +static int kvm_writepage(struct page *page, struct writeback_control *wbc)
> > > +{
> > > +     struct address_space *mapping = page->mapping;
> > > +     struct kvm *kvm = address_space_to_kvm(mapping);
> > > +     int ret = 0;
> > > +
> > > +     /*
> > > +      * gfn_to_page is called with kvm->lock hold, which might invoke page
> > > +      * reclaim. So the .writepage should check if we already hold the lock
> > > +      * to avoid deadlock.
> > > +      */
> > > +     if (!mutex_trylock(&kvm->lock)) {
> > > +             set_page_dirty(page);
> > > +             return AOP_WRITEPAGE_ACTIVATE;
> > > +     }
> > > +
> > > +     /*
> > > +      * We just zap vcpu 0's page table. For a SMP guest, we should zap all
> > > +      * vcpus'. It's better shadow page table is per-vm.
> > > +      */
> > > +     if (PagePrivate(page))
> > > +             kvm_mmu_zap_pagetbl(&kvm->vcpus[0], page->index);
> > > +
> > > +     ret = kvm_move_to_swap(page);
> > > +     if (ret) {
> > > +             set_page_dirty(page);
> > > +             goto out;
> > > +     }
> > > +     unlock_page(page);
> > > +out:
> > > +     mutex_unlock(&kvm->lock);
> > > +
> > > +     return ret;
> > > +}
> > > +
> > >
> >
> > Perhaps we can use this as a base for userspace-allocated memory.  We
> > still have a kvm inode and address_space; but instead of calling
> > kvm_move_to_swap(), we use the memory slot and virtual address offset to
> > locate the underlying address_space and call that ->writepage().
> >
> > So:
> >   kvm_writepage() removes any shadow page table references
> >   the underlying ->writepage() does the work of paging to the underlying
> > store
> So write to a file, right? Yes, it can avoid use move to swap, and
> should be feasible.
Say you want to write guest pages out to file A of back store fs, in
kvm->writepage(), we could do:
1. lower_page = grap_cache_page(file A's mapping)
2. file A's ->prepare_write(lower_page)
3. copy kvm guest page to lower_page
4. file A's ->commit_write(lower_page)
then guest page can be freed. Just like the stack fs does. The
downside is step 1 needs allocate a new page.

Thanks,
Shaohua
