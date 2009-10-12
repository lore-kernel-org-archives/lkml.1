Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZJLPiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZJLPiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZJLPiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:38:00 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:42556 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbZJLPh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Hu4tnsl/RJ6xvMTwMA9+PY4OY+MCF18ImzFxtVYXfyddtkN+r5TlOEgNaFs5+qLhZS
         3NMbxRaZWXBl/lIfxy65inA5T187AdQq/sO+TTETFWcJHXXscQHhVvXZR2S2io7Qbeib
         /d6ft8G05ewBb0/AfrFic8dAxUxe1ARaJ8/c8=
Message-ID: <4AD34D2D.7050808@clamav.net>
Date: Mon, 12 Oct 2009 18:37:17 +0300
From: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwin@clamav.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       aCaB <acab@clamav.net>, David Howells <dhowells@redhat.com>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Mutex vs semaphores scheduler bug
References: <4AD0A0F7.9070700@clamav.net> <1255359207.10420.31.camel@twins>
In-Reply-To: <1255359207.10420.31.camel@twins>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-10-12 17:53, Peter Zijlstra wrote:
> On Sat, 2009-10-10 at 17:57 +0300, Török Edwin wrote:
>> If a semaphore (such as mmap_sem) is heavily congested, then using a
>> userspace mutex makes the program faster.
>>
>> For example using a mutex around *anonymous* mmaps, speeds it up
>> significantly (~80% on this microbenchmark,
>> ~15% on real applications). Such workarounds shouldn't  be necessary for
>> userspace applications, the kernel should
>> by default use the most efficient implementation for locks.
> 
> Should, yes, does, no.
> 
>> However when using a mutex the number of context switches is SMALLER by
>> 40-60%.
> 
> That matches the problem, see below.
> 
>> I think its a bug in the scheduler, it scheduler the mutex case much
>> better. 
> 
> It's not, the scheduler doesn't know about mutexes/futexes/rwsems.
> 
>> Maybe because userspace also spins a bit before actually calling
>> futex().
> 
> Nope, if we would ever spin, it would be in the kernel after calling
> FUTEX_LOCK (which currently doesn't exist). glibc shouldn't do any
> spinning on its own (if it does, I have yet another reason to try and
> supplant the glibc futex code).

I think it doesn't by default, I was mislead by the huge number of cases
in pthread_mutex_lock.c. The default one does this:

__lll_lock_wait:
	cfi_startproc
	pushq	%r10
	cfi_adjust_cfa_offset(8)
	pushq	%rdx
	cfi_adjust_cfa_offset(8)
	cfi_offset(%r10, -16)
	cfi_offset(%rdx, -24)
	xorq	%r10, %r10	/* No timeout.  */
	movl	$2, %edx
	LOAD_FUTEX_WAIT (%esi)

	cmpl	%edx, %eax	/* NB:	 %edx == 2 */
	jne	2f

1:	movl	$SYS_futex, %eax
	syscall

2:	movl	%edx, %eax
	xchgl	%eax, (%rdi)	/* NB:	 lock is implied */

	testl	%eax, %eax
	jnz	1b

	popq	%rdx
	cfi_adjust_cfa_offset(-8)
	cfi_restore(%rdx)
	popq	%r10
	cfi_adjust_cfa_offset(-8)
	cfi_restore(%r10)
	retq


> 
>> I think its important to optimize the mmap_sem semaphore
> 
> It is.
> 
> The problem appears to be that rwsem doesn't allow lock-stealing

OK, sorry for mistaking lack of lock-stealing with scheduler bug.

>, and
> very strictly maintains FIFO order on contention. This results in extra
> schedules and reduced performance as you noticed.
> 
> What happens is that when we release a contended rwsem we assign it to
> the next waiter, if before that waiter gets ran, another (running) tasks
> comes along and tries to acquire the lock, that gets put to sleep, even
> though it could possibly get to acquire it (and the woken waiter would
> detect failure and go back to sleep).

The reason I initially thought it was a scheduler bug is that it seemed
it has something to do with wakeups, and threads are sleeping for too
long waiting for the lock.
But I think the scheduler can't give preference to tasks which would be
able to acquire a semaphore they were sleeping on, because that'd throw
 fair scheduling off-balance, right?

> 
> So what I think we need to do is have a look at all this lib/rwsem.c
> slowpath code and hack in lock stealing.
> 
> 

Best regards,
--Edwin
