Return-Path: <linux-kernel-owner+w=401wt.eu-S1757805AbXFAXAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbXFAXAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbXFAXAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:00:48 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbXFAXAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:00:47 -0400
Date: Fri, 1 Jun 2007 16:00:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
 <20070601135900.ec44b1aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
 <20070601151649.bb23c6f9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
 <20070601153328.1118ccaf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Christoph Lameter wrote:
> 
> Right it could catch a lot of other bugs as well.

I'd actually prefer "malloc(0)" to _not_ return NULL, but some known 
(non-NULL) bogus pointer.

Why?

Because it's quite sane to have simple logic like

	ptr = malloc(size);
	if (!ptr)
		return -ENOMEM;

and writing it as

	if (size && !ptr)
		return -ENOMEM;

is just annoying.

Also, NULL is _special_. There are absolutely tons of code in the kernel 
(and elsewhere) that just does something *different* from NULL pointers, 
and that totally breaks the whole notion of "you can allocate a zero-sized 
allocation, you just must not dereference it". If people special-case 
NULL as something else, they won't even go through the normal code-path.

So for *both* of the above reasons, it's actually stupid to return NULL 
for a zero-sized allocation. It would be much better to return another 
pointer that will trap on access. A good candidate might be to return

	#define BADPTR ((void *)16)

which is a portable-enough (where "portable-enough" is "against strict 
ANSI C rules, but works in practice on all architectures") way to return 
something that will cause the same page fault behaviour as NULL, but will 
_not_ trigger the "NULL is special" code.

(Of course, you then need to teach "kfree()" to accept it as another 
pointer to be ignored, that's fine).

I bet you'd find *more* problems that way than by returning NULL, and 
you'd also avoid the whole problem with "if (!ptr) return -ENOMEM".

		Linus
