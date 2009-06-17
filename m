Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbZFQA2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbZFQA2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbZFQA2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:28:43 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:34629 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbZFQA2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:28:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=eJdtRVbESGYUDChuKTQoAicSeeCwxmz/1ZYDTKdflH9yA+B0Im16x8e3s2MAUCjfTU
         98wUVPPFL5+a3OcTgAToQ+Dl5Xybaj+cJ2XxV5heP51DoE106bXkVzhX+3FAwpm3pnFi
         lKIBODLkmc3IHYDXHCn3dNpaejTix1xNYYyGA=
Date: Wed, 17 Jun 2009 09:28:26 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Mel Gorman <mel@csn.ul.ie>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 09/22] HWPOISON: Handle hardware poisoned pages in
 try_to_unmap
Message-Id: <20090617092826.56730a10.minchan.kim@barrios-desktop>
In-Reply-To: <20090616134944.GB7524@localhost>
References: <20090615024520.786814520@intel.com>
	<20090615031253.530308256@intel.com>
	<28c262360906150609gd736bf7p7a57de1b81cedd97@mail.gmail.com>
	<20090615152612.GA11700@localhost>
	<20090616090308.bac3b1f7.minchan.kim@barrios-desktop>
	<20090616134944.GB7524@localhost>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 21:49:44 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Tue, Jun 16, 2009 at 08:03:08AM +0800, Minchan Kim wrote:
> > On Mon, 15 Jun 2009 23:26:12 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > On Mon, Jun 15, 2009 at 09:09:03PM +0800, Minchan Kim wrote:
> > > > On Mon, Jun 15, 2009 at 11:45 AM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > > > > From: Andi Kleen <ak@linux.intel.com>
> > > > >
> > > > > When a page has the poison bit set replace the PTE with a poison entry.
> > > > > This causes the right error handling to be done later when a process runs
> > > > > into it.
> > > > >
> > > > > Also add a new flag to not do that (needed for the memory-failure handler
> > > > > later)
> > > > >
> > > > > Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
> > > > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > > > >
> > > > > ---
> > > > >  include/linux/rmap.h |    1 +
> > > > >  mm/rmap.c            |    9 ++++++++-
> > > > >  2 files changed, 9 insertions(+), 1 deletion(-)
> > > > >
> > > > > --- sound-2.6.orig/mm/rmap.c
> > > > > +++ sound-2.6/mm/rmap.c
> > > > > @@ -958,7 +958,14 @@ static int try_to_unmap_one(struct page
> > > > >        /* Update high watermark before we lower rss */
> > > > >        update_hiwater_rss(mm);
> > > > >
> > > > > -       if (PageAnon(page)) {
> > > > > +       if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
> > > > > +               if (PageAnon(page))
> > > > > +                       dec_mm_counter(mm, anon_rss);
> > > > > +               else if (!is_migration_entry(pte_to_swp_entry(*pte)))
> > > > 
> > > > Isn't it straightforward to use !is_hwpoison_entry ?
> > > 
> > > Good catch!  It looks like a redundant check: the
> > > page_check_address() at the beginning of the function guarantees that 
> > > !is_migration_entry() or !is_migration_entry() tests will all be TRUE.
> > > So let's do this?
> > It seems you expand my sight :)
> > 
> > I don't know migration well.
> > How page_check_address guarantee it's not migration entry ? 
> 
> page_check_address() calls pte_present() which returns the
> (_PAGE_PRESENT | _PAGE_PROTNONE) bits. While x86-64 defines
> 
> #define __swp_entry(type, offset)       ((swp_entry_t) { \
>                                          ((type) << (_PAGE_BIT_PRESENT + 1)) \
>                                          | ((offset) << SWP_OFFSET_SHIFT) })
> 
> where SWP_OFFSET_SHIFT is defined to the bigger one of
> max(_PAGE_BIT_PROTNONE + 1, _PAGE_BIT_FILE + 1) = max(8+1, 6+1) = 9.
> 
> So __swp_entry(type, offset) := (type << 1) | (offset << 9)
> 
> We know that the swap type is 5 bits. So the bit 0 _PAGE_PRESENT and bit 8
> _PAGE_PROTNONE will all be zero for swap entries.
>  

Thanks for kind explanation :)

> 
> > In addtion, If the page is poison while we are going to
> > migration((PAGE_MIGRATION && migration) == TRUE), we should decrease
> > file_rss ?
> 
> It will die on trying to migrate the poisoned page so we don't care
> the accounting. But normally the poisoned page shall already be


Okay. then, how about this ?
We should not increase file_rss on trying to migrate the poisoned page

-               else if (!is_migration_entry(pte_to_swp_entry(*pte)))
+               else if (!(PAGE_MIGRATION && migration))

> isolated so we don't care that die either.
> Thanks,
> Fengguang
> 
> > > 
> > > -               else if (!is_migration_entry(pte_to_swp_entry(*pte)))
> > > +               else
> > > 
> > > 
> > > Thanks,
> > > Fengguang
> > 
> > 
> > -- 
> > Kinds Regards
> > Minchan Kim


-- 
Kinds Regards
Minchan Kim
