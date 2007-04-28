Return-Path: <linux-kernel-owner+w=401wt.eu-S1030869AbXD1BoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030869AbXD1BoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030871AbXD1BoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:44:14 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:35252 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030869AbXD1BoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:44:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=okr+sD5cq9oy5DpliSxGEWbiFSK1FfpTKTpKB9MipaGvwxz7zKVJJsIKIX76ZJKIFiNCnvy90fBSAk+WjjyoV+PfHUv8dpCkIYtrt0WAyJqJMZTZoeAIYgHxjJiq36FPBVzGBeuyaBTxn7wyBrfhZDwzIvzh33vK1haiXq+6vxI=  ;
X-YMail-OSG: oKXhVh4VM1mjWGHSAS91rNGHObS4WY_xy.fpw5zx3wodL0vv6XCq7SxMF833P.AbB9ied9_Whw--
Message-ID: <4632A6DF.7080301@yahoo.com.au>
Date: Sat, 28 Apr 2007 11:43:59 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Chinner <dgc@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070426190438.3a856220.akpm@linux-foundation.org>	<20070427022731.GF65285596@melbourne.sgi.com>	<20070426195357.597ffd7e.akpm@linux-foundation.org>	<20070427042046.GI65285596@melbourne.sgi.com>	<20070426221528.655d79cb.akpm@linux-foundation.org>	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>	<20070426235542.bad7035a.akpm@linux-foundation.org>	<Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>	<20070427002640.22a71d06.akpm@linux-foundation.org>	<20070427163620.GI32602149@melbourne.sgi.com>	<20070427173432.GJ32602149@melbourne.sgi.com> <20070427121108.9ee05710.akpm@linux-foundation.org>
In-Reply-To: <20070427121108.9ee05710.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 28 Apr 2007 03:34:32 +1000 David Chinner <dgc@sgi.com> wrote:
> 
> 
>>Some more information - stripe unit on the dm raid0 is 512k.
>>I have not attempted to increase I/O sizes at all yet - these test are
>>just demonstrating efficiency improvements in the filesystem.
>>
>>These numbers for 32GB files.
>>
>>                    READ            WRITE
>>disks  blksz     tput   sys       tput    sys
>>-----  -----    -----   ----      -----  ----
>>  1     4k        89     18s       57     44s
>>  1    16k        46     13s       67     18s
>>  1    64k        75     12s       68     12s
>>  2     4k       179     20s      114     43s
>>  2    16k        55     13s      132     18s
>>  2    64k       126     12s      126     12s
>>  4     4k       350     20s      214     43s
>>  4    16k       350     14s      264     19s
>>  4    64k       176     11s      266     12s
>>  8     4k       415     21s      446     41s
>>  8    16k       655     13s      518     19s
>>  8    64k       664     12s      552     12s
>> 12     4k       413     20s      633     33s
>> 12    16k       736     14s      741     19s
>> 12    64k       836     12s      743     12s
>>
>>Throughput in MB/s.
>>
>>
>>Consistent improvement across the write results, first time
>>I've hit the limits of the PCI-X bus with a single buffered
>>I/O thread doing either reads or writes.
> 
> 
> 1-disk and 2-disk read throughput fell by an improbable amount, which makes
> me cautious about the other numbers.
> 
> Your annotation says "blocksize".  Are you really varying the fs blocksize
> here, or did you mean "pagesize"?
> 
> What worries me here is that we have inefficient code, and increasing the
> pagesize amortises that inefficiency without curing it.
> 
> If so, it would be better to fix the inefficiencies, so that 4k pagesize
> will also benefit.
> 
> For example, see __do_page_cache_readahead().  It does a read_lock() and a
> page allocation and a radix-tree lookup for each page.  We can vastly
> improve that.
> 
> Step 1:
> 
> - do a read-lock
> 
> - do a radix-tree walk to work out how many pages are missing
> 
> - read-unlock
> 
> - allocate that many pages
> 
> - read_lock()
> 
> - populate all the pages.
> 
> - read_unlock
> 
> - if any pages are left over, free them
> 
> - if we ended up not having enough pages, redo the whole thing.
> 
> that will reduce the number of read_lock()s, read_unlock()s and radix-tree
> descents by a factor of 32 or so in this testcase.  That's a lot, and it's
> something we (Nick ;)) should have done ages ago.

We can do pretty well with the lockless radix tree (that is already upstream)
there. I split that stuff out of my most recent lockless pagecache patchset,
because it doesn't require the "scary" speculative refcount stuff of the
lockless pagecache proper. Subject: [patch 5/9] mm: lockless probe.

So that is something we could merge pretty soon.

The other thing is that we can batch up pagecache page insertions for bulk
writes as well (that is. write(2) with buffer size > page size). I should
have a patch somewhere for that as well if anyone interested.

-- 
SUSE Labs, Novell Inc.
