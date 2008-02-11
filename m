Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbYBKMqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbYBKMqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbYBKMqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:46:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36257 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYBKMqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:46:42 -0500
Date: Mon, 11 Feb 2008 13:46:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/8] Fix logic error in 64bit memory hotadd
Message-ID: <20080211124625.GB23733@elte.hu>
References: <200802111034.764275766@suse.de> <20080211093433.DE4961B41CE@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211093433.DE4961B41CE@basil.firstfloor.org>
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

> The memory hotadd code assumes that the pud always exists already, but 
> that might be not true. Allocate it if it isn't there.

ok, this seems an like an ancient memory-hotplug bug. Does anyone even 
use memory hotplug currently? Did you find this bug via review, or did 
it trigger in practice?

Also, your fix, while it solves a real bug we want to fix, is not quite 
right for upstream integration yet. I can see 3 immediate problems with 
it:

> +			if (!pud_present(*pud)) {
> +				pud = (pud_t *)get_zeroed_page(GFP_ATOMIC);

the GFP_ATOMIC here can fail.

The proper solution is to instead extend init_memory_mapping() with a 
gfp_t parameter and pass in GFP_ATOMIC from the early init code (where 
we must not schedule and where GFP_ATOMIC will succeed anyway), but do a 
GFP_KERNEL from arch_add_memory().

> +				if (!pud)
> +					panic("Out of memory");

the panic() here is very rude to the user in the hotplug usecase.

The proper solution is to extend init_memory_mapping() with a return 
value, and to check in the caller. arch_add_memory() obviously does not 
want to panic(), it wants to return -ENOMEM to mm/memory_hotplug.c.

and a small style nit while changing this code:

> +		} else
>  			pud = alloc_low_page(&pud_phys);

please add curly braces to the 'else' branch too. (we generally prefer 
symmetrical curly braces) Thanks,

	Ingo
