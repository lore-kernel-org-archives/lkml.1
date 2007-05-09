Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbXEIMei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbXEIMei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbXEIMeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:34:31 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:40084 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750833AbXEIMea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:34:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=JD0Mapy4EcyJyw8UfH4wAd2SElSJpqCMeEdy6WEGmgUdbBPE4nHwYdWBvdeI1QTXLOaRSTQLuJWU5EnDYlVhD2jlPSWrC+615tQNS0Rrwpipxyax9hD+Bpj2f8N3FrulibJkBn3v24/IVu/wOu0hP/wnSoIlsTzEeTL6VkqyXCs=  ;
X-YMail-OSG: GYwbtZEVM1nsnp7h2v868PwtUS_DtHyh9dUhg3duyTnS5g6iVKGfMLOGN5nIyWb3dQtS3vifIg--
Message-ID: <4641BFCE.6090200@yahoo.com.au>
Date: Wed, 09 May 2007 22:34:22 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrea Arcangeli <andrea@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.22 -mm merge plans -- vm bugfixes
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <4636FDD7.9080401@yahoo.com.au> <Pine.LNX.4.64.0705011931520.16502@blonde.wat.veritas.com> <4638009E.3070408@yahoo.com.au> <Pine.LNX.4.64.0705021418030.16517@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0705021418030.16517@blonde.wat.veritas.com>
Content-Type: multipart/mixed;
 boundary="------------060803040002020005060607"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060803040002020005060607
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hugh Dickins wrote:
> On Wed, 2 May 2007, Nick Piggin wrote:

>>>But I'm pretty sure (to use your words!) regular truncate was not racy
>>>before: I believe Andrea's sequence count was handling that case fine,
>>>without a second unmap_mapping_range.
>>
>>OK, I think you're right. I _think_ it should also be OK with the
>>lock_page version as well: we should not be able to have any pages
>>after the first unmap_mapping_range call, because of the i_size
>>write. So if we have no pages, there is nothing to 'cow' from.
> 
> 
> I'd be delighted if you can remove those later unmap_mapping_ranges.
> As I recall, the important thing for the copy pages is to be holding
> the page lock (or whatever other serialization) on the copied page
> still while the copy page is inserted into pagetable: that looks
> to be so in your __do_fault.

Hmm, on second thoughts, I think I was right the first time, and do
need the unmap after the pages are truncated. With the lock_page code,
after the first unmap, we can get new ptes mapping pages, and
subsequently they can be COWed and then the original pte zapped before
the truncate loop checks it.

However, I wonder if we can't test mapping_mapped before the spinlock,
which would make most truncates cheaper?

-- 
SUSE Labs, Novell Inc.

--------------060803040002020005060607
Content-Type: text/plain;
 name="mm-truncate-avoid-rmap-locks"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mm-truncate-avoid-rmap-locks"

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2007-04-24 15:02:51.000000000 +1000
+++ linux-2.6/mm/filemap.c	2007-05-09 17:30:47.000000000 +1000
@@ -2579,8 +2579,7 @@
 	if (rw == WRITE) {
 		write_len = iov_length(iov, nr_segs);
 		end = (offset + write_len - 1) >> PAGE_CACHE_SHIFT;
-	       	if (mapping_mapped(mapping))
-			unmap_mapping_range(mapping, offset, write_len, 0);
+		unmap_mapping_range(mapping, offset, write_len, 0);
 	}
 
 	retval = filemap_write_and_wait(mapping);
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2007-05-09 17:25:28.000000000 +1000
+++ linux-2.6/mm/memory.c	2007-05-09 17:30:22.000000000 +1000
@@ -1956,6 +1956,9 @@
 	pgoff_t hba = holebegin >> PAGE_SHIFT;
 	pgoff_t hlen = (holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
+	if (!mapping_mapped(mapping))
+		return;
+
 	/* Check for overflow. */
 	if (sizeof(holelen) > sizeof(hlen)) {
 		long long holeend =

--------------060803040002020005060607--
