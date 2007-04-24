Return-Path: <linux-kernel-owner+w=401wt.eu-S1161773AbXDXOW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161773AbXDXOW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 10:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161775AbXDXOW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 10:22:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:56355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161773AbXDXOW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 10:22:57 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] mm: PageLRU can be non-atomic bit operation
Date: Tue, 24 Apr 2007 16:22:30 +0200
User-Agent: KMail/1.9.6
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2> <6.0.0.20.2.20070424100507.049670d0@172.19.0.2> <Pine.LNX.4.64.0704241410040.26223@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0704241410040.26223@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704241622.30773.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Why would you need any kind of lock when just changing a single bit,
> if it didn't affect other bits of the same word?  Just as you don't
> need a lock when simply assigning a word, setting a bit to 0 or 1
> is simple in itself (it doesn't matter if it was 0 or 1 before).
> 
> > But, I think that concurrent bit operation on different bits
> > is just like OR operation , so lock prefix is not needed.
> 
> I firmly believe that it is; but I'm not a processor expert.

Think of the CPU cache like the page cache. The VFS cannot change
anything directly on disk - it always has to read a page (or block);
change it there even if it's only a single bit and back.

Now imagine multiple independent kernels to that disk doing this in parallel
without any locking. You will lose data on simple changes because
of data races.

The CPU is similar. The memory is the disk; the protocol talking to 
the memory only knows cache lines.  There are multiple CPUs talking
to that memory. The CPUs cannot change anything 
without reading  a full cache line first and then later writing it back. 
There is "just do OR operation" when talking to memory, just like
disks don't have such a operation; just read and write.

[there are some special cases with uncached mappings, but they are not
relevant here]

With lock the CPU ensures the read-modify-write cycle is atomic, 
without it doesn't.
 
The CPU also guarantees you that multiple writes don't get lost
even when they hit the same cache line (otherwise you would need lock
for anything in the same cache line), but it doesn't guarantee that
for a word. The details for that vary by architecture; on x86 it is 
any memory access, on others it can be only guaranteed for long stores.

The exact rules for all this can be quite complicated (and also vary
by architecture), this is a simplification but should be enough as a rough 
guide.

Hope this helps,

-Andi
