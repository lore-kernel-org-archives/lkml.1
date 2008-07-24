Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbYGXTkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbYGXTkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYGXTjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:39:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbYGXTjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:39:53 -0400
Date: Thu, 24 Jul 2008 12:36:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <20080724151200.GA19266@elte.hu>
Message-ID: <alpine.LFD.1.10.0807241233450.3237@nehalem.linux-foundation.org>
References: <20080724151200.GA19266@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Jul 2008, Ingo Molnar wrote:
>
> Hugh Dickins (1):
>       x86: BUILD_IRQ say .text to avoid .data.percpu
> 
> diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
> index 0373e88..9414125 100644
> --- a/arch/x86/kernel/irqinit_64.c
> +++ b/arch/x86/kernel/irqinit_64.c
> @@ -43,7 +43,7 @@
>  
>  #define BUILD_IRQ(nr)				\
>  	asmlinkage void IRQ_NAME(nr);		\
> -	asm("\n.p2align\n"			\
> +	asm("\n.text\n.p2align\n"		\
>  	    "IRQ" #nr "_interrupt:\n\t"		\
>  	    "push $~(" #nr ") ; "		\
>  	    "jmp common_interrupt");

I do not think this is a good idea AT ALL.

You need a ".previous" there too, otherwise any random C code that doesn't 
_happen_ to change segments will now possibly put some random variable in 
the .text segment.

And yes, dependign on just where the BUILD_IRQ() is, and what is around 
it, and what compiler version we have, this bug may or may not show. But 
it's still _wrong_.

I pulled it, will fix up by hand.

		Linus
