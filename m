Return-Path: <linux-kernel-owner+w=401wt.eu-S1032313AbXEHXnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032313AbXEHXnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969798AbXEHXnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:43:42 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:25363 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S969916AbXEHXnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:43:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=N0PcgmVnlYF/OwgtDPCpwZrgyaUprxr4pqVtFl+2+WNph5SRUOLMNCgGxb0mWDME1YUBlryo7pCTYZZArI2dmzKF2xkricI0WNRAPZ5P+F1HcXJKmdealhNIxu+y6hYD4/PCi/tcx7eGzlB6HlDmCHGWwfNhwhQBy3WxbXxCA3Q=  ;
X-YMail-OSG: L5Mp9VEVM1kX6AZznugq6e4bQ4f8HHANNymAwlanCDAWy0QmapD3TIMF6mWDSvf2Ra4YOPKLJg--
Message-ID: <46410B06.1070903@yahoo.com.au>
Date: Wed, 09 May 2007 09:43:02 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au> <463B598B.80200@redhat.com> <463BC62C.3060605@yahoo.com.au> <463E5A00.6070708@redhat.com> <464014B0.7060308@yahoo.com.au> <20070508183528.GM355@devserv.devel.redhat.com>
In-Reply-To: <20070508183528.GM355@devserv.devel.redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Jelinek wrote:
> On Tue, May 08, 2007 at 04:12:00PM +1000, Nick Piggin wrote:
> 
>>I didn't actually check system and user times for the mysql
>>benchmark, but that's exactly what I had in mind when I
>>mentioned the poor cache behaviour this patch could cause. I
>>definitely did see user times go up in benchmarks where I
>>measured.
>>
>>We have percpu and cache affine page allocators, so when
>>userspace just frees a page, it is likely to be cache hot, so
>>we want to free it up so it can be reused by this CPU ASAP.
>>Likewise, when we newly allocate a page, we want it to be one
>>that is cache hot on this CPU.
> 
> 
> malloc has per-thread arenas, so when using MADV_FREE the pages
> should be local to the thread as well (unless the thread has switched
> to a different CPU also to the CPU) and in case of sysbench should
> be cache hot as well (it is reused RSN).

Right, but the kernel also wants to use cache hot pages for other
things, and it also frees back its own cache hot pages into the
allocator.

The fact that sysbench is a good candidate for this but does not
show any improvements is telling... if the workload does not reuse
the page RSN, or if it is reclaiming them, we could actually see
regressions.


>  With MADV_DONTNEED you need to
> clear the pages while that is not necessary with MADV_FREE.

With MADV_FREE, you don't need to zero the memory, but the page
is uninitialised. So you need to initialise it *somehow* (ie. use
either a zeroing alloc, or initialise it with application specific
data). At that point, you have to touch the cachelines anyway, so
the extra zeroing is going to cost very little (and you can see
that single threaded performance isn't improved).

-- 
SUSE Labs, Novell Inc.
