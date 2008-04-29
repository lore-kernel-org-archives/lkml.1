Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbYD2QP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbYD2QP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYD2QPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:15:47 -0400
Received: from viefep26-int.chello.at ([62.179.121.46]:7525 "EHLO
	viefep26-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbYD2QPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:15:46 -0400
X-SourceIP: 80.56.237.116
Subject: Re: [PATCH 1/8] lockdep: fix recursive read lock validation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <e2e108260804290903x44ad1cb7x1278027ab51b0831@mail.gmail.com>
References: <20080429125659.GA23562@in.ibm.com>
	 <20080429125750.GB23562@in.ibm.com>
	 <e2e108260804290616l489ac8c2udcb2e80fc268b72b@mail.gmail.com>
	 <1209481050.13978.72.camel@twins>
	 <e2e108260804290803u75764b56t1c475a6d186aca8d@mail.gmail.com>
	 <1209482101.13978.91.camel@twins>
	 <e2e108260804290903x44ad1cb7x1278027ab51b0831@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 18:15:39 +0200
Message-Id: <1209485739.13978.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 18:03 +0200, Bart Van Assche wrote:
> On Tue, Apr 29, 2008 at 5:15 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > On Tue, 2008-04-29 at 17:03 +0200, Bart Van Assche wrote:
> >  > On Tue, Apr 29, 2008 at 4:57 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >  > >
> >  > > On Tue, 2008-04-29 at 15:16 +0200, Bart Van Assche wrote:
> >  > >  > On Tue, Apr 29, 2008 at 2:57 PM, Gautham R Shenoy <ego@in.ibm.com> wrote:
> >  > >  > > Subject: lockdep: fix recursive read lock validation
> >  > >  > >  This means that the following sequence is now invalid, whereas previously
> >  > >  > >  it was considered valid:
> >  > >  > >
> >  > >  > >   rlock(a); rlock(b); runlock(b); runlock(a)
> >  > >  > >   rlock(b); rlock(a);
> >  > >  >
> >  > >  > Why are you marking this sequence as invalid ? Although it can be
> >  > >  > debated whether it is good programming practice to be inconsistent
> >  > >  > about the order of read-locking, the above sequence can't be involved
> >  > >  > in a deadlock.
> >  > >
> >  > >  Not for pure read locks, but when you add write locks to it, it does get
> >  > >  deadlocky. Lockdep does not keep separate chains for read and write
> >  > >  locks.
> >  >
> >  > Nesting writer locks inside reader locks is always a bad idea. So
> >  > please come up with an example of how varying the reader lock nesting
> >  > order can trigger a deadlock (when no writer locks are nested inside
> >  > reader locks and nested writer locks are always nested in the same
> >  > order).
> >
> >  It can't deadlock when only readers are involved, but lockdep will not
> >  be able to distinguish between the cases where only read locks are
> >  involved and a mix of readers and writers is involved.
> >
> >  Hence disallow both.
> >
> >  But hitting this requires you do a series of rather unfortunate things:
> >
> >   1) use recursive locking
> >   2) don't have strict lock order
> >   3) make it work by using read locks only
> >
> >  Seriously, any code that triggers this might want to have its locking
> >  re-throught.
> 
> You did not get my point.
> 
> My point is that if you follow the following locking discipline, a
> deadlock will never be triggered:
> * Always obtain writer locks in a consistent order.
> * Never nest writer locks inside reader locks.
> * Nesting reader locks inside writer locks is okay, and nesting reader
> locks inside other reader locks is also OK.
> 
> Again: if you do not agree with the above, please post an example that
> proves me wrong.

Using a lock that does not allow reader nesting would be cheating,
right?

> Or: whether or not to allow a sequence like "rlock(a); rlock(b);
> runlock(b); runlock(a); rlock(b); rlock(a);" is something we can
> choose. We do not have to forbid this sequence -- we can choose
> whether or not we allow this sequence.

I'm utterly confused now; I never argued that it would get deadlocks;
and I said I choose to not allow it from a lockdep pov. What else do you
want?



