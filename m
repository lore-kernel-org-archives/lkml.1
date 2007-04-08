Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXDHKlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXDHKlo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 06:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbXDHKlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 06:41:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55746 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXDHKln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 06:41:43 -0400
Date: Sun, 8 Apr 2007 12:41:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: Re: Ten percent test
Message-ID: <20070408104125.GB11123@elte.hu>
References: <200703290237.38777.kernel@kolivas.org> <200704071423.47790.gene.heskett@gmail.com> <20070407185220.GA31725@elte.hu> <200704071630.25830.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704071630.25830.gene.heskett@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gene Heskett <gene.heskett@gmail.com> wrote:

> That said, I am booted to the patch you sent me now, and this also is 
> a very obvious improvement, one I could easily live with on a long 
> term basis.  I haven't tried a kernel build in the background yet, but 
> I have sat here and played patience for about an hour, looking for the 
> little stutters, but never saw them.  So I could just as easily 
> recommend this one for desktop use, it seems to be working.  tvtime 
> hasn't had any audio or video glitches that I've noted when I was on 
> that screen to check on an interesting story, like the 102 year old 
> lady who finally got her hole in one, on a very short hole, but after 
> 90 years of golfing, she was beginning to wonder if she would ever get 
> one.  Not sure who bought at the 19th hole, HNN didn't cover that 
> traditional part.
> 
> So this patch also works.  And if it gets into mainline, at least 
> Con's efforts at proding the fixes needed will not have been in vain.

thanks for testing it! (for the record, Gene tested sched-mike-4.patch, 
which is Mike's patch from 4 days ago.)

> My question then, is why did it take a very public cat-fight to get 
> this looked at and the code adjusted?  Its been what, nearly 2 years 
> since Linus himself made a comment that this thing needed fixed.  The 
> fixes then done were of very little actual effectiveness and the 
> situation then has gradually deteriorated since.

this is pretty hard to get right, and the most objective way to change 
it is to do it testcase-driven. FYI, interactivity tweaking has been 
gradual, the last bigger round of interactivity changes were done a year 
ago:

 commit 5ce74abe788a26698876e66b9c9ce7e7acc25413
 Author: Mike Galbraith <efault@gmx.de>
 Date:   Mon Apr 10 22:52:44 2006 -0700

     [PATCH] sched: fix interactive task starvation

(and a few smaller tweaks since then too.)

and that change from Mike responded to a testcase. Mike's latest changes 
(the ones you just tested) were mostly driven by actual testcases too, 
which measured long-term timeslice distribution fairness.

It's really hard to judge interactivity subjectively, so we rely on 
things like interbench (written by Con) - in which testsuite the 
upstream scheduler didnt fare all that badly, plus other testcases 
(thud.c, game_sim.c, now massive_inter.c, fiftyp.c and chew.c) and all 
the usual test-workloads. This is admittedly a slow process, but it 
seems to be working too and it also ensures that we dont regress in the 
future. (because testcases stick around and do get re-tested)

your system seems to also be a bit special because you 1) drive it to 
the absolute max on the desktop but you do not overload it in obvious 
ways (i.e. your workloads are pretty fairly structured) 2) it's a bit 
under-powered (single-CPU 800 MHz CPU, right?) but not _too_ 
underpowered - so i think you /just/ managed to hit 'the worst' of the 
current interactivity estimator: with important tasks both being just 
above and just below 50%. Believe me, on all ~10 systems i use 
regularly, Linux interactivity of the vanilla scheduler is stellar. (And 
that includes a really old 500 MHz one too with FC6 on it.)

	Ingo
