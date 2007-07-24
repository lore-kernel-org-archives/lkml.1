Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbXGXHdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbXGXHdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbXGXHc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:32:56 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:50698 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbXGXHcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:32:55 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 24 Jul 2007 13:04:19 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit()
 definitions
In-Reply-To: <46A577AA.4020804@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0707241208440.1433@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160608.22137.14790.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A577AA.4020804@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Nick Piggin wrote:

> Satyam Sharma wrote:
> > From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> > 
> > [8/8] i386: bitops: smp_mb__{before, after}_clear_bit() definitions
> > 
> > > From Documentation/atomic_ops.txt, those archs that require explicit
> > memory barriers around clear_bit() must also implement these two interfaces.
> > However, for i386, clear_bit() is a strict, locked, atomic and
> > un-reorderable operation and includes an implicit memory barrier already.
> > 
> > But these two functions have been wrongly defined as "barrier()" which is
> > a pointless _compiler optimization_ barrier, and only serves to make gcc
> > not do legitimate optimizations that it could have otherwise done.
> > 
> > So let's make these proper no-ops, because that's exactly what we require
> > these to be on the i386 platform.
> 
> No. clear_bit is not a compiler barrier on i386,

Obvious.

> thus smp_mb__before/after
> must be.

Not so obvious. Why do we require these to be a full compiler barrier
is precisely the question I raised here.

Consider this (the above two functions exist only for clear_bit(),
the atomic variant, as you already know), the _only_ memory reference
we care about is that of the address of the passed bit-string:

(1) The compiler must not optimize / elid it (i.e. we need to disallow
    compiler optimization for that reference) -- but we've already taken
    care of that with the __asm__ __volatile__ and the constraints on
    the memory "addr" operand there, and,
(2) For the i386, it also includes an implicit memory (CPU) barrier
    already.

So I /think/ it makes sense to let the compiler optimize _other_ memory
references across the call to clear_bit(). There's a difference. I think
we'd be safe even if we do this, because the synchronization in callers
must be based upon the _passed bit-string_, otherwise _they_ are the
ones who're buggy.

[ However, elsewhere Jeremy Fitzhardinge mentioned the case of
  some callers, for instance, doing a memset() on an alias of
  the same bit-string. But again, I think that is dodgy/buggy/
  extremely border-line usage on the caller's side itself ...
  *unless* the caller is doing that inside a higher-level lock
  anyway, in which case he wouldn't be needing to use the
  locked variants either ... ]

[ For those interested, I've been looking at the code generated
  for the test kernel I built with these patches, and I don't
  really see anything gcc did that it shouldn't have -- but ok,
  that doesn't mean other versions/toolchains for other setups
  won't. Also, the test box has been up all night, but I'm only
  running Firefox on it anyway, and don't really know how to
  verify if I've introduced any correctness issues / bugs. ]


Satyam
