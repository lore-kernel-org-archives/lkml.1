Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZJETSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZJETSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:18:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZJETSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:18:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296AbZJETSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:18:00 -0400
Date: Mon, 5 Oct 2009 12:16:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86: Generate cmpxchg build failures
In-Reply-To: <1254758425.26976.126.camel@twins>
Message-ID: <alpine.LFD.2.01.0910051210280.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>  <4AC060AE.1090401@gmail.com>  <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>  <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>  <4AC10365.7090802@gmail.com>
 <4AC2712C.4080901@gmail.com>  <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <1254758425.26976.126.camel@twins>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Oct 2009, Peter Zijlstra wrote:

> On Tue, 2009-09-29 at 14:17 -0700, Linus Torvalds wrote:
> 
> > And regardless, we should fix the silent cmpxchg failure, even if it's 
> > just a link-time failure or something.
> 
> Something like the below?

Looks good to me. This is also one of the cases where a macro will do 
better than an inline function, since the return value depends on the size 
of the pointer, and it doesn't do the whole 'unsigned long' thing any 
more.

It should also be fairly easy to make this now just do a cmpxchg8b for the 
64-bit case (again, that wouldn't have worked sanely due to the fixed type 
in the inline function version - expanding that size to 64-bit would have 
been insane). But that's a separate issue (and maybe we don't want to do 
it, due to the whole "it's not DMA-atomic" etc issue - we may be better 
off with a build failure, and forcing people who really want 64-bit 
accesses to use the explicit cmpxchg64 thing)

That said, I think that you should merge the insane three versions of this 
macro into one. Having separate versions for "__[sync_|local_|]cmpxchg()" 
is disgusting. I bet you can do it with a single macro, and just pass in 
the LOCK_PREFIX (or empty, or "lock;") to that as needed. Rather than 
duplicating it three times.

			Linus
