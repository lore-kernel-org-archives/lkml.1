Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbYAJGzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbYAJGzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 01:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYAJGy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 01:54:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51544 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbYAJGy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 01:54:56 -0500
Date: Thu, 10 Jan 2008 07:54:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: Fix x86 32 bit FRAME_POINTER chasing code
Message-ID: <20080110065438.GA23022@elte.hu>
References: <20080109220421.630d3516@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109220421.630d3516@laptopd505.fenrus.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> +++ linux-2.6.24-rc7/arch/x86/kernel/traps_32.c
> @@ -124,7 +124,8 @@ static inline unsigned long print_contex
>  		unsigned long addr;
>  
>  		addr = frame->return_address;
> -		ops->address(data, addr);
> +		if (__kernel_text_address(addr))
> +			ops->address(data, addr);
>  		/*
>  		 * break out of recursive entries (such as
>  		 * end_of_stack_stop_unwind_function). Also,
> @@ -132,6 +133,7 @@ static inline unsigned long print_contex
>  		 * move downwards!
>  		 */
>  		next = frame->next_frame;
> +		ebp = (unsigned long) next;
>  		if (next <= frame)

thanks, applied. Nice catch!

> This patch is simple; I don't know if it's .24 candidate; the bug is 
> pretty bad but not a recent regression, and there is obviously some 
> risk with touching this code.

it's a 2.6.24.1 candidate i believe. We trigger plenty of various 
crashes during x86.git maintenance and others hit various crashes in 
-mm, so by the time .1 is released we'll have it in .25 and can backport 
it. Most folks/distros will update to 2.6.24.1 very quickly so there's 
no risk of months loss of quality to kerneloops.org data either.

if there's more than 1-2 weeks to the v2.6.24 release we could merge it 
right now as well:

 Acked-by: Ingo Molnar <mingo@elte.hu>

because in a week we'll trigger plenty of crashes in -git based x86 
trees and will know about any regressions and will be able to reasonably 
trust it.

	Ingo
