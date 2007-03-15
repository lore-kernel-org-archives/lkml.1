Return-Path: <linux-kernel-owner+w=401wt.eu-S932759AbXCOTLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbXCOTLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbXCOTLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:11:04 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:42435 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933439AbXCOTKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:10:33 -0400
From: Eric Dumazet <dada1@cosmosbay.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/3] FUTEX : new PRIVATE futexes, SMP and NUMA improvements
Date: Thu, 15 Mar 2007 20:10:34 +0100
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
References: <20060808070708.GA3931@localhost.localdomain> <200608090826.28249.dada1@cosmosbay.com> <200608090843.52893.dada1@cosmosbay.com>
In-Reply-To: <200608090843.52893.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703152010.35614.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm pleased to present these patches which improve linux futex performance and 
scalability, on both UP, SMP and NUMA configs.

I had this idea last year but I was not understood, probably because I gave 
not enough explanations. Sorry if this mail is really long...


Analysis of current linux futex code :
--------------------------------------

A central hash table futex_queues[] holds all contexts (futex_q) of waiting 
threads.
Each futex_wait()/futex_wait() has to obtain a spinlock on a hash slot to 
perform lookups or insert/deletion of a futex_q.

When a futex_wait() is done, thread has to :

1) - Obtain a read lock on mmap_sem to be able to validate the user pointer
     (calling find_vma()). This validation tells us if the futex use
     an inode based store (mapped file), or mm based store (anonymous mem)

2) - compute a hash key

3) - Atomic Increment of reference counter on an inode or a mm

4) - lock part of futex_queues[] hash table

5) - perform the test on value of futex.
                (rollback is value != expected_value, returns EWOULDBLOCK)
        (various loops if test triggers mm faults)

6) queue the context into hash table, release the lock got in 4)

7) - release the read_lock on mmap_sem

   <block>

8) Eventually unqueue the context (but rarely, as this part
 may be done by the futex_wake())

Futexes were designed to improve scalability but current implementation
has various problems :

- Central hashtable :
 This means scalability problems if many processes/threads want to use
 futexes at the same time.
 This means NUMA unbalance because this hashtable is located on one node.

- Using mmap_sem on every futex() syscall :

 Even if mmap_sem is a rw_semaphore, up_read()/down_read() are doing atomic
 ops on mmap_sem, dirtying cache line :
        - lot of cache line ping pongs on SMP configurations.

 mmap_sem is also extensively used by mm code (page faults, mmap()/munmap())
 Highly threaded processes might suffer from mmap_sem contention.

 mmap_sem is also used by oprofile code. Enabling oprofile hurts threaded
programs because of contention on the mmap_sem cache line.

- Using an atomic_inc()/atomic_dec() on inode ref counter or mm ref counter:
 It's also a cache line ping pong on SMP. It also increases mmap_sem hold time
 because of cache misses.

Most of these scalability problems come from the fact that futexes are in
one global namespace. As we use a central hash table, we must make sure
they are all using the same reference (given by the mm subsystem).
We chose to force all futexes be 'shared'. This has a cost.

But fact is POSIX defined PRIVATE and SHARED, allowing clear separation, and
optimal performance if carefuly implemented. Time has come for linux to have 
better threading performance.

PTHREAD_PROCESS_PRIVATE semantic allows implementation to use separate
repositories :
- One 'global' namespace for all PROCESS_SHARED futexes.
- One "per process private repository" for PROCESS_PRIVATE futexes.
  This repository is NUMA aware, it is allocated the first time a process
  issues a futex(XXXX_PRIVATE) call. If allocation is not possible because
  of memory shortage, we just fallback using the central repository.

The goal is to permit new futex commands to avoid :
 - Using the central hash table (still used by PTHREAD_PROCESS_SHARED futexes)
 - Taking the mmap_sem semaphore, conflicting with other subsystems.
 - Modifying a ref_count on mm or an inode, still conflicting with mm or fs.

This is possible because, for one process using PTHREAD_PROCESS_PRIVATE
futexes, we only need to distinguish futexes by their virtual address, no
matter the underlying mm storage is.

This is why this patches :

1) Define new futex subcommands (basically adding a _PRIVATE flag)
   Avoids using mmap_sem, and ref counter on inode or mm.

2) Allows each process to have a private repository (a small hash table)
   where its PROCESS_PRIVATE active futexes are stored, instead of 
   the global repository.
   if CONFIG_BASE_SMALL, we still use the global repository

3) NUMA optimization : we allocate the global hash table with vmalloc()

If glibc wants to exploit this new infrastructure, it should use new
_PRIVATE futex subcommands for PTHREAD_PROCESS_PRIVATE futexes. And
be prepared to fallback on old subcommands for old kernels. Using one
global variable with the FUTEX_PRIVATE_FLAG or 0 value should be OK.

Only PTHREAD_PROCESS_SHARED futexes should use the old subcommands.

Compatibility with old applications is preserved, they still hit the
scalability problems, but new applications can fly :)

Note : the same SHARED futex (mapped on a file) can be used by old binaries 
*and* new binaries, because both binaries will use the old subcommands.

Note : Vast majority of futexes should be using PROCESS_PRIVATE semantic,
as this is the default semantic. Almost all applications should benefit
of this changes (new kernel and updated libc)

Some bench results on a Pentium M 1.6 GHz (SMP kernel on a UP machine)

/* calling futex_wait(addr, value) with value != *addr */
450 cycles per futex(FUTEX_WAIT) call (mixing 2 futexes)
427 cycles per futex(FUTEX_WAIT) call (using one futex)
337 cycles per futex(FUTEX_WAIT_PRIVATE) call (mixing 2 futexes)
332 cycles per futex(FUTEX_WAIT_PRIVATE) call (using one futex)
For reference :
214 cycles per futex(1000) call (returns ENOSYS)
186 cycles per getppid() call
187 cycles per umask() call
182 cycles per ni_syscall() call

Thank you for reading this mail

[PATCH 1/3] FUTEX : introduce PROCESS_PRIVATE semantic
[PATCH 2/3] FUTEX : introduce private hashtables
[PATCH 3/3] FUTEX : NUMA friendly global hashtable

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
