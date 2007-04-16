Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbXDPFRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbXDPFRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 01:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbXDPFRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 01:17:14 -0400
Received: from mail39.syd.optusnet.com.au ([211.29.133.79]:57025 "EHLO
	mail39.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733AbXDPFRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 01:17:13 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Mon, 16 Apr 2007 15:16:12 +1000
User-Agent: KMail/1.9.5
Cc: Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu>
In-Reply-To: <20070415150536.GA6623@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 10136
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704161516.12746.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2007 01:05, Ingo Molnar wrote:
> * Con Kolivas <kernel@kolivas.org> wrote:
> > 2. Since then I've been thinking/working on a cpu scheduler design
> > that takes away all the guesswork out of scheduling and gives very
> > predictable, as fair as possible, cpu distribution and latency while
> > preserving as solid interactivity as possible within those confines.
>
> yeah. I think you were right on target with this call.

Yay thank goodness :) It's time to fix the damn cpu scheduler once and for 
all. Everyone uses this; it's no minor driver or $bigsmp or $bigram or 
$small_embedded_RT_hardware feature.

> I've applied the 
> sched.c change attached at the bottom of this mail to the CFS patch, if
> you dont mind. (or feel free to suggest some other text instead.)

>   *  2003-09-03	Interactivity tuning by Con Kolivas.
>   *  2004-04-02	Scheduler domains code by Nick Piggin
> + *  2007-04-15	Con Kolivas was dead right: fairness matters! :)

LOL that's awful. I'd prefer something meaningful like "Work begun on 
replacing all interactivity tuning with a fair virtual-deadline design by Con 
Kolivas".

While you're at it, it's worth getting rid of a few slightly pointless name 
changes too. Don't rename SCHED_NORMAL yet again, and don't call all your 
things sched_fair blah_fair __blah_fair and so on. It means that anything 
else is by proxy going to be considered unfair. Leave SCHED_NORMAL as is, 
replace the use of the word _fair with _cfs. I don't really care how many 
copyright notices you put into our already noisy bootup but it's redundant 
since there is no choice; we all get the same cpu scheduler.

> > 1. I tried in vain some time ago to push a working extensable
> > pluggable cpu scheduler framework (based on wli's work) for the linux
> > kernel. It was perma-vetoed by Linus and Ingo (and Nick also said he
> > didn't like it) as being absolutely the wrong approach and that we
> > should never do that. [...]
>
> i partially replied to that point to Will already, and i'd like to make
> it clear again: yes, i rejected plugsched 2-3 years ago (which already
> drifted away from wli's original codebase) and i would still reject it
> today.

No that was just me being flabbergasted by what appeared to be you posting 
your own plugsched. Note nowhere in the 40 iterations of rsdl->sd did I 
ask/suggest for plugsched. I said in my first announcement my aim was to 
create a scheduling policy robust enough for all situations rather than 
fantastic a lot of the time and awful sometimes. There are plenty of people 
ready to throw out arguments for plugsched now and I don't have the energy to 
continue that fight (I never did really).

But my question still stands about this comment:

>   case, all of SD's logic could be added via a kernel/sched_sd.c module
>   as well, if Con is interested in such an approach. ]

What exactly would be the purpose of such a module that governs nothing in 
particular? Since there'll be no pluggable scheduler by your admission it has 
no control over SCHED_NORMAL, and would require another scheduling policy for 
it to govern which there is no express way to use at the moment and people 
tend to just use the default without great effort. 

> First and foremost, please dont take such rejections too personally - i
> had my own share of rejections (and in fact, as i mentioned it in a
> previous mail, i had a fair number of complete project throwaways:
> 4g:4g, in-kernel Tux, irqrate and many others). I know that they can
> hurt and can demoralize, but if i dont like something it's my job to
> tell that.

Hmm? No that's not what this is about. Remember dynticks which was not 
originally my code but I tried to bring it up to mainline standard which I 
fought with for months? You came along with yet another rewrite from scratch 
and the flaws in the design I was working with were obvious so I instantly 
bowed down to that and never touched my code again. I didn't ask for credit 
back then, but obviously brought the requirement for a no idle tick 
implementation to the table.

> My view about plugsched: first please take a look at the latest
> plugsched code:
>
>   http://downloads.sourceforge.net/cpuse/plugsched-6.5-for-2.6.20.patch
>
>   26 files changed, 8951 insertions(+), 1495 deletions(-)
>
> As an experiment i've removed all the add-on schedulers (both the core
> and the include files, only kept the vanilla one) from the plugsched
> patch (and the makefile and kconfig complications, etc), to see the
> 'infrastructure cost', and it still gave:
>
>   12 files changed, 1933 insertions(+), 1479 deletions(-)

I do not see extra code per-se as being a bad thing. I've heard said a few 
times before "ever notice how when the correct solution is done it is a lot 
more code than the quick hack that ultimately fails?". Insert long winded 
discussion of perfect is the enemy of good here, _but_ I'm not arguing 
perfect versus good, I'm talking about solid code versus quick fix. Again, 
none of this comment is directed specifically at this implementation of 
plugsched, its code quality or intent, but using "extra code is bad" as an 
argument is not enough.

> By your logic Mike should in fact be quite upset about this: if the 
> new code works out and proves to be useful then it obsoletes a whole lot
> of code of him!

> > [...] However at one stage I virtually begged for support with my
> > attempts and help with the code. Dmitry Adamushko is the only person
> > who actually helped me with the code in the interim, while others
> > poked sticks at it. Sure the sticks helped at times but the sticks
> > always seemed to have their ends kerosene doused and flaming for
> > reasons I still don't get. No other help was forthcoming.


> Hey, i told this to you as recently as 1 month ago as well:
>
>    http://lkml.org/lkml/2007/3/8/54
>
>    "cool! I like this even more than i liked your original staircase
>     scheduler from 2 years ago :)"

