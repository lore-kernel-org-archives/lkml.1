Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbYGGUPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbYGGUPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbYGGUOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:14:53 -0400
Received: from gw.goop.org ([64.81.55.164]:53918 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbYGGUOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:14:52 -0400
Message-ID: <4872792F.9080609@goop.org>
Date: Mon, 07 Jul 2008 13:14:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
 with irqs disable
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>	<20080507073017.GJ32195@elte.hu>	<Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>	<Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>	<Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>	<1214241561.19392.21.camel@elijah.suse.cz>	<Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com>	<1214253593.11254.30.camel@twins>	<Pine.LNX.4.64.0806231345001.28304@schroedinger.engr.sgi.com>	<1214254730.11254.34.camel@twins>	<48630420.1090102@goop.org> <20080707154651.35d1004c@cuia.bos.redhat.com>
In-Reply-To: <20080707154651.35d1004c@cuia.bos.redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Alternatively, the guest could tell the host which vcpus
> are next in line for a ticket spinlock, or a vcpu that gets
> scheduled but is not supposed to grab the lock yet can give
> some CPU time to the vcpu that should get the lock next.
>   

Those are possible, but would either 1) require hypervisor changes, 
and/or 2) changes no less extensive than the ones I had to make anyway.

Thomas's proposal was to modify the scheduler to try to avoiding 
preempting vcpus while they're in kernel mode.  That's nice because it 
requires no guest changes, and seems at least somewhat successful at 
mitigating the problem.  But it can't completely solve the problem, and 
you end up with a bunch of heuristics in the hypervisor to decide who to 
preempt.

The other point, of course, is that ticket locks are massive overkill 
for the problem they're trying to solve.  It's one thing to introduce an 
element of fairness into spinlocks, its another to impose strict FIFO 
ordering.  It would be enough to make the locks "polite" by preventing a 
new lock-holder from taking the lock while its under contention.  
Something like:

	union lock {
		unsigned short word;
		struct { unsigned char lock, count; };
	};

spin_lock:		# ebx - lock pointer
	movw	$0x0001, %ax	# add 1 to lock, 0 to count
	xaddw	%ax, (%ebx)	# attempt to take lock and test user count
	testw	%ax,%ax
	jnz	slow

taken:	ret

# slow path
slow:	lock incb 1(%ebx)	# inc count

1:	rep;nop
	cmpb	$0,(%ebx)
	jnz	1b		# wait for unlocked
	
	movb	$1,%al		# attempt to take lock (count already increased)
	xchgb	%al,(%ebx)
	testb	%al,%al
	jnz	1b

	lock decb 1(%ebx)	# drop count
	jmp	taken

spin_unlock:
	movb	$0,(%ebx)
	ret


The uncontended fastpath is similar to the pre-ticket locks, but it 
refuses to take the lock if there are other waiters, even if the lock is 
not currently held.  This prevents the rapid lock-unlock cycle on one 
CPU from starving another CPU, which I understand was the original 
problem tickets locks were trying to solve.

But it also means that all the contended spinners get the lock in 
whatever order the system decides to give it to them, rather than 
imposing a strict order.

> I believe the IBM PPC64 people have done some work to implement
> just that.
>   

Do you have any references?

    J
