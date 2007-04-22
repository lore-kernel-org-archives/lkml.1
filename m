Return-Path: <linux-kernel-owner+w=401wt.eu-S964862AbXDVGcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbXDVGcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 02:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964934AbXDVGcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 02:32:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964862AbXDVGcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 02:32:08 -0400
Message-ID: <462B0156.9020407@redhat.com>
Date: Sun, 22 Apr 2007 02:31:50 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com> <462ACA40.8070407@yahoo.com.au>
In-Reply-To: <462ACA40.8070407@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Rik van Riel wrote:
>> Andrew Morton wrote:
>>
>>> On Fri, 20 Apr 2007 17:38:06 -0400
>>> Rik van Riel <riel@redhat.com> wrote:
>>>
>>>> Andrew Morton wrote:
>>>>
>>>>> I've also merged Nick's "mm: madvise avoid exclusive mmap_sem".
>>>>>
>>>>> - Nick's patch also will help this problem.  It could be that your 
>>>>> patch
>>>>>   no longer offers a 2x speedup when combined with Nick's patch.
>>>>>
>>>>>   It could well be that the combination of the two is even better, 
>>>>> but it
>>>>>   would be nice to firm that up a bit.  
>>>>
>>>> I'll test that.
>>>
>>>
>>> Thanks.
>>
>>
>> Well, good news.
>>
>> It turns out that Nick's patch does not improve peak
>> performance much, but it does prevent the decline when
>> running with 16 threads on my quad core CPU!
>>
>> We _definately_ want both patches, there's a huge benefit
>> in having them both.
>>
>> Here are the transactions/seconds for each combination:
>>
>>    vanilla   new glibc  madv_free kernel   madv_free + mmap_sem
>> threads
>>
>> 1     610         609             596                545
>> 2    1032        1136            1196               1200
>> 4    1070        1128            2014               2024
>> 8    1000        1088            1665               2087
>> 16    779        1073            1310               1999
> 
> 
> Is "new glibc" meaning MADV_DONTNEED + kernel with mmap_sem patch?

No, that's just the glibc change, with a vanilla kernel.

The third column is glibc change + mmap_sem patch.

The fourth column has your patch in it, too.

> The strange thing with your madv_free kernel is that it doesn't
> help single-threaded performance at all. So that work to avoid
> zeroing the new page is not a win at all there (maybe due to the
> cache effects I was worried about?).

Well, your patch causes the performance to drop from
596 transactions/second to 545.  Your patch is the only
difference between the third and the fourth column.

> However MADV_FREE does improve scalability, which is interesting.
> The most likely reason I can see why that may be the case is that
> it avoids mmap_sem when faulting pages back in (I doubt it is due
> to avoiding the page allocator, but maybe?).
> 
> So where is the down_write coming from in this workload, I wonder?
> Heap management? What syscalls?

I wonder if the increased parallelism simply caused
more cache line bouncing, with bounces happening in
some inner loop instead of an outer loop.

Btw, it is quite possible that the MySQL sysbench
thing gives different results on your system.  It
would be good to know what it does on a real SMP
system, vs. a single quad-core chip :)

Other architectures would be interesting to know,
too.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
