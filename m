Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbYGHImZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbYGHImZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbYGHImQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:42:16 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:37978 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750810AbYGHImP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:42:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ceIS+RvwbNHy65kT+EQXEc7piy57KxXaVJsScAJOhmyoJzE1Ehm1wPjLoNzLDoFYJ6/xMihBBQGr5x3WFgr3ltMBsidEX2Lt7XDuxXTiEw84D2hKqweIrdBpYxuyXXVPEVs501DQsZqNHszCLBgJlqapHVGr9yGKXAmGGUs41k8=  ;
X-YMail-OSG: VtraYVcVM1mbGrnwOLqqNtXBEd9aH5PE7WniGmUus8OVuhwqRUe1WWP9g12wDsWKZmVN3oSzHEZarvkcVU1OFpidtjW.1q4CRISbt4owIps8uqIIbY3ylOyU.fi0JllkZBY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin with irqs disable
Date: Tue, 8 Jul 2008 18:41:50 +1000
User-Agent: KMail/1.9.5
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> <200807081207.34453.nickpiggin@yahoo.com.au> <487301B0.8050801@goop.org>
In-Reply-To: <487301B0.8050801@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081841.50422.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 15:57, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:

> > They prevent lots of unfairness and starvation problems. The most
> > prominent one (ie. actually observed in Linux) was a single CPU
> > being totally starved by N others (to the point where lockup timers
> > would kick in).
>
> Yep.  My understanding was that the specific case was that cpu A was
> repeatedly taking and releasing the lock, while other cpus spin waiting
> for it, and that the cache coherence logic kept the cacheline owned by A
> (presumably because it kept modifying it).

In that case, the CPUs I've tested seem to do a reasonable job of
avoiding hogging the lock. And they all obviously make something of
an attempt at starvation/fairness of simple cacheline access...

But spinlocks require cacheline access *at exactly the right time*
in order to make progress. So simple cacheline fairness can break
down quite easily.


> Ticket locks work well in 
> this case because, as you say, it enforces a fairness policy that the
> hardware doesn't implement.  Are there other cases that ticket locks
> help with?

Well just starvation and fairness mainly.

Interestingly, it actually has some better scalability properties under
high contention sometimes (because the lock aquisition slowpath requires
no further stores to the cacheline).

If a single CPU is allowed to take and release a contended lock
multiple times, I don't consider that in itself as a bad property of
a lock implementation. I just reasoned that (maybe a little counter
intuitively) it isn't such an important thing to have either...


> Does the algorithm above solve the starvation issue? 

I don't believe so because there is still no guarantee you get out of
the slowpath (it's fairly similar to old spinlocks in that regard).


> > As an aside, these locks you propose are also a lot more costly in
> > the contended path. 4 vs 1 atomic operations on the lock cacheline
> > is not so great.
>
> Yep, that's not great.  But it doesn't bounce cache lines around as much
> either, so perhaps it doesn't make much difference.
>
> But really, I was being my own devil's advocate, to see if there's some
> other lock algorithm which satisfies both the normal ticket-lock case
> and the virtualization case.

Yeah, I'm not sure. I expect it would be hard to match ticket lock's
simplicity and guarantees.


> I have no real objections to ticket locks, so long as I can turn them off
> ;)

Sure. Btw. I have no problems with your patchset, but if SMP guests
are seriously used on x86, just remember the fairness issue. At some
point you might find you'll need an even more advanced lock for Xen.