Email has an awful knack of disguising intent so I took that on face value 
that you did like the idea :). 

Above when I said "no other help was forthcoming" all I was hoping for was 
really simple obvious bugfixes to help me along while I was laid up in bed 
such as "I like what you're doing but oh your use of memset here is bogus, 
here is a one line patch". I wasn't specifically expecting you to fix my 
code; you've got truckloads of things you need to do. 

It just reminds me that the concept of "release early, release often" doesn't 
actually work in the kernel. What is far more obvious is "release code only 
when it's so close to perfect that noone can argue against it" since most of 
the work is done by one person, otherwise someone will come out with a 
counterpatch that is _complete_ earlier but in all possibility not as good, 
it's just ready sooner. *NOTE* In no way am I saying your code is not as good 
as mine; I would have to say exactly the opposite is true pretty much always 
(<sarcasm>conversely then I doubt if I dropped you in my work environment 
you'd do as good a job as I do</sarcasm>). At one stage wli (again at my 
request) put together a quick hack to check for non-preemptible regions 
within the kernel. From that quick hack you adopted it and turned it into 
that beautiful latency tracer that is the cornerstone of the -rt tree 
testing. However, there are many instances I've seen good evolving code in 
the linux kernel be trumped by not-as-good but already-working alternatives 
written from scratch with no reference to the original work. This is the NIH 
(not invented here) mechanism I see happening that is worth objecting to.

What you may find most amusing is the very first iterations of RSDL looked 
_nothing_ like the mainline scheduler. There were all sorts of different 
structures, mechanisms, one priority array, plans to remove scheduler_tick 
entirely and so on. Most of those were never made for public consumption. I 
spent about half a dozen iterations of RSDL removing all of that and making 
it as close to the mainline design as possible, thus minimising the size of 
the patch, and to make it readily readable for most people familiar with the 
scheduler policy code in sched.c (all 5 of them). I should have just said 
bugger it and started everything from scratch with little to no reference to 
the original scheduler but found myself obliged to try to do things the 
minimal code patch size readable difference thingy that was valued in linux 
kernel development. I think the radically different approach would have been 
better in the long run. Trying to play ball I ruined it.

Either way I've decided for myself, my family, my career and my sanity I'm 
abandoning SD. I will shelve SD and try to have fond memories of SD as an 
intellectual prompting exercise only

> 	Ingo

-- 
-ck
