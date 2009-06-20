Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbZFTSw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbZFTSw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759596AbZFTSuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:50:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759578AbZFTSuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:50:04 -0400
Date: Sat, 20 Jun 2009 11:49:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core kernel fixes
In-Reply-To: <20090620173022.GA14145@elte.hu>
Message-ID: <alpine.LFD.2.01.0906201132020.4160@localhost.localdomain>
References: <20090620173022.GA14145@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Jun 2009, Ingo Molnar wrote:
> 
> Please pull the latest core-fixes-for-linus git tree from:

I need to think about this one.

> +/*
> + * get_user_writeable - get user page and verify RW access
> + * @uaddr:	pointer to faulting user space address
> + *
> + * We cannot write to the user space address and get_user just faults
> + * the page in, but does not tell us whether the mapping is writeable.
> + *
> + * We can not rely on access_ok() for private futexes as it is just a
> + * range check and we can neither rely on get_user_pages() as there
> + * might be a mprotect(PROT_READ) for that mapping after
> + * get_user_pages() and before the fault in the atomic write access.
> + */
> +static int get_user_writeable(u32 __user *uaddr)
> +{
> +	unsigned long addr = (unsigned long)uaddr;
> +	struct page *page;
> +	int ret;
> +
> +	ret = get_user_pages_fast(addr, 1, 1, &page);
> +	if (ret > 0)
> +		put_page(page);
> +
> +	return ret;
> +}

This is some seriously crazy sh*t, man. What drugs were you on, and are 
the police on to you? Because whatever drugs they were, I seriously doube 
they are legal even with a prescription.

There's somethign wrong in futex land. This whole retry crap has been so 
incredibly broken so many times, and this particular fix looks so horribly 
ugly that I really need to ask people: "is the loop really sane?"

I also think that the above is a singularly stupid way to do what you want 
done. It's slow, it's nasty, it's complicated.

On x86, the natural way to do what you want done is ONE SINGLE 
INSTRUCTION! As far as I can tell, the above crazy function is 100% 
equivalent to this:

	asm __inline__("lock ; addl $0,%0":"+m" (*uaddr): :"memory", "cc");

which really makes me think that using "get_user_pages_fast()" for it is 
some truly crazy crap.

Sure, we don't have any architecture-generic way to do that, but still..

		Linus
