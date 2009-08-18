Return-Path: <linux-kernel-owner+w=401wt.eu-S1751125AbZHRESU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbZHRESU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 00:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbZHRESU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 00:18:20 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:52448 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZHREST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 00:18:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=jWGSh10f8mmu1hLBViP72oHpuWP2HhdYubVE0AGmfBzFFNGNunuROuZAAlZ0wJ7olC
         DYJN9Wmcoi+RWmEB0qkY5MHoZ3RXaGZ4kAuBZ+gSDu/bYkDDl1bO4gjDmRKY+EkHX1nH
         p11MBmEK7TMNeEPJ9cM1DOK4SK9SS2dOMDVAM=
Date: Tue, 18 Aug 2009 13:17:34 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
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
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-Id: <20090818131734.3d5bceb2.minchan.kim@barrios-desktop>
In-Reply-To: <20090818023438.GB7958@localhost>
References: <20090806102057.GQ23385@random.random>
	<20090806105932.GA1569@localhost>
	<4A7AC201.4010202@redhat.com>
	<20090806130631.GB6162@localhost>
	<20090806210955.GA14201@c2.user-mode-linux.org>
	<20090816031827.GA6888@localhost>
	<4A87829C.4090908@redhat.com>
	<20090816051502.GB13740@localhost>
	<20090816112910.GA3208@localhost>
	<28c262360908170733q4bc5ddb8ob2fc976b6a468d6e@mail.gmail.com>
	<20090818023438.GB7958@localhost>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 10:34:38 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Minchan,
> 
> On Mon, Aug 17, 2009 at 10:33:54PM +0800, Minchan Kim wrote:
> > On Sun, Aug 16, 2009 at 8:29 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > > On Sun, Aug 16, 2009 at 01:15:02PM +0800, Wu Fengguang wrote:
> > >> On Sun, Aug 16, 2009 at 11:53:00AM +0800, Rik van Riel wrote:
> > >> > Wu Fengguang wrote:
> > >> > > On Fri, Aug 07, 2009 at 05:09:55AM +0800, Jeff Dike wrote:
> > >> > >> Side question -
> > >> > >>  Is there a good reason for this to be in shrink_active_list()
> > >> > >> as opposed to __isolate_lru_page?
> > >> > >>
> > >> > >>          if (unlikely(!page_evictable(page, NULL))) {
> > >> > >>                  putback_lru_page(page);
> > >> > >>                  continue;
> > >> > >>          }
> > >> > >>
> > >> > >> Maybe we want to minimize the amount of code under the lru lock or
> > >> > >> avoid duplicate logic in the isolate_page functions.
> > >> > >
> > >> > > I guess the quick test means to avoid the expensive page_referenced()
> > >> > > call that follows it. But that should be mostly one shot cost - the
> > >> > > unevictable pages are unlikely to cycle in active/inactive list again
> > >> > > and again.
> > >> >
> > >> > Please read what putback_lru_page does.
> > >> >
> > >> > It moves the page onto the unevictable list, so that
> > >> > it will not end up in this scan again.
> > >>
> > >> Yes it does. I said 'mostly' because there is a small hole that an
> > >> unevictable page may be scanned but still not moved to unevictable
> > >> list: when a page is mapped in two places, the first pte has the
> > >> referenced bit set, the _second_ VMA has VM_LOCKED bit set, then
> > >> page_referenced() will return 1 and shrink_page_list() will move it
> > >> into active list instead of unevictable list. Shall we fix this rare
> > >> case?
> > 
> > I think it's not a big deal.
> 
> Maybe, otherwise I should bring up this issue long time before :)
> 
> > As you mentioned, it's rare case so there would be few pages in active
> > list instead of unevictable list.
> 
> Yes.
> 
> > When next time to scan comes, we can try to move the pages into
> > unevictable list, again.
> 
> Will PG_mlocked be set by then? Otherwise the situation is not likely 
> to change and the VM_LOCKED pages may circulate in active/inactive
> list for countless times.

PG_mlocked is not important in that case. 
Important thing is VM_LOCKED vma. 
I think below annotaion can help you to understand my point. :)

----

/*
 * called from munlock()/munmap() path with page supposedly on the LRU.
 *
 * Note:  unlike mlock_vma_page(), we can't just clear the PageMlocked
 * [in try_to_munlock()] and then attempt to isolate the page.  We must
 * isolate the page to keep others from messing with its unevictable
 * and mlocked state while trying to munlock.  However, we pre-clear the
 * mlocked state anyway as we might lose the isolation race and we might
 * not get another chance to clear PageMlocked.  If we successfully
 * isolate the page and try_to_munlock() detects other VM_LOCKED vmas
 * mapping the page, it will restore the PageMlocked state, unless the page
 * is mapped in a non-linear vma.  So, we go ahead and SetPageMlocked(),
 * perhaps redundantly.
 * If we lose the isolation race, and the page is mapped by other VM_LOCKED
 * vmas, we'll detect this in vmscan--via try_to_munlock() or try_to_unmap()
 * either of which will restore the PageMlocked state by calling
 * mlock_vma_page() above, if it can grab the vma's mmap sem.
 */
static void munlock_vma_page(struct page *page)
{
...

-- 
Kind regards,
Minchan Kim
