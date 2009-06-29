Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbZF2EKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbZF2EKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 00:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZF2EJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 00:09:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38858 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZF2EJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 00:09:57 -0400
Date: Mon, 29 Jun 2009 06:09:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH]highmem_32.c: add argument pointer checking
Message-ID: <20090629040954.GA13117@elte.hu>
References: <1246244906.5759.5.camel@myhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246244906.5759.5.camel@myhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Figo.zhang <figo1802@gmail.com> wrote:

> It had better add argument pointer checking.
> 
> If any guys write driver want to alloc hightmem and pass a no-initial pointer,
> it would be crashed.
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---  
> arch/x86/mm/highmem_32.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
> index 58f621e..e52e1a9 100644
> --- a/arch/x86/mm/highmem_32.c
> +++ b/arch/x86/mm/highmem_32.c
> @@ -31,6 +31,7 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
>  {
>  	enum fixed_addresses idx;
>  	unsigned long vaddr;
> +	BUG_ON(!page);
>  
>  	/* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
>  	pagefault_disable();
> @@ -58,6 +59,9 @@ void kunmap_atomic(void *kvaddr, enum km_type type)
>  	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
>  	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
>  
> +	if(!kvaddr)
> +		return;
> +

(Please run patches through scripts/checkpatch.pl before 
submission.)

Also, what's the improvement here? Before the patch we'd crash on a 
NULL dereference ... after the patch we'd crash on a BUG_ON().

Furthermore, he kunmap_atomic() change is outright wrong - it will 
now allow NULL kunmaps, which can hide bugs in drivers.

	Ingo
