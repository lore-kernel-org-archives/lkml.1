Return-Path: <linux-kernel-owner+w=401wt.eu-S1945976AbXDCVah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945976AbXDCVah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945975AbXDCVah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:30:37 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:50866 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945977AbXDCVah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:30:37 -0400
Message-ID: <4612C759.6090708@cosmosbay.com>
Date: Tue, 03 Apr 2007 23:30:01 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com> <20070403135154.61e1b5f3.akpm@linux-foundation.org> <4612C059.8070702@redhat.com> <4612C2B6.3010302@cosmosbay.com> <4612C401.3010507@redhat.com>
In-Reply-To: <4612C401.3010507@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 03 Apr 2007 23:30:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel a écrit :
> Eric Dumazet wrote:
>> Rik van Riel a écrit :
>>> Andrew Morton wrote:
>>>
>>>> Oh.  I was assuming that we'd want to unmap these pages from 
>>>> pagetables and
>>>> mark then super-easily-reclaimable.  So a later touch would incur a 
>>>> minor
>>>> fault.
>>>>
>>>> But you think that we should leave them mapped into pagetables so no 
>>>> such
>>>> fault occurs.
>>>
>>>> Leaving the pages mapped into pagetables means that they are 
>>>> considerably
>>>> less likely to be reclaimed.
>>>
>>> If we move the pages to a place where they are very likely to be
>>> reclaimed quickly (end of the inactive list, or a separate
>>> reclaim list) and clear the dirty and referenced lists, we can
>>> both reclaim the page easily *and* avoid the page fault penalty.
>>>
>>
>> There is one possible speedup :
>>
>> - If an user app does a madvise(MADV_DONTNEED), we can assume the 
>> pages can later be bring back without need to zero them. The 
>> application doesnt care.
> 
> ... however, the application that previously used that page might
> care a lot!

The application that does madvise(MADV_WHATEVER_MEANS_KENREL_CAN_DROP)
doesnt care. It it cares, it would use munmap(), or no syscall at all.

> 
>> mmap()/brk() must give fresh NULL pages, but maybe 
>> madvise(MADV_DONTNEED) can relax this requirement (if the pages were 
>> reclaimed, then a page fault could bring a new page with random content)
> 
> If we bring in a new page, it has to be zeroed for security
> reasons.
> 
> You don't want somebody else's process to get a page with
> your password in it.

Then an application that cares of passwd wont use 
madvise(MADV_WHATEVER_MEANS_I_DONT_CARE)

;)

Maybe I was not clear, but I was refering to a pool of 'discardable' pages, 
that would be feeded by applications that want to notify kernel some pages can 
be completly discarded (contains no security data of course, nor data that the 
applications dont want to forget), and might be given to a consumer without 
the need of zeroing it.

We might make this pool private to each process, but then it would benefit to 
less workloads I guess...

