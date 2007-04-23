Return-Path: <linux-kernel-owner+w=401wt.eu-S1030658AbXDWDoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030658AbXDWDoi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 23:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030653AbXDWDoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 23:44:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030622AbXDWDog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 23:44:36 -0400
Message-ID: <462C2DC7.5070709@redhat.com>
Date: Sun, 22 Apr 2007 23:53:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>,
       jakub@redhat.com, drepper@redhat.com
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com> <462ACA40.8070407@yahoo.com.au> <462B0156.9020407@redhat.com> <462BFAF3.4040509@yahoo.com.au>
In-Reply-To: <462BFAF3.4040509@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Rik van Riel wrote:
>> Nick Piggin wrote:
>>
>>> Rik van Riel wrote:
> 
>>>> Here are the transactions/seconds for each combination:

I've added a 5th column, with just your mmap_sem patch and
without my madv_free patch.  It is run with the glibc patch,
which should make it fall back to MADV_DONTNEED after the
first MADV_FREE call fails.

>>>>    vanilla   new glibc  madv_free kernel   madv_free + mmap_sem  mmap_sem
>>>> threads
>>>>
>>>> 1     610         609             596                545         534
>>>> 2    1032        1136            1196               1200        1180
>>>> 4    1070        1128            2014               2024        2027
>>>> 8    1000        1088            1665               2087        2089
>>>> 16    779        1073            1310               1999        2012

Not doing the mprotect calls is the big one I guess, especially
the fact that we don't need to take the mmap_sem for writing.

With both our patches, single and two thread performance with
MySQL sysbench is somewhat better than with just your patch,
4 and 8 thread performance are basically the same and just
your patch gives a slight benefit with 16 threads.

I guess I should benchmark up to 64 or 128 threads tomorrow,
to see if this is just luck or if the cache benefit of doing
the page faults and reusing hot pages is faster than not
having page faults at all.

I should run some benchmarks on other systems, too.  Some of
these results could be an artifact of my quad core CPU.  The
results could be very different on other systems...

> Yeah. That's funny, because it means either there is some
> contention on the mmap_sem (or ptl) at 1 thread, or that my
> patch alters the uncontended performance.

Maybe MySQL has various different threads to do
different tasks.  Something to look into...
