Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYIZFZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYIZFZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 01:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYIZFZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 01:25:30 -0400
Received: from ozlabs.org ([203.10.76.45]:52540 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbYIZFZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 01:25:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Date: Fri, 26 Sep 2008 15:25:29 +1000
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, Alan.Brunelle@hp.com,
       travis@sgi.com, tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <200809251150.26760.rusty@rustcorp.com.au> <alpine.LFD.1.10.0809250836270.3265@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809250836270.3265@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809261525.30258.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2008 01:42:13 Linus Torvalds wrote:
> On Thu, 25 Sep 2008, Rusty Russell wrote:
> >     This turns out to be awful in practice, mainly due to const. 
> > Consider:
> >
> > 	#ifdef CONFIG_CPUMASK_OFFSTACK
> > 	typedef unsigned long *cpumask_t;
> > 	#else
> > 	typedef unsigned long cpumask_t[1];
> > 	#endif
> >
> > 	cpumask_t returns_cpumask(void);
>
> No. That's already broken. You cannot return a cpumask_t, regardless of
> interface. We must not do it regardless of how we pass those things
> around, since it generates _yet_ another temporary on the stack for the
> return slot for any kind of structure.

No, for large NR_CPUS, cpumask_t is a pointer as shown.  And we have numerous 
basic functions which return a cpumask_t.  Yes, this is part of the problem.

> What _is_ relevant is how we allocate them when we need temporary CPU
> masks. And _that_ is where my suggestion comes in. For small NR_CPUS, we
> really do want to allocate them on the stack, because calling kmalloc for
> a 4- or 8-byte allocation is just _stupid_.

Right, but cpumask_t is used for far more than stack decls, thus the problems.

I can make a separate "cpumask_stack_t" and use your method tho.  I think that 
might even reduce churn and allow us to do this in parts.

> which has to be converted some way. And I think it needs to be converted
> in a way that does *not* force us to call kmalloc() for idiotically small
> values.

Yeah, got that.  But your suggestion to change cpumask_t turned out horribly 
ugly.

Cheers,
Rusty.
