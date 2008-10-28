Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYJ1QQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYJ1QQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYJ1QQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:16:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbYJ1QQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:16:43 -0400
Date: Tue, 28 Oct 2008 09:16:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: On spreading atomic_t initialization
In-Reply-To: <20081028152943.GA20989@x200.localdomain>
Message-ID: <alpine.LFD.2.00.0810280905350.3386@nehalem.linux-foundation.org>
References: <20081028152943.GA20989@x200.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Oct 2008, Alexey Dobriyan wrote:
>
> I wrote stupid runtime checker to look for atomic_t uninitialized usage
> and the amount of screaming in logs is surprisingly very big.
> 
> So the question: is there really really an arch for which setting atomic_t
> by hand (kzalloc) is not equivalent to atomic_set()?

For _initializers_? Not any more. And never for zero values.

We used to have very strict rules because 32-bit sparc historically used 
to use the low byte as a lock byte, but even back then it was ok to 
initialize the values with zero, and you had to use atomic_set() only if 
you set it to some other value (because the thing needed to be shifted up 
by eight bits in order to avoid the lock byte).

But zero has always been safe, and in fact since then we've also simply 
required that "atomic_t" always has at least 32 bits of data, and sparc 
fixed its implementation to have the lock separately for the broken old 
sparc32 architectures that don't have good atomic handling. 

So it might possibly still be valid to check that an atomic_t is 
initialized properly, but setting it to zero is a special case, and so 
it's ok to initialize it with a zeroing allocation (kzalloc()) or simply 
with a 'memset(ptr, 0, size)'.

I bet that if you change your checker to accept zero initializations, you 
won't find any issues any more. 

			Linus
