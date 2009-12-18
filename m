Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZLRPkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZLRPkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbZLRPka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:40:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55738 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbZLRPk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:40:29 -0500
Date: Fri, 18 Dec 2009 16:39:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
Message-ID: <20091218153930.GA15922@elte.hu>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
 <1261143924.20899.169.camel@laptop>
 <alpine.LFD.2.00.0912180724580.3712@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912180724580.3712@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> IOW, if you hold a lock, and then do 'flush_workqueue()', lockdep has no 
> idea that maybe one of the entries on a workqueue might need the lock that 
> you are holding. But I don't think lockdep sees the dependency that gets 
> created by the flush - because it's not a direct code execution dependency.

Do you mean like the annotations we added in:

  4e6045f: workqueue: debug flushing deadlocks with lockdep
  a67da70: workqueues: lockdep annotations for flush_work()

?

It looks like this currently in the worklet:

                lock_map_acquire(&cwq->wq->lockdep_map);
                lock_map_acquire(&lockdep_map);
                f(work);
                lock_map_release(&lockdep_map);
                lock_map_release(&cwq->wq->lockdep_map);

and like this in flush:

        lock_map_acquire(&wq->lockdep_map);
        lock_map_release(&wq->lockdep_map);
        for_each_cpu(cpu, cpu_map)
                flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));

We basically track the implicit dependencies even if they are not executed 
(only theoretically possible) - and we subsequently caught a few bugs that 
way.

Or did you have some other dependency in mind?

	Ingo
