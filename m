Return-Path: <linux-kernel-owner+w=401wt.eu-S1751423AbZA0W55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbZA0W55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZA0W5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:57:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbZA0W5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:57:48 -0500
Date: Tue, 27 Jan 2009 14:57:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
In-Reply-To: <20090127222825.GA27097@elte.hu>
Message-ID: <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
References: <20090127222825.GA27097@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Jan 2009, Ingo Molnar wrote:
> 
> Should i perhaps not bother with the stuff below? Cannot turn off 
> CONFIG_HEADERS_CHECK in my builds because it can cause build failures.

I really hate the patch. I think it's fundamentally flawed. I hate scripts 
that test for things that are readable, and encourage people to then write 
crap instead.

The thing is, the headers_check stuff is just wrong if it causes these 
things, and I'd rather just turn it off.

If those 

	#ifdef CONFIG_XYZ

things result in problems, then we should just make the rule be that we 
turn that kind of string into

	#if 0

automatically when exporting the kernel headers. IOW, just about 
_anything_ that headers_check complains about automatically is something 
that should just be _fixed_ automatically at header install time rather 
than make the code harder to read.

So I think it makes our headers worse. Code like

	> +#ifdef __KERNEL__
	> +# ifdef CONFIG_X86_BSWAP
	> +# define __X86_BSWAP  
	> +# endif /* CONFIG_X86_BSWAP */
	> +#endif /* __KERNEL__ */

just doesn't make sense. It doesn't make sense _inside_ the kernel, and it 
doesn't make sense _outside_ it either.

As far as I can tell, the header install script could literally just do 
something like run 'sed' over the headers as it installs them, and do 
something like

	sed 's/\<CONFIG_[A-Z0-9_]*\>/__kernel_only__/g'

which I realize is not really the complete/correct solution (ie you could 
write a nicer thing that does a better job), but my point here is that 
rather than have scripts that _whine_ about these kinds of trivial things 
and cause people to write less readable header files, we should just make 
sure that if we can recognize them so easily, we can just fix them 
instead.

End result: headers that don't suck.

If the damn headers-check isn't working for people, then let's turn the 
thing off, not make our code look worse.

There are parts of the patches that look fine, like moving __KERNEL__ 
checks around a bit, and changing <asm/types.h> to <linux/types.h> which 
looks correct _both_ in a kernel and in a user context, but I dislike the 
stupid parts.

			Linus
