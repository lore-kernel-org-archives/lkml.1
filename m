Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZFPADi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZFPADi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 20:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZFPAD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 20:03:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:7166 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZFPADZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 20:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=kxzQ2eUitk036n5h+nQAjreDoZmi3yRgu8Q1ysvTAeNjPvdSjk3zKZEPkwbedSHEyz
         mFDCKoPnYCI3a8IiTpPM7G5kV/QgJwxBlVXHtp6f41zlZKvBZN9RPALkWXq6+sSX4B7c
         /TwSP+ZVXC6IUKmv+Dx8ztsXKMUDYWpsXdQK0=
Date: Tue, 16 Jun 2009 09:03:08 +0900
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
Message-Id: <20090616090308.bac3b1f7.minchan.kim@barrios-desktop>
In-Reply-To: <20090615152612.GA11700@localhost>
References: <20090615024520.786814520@intel.com>
	<20090615031253.530308256@intel.com>
	<28c262360906150609gd736bf7p7a57de1b81cedd97@mail.gmail.com>
	<20090615152612.GA11700@localhost>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 23:26:12 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Mon, Jun 15, 2009 at 09:09:03PM +0800, Minchan Kim wrote:
> > On Mon, Jun 15, 2009 at 11:45 AM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > >
> > > When a page has the poison bit set replace the PTE with a poison entry.
> > > This causes the right error handling to be done later when a process runs
> > > into it.
> > >
> > > Also add a new flag to not do that (needed for the memory-failure handler
> > > later)
> > >
> > > Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
> > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > >
> > > ---
> > >  include/linux/rmap.h |    1 +
> > >  mm/rmap.c            |    9 ++++++++-
> > >  2 files changed, 9 insertions(+), 1 deletion(-)
> > >
> > > --- sound-2.6.orig/mm/rmap.c
> > > +++ sound-2.6/mm/rmap.c
> > > @@ -958,7 +958,14 @@ static int try_to_unmap_one(struct page
> > >        /* Update high watermark before we lower rss */
> > >        update_hiwater_rss(mm);
> > >
> > > -       if (PageAnon(page)) {
> > > +       if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
> > > +               if (PageAnon(page))
> > > +                       dec_mm_counter(mm, anon_rss);
> > > +               else if (!is_migration_entry(pte_to_swp_entry(*pte)))
> > 
> > Isn't it straightforward to use !is_hwpoison_entry ?
> 
> Good catch!  It looks like a redundant check: the
> page_check_address() at the beginning of the function guarantees that 
> !is_migration_entry() or !is_migration_entry() tests will all be TRUE.
> So let's do this?
It seems you expand my sight :)

I don't know migration well.
How page_check_address guarantee it's not migration entry ? 

In addtion, If the page is poison while we are going to migration((PAGE_MIGRATION && migration) == TRUE), we should decrease file_rss ?

> 
> -               else if (!is_migration_entry(pte_to_swp_entry(*pte)))
> +               else
> 
> 
> Thanks,
> Fengguang


-- 
Kinds Regards
Minchan Kim
