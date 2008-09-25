Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYIYI4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYIYI4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYIYI4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:56:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42549 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbYIYI4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:56:09 -0400
Date: Thu, 25 Sep 2008 10:55:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Alan.Brunelle@hp.com, travis@sgi.com, tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
Message-ID: <20080925085519.GA15771@elte.hu>
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <86802c440808260136t3a33a9c8if53b6f70ab9df9e2@mail.gmail.com> <alpine.LFD.1.10.0808260939070.3363@nehalem.linux-foundation.org> <200809251150.26760.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809251150.26760.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> I can't see a neater way down this path, and I don't want to lose 
> const.
> 
> I can see three alternatives:
> 1) An ONSTACK_CPUMASK(name) macro which declares "struct cpumask name[1]" or
>    "struct cpumask *name".  Same idea as yours, without the typedef.
> 2) Use a normal struct for cpumask, make everyone use pointers, but have an
>    struct cpumask *alloc_stack_cpumask() which uses alloca() for small
>    NR_CPUS.
> 3) Same, but just use kmalloc everywhere.  Optimize important cases by hand.
> 
> Anyone see a better way?

since most of the important cpumasks in high-perf codepaths are already 
pre-constructed and embedded in some existing object (say task_struct), 
i think a variant of #3 is the best approach:

 - get rid of cpumask_t and use 'struct cpumask' everywhere.

 - do not expose normal kernel code to struct cpumask's definition, only
   declare the type via 'struct cpumask;' in sched.h - a'la 
   kmem_cache_t.

 - even hide the structure from sched.h - use an extra indirection for 
   struct cpumask *cpus_allowed in task_struct and be done with it.

 - have normal cpumask object alloc/free codepaths.

 - optimize any remaining important cases by hand, if needed. (the 
   scheduler mostly)

(wrt. #2, alloca() is a nightmare i think.)

	Ingo
