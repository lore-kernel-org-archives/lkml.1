Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYFXRQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYFXRQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYFXRQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:16:12 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42484 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYFXRQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:16:11 -0400
Subject: Re: [RFC][PATCH] putback_lru_page()/unevictable page handling
	rework v3
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20080624184122.D838.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080624184122.D838.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 24 Jun 2008 13:15:41 -0400
Message-Id: <1214327741.6563.17.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-24 at 18:49 +0900, KOSAKI Motohiro wrote:
> I found one bug ;)
> 
> > -int putback_lru_page(struct page *page)
> > +#ifdef CONFIG_UNEVICTABLE_LRU
> > +void putback_lru_page(struct page *page)
> >  {
> >  	int lru;
> > -	int ret = 1;
> >  	int was_unevictable;
> >  
> > -	VM_BUG_ON(!PageLocked(page));
> >  	VM_BUG_ON(PageLRU(page));
> >  
> > +	was_unevictable = TestClearPageUnevictable(page);
> > +
> > +redo:
> >  	lru = !!TestClearPageActive(page);
> > -	was_unevictable = TestClearPageUnevictable(page); /* for page_evictable() */
> 
> (snip)
> 
> > +	mem_cgroup_move_lists(page, lru);
> > +
> > +	/*
> > +	 * page's status can change while we move it among lru. If an evictable
> > +	 * page is on unevictable list, it never be freed. To avoid that,
> > +	 * check after we added it to the list, again.
> > +	 */
> > +	if (lru == LRU_UNEVICTABLE && page_evictable(page, NULL)) {
> > +		if (!isolate_lru_page(page)) {
> > +			put_page(page);
> > +			goto redo;
> 
> at this point, We should call ClearPageUnevictable().
> otherwise, BUG() is called on isolate_lru_pages().
> 

To which BUG() are you referring here?  There used to be a
BUG_ON(PageUnevictable(page)) in page_evictable(), but Kame-san removed
that.

By the wah, we'll never take the retry because 'lru' never ==
LRU_UNEVICTABLE in this version of putback_lru_page().  Patch to follow.

Lee

