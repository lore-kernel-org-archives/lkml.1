Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbZFIM0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbZFIM0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZFIM0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:26:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45134 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbZFIM0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:26:08 -0400
Date: Tue, 9 Jun 2009 14:25:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
	kernels
Message-ID: <20090609122529.GD25586@elte.hu>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <20090609093918.GC16940@wotan.suse.de> <20090609111719.GA4463@elte.hu> <20090609121055.GA9158@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609121055.GA9158@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > and using atomic kmaps 
> >    is fragile and error-prone. I think we still have a FIXME of a 
> >    possibly triggerable deadlock somewhere in the core MM code ...
> 
> Not that I know of. I fixed the last long standing known one with 
> the write_begin/write_end changes a year or two ago. It wasn't 
> exactly related to kmap of the pagecache (but page fault of the 
> user address in copy_from_user).

> > OTOH, highmem is clearly a useful hardware enablement feature 
> > with a slowly receding upside and a constant downside. The 
> > outcome is clear: when a critical threshold is reached distros 
> > will stop enabling it. (or more likely, there will be pure 
> > 64-bit x86 distros)
> 
> Well now lots of embedded type archs are enabling it... So the 
> upside is slowly increasing again I think.

Sure - but the question is always how often does it show up on lkml? 
Less and less. There might be a lot of embedded Linux products sold, 
but their users are not reporting bugs to us and are not sending 
patches to us in the proportion of their apparent usage.

And on lkml there's a clear downtick in highmem relevance.

> > Highmem simply enables a sucky piece of hardware so the code 
> > itself has an intrinsic level of suckage, so to speak. There's 
> > not much to be done about it but it's not a _big_ problem 
> > either: this type of hw is moving fast out of the distro 
> > attention span.
> 
> Yes but Linus really hated the code. I wonder whether it is 
> generic code or x86 specific. OTOH with x86 you'd probably still 
> have to support different page table formats, at least, so you 
> couldn't rip it all out.

In practice the pte format hurts the VM more than just highmem. (the 
two are inseparably connected of course)

I did this fork overhead measurement some time ago, using 
perfcounters and 'perf':

  Performance counter stats for './fork':

        32-bit  32-bit-PAE     64-bit
     ---------  ----------  ---------
     27.367537   30.660090  31.542003  task clock ticks     (msecs)

          5785        5810       5751  pagefaults           (events)
           389         388        388  context switches     (events)
             4           4          4  CPU migrations       (events)
     ---------  ----------  ---------
                    +12.0%     +15.2%  overhead

So PAE is 12.0% slower (the overhead of double the pte size and 
three page table levels), and 64-bit is 15.2% slower (the extra 
overhead of having four page table levels added to the overhead of 
double the pte size). [the pagefault count noise is well below the 
systematic performance difference.]

Fork is pretty much the worst-case measurement for larger pte 
overhead, as it has to copy around a lot of pagetables.

Larger ptes do not come for free and the 64-bit instructions do not 
mitigate the cachemiss overhead and memory bandwidth cost.

	Ingo
