Return-Path: <linux-kernel-owner+w=401wt.eu-S965287AbXDWARI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287AbXDWARI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 20:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965656AbXDWARI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 20:17:08 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:47429 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965287AbXDWARH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 20:17:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=sKkVQDp6SLS9kbQWi3tz4kpYEMXh50bL/IQocBGUjEkIhuDFCsT47l/nRwWi0vkcm6Ch6oiUuPPp6xYH+bB+/cxeuZCZsm51tf5IukORCoenMH5+qWBCY5zoLjmdrcmZW1sJ9Upx5ifOgymJcCZ5ANEcwV60ymH4qiShj4dR8gc=  ;
X-YMail-OSG: 2df_SA0VM1nlF2ju13FSuF.Qb5zTorn1rpK_7JlI_ml50KlzBGz_JsbRkGxirkdWCo6P8Smfcw--
Message-ID: <462BFAF3.4040509@yahoo.com.au>
Date: Mon, 23 Apr 2007 10:16:51 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com> <462ACA40.8070407@yahoo.com.au> <462B0156.9020407@redhat.com>
In-Reply-To: <462B0156.9020407@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Nick Piggin wrote:
> 
>> Rik van Riel wrote:

>>> Here are the transactions/seconds for each combination:
>>>
>>>    vanilla   new glibc  madv_free kernel   madv_free + mmap_sem
>>> threads
>>>
>>> 1     610         609             596                545
>>> 2    1032        1136            1196               1200
>>> 4    1070        1128            2014               2024
>>> 8    1000        1088            1665               2087
>>> 16    779        1073            1310               1999
>>
>>
>>
>> Is "new glibc" meaning MADV_DONTNEED + kernel with mmap_sem patch?
> 
> 
> No, that's just the glibc change, with a vanilla kernel.

OK. That would be interesting to see with the mmap_sem change,
because that should increase scalability.


> The third column is glibc change + mmap_sem patch.
> 
> The fourth column has your patch in it, too.
> 
>> The strange thing with your madv_free kernel is that it doesn't
>> help single-threaded performance at all. So that work to avoid
>> zeroing the new page is not a win at all there (maybe due to the
>> cache effects I was worried about?).
> 
> 
> Well, your patch causes the performance to drop from
> 596 transactions/second to 545.  Your patch is the only
> difference between the third and the fourth column.

Yeah. That's funny, because it means either there is some
contention on the mmap_sem (or ptl) at 1 thread, or that my
patch alters the uncontended performance.


>> However MADV_FREE does improve scalability, which is interesting.
>> The most likely reason I can see why that may be the case is that
>> it avoids mmap_sem when faulting pages back in (I doubt it is due
>> to avoiding the page allocator, but maybe?).
>>
>> So where is the down_write coming from in this workload, I wonder?
>> Heap management? What syscalls?
> 
> 
> I wonder if the increased parallelism simply caused
> more cache line bouncing, with bounces happening in
> some inner loop instead of an outer loop.
> 
> Btw, it is quite possible that the MySQL sysbench
> thing gives different results on your system.  It
> would be good to know what it does on a real SMP
> system, vs. a single quad-core chip :)
> 
> Other architectures would be interesting to know,
> too.

I don't see why parallelism should come into it at 1 thread, unless
MySQL is parallelising individual transactions. Anyway, I'll try to do
some more digging.

-- 
SUSE Labs, Novell Inc.
