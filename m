Return-Path: <linux-kernel-owner+w=401wt.eu-S1764717AbZFQNnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764717AbZFQNnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbZFQNn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:43:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:41604 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276AbZFQNn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v9TuxrR0xnPDucs3I/f5FpzuQ9G3oNvSt6ivavczqcYxWNwgfvPX+GOd1AdUlAGLJT
         NjoWdTYPH8GObnZYupal2mqaxVCCsD+9qZoYC0GxaGFta7q1csazF7NtkKzanMsxX8GQ
         PbJCf4fqN21Kqxd3/7JIdt7kMjIs9IO7gkRH0=
MIME-Version: 1.0
In-Reply-To: <20090617133708.GA7839@localhost>
References: <20090615024520.786814520@intel.com>
	 <20090615031253.530308256@intel.com>
	 <28c262360906150609gd736bf7p7a57de1b81cedd97@mail.gmail.com>
	 <20090615152612.GA11700@localhost>
	 <20090616090308.bac3b1f7.minchan.kim@barrios-desktop>
	 <20090616134944.GB7524@localhost>
	 <20090617092826.56730a10.minchan.kim@barrios-desktop>
	 <20090617072319.GA5841@localhost>
	 <28c262360906170627p2e57f907y2f8bbdc9fd5804f2@mail.gmail.com>
	 <20090617133708.GA7839@localhost>
