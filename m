Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbXDVCg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbXDVCg7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 22:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXDVCg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 22:36:59 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:33685 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753989AbXDVCg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 22:36:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=vRUCtym8LR3Z8d9SgqY4SDYU30ZsI0p36A/5uPlcjFIX9JSDnc73bLdjG3tbgbPTMcXPqOI+fkugTkNN31uFx8ElsC647LvsoDyjzi2tqSTc96synXUu7ZntipOAyg1E9f0Cj7/8oV+GKCtFMT8UJ9E2H3EJRAudxREGicoj60E=  ;
X-YMail-OSG: L9jSUDEVM1lP4QyqqYnKJinPllcAv5P.rVk.9IJ0FDemEfl7q3cKZ87SVYMJETxypytHwbQhfg--
Message-ID: <462ACA40.8070407@yahoo.com.au>
Date: Sun, 22 Apr 2007 12:36:48 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com>
In-Reply-To: <4629524C.5040302@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Andrew Morton wrote:
> 
>> On Fri, 20 Apr 2007 17:38:06 -0400
>> Rik van Riel <riel@redhat.com> wrote:
>>
>>> Andrew Morton wrote:
>>>
>>>> I've also merged Nick's "mm: madvise avoid exclusive mmap_sem".
>>>>
>>>> - Nick's patch also will help this problem.  It could be that your 
>>>> patch
>>>>   no longer offers a 2x speedup when combined with Nick's patch.
>>>>
>>>>   It could well be that the combination of the two is even better, 
>>>> but it
>>>>   would be nice to firm that up a bit.  
>>>
>>> I'll test that.
>>
>>
>> Thanks.
> 
> 
> Well, good news.
> 
> It turns out that Nick's patch does not improve peak
> performance much, but it does prevent the decline when
> running with 16 threads on my quad core CPU!
> 
> We _definately_ want both patches, there's a huge benefit
> in having them both.
> 
> Here are the transactions/seconds for each combination:
> 
>    vanilla   new glibc  madv_free kernel   madv_free + mmap_sem
> threads
> 
> 1     610         609             596                545
> 2    1032        1136            1196               1200
> 4    1070        1128            2014               2024
> 8    1000        1088            1665               2087
> 16    779        1073            1310               1999


Is "new glibc" meaning MADV_DONTNEED + kernel with mmap_sem patch?

The strange thing with your madv_free kernel is that it doesn't
help single-threaded performance at all. So that work to avoid
zeroing the new page is not a win at all there (maybe due to the
cache effects I was worried about?).

However MADV_FREE does improve scalability, which is interesting.
The most likely reason I can see why that may be the case is that
it avoids mmap_sem when faulting pages back in (I doubt it is due
to avoiding the page allocator, but maybe?).

So where is the down_write coming from in this workload, I wonder?
Heap management? What syscalls?

x86_64's rwsems are crap under heavy parallelism (even read-only),
as I fixed in my recent generic rwsems patch. I don't expect MySQL
to be such a mmap_sem microbenchmark, but I wonder how much this
would help?

What if we ran the private futexes patch to further cut down
mmap_sem contention?

-- 
SUSE Labs, Novell Inc.
