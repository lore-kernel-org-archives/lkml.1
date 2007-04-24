Return-Path: <linux-kernel-owner+w=401wt.eu-S1161753AbXDXNlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161753AbXDXNlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 09:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161767AbXDXNlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 09:41:05 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:54346 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161753AbXDXNlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 09:41:02 -0400
X-AuditID: d80ac287-ad0c9bb00000590d-12-462e08ee6156 
Date: Tue, 24 Apr 2007 14:40:47 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
cc: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: PageLRU can be non-atomic bit operation
In-Reply-To: <6.0.0.20.2.20070424100507.049670d0@172.19.0.2>
Message-ID: <Pine.LNX.4.64.0704241410040.26223@blonde.wat.veritas.com>
References: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2>
 <Pine.LNX.4.64.0704231202390.29015@blonde.wat.veritas.com>
 <6.0.0.20.2.20070423210926.045668d0@172.19.0.2>
 <Pine.LNX.4.64.0704231438280.3516@blonde.wat.veritas.com>
 <6.0.0.20.2.20070424100507.049670d0@172.19.0.2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 24 Apr 2007 13:40:58.0841 (UTC) FILETIME=[30EC6490:01C78676]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Hisashi Hifumi wrote:
> At 22:42 07/04/23, Hugh Dickins wrote:
> >On Mon, 23 Apr 2007, Hisashi Hifumi wrote:
> > > >No.  The PG_lru flag bit is just one bit amongst many others:
> > > >what of concurrent operations changing other bits in that same
> > > >unsigned long e.g. trying to lock the page by setting PG_locked?
> > > >There are some places where such micro-optimizations can be made
> > > >(typically while first allocating the page); but in general, no.
> > >
> > > In i386 and x86_64, btsl is used to change page flag. In this case,
> > > if btsl without lock prefix
> > > set PG_locked and PG_lru flag concurrently, does only one operation
> > > succeed ?
> >
> >That's right: on an SMP machine, without the lock prefix, the operation
> >is no longer atomic: what's stored back may be missing the result of
> >one or the other of the racing operations.
> 
> In the case that changing the same bit concurrently, lock prefix or other
> spinlock is needed.

Why would you need any kind of lock when just changing a single bit,
if it didn't affect other bits of the same word?  Just as you don't
need a lock when simply assigning a word, setting a bit to 0 or 1
is simple in itself (it doesn't matter if it was 0 or 1 before).

> But, I think that concurrent bit operation on different bits
> is just like OR operation , so lock prefix is not needed.

I firmly believe that it is; but I'm not a processor expert.

> AMD instruction manual says about bts that ,
> 
> "Copies a bit, specified by bit index in a register or 8-bit immediate value
> (second operand), from a bit
> string (first operand), also called the bit base, to the carry flag (CF) of
> the rFLAGS register, and then
> sets the bit in the bit string to 1."
> 
> BTS instruction is read-modify-write instruction on bit unit. So concurrent
> bit operation on different bits may be possible.

read-modify-write indeed.  That's exactly what the "lock" prefix is
needed for, isn't it?  To lock together the read-modify-write cycles
to make the entire operation atomic on SMP.  Without which you may
lose the changes made concurrently to the same word by another cpu,
or it lose yours.

(If another cpu is merely changing the same bit as you are, no problem:
either you're both changing it to the same value, or you're racing to
set it to opposite values, and one of you wins - fair enough, however
much locking you add, you're still left with the situation that two
are racing and one wins in the end.)

You now seem to be arguing, never mind your original PageLRU case,
that include/asm-i386/bitops.h and include/asm-x86_64/bitops.h
don't need the LOCK_PREFIX before the "btsl" in set_bit().

I disagree with you; but let someone more authoritative speak up.
Mabye Andi can explain it a lot better than I can?

Hugh
