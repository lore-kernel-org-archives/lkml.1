Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZHQOdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZHQOdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZHQOdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:33:54 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:44326 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZHQOdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:33:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Yp8Dq+doHHNHbcU9sFyFVx69HvcckD9d5JXlyh+tbJPFtXZaN3VB4EGIUe9kxPtE91
         kyjiryOGsqEyw0H1JtYlMfwWE8XMiJL3AeylzsajWIo1seGykfboLncpLDH2Pmq39zcF
         d2v0scITQDiG9AHg2k7zrYYSDrTEOJGTlxaOA=
MIME-Version: 1.0
In-Reply-To: <20090816112910.GA3208@localhost>
References: <20090806100824.GO23385@random.random>
	 <20090806102057.GQ23385@random.random>
	 <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com>
	 <20090806130631.GB6162@localhost>
	 <20090806210955.GA14201@c2.user-mode-linux.org>
	 <20090816031827.GA6888@localhost> <4A87829C.4090908@redhat.com>
	 <20090816051502.GB13740@localhost> <20090816112910.GA3208@localhost>
Date: Mon, 17 Aug 2009 23:33:54 +0900
Message-ID: <28c262360908170733q4bc5ddb8ob2fc976b6a468d6e@mail.gmail.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
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

Hi, Wu.

On Sun, Aug 16, 2009 at 8:29 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> On Sun, Aug 16, 2009 at 01:15:02PM +0800, Wu Fengguang wrote:
>> On Sun, Aug 16, 2009 at 11:53:00AM +0800, Rik van Riel wrote:
>> > Wu Fengguang wrote:
>> > > On Fri, Aug 07, 2009 at 05:09:55AM +0800, Jeff Dike wrote:
>> > >> Side question -
>> > >>  Is there a good reason for this to be in shrink_active_list()
>> > >> as opposed to __isolate_lru_page?
>> > >>
>> > >>          if (unlikely(!page_evictable(page, NULL))) {
>> > >>                  putback_lru_page(page);
>> > >>                  continue;
>> > >>          }
>> > >>
>> > >> Maybe we want to minimize the amount of code under the lru lock or
>> > >> avoid duplicate logic in the isolate_page functions.
>> > >
>> > > I guess the quick test means to avoid the expensive page_referenced()
>> > > call that follows it. But that should be mostly one shot cost - the
>> > > unevictable pages are unlikely to cycle in active/inactive list again
>> > > and again.
>> >
>> > Please read what putback_lru_page does.
>> >
>> > It moves the page onto the unevictable list, so that
>> > it will not end up in this scan again.
>>
>> Yes it does. I said 'mostly' because there is a small hole that an
>> unevictable page may be scanned but still not moved to unevictable
>> list: when a page is mapped in two places, the first pte has the
>> referenced bit set, the _second_ VMA has VM_LOCKED bit set, then
>> page_referenced() will return 1 and shrink_page_list() will move it
>> into active list instead of unevictable list. Shall we fix this rare
>> case?

I think it's not a big deal.

As you mentioned, it's rare case so there would be few pages in active
list instead of unevictable list.
When next time to scan comes, we can try to move the pages into
unevictable list, again.

As I know about mlock pages, we already had some races condition.
They will be rescued like above.

>
> How about this fix?
>
> ---
> mm: stop circulating of referenced mlocked pages
>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>
> --- linux.orig/mm/rmap.c        2009-08-16 19:11:13.000000000 +0800
> +++ linux/mm/rmap.c     2009-08-16 19:22:46.000000000 +0800
> @@ -358,6 +358,7 @@ static int page_referenced_one(struct pa
>         */
>        if (vma->vm_flags & VM_LOCKED) {
>                *mapcount = 1;  /* break early from loop */
> +               *vm_flags |= VM_LOCKED;
>                goto out_unmap;
>        }
>
> @@ -482,6 +483,8 @@ static int page_referenced_file(struct p
>        }
>
>        spin_unlock(&mapping->i_mmap_lock);
> +       if (*vm_flags & VM_LOCKED)
> +               referenced = 0;
>        return referenced;
>  }
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
