Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbZCBXCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbZCBXCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbZCBXBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:01:46 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:48660 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbZCBXBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:01:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E6MbNedCOW7/8hABGPYgkYlyWLedxdMo77O1hILWe/ekVZrl42Y5myewJLSYB4/P6X
         VEw9oaRPuZ5hJm0Q4BJNey2j5ZqrorKyMOIuGf863G1cOkpyUNrzbdOIX5B3zALsj5Ag
         pLJ7qRwEL20M+xuruLI675j81O1zQj+F80L/0=
MIME-Version: 1.0
In-Reply-To: <20090302142757.1cc014aa.akpm@linux-foundation.org>
References: <20090302183148.a4dfcc22.minchan.kim@barrios-desktop>
	 <20090302142757.1cc014aa.akpm@linux-foundation.org>
Date: Tue, 3 Mar 2009 08:01:41 +0900
Message-ID: <28c262360903021501q7cf29c2fu96d831ac5bad08f@mail.gmail.com>
Subject: Re: [PATCH] mmtom : add VM_BUG_ON in __get_free_pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 7:27 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 2 Mar 2009 18:31:48 +0900
> MinChan Kim <minchan.kim@gmail.com> wrote:
>
>>
>> The __get_free_pages is used in many place.
>> Also, driver developers can use it freely due to export function.
>> Some developers might use it to allocate high pages by mistake.
>>
>> The __get_free_pages can allocate high page using alloc_pages,
>> but it can't return linear address for high page.
>>
>> Even worse, in this csse, caller can't free page which are there in high zone.
>> So, It would be better to add VM_BUG_ON.
>>
>> It's based on mmtom 2009-02-27-13-54.
>>
>> Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/page_alloc.c |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 8294107..381056b 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1681,6 +1681,13 @@ EXPORT_SYMBOL(__alloc_pages_internal);
>>  unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
>>  {
>>       struct page * page;
>> +
>> +     /*
>> +      * __get_free_pages() returns a 32-bit address, which cannot represent
>> +      * a highmem page
>> +      */
>> +     VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
>> +
>>       page = alloc_pages(gfp_mask, order);
>>       if (!page)
>>               return 0;
>
> If someone calls __get_free_pages(__GFP_HIGHMEM) then page_address()
> will reliably return NULL and the caller's code will oops.

If someone fail to allocate highmem, he might retry to allocate page
in normal or dma. then he will get the page.
but, more important thing is that In first try, page allocator
succeeded to allocate page in highmem and just failed to translate
from page to linear address by page_address(page).

So, the caller don't have any way to free high page.
How do we solve this problem ?


> Yes, there's a decent (and increasing) risk that the developer won't be
> testing the code on a highmem machine, but there are enough highmem
> machines out there that the bug should be discovered pretty quickly.
> So I'm not sure that this test is worth the additional overhead to a
> fairly frequently called function?
>

I agree.

If you have a concern about hotpath,  how about adding annotation to
prevent wrong usage ?
If you agree with my suggestion, I will resend this patch with more
detail changelog.

 Signed-off-by: MinChan Kim <minchan.kim@gmail.com>

---
 mm/page_alloc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 381056b..b168c5f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1677,6 +1677,7 @@ EXPORT_SYMBOL(__alloc_pages_internal);

 /*
  * Common helper functions.
+ * This function must not be used with __GFP_HIGHMEM.
  */
 unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
 {
-- 
1.5.4.3




-- 
Kinds regards,
MinChan Kim
