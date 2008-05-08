Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbYEHUUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbYEHUUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbYEHUUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:20:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39785 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbYEHUUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:20:21 -0400
Date: Thu, 8 May 2008 22:19:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix
	AIM7 40% regression with 2.6.26-rc1)
Message-ID: <20080508201956.GA2547@elte.hu>
References: <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org>
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

> On Thu, 8 May 2008, Linus Torvalds wrote:
> > 
> > Why don't we just make it do the same thing that the x86 semaphores used 
> > to do: make it signed, and decrement unconditionally. And callt eh 
> > slow-path if it became negative.
> > ... 
> > and now we have an existing known-good implementation to look at?
> 
> Ok, after having thought that over, and looked at the code, I think I 
> like your version after all. The old implementation was pretty complex 
> due to the need to be so extra careful about the count that could 
> change outside of the lock, so everything considered, a new 
> implementation that is simpler is probably the better choice.

yeah. I thought about that too, the problem i found is this thing in the 
old lib/semaphore-sleepers.c code's __down() path:

        remove_wait_queue_locked(&sem->wait, &wait);
        wake_up_locked(&sem->wait);
        spin_unlock_irqrestore(&sem->wait.lock, flags);
        tsk->state = TASK_RUNNING;

that mystery wakeup once i understood to be necessary for some weird 
ordering reason, but it would probably be hard to justify in the new 
code, because it's done unconditionally, regardless of whether there are 
sleepers around.

And once we deviate from the old code, we might as well go for the 
simplest approach - which also happens to be rather close to the mutex 
code's current slowpath - just with counting property added, legacy 
semantics and no lockdep coverage.

> Ergo, I will just pull your scheduler tree.

great! Meanwhile a 100 randconfigs booted fine with that tree so i'd say 
the implementation is robust.

i also did a quick re-test of AIM7 because the wakeup logic changed a 
bit from what i tested initially (from round-robin to strict FIFO), and 
as expected not much changed in the AIM7 results on the quad:

  Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
  2000    55019.9         96      211.6   806.5   0.4585
  2000    55116.2         90      211.2   804.7   0.4593
  2000    55082.3         82      211.3   805.5   0.4590

this is slightly lower but the test was not fully apples to apples 
because this also had some tracing active and other small details. It's 
still very close to the v2.6.25 numbers. I suspect some more performance 
could be won in this particular workload by getting rid of the BKL 
dependency altogether.

	Ingo
