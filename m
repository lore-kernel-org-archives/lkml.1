Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbZBTPqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbZBTPqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZBTPqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:46:23 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36361 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbZBTPqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:46:22 -0500
Date: Fri, 20 Feb 2009 07:46:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090220154619.GC6960@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220134121.GA19575@damson.getinternet.no> <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu> <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 03:51:28PM +0100, Vegard Nossum wrote:
> 2009/2/20 Ingo Molnar <mingo@elte.hu>:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> ah, indeed:
> >>
> >>         list_del_rcu(&va->list);
> >>
> >> i suspect it could be hit big time in a workload that opens
> >> more than 512 files, as expand_files() uses a
> >> vmalloc()+vfree() pair in that case.
> >
> > hm, perhaps it's not a problem after all. The freeing is done
> > via rcu, and list_del_rcu() leaves the forward pointer intact.
> 
> Well, it's not the particular line that you posted, in any case.
> That's &va->list, but the traversed list is &va->purge_list.
> 
> I thought it would be the line:
> 
>         call_rcu(&va->rcu_head, rcu_free_va);
> 
> (which does kfree() in the callback) that was the problem.
> 
> > So how did it happen that the entry got kfree()d before the loop
> > was done? We are in a spinlocked section so the CPU should not
> > have entered rcu processing.
> 
> I added some printks to __free_vmap_area() and rcu_free_va(), and it
> shows that the kfree() is being called immediately (inside the list
> traversal). So the call_rcu() is happening immediately (or almost
> immediately).
> 
> If I've understood correctly, the RCU processing can happen inside a
> spinlock, as long as interrupts are enabled. (Won't the timer IRQ
> trigger softirq processing, which triggers RCU callback processing,
> for example?)
> 
> And interrupts are enabled when this happens: EFLAGS: 00000292
> 
> Please correct me if I am wrong!

If you are using preemptable RCU, and if the read side accesses are not
protected by rcu_read_lock(), this can happen.  At least for values of
"immediately" in the millisecond range.

If you were using classic or hierarchical RCU, the fact that the
call_rcu() is within a spinlock (as opposed to mutex) critical section
should prevent the grace period from ending.

So, what flavor of RCU were you using?

							Thanx, Paul
