Return-Path: <linux-kernel-owner+w=401wt.eu-S1763090AbYD2P5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763090AbYD2P5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYD2P5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:57:34 -0400
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:14121 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631AbYD2P5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:57:33 -0400
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Inc.
To: Glauber Costa <gcosta@redhat.com>
Subject: Re: [PATCH] KVM x86: Handle hypercalls for assigned PCI devices
Date: Tue, 29 Apr 2008 21:28:51 +0530
User-Agent: KMail/1.9.9
Cc: kvm-devel@lists.sourceforge.net, virtualization@lists.linux-foundation.org,
       muli@il.ibm.com, BENAMI@il.ibm.com, chrisw@redhat.com,
       dor.laor@qumranet.com, allen.m.kay@intel.com, avi@qumranet.com,
       linux-kernel@vger.kernel.org
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com> <1209465451-3758-3-git-send-email-amit.shah@qumranet.com> <48173440.304@redhat.com>
In-Reply-To: <48173440.304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804292128.52268.amit.shah@qumranet.com>
X-OriginalArrivalTime: 29 Apr 2008 15:57:32.0595 (UTC) FILETIME=[BC094830:01C8AA11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008 20:14:16 Glauber Costa wrote:
> Amit Shah wrote:

> > +static struct kvm_pv_dma_map*
> > +find_pci_pv_dmap(struct list_head *head, dma_addr_t dma)
> > +{
>
> might be better to prefix those functions with kvm? Even though they are
> static, it seems to be the current practice.

The function names are long enough already. Prefixing everything with kvm_ 
could hurt the eye as well.

> > +	host_page = gfn_to_page(vcpu->kvm, page_gfn);
>
> you need mmap_sem held for read to use gfn_to_page.

Yes; it's going to trickle down soon.

> > +	/* FIXME: guest should send the direction */
> > +	r = dma_ops->map_sg(NULL, sg, npages, PCI_DMA_BIDIRECTIONAL);
> > +	if (r) {
> > +		r = npages;
> > +		*hcall_page = sg[0].dma_address | (*hcall_page & ~PAGE_MASK);
> > +	}
> > +
> > + out_unmap:
> > +	if (!r)
> > +		*hcall_page = bad_dma_address;
> > +	kunmap(host_page);
> > + out:
> > +	++vcpu->stat.hypercall_map;
> > +	return r;
> > + out_unmap_sg_dmap:
> > +	kfree(dmap);
> > + out_unmap_sg:
> > +	kfree(sg);
> > +	goto out_unmap;
>
> those backwards goto are very clumsy. Might be better to give it a
> further attention in order to avoid id.

It does keep everything nicely in one place though. You're right though. Some 
more attention is needed.

> > +static int free_dmap(struct kvm_pv_dma_map *dmap, struct list_head
> > *head) +{
> > +	int i;
> > +
> > +	if (!dmap)
> > +		return 1;
>
> that's ugly.
>
> it's better to keep the free function with free-like semantics: just a
> void function that plainly returns if !dmap, and check in the caller.

I was lazy and used the return value from here to propagate it down further. 
But this kicked me to modify that.

> > +	if (is_error_page(host_page)) {
> > +		printk(KERN_INFO "%s: gfn %p not valid\n",
> > +		       __func__, (void *)page_gfn);
> > +		r = -1;
>
> r = -1 is not really informative. Better use some meaningful error.

The error's going to the guest. The guest, as we know, has already done a 
successful DMA allocation. Something went wrong in the hypercall, and we 
don't know why (bad page). Any kind of error here isn't going to be 
intelligible to the guest anyway. It's mostly a host thing if we ever hit 
this.

> > +	if (find_pci_pt_dev(&vcpu->kvm->arch.pci_pt_dev_head,
> > +			    &pci_pt_info, 0, KVM_PT_SOURCE_ASSIGN))
> > +		r++; /* We have assigned the device */
> > +
> > +	kunmap(host_page);
>
> better use atomic mappings here.

We can't use atomic mappings for guest pages. They can be swapped out.
