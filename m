Return-Path: <linux-kernel-owner+w=401wt.eu-S1030202AbXAXFbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202AbXAXFbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 00:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030210AbXAXFbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 00:31:15 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:56826 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030202AbXAXFbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 00:31:14 -0500
Message-ID: <45B6EEFC.5050402@linux.vnet.ibm.com>
Date: Wed, 24 Jan 2007 11:00:36 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Aubrey Li <aubreylee@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [RPC][PATCH 2.6.20-rc5] limit total vfs page cache
References: <6d6a94c50701171923g48c8652ayd281a10d1cb5dd95@mail.gmail.com> <45B0D967.8090607@linux.vnet.ibm.com> <6d6a94c50701190740v6da25151kb9ddcf358ab2957@mail.gmail.com>
In-Reply-To: <6d6a94c50701190740v6da25151kb9ddcf358ab2957@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Aubrey Li wrote:
> On 1/19/07, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
>> Hi Aubrey,
>>
>> I used your patch on my PPC64 box and I do not get expected
>> behavior.  As you had requested, I am attaching zoneinfo and meminfo
>> dumps:
>>
>> Please let me know if you need any further data to help me out with
>> the test/experiment.
>>
> 
> Although I have no PPC64 box in hand, I think the logic should be the same.
> get_page_from_freelist() is called 5 times in __alloc_pages().
> 
> 1) alloc_flags = ALLOC_WMARK_LOW | ALLOC_PAGECACHE;
> 2) alloc_flags = ALLOC_WMARK_MIN | ALLOC_PAGECACHE;
> We should have the same result on the first two times get_page_from_freelist().
> 
> 3) if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
> 			&& !in_interrupt())
>    alloc_flags = ALLOC_NO_WATERMARKS
> The case on my platform will never enter this branch. If the branch
> occurs on your side,
> The limit will be omitted. Because NO watermark, zone_watermark_ok()
> will not be checked. memory will be allocated directly.
> 
> 4)if (likely(did_some_progress)) {
>    alloc_flags should include ALLOC_PAGECACHE.
> So we should have the same result on this call.
> 
> 5)	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
>    alloc_flags = ALLOC_WMARK_HIGH, without ALLOC_PAGECACHE
> 
> This branch will not hit on my case. You may need to check it.
> 
> If 3) or 5) occurs on your platform, I think you can easily fix it.
> Please confirm it and let me know the result.


None of the above condition was the problem in my PPC64 box.  I
added __GFP_PAGECACHE flag in pagecache_alloc_cold() and
grab_cache_page_nowait() routines and the reclaim seemed to work.

--- linux-2.6.20-rc5.orig/include/linux/pagemap.h
+++ linux-2.6.20-rc5/include/linux/pagemap.h
@@ -62,12 +62,12 @@ static inline struct page *__page_cache_

 static inline struct page *page_cache_alloc(struct address_space *x)
 {
-	return __page_cache_alloc(mapping_gfp_mask(x));
+	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_PAGECACHE);
 }

 static inline struct page *page_cache_alloc_cold(struct
address_space *x)
 {
-	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD);
+	return
__page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD|__GFP_PAGECACHE);
 }

 typedef int filler_t(void *, struct page *);

[snip]

--- linux-2.6.20-rc5.orig/mm/filemap.c
+++ linux-2.6.20-rc5/mm/filemap.c
@@ -823,7 +823,7 @@ grab_cache_page_nowait(struct address_sp
 		page_cache_release(page);
 		return NULL;
 	}
-	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~__GFP_FS);
+	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~__GFP_FS |
__GFP_PAGECACHE);
 	if (page && add_to_page_cache_lru(page, mapping, index, GFP_KERNEL)) {
 		page_cache_release(page);
 		page = NULL;


pagecache_alloc_cold() is used in the read-ahead path which was
being called in my case of large file operations.

--Vaidy

