Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYFZIK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYFZIK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYFZIKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:10:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51733 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYFZIKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:10:39 -0400
Date: Thu, 26 Jun 2008 17:08:57 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [-mm][PATCH 10/10] putback_lru_page()/unevictable page handling rework v4
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroy@jp.fujitsu.com>
In-Reply-To: <1214411395.7010.34.camel@lts-notebook>
References: <20080625191014.D86A.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1214411395.7010.34.camel@lts-notebook>
Message-Id: <20080626170614.FD0E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm updating the unevictable-lru doc in Documentation/vm.
> I have a question, below, on the removal of page_lock() from
> __mlock_vma_pages_range().  The document discusses how we hold the page
> lock when calling mlock_vma_page() to prevent races with migration
> [addressed by putback_lru_page() rework] and truncation.  I'm wondering
> if we're properly protected from truncation now...

Thanks for careful review.
I'll fix it and split into sevaral patches for easy review.


> > @@ -79,7 +80,7 @@ void __clear_page_mlock(struct page *pag
> >   */
> >  void mlock_vma_page(struct page *page)
> >  {
> > -	BUG_ON(!PageLocked(page));
> > +	VM_BUG_ON(!page->mapping);
> 
> If we're not holding the page locked here, can the page be truncated out
> from under us?  If so, I think we could hit this BUG or, if we just miss
> it, we could end up setting PageMlocked on a truncated page, and end up
> freeing an mlocked page.

this is obiously folding mistake by me ;)
this VM_BUG_ON() should be removed.



> > @@ -169,7 +170,8 @@ static int __mlock_vma_pages_range(struc
> >  
> >  		/*
> >  		 * get_user_pages makes pages present if we are
> > -		 * setting mlock.
> > +		 * setting mlock. and this extra reference count will
> > +		 * disable migration of this page.
> >  		 */
> >  		ret = get_user_pages(current, mm, addr,
> >  				min_t(int, nr_pages, ARRAY_SIZE(pages)),
> > @@ -197,14 +199,8 @@ static int __mlock_vma_pages_range(struc
> >  		for (i = 0; i < ret; i++) {
> >  			struct page *page = pages[i];
> >  
> > -			/*
> > -			 * page might be truncated or migrated out from under
> > -			 * us.  Check after acquiring page lock.
> > -			 */
> > -			lock_page(page);
> Safe to remove the locking?  I.e., page can't be truncated here?

you are right.
this lock_page() is necessary.



