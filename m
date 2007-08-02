Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbXHBT7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbXHBT7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758672AbXHBT67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:58:59 -0400
Received: from stephens.ittc.ku.edu ([129.237.125.220]:53990 "EHLO
	stephens.ittc.ku.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbXHBT66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:58:58 -0400
Date: Thu, 2 Aug 2007 14:58:37 -0500
From: Noah Watkins <nwatkins@ittc.ku.edu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       "systemtap@sourceware.org" <systemtap@sourceware.org>
Subject: Re: [patch 0/1] extending low-level markers
Message-ID: <20070802195837.GD15216@ittc.ku.edu>
References: <20070801215723.GA10470@ittc.ku.edu> <20070802164437.GA27003@Krystal> <20070802183251.GA15216@ittc.ku.edu> <20070802190211.GA12124@Krystal> <20070802193106.GC15216@ittc.ku.edu> <20070802193851.GA15883@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802193851.GA15883@Krystal>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (stephens.ittc.ku.edu [129.237.125.220]); Thu, 02 Aug 2007 14:58:38 -0500 (CDT)
X-VirusScan: Clean
X-MailScanner-From: nwatkins@ittc.ku.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > 
> > The locking is internal to our framework and done on a per-type basis.
> > The start/end example i mentioned could represent an interval. When the
> > two points are wired up they both have their private data pointing at a
> > kmalloc'd interval structure internal to our framework, which contains
> > a lock.
> > 
> 
> Then this lock is taken in _start and unlocked in _end ? What happens if
> the _start and _end markers are enabled/disabled in a non-equilibrated
> way while the kernel code is being executed ? Would it deadlock the next
> time the lock is taken due to a missing unlock ?

The locks are aquired and released in each _start and _end marker, so
the equilibrium is not a issue.

A more sane example is the insertion of values into a histogram. Instead
of the instrumenation point logging the values and having the histogram
constructed during a post-process step, data structures implemented the
histogrm are associated with the instrumenation point. The lock protects
this structure in a more intuitive way than the interval example.

We have additional instrumenation points associated with the histogram
which for example trigger the logging of the histgoram when conditions
are met (conditions are implied by the placement of the marker).

In the interval example, they provide the data consistency, and
make no attempt to insure that the markers are used in a way that
makes sense (for example an interval in a preemptable re-entrant path).

So you can see that encoding the types of markers in the name of the
marker may become cumbersome as the amount of combinations grow.

> 
> > 
> > The cookie approach would accomplish the functionality, though it does
> > complicate the procedure of adding the instrumenation point. If the
> > start and the end events are not in the same function/file then
> > the linking of the cookie could be too instrusive.
> > 
> > In all of our cases the cookie would certainly be a void* pointing to
> > internal data structures. What is the objection to using the marker's
> > private data to point to the internal structures?
> > 
> 
> SMP, preemption, all those things while requires locking around a static
> variable. And the problem of non atomicity of connexion/disconnexion of
> multiple probes vs unbalanced lock/unlock.

I think most of problems involving non atomicity of the
connection/disconnection of probes can be accomplished by good house
keeping and settings things up in phases which insure consistency. For
example wiring things up before enabling events. An issue such as
hitting a _end event before a _start event can easily be handled by
whatever framework the markers are attached to.

- Noah

> 
> > Thanks for helping out. I realize the situations I'm describing are
> > quite specialized to our particular situation. Many students here use
> > the framework for learning systems programming, and as such it evolves
> > often.
> > 
> 
> No problem. I think some interesting things came come out of this.
> 
> Mathieu
> 
> > - Noah
> > 
> > > 
> > > > > The current approach is to use the marker name as a way to specify
> > > > > markers "group". If we go with a "flavor" enumeration instead, we would
> > > > > have to add an enumeration of every markers users in marker.h, which I
> > > > > am a bit reluctant to do.
> > > > 
> > > > This would have to be my biggest complaint with the 'flavor' concept as
> > > > well. However, if all points in main-line always used no concept of
> > > > flavor (or essentially the default flavor) then users wishing to use the
> > > > flavor enumeration out of main-line development could do so?
> > > > 
> > > 
> > > Hrm, the ideal thing would be to agree on an instrumentation set for a
> > > given subsystem/driver and to get the said instrumentation integrated in
> > > mainline. That would sound like a better way to stop reinventing the
> > > wheel forever. And actually, if there are some features in your tracer
> > > that you would like to add into a mainline tracer, I'll be glad to
> > > discuss those with you. A lot of people out there are facing the same
> > > issues as you are anyway :)
> > > 
> > > Ideally, a marker should express what the kernel code is doing and what
> > > information we want to extract from it more than being tied to one
> > > particular consumer (probe).
> > > 
> > > > Hope this helps portray more of what we are trying to do.
> > > > 
> > > 
> > > It sure helps, thanks :)
> > > 
> > > Mathieu
> > > 
> > > > Noah
> > > 
> > > -- 
> > > Mathieu Desnoyers
> > > Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
