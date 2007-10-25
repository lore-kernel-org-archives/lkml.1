Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbXJYXKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbXJYXKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbXJYXJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:09:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:44197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbXJYXJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:09:54 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Is gcc thread-unsafe?
Date: Fri, 26 Oct 2007 01:09:49 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710250915.50675.ak@suse.de> <200710260849.42776.nickpiggin@yahoo.com.au>
In-Reply-To: <200710260849.42776.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260109.50092.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 00:49:42 Nick Piggin wrote:
> On Thursday 25 October 2007 17:15, Andi Kleen wrote:
> > On Thursday 25 October 2007 05:24, Nick Piggin wrote:
> > > Basically, what the gcc developers are saying is that gcc is
> > > free to load and store to any memory location, so long as it
> > > behaves as if the instructions were executed in sequence.
> >
> > This case is clearly a bug, a very likely code pessimization.
> > I guess it wasn't intentional, just an optimization that is useful
> > for local register values doing too much.
> 
> Although there can be cases where it looks much more like an
> optimisation (eg. where the branch and increment occurs much
> more often), but it would still be a bug. Granted they are
> rather constructed cases, but I don't think you want to rely on
> the fact that most of the time it's OK.
> 
> 
> > > I guess that dynamically allocated memory and computed pointers
> > > are more difficult for gcc to do anything unsafe with, because
> > > it is harder to tell if a given function has deallocated the
> > > memory.
> >
> > Often accesses happen without function calls inbetween.
> > Also I think newer gcc (not 3.x) can determine if a pointer
> > "escapes" or not so that might not protect against it.
> >
> > > Any thoughts?
> >
> > We don't have much choice: If such a case is found it has to be marked
> > volatile or that particular compiler version be unsupported.
> 
> Marking volatile I think is out of the question. To start with,
> volatile creates really poor code (and most of the time we actually
> do want the code in critical sections to be as tight as possible).

Poor code is better than broken code I would say. Besides
the cross CPU synchronization paths are likely dominated by 
cache misses anyways; it's unlikely they're actually limited
by the core CPU. So it'll probably not matter all that much
if the code is poor or not.

But it's all theoretical for now.

> But also because I don't think these bugs are just going to be
> found easily.
> 
> 
> > It might be useful to come up with some kind of assembler pattern
> > matcher to check if any such code is generated for the kernel
> > and try it with different compiler versions.
> 
> Hard to know how to do it. If you can, then it would be interesting.

I checked my kernel for "adc" at least (for the trylock/++ pattern) 
and couldn't find any (in fact all of them were in 
data the compiler thought to be code). That was not a allyesconfig build,
so i missed some code. 

For cmov it's at first harder because they're much more frequent
and cmov to memory is a multiple instruction pattern (the instruction
does only support memory source operands). Luckily gcc
doesn't know the if (x) mem = a; => ptr = cmov(x, &a, &dummy); *ptr = a; 
transformation trick so I don't think there are actually any conditional 
stores on current x86. 

It might be a problem on other architectures which support true
conditional stores though (like IA64 or ARM) 

Also I'm not sure if gcc doesn't know any other tricks like the
conditional add using carry, although I cannot think of any related
to stores from the top of my hat.

Anyways, if it's only conditional add if we ever catch such a case
it could be also handled with inline assembly similar to local_inc()

-Andi
