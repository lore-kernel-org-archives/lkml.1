Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbZHRLAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbZHRLAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbZHRLAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:00:48 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:52478 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711AbZHRLAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uxKaPXV7AvVaMCWHzAbk7/jK/Tf0Hm4kziFH32+0PgCX+6r/BSCZVzyX/mK17wHbCX
         kUJuk+anZpVjipmaf+bvtKYm9JJMFvvUPJmn3Vcq8hYnYJEQZWEawKDaQzFSVeL1zrUm
         mEJTjBOcK4ff5fpwbe5vTiSQw42bMeC1eqKSQ=
MIME-Version: 1.0
In-Reply-To: <20090818100031.GC16298@localhost>
References: <20090806210955.GA14201@c2.user-mode-linux.org>
	 <4A87829C.4090908@redhat.com> <20090816051502.GB13740@localhost>
	 <20090816112910.GA3208@localhost>
	 <28c262360908170733q4bc5ddb8ob2fc976b6a468d6e@mail.gmail.com>
	 <20090818023438.GB7958@localhost>
	 <20090818131734.3d5bceb2.minchan.kim@barrios-desktop>
	 <20090818093119.GA12679@localhost>
	 <20090818185247.a4516389.minchan.kim@barrios-desktop>
	 <20090818100031.GC16298@localhost>
Date: Tue, 18 Aug 2009 20:00:48 +0900
Message-ID: <28c262360908180400q361ea322o8959fd5ea5ae3217@mail.gmail.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>, Jeff Dike <jdike@addtoit.com>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 7:00 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> On Tue, Aug 18, 2009 at 05:52:47PM +0800, Minchan Kim wrote:
>> On Tue, 18 Aug 2009 17:31:19 +0800
>> Wu Fengguang <fengguang.wu@intel.com> wrote:
>>
>> > On Tue, Aug 18, 2009 at 12:17:34PM +0800, Minchan Kim wrote:
>> > > On Tue, 18 Aug 2009 10:34:38 +0800
>> > > Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > >
>> > > > Minchan,
>> > > >
>> > > > On Mon, Aug 17, 2009 at 10:33:54PM +0800, Minchan Kim wrote:
>> > > > > On Sun, Aug 16, 2009 at 8:29 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
>> > > > > > On Sun, Aug 16, 2009 at 01:15:02PM +0800, Wu Fengguang wrote:
>> > > > > >> On Sun, Aug 16, 2009 at 11:53:00AM +0800, Rik van Riel wrote:
>> > > > > >> > Wu Fengguang wrote:
>> > > > > >> > > On Fri, Aug 07, 2009 at 05:09:55AM +0800, Jeff Dike wrote:
>> > > > > >> > >> Side question -
>> > > > > >> > >>  Is there a good reason for this to be in shrink_active_list()
>> > > > > >> > >> as opposed to __isolate_lru_page?
>> > > > > >> > >>
>> > > > > >> > >>          if (unlikely(!page_evictable(page, NULL))) {
>> > > > > >> > >>                  putback_lru_page(page);
>> > > > > >> > >>                  continue;
>> > > > > >> > >>          }
>> > > > > >> > >>
>> > > > > >> > >> Maybe we want to minimize the amount of code under the lru lock or
>> > > > > >> > >> avoid duplicate logic in the isolate_page functions.
>> > > > > >> > >
>> > > > > >> > > I guess the quick test means to avoid the expensive page_referenced()
>> > > > > >> > > call that follows it. But that should be mostly one shot cost - the
>> > > > > >> > > unevictable pages are unlikely to cycle in active/inactive list again
>> > > > > >> > > and again.
>> > > > > >> >
>> > > > > >> > Please read what putback_lru_page does.
>> > > > > >> >
>> > > > > >> > It moves the page onto the unevictable list, so that
>> > > > > >> > it will not end up in this scan again.
>> > > > > >>
>> > > > > >> Yes it does. I said 'mostly' because there is a small hole that an
>> > > > > >> unevictable page may be scanned but still not moved to unevictable
>> > > > > >> list: when a page is mapped in two places, the first pte has the
>> > > > > >> referenced bit set, the _second_ VMA has VM_LOCKED bit set, then
>> > > > > >> page_referenced() will return 1 and shrink_page_list() will move it
>> > > > > >> into active list instead of unevictable list. Shall we fix this rare
>> > > > > >> case?
>> > > > >
>> > > > > I think it's not a big deal.
>> > > >
>> > > > Maybe, otherwise I should bring up this issue long time before :)
>> > > >
>> > > > > As you mentioned, it's rare case so there would be few pages in active
>> > > > > list instead of unevictable list.
>> > > >
>> > > > Yes.
>> > > >
>> > > > > When next time to scan comes, we can try to move the pages into
>> > > > > unevictable list, again.
>> > > >
>> > > > Will PG_mlocked be set by then? Otherwise the situation is not likely
>> > > > to change and the VM_LOCKED pages may circulate in active/inactive
>> > > > list for countless times.
>> > >
>> > > PG_mlocked is not important in that case.
>> > > Important thing is VM_LOCKED vma.
>> > > I think below annotaion can help you to understand my point. :)
>> >
>> > Hmm, it looks like pages under VM_LOCKED vma is guaranteed to have
>> > PG_mlocked set, and so will be caught by page_evictable(). Is it?
>>
>> No. I am sorry for making my point not clear.
>> I meant following as.
>> When the next time to scan,
>>
>> shrink_page_list
>  ->
>                referenced = page_referenced(page, 1,
>                                                sc->mem_cgroup, &vm_flags);
>                /* In active use or really unfreeable?  Activate it. */
>                if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
>                                        referenced && page_mapping_inuse(page))
>                        goto activate_locked;
>
>> -> try_to_unmap
>     ~~~~~~~~~~~~ this line won't be reached if page is found to be
>     referenced in the above lines?

