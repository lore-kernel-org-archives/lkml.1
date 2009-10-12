Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbZJLJo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbZJLJo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbZJLJoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:44:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56170 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631AbZJLJoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:44:25 -0400
Date: Mon, 12 Oct 2009 11:43:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc4
Message-ID: <20091012094334.GA928@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012082950.GA2270@elte.hu> <20091012132917.GA4900@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012132917.GA4900@x200>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, Oct 12, 2009 at 10:29:50AM +0200, Ingo Molnar wrote:
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > Alexey Dobriyan (2):
> > >       headers: remove sched.h from interrupt.h
> > 
> > This commit broke the -rc4 build in numerous ways on x86:
> > 
> >   drivers/pci/hotplug/cpqphp.h: In function ???wait_for_ctrl_irq???:
> >   drivers/pci/hotplug/cpqphp.h:730: error: implicit declaration of function ???signal_pending???
> > 
> >   drivers/char/rtc.c: In function 'rtc_interrupt':
> >   drivers/char/rtc.c:271: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> >   drivers/char/rtc.c:271: error: (Each undeclared identifier is reported only once
> > 
> > (I'll send fixes for the build failures as followups to this mail.)
> > 
> > Beyond being buggy there's two workflow problems with the commit.
> > 
> > Firstly, the commit log concentrates on the m68k situation while in 
> > reality more testing on x86 would have been much more important to the 
> > end result. If we break m68k with a header cleanup it's far less of a 
> > practical problem than if we break thousands of x86 boxes. I find this 
> > kind of artificially inflated focus on cross-testing (without properly 
> > weighting platforms) harmful.
> > 
> > Secondly, i'm wondering why the original mail to lkml:
> > 
> >   Date: Wed, 7 Oct 2009 17:09:06 +0400
> >   From: Alexey Dobriyan <adobriyan@gmail.com>
> >   To: torvalds@linux-foundation.org
> >   Subject: [PATCH] headers: remove sched.h from interrupt.h
> >   Cc: linux-kernel@vger.kernel.org
> > 
> > Wasnt Cc:-ed to the affected maintainers?
> 
> To whom? All 42 of them?

Nope. If you dont know who generally tends to modify a file you can use 
scripts/get_maintainer.pl, which gives you applicable Cc lines:

 earth4:~/tip> scripts/get_maintainer.pl -f include/linux/sched.h 
 Ingo Molnar <mingo@elte.hu>
 Peter Zijlstra <peterz@infradead.org>
 Andrew Morton <akpm@linux-foundation.org>
 linux-kernel@vger.kernel.org

 earth4:~/tip> scripts/get_maintainer.pl -f include/linux/interrupt.h 
 Ingo Molnar <mingo@elte.hu>
 Thomas Gleixner <tglx@linutronix.de>
 Yinghai Lu <yinghai@kernel.org>
 Rusty Russell <rusty@rustcorp.com.au>
 Peter Zijlstra <a.p.zijlstra@chello.nl>
 linux-kernel@vger.kernel.org

> > As a result the patch wasnt tested by any maintainer tree before it 
> > was sent to Linus. The change is good but obviously needs to be done 
> > more carefully, there are a _lot_ of hidden header dependencies in 
> > the kernel, especially related to sched.h.
> > 
> > We are doing regular header cleanup patches in -tip and have the 
> > infrastructure to test them properly as well, so this change could 
> > have been done via either the scheduler tree and the interrupt tree. 
> > We also cross-test to all other architectures.
> 
> Me too.

The problem is that you dont test carefully enough and that you avoid 
maintainer trees that do.

> This patch was tested on ~300 configs (allmodconfigs and defconfigs) 
> _and_ randconfigs on i386 and x86_64. I'm sorry I don't have more 
> compile time.
> 
> > Alexey, could you please Cc: affected maintainers in the future, so 
> > that we can avoid such problems?
> 
> Probably.

Probably? You dont know for sure whether you will be able to Cc: 
affected maintainers in the future?

> The problem I have with -tip is that god knows what's in there,

git log?

> [...] so any header dependency removed might very well be unrelated to 
> mainline.

That's nonsense. It's trivial to tell whether a build failure is caused 
by a commit in a maintainer tree or whether it came from upstream. 
Maintainers do this all the time, it's not specific to -tip at all.

All the 5 build fixes i sent today were for mainline build breakages you 
introduced via that patch.

	Ingo
