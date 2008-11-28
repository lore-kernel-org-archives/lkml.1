Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbYK1XEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbYK1XEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 18:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYK1XD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 18:03:58 -0500
Received: from smtp-out.google.com ([216.239.45.13]:63188 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYK1XD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 18:03:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=Wov8VIjaKu1bqEYjS3lkNA9kZLwVXemN2EOzI7gP9UFuRL3WndKaTDPgIPzG380YH
	8CzQzvOReik8CTFXESEbg==
Message-ID: <49307893.4030708@google.com>
Date: Fri, 28 Nov 2008 15:02:43 -0800
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
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com> <20081123091843.GK30453@elte.hu> <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com> <20081126123246.GB23649@wotan.suse.de> <492DAA24.8040100@google.com> <20081127085554.GD28285@wotan.suse.de> <492E6849.6090205@google.com> <20081127130817.GP28285@wotan.suse.de> <492EEF0C.9040607@google.com> <20081128093713.GB1818@wotan.suse.de>
In-Reply-To: <20081128093713.GB1818@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-GMailtapped-By: 172.24.198.77
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thu, Nov 27, 2008 at 11:03:40AM -0800, Mike Waychison wrote:
>> Nick Piggin wrote:
>>> On Thu, Nov 27, 2008 at 01:28:41AM -0800, Mike Waychison wrote:
>>>> Török however identified mmap taking on the order of several 
>>>> milliseconds due to this exact problem:
>>>>
>>>> http://lkml.org/lkml/2008/9/12/185
>>> Turns out to be a different problem.
>>>
>> What do you mean?
> 
> His is just contending on the write side. The retry patch doesn't help.
> 

I disagree.  How do you get 'write contention' from the following paragraph:

"Just to confirm that the problem is with pagefaults and mmap, I dropped
the mmap_sem in filemap_fault, and then
I got same performance in my testprogram for mmap and read. Of course
this is totally unsafe, because the mapping could change at any time."

It reads to me that the writers were held off by the readers sleeping in IO.

> 
>>>> We generally try to avoid such things, but sometimes it a) can't be 
>>>> easily avoided (third party libraries for instance) and b) when it hits 
>>>> us, it affects the overall health of the machine/cluster (the monitoring 
>>>> daemons get blocked, which isn't very healthy).
>>> Are you doing appropriate posix_fadvise to prefetch in the files before
>>> faulting, and madvise hints if appropriate?
>>>
>> Yes, we've been slowly rolling out fadvise hints out, though not to 
>> prefetch, and definitely not for faulting.  I don't see how issuing a 
>> prefetch right before we try to fault in a page is going to help 
>> matters.  The pages may appear in pagecache, but they won't be uptodate 
>> by the time we look at them anyway, so we're back to square one.
> 
> The whole point of a prefetch is to issue it sufficiently early so
> it makes a difference. Actually if you can tell quite well where the
> major faults will be, but don't know it sufficiently in advance to
> do very good prefetching, then perhaps we could add a new madvise hint
> to synchronously bring the page in (dropping the mmap_sem over the IO).
> 

Or we could just fix the faulting code to drop the mmap_sem for us?  I'm 
not sure a new madvise flag could help with the 'starvation hole' issue 
you brought up.
