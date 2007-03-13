Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbXCMM3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbXCMM3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933191AbXCMM3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:29:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359AbXCMM3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:29:05 -0400
Date: Tue, 13 Mar 2007 07:27:17 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrea Arcangeli <andrea@suse.de>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Anton Blanchard <anton@samba.org>, Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
Message-ID: <20070313122716.GV355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <45E21FEC.9060605@redhat.com> <45F68713.9040608@yahoo.com.au> <20070313114215.GI8992@v2.random> <200703131302.45216.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703131302.45216.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 01:02:44PM +0100, Eric Dumazet wrote:
> On Tuesday 13 March 2007 12:42, Andrea Arcangeli wrote:
> 
> > My wild guess is that they're allocating memory after taking
> > futexes. If they do, something like this will happen:
> >
> >      taskA		taskB		taskC
> >      user lock
> > 			mmap_sem lock
> >      mmap sem -> schedule
> > 					user lock -> schedule
> >
> > If taskB wouldn't be there triggering more random trashing over the
> > mmap_sem, the lock holder wouldn't wait and task C wouldn't wait too.
> >
> > I suspect the real fix is not to allocate memory or to run other
> > expensive syscalls that can block inside the futex critical sections...
> 
> glibc malloc uses arenas, and trylock() only. It should not block because if 
> an arena is already locked, thread automatically chose another arena, and 
> might create a new one if necessary.

Well, only when allocating it uses trylock, free uses normal lock.
glibc malloc will by default use the same arena for all threads, only when
it sees contention during allocation it gives different threads different
arenas.  So, e.g. if mysql did all allocations while holding some global
heap lock (thus glibc wouldn't see any contention on allocation), but
freeing would be done outside of application's critical section, you would
see contention on main arena's lock in the free path.
Calling malloc_stats (); from e.g. atexit handler could give interesting
details, especially if you recompile glibc malloc with -DTHREAD_STATS=1.

	Jakub
