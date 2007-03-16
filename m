Return-Path: <linux-kernel-owner+w=401wt.eu-S933259AbXCPJjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbXCPJjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933273AbXCPJjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:39:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56374 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933259AbXCPJjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:39:39 -0400
Date: Fri, 16 Mar 2007 10:38:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 04/26] Xen-paravirt_ops: Add pagetable accessors to pack and unpack pagetable entries
Message-ID: <20070316093844.GT23174@elte.hu>
References: <20070301232443.195603797@goop.org> <20070301232526.502172500@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301232526.502172500@goop.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Add a set of accessors to pack, unpack and modify page table entries 
> (at all levels).  This allows a paravirt implementation to control the 
> contents of pgd/pmd/pte entries.  For example, Xen uses this to 
> convert the (pseudo-)physical address into a machine address when 
> populating a pagetable entry, and converting back to pphys address 
> when an entry is read.

looks good.

Acked-by: Ingo Molnar <mingo@elte.hu>

only some minor style nits:

> +static inline unsigned long long native_pgd_val(pgd_t pgd)
> +{
> +	return pgd.pgd;
> +}
> +static inline unsigned long long native_pmd_val(pmd_t pmd)
> +{
> +	return pmd.pmd;
> +}
> +static inline unsigned long long native_pte_val(pte_t pte)
> +{
> +	return pte.pte_low | ((unsigned long long)pte.pte_high << 32);
> +}
> +static inline pgd_t native_make_pgd(unsigned long long val)
> +{
> +	return (pgd_t) { val };
> +}
> +static inline pmd_t native_make_pmd(unsigned long long val)
> +{
> +	return (pmd_t) { val };
> +}
> +static inline pte_t native_make_pte(unsigned long long val)
> +{
> +	return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
> +}

missing newlines between inline functions.

> +#ifndef CONFIG_PARAVIRT
> +#define pmd_val(x)	native_pmd_val(x)
> +#define __pmd(x)	native_make_pmd(x)
> +#endif	/* !CONFIG_PARAVIRT */

no need for the closing !CONFIG_PARAVIRT comment: this define is 2 lines 
long so it's not that hard to find the start of the block. We typically 
do the /* !CONFIG_XX */ comment only for larger blocks, and when 
multiple #endif's intermix.

> +static inline unsigned long native_pgd_val(pgd_t pgd)
> +{
> +	return pgd.pgd;
> +}
> +static inline unsigned long native_pte_val(pte_t pte)
> +{
> +	return pte.pte_low;
> +}
> +static inline pgd_t native_make_pgd(unsigned long val)
> +{
> +	return (pgd_t) { val };
> +}
> +static inline pte_t native_make_pte(unsigned long val)
> +{
> +	return (pte_t) { .pte_low = val };
> +}

newlines.

>  #define HPAGE_SHIFT	22
>  #include <asm-generic/pgtable-nopmd.h>
> -#endif
> +#endif	/* CONFIG_X86_PAE */

(for example here the #endif comment is justified.)

	Ingo
