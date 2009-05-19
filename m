Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbZESKuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbZESKuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZESKuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:50:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZESKuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:50:08 -0400
Subject: Re: INFO: possible circular locking dependency at
 cleanup_workqueue_thread
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1242724380.26820.482.camel@twins>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com> <1242676857.32543.1343.camel@laptop>
	 <20090518201650.GA4384@redhat.com> <1242679221.32543.1396.camel@laptop>
	 <20090518221403.GA7393@redhat.com>  <1242724380.26820.482.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 19 May 2009 12:49:14 +0200
Message-Id: <1242730154.26820.501.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 11:13 +0200, Peter Zijlstra wrote:
> On Tue, 2009-05-19 at 00:14 +0200, Oleg Nesterov wrote:
> > On 05/18, Peter Zijlstra wrote:
> > >
> > > On Mon, 2009-05-18 at 22:16 +0200, Oleg Nesterov wrote:
> > > > On 05/18, Peter Zijlstra wrote:
> > > > >
> > > > > On Mon, 2009-05-18 at 21:47 +0200, Oleg Nesterov wrote:
> > > > > >
> > > > > > This output looks obviously wrong, Z does not depend on L1 or any
> > > > > > other lock.
> > > > >
> > > > > It does, L1 -> L2 -> Z as per 1 and 2
> > > > > which 3 obviously reverses.
> > > >
> > > > Yes, yes, I see. And, as I said, I can't explain what I mean.
> > > >
> > > > I mean... The output above looks as if we take L1 and Z in wrong order.
> > > > But Z has nothing to do with this deadlock, it can't depend on any lock
> > > > from the correctness pov. Except yes, we have it in L1->L2->Z->L1 cycle.
> > >
> > > AB-BC-CA deadlock
> > >
> > > Thread 1		Thread 2		Thread 3
> > >
> > > L(L1)
> > > 			L(L2)
> > > 						L(Z)
> > > L(L2)
> > > 			L(Z)
> > > 						L(L1)
> > 
> > Sure. Now Z really depends on L1. But if you change Thread 3 to take yet
> > another unique lock X under Z, then lockdep will complain that X depends
> > on L1, not Z.
> > 
> > To clarify, I do not say the output is bugggy. I only meant it could be
> > better. But I don't understand how to improve it.
> > 
> > If we return to the original bug report, perhaps cpu_add_remove_lock
> > has nothing to do with this problem... we could have the similar output
> > if device_pm_lock() is called from work_struct.
> > 
> > > And you're saying, we can't have that deadlock because we don't have the
> > > 3 separate functions?
> > 
> > No,
> > 
> > > That is, there is no concurrency on Z because its always taken under L2?
> > 
> > Yes, nobody else can hold Z when we take L2.
> > 
> > But this wasn't my point.
> > 
> > > For those situations we have the spin_lock_nest_lock(X, y) annotation,
> > > where we say, there cannot be any concurrency on x element of X, because
> > > all such locks are always taken under y.
> > 
> > We can just kill L(Z) instead of annotating, this changes nothing from
> > the correctness pov, we have the same deadlock. But the output becomes
> > very clear: L1 depends on L2.
> > 
> > 
> > OK, please forget. Not sure why I started this thread. Just because I
> > was surprised a bit when I figured out that lockdep's output does not
> > match my naive expectations.
> 
> Well, since you're quite versed in the field, I'm guessing other people
> might find it even more confusing -- so it might well do to explore this
> situation a bit further, if only to see if we can make lockdep output
> 'easier'.
> 
> There is a solution to this, Gautham suggested it a while back, we could
> make lockdep scan a lock (Z) his dependencies and if in every chain a
> particular other lock (L2) was taken, ignore this lock (Z) his
> dependency for the circular analysis at hand.
> 
> That would mean we would not find the Z->L1 dep to violate the existing
> one, because we would ignore L2->Z (because in every Z we hold L2), and
> we would indeed fail on the next: L2->L1 on the next line in your
> initial program.
> 
> Implementing this however might be slightly less trivial than this
> explanation -- it would however rid us of the spin_lock_nest_lock()
> annotation's need.

Ingo pointed out that that would weaken the possible deadlock detection
in that it would have to observe a Z outside of L2 before reporting the
problem, which might be a very rare, but existing, code path.

Another possible way might be to find the smallest cycle instead of just
any (the first) cycle.

