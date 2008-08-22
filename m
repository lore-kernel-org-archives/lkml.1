Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbYHVV0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbYHVV0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYHVV0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:26:45 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:44490 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYHVV0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:26:45 -0400
Message-ID: <48AF2DD7.9030902@cs.columbia.edu>
Date: Fri, 22 Aug 2008 17:21:27 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Louis.Rilling@kerlabs.com
CC: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu> <20080821095316.GH581@hawkmoon.kerlabs.com>
In-Reply-To: <20080821095316.GH581@hawkmoon.kerlabs.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Louis for all the comments. Will fix in v3.

Oren.

Louis Rilling wrote:
> On Wed, Aug 20, 2008 at 11:05:15PM -0400, Oren Laadan wrote:
>> For each VMA, there is a 'struct cr_vma'; if the VMA is file-mapped,
>> it will be followed by the file name.  The cr_vma->npages will tell
>> how many pages were dumped for this VMA.  Then it will be followed
>> by the actual data: first a dump of the addresses of all dumped
>> pages (npages entries) followed by a dump of the contents of all
>> dumped pages (npages pages). Then will come the next VMA and so on.
> 
> [...]
> 
>> diff --git a/checkpoint/ckpt_mem.c b/checkpoint/ckpt_mem.c
>> new file mode 100644
>> index 0000000..a23aa29
>> --- /dev/null
>> +++ b/checkpoint/ckpt_mem.c
> 
> [...]
> 
>> +/**
>> + * cr_vma_fill_pgarr - fill a page-array with addr/page tuples for a vma
>> + * @ctx - checkpoint context
>> + * @pgarr - page-array to fill
>> + * @vma - vma to scan
>> + * @start - start address (updated)
>> + */
>> +static int cr_vma_fill_pgarr(struct cr_ctx *ctx, struct cr_pgarr *pgarr,
>> +			     struct vm_area_struct *vma, unsigned long *start)
>> +{
>> +	unsigned long end = vma->vm_end;
>> +	unsigned long addr = *start;
>> +	struct page **pagep;
>> +	unsigned long *addrp;
>> +	int cow, nr, ret = 0;
>> +
>> +	nr = pgarr->nleft;
>> +	pagep = &pgarr->pages[pgarr->nused];
>> +	addrp = &pgarr->addrs[pgarr->nused];
>> +	cow = !!vma->vm_file;
>> +
>> +	while (addr < end) {
>> +		struct page *page;
>> +
>> +		/* simplified version of get_user_pages(): already have vma,
>> +		* only need FOLL_TOUCH, and (for now) ignore fault stats */
>> +
>> +		cond_resched();
>> +		while (!(page = follow_page(vma, addr, FOLL_TOUCH))) {
>> +			ret = handle_mm_fault(vma->vm_mm, vma, addr, 0);
>> +			if (ret & VM_FAULT_ERROR) {
>> +				if (ret & VM_FAULT_OOM)
>> +					ret = -ENOMEM;
>> +				else if (ret & VM_FAULT_SIGBUS)
>> +					ret = -EFAULT;
>> +				else
>> +					BUG();
>> +				break;
>> +			}
> 
> +			ret = 0;
> 
>> +			cond_resched();
>> +		}
>> +
>> +		if (IS_ERR(page)) {
>> +			ret = PTR_ERR(page);
>> +			break;
>> +		}
> 
> Need to check ret here:
> 
> + 		if (ret)
> 			break;
> 
>> +
>> +		if (page == ZERO_PAGE(0))
>> +			page = NULL;	/* zero page: ignore */
>> +		else if (cow && page_mapping(page) != NULL)
>> +			page = NULL;	/* clean cow: ignore */
>> +		else {
>> +			get_page(page);
>> +			*(addrp++) = addr;
>> +			*(pagep++) = page;
>> +			if (--nr == 0) {
>> +				addr += PAGE_SIZE;
>> +				break;
>> +			}
>> +		}
>> +
>> +		addr += PAGE_SIZE;
>> +	}
>> +
>> +	if (unlikely(ret < 0)) {
>> +		nr = pgarr->nleft - nr;
>> +		while (nr--)
>> +			page_cache_release(*(--pagep));
>> +		return ret;
>> +	}
>> +
>> +	*start = addr;
>> +	return (pgarr->nleft - nr);
>> +}
> 
> [...]
> 
> Thanks,
> 
> Louis
> 
