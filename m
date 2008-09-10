Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbYIJKM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbYIJKM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 06:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYIJKMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 06:12:13 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:22749 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751013AbYIJKMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 06:12:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gNh4IZWqF+jw1XyG0d4QWwbZlhCghR2YN8sQvV1QsBMriCnyyNRjxRxzwQ3V+rAuwKA8l7zaphR9VNf26Y4S8YH87DQzrbYhED9x21s2bTT7SNzzTwPAy4hi154aFhIe/L8IME0SJhLUKOJ2xvVd77+av9e1CE9n8shK9te/buQ=  ;
X-YMail-OSG: jRKTytUVM1mwu8mSooeaVuSpkFiR0HezJkANuTm3IqYPgF1D4CuqdaZrln91SHm7V7Tg4DiQ4ZfaSA9WL15BPvT5jb93qGdkiR6ncHOfDQgTAdoIKSqSk26mbdJiFrHxC1YVviyDkIl.TeTue5lOOn8y
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [2.6.27-rc5] inotify_read's ev_mutex vs do_page_fault's mmap_sem...
Date: Thu, 11 Sep 2008 06:11:48 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Daniel J Blueman <daniel.blueman@gmail.com>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <6278d2220809091403k65187128keec3b401717f1ec0@mail.gmail.com> <200809101950.27669.nickpiggin@yahoo.com.au> <1221040771.2442.120.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1221040771.2442.120.camel@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809110611.49417.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 19:59, Peter Zijlstra wrote:
> On Wed, 2008-09-10 at 19:50 +1000, Nick Piggin wrote:
> > On Wednesday 10 September 2008 18:37, Ingo Molnar wrote:
> > > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > On Wednesday 10 September 2008 17:57, Peter Zijlstra wrote:
> > > > > Sure, how about the below - untested - uncompiled, might eat
> > > > > kittens, etc..
> > > > >
> > > > > Just sprinkle something like:
> > > > >
> > > > >   might_lock_read(&mm->mmap_sem);
> > > > >
> > > > > in the right places.
> > > >
> > > > Ahh, very nice, thanks! I'll give that a try...
> > >
> > > cool! Please send in an RFC patch once you have something that boots -
> > > we can stick it into tip/core/locking and see whether there's any new
> > > messages on a wide range of systems and workloads. (and we'd also check
> > > whether the number of kittens is an invariant.)
> >
> > Well I have verified it boots, and have used the annotation in some of
> > x86-64's user copy routines (luckily no flood of bugs I was scared of,
> > phew!)
> >
> > So I would like to request you merge Peter's patch, and we'll hopefully
> > start seeing the annotations being used.
>
> Will you send your x86_64 patch to be the first?

OK.


> > FWIW, I don't suppose lockdep
> > can determine that it is a sleeping lock, and do the appropriate
> > might_sleep checks at this point as well?
>
> Humm, no - we don't actually have that information there - I guess one
> could add it to lockdep_map and set it from the various init routines,
> but I'm not sure its worth it - just add might_sleep() along with
> might_lock() :-)

I guess so... seems like lockdep should know about "locks", however :)
Spinlock isn't always a spinlock, and ordinary kernel code usually
should not care about that.

But I'll add it in this case.
