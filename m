Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYCYKtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYCYKtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYCYKt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:49:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45447 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbYCYKt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:49:26 -0400
Date: Tue, 25 Mar 2008 11:48:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: jirislaby@gmail.com, viro@ZenIV.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
	- formatting only
Message-ID: <20080325104841.GA24211@elte.hu>
References: <20080323085210.GE10722@ZenIV.linux.org.uk> <20080323.032013.79276201.davem@davemloft.net> <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323.051929.267232495.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> > I disagree. It's just misuse in this case (like using Lindent on 
> > whole tree).
> 
> Unlike sparse, this thing encourages the kind of behavior seen here.
> 
> And even worse it becomes monkey see monkey do.
> 
> There are mountains of more useful stuff to be working on (much of it 
> automated, but unlike checkpatch work doesn't result in crap) rather 
> than 148 patches of checkpatch vomit.

Joe should not have spammed lkml like this - but let me take up the 
general issue of checkpatch that you touch upon - even if the incident 
at hand puts checkpatch into an unfavorable light.

> Fixing sparse warnings properly fixes real issues, whereas fixing 
> checkpatch stuff creates garbage 9 times out of 10.

actually, my experience has been that 99% of the arch/x86 sparse 
annotations dont fix any "real" issue but remove a warning. The 
remaining 1% still very much makes it worth though (they can prevent a 
security hole, a bad bug, endianness incompatibility, etc.), so we've 
taken a large amount of sparse annotations in arch/x86 in the past few 
months - while fixing exactly zero "real" bugs in the process.

Same goes for checkpatch: almost no individual checkpatch change _looks_ 
worthwile in isolation, but the combined effect very much shows and 
avoids real bugs. (While Sparse is 'type functional' and checkpatch is 
'style only' - still both avoid real bugs - see below why.)

Lets consider the "end result" that we are aiming for. One example of a 
"checkpatch clean" codebase is the scheduler (kernel/sched*.[ch]):

 $ code-quality kernel/sched*.[ch]

                               errors   lines of code   errors/KLOC
 kernel/sched.c                     0            8490             0
 kernel/sched_debug.c               0             402             0
 kernel/sched_fair.c                0            1475             0
 kernel/sched_idletask.c            0             130             0
 kernel/sched_rt.c                  0            1341             0
 kernel/sched_stats.h               0             238             0

The value of a "checkpatch clean" codebase is significant to me as a 
maintainer. No matter where i look at the (rather sizable) scheduler 
codebase, the style is uniform and changes all look the same and are 
much easier to review. Since 2.6.22 we've managed to do about 500 
changes to this 10 KLOC codebase, with a very low regression rate - that 
is more than 10 times the rate of change of the kernel as a whole.

We couldnt achieve that without broad "visual uniformity". Human vision 
is based on pattern matching, which brain capacity has a physical limit. 
Reducing the complexity of that process, and helping the "flow of eye 
movement during review" is just as important as to clean up the logic of 
code - it gives us better chances to find a bad bug during review.

We here on lkml are all quite good at filtering out unnecessary visual 
noise when reviewing patches and writing code, but i prefer to reserve 
that brain capacity towards understanding the code and finding mistakes 
in it.

So i minimize all visual distractions in my physical work environment (i 
optimize the field of view i have at the monitor), i minimize visual 
distractions in the editor i use (no GUI for example, just plain 
fullscreen text view with no borders, no menus, etc.), and an important 
part of that is that i also minimize all unnecessary distractions in the 
_code_ itself that i maintain.

But if you look at the git log of the scheduler in of the past 5 months, 
you'll see a striking lack of trivial, checkpatch generated "monkey" 
patches.

Why? Because all the patches that are applied are checkpatch-clean from 
the get go, so there's no need for trivialities. There were certainly 
some checkpatch "trivialities" early in the process (despite the 
scheduler being very clean to begin with), but the transients have 
subsided meanwhile and what we have is a squeaky-clean codebase in 
action. In this model of maintenance, checkpatch ends up being just a 
'background force' that never truly comes to the surface to bother us 
with explicit trivialities. In other words: there's _zero_ room for 
"monkey patches".

Note that there are no "problems to development patches" caused by 
scheduler cleanups either - because there are essentially _no_ cleanup 
patches at all in the scheduler - almost all patches we apply to the 
scheduler are clean.

arch/x86 is on a similar path:

                                         errors    LOC     err/KLOC
                                         -----------------------------
 v2.6.24-rc1      arch/x86/                8695   117423   74.0
 v2.6.24-x86.git  arch/x86/ [21 Nov 2007]  5190   117156   44.2
 v2.6.24-x86.git  arch/x86/ [18 Dec 2007]  4057   117213   34.6
 v2.6.24-x86.git  arch/x86/ [ 8 Jan 2008]  3650   117987   30.9
 v2.6.24-x86.git  arch/x86/ [ 4 Feb 2008]  3334   133542   24.9
 v2.6.25-x86.git  arch/x86/ [21 Feb 2008]  2724   136963   19.8
 v2.6.25-x86.git  arch/x86/ [ 1 Mar 2008]  2155   136404   15.7
 v2.6.25-x86.git  arch/x86/ [21 Mar 2008]  1979   137205   14.4

and once we reach a "zero" state, the flow of "explicit" checkpatch 
patches comes to a virtual standstill - just like it did for the 
scheduler. And we broke up the "please dont do this to my outstanding 
development patches" Catch-22 (which is also a way too easy place for 
lazy developers to hide behind) by doing backports/forward ports along 
more intrusive cleanups.

On a more conceptual angle: "coding style", despite being entirely 
"non-functional" (it does not affect the generated code), is still very 
much an integral part of the code because source code is fundamentally 
about "knowledge" - and extra style noise in knowledge can never 
possibly increase the quality of that knowledge. There are strong links 
between code correctness and typography/aesthetics.

So, in the specific example of the scheduler subsystem, i've only 
observed advantages to checkpatch and zero downsides. Could anyone give 
me _any_ objective reason why i shouldnt be using checkpatch for the 
scheduler? More broadly, could anyone give me an objective reason why we 
shouldnt be doing it for arch/x86? And even more broadly, could anyone 
give me an objective reason why we shouldnt be doing it for all actively 
maintained areas of the kernel?

	Ingo
