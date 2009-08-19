Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbZHSNiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbZHSNiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZHSNiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:38:06 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:36168 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZHSNiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LAhAKoF6jWl+/yjQ/koEhNuHLF8jrCT8HmupqzIciY1XG6WAWeHGWwm9oi8GC19po2
         STWfpTPGn+5GYR0Rdne/9Qw1voPmd+ftzsxqoqLReWJ15cM+lLS7K1AMBmPru2GEga5R
         x6fejOnYX7UAuS47SOHaNX7XObXRC0BbveYZ4=
MIME-Version: 1.0
In-Reply-To: <20090819132420.GA6137@localhost>
References: <20090816051502.GB13740@localhost>
	 <20090816112910.GA3208@localhost>
	 <20090818234310.A64B.A69D9226@jp.fujitsu.com>
	 <20090819120117.GB7306@localhost>
	 <2f11576a0908190505h6da96280xf67c962aa3f5ba07@mail.gmail.com>
	 <20090819121017.GA8226@localhost>
	 <28c262360908190525i6e56ead0mb8dcb01c3d1a69f1@mail.gmail.com>
	 <20090819132420.GA6137@localhost>
Date: Wed, 19 Aug 2009 22:38:05 +0900
Message-ID: <28c262360908190638g521e55bcje14cb321c9a22c51@mail.gmail.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Jeff Dike <jdike@addtoit.com>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
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

On Wed, Aug 19, 2009 at 10:24 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> On Wed, Aug 19, 2009 at 08:25:56PM +0800, Minchan Kim wrote:
>> On Wed, Aug 19, 2009 at 9:10 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
>> > On Wed, Aug 19, 2009 at 08:05:19PM +0800, KOSAKI Motohiro wrote:
>> >> >> page_referenced_file?
>> >> >> I think we should change page_referenced().
>> >> >
>> >> > Yeah, good catch.
>> >> >
>> >> >>
>> >> >> Instead, How about this?
>> >> >> ==============================================
>> >> >>
>> >> >> Subject: [PATCH] mm: stop circulating of referenced mlocked pages
>> >> >>
>> >> >> Currently, mlock() systemcall doesn't gurantee to mark the page PG_Mlocked
>> >> >
>> >> >                                                    mark PG_mlocked
>> >> >
>> >> >> because some race prevent page grabbing.
>> >> >> In that case, instead vmscan move the page to unevictable lru.
>> >> >>
>> >> >> However, Recently Wu Fengguang pointed out current vmscan logic isn't so
>> >> >> efficient.
>> >> >> mlocked page can move circulatly active and inactive list because
>> >> >> vmscan check the page is referenced _before_ cull mlocked page.
>> >> >>
>> >> >> Plus, vmscan should mark PG_Mlocked when cull mlocked page.
>> >> >
>> >> >                           PG_mlocked
>> >> >
>> >> >> Otherwise vm stastics show strange number.
>> >> >>
>> >> >> This patch does that.
>> >> >
>> >> > Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
>> >>
>> >> Thanks.
>> >>
>> >>
>> >>
>> >> >> Index: b/mm/rmap.c
>> >> >> ===================================================================
>> >> >> --- a/mm/rmap.c       2009-08-18 19:48:14.000000000 +0900
>> >> >> +++ b/mm/rmap.c       2009-08-18 23:47:34.000000000 +0900
>> >> >> @@ -362,7 +362,9 @@ static int page_referenced_one(struct pa
>> >> >>        * unevictable list.
>> >> >>        */
>> >> >>       if (vma->vm_flags & VM_LOCKED) {
>> >> >> -             *mapcount = 1;  /* break early from loop */
>> >> >> +             *mapcount = 1;          /* break early from loop */
>> >> >> +             *vm_flags |= VM_LOCKED; /* for prevent to move active list */
>> >> >
>> >> >> +             try_set_page_mlocked(vma, page);
>> >> >
>> >> > That call is not absolutely necessary?
>> >>
>> >> Why? I haven't catch your point.
>> >
>> > Because we'll eventually hit another try_set_page_mlocked() when
>> > trying to unmap the page. Ie. duplicated with another call you added
>> > in this patch.
>>
>> Yes. we don't have to call it and we can make patch simple.
>> I already sent patch on yesterday.
>>
>> http://marc.info/?l=linux-mm&m=125059325722370&w=2
>>
>> I think It's more simple than KOSAKI's idea.
>> Is any problem in my patch ?
>
> No, IMHO your patch is simple and good, while KOSAKI's is more
> complete :)
>
> - the try_set_page_mlocked() rename is suitable
> - the call to try_set_page_mlocked() is necessary on try_to_unmap()

We don't need try_set_page_mlocked call in try_to_unmap.
That's because try_to_unmap_xxx will call try_to_mlock_page if the
page is included in any VM_LOCKED vma. Eventually, It can move
unevictable list.

> - the "if (VM_LOCKED) referenced = 0" in page_referenced() could
>  cover both active/inactive vmscan

ASAP we set PG_mlocked in page, we can save unnecessary vmscan cost from
active list to inactive list. But I think it's rare case so that there
would be few pages.
So I think that will be not big overhead.

As I know, Rescue by vmscan page losing the isolation race was the
Lee's design.
But as you pointed out, it have a bug that vmscan can't rescue the
page due to reach try_to_unmap.

So I think this approach is proper. :)

> I did like your proposed
>
>                if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
> -                                       referenced && page_mapping_inuse(page))
> +                                       referenced && page_mapping_inuse(page)
> +                                       && !(vm_flags & VM_LOCKED))
>                        goto activate_locked;
>
> which looks more intuitive and less confusing.
>
> Thanks,
> Fengguang
>



-- 
Kind regards,
Minchan Kim
