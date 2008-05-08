Return-Path: <linux-kernel-owner+w=401wt.eu-S1764480AbYEHPB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764480AbYEHPB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764024AbYEHPBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:01:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764000AbYEHPBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:01:38 -0400
Date: Thu, 8 May 2008 17:01:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix
	AIM7 40% regression with 2.6.26-rc1)
Message-ID: <20080508150121.GA11039@elte.hu>
References: <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508132049.GG19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508132049.GG19219@parisc-linux.org>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> Fair is certainly the enemy of throughput (see also dbench arguments 
> passim).  It may be that some semaphore users really do want fairness 
> -- it seems pretty clear that we don't want fairness for the BKL.

i dont think we need to consider any theoretical arguments about 
fairness here as there's a fundamental down-to-earth maintenance issue 
that governs: old semaphores were similarly unfair too, so it is just a 
bad idea (and a bug) to change behavior when implementing new, generic 
semaphores that are supposed to be a seemless replacement! This is about 
legacy code that is intended to be phased out anyway.

This is already a killer argument and we wouldnt have to look any 
further.

but even on the more theoretical level i disagree: fairness of CPU time 
is something that is implemented by the scheduler in a natural way 
already. Putting extra ad-hoc synchronization and scheduling into the 
locking primitives around data structures only gives mathematical 
fairness and artificial micro-scheduling, it does not actually make the 
end result more useful! This is especially true for the BKL which is 
auto-dropped by the scheduler anyway. (so descheduling a task will 
automatically release it of its BKL ownership)

For example we've invested a _lot_ of time and effort into adding lock 
stealing (i.e. intentional "unfairness") to kernel/rtmutex.c. Which is a 
_lot_ harder to do atomically with PI constraints but still possible and 
makes sense in the grand scheme of things. kernel/mutex.c is also 
"unfair" - and that's correct IMO.

For the BKL in particular there's almost no sense to talk about any 
underlying resource and there's almost no expectation from users for 
that imaginery resource to be shared fairly.

	Ingo
