Return-Path: <linux-kernel-owner+w=401wt.eu-S1751090AbXDWTtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbXDWTtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 15:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXDWTtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 15:49:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33737 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbXDWTtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 15:49:16 -0400
Date: Mon, 23 Apr 2007 21:48:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Juliusz Chroboczek <jch@pps.jussieu.fr>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Davidsen <davidsen@tmr.com>,
       Willy Tarreau <w@1wt.eu>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [report] renicing X, cfs-v5 vs sd-0.46
Message-ID: <20070423194821.GA10286@elte.hu>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org> <20070423024245.GA8378@elte.hu> <alpine.LFD.0.98.0704230805510.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704230805510.9964@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> >  4  0      0 475752  13492 176320    0    0     0     0  107 1477 85 15  0  0  0
> >  4  0      0 475752  13492 176320    0    0     0     0  122 1498 84 16  0  0  0
> 
> Did you even *look* at your own numbers? Maybe you looked at 
> "interrpts". The context switch numbers go from 170 per second, to 
> 1500 per second!

i think i managed to look at the correct column :) 1500 per second is 
the absolute ceiling under CFS.

but, even though this utterly ugly hack of renicing (Arjan immediately 
slapped me for it when i mentioned it to him and he correctly predicted 
that lkml would go amok on anything like this) undeniably behaves better 
under CFS and gives a _visually better_ desktop at a 1500 context 
switches per second, i share your unease about it on architectural and 
policy grounds. Doing this hack upstream could easily hinder the 
efficient creation of a healthy economy for "scheduler money", by 
forcibly hacking X out of the picture - while X could be such a nice 
(and important) prototype for a cool and useful new scheduling 
infrastructure.

Basically this hack is bad on policy grounds because it is giving X an 
"legislated, unfair monopoly" on the system. It's the equivalent of a 
state-guaranteed monopoly in certain 'strategic industries'. It has some 
advantages but it is very much net harmful. Most of the time the 
"strategic importance" of any industry can be cleanly driven by the 
normal mechanics of supply and demand: anything important is recognized 
by 'people' as important via actual actions of giving it 'money'. (This 
approach also gives formerly-strategic industries the boot quickly, were 
they to become less strategic to people as things evolve.)

still, recognizing all the very real advantages of a cleaner approach, 
my primary present goal with CFS is to reach "maximum interactivity" 
here and today on a maximimally broad set of workloads, whatever it 
takes, and then to look back and figure out cleaner ways while still 
carefully keeping that maximum interactivity propertly of CFS.

For this particular auto-renicing hack here are the observed objective 
advantages to the user:

 1) while it's still an ugly hack, the increased context-switching rate
    (surprisingly to me!) still has actual, objective, undeniable 
    positive effects even in this totally X-centric worst-case messaging 
    scenario i tried to trigger:

        - visibly better eye-pleasing X behavior under the same
          "performance of scrolling"

        - no hung mouse pointer. Ever. I'd not go as far as Windows to 
          put the mouse refresh code into the kernel, but now having 
          experienced under CFS the 'mouse never hangs under any load' 
          phenomenon for a longer time, i have to admit i got addicted 
          to it. It give instant emotionally positive feedback about 
          "yes, your system is still fine, just overworked a bit", and 
          it also gives a "you caused something to happen on this box, 
          cool boy!" reassurance to the impatient human who is waiting 
          on it - be it that such a minimal thing as a moving mouse 
          pointer.

    There's a new argument as well, not amongst the issues i raised 
    before: people are happily spending 40-50% of their CPU's
    power on Beryl just to get a more ergonomic desktop via 3D effects, 
    so why not allow them to achieve another type of visual ergonomy by 
    allowing an increased, maximum-throttled X context-switch rate,
    without any measurable drop in performance, to a tunable maximum? 
    I can see no easy way for X itself to control this context-switching
    "refresh" rate in a sane way, as its workload is largely detached
    from client workloads and there's no communication between clients.

 2) it's the absolute worst maximum rate you'll ever see under CFS, and
    i definitely concentrated on triggering the worst-case. On other
    schedulers i easily got to 14K context-switches per second or worse,
    depending on the X workload, which hurts performance and makes it 
    behave visually worse. On CFS the 1400 context-switches is the 
    _ceiling_, did not measurably hurt performance and it is tunable 
    ceiling.

 3) this behavior was totally uncontrollable on other schedulers i tried
    and indeed has hurt performance there. On CFS this is still totally
    tunable and controllable on several levels.

i'm not saying that any of this reduces the ugliness of the hack, or 
that any of this makes the strategic disadvantages of this hack 
disappear, i simply tried to point out that despite the existing 
conventional wisdom it's apparently much more useful in practice on CFS 
than on other schedulers.

And if the "economy of scheduling" experiment fails in practice for some 
presently unknown technological reason, we might as well have to go back 
to ugly tricks like this one. With its 5 lines and limited scope i think 
it still beats 500 lines of convoluted scheduling heuristics :-/ Right 
now i'm very positive about the "economy of scheduling" angle, i think 
we have a realistic chance to pull it off.

	Ingo
