Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbZHRODj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbZHRODj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZHRODi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:03:38 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:42734 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZHRODi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:03:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Nr9PepqFXTBQRuu+UegKKHBVLJzf6iW0z32YIPwgIEZyvMRXb9cJ/LkhP/fbMjvKHa
         E7jvltS7eKaMTIwaAWz9enLqtHkjGKER3YwFpdYUW0N1DmfoPXS9SgjENT2ESxRTci+3
         QMVSRqS3fwkmCpswOHjqLF/1jPY6OKQgRnfe0=
MIME-Version: 1.0
In-Reply-To: <20090818111125.GA20217@localhost>
References: <4A87829C.4090908@redhat.com> <20090816112910.GA3208@localhost>
	 <28c262360908170733q4bc5ddb8ob2fc976b6a468d6e@mail.gmail.com>
	 <20090818023438.GB7958@localhost>
	 <20090818131734.3d5bceb2.minchan.kim@barrios-desktop>
	 <20090818093119.GA12679@localhost>
	 <20090818185247.a4516389.minchan.kim@barrios-desktop>
	 <20090818100031.GC16298@localhost>
	 <28c262360908180400q361ea322o8959fd5ea5ae3217@mail.gmail.com>
	 <20090818111125.GA20217@localhost>
Date: Tue, 18 Aug 2009 23:03:38 +0900
Message-ID: <28c262360908180703p61e9048el9981a595b72f470d@mail.gmail.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>, Rik van Riel <riel@redhat.com>,
       Jeff Dike <jdike@addtoit.com>, Avi Kivity <avi@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
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

On Tue, Aug 18, 2009 at 8:11 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> On Tue, Aug 18, 2009 at 07:00:48PM +0800, Minchan Kim wrote:
>> On Tue, Aug 18, 2009 at 7:00 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
>> > On Tue, Aug 18, 2009 at 05:52:47PM +0800, Minchan Kim wrote:
>> >> On Tue, 18 Aug 2009 17:31:19 +0800
>> >> Wu Fengguang <fengguang.wu@intel.com> wrote:
>> >>
>> >> > On Tue, Aug 18, 2009 at 12:17:34PM +0800, Minchan Kim wrote:
>> >> > > On Tue, 18 Aug 2009 10:34:38 +0800
>> >> > > Wu Fengguang <fengguang.wu@intel.com> wrote:
>> >> > >
>> >> > > > Minchan,
>> >> > > >
>> >> > > > On Mon, Aug 17, 2009 at 10:33:54PM +0800, Minchan Kim wrote:
>> >> > > > > On Sun, Aug 16, 2009 at 8:29 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
>> >> > > > > > On Sun, Aug 16, 2009 at 01:15:02PM +0800, Wu Fengguang wrote:
>> >> > > > > >> On Sun, Aug 16, 2009 at 11:53:00AM +0800, Rik van Riel wrote:
>> >> > > > > >> > Wu Fengguang wrote:
>> >> > > > > >> > > On Fri, Aug 07, 2009 at 05:09:55AM +0800, Jeff Dike wrote:
>> >> > > > > >> > >> Side question -
>> >> > > > > >> > >>  Is there a good reason for this to be in shrink_active_list()
>> >> > > > > >> > >> as opposed to __isolate_lru_page?
>> >> > > > > >> > >>
>> >> > > > > >> > >>          if (unlikely(!page_evictable(page, NULL))) {
>> >> > > > > >> > >>                  putback_lru_page(page);
>> >> > > > > >> > >>                  continue;
>> >> > > > > >> > >>          }
>> >> > > > > >> > >>
>> >> > > > > >> > >> Maybe we want to minimize the amount of code under the lru lock or
>> >> > > > > >> > >> avoid duplicate logic in the isolate_page functions.
>> >> > > > > >> > >
>> >> > > > > >> > > I guess the quick test means to avoid the expensive page_referenced()
>> >> > > > > >> > > call that follows it. But that should be mostly one shot cost - the
>> >> > > > > >> > > unevictable pages are unlikely to cycle in active/inactive list again
>> >> > > > > >> > > and again.
>> >> > > > > >> >
>> >> > > > > >> > Please read what putback_lru_page does.
>> >> > > > > >> >
>> >> > > > > >> > It moves the page onto the unevictable list, so that
>> >> > > > > >> > it will not end up in this scan again.
>> >> > > > > >>
>> >> > > > > >> Yes it does. I said 'mostly' because there is a small hole that an
>> >> > > > > >> unevictable page may be scanned but still not moved to unevictable
>> >> > > > > >> list: when a page is mapped in two places, the first pte has the
>> >> > > > > >> referenced bit set, the _second_ VMA has VM_LOCKED bit set, then
>> >> > > > > >> page_referenced() will return 1 and shrink_page_list() will move it
>> >> > > > > >> into active list instead of unevictable list. Shall we fix this rare
>> >> > > > > >> case?
>> >> > > > >
>> >> > > > > I think it's not a big deal.
>> >> > > >
>> >> > > > Maybe, otherwise I should bring up this issue long time before :)
>> >> > > >
>> >> > > > > As you mentioned, it's rare case so there would be few pages in active
>> >> > > > > list instead of unevictable list.
>> >> > > >
>> >> > > > Yes.
>> >> > > >
>> >> > > > > When next time to scan comes, we can try to move the pages into
>> >> > > > > unevictable list, again.
>> >> > > >
>> >> > > > Will PG_mlocked be set by then? Otherwise the situation is not likely
>> >> > > > to change and the VM_LOCKED pages may circulate in active/inactive
>> >> > > > list for countless times.
>> >> > >
>> >> > > PG_mlocked is not important in that case.
>> >> > > Important thing is VM_LOCKED vma.
>> >> > > I think below annotaion can help you to understand my point. :)
>> >> >
>> >> > Hmm, it looks like pages under VM_LOCKED vma is guaranteed to have
>> >> > PG_mlocked set, and so will be caught by page_evictable(). Is it?
>> >>
>> >> No. I am sorry for making my point not clear.
>> >> I meant following as.
>> >> When the next time to scan,
>> >>
>> >> shrink_page_list
>> >  ->
>> >                referenced = page_referenced(page, 1,
>> >                                                sc->mem_cgroup, &vm_flags);
>> >                /* In active use or really unfreeable?  Activate it. */
>> >                if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
>> >                                        referenced && page_mapping_inuse(page))
>> >                        goto activate_locked;
>> >
>> >> -> try_to_unmap
>> >     ~~~~~~~~~~~~ this line won't be reached if page is found to be
>> >     referenced in the above lines?
>>
>> Indeed! In fact, I was worry about that.
>> It looks after live lock problem.
>> But I think  it's very small race window so  there isn't any report until now.
>> Let's Cced Lee.
>>
>> If we have to fix it, how about this ?
>> This version  has small overhead than yours since
>> there is less shrink_page_list call than page_referenced.
>
> Yeah, it looks better. However I still wonder if (VM_LOCKED && !PG_mlocked)
> is possible and somehow persistent. Does anyone have the answer? Thanks!

I think it's possible.
munlock_vma_page pre-clears PG_mlocked of page.
And then if isolate_lru_page fail, the page have no PG_mlocked and vma which
have VM_LOCKED.

As munlock_vma_page's annotation said, we hope the page will be rescued by
try_to_unmap. But As you pointed out, if the page have PG_referenced, it can't
reach try_to_unmap so that it will go into the active list.

What are others' opinion ?

> Thanks,
> Fengguang



-- 
Kind regards,
Minchan Kim
