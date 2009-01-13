Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZAMAcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZAMAcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 19:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZAMAcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 19:32:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43128 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbZAMAcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 19:32:07 -0500
Date: Tue, 13 Jan 2009 01:31:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, Daniel.Beschorner@facton.com,
       stable@kernel.org
Subject: Re: [patch] x86: fix PTE corruption issue while mapping RAM using
	/dev/mem
Message-ID: <20090113003147.GA18115@elte.hu>
References: <20090112235135.GA22722@elte.hu> <496BDDFD.27997.A74B06@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496BDDFD.27997.A74B06@pageexec.freemail.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> On 13 Jan 2009 at 0:51, Ingo Molnar wrote:
> 
> > applied to tip/x86/urgent, thanks Suresh!
> > 
> > note that the patch caused some conflicts (there were other changes in 
> > pat.c) - i merged it up manually but could you please check the final 
> > commit in tip/master whether it's all OK?
> 
> i don't think that it got applied properly:
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 85cbd3c..ea36ed7 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -347,9 +347,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
>         new->end        = end;
>         new->type       = actual_type;
> 
> -       if (new_type)
> -               *new_type = actual_type;
> -
>         spin_lock(&memtype_lock);
> 
>         if (cached_entry && start >= cached_start)
> @@ -437,6 +434,9 @@ int free_memtype(u64 start, u64 end)
>         if (is_ISA_range(start, end - 1))
>                 return 0;
> 
> +       if (new_type)
> +               *new_type = actual_type;
> +
>         is_range_ram = pagerange_is_ram(start, end);
>         if (is_range_ram == 1)
>                 return free_ram_pages_type(start, end);
> 
> free_memtype doesn't even have a new_type argument for starters ;), 
> patch must have applied it at the wrong place...

yeah, and Mr. Compiler agrees:

arch/x86/mm/pat.c: In function 'free_memtype':
arch/x86/mm/pat.c:437: error: 'new_type' undeclared (first use in this function)
arch/x86/mm/pat.c:437: error: (Each undeclared identifier is reported only once
arch/x86/mm/pat.c:437: error: for each function it appears in.)
arch/x86/mm/pat.c:438: error: 'actual_type' undeclared (first use in this function)

Suresh, could you please resend against tip/master? Thanks,

	Ingo
