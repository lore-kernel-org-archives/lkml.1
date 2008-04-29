Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbYD2OwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbYD2OwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYD2OwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:52:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYD2OwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:52:05 -0400
Message-ID: <48173440.304@redhat.com>
Date: Tue, 29 Apr 2008 11:44:16 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Amit Shah <amit.shah@qumranet.com>
CC: kvm-devel@lists.sourceforge.net, virtualization@lists.linux-foundation.org,
       muli@il.ibm.com, BENAMI@il.ibm.com, chrisw@redhat.com,
       dor.laor@qumranet.com, allen.m.kay@intel.com, avi@qumranet.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM x86: Handle hypercalls for assigned PCI devices
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com> <1209465451-3758-2-git-send-email-amit.shah@qumranet.com> <1209465451-3758-3-git-send-email-amit.shah@qumranet.com>
In-Reply-To: <1209465451-3758-3-git-send-email-amit.shah@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah wrote:
> We introduce three hypercalls:
> 1. When the guest wants to check if a particular device is an assigned device
>    (this is done once per device by the guest to enable / disable hypercall-
>    based translation of addresses)
> 
> 2. map: to convert guest phyical addresses to host physical address to pass on
>    to the device for DMA. We also pin the pages thus requested so that they're
>    not swapped out.
> 
> 3. unmap: to unpin the pages and free any information we might have stored.
> 
> Signed-off-by: Amit Shah <amit.shah@qumranet.com>
> ---
>  arch/x86/kvm/x86.c         |  211 +++++++++++++++++++++++++++++++++++++++++++-
>  include/asm-x86/kvm_host.h |   15 +++
>  include/asm-x86/kvm_para.h |    8 ++
>  3 files changed, 233 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb9b329..94ee4db 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -24,8 +24,11 @@
>  #include <linux/interrupt.h>
>  #include <linux/kvm.h>
>  #include <linux/fs.h>
> +#include <linux/list.h>
> +#include <linux/pci.h>
>  #include <linux/vmalloc.h>
>  #include <linux/module.h>
> +#include <linux/highmem.h>
>  #include <linux/mman.h>
>  #include <linux/highmem.h>
>  
> @@ -76,6 +79,9 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	{ "halt_exits", VCPU_STAT(halt_exits) },
>  	{ "halt_wakeup", VCPU_STAT(halt_wakeup) },
>  	{ "hypercalls", VCPU_STAT(hypercalls) },
> +	{ "hypercall_map", VCPU_STAT(hypercall_map) },
> +	{ "hypercall_unmap", VCPU_STAT(hypercall_unmap) },
> +	{ "hypercall_pv_dev", VCPU_STAT(hypercall_pv_dev) },
>  	{ "request_irq", VCPU_STAT(request_irq_exits) },
>  	{ "irq_exits", VCPU_STAT(irq_exits) },
>  	{ "host_state_reload", VCPU_STAT(host_state_reload) },
> @@ -95,9 +101,164 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	{ NULL }
>  };
>  
> +static struct kvm_pv_dma_map*
> +find_pci_pv_dmap(struct list_head *head, dma_addr_t dma)
> +{
might be better to prefix those functions with kvm? Even though they are 
static, it seems to be the current practice.

> +static int pv_map_hypercall(struct kvm_vcpu *vcpu, int npages, gfn_t page_gfn)
> +{
> +	int i, r = 0;
> +	struct page *host_page;
> +	struct scatterlist *sg;
> +	struct kvm_pv_dma_map *dmap;
> +	unsigned long *shared_addr, *hcall_page;
> +
> +	/* We currently don't support dma mappings which have more than
> +	 * PAGE_SIZE/sizeof(unsigned long *) pages
> +	 */
> +	if (!npages || npages > MAX_PVDMA_PAGES) {
> +		printk(KERN_INFO "%s: Illegal number of pages: %d\n",
> +		       __func__, npages);
> +		goto out;
> +	}
> +
> +	host_page = gfn_to_page(vcpu->kvm, page_gfn);
you need mmap_sem held for read to use gfn_to_page.

> +	if (is_error_page(host_page)) {
> +		printk(KERN_INFO "%s: Bad gfn %p\n", __func__,
> +		       (void *)page_gfn);
> +		goto out;
> +	}
> +	hcall_page = shared_addr = kmap(host_page);
> +
> +	/* scatterlist to map guest dma pages into host physical
> +	 * memory -- if they exceed the DMA map limit
> +	 */
> +	sg = kcalloc(npages, sizeof(struct scatterlist), GFP_KERNEL);
> +	if (sg == NULL) {
> +		printk(KERN_INFO "%s: Couldn't allocate memory (sg)\n",
> +		       __func__);
> +		goto out_unmap;
> +	}
> +
> +	/* List to store all guest pages mapped into host. This will
> +	 * be used later to free pages on the host. Think of this as a
> +	 * translation table from guest dma addresses into host dma
> +	 * addresses
> +	 */
> +	dmap = kzalloc(sizeof(*dmap), GFP_KERNEL);
> +	if (dmap == NULL) {
> +		printk(KERN_INFO "%s: Couldn't allocate memory\n",
> +		       __func__);
> +		goto out_unmap_sg;
> +	}
> +
> +	/* FIXME: consider the length of the last page. Guest should
> +	 * send this info.
> +	 */
> +	for (i = 0; i < npages; i++) {
> +		struct page *page;
> +		gpa_t gpa;
> +
> +		gpa = *shared_addr++;
> +		page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
care for locking here too.

> +		if (is_error_page(page)) {
> +			int j;
> +			printk(KERN_INFO "kvm %s: gpa %p not valid\n",
> +			       __func__, (void *)gpa);
> +
> +			for (j = 0; j < i; j++)
> +				put_page(sg_page(&sg[j]));
> +			goto out_unmap_sg_dmap;
> +		}
> +		prepare_sg_entry(&sg[i], page);
> +		get_page(sg_page(&sg[i]));
> +	}
> +
> +	/* Put this on the dmap_head list, so that we can find it
> +	 * later for the 'free' operation
> +	 */
> +	dmap->sg = sg;
> +	dmap->nents = npages;
> +	list_add(&dmap->list, &vcpu->kvm->arch.pci_pv_dmap_head);
> +
> +	/* FIXME: guest should send the direction */
> +	r = dma_ops->map_sg(NULL, sg, npages, PCI_DMA_BIDIRECTIONAL);
> +	if (r) {
> +		r = npages;
> +		*hcall_page = sg[0].dma_address | (*hcall_page & ~PAGE_MASK);
> +	}
> +
> + out_unmap:
> +	if (!r)
> +		*hcall_page = bad_dma_address;
> +	kunmap(host_page);
> + out:
> +	++vcpu->stat.hypercall_map;
> +	return r;
> + out_unmap_sg_dmap:
> +	kfree(dmap);
> + out_unmap_sg:
> +	kfree(sg);
> +	goto out_unmap;
those backwards goto are very clumsy. Might be better to give it a 
further attention in order to avoid id.

> +}
> +
> +static int free_dmap(struct kvm_pv_dma_map *dmap, struct list_head *head)
> +{
> +	int i;
> +
> +	if (!dmap)
> +		return 1;
that's ugly.

it's better to keep the free function with free-like semantics: just a 
void function that plainly returns if !dmap, and check in the caller.

> +static int
> +pv_mapped_pci_device_hypercall(struct kvm_vcpu *vcpu, gfn_t page_gfn)
> +{
> +	int r = 0;
> +	unsigned long *shared_addr;
> +	struct page *host_page;
> +	struct kvm_pci_pt_info pci_pt_info;
> +
> +	host_page = gfn_to_page(vcpu->kvm, page_gfn);
locking
> +	if (is_error_page(host_page)) {
> +		printk(KERN_INFO "%s: gfn %p not valid\n",
> +		       __func__, (void *)page_gfn);
> +		r = -1;
r = -1 is not really informative. Better use some meaningful error.

We can return here, and avoid this goto if we always increment the 
hypercall counter in the beginning of the function. But this is nitpicking.

> +		goto out;
> +	}
> +	shared_addr = kmap(host_page);
> +	memcpy(&pci_pt_info, shared_addr, sizeof(pci_pt_info));
> +
> +	if (find_pci_pt_dev(&vcpu->kvm->arch.pci_pt_dev_head,
> +			    &pci_pt_info, 0, KVM_PT_SOURCE_ASSIGN))
> +		r++; /* We have assigned the device */
> +
> +	kunmap(host_page);
better use atomic mappings here.

