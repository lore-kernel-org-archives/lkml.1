Return-Path: <linux-kernel-owner+w=401wt.eu-S1752365AbXDOPGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbXDOPGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 11:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXDOPGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 11:06:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46259 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbXDOPGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 11:06:14 -0400
Date: Sun, 15 Apr 2007 17:05:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415150536.GA6623@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704151327.13589.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

[ i'm quoting this bit out of order: ]

> 2. Since then I've been thinking/working on a cpu scheduler design 
> that takes away all the guesswork out of scheduling and gives very 
> predictable, as fair as possible, cpu distribution and latency while 
> preserving as solid interactivity as possible within those confines.

yeah. I think you were right on target with this call. I've applied the 
sched.c change attached at the bottom of this mail to the CFS patch, if 
you dont mind. (or feel free to suggest some other text instead.)

> 1. I tried in vain some time ago to push a working extensable 
> pluggable cpu scheduler framework (based on wli's work) for the linux 
> kernel. It was perma-vetoed by Linus and Ingo (and Nick also said he 
> didn't like it) as being absolutely the wrong approach and that we 
> should never do that. [...]

i partially replied to that point to Will already, and i'd like to make 
it clear again: yes, i rejected plugsched 2-3 years ago (which already 
drifted away from wli's original codebase) and i would still reject it 
today.

First and foremost, please dont take such rejections too personally - i 
had my own share of rejections (and in fact, as i mentioned it in a 
previous mail, i had a fair number of complete project throwaways: 
4g:4g, in-kernel Tux, irqrate and many others). I know that they can 
hurt and can demoralize, but if i dont like something it's my job to 
tell that.

Can i sum up your argument as: "you rejected plugsched, but then why on 
earth did you modularize portions of the scheduler in CFS? Isnt your 
position thus woefully inconsistent?" (i'm sure you would never put it 
this impolitely though, but i guess i can flame myself with impunity ;)

While having an inconsistent position isnt a terminal sin in itself, 
please realize that the scheduler classes code in CFS is quite different 
from plugsched: it was a result of what i saw to be technological 
pressure for _internal modularization_. (This internal/policy 
modularization aspect is something that Will said was present in his 
original plugsched code, but which aspect i didnt see in the plugsched 
patches that i reviewed.)

That possibility never even occured to me to until 3 days ago. You never 
raised it either AFAIK. No patches to simplify the scheduler that way 
were ever sent. Plugsched doesnt even touch the core load-balancer for 
example, and most of the time i spent with the modularization was to get 
the load-balancing details right. So it's really apples to oranges.

My view about plugsched: first please take a look at the latest 
plugsched code:

  http://downloads.sourceforge.net/cpuse/plugsched-6.5-for-2.6.20.patch

  26 files changed, 8951 insertions(+), 1495 deletions(-)

As an experiment i've removed all the add-on schedulers (both the core 
and the include files, only kept the vanilla one) from the plugsched 
patch (and the makefile and kconfig complications, etc), to see the 
'infrastructure cost', and it still gave:

  12 files changed, 1933 insertions(+), 1479 deletions(-)

that's the extra complication i didnt like 3 years ago and which i still 
dont like today. What the current plugsched code does is that it 
simplifies the adding of new experimental schedulers, but it doesnt 
really do what i wanted: to simplify the _scheduler itself_. Personally 
i'm still not primarily interested in having a large selection of 
schedulers, i'm mainly interested in a good and maintainable scheduler 
that works for people.

so the rejection was on these grounds, and i still very much stand by 
that position here and today: i didnt want to see the Linux scheduler 
landscape balkanized and i saw no technological reasons for the 
complication that external modularization brings.

the new scheding classes code in the CFS patch was not a result of "oh, 
i want to write a new scheduler, lets make schedulers pluggable" kind of 
thinking. That result was just a side-effect of it. (and as you 
correctly noted it, the CFS related modularization is incomplete).

Btw., the thing that triggered the scheduling classes code wasnt even 
plugsched or RSDL/SD, it was Mike's patches. Mike had an itch and he 
fixed it within the framework of the existing scheduler, and the end 
result behaved quite well when i threw various testloads on it.

But i felt a bit uncomfortable that it added another few hundred lines 
of code to an already complex sched.c. This felt unnatural so i mailed 
Mike that i'd attempt to clean these infrastructure aspects of sched.c 
up a bit so that it becomes more hackable to him. Thus 3 days ago, 
without having made up my mind about anything, i started this experiment 
(which ended up in the modularization and in the CFS scheduler) to 
simplify the code and to enable Mike to fix such itches in an easier 
way. By your logic Mike should in fact be quite upset about this: if the 
new code works out and proves to be useful then it obsoletes a whole lot 
of code of him!

> For weeks now, Ingo has said that the interactivity regressions were 
> showstoppers and we should address them, never mind the fact that the 
> so-called regressions were purely "it slows down linearly with load" 
> which to me is perfectly desirable behaviour. [...]

yes. For me the first thing when considering a large scheduler patch is: 
"does a patch do what it claims" and "does it work". If those goals are 
met (and if it's a complete scheduler i actually try it quite 
extensively) then i look at the code cleanliness issues. Mike's patch 
was the first one that seemed to meet that threshold in my own humble 
testing, and CFS was a direct result of that.

note that i tried the same workloads with CFS and while it wasnt as good 
as mainline, it handled them better than SD. Mike reported the same, and 
Mark Lord (who too reported SD interactivity problems) reported success 
yesterday too.

(but .. CFS is a mere 2 days old so we cannot really tell anything with 
certainty yet.)

> [...] However at one stage I virtually begged for support with my 
> attempts and help with the code. Dmitry Adamushko is the only person 
> who actually helped me with the code in the interim, while others 
> poked sticks at it. Sure the sticks helped at times but the sticks 
> always seemed to have their ends kerosene doused and flaming for 
> reasons I still don't get. No other help was forthcoming.

i'm really sorry you got that impression.

in 2004 i had a good look at the staircase scheduler and said:

  http://www.uwsg.iu.edu/hypermail/linux/kernel/0408.0/1146.html

   "But in general i'm quite positive about the staircase scheduler."

and even tested it and gave you feedback:

   http://lwn.net/Articles/96562/

i think i even told Andrew that i dont really like pluggable schedulers 
and if there's any replacement for the current scheduler then that would 
be a full replacement, and it would be the staircase scheduler.

Hey, i told this to you as recently as 1 month ago as well:

   http://lkml.org/lkml/2007/3/8/54

   "cool! I like this even more than i liked your original staircase 
    scheduler from 2 years ago :)"

	Ingo

----------->
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -16,6 +16,7 @@
  *		by Davide Libenzi, preemptible kernel bits by Robert Love.
  *  2003-09-03	Interactivity tuning by Con Kolivas.
  *  2004-04-02	Scheduler domains code by Nick Piggin
+ *  2007-04-15	Con Kolivas was dead right: fairness matters! :)
  */
 
