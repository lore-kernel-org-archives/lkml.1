Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZDGFAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZDGFAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZDGFAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:00:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34506 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZDGFAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:00:41 -0400
Date: Tue, 7 Apr 2009 06:58:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [GIT PULL] SLAB include file dependency fixes + kmemtrace
	updates
Message-ID: <20090407045857.GA14481@elte.hu>
References: <20090405193944.GA12691@elte.hu> <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain>
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


(more folks Cc:-ed)

* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git kmemtrace-for-linus
> > 
> > We kept this topic separate from the main tracing tree due to 
> > the unexpectedly wide and messy-looking scope of the fixes Pekka 
> > needed to do to untangle various slab*.h, rcu*.h and fs.h 
> > dependency chains.
> 
> I'm not sure this is the tree that brings in the problem, but my 
> wife's Mac Mini won't boot any more, and it looks like some slub 
> or percpu issue, so regardless, roughly the right people are 
> involved in the cc here already.
> 
> I get odd NUL page faults or GP faults in either __kmalloc, 
> __kmalloc_track_caller or kmem_cache_alloc, and they all seem to 
> happen on roughly the same code, ie it's something like this:
> 
>         movq    752(%r13,%rax,8), %rdx  # <variable>.cpu_slab, c
>         movl    24(%rdx), %eax  # <variable>.objsize,
>         movl    %eax, -44(%rbp) #, objsize
>         movq    (%rdx), %r12    # <variable>.freelist, object
>         testq   %r12, %r12      # object
>         je      .L617   #,
>         mov     20(%rdx), %eax  # <variable>.offset, <variable>.offset
> ->      movq    (%r12,%rax,8), %rax     #* object, tmp79
>         movq    %rax, (%rdx)    # tmp79, <variable>.freelist
> 
> where that arrow points to the instruction that seems to be faulting.
> 
> I think it's this code:
> 
>                 object = c->freelist;
>                 c->freelist = object[c->offset];
> 
> and that "object[c->offset]" in particular.
> 
> I have not tried to bisect it yet, and I'll do that, but if this 
> sounds familiar to anybody, please holler before I waste a lot of 
> time on it.

Hm, this would suggest some sort of memory or data structure 
corruption.

There's no such pending bug (we wouldnt have pushed if there was 
anything of this severity). The historic track record:

 - the kmemtrace hooks have been 100% problem free since last 
   August. I mismerged them two times as SLUB changed upstream 
   frequently them but there was no runtime failure that i can 
   remember.

 - percpu changes have a more spotty past: and the #GP might
   suggest something there: we can get a #GP if we go outside the 
   %gs offset range and get a non-canonical address. All sorts of 
   bugs have been observed here: runtime failures with #GP and 
   memory corruption as well and linker bugs.

   To investigate+exclude this angle, a precise .config, sha1, gcc 
   and binutils version would be needed, to reproduce your exact
   kernel image. A dmesg would be helpful too - it's probably an EFI 
   bootup which is rare, but i can try to take your bootup memory 
   map dump in the dmesg and stuff it into an exactmap=<...> set of
   simulated memory environment - maybe that tickles the bug here 
   too.

 - [ stackprotector connects to percpu and got re-enabled - please
     double check you have it off in your config. ]

 - [ cpumask changes have sometimes produced runtime crashes, and 
     once a memory corruption - but only with 
     CONFIG_CPUMASK_OFFSTACK=y which i doubt you have enabled. ]

So unless you have a good crash pattern with a smoking gun, and if 
it's reproducible but bisection does not lead anywhere (which your 
later mails suggest), it might make sense to boot up with the full 
array of memory related debugging checks enabled:

  CONFIG_DEBUG_PAGEALLOC=y
  CONFIG_SLUB_DEBUG=y
  CONFIG_SLUB_DEBUG_ON=y

If the bug is timing or kernel image layout sensitive, this might 
hide it though.

Does it reproduce with maxcpus=1? If yes, it would weaken the percpu 
angle - paradoxially most of the percpu trouble we had during 
development was uniform and affected UP too.

Plus if it's a genuine memory corruptor and not timing sensitive and 
all other efforts fail, then there's also kmemcheck to try:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git kmemcheck

( Note: i merged this branch up to latest -git 30 seconds ago with 5 
  conflict resolutions half awake, but it will all be perfect, rest 
  assured. [ If not - a build failure or so - have a look at the 
  conflict resolutions ] If you try this you might have to tweak the 
  .config a bit to make CONFIG_KMEMCHECK appear - it's dependent on 
  a few things. Also - a kmemcheck false positive might hit the 
  bootup sooner than a genuine memory corruption so even if it emits 
  something, it might not be genuinely interesting. )

	Ingo
