Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZJ0NSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZJ0NSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbZJ0NSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:18:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbZJ0NSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:18:47 -0400
Date: Tue, 27 Oct 2009 09:17:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 1/1] crash_dump: fix non-pae kdump kernel memory
	accesses
Message-ID: <20091027131750.GA10513@redhat.com>
References: <20091025162018.GB20391@elte.hu> <1256551903-30567-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256551903-30567-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 11:11:43AM +0100, Jiri Slaby wrote:
> Non-PAE 32-bit dump kernels may wrap an address around 4G and
> poke unwanted space. ptes there are 32-bit long, and since
> pfn << PAGE_SIZE may exceed this limit, high pfn bits are cropped
> and wrong address mapped by kmap_atomic_pfn in copy_oldmem_page.
> 
> Don't allow this behavior in non-PAE kdump kernels by checking
> pfns passed into copy_oldmem_page. In the case of failure,
> userspace process gets EFAULT.
> 
> [v2]
> - fix comments
> - move ifdefs inside the function
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

>  arch/x86/kernel/crash_dump_32.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/crash_dump_32.c b/arch/x86/kernel/crash_dump_32.c
> index f7cdb3b..cd97ce1 100644
> --- a/arch/x86/kernel/crash_dump_32.c
> +++ b/arch/x86/kernel/crash_dump_32.c
> @@ -16,6 +16,22 @@ static void *kdump_buf_page;
>  /* Stores the physical address of elf header of crash image. */
>  unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
>  
> +static inline bool is_crashed_pfn_valid(unsigned long pfn)
> +{
> +#ifndef CONFIG_X86_PAE
> +	/*
> +	 * non-PAE kdump kernel executed from a PAE one will crop high pte
> +	 * bits and poke unwanted space counting again from address 0, we
> +	 * don't want that. pte must fit into unsigned long. In fact the
> +	 * test checks high 12 bits for being zero (pfn will be shifted left
> +	 * by PAGE_SHIFT).
> +	 */
> +	return pte_pfn(pfn_pte(pfn, __pgprot(0))) == pfn;
> +#else
> +	return true;
> +#endif
> +}
> +
>  /**
>   * copy_oldmem_page - copy one page from "oldmem"
>   * @pfn: page frame number to be copied
> @@ -41,6 +57,9 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
>  	if (!csize)
>  		return 0;
>  
> +	if (!is_crashed_pfn_valid(pfn))
> +		return -EFAULT;
> +
>  	vaddr = kmap_atomic_pfn(pfn, KM_PTE0);
>  
>  	if (!userbuf) {
> -- 
> 1.6.4.2