Date: Wed, 17 Jun 2009 22:43:29 +0900
Message-ID: <28c262360906170643o3783b0a4k8fbc1001baa8e2e1@mail.gmail.com>
Subject: Re: [PATCH 09/22] HWPOISON: Handle hardware poisoned pages in 
	try_to_unmap
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Mel Gorman <mel@csn.ul.ie>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 10:37 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> On Wed, Jun 17, 2009 at 09:27:36PM +0800, Minchan Kim wrote:
>> On Wed, Jun 17, 2009 at 4:23 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
>> > On Wed, Jun 17, 2009 at 08:28:26AM +0800, Minchan Kim wrote:
>> >> On Tue, 16 Jun 2009 21:49:44 +0800
>> >> Wu Fengguang <fengguang.wu@intel.com> wrote:
>> >>
>> >> > On Tue, Jun 16, 2009 at 08:03:08AM +0800, Minchan Kim wrote:
>> >> > > On Mon, 15 Jun 2009 23:26:12 +0800
>> >> > > Wu Fengguang <fengguang.wu@intel.com> wrote:
>> >> > >
>> >> > > > On Mon, Jun 15, 2009 at 09:09:03PM +0800, Minchan Kim wrote:
>> >> > > > > On Mon, Jun 15, 2009 at 11:45 AM, Wu Fengguang<fengguang.wu@intel.com> wrote:
>> >> > > > > > From: Andi Kleen <ak@linux.intel.com>
>> >> > > > > >
>> >> > > > > > When a page has the poison bit set replace the PTE with a poison entry.
>> >> > > > > > This causes the right error handling to be done later when a process runs
>> >> > > > > > into it.
>> >> > > > > >
>> >> > > > > > Also add a new flag to not do that (needed for the memory-failure handler
>> >> > > > > > later)
>> >> > > > > >
>> >> > > > > > Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
>> >> > > > > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
>> >> > > > > >
>> >> > > > > > ---
>> >> > > > > >  include/linux/rmap.h |    1 +
>> >> > > > > >  mm/rmap.c            |    9 ++++++++-
>> >> > > > > >  2 files changed, 9 insertions(+), 1 deletion(-)
>> >> > > > > >
>> >> > > > > > --- sound-2.6.orig/mm/rmap.c
>> >> > > > > > +++ sound-2.6/mm/rmap.c
>> >> > > > > > @@ -958,7 +958,14 @@ static int try_to_unmap_one(struct page
>> >> > > > > >        /* Update high watermark before we lower rss */
>> >> > > > > >        update_hiwater_rss(mm);
>> >> > > > > >
>> >> > > > > > -       if (PageAnon(page)) {
>> >> > > > > > +       if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
>> >> > > > > > +               if (PageAnon(page))
>> >> > > > > > +                       dec_mm_counter(mm, anon_rss);
>> >> > > > > > +               else if (!is_migration_entry(pte_to_swp_entry(*pte)))
>> >> > > > >
>> >> > > > > Isn't it straightforward to use !is_hwpoison_entry ?
>> >> > > >
>> >> > > > Good catch!  It looks like a redundant check: the
>> >> > > > page_check_address() at the beginning of the function guarantees that
>> >> > > > !is_migration_entry() or !is_migration_entry() tests will all be TRUE.
>> >> > > > So let's do this?
>> >> > > It seems you expand my sight :)
>> >> > >
>> >> > > I don't know migration well.
>> >> > > How page_check_address guarantee it's not migration entry ?
>> >> >
>> >> > page_check_address() calls pte_present() which returns the
>> >> > (_PAGE_PRESENT | _PAGE_PROTNONE) bits. While x86-64 defines
>> >> >
>> >> > #define __swp_entry(type, offset)       ((swp_entry_t) { \
>> >> >                                          ((type) << (_PAGE_BIT_PRESENT + 1)) \
>> >> >                                          | ((offset) << SWP_OFFSET_SHIFT) })
>> >> >
>> >> > where SWP_OFFSET_SHIFT is defined to the bigger one of
>> >> > max(_PAGE_BIT_PROTNONE + 1, _PAGE_BIT_FILE + 1) = max(8+1, 6+1) = 9.
>> >> >
>> >> > So __swp_entry(type, offset) := (type << 1) | (offset << 9)
>> >> >
>> >> > We know that the swap type is 5 bits. So the bit 0 _PAGE_PRESENT and bit 8
>> >> > _PAGE_PROTNONE will all be zero for swap entries.
>> >> >
>> >>
>> >> Thanks for kind explanation :)
>> >
>> > You are welcome~
>> >
>> >> >
>> >> > > In addtion, If the page is poison while we are going to
>> >> > > migration((PAGE_MIGRATION && migration) == TRUE), we should decrease
>> >> > > file_rss ?
>> >> >
>> >> > It will die on trying to migrate the poisoned page so we don't care
>> >> > the accounting. But normally the poisoned page shall already be
>> >>
>> >>
>> >> Okay. then, how about this ?
>> >> We should not increase file_rss on trying to migrate the poisoned page
>> >>
>> >> -               else if (!is_migration_entry(pte_to_swp_entry(*pte)))
>> >> +               else if (!(PAGE_MIGRATION && migration))
>> >
>> > This is good if we are going to stop the hwpoison page from being
>> > consumed by move_to_new_page(), but I highly doubt we'll ever add
>> > PageHWPoison() checks into the migration code.
>> >
>> > Because this race window is small enough:
>> >
>> >        TestSetPageHWPoison(p);
>> >                                   lock_page(page);
>> >                                   try_to_unmap(page, TTU_MIGRATION|...);
>> >        lock_page_nosync(p);
>> >
>> > such small race windows can be found all over the kernel, it's just
>> > insane to try to fix any of them.
>>
>> Sorry for too late response.
>>
>> I see your point.
>> My opinion is that at least we must be notified when such situation happen.
>> So I think it would be better to add some warning to fix up it when it
>> happen even thought  it is small race window.
>
> Notification is also pointless here: we'll die hard on
> accessing/consuming the poisoned page anyway :(

My intention wasn't to recover it.

It just add something like WARN_ON.
You said it is small window enough. but I think it can happen more
hight probability in migration-workload.(At a moment, I don't know
what kinds of app)
For such case, If we can hear reporting of warning, at that time we
can consider migration handling for HWPoison.

> Thanks,
> Fengguang
>
>



-- 
Kinds regards,
Minchan Kim
