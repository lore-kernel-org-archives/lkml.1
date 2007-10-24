Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbXJXKRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbXJXKRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbXJXKRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:17:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55573 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbXJXKRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:17:34 -0400
Date: Wed, 24 Oct 2007 12:17:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux v2.6.24-rc1, x86 arch code quality, unifications
Message-ID: <20071024101715.GB18882@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024080451.GA32690@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024080451.GA32690@infradead.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Oct 23, 2007 at 09:19:16PM -0700, Linus Torvalds wrote:
> > In short, we just had an unusually large amount of not just x86 merges, 
> 
> Btw, can we please finis up this merge a little more before we freeze 
> 2.6.24?  The way we currently have leftovers of arch/i386/ and 
> arch/x86_64/ is quite a nightmare and not how the other architectures 
> were merged.
> 
> Thomas, what again prevents us from just killing these leftovers?

to answer that question one should first be aware of the fundamental 
code quality problems that the unified x86 architecture has inherited 
from the split i386 and x86_64 architectures.

To get objective and automated metrics about code quality, i've 
constructed a table of "coding style errors per one thousand lines of 
source code" numbers with the help of the latest checkpatch.pl. The 
codebases i measured are the pre-merge i386 and x86_64 tree, the 
post-merge arch/x86 unified architecture, and i've also added a handful 
of other architectures and selected core subsystems, as comparison:

               -------------------------------------------------------
               |    errors  | lines of code  |    errors/KLOC
               |            |                |    (smaller is better)
 --------------|------------|----------------|------------------------
  arch/i386/          5717            73865         77.3
  arch/x86_64/        2993            31155         96.0
  arch/x86/           8504           114654         74.1
 ..............|............|................|........................
  arch/ia64/          1779            64022         27.7
  arch/mips/          2110            94692         22.2
  arch/sparc64/       1387            49253         28.1
 ..............|............|................|........................
  kernel/              762            83540          9.1
  kernel/time/          15             4191          3.5
  kernel/irq/            1             2317          0.4
  mm/                  464            46324         10.0
  net/core             176            24413          7.2
 ..............|............|................|........................

a couple of observations. Firstly, it is plainly obvious that the x86_64 
and i386 architectures were in a dreadful state of code quality before 
the unification. Their code quality was almost an order of magnitude 
worse than that of the core kernel (!) - and their code quality was 
significantly worse than that of a couple of other, comparable 
architectures. (we knew this when we started the x86 unification effort 
- but i suspect it's even more apparent via the hard numbers in this 
table.)

 ( Note: code metrics should be taken with a grain of salt, as they
   often over-simplify the picture, but in this particular situation the
   trends are clear and the numbers match my personal impressions of
   code quality and robustness of these codebases. )

paradoxically the x86_64 architecture that had a _worse_ code quality 
than the "legacy" 32-bit code - so much about the "newer code must be 
better" misconception. The first, mechanic round of unifications thus 
brought a net degradation in quality - but we've reversed that trend in 
2.6.24-rc1 already, via unifications and cleanups, as it can be seen 
from the table. (and we did that while adding new features like 
high-resolution timers and dynticks to the x86-64bit architecture in 
v2.6.24-rc1 - or the new IOMMU code. So the x86 architecture is not 
standing still at all while the unification is going on.)

so to answer your question: full unification is no easy task and it is 
not automatic at all. The x86_64 tree has diverged from the i386 tree in 
the past 5 years due to their illogical, forced separation and a 
resulting bitrot. The two architectures have grown different sets of 
cleanliness problems and different sets of functions with arbitrary 
differences that often cover the same functionality. It's all compounded 
by the fact that the 64-bit code is in worse shape than the 32-bit - so 
it's not like we could just pick the 64-bit code and use that as the 
unified code. The 32-bit code is also used about 8-10 times more 
frequently than the 64-bit code. So there is no easy "just unify it" 
path.

The new maintainers of the x86 architecture (Thomas, Peter and me), and 
many other x86 developers are highly motivated to improve the x86 
architecture's code quality and unify the heck out of it, and there are 
some real improvements in 2.6.24-rc1 already, but we _must_ be (and are) 
working on this carefully. So we do unifications on a case by case 
basis, with the highest priority being to not introduce "unification 
regressions". The x86 architecture is the most common Linux architecture 
after all - and users care much more about having a working kernel than 
they care about cleanups and unifications. So yes, we agree with you, 
but please be patient! :-) This cannot be realistically finished in 
v2.6.24, without upsetting the codebase.

	Ingo
