Return-Path: <linux-kernel-owner+w=401wt.eu-S934977AbXGXLIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934977AbXGXLIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933462AbXGXLIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:08:47 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:43357 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760332AbXGXLIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:08:46 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 24 Jul 2007 16:40:09 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit()
 definitions
In-Reply-To: <423904.37199.qm@web53810.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0707241631220.1433@cselinux1.cse.iitk.ac.in>
References: <423904.37199.qm@web53810.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Nick Piggin wrote:

> > > Satyam Sharma wrote:
> 
> > > > Consider this (the above two functions exist
> > only for clear_bit(),
> > > > the atomic variant, as you already know), the
> > _only_ memory reference
> > > > we care about is that of the address of the
> > passed bit-string:
> > > 
> > > No. Memory barriers explicitly extend to all
> > memory references.
> > 
> > [ Compiler barrier, you mean, that's not true of CPU
> > barriers. ]
> 
> For the purpose of this discussion (Linux memory
> barrier semantics, on WB memory), it is true of CPU
> and compiler barriers.

On later Intel processors, if the memory address range being referenced
(and say written to) by the (locked) instruction is in the cache of a
CPU, then it will not assert the LOCK signal on the system bus --
thus not assume exclusive use of shared memory. So other CPUs are free
to modify (other) memory at that point. Cache coherency will still
ensure _that_ (locked) memory area is still updated atomically, though.

> Obviously because we want some kind of ordering
> guarantee at a given point. All the CPU barriers
> in the world are useless if the compiler can reorder
> access over them.

Yes ...

> > As for a compiler barrier, the asm there already
> > guarantees the compiler
> > will not optimize references to _that_ address
> 
> One or both of us still fails to understand the other.

... I think the culprit is me ...

> bit_spin_lock(LOCK_NR, &word);
> var++;
> /* this is bit_spin_unlock(LOCK_NR, &word); */
> smp_mb__before_clear_bit();
> clear_bit(LOCK_NR, &word);

Yup, David has laid this out clearly, as well.

> Are you saying that it is OK for the store to var to
> be reordered below the clear_bit? If not, what are you
> saying?

I might be making a radical turn-around here, but all of a
sudden I think it's actually a good idea to put a complete
memory clobber in set_bit/clear_bit and friends themselves,
and leave the "__" variants as they are.


Satyam
