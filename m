Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbZHSN2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbZHSN2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZHSN2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:28:36 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:37493 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZHSN2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:28:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=otYnfI0mt/5eOtybtgC5Te0a8FVmaztpMHBBBraEMbLHp2Kx/8iCHOY/NPtfjLwqjw
         otLUbl7TshzELrCjsn29mEeVFgSqmt3zwETaRaO8kpejfASt3LGUFusawSiCsM5mimX4
         yjm1Fl5S/ootKge7kcanxiWrYY2oq8dy/qB9g=
MIME-Version: 1.0
In-Reply-To: <2f11576a0908190619t9951959o3841091e51324c8@mail.gmail.com>
References: <20090816051502.GB13740@localhost>
	 <20090816112910.GA3208@localhost>
	 <20090818234310.A64B.A69D9226@jp.fujitsu.com>
	 <20090819120117.GB7306@localhost>
	 <2f11576a0908190505h6da96280xf67c962aa3f5ba07@mail.gmail.com>
	 <20090819121017.GA8226@localhost>
	 <28c262360908190525i6e56ead0mb8dcb01c3d1a69f1@mail.gmail.com>
	 <2f11576a0908190619t9951959o3841091e51324c8@mail.gmail.com>
Date: Wed, 19 Aug 2009 22:28:33 +0900
Message-ID: <28c262360908190628i3f323714kf011f9b0fd4cd15@mail.gmail.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Jeff Dike <jdike@addtoit.com>, Avi Kivity <avi@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 10:19 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> 2009/8/19 Minchan Kim <minchan.kim@gmail.com>:
>> On Wed, Aug 19, 2009 at 9:10 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
>>> On Wed, Aug 19, 2009 at 08:05:19PM +0800, KOSAKI Motohiro wrote:
>>>> >> page_referenced_file?
>>>> >> I think we should change page_referenced().
>>>> >
>>>> > Yeah, good catch.
>>>> >
>>>> >>
>>>> >> Instead, How about this?
>>>> >> ==============================================
>>>> >>
>>>> >> Subject: [PATCH] mm: stop circulating of referenced mlocked pages
>>>> >>
>>>> >> Currently, mlock() systemcall doesn't gurantee to mark the page PG_Mlocked
>>>> >
>>>> >                                                    mark PG_mlocked
>>>> >
>>>> >> because some race prevent page grabbing.
>>>> >> In that case, instead vmscan move the page to unevictable lru.
>>>> >>
>>>> >> However, Recently Wu Fengguang pointed out current vmscan logic isn't so
>>>> >> efficient.
>>>> >> mlocked page can move circulatly active and inactive list because
>>>> >> vmscan check the page is referenced _before_ cull mlocked page.
>>>> >>
>>>> >> Plus, vmscan should mark PG_Mlocked when cull mlocked page.
>>>> >
>>>> >                           PG_mlocked
>>>> >
>>>> >> Otherwise vm stastics show strange number.
>>>> >>
>>>> >> This patch does that.
>>>> >
>>>> > Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
>>>>
>>>> Thanks.
>>>>
>>>>
>>>>
>>>> >> Index: b/mm/rmap.c
>>>> >> ===================================================================
>>>> >> --- a/mm/rmap.c       2009-08-18 19:48:14.000000000 +0900
>>>> >> +++ b/mm/rmap.c       2009-08-18 23:47:34.000000000 +0900
>>>> >> @@ -362,7 +362,9 @@ static int page_referenced_one(struct pa
>>>> >>        * unevictable list.
>>>> >>        */
>>>> >>       if (vma->vm_flags & VM_LOCKED) {
>>>> >> -             *mapcount = 1;  /* break early from loop */
>>>> >> +             *mapcount = 1;          /* break early from loop */
>>>> >> +             *vm_flags |= VM_LOCKED; /* for prevent to move active list */
>>>> >
>>>> >> +             try_set_page_mlocked(vma, page);
>>>> >
>>>> > That call is not absolutely necessary?
>>>>
>>>> Why? I haven't catch your point.
>>>
>>> Because we'll eventually hit another try_set_page_mlocked() when
>>> trying to unmap the page. Ie. duplicated with another call you added
>>> in this patch.
>
> Correct.
>
>
>> Yes. we don't have to call it and we can make patch simple.
>> I already sent patch on yesterday.
>>
>> http://marc.info/?l=linux-mm&m=125059325722370&w=2
>>
>> I think It's more simple than KOSAKI's idea.
>> Is any problem in my patch ?
>
> Hmm, I think
>
> 1. Anyway, we need turn on PG_mlock.

I add my patch again to explain.

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

By this check, the page can be reached at try_to_unmap after
page_referenced in shrink_page_list. At that time PG_mlocked will be
set.

> 2. PG_mlock prevent livelock because page_evictable() check is called
> at very early in shrink_page_list().






-- 
Kind regards,
Minchan Kim
