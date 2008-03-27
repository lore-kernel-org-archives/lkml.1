Return-Path: <linux-kernel-owner+w=401wt.eu-S1761031AbYC0Ucq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761031AbYC0Ucq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758214AbYC0Uci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:32:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758013AbYC0Uch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:32:37 -0400
Date: Thu, 27 Mar 2008 13:31:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <20080327200309.GA18550@elte.hu>
Message-ID: <alpine.LFD.1.00.0803271325430.14670@woody.linux-foundation.org>
References: <20080327200309.GA18550@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Mar 2008, Ingo Molnar wrote:
>
> Ingo Molnar (1):
>       x86: fix prefetch workaround
...
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index fdc6674..c0c82bc 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -92,7 +92,8 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
>  	unsigned char *max_instr;
>  
>  #ifdef CONFIG_X86_32
> -	if (!(__supported_pte_mask & _PAGE_NX))
> +	/* Catch an obscure case of prefetch inside an NX page: */
> +	if ((__supported_pte_mask & _PAGE_NX) && (error_code & 16))
>  		return 0;
>  #endif

Ingo, this patch makes no sense.

Two reasons:

 - "error_code & 16" is senseless. Use PF_INSTR instead, which actually 
   tells the reader something.

 - this piece of crap code is immediately followed by

	/* If it was a exec fault on NX page, ignore */
	if (error_code & PF_INSTR)
		return 0;

   which uses that *right* and readable PF_INSTR #define, and also shows 
   that the newly modified code is totally insane (ie: if the new code 
   triggers, then it would have returned 0 later _anyway_)

So I think it's just crap. I think it's duplication from the merging of 
the x86 code, and I think that the fact that the new code didn't use the 
right #define helper means that people didn't see that it was crap.

I pulled it, but this needs some resolution. The code makes no sense. 
Should that #ifdef and the code inside of it just be removed entirely?

			Linus
