Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZBWMoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZBWMoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 07:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZBWMog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 07:44:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZBWMof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 07:44:35 -0500
Subject: Re: [PATCH 15/20] Do not disable interrupts in free_page_mlock()
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
In-Reply-To: <20090223122331.GF6740@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
	 <1235344649-18265-16-git-send-email-mel@csn.ul.ie>
	 <1235380740.4645.2.camel@laptop>  <20090223122331.GF6740@csn.ul.ie>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 13:44:18 +0100
Message-Id: <1235393058.4645.134.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 12:23 +0000, Mel Gorman wrote:
> On Mon, Feb 23, 2009 at 10:19:00AM +0100, Peter Zijlstra wrote:
> > On Sun, 2009-02-22 at 23:17 +0000, Mel Gorman wrote:

> > >  static inline void free_page_mlock(struct page *page)
> > >  {
> > > -	if (unlikely(TestClearPageMlocked(page))) {
> > > -		unsigned long flags;
> > > -
> > > -		local_irq_save(flags);
> > > -		__dec_zone_page_state(page, NR_MLOCK);
> > > -		__count_vm_event(UNEVICTABLE_MLOCKFREED);
> > > -		local_irq_restore(flags);
> > > -	}
> > > +	__dec_zone_page_state(page, NR_MLOCK);
> > > +	__count_vm_event(UNEVICTABLE_MLOCKFREED);
> > >  }
> > 
> > Its not actually clearing PG_mlocked anymore, so the name is now a tad
> > misleading.
> > 
> 
> Really? I see the following

> So there is a PG_mlocked bit once UNEVITABLE_LRU is set which was the
> case on the tests I was running. I'm probably missing something silly.

What I was trying to say was that free_page_mlock() doesn't change the
page-state after your change, hence the 'free' part of its name is
misleading.

> > That said, since we're freeing the page, there ought to not be another
> > reference to the page, in which case it appears to me we could safely
> > use the unlocked variant of TestClear*().
> > 
> 
> Regrettably, unlocked variants do not appear to be defined as such but
> the following should do the job, right? It applies on top of the current
> change.
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index b52bf86..7f775a1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -155,6 +155,7 @@ static inline void mlock_migrate_page(struct page *newpage, struct page *page)
>   */
>  static inline void free_page_mlock(struct page *page)
>  {
	VM_BUG_ON(!PageMlocked(page)); ?

> +	__ClearPageMlocked(page);
>  	__dec_zone_page_state(page, NR_MLOCK);
>  	__count_vm_event(UNEVICTABLE_MLOCKFREED);
>  }
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index edac673..8bd0533 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -580,7 +580,7 @@ static void __free_pages_ok(struct page *page, unsigned int order,
>  	unsigned long flags;
>  	int i;
>  	int bad = 0;
> -	int clearMlocked = TestClearPageMlocked(page);
> +	int clearMlocked = PageMlocked(page);
>  
>  	for (i = 0 ; i < (1 << order) ; ++i)
>  		bad += free_pages_check(page + i);
> @@ -1040,7 +1040,7 @@ static void free_pcp_page(struct page *page)
>  	struct per_cpu_pages *pcp;
>  	unsigned long flags;
>  	int migratetype;
> -	int clearMlocked = TestClearPageMlocked(page);
> +	int clearMlocked = PageMlocked(page);
>  
>  	if (PageAnon(page))
>  		page->mapping = NULL;

Right, that should do.

