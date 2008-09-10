Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYIJLsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYIJLsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYIJLsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:48:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40082 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbYIJLsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:48:09 -0400
Date: Wed, 10 Sep 2008 13:47:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: some lock annotations for user copy paths
Message-ID: <20080910114755.GA9696@elte.hu>
References: <20080910113717.GB16811@wotan.suse.de> <1221046892.30429.85.camel@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221046892.30429.85.camel@twins.programming.kicks-ass.net>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2008-09-10 at 13:37 +0200, Nick Piggin wrote:
> > copy_to/from_user and all its variants (except the atomic ones) can take a
> > page fault and perform non-trivial work like taking mmap_sem and entering
> > the filesyste/pagecache.
> > 
> > Unfortunately, this often escapes lockdep because a common pattern is to
> > use it to read in some arguments just set up from userspace, or write data
> > back to a hot buffer. In those cases, it will be unlikely for page reclaim
> > to get a window in to cause copy_*_user to fault.
> > 
> > With the new might_lock primitives, add some annotations to x86. I don't
> > know if I caught all possible faulting points (it's a bit of a maze, and I
> > didn't really look at 32-bit). But this is a starting point.
> > 
> > Boots and runs OK so far.
> 
> shouldn't some of that be conditional on pagefault_disable() 'n such?

i dont think so - those have their own special __atomic user-copy 
primitives which Nick didnt touch.

but i think it should be a single primitive sprinkled around, 
might_fault(), which would be something like:

> > +	might_sleep();
> > +	if (current->mm)
> > +		might_lock_read(&current->mm->mmap_sem);

that way it's a lot less visually intrusive as well.

	Ingo
