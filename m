Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYEaCOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYEaCOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 22:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYEaCO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 22:14:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbYEaCO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 22:14:29 -0400
Date: Fri, 30 May 2008 19:13:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com>
Message-ID: <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org>
References: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 May 2008, Ulrich Drepper wrote:
> 
> Without imposing unreasonable limitations on the number of concurrent users
> a rwlock can have the state cannot be represented in a single 32-bit variable.

I call bull on that.

We've had a 32-bit rwsemaphore in the kernel for a *long* time.

I think it's totally stupid for glibc to even *try* to do something like 
this, since almost nobody will have a kernel with 64-bit futex support for 
a long time in the wild anyway. So you need to support a 32-bit semaphore 
in practice, and it's been done before.

The x86 kernel rwsem implementation may limit things to 64k readers (I'm 
not even sure that's true, I'm not going to look at the code again), but 
if I recall correctly that's just because we wanted to use a single "xadd" 
in the hotpath, instead of doign a load a cmpxchg.

I really object to adding another 32/64-bit difference just for something 
like an rwsemaphore. It needs a whole lot of stronger reasons than that.

I suspect the old rwlocks are simply just stupid. You can do those things 
with a single 32-bit locked op. Have you tried
 - 29 bits of reader counts
 - 1 bit of uncontended writer
 - 1 bit of "contention" (ie a mark for requiring fairness)
 - 1 bit for a spinlock so that you can do all the fairness without doing 
   any extra locked ops
or similar?

			Linus
