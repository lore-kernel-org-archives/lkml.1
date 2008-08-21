Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYHUVRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYHUVRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYHUVQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:16:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbYHUVQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:16:52 -0400
Date: Thu, 21 Aug 2008 14:15:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Writer-biased low-latency rwlock v8
In-Reply-To: <alpine.LFD.1.10.0808211356360.3487@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808211402370.3487@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org> <20080817075335.GA25019@Krystal> <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org>
 <20080817191034.GA5258@Krystal> <20080818232500.GF6732@linux.vnet.ibm.com> <20080819060417.GB24085@Krystal> <20080819073345.GA30285@Krystal> <alpine.LFD.1.10.0808190946560.3324@nehalem.linux-foundation.org> <20080821205045.GA24909@Krystal>
 <alpine.LFD.1.10.0808211356360.3487@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Aug 2008, Linus Torvalds wrote:
> 
> That leaves 30 bits for readers. If you still think you need to "limit the 
> number of readers", then you aren't getting it.

Side note: the actual main rwlock thing is designed for a 64-bit word and 
the waiters separately as two 32-bit words, so it doesn't really do what I 
describe, but that's actually because the whole sleeping thing is _harder_ 
than a spinning thing, and has races with wakeups etc.

A spinning thing, in contrast, is pretty trivial.

So here's what I think your code should be like:

 rdlock:
	movl $4,%eax
	lock ; xaddl %eax,(%rdi)
	testl $3,%eax
	jne __rdlock_slowpath
	ret

 rwlock:
	xorl %eax,%eax
	movl $1,%edx
	lock ; cmpxchgl %edx,(%rdi)
	jne __rwlock_slowpath
	ret

 rdunlock:
	lock ; subl $4,(%rdi)
	ret

 rwunlock:
	lock ; andl $~1,(%rdi)
	ret

and I'm pretty damn sure that that should be totally sufficient for a 
spinning rwlock. The non-spinning one is more complex just because the 
unlock paths need to guarantee that something gets woken up, that just 
isn't an issue when you do spinlocks.

Now, in the slow-path:
 - on the rwlock slowpath side, set bit#1 to make sure that readers get 
   caught in the slowpath
 - then do a *separate* count of how many pending readers and writers 
   (ie the ones that got caught into the slowpath) you have (one word 
   each is probably fine), and then the slowpaths can just do the right 
   thing depending on whether there are pending readers/writers.

See? The main lock needs not worry about number of writers AT ALL, because 
it's totally irrelevant. So don't worry about running out of bits. You 
won't. Just put those counts somewhere else! The only thing that matters 
for the main lock word is whether there are active readers (30 bits), and 
whether there is an active writer (there can only ever be one: 1 bit), and 
whether new readers should be trapped (1 bit).

If you worry about overflows, you're doing something wrong.

			Linus
