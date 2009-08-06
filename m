Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbZHFLjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbZHFLjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbZHFLjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:39:44 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:56077 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbZHFLjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:39:37 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
 tgid  at once
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, paulmck <paulmck@linux.vnet.ibm.com>,
       oleg <oleg@redhat.com>
In-Reply-To: <6599ad830908060424r72e1aa12g2b246785e7bc039c@mail.gmail.com>
References: <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
	 <20090805102057.GT29252@hawkmoon.kerlabs.com>
	 <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
	 <20090805164218.GB26446@hawkmoon.kerlabs.com>
	 <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com>
	 <20090806095854.GD26446@hawkmoon.kerlabs.com>
	 <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com>
	 <1249554853.32113.145.camel@twins>
	 <6599ad830908060342m1fc8cdd2me25af248a8e0e183@mail.gmail.com>
	 <1249556540.32113.191.camel@twins>
	 <6599ad830908060424r72e1aa12g2b246785e7bc039c@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 13:39:21 +0200
Message-Id: <1249558761.32113.262.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 04:24 -0700, Paul Menage wrote:
> On Thu, Aug 6, 2009 at 4:02 AM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> >
> > Taking that many locks in general, some apps (JVM based usually) tend to
> > be thread heavy and can easily have hundreds of them, even on relatively
> 
> Oh, I'm well aware that apps can be heavily multi-threaded - we have
> much worse cases at Google.
> 
> >
> > Now that's not real nice is it ;-)
> 
> Not particularly - but who exactly is going to be moving processes
> with thousands of threads between cgroups on a lockdep-enabled debug
> kernel?

All it takes are: 8 or 48 (or soon 2048) depending on your particular
annotation. I might and then I'd have to come and kick you ;-)

Really, lockdep not being able to deal with something is a strong
indication that you're doing something wonky.

Stronger, you can even do wonky things which lockdep thinks are
absolutely fine.

And doing wonky things should be avoided :-)

Luckily we seem to have found a sensible solution.

> What benefits does the additional complexity of SRCU give, over the
> simple solution of putting an rwsem in the same cache line as
> sighand->count ?

I said:

> Then again, clone() might already serialize on the process as a whole
> (not sure though, Oleg/Ingo?), in which case you can indeed take a
> process wide lock.

Which looking up sighand->count seems to be the case:

static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
{
        struct sighand_struct *sig;

        if (clone_flags & CLONE_SIGHAND) {
                atomic_inc(&current->sighand->count);
                return 0;
        }


So yes, putting a rwsem in there sounds fine, you're already bouncing
it.

