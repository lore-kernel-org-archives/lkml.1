Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbZA2Ufk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbZA2Ufk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZA2Ufb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:35:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52445 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbZA2Ufa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:35:30 -0500
Date: Thu, 29 Jan 2009 21:35:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH] x86: UV cleanup
Message-ID: <20090129203517.GE12819@elte.hu>
References: <E1LScjM-00073R-Cu@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LScjM-00073R-Cu@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> This patch tweaks a couple things:
> 
> - uv_flush_tlb_others()
>   the WARN_ON(!in_atomic()); fails if CONFIG_PREEMPT is not enabled
> 
>   The #ifdef may not be the right fix. The fix is probably in the
>   in_atomic macro, but I'm not sure what in_atomic() should return
>   if CONFIG_PREEMPT is turned off.  I tested making it return 1 in that
>   case, but that yielded tons of warnings.
> 
>   The simpler fix for tlb_uv.c would be to just drop the WARN_ON.
> 
> - uv_flush_send_and_wait() should return a pointer if the broadcast
>   remote tlb shootdown requests fail. That causes the conventional IPI
>   method of shootdown to be used.

hm, this isnt a cleanup but a fix - i.e. needs to go into x86/urgent as a 
separate patch, right?

and this:

> @@ -316,7 +316,9 @@ const struct cpumask *uv_flush_tlb_other
>  	int locals = 0;
>  	struct bau_desc *bau_desc;
>  
> +#ifdef CONFIG_PREEMPT
>  	WARN_ON(!in_atomic());
> +#endif

is indeed somewhat ugly - and we have no proper primitive to test for 
atomicity. (mainly because we dont know about atomicity on a non-preempt 
kernel)

	Ingo
