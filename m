Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYG1H4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYG1H4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 03:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYG1H4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 03:56:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbYG1H4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 03:56:31 -0400
Date: Mon, 28 Jul 2008 09:56:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>
Subject: Re: [git pull] cpus4096 fixes
Message-ID: <20080728075611.GA16208@elte.hu>
References: <20080727190601.GA764@elte.hu> <200807281042.12860.rusty@rustcorp.com.au> <20080727200636.96da12d0.akpm@linux-foundation.org> <200807281634.43036.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807281634.43036.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Monday 28 July 2008 13:06:36 Andrew Morton wrote:
> > On Mon, 28 Jul 2008 10:42:12 +1000 Rusty Russell <rusty@rustcorp.com.au> 
> wrote:
> > > The 4k CPU patches have been sliding in without review up until now.
> >
> > wot?
> 
> This surprises you? [...]

you should check many of the earliest iterations (it's all on lkml), and 
the bits we rejected in review/testing. You'll be surprised how much 
questionable and fragile stuff was filtered out.

But your intuition is right in a sense, this whole topic _feels_ ugly, 
and there's a good reason for it and i doubt you'll like it:

Much of it derives from the ugly fact that cpumasks were designed to be 
word-size-ish and are used as such in hundreds of places in the kernel, 
while with 4K CPUs they become half a _kilobyte_.

That causes the basic conceptual friction. That fundamental unease is 
what caused me to split these patches off into a completly separate 
topic, so that they can be NAK-ed individually without blocking other 
subsystem changes. Mike will be able to tell you how many bits were 
rejected and rewritten - it's been one of the most iterated topics.

Unless you know some good way around that basic "0.5K cpumask" problem 
[besides the 'dont try to do it at all then, stupid' solution] Mike's 
painful year-long, multi-release, all-on-lkml effort to bootstrap a 4K 
CPUs kernel, to track down dozens of early boot crashes, to look at 
stack sizes in zillions of functions, to write a ton of patches to 
evolve the APIs to cope with it better (all of this was done out in the 
open on lkml for all to see) looks like quite close to what _can_ be 
done.

128/256/512/1024 CPU support (which has been upstream for years and 
built into enterprise distros, etc.) already turned cpumasks into rather 
static objects in practice and their proliferation into hotpaths stopped 
- so maybe we could just turn them into non-stack objects from now on.

( with perhaps some nice wrappers that turns then into on-stack objects
  to not slow down the common case. Mike tried to do something like 
  that. )

Help and more cleanup patches welcome. Mike & co did most of the hard 
work already, latest -git does boot with 4K cpus built into the kernel. 
We can iterate this stuff a _lot_ easier now. Turn on CONFIG_MAXSMP=y on 
x86 and you can boot it on your PC.

> [...]  I stumbled across the cpumask_of_cpu() bug because I happened 
> to want it for stop_machine and read the damned code.  But it lead me 
> to the surrounding code, which is pretty questionable.  An 
> arch-specific map, rather than depending on NR_CPUS?  Adding 
> set_cpus_allowed_ptr() instead of changing set_cpus_allowed()? [...]

the set_cpus_allowed_ptr() change too was done due to review feedback, 
to reduce the friction with other tree, to make for smoother migration. 
Breaking an existing API is a far too rude technique for a long-lived 
topic like this. (it's been going on for nearly a year or so)

> [...] Macros which declare things and may or may not do an 
> allocation/free?  Finally a patch so horrifically ugly that it can't 
> be ignored any more gets all the way to Linus.

[ hey, is that your suggested solution you are talking about? ;-) ]

> Overall, it seems like an attempt to sneak in gradual workarounds for 
> cpumasks on the stack, rather than a coherent plan.  I understand the 
> temptation to avoid an "are we prepared to pay this price for large 
> NR_CPUS?" discussion, but we need it anyway.

sure. From a practical standpoint 4096 CPUs support looks pretty stable 
and functional. I boot a 4K cpus kernel every couple of minutes:

 config-Sun_Jul_27_09_15_47_CEST_2008.good:CONFIG_MAXSMP=y
 config-Sun_Jul_27_09_27_00_CEST_2008.good:CONFIG_MAXSMP=y
 config-Sun_Jul_27_09_29_39_CEST_2008.good:CONFIG_MAXSMP=y
 config-Sun_Jul_27_09_36_41_CEST_2008.good:CONFIG_MAXSMP=y
 config-Sun_Jul_27_09_40_22_CEST_2008.good:CONFIG_MAXSMP=y
 config-Sun_Jul_27_09_59_33_CEST_2008.good:CONFIG_MAXSMP=y

 config-Sun_Jul_27_22_14_47_CEST_2008.good:CONFIG_NR_CPUS=8
 config-Sun_Jul_27_22_20_09_CEST_2008.good:CONFIG_NR_CPUS=8
 config-Sun_Jul_27_22_25_32_CEST_2008.good:CONFIG_MAXSMP=y
 config-Sun_Jul_27_22_25_32_CEST_2008.good:CONFIG_NR_CPUS=4096
 config-Sun_Jul_27_22_36_52_CEST_2008.good:CONFIG_MAXSMP=y
 config-Sun_Jul_27_22_36_52_CEST_2008.good:CONFIG_NR_CPUS=4096
 config-Sun_Jul_27_22_42_19_CEST_2008.good:CONFIG_MAXSMP=y
 config-Sun_Jul_27_22_42_19_CEST_2008.good:CONFIG_NR_CPUS=4096
 config-Sun_Jul_27_22_47_28_CEST_2008.good:CONFIG_NR_CPUS=32
 config-Sun_Jul_27_22_52_47_CEST_2008.good:CONFIG_NR_CPUS=32
 config-Sun_Jul_27_22_57_59_CEST_2008.good:CONFIG_NR_CPUS=32

The last difficult regression has been months ago. So this stuff is 
hackable in practice and you can try out the end result if you are 
interested in it.

	Ingo
