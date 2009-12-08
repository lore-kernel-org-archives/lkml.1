Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZLHNgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZLHNgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 08:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbZLHNgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 08:36:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:54686 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbZLHNgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 08:36:31 -0500
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4B1E4548.5040408@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-5-git-send-email-tj@kernel.org>
	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>
	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>
	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop>
	 <4B1CE1E8.2070803@kernel.org>  <4B1E1130.9050108@kernel.org>
	 <1260262963.3935.1002.camel@laptop>  <4B1E189B.1070204@kernel.org>
	 <1260268453.3935.1106.camel@laptop>  <4B1E378A.5050101@kernel.org>
	 <1260272885.3935.1189.camel@laptop>  <4B1E3EE0.7030001@kernel.org>
	 <1260274232.3935.1223.camel@laptop>  <4B1E4548.5040408@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 14:35:51 +0100
Message-ID: <1260279351.3935.1375.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 21:23 +0900, Tejun Heo wrote:
> On 12/08/2009 09:10 PM, Peter Zijlstra wrote:
> > Hotplug and deterministic are not to be used in the same sentence, its
> > an utter slow path and I'd much rather have simple code than clever code
> > there -- there's been way too many 'interesting' hotplug problems.
> 
> Slow and indeterminism comes in different magnitudes.

Determinism does _not_ come in magnitudes, its a very binary property,
either it is or it is not.

As to the order of slowness for unplug, that is about maximal, its _the_
slowest path in the whole kernel.

> > Furthermore if it's objective is to cater to generic thread pools then I
> > think its an utter fail simply because it mandates strict cpu affinity,
> > that basically requires you to write a work scheduler to balance work
> > load etc.. Much easier is a simple unbounded thread pool that gets
> > balanced by the regular scheduler.
> 
> The observation was that for most long running async jobs, most time
> is spent sleeping instead of burning cpu cycles and long running ones
> are relatively few compared to short ones so the strict affinity would
> be more helpful.  That is the basis of whole design and why it has
> scheduler callbacks to regulate concurrency instead of creating a
> bunch of active workers and letting the scheduler take care of it.
> Works wouldn't be competing for cpu cycles.
> 
> In short, the target workload is the current short works + long
> running mostly sleeping async works, which cover most of worker pools
> we have in kernel.

Ok, maybe, but that is not what I would call a generic thread pool.

So the reason we have tons of idle workqueues around are purely because
of deadlock scenarios? Or is there other crap about?

So why not start simple and only have one thread per cpu (lets call it
events/#) and run all works there. Then when you enqueue a work and
events/# is already busy with a work from anther wq, hand the work to a
global event thread which will spawn a special single shot kthread for
it, with a second exception for those reclaim wq's, for which you'll
have this rescue thread which you'll bind to the right cpu for that
work.

That should get rid of all these gazillion threads we have, preserve the
queue property and not be as invasive as your current thing.

If they're really as idle as reported you'll never need the fork-fest
you currently propose, simply because there's not enough work.

So basically, have events/# service the first non-empty cwq, when
there's more non empty cwqs spawn them single shot threads, or use a
rescue thread.

>   I thought about adding an unbound pool of workers
> for cpu intensive works for completeness but I really couldn't find
> much use for that.  If enough number of users would need something
> like that, we can add an anonymous pool but for now I really don't see
> the need to worry about that.

And I though I'd heard multiple parties express interesting in exactly
that, btrfs, bdi and pohmelfs come to mind, also crypto looks like one
that could actually do some work.

