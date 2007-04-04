Return-Path: <linux-kernel-owner+w=401wt.eu-S2992721AbXDDIEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992721AbXDDIEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992728AbXDDIEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:04:43 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:31347 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992721AbXDDIEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:04:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=2nKd9tRpA8aH9PEZSuC9NT3hsDIMlhlx5eRyZLrQcChaDnwln3V/ohWxfjRUZzXWzraAfBYQI2/kCq/PEdzm7M70O9cJVwEBUGNSUM5UZRvHPQ2GnxucwsdEO/7PyExXEUg4H2r+2tF4+M++tD88c3piR9AUbasL7IQ8Xa+x8eQ=  ;
X-YMail-OSG: TamrzKAVM1nhkOWqpSEiN5CCNokOxi5dIB1.D3gCntg.JLJj_MNeERzuEJIjhSdhKggux.14qg--
Message-ID: <46135C0E.5070803@yahoo.com.au>
Date: Wed, 04 Apr 2007 18:04:30 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ulrich Drepper <drepper@redhat.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <461357C4.4010403@yahoo.com.au>
In-Reply-To: <461357C4.4010403@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Ulrich Drepper wrote:
> 
>> People might remember the thread about mysql not scaling and pointing
>> the finger quite happily at glibc.  Well, the situation is not like that.
>>
>> The problem is glibc has to work around kernel limitations.  If the
>> malloc implementation detects that a large chunk of previously allocated
>> memory is now free and unused it wants to return the memory to the
>> system.  What we currently have to do is this:
>>
>>   to free:      mmap(PROT_NONE) over the area
>>   to reuse:     mprotect(PROT_READ|PROT_WRITE)
>>
>> Yep, that's expensive, both operations need to get locks preventing
>> other threads from doing the same.
>>
>> Some people were quick to suggest that we simply avoid the freeing in
>> many situations (that's what the patch submitted by Yanmin Zhang
>> basically does).  That's no solution.  One of the very good properties
>> of the current allocator is that it does not use much memory.
> 
> 
> Does mmap(PROT_NONE) actually free the memory?
> 
> 
>> A solution for this problem is a madvise() operation with the following
>> property:
>>
>>   - the content of the address range can be discarded
>>
>>   - if an access to a page in the range happens in the future it must
>>     succeed.  The old page content can be provided or a new, empty page
>>     can be provided
>>
>> That's it.  The current MADV_DONTNEED doesn't cut it because it zaps the
>> pages, causing *all* future reuses to create page faults.  This is what
>> I guess happens in the mysql test case where the pages where unused and
>> freed but then almost immediately reused.  The page faults erased all
>> the benefits of using one mprotect() call vs a pair of mmap()/mprotect()
>> calls.
> 
> 
> Two questions.
> 
> In the case of pages being unused then almost immediately reused, why is
> it a bad solution to avoid freeing? Is it that you want to avoid
> heuristics because in some cases they could fail and end up using memory?
> 
> Secondly, why is MADV_DONTNEED bad? How much more expensive is a pagefault
> than a syscall? (including the cost of the TLB fill for the memory access
> after the syscall, of course).
> 
> zapping the pages puts them on a nice LIFO cache hot list of pages that
> can be quickly used when the next fault comes in, or used for any other
> allocation in the kernel. Putting them on some sort of reclaim list seems
> a bit pointless.
> 
> Oh, also: something like this patch would help out MADV_DONTNEED, as it
> means it can run concurrently with page faults. I think the locking will
> work (but needs forward porting).

BTW. and this way it becomes much more attractive than using mmap/mprotect
can ever be, because they must take mmap_sem for writing always.

You don't actually need to protect the ranges unless running with use after
free debugging turned on, do you?

-- 
SUSE Labs, Novell Inc.
