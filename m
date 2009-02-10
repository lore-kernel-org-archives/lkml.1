Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbZBJWnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbZBJWnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZBJWnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:43:01 -0500
Received: from gw.goop.org ([64.81.55.164]:60589 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005AbZBJWnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:43:00 -0500
Message-ID: <499202F0.10108@goop.org>
Date: Tue, 10 Feb 2009 14:42:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pekka Paalanen <pq@iki.fi>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stuart Bennett <stuart@freedesktop.org>
Subject: Re: testing pmdval/pteval page presence bit
References: <20090209215849.5a788261@daedalus.pq.iki.fi>
In-Reply-To: <20090209215849.5a788261@daedalus.pq.iki.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Paalanen wrote:
> Hi all,
>
> This question is related to mmiotrace which toggles the page presence
> bit to trigger page faults on ioremapped regions. Page faults are used
> to trace MMIO reads and writes of proprietary drivers.
>
> I understood that large pages use pmd's instead of pte's. If there is a
> union like this:
>
> +	union {
> +		pmdval_t pmdval;
> +		pteval_t pteval;
> +	} saved;	/* stored value prior to arming */
>
> and it is being assigned the proper content, as in the following:
>
> +static int clear_page_present(struct kmmio_fault_page *f, bool clear)
>  {
>  	pteval_t pteval;
>  	pmdval_t pmdval;
>  	unsigned int level;
>  	pmd_t *pmd;
> +	pte_t *pte = lookup_address(f->page, &level);
>  
>  	if (!pte) {
> +		pr_err("kmmio: no pte for page 0x%08lx\n", f->page);
>  		return -1;
>  	}
>  
>  	switch (level) {
>  	case PG_LEVEL_2M:
>  		pmd = (pmd_t *)pte;
> +		if (clear) {
> +			f->saved.pmdval = pmd_val(*pmd);
> +			pmdval = f->saved.pmdval & ~_PAGE_PRESENT;
> +		} else
> +			pmdval = f->saved.pmdval;
>  		set_pmd(pmd, __pmd(pmdval));
>  		break;
>  
>  	case PG_LEVEL_4K:
> +		if (clear) {
> +			f->saved.pteval = pte_val(*pte);
> +			pteval = f->saved.pteval & ~_PAGE_PRESENT;
> +		} else
> +			pteval = f->saved.pteval;
>  		set_pte_atomic(pte, __pte(pteval));
>  		break;
>
>
> Then regardless of was it pmdval or pteval being set, the test
>
> 	if (!(faultpage->saved.pteval & _PAGE_PRESENT))
>
> should be ok. But is it?
> Can large page (pmd) presence be handled just like a normal page (pte)?
>   

_PAGE_PRESENT is meaningful for both ptes and pmds; you can use 
pmd_present() to test for it rather than open-coding it.

But there's one other theoretical problem with this code.  In general it 
isn't safe to just toggle the _PAGE_PRESENT bit on its own, because the 
rest of the non-present pte could get interpreted as a swap entry.  If 
you're guaranteed that these are kernel mappings then there's no problem 
in practice.

    J
