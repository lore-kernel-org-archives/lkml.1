Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbYAYK2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbYAYK2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbYAYK1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:27:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbYAYK1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:27:54 -0500
Date: Fri, 25 Jan 2008 11:27:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: ioremap_nocache fix
Message-ID: <20080125102738.GQ23708@elte.hu>
References: <1201238561.15972.17.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201238561.15972.17.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang, Ying <ying.huang@intel.com> wrote:

> This patch fixes a bug of ioremap_nocache. ioremap_nocache() will call 
> __ioremap() with flags != 0 to do the real work, which will call 
> change_page_attr_addr() if phys_addr + size - 1 < (end_pfn_map << 
> PAGE_SHIFT). But some pages between 0 ~ end_pfn_map << PAGE_SHIFT are 
> not mapped by identity map, this will make change_page_attr_addr 
> failed.

very interesting! Is this in response to a bug you've triggered?

i believe the scenario you outlne could trigger on 64-bit boxen, if they 
try to ioremap an area not covered by the direct ptes:

> @@ -41,8 +41,15 @@ ioremap_change_attr(unsigned long phys_a
>  	if (phys_addr + size - 1 < (end_pfn_map << PAGE_SHIFT)) {
>  		unsigned long npages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>  		unsigned long vaddr = (unsigned long) __va(phys_addr);
> +		int level;
>  
>  		/*
> +		 * If there is no identity map for this address,
> +		 * change_page_attr_addr is unnecessary
> +		 */
> +		if (!lookup_address(vaddr, &level))
> +			return err;
> +		/*

and we'd incorrectly fail the ioremap() with -EINVAL, and return a hard 
error to the driver - and causing broken boxes, right?

Thomas has unified most of ioremap*.c as well, and we'll make sure this 
fix survives the unification. The 64-bit code limped along before by 
accident, because the (pre-cleanup) 64-bit __change_page_attr() code 
incorrectly returned 0 for invalid ranges:

        kpte = lookup_address(address);
        if (!kpte) return 0;

which masked the bug you fixed now. 32-bit always returned -EINVAL on 
invalid ranges.

	Ingo
