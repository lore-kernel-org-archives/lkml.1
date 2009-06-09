Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbZFIOBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbZFIOBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZFIOB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:01:26 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:39471 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZFIOBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ch2p3hGE0yUlzszm4M9plY16M/Qzx0kAbfs2UHFMWdQSvQv6vZIBhik4i5o46RVW9/
         /ECqgE0oKBRvUTNmmBPruToE+h1VF4QZe6uZzNKGEdnxTo8T6qp8UgPfl3m8ftKw6oku
         8z6MI+dG5GhLCzY1a/0ddjj87n1s5QPDWiN4w=
MIME-Version: 1.0
In-Reply-To: <20090609130058.GA25007@shadowen.org>
References: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262360906090300s13f4ee09mcc9622c1e477eaad@mail.gmail.com>
	 <e8f208a7c6bec1818947c24658dc1561.squirrel@webmail-b.css.fujitsu.com>
	 <28c262360906090430p21125c51g10cfdc377a78d07b@mail.gmail.com>
	 <7ca0521d9b798ef8b56212e5b17ea713.squirrel@webmail-b.css.fujitsu.com>
	 <28c262360906090507u75f5b594o71906777a91efa1@mail.gmail.com>
	 <20090609130058.GA25007@shadowen.org>
Date: Tue, 9 Jun 2009 23:01:26 +0900
Message-ID: <28c262360906090701v35af80b7j3f8317d96fa2d23@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] fix wrong lru rotate back at lumpty reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andy.

On Tue, Jun 9, 2009 at 10:00 PM, Andy Whitcroft<apw@canonical.com> wrote:
> On Tue, Jun 09, 2009 at 09:07:16PM +0900, Minchan Kim wrote:
>> 2009/6/9 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
>> > Minchan Kim wrote:
>> >
>> >> I mean follow as
>> >>  908         /*
>> >>  909          * Attempt to take all pages in the order aligned region
>> >>  910          * surrounding the tag page.  Only take those pages of
>> >>  911          * the same active state as that tag page.  We may safely
>> >>  912          * round the target page pfn down to the requested order
>> >>  913          * as the mem_map is guarenteed valid out to MAX_ORDER,
>> >>  914          * where that page is in a different zone we will detect
>> >>  915          * it from its zone id and abort this block scan.
>> >>  916          */
>> >>  917         zone_id = page_zone_id(page);
>> >>
>> > But what this code really do is.
>> > ==
>> > 931                         /* Check that we have not crossed a zone
>> > boundary. */
>> >  932                         if (unlikely(page_zone_id(cursor_page) !=
>> > zone_id))
>> >  933                                 continue;
>> > ==
>> > continue. I think this should be "break"
>> > I wonder what "This block scan" means is "scanning this aligned block".
>>
>> It is to find first page in same zone with target page when we have
>> crossed a zone.
>> so it shouldn't stop due to that.
>>
>> I think 'abort' means stopping only the page.
>> If it is right, it would be better to change follow as.
>> "and continue scanning next page"
>>
>> Let's Cced Andy Whitcroft.
>>
>> > But I think the whoe code is not written as commented.
>> >
>> >>
>> >>>> If I understand it properly , don't we add goto phrase ?
>> >>>>
>> >>> No.
>> >>
>> >> If it is so, the break also is meaningless.
>> >>
>> > yes. I'll remove it. But need to add "exit from for loop" logic again.
>> >
>> > I'm sorry that the wrong logic of this loop was out of my sight.
>> > I'll review and rewrite this part all, tomorrow.
>>
>> Yes. I will review tomorrow, too. :)
>
> The comment is not the best wording.  The point here is that we need to
> round down in order to safely scan the free blocks as they are only
> marked at the start.  In rounding down however we may move back into the
> previous zone as zones are not necessarily MAX_ORDER aligned.  We want
> to ignore the bit before our zone starts and that check moves us on to
> the next page.  It should be noted that this occurs rarely, ie. only
> when we touch the start of a zone and only then where the zone
> boundaries are not MAX_ORDER aligned.

Thanks for kind explanation.

I think this thread's issue is the 'break' following as.

...
                        cursor_page = pfn_to_page(pfn);

                        /* Check that we have not crossed a zone boundary. */
                        if (unlikely(page_zone_id(cursor_page) != zone_id))
                                continue;
                        switch (__isolate_lru_page(cursor_page, mode, file)) {
                        case 0:
                                list_move(&cursor_page->lru, dst);
                                nr_taken++;
                                scan++;
                                break;

                        case -EBUSY:
                                /* else it is being freed elsewhere */
                                list_move(&cursor_page->lru, src);
                        default:
                                break;  /* ! on LRU or wrong list */
<====== HERE
                        }
                }
        }
...

I think you meant that if we met not lru pages, it should stop scanning.
That's because we have in trouble with high order page allocation.
So, if we fail to allocate contiguous page frame, scanning isn't a
point any more.

But that break can't stop loop. It is in switch case. so if we want to
break in loop really, we have to use goto phrase.
What do you think about it ?

> -apw
>



-- 
Kinds regards,
Minchan Kim
