Return-Path: <linux-kernel-owner+w=401wt.eu-S933165AbXCMLmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbXCMLmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 07:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933144AbXCMLmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 07:42:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161AbXCMLmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 07:42:22 -0400
Date: Tue, 13 Mar 2007 12:42:15 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Anton Blanchard <anton@samba.org>, Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
Message-ID: <20070313114215.GI8992@v2.random>
References: <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au> <20070312220042.GA807@kryten> <45F63266.1080509@yahoo.com.au> <20070313094559.GC8992@v2.random> <45F67796.4040508@yahoo.com.au> <20070313103134.GF8992@v2.random> <45F67F02.5020401@yahoo.com.au> <20070313105742.GG8992@v2.random> <45F68713.9040608@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F68713.9040608@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 10:12:19PM +1100, Nick Piggin wrote:
> They'll be sleeping in futex_wait in the kernel, I think. One thread
> will hold the critical mutex, some will be off doing their own thing,
> but importantly there will be many sleeping for the mutex to become
> available.

The initial assumption was that there was zero idle time with threads
= cpus and the idle time showed up only when the number of threads
increased to the double the number of cpus. If the idle time wouldn't
increase with the number of threads, nothing would be suspect.

> However, I tested with a bigger system and actually the idle time
> comes before we saturate all CPUs. Also, increasing the aggressiveness
> of the load balancer did not drop idle time at all, so it is not a case
> of some runqueues idle while others have many threads on them.

It'd be interesting to see the sysrq+t after the idle time
increased.

> I guess googlemalloc (tcmalloc?) isn't suitable for a general purpose
> glibc allocator. But I wonder if there are other improvements that glibc
> can do here?

My wild guess is that they're allocating memory after taking
futexes. If they do, something like this will happen:

     taskA		taskB		taskC
     user lock
			mmap_sem lock
     mmap sem -> schedule
					user lock -> schedule

If taskB wouldn't be there triggering more random trashing over the
mmap_sem, the lock holder wouldn't wait and task C wouldn't wait too.

I suspect the real fix is not to allocate memory or to run other
expensive syscalls that can block inside the futex critical sections...
