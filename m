Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbYEaEQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbYEaEQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 00:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYEaEQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 00:16:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbYEaEQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 00:16:46 -0400
Date: Fri, 30 May 2008 21:16:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <4840CE51.9060109@redhat.com>
Message-ID: <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org>
References: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 May 2008, Ulrich Drepper wrote:
>
> Ask yourself this:

How about you post your code. 

Because your questions seem to be total and utter crap.

> - How do you know when there is no more writer waiting?  You cannot
>   reset a "writer waiting" bit after you wake up one writer without
>   waking every single thread waiting for the rwlock and letting them
>   fight for it

Sure you can. By looking at the *other*data* that isn't atomic.

So when doing a "write_unlock()" (or whatever you call it - for the kernel 
calls it "up_write()") you can look at the non-atomic write counts to 
decide whether there are others.

Also note how you can use 64-bit atomic ops to do that all in user space, 
without actually requiring 64-bit futex support - as long as the bits that 
matter for waking (like "was there more than one pending writer") fit in 
the one 32-bit word.

> - - How do you handle the difference between reader-preferred rwlocks
>   and writer-preferred rwlocks?  In the latter, if a rwlock is locked
>   for reading, future readers must be delayed until all writers are
>   gone

Again, that's not something that needs to be in the *atomic* part.

It's unquestionable that a rwlock is more than 32 bits, but what I 
question is whether you need all those extra bits to be under futex

> - How do you do the accounting for the *timedlock variants?  In the
>   case of those a functions, if the threads wake due to a timeout,
>   you have the decrement the waiter count.  But you have only one bit...

Uli, you're not even trying any more.

NO, you don't have just one bit. You have as many bits as you want. It's 
just that only 32 of the bits will be relevant for FUTEX_WAIT_OP etc.

			Linus
