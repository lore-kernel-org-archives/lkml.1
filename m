Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654Ab0COFiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 01:38:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53425 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab0COFiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 01:38:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 15 Mar 2010 14:34:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped 
 anonymous pages
Message-Id: <20100315143420.6ec3bdf9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262361003141728g4aa40901hb040144c5a4aeeed@mail.gmail.com>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
	<1268412087-13536-3-git-send-email-mel@csn.ul.ie>
	<28c262361003141728g4aa40901hb040144c5a4aeeed@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 09:28:08 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Hi, Mel.
> On Sat, Mar 13, 2010 at 1:41 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> > rmap_walk_anon() was triggering errors in memory compaction that looks like
> > use-after-free errors in anon_vma. The problem appears to be that between
> > the page being isolated from the LRU and rcu_read_lock() being taken, the
> > mapcount of the page dropped to 0 and the anon_vma was freed. This patch
> > skips the migration of anon pages that are not mapped by anyone.
> >
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > Acked-by: Rik van Riel <riel@redhat.com>
> > ---
> >  mm/migrate.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> >
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 98eaaf2..3c491e3 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -602,6 +602,16 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
> >         * just care Anon page here.
> >         */
> >        if (PageAnon(page)) {
> > +               /*
> > +                * If the page has no mappings any more, just bail. An
> > +                * unmapped anon page is likely to be freed soon but worse,
> > +                * it's possible its anon_vma disappeared between when
> > +                * the page was isolated and when we reached here while
> > +                * the RCU lock was not held
> > +                */
> > +               if (!page_mapcount(page))
> 
> As looking code about mapcount of page, I got confused.
> I think mapcount of page is protected by pte lock.
> But I can't find pte lock in unmap_and_move.
There is no pte_lock.

> If I am right, what protects race between this condition check and
> rcu_read_lock?
> This patch makes race window very small but It can't remove race totally.
> 
> I think I am missing something.
> Pz, point me out. :)
> 

Hmm. This is my understanding of old story.

At migration.
  1. we increase page_count().
  2. isolate it from LRU.
  3. call try_to_unmap() under rcu_read_lock(). Then, 
  4. replace pte with swp_entry_t made by PFN. under pte_lock.
  5. do migarate 
  6. remap new pages. under pte_lock()>
  7. release rcu_read_lock().

Here, we don't care whether page->mapping holds valid anon_vma or not.

Assume a racy threads which calls zap_pte_range() (or some other)

a) When the thread finds valid pte under pte_lock and successfully call
   page_remove_rmap().
   In this case, migration thread finds try_to_unmap doesn't unmap any pte.
   Then, at 6, remap pte will not work.
b) When the thread finds migrateion PTE(as swap entry) in zap_page_range().
   In this case, migration doesn't find migrateion PTE and remap fails.

Why rcu_read_lock() is necessary..
 - When page_mapcount() goes to 0, we shouldn't trust page->mapping is valid.
 - Possible cases are
	i) anon_vma (= page->mapping) is freed and used for other object.
 	ii) anon_vma (= page->mapping) is freed
	iii) anon_vma (= page->mapping) is freed and used as anon_vma again.

Here, anon_vma_cachep is created  by SLAB_DESTROY_BY_RCU. Then, possible cases
are only ii) and iii). While anon_vma is anon_vma, try_to_unmap and remap_page
can work well because of the list of vmas and address check. IOW, remap routine
just do nothing if anon_vma is freed.

I'm not sure by what logic "use-after-free anon_vma" is caught. But yes,
there will be case, "anon_vma is touched after freed.", I think.

Thanks,
-Kame



