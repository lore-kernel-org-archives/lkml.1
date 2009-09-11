Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbZIKWHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbZIKWHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbZIKWHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:07:47 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11683 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbZIKWHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:07:46 -0400
Date: Sat, 12 Sep 2009 00:07:49 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86/xen for v2.6.32
In-Reply-To: <20090911200135.GA1426@elte.hu>
Message-ID: <alpine.LNX.2.00.0909120000010.31018@swampdragon.chaosbits.net>
References: <20090911200135.GA1426@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009, Ingo Molnar wrote:

[...]
> +static __init void xen_load_gdt_boot(const struct desc_ptr *dtr)
> +{
> +	unsigned long va = dtr->address;
> +	unsigned int size = dtr->size + 1;
> +	unsigned pages = (size + PAGE_SIZE - 1) / PAGE_SIZE;
> +	unsigned long frames[pages];
> +	int f;
> +
> +	/*
> +	 * A GDT can be up to 64k in size, which corresponds to 8192
> +	 * 8-byte entries, or 16 4k pages..
> +	 */
> +
> +	BUG_ON(size > 65536);
> +	BUG_ON(va & ~PAGE_MASK);
> +
> +	for (f = 0; va < dtr->address + size; va += PAGE_SIZE, f++) {
> +		pte_t pte;
> +		unsigned long pfn, mfn;
> +
> +		pfn = virt_to_pfn(va);
> +		mfn = pfn_to_mfn(pfn);
> +
> +		pte = pfn_pte(pfn, PAGE_KERNEL_RO);
> +
> +		if (HYPERVISOR_update_va_mapping((unsigned long)va, pte, 0))
> +			BUG();
[...]

Why is this cast of 'va' needed?  As far as I can see, 'va' already has 
the correct type of "unsigned long".
Pointless casts do more harm than good, let's remove this one :-)

Sorry that all I could comment on was this trivial thing, but I thought it 
better to comment than keep silent now that I had read the patch and 
spotted it...


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

