Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbZCCMFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbZCCMFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 07:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZCCMFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 07:05:25 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:35185 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZCCMFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 07:05:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xay2lNOrE9OL4B0qMRwR5l5bUYTK75wVad6ROgjC757I0WnKaKxmMmOykkjsDwqYcm
         vQNQvfqF2h/ujfr0Fjnib5M9DyB0l3IsjwyD8igFKpo49PvhlUL7+qbZNnq8If2B+X6l
         VJ0AC/l4IhAXox66+1iScIuedkZlER4AcRKQo=
MIME-Version: 1.0
In-Reply-To: <20090302231628.GA7228@cmpxchg.org>
References: <20090302183148.a4dfcc22.minchan.kim@barrios-desktop>
	 <20090302142757.1cc014aa.akpm@linux-foundation.org>
	 <20090302231628.GA7228@cmpxchg.org>
Date: Tue, 3 Mar 2009 21:05:22 +0900
Message-ID: <28c262360903030405uf54660axebce0ee19e27f7c@mail.gmail.com>
Subject: Re: [PATCH] mmtom : add VM_BUG_ON in __get_free_pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Hannes.
Thanks for careful review.

On Tue, Mar 3, 2009 at 8:16 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Mon, Mar 02, 2009 at 02:27:57PM -0800, Andrew Morton wrote:
>> On Mon, 2 Mar 2009 18:31:48 +0900
>> MinChan Kim <minchan.kim@gmail.com> wrote:
>>
>> >
>> > The __get_free_pages is used in many place.
>> > Also, driver developers can use it freely due to export function.
>> > Some developers might use it to allocate high pages by mistake.
>> >
>> > The __get_free_pages can allocate high page using alloc_pages,
>> > but it can't return linear address for high page.
>> >
>> > Even worse, in this csse, caller can't free page which are there in high zone.
>> > So, It would be better to add VM_BUG_ON.
>> >
>> > It's based on mmtom 2009-02-27-13-54.
>> >
>> > Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
>> > ---
>> >  mm/page_alloc.c |    7 +++++++
>> >  1 files changed, 7 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> > index 8294107..381056b 100644
>> > --- a/mm/page_alloc.c
>> > +++ b/mm/page_alloc.c
>> > @@ -1681,6 +1681,13 @@ EXPORT_SYMBOL(__alloc_pages_internal);
>> >  unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
>> >  {
>> >     struct page * page;
>> > +
>> > +   /*
>> > +    * __get_free_pages() returns a 32-bit address, which cannot represent
>> > +    * a highmem page
>> > +    */
>> > +   VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
>> > +
>> >     page = alloc_pages(gfp_mask, order);
>> >     if (!page)
>> >             return 0;
>>
>> If someone calls __get_free_pages(__GFP_HIGHMEM) then page_address()
>> will reliably return NULL and the caller's code will oops.
>
> It will allocate a page, fail to translate it to a virtual address,
> return 0 and the caller will think allocation failed because it checks
> for the return value.
>
> But the highmem page is still allocated and now leaked, isn't it?

That was my point.

>> Yes, there's a decent (and increasing) risk that the developer won't be
>> testing the code on a highmem machine, but there are enough highmem
>> machines out there that the bug should be discovered pretty quickly.
>
> Another thing is that a device driver developer does not necessarily
> has CONFIG_DEBUG_VM set.  Can we expect him to?

Hmm. I agree.
Even, Many embedded guys don't upload their driver source to mainline
for revewing and testing.
so, others who have high mem machine can't review and test driver code.
Of couse, It depends on their willing but it would be better to care them.

>> So I'm not sure that this test is worth the additional overhead to a
>> fairly frequently called function?
>
> Well, it's only done conditionally if you want to debug the thing
> anyway.  But as mentioned above, maybe this isn't the right condition.
>
I added VM_DEUBG_ON as referencing get_zeroed_page without serious considering.
I agree with your opinion.
so, we have to change __get_free_page and get_zeroed_page.
Do you mean BUG_ON instead of VM_BUG_ON ?

Andrew, How about that ?
you think it is rather big overhead even if it's vm debug mode ?

-- 
Kinds regards,
Minchan Kim
