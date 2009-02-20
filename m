Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZBTQEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZBTQEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZBTQEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:04:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60704 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbZBTQEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:04:34 -0500
Date: Fri, 20 Feb 2009 17:04:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090220160409.GB11294@elte.hu>
References: <20090220134121.GA19575@damson.getinternet.no> <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu> <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com> <20090220154619.GC6960@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220154619.GC6960@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Fri, Feb 20, 2009 at 03:51:28PM +0100, Vegard Nossum wrote:
> > 2009/2/20 Ingo Molnar <mingo@elte.hu>:
> > >
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > >> ah, indeed:
> > >>
> > >>         list_del_rcu(&va->list);
> > >>
> > >> i suspect it could be hit big time in a workload that opens
> > >> more than 512 files, as expand_files() uses a
> > >> vmalloc()+vfree() pair in that case.
> > >
> > > hm, perhaps it's not a problem after all. The freeing is done
> > > via rcu, and list_del_rcu() leaves the forward pointer intact.
> > 
> > Well, it's not the particular line that you posted, in any case.
> > That's &va->list, but the traversed list is &va->purge_list.
> > 
> > I thought it would be the line:
> > 
> >         call_rcu(&va->rcu_head, rcu_free_va);
> > 
> > (which does kfree() in the callback) that was the problem.
> > 
> > > So how did it happen that the entry got kfree()d before the loop
> > > was done? We are in a spinlocked section so the CPU should not
> > > have entered rcu processing.
> > 
> > I added some printks to __free_vmap_area() and rcu_free_va(), and it
> > shows that the kfree() is being called immediately (inside the list
> > traversal). So the call_rcu() is happening immediately (or almost
> > immediately).
> > 
> > If I've understood correctly, the RCU processing can happen inside a
> > spinlock, as long as interrupts are enabled. (Won't the timer IRQ
> > trigger softirq processing, which triggers RCU callback processing,
> > for example?)
> > 
> > And interrupts are enabled when this happens: EFLAGS: 00000292
> > 
> > Please correct me if I am wrong!
> 
> If you are using preemptable RCU, and if the read side 
> accesses are not protected by rcu_read_lock(), this can 
> happen.  At least for values of "immediately" in the 
> millisecond range.
> 
> If you were using classic or hierarchical RCU, the fact that 
> the call_rcu() is within a spinlock (as opposed to mutex) 
> critical section should prevent the grace period from ending.
> 
> So, what flavor of RCU were you using?

well, even in preemptible RCU the grace period should be 
extended as long as we are non-preempt (which we are here), 
correct?

Preemptible RCU does make an rcu_read_lock() critical section 
preemptible, so if this were protected by rcu_read_lock() it 
would be a bug. But it does not make spin_lock() section 
preemptible, and this is a spin_lock(&vmap_area_lock) section:

                spin_lock(&vmap_area_lock);
-               list_for_each_entry(va, &valist, purge_list)
+               list_for_each_entry_safe(va, n_va, &valist, purge_list)
                       	__free_vmap_area(va);
                spin_unlock(&vmap_area_lock);

	Ingo
