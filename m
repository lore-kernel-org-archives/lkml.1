Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYGHCIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYGHCIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 22:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYGHCH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 22:07:59 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:45452 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754691AbYGHCH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 22:07:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JJIokSLvg945uLWuRWebw0boko0sitQ0897CuE/BQegQmK+rg54GZPwfa4oaG4QnInOC7qncMXFdG4emZaVQs+8sJ0jr1CpUbkgh5i/2f8tBRVF8tMLApRQ0CLWKwTEsln8iJgjGbnVj/wDKkF6I1l1V6GvP+nNyEJEKJ/4hSW8=  ;
X-YMail-OSG: sISAswsVM1k4Gk5P1IG1JU3zqWsq_p5PcH_pRsfwJ9L5JzeC4urg1eP1YDMTAHSTpz9U3qbxtVfqgDpyjbs552WNDlFKePzRPwcj8Ni9ectT8NTNxLyQAnTma1UBbSlBQ7M-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin with irqs disable
Date: Tue, 8 Jul 2008 12:07:34 +1000
User-Agent: KMail/1.9.5
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> <20080707154651.35d1004c@cuia.bos.redhat.com> <4872792F.9080609@goop.org>
In-Reply-To: <4872792F.9080609@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081207.34453.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 06:14, Jeremy Fitzhardinge wrote:

> The other point, of course, is that ticket locks are massive overkill
> for the problem they're trying to solve.

No they aren't.


> It's one thing to introduce an 
> element of fairness into spinlocks, its another to impose strict FIFO
> ordering.  It would be enough to make the locks "polite" by preventing a
> new lock-holder from taking the lock while its under contention.
> Something like:
>
> 	union lock {
> 		unsigned short word;
> 		struct { unsigned char lock, count; };
> 	};
>
> spin_lock:		# ebx - lock pointer
> 	movw	$0x0001, %ax	# add 1 to lock, 0 to count
> 	xaddw	%ax, (%ebx)	# attempt to take lock and test user count
> 	testw	%ax,%ax
> 	jnz	slow
>
> taken:	ret
>
> # slow path
> slow:	lock incb 1(%ebx)	# inc count
>
> 1:	rep;nop
> 	cmpb	$0,(%ebx)
> 	jnz	1b		# wait for unlocked
>
> 	movb	$1,%al		# attempt to take lock (count already increased)
> 	xchgb	%al,(%ebx)
> 	testb	%al,%al
> 	jnz	1b
>
> 	lock decb 1(%ebx)	# drop count
> 	jmp	taken
>
> spin_unlock:
> 	movb	$0,(%ebx)
> 	ret
>
>
> The uncontended fastpath is similar to the pre-ticket locks, but it
> refuses to take the lock if there are other waiters, even if the lock is
> not currently held.  This prevents the rapid lock-unlock cycle on one
> CPU from starving another CPU, which I understand was the original
> problem tickets locks were trying to solve.

They prevent lots of unfairness and starvation problems. The most
prominent one (ie. actually observed in Linux) was a single CPU
being totally starved by N others (to the point where lockup timers
would kick in).

As an aside, these locks you propose are also a lot more costly in
the contended path. 4 vs 1 atomic operations on the lock cacheline
is not so great.


> But it also means that all the contended spinners get the lock in
> whatever order the system decides to give it to them, rather than
> imposing a strict order.

The exact problem is that the system actively does the wrong thing
when you allow it to decide.

Unlike simple cacheline access, I don't believe it is such a good
idea to batch up locks many times on the same CPU for example. While
it surely could improve performance in specific situations, I think
that if code is taking and releasing a lock many times, then it most
probably should be either reworked to hold the lock for longer, or
changed completely. And once locks become *really* contended, then
the cost of moving the critical section to another CPU is really
drowned out by the cost of contention itself (all the idle time,
and taking/releasing the lock cacheline).

So far my theory has held up (except for virtualized systems).

