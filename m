Return-Path: <linux-kernel-owner+w=401wt.eu-S1762326AbYEGRGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762326AbYEGRGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYEGRFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:05:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55087 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbYEGRFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:05:51 -0400
Date: Wed, 7 May 2008 19:05:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507170528.GA11511@elte.hu>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <20080507162012.GA10096@elte.hu> <alpine.LFD.1.10.0805070929310.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805070929310.3024@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > I think it is far more likely that it's due to the different 
> > scheduling and wakeup behavior of the new kernel/semaphore.c code. 
> > So the fix would be to restore the old scheduling behavior - that's 
> > what Yanmin's manual revert did and that's what got him back the 
> > previous AIM7 performance.
> 
> Yes, Yanmin's manual revert got rid of the new semaphores entirely. 
> Which was what, 7500 lines of code removed that got reverted.

i wouldnt advocate a 7500 revert instead of a 160 lines change.

my suggestion was that the scheduling behavior of the new 
kernel/semaphore.c code is causing the problem - i.e. making it match 
the old semaphore code's behavior would give us back performance.

> And the *WHOLE* and *ONLY* excuse for dropping the spinlock 
> lock_kernel was this (and I quote your message):
> 
>     remove the !PREEMPT_BKL code.
>     
>     this removes 160 lines of legacy code.
> 
> in other words, your only stated valid reason for getting rid of the 
> spinlock was 160 lines, and the comment didn't even match what it did 
> (it removed the spinlocks entirely, not just the preemptible version).

it was removed by me in the course of this discussion:

   http://lkml.org/lkml/2008/1/2/58

the whole discussion started IIRC because !CONFIG_PREEMPT_BKL [the 
spinlock version] was broken for a longer period of time (it crashed 
trivially), because nobody apparently used it. People (Nick) asked why 
it was still there and i agreed and removed it. CONFIG_PREEMPT_BKL=y was 
the default, that was what all distros used. I.e. the spinlock code was 
in essence dead code at that point in time.

the spinlock code might in fact perform _better_, but nobody came up 
with such a workload before.

> In contrast, the revert adds 7500 lines. If you go by the only 
> documented reason for the crap that is the current BKL, then I know 
> which one I'll take. I'll take the spinlock back, and I'd rather put 
> preemption back than ever take those semaphores.
> 
> And even that's ignoring another issue: did anybody ever even do that 
> AIM7 benchmark comparing spinlocks to the semaphore-BKL? It's quite 
> possible that the semaphores (even the well-behaved ones) behaved 
> worse than the spinlocks.

that's a good question...

	Ingo
