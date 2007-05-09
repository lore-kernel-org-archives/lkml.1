Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbXEIOpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbXEIOpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXEIOpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:45:36 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:29573 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751220AbXEIOpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:45:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=JRnt2PBSGXwp6fklLCSqS3L0L89lx3K6iNzvS1Jzg8wJLd/JVyccMrgRhnc5ZDp6zeYoi+AfeQaLBvqV8YETon2PROTsoAq33lbbnvlrHIkJmOEf1TxQItbyqzXSRQw0rH04LgWP50d4Yh9N9jBz/6XsBWwQHHwxrp+sxgyFZHM=  ;
X-YMail-OSG: R5CYG2QVM1kPp.7W.ORAsvB0zw6u8ATZ0L6L6gsRDcLjCfdJFR1z06ktInu37p4b2lPUt_7Cqw--
Message-ID: <4641DE7D.6000902@yahoo.com.au>
Date: Thu, 10 May 2007 00:45:17 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrea Arcangeli <andrea@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.22 -mm merge plans -- vm bugfixes
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <4636FDD7.9080401@yahoo.com.au> <Pine.LNX.4.64.0705011931520.16502@blonde.wat.veritas.com> <4638009E.3070408@yahoo.com.au> <Pine.LNX.4.64.0705021418030.16517@blonde.wat.veritas.com> <4641BFCE.6090200@yahoo.com.au> <Pine.LNX.4.64.0705091522110.15345@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0705091522110.15345@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 9 May 2007, Nick Piggin wrote:
> 
>>Hugh Dickins wrote:
>>
>>>On Wed, 2 May 2007, Nick Piggin wrote:
>>
>>>>>But I'm pretty sure (to use your words!) regular truncate was not racy
>>>>>before: I believe Andrea's sequence count was handling that case fine,
>>>>>without a second unmap_mapping_range.
>>>>
>>>>OK, I think you're right. I _think_ it should also be OK with the
>>>>lock_page version as well: we should not be able to have any pages
>>>>after the first unmap_mapping_range call, because of the i_size
>>>>write. So if we have no pages, there is nothing to 'cow' from.
>>>
>>>I'd be delighted if you can remove those later unmap_mapping_ranges.
>>>As I recall, the important thing for the copy pages is to be holding
>>>the page lock (or whatever other serialization) on the copied page
>>>still while the copy page is inserted into pagetable: that looks
>>>to be so in your __do_fault.
>>
>>Hmm, on second thoughts, I think I was right the first time, and do
>>need the unmap after the pages are truncated. With the lock_page code,
>>after the first unmap, we can get new ptes mapping pages, and
>>subsequently they can be COWed and then the original pte zapped before
>>the truncate loop checks it.
> 
> 
> The filesystem (or page cache) allows pages beyond i_size to come
> in there?  That wasn't a problem before, was it?  But now it is?

The filesystem still doesn't, but if i_size is updated after the page
is returned, we can have a problem that was previously taken care of
with the truncate_count but now isn't.

>>However, I wonder if we can't test mapping_mapped before the spinlock,
>>which would make most truncates cheaper?
> 
> 
> Slightly cheaper, yes, though I doubt it'd be much in comparison with
> actually doing any work in unmap_mapping_range or truncate_inode_pages.

But if we're supposing the common case for truncate is unmapped mappings,
then the main cost there will be the locking, which I'm trying to avoid.
Hopefully with this patch, most truncate workloads would get faster, even
though truncate mapped files is going to be unavoidably slower.


> Suspect you'd need a barrier of some kind between the i_size_write and
> the mapping_mapped test?

The unmap_mapping_range that runs after the truncate_inode_pages should
run in the correct order, I believe.

>  But that's a change we could have made at
> any time if we'd bothered, it's not really the issue here.

I don't see how you could, because you need to increment truncate_count.

But I believe this is fixing the issue, even if it does so in a peripheral
manner, because it avoids the added cost for unmapped files.

-- 
SUSE Labs, Novell Inc.
