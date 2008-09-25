Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYIYPnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYIYPnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYIYPnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:43:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbYIYPnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:43:15 -0400
Date: Thu, 25 Sep 2008 08:42:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, Alan.Brunelle@hp.com,
       travis@sgi.com, tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <200809251150.26760.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.10.0809250836270.3265@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <86802c440808260136t3a33a9c8if53b6f70ab9df9e2@mail.gmail.com> <alpine.LFD.1.10.0808260939070.3363@nehalem.linux-foundation.org> <200809251150.26760.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Rusty Russell wrote:
> 
>     This turns out to be awful in practice, mainly due to const.  Consider:
> 
> 	#ifdef CONFIG_CPUMASK_OFFSTACK
> 	typedef unsigned long *cpumask_t;
> 	#else
> 	typedef unsigned long cpumask_t[1];
> 	#endif
> 
> 	cpumask_t returns_cpumask(void);

No. That's already broken. You cannot return a cpumask_t, regardless of 
interface. We must not do it regardless of how we pass those things 
around, since it generates _yet_ another temporary on the stack for the 
return slot for any kind of structure.

So all cpumask functions should always return pointers and/or take 
pointers to be filled in. That's true *regardless* of how we actually are 
to then allocate them.

So forget returning cpumasks. It's irrelevant.

What _is_ relevant is how we allocate them when we need temporary CPU 
masks. And _that_ is where my suggestion comes in. For small NR_CPUS, we 
really do want to allocate them on the stack, because calling kmalloc for 
a 4- or 8-byte allocation is just _stupid_.

So all your arguments are invalid, because you're looking at the wrong 
thing. The thing that I was talking about is converting current code that 
has

   random_function(..)
   {
	cpumask_t mask;

	.. do something with mask ...
   }

which has to be converted some way. And I think it needs to be converted 
in a way that does *not* force us to call kmalloc() for idiotically small 
values.

			Linus
