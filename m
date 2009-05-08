Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbZEHMJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbZEHMJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZEHMJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:09:26 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:61145 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbZEHMJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZMIhGKsc8zBLw32PbLIw3VeZT1KoChwx3/JHu0LXoGepqgY10jdCyKs+hh2fpjCT4i
         8ejHHy/eEfP22qjb+oNpURCIPqXssjRYQ4mpHFXHxsXAoVd/USjv01iv9Eo68pwvUGNq
         Y4rUUxvpNJoT3om2fCCAxyHMaP+7Sd/wZkNDc=
MIME-Version: 1.0
In-Reply-To: <20090508041700.GC8892@localhost>
References: <20090430181340.6f07421d.akpm@linux-foundation.org>
	 <20090430195439.e02edc26.akpm@linux-foundation.org>
	 <49FB01C1.6050204@redhat.com>
	 <20090501123541.7983a8ae.akpm@linux-foundation.org>
	 <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins>
	 <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org>
	 <1241709466.11251.164.camel@twins> <20090508041700.GC8892@localhost>
Date: Fri, 8 May 2009 21:09:24 +0900
Message-ID: <28c262360905080509q333ec8acv2d2be69d99e1dfa3@mail.gmail.com>
Subject: Re: [RFC][PATCH] vmscan: report vm_flags in page_referenced()
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 8, 2009 at 1:17 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Thu, May 07, 2009 at 11:17:46PM +0800, Peter Zijlstra wrote:
>> On Thu, 2009-05-07 at 17:10 +0200, Johannes Weiner wrote:
>>
>> > > @@ -1269,8 +1270,15 @@ static void shrink_active_list(unsigned
>> > >
>> > >           /* page_referenced clears PageReferenced */
>> > >           if (page_mapping_inuse(page) &&
>> > > -             page_referenced(page, 0, sc->mem_cgroup))
>> > > +             page_referenced(page, 0, sc->mem_cgroup)) {
>> > > +                 struct address_space *mapping = page_mapping(page);
>> > > +
>> > >                   pgmoved++;
>> > > +                 if (mapping && test_bit(AS_EXEC, &mapping->flags)) {
>> > > +                         list_add(&page->lru, &l_active);
>> > > +                         continue;
>> > > +                 }
>> > > +         }
>> >
>> > Since we walk the VMAs in page_referenced anyway, wouldn't it be
>> > better to check if one of them is executable?  This would even work
>> > for executable anon pages.  After all, there are applications that cow
>> > executable mappings (sbcl and other language environments that use an
>> > executable, run-time modified core image come to mind).
>>
>> Hmm, like provide a vm_flags mask along to page_referenced() to only
>> account matching vmas... seems like a sensible idea.
>
> Here is a quick patch for your opinions. Compile tested.
>
> With the added vm_flags reporting, the mlock=>unevictable logic can
> possibly be made more straightforward.
>
> Thanks,
> Fengguang
> ---
> vmscan: report vm_flags in page_referenced()
>
> This enables more informed reclaim heuristics, eg. to protect executable
> file pages more aggressively.
>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  include/linux/rmap.h |    5 +++--
>  mm/rmap.c            |   30 +++++++++++++++++++++---------
>  mm/vmscan.c          |    7 +++++--
>  3 files changed, 29 insertions(+), 13 deletions(-)
>
> --- linux.orig/include/linux/rmap.h
> +++ linux/include/linux/rmap.h
> @@ -83,7 +83,8 @@ static inline void page_dup_rmap(struct
>  /*
>  * Called from mm/vmscan.c to handle paging out
>  */
> -int page_referenced(struct page *, int is_locked, struct mem_cgroup *cnt);
> +int page_referenced(struct page *, int is_locked,
> +                       struct mem_cgroup *cnt, unsigned long *vm_flags);
>  int try_to_unmap(struct page *, int ignore_refs);
>
>  /*
> @@ -128,7 +129,7 @@ int page_wrprotect(struct page *page, in
>  #define anon_vma_prepare(vma)  (0)
>  #define anon_vma_link(vma)     do {} while (0)
>
> -#define page_referenced(page,l,cnt) TestClearPageReferenced(page)
> +#define page_referenced(page, locked, cnt, flags) TestClearPageReferenced(page)
>  #define try_to_unmap(page, refs) SWAP_FAIL
>
>  static inline int page_mkclean(struct page *page)
> --- linux.orig/mm/rmap.c
> +++ linux/mm/rmap.c
> @@ -333,7 +333,8 @@ static int page_mapped_in_vma(struct pag
>  * repeatedly from either page_referenced_anon or page_referenced_file.
>  */
>  static int page_referenced_one(struct page *page,
> -       struct vm_area_struct *vma, unsigned int *mapcount)
> +                              struct vm_area_struct *vma,
> +                              unsigned int *mapcount)
>  {
>        struct mm_struct *mm = vma->vm_mm;
>        unsigned long address;
> @@ -385,7 +386,8 @@ out:
>  }
>
>  static int page_referenced_anon(struct page *page,
> -                               struct mem_cgroup *mem_cont)
> +                               struct mem_cgroup *mem_cont,
> +                               unsigned long *vm_flags)
>  {
>        unsigned int mapcount;
>        struct anon_vma *anon_vma;
> @@ -406,6 +408,7 @@ static int page_referenced_anon(struct p
>                if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
>                        continue;
>                referenced += page_referenced_one(page, vma, &mapcount);
> +               *vm_flags |= vma->vm_flags;

Sometime this vma don't contain the anon page.
That's why we need page_check_address.
For such a case, wrong *vm_flag cause be harmful to reclaim.
It can be happen in your first class citizen patch, I think.



-- 
Kinds regards,
Minchan Kim
