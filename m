Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZJZUlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZJZUlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbZJZUlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:41:01 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47697 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596AbZJZUk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:40:59 -0400
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
       Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 1/1] crash_dump: fix non-pae kdump kernel memory accesses
References: <20091025162018.GB20391@elte.hu>
	<1256551903-30567-1-git-send-email-jirislaby@gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 26 Oct 2009 13:40:53 -0700
In-Reply-To: <1256551903-30567-1-git-send-email-jirislaby@gmail.com> (Jiri Slaby's message of "Mon\, 26 Oct 2009 11\:11\:43 +0100")
Message-ID: <m1fx95lwh6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> Non-PAE 32-bit dump kernels may wrap an address around 4G and
> poke unwanted space. ptes there are 32-bit long, and since
> pfn << PAGE_SIZE may exceed this limit, high pfn bits are cropped
> and wrong address mapped by kmap_atomic_pfn in copy_oldmem_page.
>
> Don't allow this behavior in non-PAE kdump kernels by checking
> pfns passed into copy_oldmem_page. In the case of failure,
> userspace process gets EFAULT.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Looks good to me.

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
