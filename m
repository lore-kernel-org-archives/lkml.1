Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbZHDQDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbZHDQDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932649AbZHDQDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:03:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34809 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932635AbZHDQDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:03:52 -0400
Date: Tue, 4 Aug 2009 17:59:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Takashi Iwai <tiwai@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Incorrect circular locking dependency?
Message-ID: <20090804155952.GA5211@redhat.com>
References: <s5hvdmos4i8.wl%tiwai@suse.de> <alpine.DEB.2.01.0906211926080.6439@bogon> <6950.1245661098@redhat.com> <24075.1248705430@redhat.com> <1249397486.7924.243.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249397486.7924.243.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Peter Zijlstra wrote:
>
> On Mon, 2009-07-27 at 15:37 +0100, David Howells wrote:
> > Takashi Iwai <tiwai@suse.de> wrote:
> >
> > > =======================================================
> > > [ INFO: possible circular locking dependency detected ]
> > > 2.6.30-test #7
> > > -------------------------------------------------------
> > > swapper/0 is trying to acquire lock:
> > >  (&cwq->lock){-.-...}, at: [<c01519f3>] __queue_work+0x1f/0x4e
> > >
> > > but task is already holding lock:
> > >  (&q->lock){-.-.-.}, at: [<c012cc9c>] __wake_up+0x26/0x5c
> > >
> > > which lock already depends on the new lock.
> >
> > Okay.  I think I understand this:
> >
> >  (1) cachefiles_read_waiter() intercepts wake up events, and, as such, is run
> >      inside the waitqueue spinlock for the page bit waitqueue.
> >
> >  (2) cachefiles_read_waiter() calls fscache_enqueue_retrieval() which calls
> >      fscache_enqueue_operation() which calls schedule_work() for fast
> >      operations, thus taking a per-CPU workqueue spinlock.
> >
> >  (3) queue_work(), which is called by many things, calls __queue_work(), which
> >      takes the per-CPU workqueue spinlock.
> >
> >  (4) __queue_work() then calls insert_work(), which calls wake_up(), which
> >      takes the waitqueue spinlock for the per-CPU workqueue waitqueue.
> >
> > Even though the two waitqueues are separate, I think lockdep sees them as
> > having the same lock.
>
> Yeah, it looks like cwq->lock is always in the same lock class.
>
> Creating a new class for your second workqueue might help, we'd have to
> pass a second key through __create_workqueue_key() and pass that into
> init_cpu_workqueue() and apply it to cwq->lock using lockdep_set_class()
> and co.

Agreed.


But otoh, it would be nice to kill cwq->more_work and speedup workqueues
a bit. We don't actually need wait_queue_head_t, we have a single thread
cwq->thread which should be woken.  However this change is not completely
trivial, we need cwq->please_wakeup_me to avoid unnecessary wakeups inside
run_workqueue(). Not sure this worth the trouble.

Oleg.

