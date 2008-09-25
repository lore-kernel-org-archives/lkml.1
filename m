Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbYIYBuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbYIYBuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 21:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYIYBuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 21:50:35 -0400
Received: from ozlabs.org ([203.10.76.45]:33771 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbYIYBue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 21:50:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Date: Thu, 25 Sep 2008 11:50:25 +1000
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, Alan.Brunelle@hp.com,
       travis@sgi.com, tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <86802c440808260136t3a33a9c8if53b6f70ab9df9e2@mail.gmail.com> <alpine.LFD.1.10.0808260939070.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808260939070.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809251150.26760.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008 02:51:46 Linus Torvalds wrote:
> On Tue, 26 Aug 2008, Yinghai Lu wrote:
> > wonder if could use "unsigned long *" directly.
>
> I would actually suggest something like this:
>
>  - we continue to have a magic "cpumask_t".
>
>  - we do different cases for big and small NR_CPUS:
>
> 	#if NR_CPUS <= BITS_PER_LONG
>
> 	/*
> 	 * Make it an array - that way passing it as an argument will
> 	 * always pass it as a pointer!
> 	 */
> 	typedef unsigned long cpumask_t[1];
>
> 	static inline void create_cpumask(cpumask_t *p)
> 	{
> 		*p = 0;
> 	}
> 	static inline void free_cpumask(cpumask_t *p)
> 	{
> 	}
>
> 	#else
>
> 	typedef unsigned long *cpumask_t;
>
> 	static inline void create_cpumask(cpumask_t *p)
> 	{
> 		*p = kcalloc(..);
> 	}
>
> 	static inline void free_cpumask(cpumask_t *p)
> 	{
> 		kfree(*p);
> 	}
>
> 	#endif
>
> and now after you do this, you can just do something like
>
> 	cpumask_t mycpu;
>
> 	create_cpumask(&mycpu);
> 	..
> 	free_cpumask(&mycpu);
>
> and in between, you can use 'cpumask' as a pointer, because even when it
> is an array directly allocated on the stack, the array can always
> degenerate into a pointer by C type rules!

Hi Linus,

    This turns out to be awful in practice, mainly due to const.  Consider:

	#ifdef CONFIG_CPUMASK_OFFSTACK
	typedef unsigned long *cpumask_t;
	#else
	typedef unsigned long cpumask_t[1];
	#endif

	cpumask_t returns_cpumask(void);

That's obviously illegal if cpumask_t is an array.  So we need a typedef which 
says "really always a pointer".

	typedef unsigned long *cpumask_return_t;
	cpumask_return_t returns_cpumask(void);

But we usually want it to return a const ptr, and this doesn't work:

	const cpumask_return_t returns_cpumask(void);
	foo.c:12: warning: type qualifiers ignored on function return type

So now we need:
	typedef const unsigned long *cpumask_const_return_t;
	cpumask_const_return_t returns_cpumask(void);

OK, now consider a function which wants to take a const cpu bitmap:

	void cpus_copy(cpumask_t dst, const cpumask_t src);
	...
	cpus_copy(cpus, returns_cpumask());
	foo.c:34: warning: passing argument 2 of ‘cpus_copy’ discards qualifiers from 
pointer target type

Oops, that didn't work with the pointer version.  So we need another typedef:
	#ifdef CONFIG_CPUMASK_OFFSTACK
	typedef const unsigned long *cpumask_const_t;
	#else
	typedef const unsigned long cpumask_const_t[1];
	#endif

	void cpus_copy(cpumask_t dst, cpumask_const_t src);

We end up with this:
	#ifdef CONFIG_CPUMASK_OFFSTACK
	typedef unsigned long *cpumask_t;
	typedef const unsigned long *cpumask_const_t;
	#else
	typedef unsigned long cpumask_t[1];
	typedef const unsigned long cpumask_const_t[1];
	#endif
	typedef unsigned long *cpumask_return_t;
	typedef const unsigned long *cpumask_const_return_t;
	typedef unsigned long cpumask_data_t[1];

I can't see a neater way down this path, and I don't want to lose const.

I can see three alternatives:
1) An ONSTACK_CPUMASK(name) macro which declares "struct cpumask name[1]" or
   "struct cpumask *name".  Same idea as yours, without the typedef.
2) Use a normal struct for cpumask, make everyone use pointers, but have an
   struct cpumask *alloc_stack_cpumask() which uses alloca() for small
   NR_CPUS.
3) Same, but just use kmalloc everywhere.  Optimize important cases by hand.

Anyone see a better way?
Rusty.
