Return-Path: <linux-kernel-owner+w=401wt.eu-S1751516Ab0ABTCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab0ABTCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266Ab0ABTCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:02:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50062 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab0ABTCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kpYMRfHHeR0VTsZGFZuiNRfv0sbo9RTaFscacJ8fno+MGzX2ULt9nF834x3YgRCZhZ
         8sPGmv7dFAuLeLyEp+/mZGbgVoja8nVKF7ecp+F3cVo7nE9RVPc1MX2iuSr6KxhYCdc0
         tb+jvc6hdrDOgLWmJej37TKNNyheXlualocOg=
Date: Sat, 2 Jan 2010 20:02:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102190213.GC5076@nowhere>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <87bphc7heo.fsf@basil.nowhere.org> <20100102163644.GA5076@nowhere> <20100102174311.GA30016@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102174311.GA30016@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 06:43:12PM +0100, Andi Kleen wrote:
> > I only have reiserfs partitions in my laptop and my testbox,
> > nothing else. And that because I'm now maintaining it de facto.
> 
> AFAIK it's widely used in SUSE installations. It was the default
> for a long time.
> 
> And right now as in 2.6.32 it's in a state of
> "may randomly explode/deadlock". And no clear path out of it. Not good.
> 
> I am very concerned about destabilizing a widely used file system
> like this. This has the potential to really hurt users.


I understand your worries. And I've been very cautious with that,
waiting for three cycles before requesting an upstream merge. I did
it because the isolated tree model did not scale anymore.

Now that it's upstream, I get more testing and I expect that, in
the end of this cycle, I get most of these issues reported and
fixed.

Serious users who run serious datas won't ship 2.6.33, they will ship
a further stable version 2.6.33.x (if they haven't converted their
filesystems already).
And at this time, things should be 99% fixed.

 
> > - that would require a notifier in schedule(), one notifier
> >   per sub-bkl. That's horrible for performances. And for
> >   the scheduler. I will be the first to NAK.
> 
> I thought the original idea was to find everything that 
> can sleep in reiserfs and simply wrap it with lock dropping?
>
> That should be roughly equivalent to the old BKL semantics.
>
> Where did it go wrong?



That's the theory. Fitting into this strict scheme brings performance
regressions. The bkl is a spinlock, it disables preemption, it is
relaxed on sleep, and doesn't have locking dependencies. Moreover
it's not a lock but a simulation of a NO_PREEMPT UP flow, with all
the fixup guardians that come with (fixup if we schedule, as
scheduling brings races).

>From the conversion is borned a mutex. Even though we have
adaptive spinning, we don't catch up spinlock performances
as it's not a pure optimized looping fast path, and it may
actually just sleep.

The bkl is relaxed only when we sleep. Now simulating that with
a mutex that gets explicitly relaxed is not the same thing as
we need to relax the lock each time we _might_ sleep. It means
we relax more and that brings performance regressions.

That said it's sometimes a drawback for the bkl to be relaxed
every time we schedule, because we need to fixup after that,
sometimes we need to re-walk into the entire tree, etc...

So sometimes we can do better. There are some places where
we don't relax like did the bkl, so that we don't need to fixup,
and we get a win of performances.

You see? The bkl semantics must not be always strictly imitated on
such conversion. It depends on what does the code. In reiserfs,
sometimes it was desired that the bkl get relaxed, sometimes it
wasn't. And all the reiserfs code deals with that.

With a mutex we have the choice. So the conversion has been
a balance between performance regressions brought by the mutex
conversion, and the performance win because we have actually
more control with a traditional lock.

That said there are places where we really need to sleep, like
when we grab another lock, so that we don't create inverted
dependencies.


That said, if the general opinion is in favour of unmerging
the bkl removal changes in reiserfs. Then please do.

Just to express my point of view, as my primary goal is not
to fix reiserfs but the kernel: If you are afraid of such
changes, your kernel will just become mildewed by the time.
You need to drop such bad ill-legacies if you want it to
evolve. Until every users of the big kernel lock will remain
in the kernel, vanilla upstream will keep it as ball and chain,
won't ever be able to perform any serious real time service,
etc...

So yes this is risky. But I think this is necessary. And as I
explained above, things will be fine as serious datas are not
manipulated with a random -rc2 (except my own datas...).

