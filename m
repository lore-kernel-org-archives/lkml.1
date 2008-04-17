Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbYDQIae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbYDQIae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYDQIaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:30:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43311 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbYDQIaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:30:23 -0400
Date: Thu, 17 Apr 2008 10:30:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080417083000.GA4935@elte.hu>
References: <20080416202338.GA6007@elte.hu> <20080417002552.5742ad65.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417002552.5742ad65.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 16 Apr 2008 22:23:38 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > what's brewing in x86.git for v2.6.26?
>
> How much of this has not been in -mm?

all of these are in linux-next, and most of them are in -mm.
 
the for-akpm branch has 646 commits at the moment (these are the ones 
that are in -mm), out of 890 patches. These are the "pure arch/x86" 
topic patches, and which will be offered in the first wave of pull 
requests.

Of the remaining patches, they'll be offered under different topics, in 
different temporary branches (or trees) depending on which subsystem 
they interact with. There will be no "take it or leave it" big pull 
request.

Some patches are later in the queue because they depend on generic 
infrastructure.

Some wont be offered for a pull at all because they belong into other 
subsystems and we just track them via x86.git because it's some 
important topic or dangerous-looking patch we'd like to see the effects 
of first-hand.

[ sorry about not having described this in detail in my mail - i spent 
  the last 3 work days on a 2.6.25 regression almost non-stop, so x86 
  queue cleanup lagged behind a bit and my description of the changes 
  was rather terse. ]

> How much of this has not been in linux-next?

none.

but we do much more testing than just getting code into other trees. We 
cross-build 96 different configurations on other non-x86 architectures:

  http://www.tglx.de/autoqa-cgi/index?run=81&tree=1

last night's run was: 96 out of 96 configs built successfully.

This covers: alpha, arm, mips, powerpc, sparc64, x86, m32r, powerpc, 
xtensa, mips, sh, sparc, parisc, powerpc. We test the various branches 
(amongst them for-akpm) and combination trees as well.

and the backbone of arch/x86 QA we do are the build, boot and stress 
tests we do on x86: we ran and booted thousands of x86 randconfigs in 
the past few days alone. x86/latest boots and works from the smallest 
boxes up to a 64-way testbox. On the 64-way box i did a 1 week burn-in 
stress-test last week as well, for any longer-term effects.

> >  - ftrace plugin for sysprof
> 
> sysprof is crap.

you mean the original hack? Sure, that had a number of problems and we 
are not offering that for a merge.

But have you seen the latest code we are offering for merge? Check out 
sched-devel/latest and kernel/trace/trace_sysprof.c. Nicely generalized 
on top of stacktrace.h, put into the ftrace framework, userspace has 
been ported to that too. No more special sysprof-only API hack.

> >  - debug helper: view kernel pagetable layout via debugfs
> 
> Needs documentation.

ok, will fix.

> >       x86: introduce /dev/mem restrictions with a config option
> 
> This should be runtime-settable, not build-time settable.

... that defeats one of the security purposes of this feature. (which is 
to make it a bit harder for rootkits to just patch themselves in via 
/dev/mem)

> > Randy Dunlap (2):
> > ...
> >       linux-next: Tree for April 10 (arch/x86)
> 
> borked patch title.

thanks, fixed. This patch will be backmerged shortly before pushout 
anyway (like you do for -mm, to maintain bisectability) so the title 
does not matter (the fix and credit will be added to the original 
patch).

Note that this is from the tail of the queue - not all commit entries 
are sanitized yet.

> > Soren Sandmann (1):
> >       x86: add the debugfs interface for the sysprof tool
> 
> There were serious objections that this is weaker than and duplicative 
> of oprofile which were not adequately addressed.
> 
> Also, I (and apparently only I) actually reviewed the implementation 
> and found it to be riddled with bugs and shortcomings.  afacit this 
> was completely ignored and you propose to merge it anwyay?

no.

I think what caused the confusion is that the cleaned up sysprof ftrace 
plugin depends on the presence of the ftrace infrastructure, which is in 
sched-devel. The patch you see in x86.git is the (now obsolete, and 
removed) sysprof code. Those interim commits show up in the shortlog but 
we (of course) wont push them upstream. Sorry about the confusion ...

i just cleaned this up and pushed out a new x86.git and sched.git.

	Ingo
