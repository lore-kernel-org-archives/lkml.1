Return-Path: <linux-kernel-owner+w=401wt.eu-S1423302AbXDYI47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423302AbXDYI47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423324AbXDYI47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:56:59 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:46985 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423302AbXDYI46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:56:58 -0400
Subject: Re: [PATCH] mm: PageLRU can be non-atomic bit operation
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Andi Kleen <ak@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200704241622.30773.ak@suse.de>
References: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2>
	 <6.0.0.20.2.20070424100507.049670d0@172.19.0.2>
	 <Pine.LNX.4.64.0704241410040.26223@blonde.wat.veritas.com>
	 <200704241622.30773.ak@suse.de>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 25 Apr 2007 17:56:56 +0900
Message-Id: <1177491416.15618.7.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-24 at 16:22 +0200, Andi Kleen wrote:
> > Why would you need any kind of lock when just changing a single bit,
> > if it didn't affect other bits of the same word?  Just as you don't
> > need a lock when simply assigning a word, setting a bit to 0 or 1
> > is simple in itself (it doesn't matter if it was 0 or 1 before).
> > 
> > > But, I think that concurrent bit operation on different bits
> > > is just like OR operation , so lock prefix is not needed.
> > 
> > I firmly believe that it is; but I'm not a processor expert.
> 
> Think of the CPU cache like the page cache. The VFS cannot change
> anything directly on disk - it always has to read a page (or block);
> change it there even if it's only a single bit and back.
> 
> Now imagine multiple independent kernels to that disk doing this in parallel
> without any locking. You will lose data on simple changes because
> of data races.
> 
> The CPU is similar. The memory is the disk; the protocol talking to 
> the memory only knows cache lines.  There are multiple CPUs talking
> to that memory. The CPUs cannot change anything 
> without reading  a full cache line first and then later writing it back. 
> There is "just do OR operation" when talking to memory, just like
> disks don't have such a operation; just read and write.
> 
> [there are some special cases with uncached mappings, but they are not
> relevant here]
> 
> With lock the CPU ensures the read-modify-write cycle is atomic, 
> without it doesn't.
>  
> The CPU also guarantees you that multiple writes don't get lost
> even when they hit the same cache line (otherwise you would need lock
> for anything in the same cache line), but it doesn't guarantee that
> for a word. The details for that vary by architecture; on x86 it is 
> any memory access, on others it can be only guaranteed for long stores.
> 
> The exact rules for all this can be quite complicated (and also vary
> by architecture), this is a simplification but should be enough as a rough 
> guide.

Intel 80386 Reference Programmer's Manual reads:

" When accessing a bit in memory, the processor may access four bytes
starting from the memory address given by:

   Effective Address + (4 * (BitOffset DIV 32))
for a 32-bit operand size, or two bytes starting from the memory address
given by: 
   Effective Address + (2 * (BitOffset DIV 16))
for a 16-bit operand size. It may do this even when only a single byte
needs to be accessed in order to get at the given bit. "

This seems to imply that we need the lock prefix even when updating
different bits within the same long (not just the same byte). Is this
interpretation correct?

 - Fernando

