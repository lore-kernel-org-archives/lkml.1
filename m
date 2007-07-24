Return-Path: <linux-kernel-owner+w=401wt.eu-S935643AbXGXJVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935643AbXGXJVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935009AbXGXJU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:20:27 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:52727 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759451AbXGXJUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:20:25 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 24 Jul 2007 14:51:47 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit()
 definitions
In-Reply-To: <46A5B652.3050304@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0707241359470.1433@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160608.22137.14790.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A577AA.4020804@yahoo.com.au> <Pine.LNX.4.64.0707241208440.1433@cselinux1.cse.iitk.ac.in>
 <46A5B652.3050304@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Nick Piggin wrote:

> Satyam Sharma wrote:
> > On Tue, 24 Jul 2007, Nick Piggin wrote:
> > > Satyam Sharma wrote:
> > > [...]
> > > > So let's make these proper no-ops, because that's exactly what we
> > > > require
> > > > these to be on the i386 platform.
> > > 
> > > No. clear_bit is not a compiler barrier on i386,
> > 
> > Obvious.
> > 
> > > thus smp_mb__before/after
> > > must be.

> > Not so obvious. Why do we require these to be a full compiler barrier
> > is precisely the question I raised here.

> > Consider this (the above two functions exist only for clear_bit(),
> > the atomic variant, as you already know), the _only_ memory reference
> > we care about is that of the address of the passed bit-string:
> 
> No. Memory barriers explicitly extend to all memory references.

[ Compiler barrier, you mean, that's not true of CPU barriers. ]

In any case, I know that, obviously. I asked "why" not "what" :-) i.e.
why should we care about other addresses / why do we want to extend
the compiler barrier to all memory references -- but Jeremy seems to
have answered that ...

> > (1) The compiler must not optimize / elid it (i.e. we need to disallow
> >     compiler optimization for that reference) -- but we've already taken
> >     care of that with the __asm__ __volatile__ and the constraints on
> >     the memory "addr" operand there, and,
> > (2) For the i386, it also includes an implicit memory (CPU) barrier
> >     already.
> 
> Repeating what has been said before: A CPU memory barrier is not a
> compiler barrier or vice versa. Seeing as we are talking about
> the compiler barrier, it is irrelevant as to whether or not the
> assembly includes a CPU barrier.

I think it is quite relevant, in fact. From Documentation/atomic_ops.txt,
smp_mb__{before,after}_clear_bit(), as the name itself suggests, must
be _CPU barriers_ for those arch's that don't have an implicit
_CPU barrier_ in the clear_bit() itself [ which i386 does have already ].

As for a compiler barrier, the asm there already guarantees the compiler
will not optimize references to _that_ address, but there could still be
the memset()/set{clear}_bit() interspersing pitfalls for example, so yeah
the memory clobber would probably protect us there.


Satyam
