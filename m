Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZJYQVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZJYQVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 12:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZJYQVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 12:21:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48459 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbZJYQVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 12:21:08 -0400
Date: Sun, 25 Oct 2009 17:20:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/1] crash_dump: fix non-pae kdump kernel memory
	accesses
Message-ID: <20091025162018.GB20391@elte.hu>
References: <1256312729-22935-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256312729-22935-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Non-PAE 32-bit dump kernels may wrap an address around 4G and
> poke unwanted space. ptes there are 32-bit long, and since
> pfn << PAGE_SIZE may exceed this limit, high pfn bits are cropped
> and wrong address mapped by kmap_atomic_pfn in copy_oldmem_page.
> 
> Don't allow this behavior in non-PAE kdump kernels by checking
> pfns passed into copy_oldmem_page. In the case of failure,
> userspace process gets EFAULT.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/crash_dump_32.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/crash_dump_32.c b/arch/x86/kernel/crash_dump_32.c
> index f7cdb3b..b78dab8 100644
> --- a/arch/x86/kernel/crash_dump_32.c
> +++ b/arch/x86/kernel/crash_dump_32.c
> @@ -16,6 +16,19 @@ static void *kdump_buf_page;
>  /* Stores the physical address of elf header of crash image. */
>  unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
>  
> +#ifndef CONFIG_X86_PAE
> +/* non-PAE kdump kernel executed from a PAE one will crop high pte bits and
> +   poke unwanted space counting again from address 0, we don't want that */
> +static inline bool is_crashed_pfn_valid(unsigned long pfn)
> +{
> +	/* on non-PAE pte must fit into unsigned long
> +	   in fact the test is (pfn & 0x000fffff) */
> +	return pte_pfn(pfn_pte(pfn, __pgprot(0))) == pfn;
> +}
> +#else
> +static inline bool is_crashed_pfn_valid(unsigned long pfn) { return true; }
> +#endif

i'd suggest to push the #ifdef inside the function.

Also, please use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

Thanks,

        Ingo
