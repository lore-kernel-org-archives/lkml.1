Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbZGMHB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbZGMHB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 03:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbZGMHBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 03:01:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42336 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbZGMHBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 03:01:21 -0400
Date: Mon, 13 Jul 2009 09:01:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RESEND PATCH 01/11] kernel:lockdep:print the shortest
	dependency chain if finding a circle
Message-ID: <20090713070110.GA28499@elte.hu>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com> <1246201486-7308-2-git-send-email-tom.leiming@gmail.com> <20090711213028.GC6641@nowhere> <d82e647a0907111942o1cf22batb204c38bfbd43c03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0907111942o1cf22batb204c38bfbd43c03@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ming Lei <tom.leiming@gmail.com> wrote:

> > If I understand well, lets imagine the following:
> >
> > Task 1 acquires: A B F
> > Task 2 acquires: A B C D E F
> > Task 3 acquires: F B
> >
> > Before your patch, DFS would report the BF - FB wicked 
> > dependency by reporting the Task 2 dependency snapshot, which is 
> > cluttered by the other locks C, D and E (that would be reported 
> > in the dependency chain if I'm not wrong) whereas BFS would be 
> > smarter by finding the shortest snapshot found in Task 3: just F 
> > B.
> >
> > Correct me if I misunderstand this patch.
> 
> You are correct, BFS will always find the shortest circle if there 
> is circle.
> 
> > I suggest you to provide an example along this patch, that would 
> > make it easier to demonstrate its importance.
> 
> No, as you said, the shortest circle is not very important, and it 
> is just a byproduct and we have no reason to reject it.

It's a nice byproduct, beyond the primary advantage of not being a 
stack based recursion check.

I think this patch-set is great, and there's just one more step 
needed to make it round: it would be nice to remove the limitation 
of maximum number of locks held per task. (MAX_LOCK_DEPTH)

The way we could do it is to split out this bit of struct task:

#ifdef CONFIG_LOCKDEP
# define MAX_LOCK_DEPTH 48UL
        u64 curr_chain_key;
        int lockdep_depth;
        unsigned int lockdep_recursion;
        struct held_lock held_locks[MAX_LOCK_DEPTH];
        gfp_t lockdep_reclaim_gfp;
#endif

into a separate 'struct lockdep_state' structure, and allocate it 
dynamically during fork with a initial pre-set size of say 64 locks 
depth. If we hit that limit, we'd double the allocation threshold, 
which would cause a larger structure to be allocated for all newly 
allocated tasks.

( This means that the task that hits this threshold needs to have
  lockdep disabled until it exits - but that's OK. )

	Ingo
