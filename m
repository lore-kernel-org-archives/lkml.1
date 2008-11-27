Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbYK0TEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbYK0TEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 14:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYK0TE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 14:04:26 -0500
Received: from smtp-out.google.com ([216.239.45.13]:38279 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbYK0TE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 14:04:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=nEcsfvAT8tE7Nz59UveuUeP4So9jIX5VKRoJm/lypW0rgkl+mK6BkATGkxcFj18le
	ylXBshb7fG5cnLdwCcEbg==
Message-ID: <492EEF0C.9040607@google.com>
Date: Thu, 27 Nov 2008 11:03:40 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Ying Han <yinghan@google.com>, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>,
       Rohit Seth <rohitseth@google.com>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, edwintorok@gmail.com
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com> <20081123091843.GK30453@elte.hu> <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com> <20081126123246.GB23649@wotan.suse.de> <492DAA24.8040100@google.com> <20081127085554.GD28285@wotan.suse.de> <492E6849.6090205@google.com> <20081127130817.GP28285@wotan.suse.de>
In-Reply-To: <20081127130817.GP28285@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-GMailtapped-By: 172.25.146.19
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thu, Nov 27, 2008 at 01:28:41AM -0800, Mike Waychison wrote:
>>> Hmm. How quantifiable is the benefit? Does it actually matter that you
>>> can read the proc file much faster? (this is for some automated workload
>>> management daemon or something, right?)
>> Correct.  I don't recall the numbers from the pathelogical cases we were 
>> seeing, but iirc, it was on the order of 10s of seconds, likely 
>> exascerbated by slower than usual disks.  I've been digging through my 
>> inbox to find numbers without much success -- we've been using a variant 
>> of this patch since 2.6.11.
>>
>> Török however identified mmap taking on the order of several 
>> milliseconds due to this exact problem:
>>
>> http://lkml.org/lkml/2008/9/12/185
> 
> Turns out to be a different problem.
> 

What do you mean?

> 
>>> Would it be possible to reduce mmap()/munmap() activity? eg. if it is
>>> due to a heap memory allocator, then perhaps do more batching or set
>>> some hysteresis.
>> I know our tcmalloc team had made great strides to reduce mmap_sem 
>> contention for the heap, but there are various other bits of the stack 
>> that really want to mmap files..
>>
>> We generally try to avoid such things, but sometimes it a) can't be 
>> easily avoided (third party libraries for instance) and b) when it hits 
>> us, it affects the overall health of the machine/cluster (the monitoring 
>> daemons get blocked, which isn't very healthy).
> 
> Are you doing appropriate posix_fadvise to prefetch in the files before
> faulting, and madvise hints if appropriate?
> 

Yes, we've been slowly rolling out fadvise hints out, though not to 
prefetch, and definitely not for faulting.  I don't see how issuing a 
prefetch right before we try to fault in a page is going to help 
matters.  The pages may appear in pagecache, but they won't be uptodate 
by the time we look at them anyway, so we're back to square one.

The best use for fadvise we've found is FADV_DONTNEED as it kicks off 
any IO for dirty pages asynchronously (except it misses metadata..). 
That it drops clean pages is a nice side-benefit.  With it, we don't 
have to rely on the kernel's heuristics for writeout which lead to 
imbalances and latency spikes.