Indeed! In fact, I was worry about that.
It looks after live lock problem.
But I think  it's very small race window so  there isn't any report until now.
Let's Cced Lee.

If we have to fix it, how about this ?
This version  has small overhead than yours since
there is less shrink_page_list call than page_referenced.

diff --git a/mm/rmap.c b/mm/rmap.c
index ed63894..283266c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -358,6 +358,7 @@ static int page_referenced_one(struct page *page,
         */
        if (vma->vm_flags & VM_LOCKED) {
                *mapcount = 1;  /* break early from loop */
+               *vm_flags |= VM_LOCKED;
                goto out_unmap;
        }

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d224b28..d156e1d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -632,7 +632,8 @@ static unsigned long shrink_page_list(struct
list_head *page_list,
                                                sc->mem_cgroup, &vm_flags);
                /* In active use or really unfreeable?  Activate it. */
                if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
-                                       referenced && page_mapping_inuse(page))
+                                       referenced && page_mapping_inuse(page)
+                                       && !(vm_flags & VM_LOCKED))
                        goto activate_locked;




>
> Thanks,
> Fengguang
>
>>       -> try_to_unmap_xxx
>>               -> if (vma->vm_flags & VM_LOCKED)
>>               -> try_to_mlock_page
>>                       -> TestSetPageMlocked
>>                       -> putback_lru_page
>>
>> So at last, the page will be located in unevictable list.
>>
>> > Then I was worrying about a null problem. Sorry for the confusion!
>> >
>> > Thanks,
>> > Fengguang
>> >
>> > > ----
>> > >
>> > > /*
>> > >  * called from munlock()/munmap() path with page supposedly on the LRU.
>> > >  *
>> > >  * Note:  unlike mlock_vma_page(), we can't just clear the PageMlocked
>> > >  * [in try_to_munlock()] and then attempt to isolate the page.  We must
>> > >  * isolate the page to keep others from messing with its unevictable
>> > >  * and mlocked state while trying to munlock.  However, we pre-clear the
>> > >  * mlocked state anyway as we might lose the isolation race and we might
>> > >  * not get another chance to clear PageMlocked.  If we successfully
>> > >  * isolate the page and try_to_munlock() detects other VM_LOCKED vmas
>> > >  * mapping the page, it will restore the PageMlocked state, unless the page
>> > >  * is mapped in a non-linear vma.  So, we go ahead and SetPageMlocked(),
>> > >  * perhaps redundantly.
>> > >  * If we lose the isolation race, and the page is mapped by other VM_LOCKED
>> > >  * vmas, we'll detect this in vmscan--via try_to_munlock() or try_to_unmap()
>> > >  * either of which will restore the PageMlocked state by calling
>> > >  * mlock_vma_page() above, if it can grab the vma's mmap sem.
>> > >  */
>> > > static void munlock_vma_page(struct page *page)
>> > > {
>> > > ...
>> > >
>> > > --
>> > > Kind regards,
>> > > Minchan Kim
>>
>>
>> --
>> Kind regards,
>> Minchan Kim
>



-- 
Kind regards,
Minchan Kim
