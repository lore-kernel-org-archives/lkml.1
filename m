Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbYHZQyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbYHZQyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYHZQyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:54:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729AbYHZQyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:54:08 -0400
Date: Tue, 26 Aug 2008 09:51:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Alan.Brunelle@hp.com, travis@sgi.com, tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       rusty@rustcorp.com.au
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <86802c440808260136t3a33a9c8if53b6f70ab9df9e2@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808260939070.3363@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org>  <20080826072220.GB31876@elte.hu>  <20080826.004607.253712060.davem@davemloft.net>  <20080826075355.GA7596@elte.hu>
 <86802c440808260136t3a33a9c8if53b6f70ab9df9e2@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Yinghai Lu wrote:
> 
> wonder if could use "unsigned long *" directly.

I would actually suggest something like this:

 - we continue to have a magic "cpumask_t".

 - we do different cases for big and small NR_CPUS:

	#if NR_CPUS <= BITS_PER_LONG

	/*
	 * Make it an array - that way passing it as an argument will
	 * always pass it as a pointer!
	 */
	typedef unsigned long cpumask_t[1];

	static inline void create_cpumask(cpumask_t *p)
	{
		*p = 0;
	}
	static inline void free_cpumask(cpumask_t *p)
	{
	}

	#else

	typedef unsigned long *cpumask_t;

	static inline void create_cpumask(cpumask_t *p)
	{
		*p = kcalloc(..);
	}

	static inline void free_cpumask(cpumask_t *p)
	{
		kfree(*p);
	}

	#endif

and now after you do this, you can just do something like

	cpumask_t mycpu;

	create_cpumask(&mycpu);
	..
	free_cpumask(&mycpu);

and in between, you can use 'cpumask' as a pointer, because even when it 
is an array directly allocated on the stack, the array can always 
degenerate into a pointer by C type rules!

And for the small-NR_CPUS case there is zero overhead.

			Linus
