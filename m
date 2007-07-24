Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbXGXVgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbXGXVgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbXGXVgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:36:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:53731 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbXGXVgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:36:37 -0400
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
	unnecessarily
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707241021210.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <alpine.LFD.0.999.0707231054290.3607@woody.linux-foundation.org>
	 <1185270756.5439.256.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0707241021210.3607@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 07:36:17 +1000
Message-Id: <1185312977.5439.281.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 10:24 -0700, Linus Torvalds wrote:
> 
> On Tue, 24 Jul 2007, Benjamin Herrenschmidt wrote:
> > 
> > In fact, it's more than that... the bitops that return a value are often
> > used to have hand-made spinlock semantics. I'm sure we would get funky
> > bugs if loads or stores leaked out of the locked region. I think a full
> > "memory" clobber should be kept around for those cases.
> 
> Not helpful.
> 
> The CPU ordering constraints for "test_and_set_bit()" and friends are weak 
> enough that even if you have a full memory clobber, it still wouldn't work 
> as a lock.
>
> That's exactly why we have smp_mb__after_set_bit() and friends. On some 
> architectures (arm, mips, parsic, powerpc), *that* is where the CPU memory 
> barrier is, because the "test_and_set_bit()" itself is just a 
> cache-coherent operation, not an actual barrier.

Well, as I said, our test_and_set_bit() asm (and in general, the asm for
all the atomic ops that -return- a value) have at least some level of
barriers in them because of that. We do that because people are abusing
them as locks. The smp_mb__after_set_bit() I never quite grokked. We do
an mb in there but I suspect we don't need if it's only ever used after
test_and_set_bit() because of the above. The smb_mb__before_clear_bit()
makes more sense as it's supposed to give clear_bit() a spin_unlock
semantic.

But we do need the "memory" clobber as well.

That's one reason why I like Nick's bitop locks patches, providing
-explicit- test_and_set_bit_lock() and clear_bit_unlock(), we can fix a
whole lot of things and make sure they have the right barriers and not
more. (We save a few useless barriers on POWER that way in the page lock
path and it's measureable in his benchmark).

Cheers,
Ben.



