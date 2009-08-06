Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbZHFLCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbZHFLCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZHFLCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:02:39 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:5655 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZHFLCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:02:38 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
 tgid  at once
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, paulmck <paulmck@linux.vnet.ibm.com>,
       oleg <oleg@redhat.com>
In-Reply-To: <6599ad830908060342m1fc8cdd2me25af248a8e0e183@mail.gmail.com>
References: <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
	 <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com>
	 <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com>
	 <20090805102057.GT29252@hawkmoon.kerlabs.com>
	 <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
	 <20090805164218.GB26446@hawkmoon.kerlabs.com>
	 <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com>
	 <20090806095854.GD26446@hawkmoon.kerlabs.com>
	 <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com>
	 <1249554853.32113.145.camel@twins>
	 <6599ad830908060342m1fc8cdd2me25af248a8e0e183@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 13:02:20 +0200
Message-Id: <1249556540.32113.191.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 03:42 -0700, Paul Menage wrote:
> On Thu, Aug 6, 2009 at 3:34 AM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> > On Thu, 2009-08-06 at 03:28 -0700, Paul Menage wrote:
> >
> >> OK, well if lockdep can't currently handle the "writer takes a lock on
> >> every thread" model,
> >
> > I haven't read what this is about, but simply looking at that sentence
> > makes me want to hit someone with a cluebat. Have you any idea how
> > expensive that is?
> 
> For lockdep to track that many locks, or just the concept of taking
> that many locks generally?

Taking that many locks in general, some apps (JVM based usually) tend to
be thread heavy and can easily have hundreds of them, even on relatively
small (~8 CPU) machines. Having to take hundreds of locks on such a
small machine seems to indicate to me you're doing something wrong.

[ I now understand its only 'all threads of a process' which is
  slightly better than 'all threads' but still crazy ]

> The basic idea is that in order to implement a "procs" file in cgroups
> that can migrate all threads in a process atomically, we need to
> synchronize with concurrent clone() calls. But since thread clones are
> likely to occur far more often than "procs" writes, and we wanted to
> avoid introducing overhead into the clone path, one approach was to
> give each thread a fork mutex, which it could take around the relevant
> parts of the fork/clone operation, and have the "procs" writer deal
> with obtaining the fork mutex for every thread in the process being
> moved, so pushing the overhead on to the "procs" writer.

See below.

> I don't think it's a deficiency of lockdep that it would have trouble
> dealing with this - in fact, my original plan was that we'd just have
> to live with the fact that anyone doing a "procs" move on a massive
> process would have to live with lockdep printing an overflow warning.

Now that's not real nice is it ;-)

> But given that AFAICS we can eliminate the overhead associated with a
> single lock by piggy-backing on the cache line containing
> sighand->count, hopefully this won't be an issue any more.

Right, so this is a write rarely, read frequently thing, which suggests
an RCU like approach where the readers pay a minimum synchronization
penalty.

Then again, clone() might already serialize on the process as a whole
(not sure though, Oleg/Ingo?), in which case you can indeed take a
process wide lock.

If not, you might think about using an SRCU variant where the read
(clone) side does something like:

 if (rcu_derference(tsk->sighand->cgroup_block))
   wait_event(&some_queue, !tsk->sighand->cgroup_block);

 srcu_read_lock(&my_srcu_thing);

 /* do the clone bit */

 srcu_read_unlock(&my_srcu_thing);


and the write (cgroup thingy) side does:

 rcu_assign(tsk->sighand->cgroup_block, 1);

 srcu_synchronize(&my_srcu_thing); 

 /* everybody will be out of clone */

 /* do your thing */

 rcu_assign(tsk->sighand->cgroup_block, 0);
 wake_up_all(&some_queue);

Or something like that, which should reduce the read-side overhead to a
single shared read and some SRCU ops which should be per-cpu in the
normal case.



