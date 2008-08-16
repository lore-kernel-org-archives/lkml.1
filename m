Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbYHPRcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbYHPRcB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 13:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYHPRbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 13:31:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbYHPRbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 13:31:52 -0400
Date: Sat, 16 Aug 2008 10:30:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 : support atomic ops with 64 bits integer
 values
In-Reply-To: <20080816154330.GA5880@Krystal>
Message-ID: <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org>
References: <20080816073926.GA19546@Krystal> <48A6EC77.8080904@zytor.com> <20080816154330.GA5880@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 Aug 2008, Mathieu Desnoyers wrote:
> 
> I have hit this problem when tying to implement a better rwlock design
> than is currently in the mainline kernel (I know the RT kernel has a
> hard time with rwlocks)

Have you looked at my sleping rwlock trial thing?

It's very different from a spinning one, but I think the fast path should 
be identical, and that's the one I tried to make fairly optimal.

See 

	http://git.kernel.org/?p=linux/kernel/git/torvalds/rwlock.git;a=summary

for a git tree. The sleeping version has two extra words for the sleep 
events, but those would be irrelevant for the spinning version.

The fastpath is

	movl $4,%eax
	lock ; xaddl %eax,(%rdi)
	testl $3,%eax
	jne __my_rwlock_rdlock

for the read-lock (the two low bits are contention bits, so you can make 
contention have any behaviour you want - including fairish, prefer-reads, 
or prefer-writes).

The write fastpath is

	xorl %eax,%eax
	movl $1,%edx
	lock ; cmpxchgl %edx,(%rdi)
	jne __my_rwlock_wrlock

and the "unlock" case is actually unnecessarily complex in my 
implementation, because it needs to

 - wake things up in case of a conflict (not true of a spinning version, 
   of course)
 - it's pthreads-compatible, so the same function needs to handle both a 
   read-unlock and a write-unlock.

but a spinning version should be much simpler.

Anyway, I haven't tried turning it into a spinning version, but it was 
very much designed to

 - work with both 32-bit and 64-bit x86 by making the fastpath only do 
   32-bit locked accesses
 - have any number of pending readers/writers (which is not a big deal for 
   a spinning one, but at least there are no CPU count overflows).
 - and because it is designed for sleeping, I'm pretty sure that you can 
   easily drop interrupts in the contention path, to make 
   write_lock_irq[save]() be reasonable.

In particular, the third bullet is the important one: because it's 
designed to have a "contention" path that has _extra_ information for the 
contended case, you could literally make the extra information have things 
like a list of pending writers, so that you can drop interrupts on one 
CPU, while you adding information to let the reader side know that if the 
read-lock happens on that CPU, it needs to be able to continue in order to 
not deadlock.

		Linus
