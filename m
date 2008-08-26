Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbYHZHXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbYHZHXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 03:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYHZHXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 03:23:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41557 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbYHZHXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 03:23:08 -0400
Date: Tue, 26 Aug 2008 09:22:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, Mike Travis <travis@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
Message-ID: <20080826072220.GB31876@elte.hu>
References: <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B29F7B.6080405@hp.com> <48B2A421.7080705@hp.com> <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 25 Aug 2008, Linus Torvalds wrote:
> > 
> > checkstack.pl shows these things as the top problems:
> > 
> > 	0xffffffff80266234 smp_call_function_mask [vmlinux]:    2736
> > 	0xffffffff80234747 __build_sched_domains [vmlinux]:     2232
> > 	0xffffffff8023523f __build_sched_domains [vmlinux]:     2232
> > 
> > Anyway, the reason smp_call_function_mask and friends have such _huge_ 
> > stack usages for you is that they contain a 'cpumask_t' on the stack.
> 
> In fact, they contain multiple CPU-masks, each 4k-bits - 512 bytes - in 
> size. And they tend to call each other.
> 
> Quite frankly, I don't think we were really ready for 4k CPU's. I'm 
> going to commit this patch to make sure others don't do that many 
> CPU's by mistake. It marks MAXCPU's as being 'broken' so you cannot 
> select it, and also limits the number of CPU's that you _can_ select 
> to "just" 512.

yeah, that's OK i guess - distros can still enable 4K support if they 
wish to. Someone interested in improving the stack footprint situation 
should dust off the max-stack-footprint tracer so that we can catch 
these things in a more structured way.

And i guess the next generation of 4K CPUs support should just get away 
from cpumask_t-on-kernel-stack model altogether, as the current model is 
not maintainable. We tried the on-kernel-stack variant, and it really 
does not work reliably. We can fix this in v2.6.28.

	Ingo
