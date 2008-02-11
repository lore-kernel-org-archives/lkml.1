Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYBKM1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYBKM1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbYBKM1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:27:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40220 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbYBKM1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:27:21 -0500
Date: Mon, 11 Feb 2008 13:27:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: ying.huang@intel.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/8] CPA: Fix set_memory_x for ioremap
Message-ID: <20080211122705.GA23733@elte.hu>
References: <200802111034.764275766@suse.de> <20080211093432.DA4331B41CE@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211093432.DA4331B41CE@basil.firstfloor.org>
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


* Andi Kleen <ak@suse.de> wrote:

> EFI currently calls set_memory_x() on potentially ioremapped 
> addresses.
> 
> This is problematic for several reasons:
> 
> - The cpa code internally calls __pa on it which does not work for 
> remapped addresses and will give some random result.

Wrong. We do call __pa() on vmalloc ranges (which is a known 
uncleanliness that we intend to fix), but contrary to your claim the 
result is not "random result". On 64-bit it's guaranteed to have a value 
above ~66 TB on 64-bit and hence fails all the filters later on so it 
has zero practical relevance at the moment. On 32-bit we transform it 
down to somewhere around 1GB - where we check it against the BIOS range 
filters - which again cannot trigger. But I do agree that it's unclean 
and needs fixing up.

Detailed analysis on 64-bit: we call __pa() here:

static int change_page_attr_addr(struct cpa_data *cpa)
...
        unsigned long phys_addr = __pa(address);

which for vmalloc area virtual addresses will indeed yield some really 
high (and invalid) physical address. That address will never trigger 
this check:

        if (within(address, HIGH_MAP_START, HIGH_MAP_END))
                address = (unsigned long) __va(phys_addr);

or this check:

        if (within(phys_addr, 0, KERNEL_TEXT_SIZE)) {

so we'll never actuall _use_ that phys_addr.

> - cpa will try to change all potential aliases (like the kernel 
> mapping on x86-64), but that is not needed for NX because the caller 
> does only needs its specific virtual address executable. There is no 
> requirement in the x86 architecture for nx bits to be coherent between 
> mapping aliases. Also with the previous problem of __pa returning a 
> wrong address it would likely try to change some random other page if 
> you're unlucky and the random result would match the kernel text 
> range.

wrong. That "random other page" is guaranteed to be above 66 TB 
physical.

Anyway, i agree that it's ugly and unintuitive and it's on our clean-up 
list. But your patch is not a good cleanup because it just hides the 
underlying weakness.

	Ingo
