Return-Path: <linux-kernel-owner+w=401wt.eu-S1763362AbXGWRLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763362AbXGWRLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbXGWRLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:11:06 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:57911 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598AbXGWRLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:11:05 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Mon, 23 Jul 2007 22:42:22 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Andi Kleen <ak@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <200707231833.20678.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0707232220130.22796@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <200707231813.26859.ak@suse.de> <Pine.LNX.4.64.0707232152250.22155@cselinux1.cse.iitk.ac.in>
 <200707231833.20678.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 23 Jul 2007, Andi Kleen wrote:

> 
> > Yes, but _that_ address (of the bit-string) is protected already -- by the
> > implicit memory barrier due to the LOCK prefix.
> 
> Compiler barrier != CPU barrier.

Exactly, but the actual _synchronization_ in all users of the bitops API
should (should, at least, otherwise the bugs lie in the callers) depend
upon the _bit-string_ whose address is passed to us. That could be some
flags/lock/etc in some caller, whatever, but all the synchronization in
those users would be based upon _that_ -- and we're handling it alright
with the full CPU barrier for _that_ address. Also note that in all the
atomic/unatomic variants, we always constrain the passed pointer to
memory and for the atomic/locked variants at least, I don't really see
how compiler optimizations would get us into trouble (again, for the
_passed bit-string memory address_).

> The memory clobber is a compiler barrier that prevents its global optimizer
> from moving memory references.
> [...]
> > We shouldn't really be 
> > caring about any other memory addresses, so it doesn't affect the
> > correctness of the bitops API at all.
> 
> The problem is the relationship to other operations.


... I don't want to get argumentative, but IMHO, we don't really need
to care about other (other than the passed memory address) references.
The problem with marking all of memory clobbered is that we're
disallowing legitimate optimizations for other memory references.

> The CPU memory ordering guarantees are completely 
> independent from this.

Of course.

> This is not theoretic and we have had bugs because of this.

Those could've been due to buggy users, not necessarily the bitops.

Satyam
