Return-Path: <linux-kernel-owner+w=401wt.eu-S2992792AbXDDJpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992792AbXDDJpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992793AbXDDJpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:45:49 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:47791 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992792AbXDDJps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:45:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=KS/xcZ++OObxsfihecZeoZeq0/jTDMyCSHbzsh+1oTri+x68Ul21sXKIeKOCrDWE21JtxyE8ZInniQSPUlf1WxjbeUcw+rNRnCVR7rGvlk2ze61EvR2IweD9UfkLFYdOcw4mq48DjNczideR0evdh/e3GeIUwH9La9hPJ7/4xpQ=  ;
X-YMail-OSG: gU61MP4VM1kLf2Ns.9QM_ZM1eicixb309JgpqUWVjmqMuMGg4yDQn1Dh6IavLsnHAFrS9PGj.Q--
Message-ID: <461373C4.7050501@yahoo.com.au>
Date: Wed, 04 Apr 2007 19:45:40 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com>	<20070403202937.GE355@devserv.devel.redhat.com>	<20070403144948.fe8eede6.akpm@linux-foundation.org>	<4612DCC6.7000504@cosmosbay.com>	<46130BC8.9050905@yahoo.com.au>	<1175675146.6483.26.camel@twins>	<461367F6.10705@yahoo.com.au> <20070404113447.17ccbefa.dada1@cosmosbay.com>
In-Reply-To: <20070404113447.17ccbefa.dada1@cosmosbay.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> On Wed, 04 Apr 2007 18:55:18 +1000
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>Peter Zijlstra wrote:
>>
>>>On Wed, 2007-04-04 at 12:22 +1000, Nick Piggin wrote:
>>>
>>>
>>>>Eric Dumazet wrote:
>>>
>>>
>>>>>I do think such workloads might benefit from a vma_cache not shared by 
>>>>>all threads but private to each thread. A sequence could invalidate the 
>>>>>cache(s).
>>>>>
>>>>>ie instead of a mm->mmap_cache, having a mm->sequence, and each thread 
>>>>>having a current->mmap_cache and current->mm_sequence
>>>>
>>>>I have a patchset to do exactly this, btw.
>>>
>>>
>>>/me too
>>>
>>>However, I decided against pushing it because when it does happen that a
>>>task is not involved with a vma lookup for longer than it takes the seq
>>>count to wrap we have a stale pointer...
>>>
>>>We could go and walk the tasks once in a while to reset the pointer, but
>>>it all got a tad involved.
>>
>>Well here is my core patch (against I think 2.6.16 + a set of vma cache
>>cleanups and abstractions). I didn't think the wrapping aspect was
>>terribly involved.
> 
> 
> Well, I believe this one is too expensive. I was thinking of a light one :
> 
> I am not deleting mmap_sem, but adding a sequence number to mm_struct, that is incremented each time a vma is added/deleted, not each time mmap_sem is taken (read or write)

That's exactly what mine does (except IIRC it doesn't invalidate when
you add a vma).


> Each thread has its own copy of the sequence, taken at the time find_vma() had to do a full lookup.
> 
> I believe some optimized paths could call check_vma_cache() without mmap_sem read lock taken, and if it fails, take the mmap_sem lock and do the slow path.

The mmap_sem for read does not only protect the mm_rb rbtree structure, but
the vmas themselves as well as their page tables, so you can't do that.

You could do it if you had a lock-per-vma to synchronise against write
operations, and rcu-freed vmas or some such... but I don't think we should
go down a road like that until we first remove mmap_sem from low hanging
things (like private futexes!) and then see who's complaining.

-- 
SUSE Labs, Novell Inc.
