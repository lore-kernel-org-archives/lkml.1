Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbXLUUAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbXLUUAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 15:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbXLUUAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 15:00:46 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:54958 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbXLUUAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 15:00:43 -0500
Date: Fri, 21 Dec 2007 20:59:27 +0100 (CET)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <20071220222816.GB4745@atjola.homenet>
Message-ID: <Pine.LNX.4.64.0712212049001.24477@bizon.gios.gov.pl>
References: <20071215221935.306A5108068@picon.linux-foundation.org>
 <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl>
 <20071215203539.d6f71e96.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl>
 <20071216015112.d0ab08a1.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl>
 <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org>
 <20071220141217.GA4745@atjola.homenet> <alpine.LFD.0.9999.0712200753040.21557@woody.linux-foundation.org>
 <20071220222816.GB4745@atjola.homenet>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-359259988-1198267167=:24477"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-359259988-1198267167=:24477
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 20 Dec 2007, Bj=F6rn Steinbrink wrote:

> On 2007.12.20 08:25:56 -0800, Linus Torvalds wrote:
>>
>>
>> On Thu, 20 Dec 2007, Bj?rn Steinbrink wrote:
>>>
>>> OK, so I looked for PG_dirty anyway.
>>>
>>> In 46d2277c796f9f4937bfa668c40b2e3f43e93dd0 you made try_to_free_buffer=
s
>>> bail out if the page is dirty.
>>>
>>> Then in 3e67c0987d7567ad666641164a153dca9a43b11d, Andrew fixed
>>> truncate_complete_page, because it called cancel_dirty_page (and thus
>>> cleared PG_dirty) after try_to_free_buffers was called via
>>> do_invalidatepage.
>>>
>>> Now, if I'm not mistaken, we can end up as follows.
>>>
>>> truncate_complete_page()
>>>   cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
>>>   do_invalidatepage()
>>>     ext3_invalidatepage()
>>>       journal_invalidatepage()
>>>         journal_unmap_buffer()
>>>           __dispose_buffer()
>>>             __journal_unfile_buffer()
>>>               __journal_temp_unlink_buffer()
>>>                 mark_buffer_dirty(); // PG_dirty set, incr. dirty pages
>>
>> Good, this seems to be the exact path that actually triggers it. I got t=
o
>> journal_unmap_buffer(), but was too lazy to actually then bother to foll=
ow
>> it all the way down - I decided that I didn't actually really even care
>> what the low-level FS layer did, I had already convinced myself that it
>> obviously must be dirtying the page some way, since that matched the
>> symptoms exactly (ie only the journaling case was impacted, and this was
>> all about the journal).
>>
>> But perhaps more importantly: regardless of what the low-level filesyste=
m
>> did at that point, the VM accounting shouldn't care, and should be robus=
t
>> in the face of a low-level filesystem doing strange and wonderful things=
=2E
>> But thanks for bothering to go through the whole history and figure out
>> what exactly is up.
>
> Oh well, after seeing the move of cancel_dirty_page, I just went
> backwards from __set_page_dirty using cscope + some smart guessing and
> quickly ended up at ext3_invalidatepage, so it wasn't that hard :-)
>
>>> As try_to_free_buffers got its ext3 hack back in
>>> ecdfc9787fe527491baefc22dce8b2dbd5b2908d, maybe
>>> 3e67c0987d7567ad666641164a153dca9a43b11d should be reverted? (Except fo=
r
>>> the accounting fix in cancel_dirty_page, of course).
>>
>> Yes, I think we have room for cleanups now, and I agree: we ended up
>> reinstating some questionable code in the VM just because we didn't real=
ly
>> know or understand what was going on in the ext3 journal code.
>
> Hm, you attributed more to my mail than there was actually in it. I
> didn't even start to think of cleanups (because I don't know jack about
> the whole ext3/jdb stuff, so I simply cannot come up with any cleanups
> (yet?)).What I meant is that we only did a half-revert of that hackery.
>
> When try_to_free_buffers started to check for PG_dirty, the
> cancel_dirty_page call had to be called before do_invalidatepage, to
> "fix" a _huge_ leak.  But that caused the accouting breakage we're now
> seeing, because we never account for the pages that got redirtied during
> do_invalidatepage.
>
> Then the change to try_to_free_buffers got reverted, so we no longer
> need to call cancel_dirty_page before do_invalidatepage, but still we
> do. Thus the accounting bug remains. So what I meant to suggest was
> simply to actually "finish" the revert we started.
>
> Or expressed as a patch:
>
> diff --git a/mm/truncate.c b/mm/truncate.c
> index cadc156..2974903 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -98,11 +98,11 @@ truncate_complete_page(struct address_space *mapping,=
 struct page *page)
> =09if (page->mapping !=3D mapping)
> =09=09return;
>
> -=09cancel_dirty_page(page, PAGE_CACHE_SIZE);
> -
> =09if (PagePrivate(page))
> =09=09do_invalidatepage(page, 0);
>
> +=09cancel_dirty_page(page, PAGE_CACHE_SIZE);
> +
> =09remove_from_page_cache(page);
> =09ClearPageUptodate(page);
> =09ClearPageMappedToDisk(page);
>
> I'll be the last one to comment on whether or not that causes inaccurate
> accouting, so I'll just watch you and Jan battle that out until someone
> comes up with a post-.24 patch to provide a clean fix for the issue.
>
> Krzysztof, could you give this patch a test run?
>
> If that "fixes" the problem for now, I'll try to come up with some
> usable commit message, or if somehow wants to beat me to it, you can
> already have my
>
> Signed-off-by: Bj=F6rn Steinbrink <B.Steinbrink@gmx.de>

Checked with 2.6.24-rc5 + debug/fixup patch from Linus + above fix. After=
=20
3h there have been no warnings about __remove_from_page_cache(). So, it=20
seems that it is OK.

Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-359259988-1198267167=:24477--
