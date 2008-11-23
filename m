Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbYKWJ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbYKWJ6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYKWJ6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:58:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37070 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYKWJ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:58:30 -0500
Date: Sun, 23 Nov 2008 10:58:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Make BUG() __noreturn.
Message-ID: <20081123095818.GU30453@elte.hu>
References: <49260E4C.8080500@caviumnetworks.com> <20081121150023.032f7b5b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121150023.032f7b5b.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > +static inline void __noreturn BUG(void)
> > +{
> > +	__asm__ __volatile__("break %0" : : "i" (BRK_BUG));
> > +	/* Fool GCC into thinking the function doesn't return. */
> > +	while (1)
> > +		;
> > +}
> 
> This kind of sucks, doesn't it?  It adds instructions into the 
> kernel text, very frequently on fast paths.  Those instructions are 
> never executed, and we're blowing away i-cache just to quash 
> compiler warnings.
> 
> For example, this:
> 
> --- a/arch/x86/include/asm/bug.h~a
> +++ a/arch/x86/include/asm/bug.h
> @@ -22,14 +22,12 @@ do {								\
>  		     ".popsection"				\
>  		     : : "i" (__FILE__), "i" (__LINE__),	\
>  		     "i" (sizeof(struct bug_entry)));		\
> -	for (;;) ;						\
>  } while (0)
>  
>  #else
>  #define BUG()							\
>  do {								\
>  	asm volatile("ud2");					\
> -	for (;;) ;						\
>  } while (0)
>  #endif
>  
> _
> 
> reduces the size of i386 mm/vmalloc.o text by 56 bytes.

yes - the total image effect is significantly - recently looked at how 
much larger !CONFIG_BUG builds would get if we inserted an infinite 
loop into them - it was in the 50K text range (!).

but in the x86 ud2 case we could guarantee that we wont ever return 
from that exception. Mind sending a patch with a signoff, a 
description and an infinite loop in the u2d handler?

	Ingo
