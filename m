Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbXDEBoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbXDEBoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 21:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXDEBoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 21:44:30 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:29644 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932418AbXDEBo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 21:44:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=0e69bRJ/5FPS8J4fTzF1ATuuvq5lJPBCnz1XC1QnEkpefSkV60nBPMg4KyHbDa7PBr//cc34Gm1VzhgYYQmmop7QLx+keuVTqDsDmu0BvSn5Z4I1m3CWUAMyafF9MgaE87UgnIp21ciZhl4vjDyboKA+BYrwcuOf96Ri17RzbaA=  ;
X-YMail-OSG: uzu40aYVM1mCGI9LdtRGVTOQQwsfUA5yLfr_eLLA7MqVfQg0mYg0r8vL1PWzqv0cHy6FYytc8_GEHIC_bEVt_rJ9qX0gY205r2xaX5lTKtnifRIvYGJ7qQ--
Message-ID: <46145476.8080504@yahoo.com.au>
Date: Thu, 05 Apr 2007 11:44:22 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de> <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403202937.GE355@devserv.devel.redhat.com> <20070403144948.fe8eede6.akpm@linux-foundation.org> <20070403160231.33aa862d.akpm@linux-foundation.org> <Pine.LNX.4.64.0704040949050.17341@blonde.wat.veritas.com> <4613BC5D.2070404@redhat.com> <Pine.LNX.4.64.0704041610320.19450@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0704041610320.19450@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 4 Apr 2007, Rik van Riel wrote:
> 
>>Hugh Dickins wrote:
>>
>>
>>>(I didn't understand how Rik would achieve his point 5, _no_ lock
>>>contention while repeatedly re-marking these pages, but never mind.)
>>
>>The CPU marks them accessed&dirty when they are reused.
>>
>>The VM only moves the reused pages back to the active list
>>on memory pressure.  This means that when the system is
>>not under memory pressure, the same page can simply stay
>>PG_lazyfree for multiple malloc/free rounds.
> 
> 
> Sure, there's no need for repetitious locking at the LRU end of it;
> but you said "if the system has lots of free memory, pages can go
> through multiple free/malloc cycles while sitting on the dontneed
> list, very lazily with no lock contention".  I took that to mean,
> with userspace repeatedly madvising on the ranges they fall in,
> which will involve mmap_sem and ptl each time - just in order
> to check that no LRU movement is required each time.
> 
> (Of course, there's also the problem that we don't leave our
> systems with lots of free memory: some LRU balancing decisions.)

I don't agree this approach is the best one anyway. I'd rather
just the simple MADV_DONTNEED/MADV_DONEED.

Once you go through the trouble of protecting the memory and
flushing TLBs, unprotecting them afterwards and taking a trap
(even if it is a pure hardware trap), I doubt you've saved much.

You may have saved the cost of zeroing out the page, but that
has to be weighed against the fact that you have left a possibly
cache hot page sitting there to get cold, and your accesses to
initialise the malloced memory might have more cache misses.

If you just free the page, it goes onto a nice LIFO cache hot
list, and when you want to allocate another one, you'll probably
get a cache hot one.

The problem is down_write(mmap_sem) isn't it? We can and should
easily fix that problem now. If we subsequently want to look at
micro optimisations to avoid zeroing using MMU tricks, then we
have a good base to compare with.

-- 
SUSE Labs, Novell Inc.
