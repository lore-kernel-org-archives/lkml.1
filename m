Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbZDOQ1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbZDOQ1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZDOQ1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:27:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56534 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbZDOQ1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:27:06 -0400
Date: Wed, 15 Apr 2009 18:26:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090415162627.GA32254@elte.hu>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Impact: clarify and extend confusing API
> 
> And what the hell is up with these bogus "Impact:" things? Who 
> started doing that, and why? If your single-line explanation at 
> the top is not good enough, and your multi-line explanation isn't 
> clear enough, then you should fix the OTHER parts, not add that 
> _idiotic_ "Impact" statement.

I got Rusty to use it so i'm to blame for this one. A number of 
developers/maintainers use it now and they find it useful in a 
number of circumstances, when used judiciously.

We are using impact lines to judge "practical impact of a commit". 
The shorter (while still correct and expressive), the better. We are 
trying to use it in well-defined cases - but not always.

Here it helped expose the bogosity of a patch more clearly: the 
intended impact of "clarifying a confusing API" was not met, and the 
commit became easier to flame.

There's 6 different classes of uses of impact lines right now:

1)

They force smaller patch submissions: it is hard to write a correct 
impact line for an overly complex, multi-purpose patch. Just try it 
in practice and you'll see. It is _much_ easier to write a correct 
impact line for a properly split up patch series.

So instead of bitching with developers again and again, we asked 
frequent sinners to write proper impact lines. Voila, the patches 
became smaller: one patch, one main line of (intended) impact. It is 
a very nicely self-regulating process.

2)

One other purpose of them is to have a ... managerial 
risk-at-a-glance view of a larger set of commits, post facto.

For example:

      $ git log v2.6.29..v2.6.30-rc1 arch/x86/kernel/apic/ | \
                  grep Impact: | sort | uniq -c | sort -n

      1     Impact: build fix
      1     Impact: build fix, cleanup
      1     Impact: cleanup, paranoia
      1     Impact: cleanup, reduce memory usage for CONFIG_CPUMASK_OFFSTACK=y
      1     Impact: cleanup, remove cpumask from stack
      1     Impact: fix bug with irq-descriptor moving when logical flat
      1     Impact: fix incorrect error message
      1     Impact: fix possible race
      1     Impact: fix spurious IRQs
      1     Impact: get correct smp_affinity as user requested
      1     Impact: interface augmentation (not yet used)
      1     Impact: make kexec work with x2apic
      1     Impact: optimize APIC IPI related barriers
      1     Impact: simplification
     10     Impact: cleanup

Shows (at a glance) that we had 5-6 runtime problems (mostly 
misbehavior, not crashes) in the APIC code during the last 
development window.

Or:

      $ git log v2.6.29..v2.6.30-rc1 kernel/sched.c | \
                   grep Impact: | sort | uniq -c | sort -n

      1     Impact: cleanup, micro-optimization
      1     Impact: cleanup, new schedstat ABI
      1     Impact: fix boot crash
      1     Impact: fix circular locking
      1     Impact: fix function graph trace hang / drop pointless softirq on UP
      1     Impact: fix to preempt trace triggering lockdep check_flag failure
      1     Impact: more precise avg_overlap metric - better load-balancing
      1     Impact: struct rq size optimization
      2     Impact: micro-optimization
     12     Impact: cleanup

Shows that we had ~4 runtime problems (crashes or lockdep asserts) 
in the scheduler during the last development window.

3)

"Risk judgement at a glance" cannot be done via other attributes of 
the commit:

The subject lines are too important to be burdened with structured 
risk information, and they are also too specific and spread too 
much. But if you think we can add [fix crash] and [pure cleanup] 
tags to primary subject lines that would be even better ...

We thought that such artificial risk attribute structure was an 
obvious non-starter, because it would depart from existing commit 
practices so much.

The subject line also tends to mimic the patch-submission subject 
lines (so that it aligns with lkml discussions/submissions) and 
tends to be more detailed and differently structured - so it's a lot 
harder to extract only risk/impact information from it, at a glance.

4)

We are also using "Impact: cleanup" as a special tag for commits 
that are supposed to have _zero_ side-effects. "cleanup" otherwise 
can be ambigious: it often covers restructuring / refactoring of 
code and it covers changes that have side-effects. We had several 
cases in the past when an "Impact: cleanup" patch was bisected to - 
and the bisector / bug reporter already knew it straight away that 
there was a misunderstanding about the impact of the commit, without 
having to fully read the patch. This is very useful when someone not 
versed in that particular code meets such a commit down the line.

5)

Impact lines are also very useful during maintenance, when adding it 
to a patch that got submitted by others: if i mis-interpret the 
impact of a patch and add the wrong impact line, people point it 
out. This happened several times in the past, and it can be 
embarrasing - but it forces maintainer attention and honesty.

6)

It forces developer honesty/disclosure as well: sometimes a commit 
log is too wishy-washy and instead of forcing people to rewrite full 
commit logs (often made difficult by language barriers - the 
intersection of people who can write good code an good 
documentation/commits in English is very small - and we shouldnt 
exclude good coders who are not able to write good 
documentation/commits) we ask them (or show them) impact lines.

It also forces developers to _think_ about the full impact of 
patches. We often got bad patches because people clearly did not 
think through what they were trying to do. With an impact line it's 
much easier to argue whether a developer was fully aware of a given 
risk of a commit or not.


All in one, the impact line standardizes risk/impact info in a 
compact form. I do think that 'risk' is an essential attribute of a 
commit.

Is this scheme perfect? Clearly not - and we are still experimenting 
with exactly how to shape it better (you can see several small 
variants).

But it's already pretty useful in the history too - not just while 
writing changes and queueing up commits.

I guess your flame means we must stop using it. Oh well. The party 
was nice while it lasted ;-)

	Ingo
