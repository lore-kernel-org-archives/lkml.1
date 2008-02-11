Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYBKLAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYBKLAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757743AbYBKLAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:00:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53800 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618AbYBKLAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:00:37 -0500
Date: Mon, 11 Feb 2008 12:00:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/8] CPA: Flush the caches when setting pages not
	present
Message-ID: <20080211110025.GA15373@elte.hu>
References: <200802111034.764275766@suse.de> <20080211093430.D198A1B41CE@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211093430.D198A1B41CE@basil.firstfloor.org>
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

> e.g. the AMD64 pci-gart code sets pages not present to prevent 
> potential cache coherency problems.  When doing this it is probably 
> safer to flush the caches too. So consider clearing of the present bit 
> as a cache flush indicator.

uhm, but why? "Probably safer" is not the right kind of technical 
argument ;-)

The PCI-GART quirk which we use on some systems unmaps pages _not_ 
because of coherency problems (any cache coherency problems would be 
triggerable before we unmap them anyway), but due to _page aliasing_ 
problems: these pages might be in our general e820 map so we must 
disable them.

( in any case, the CPA code does not deal with cache attribute coherency 
  - that is topic of the upcoming PAT feature. We still largely rely on 
  MTRRs to get cache coherency right. )

furthermore, your patch does not even do what you claim it does, because
it is an elaborate NOP on most modern CPUs:

> +static inline int cache_attr(pgprot_t set, pgprot_t clr)
>  {
> -	return pgprot_val(attr) &
> +	/*
> +	 * Clearing pages is usually done for cache cohereny reasons
> +	 * (except for pagealloc debug, but that doesn't call this anyways)
> +	 * It's safer to flush the caches in this case too.
> +	 */
> +	if (pgprot_val(clr) & _PAGE_PRESENT)
> +		return 1;

as clflush does not work on not present pages...

	Ingo
