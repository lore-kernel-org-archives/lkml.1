Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbYFUIlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbYFUIlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 04:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYFUIle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 04:41:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47265 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYFUIld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:41:33 -0400
Date: Sat, 21 Jun 2008 17:41:28 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [Experimental][PATCH] putback_lru_page rework
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
In-Reply-To: <1213981843.6474.68.camel@lts-notebook>
References: <20080620101352.e1200b8e.kamezawa.hiroyu@jp.fujitsu.com> <1213981843.6474.68.camel@lts-notebook>
Message-Id: <20080621173912.E824.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Before:
> >       lock_page()(TestSetPageLocked())
> >       spin_lock(zone->lock)
> >       unlock_page()
> >       spin_unlock(zone->lock)  
> 
> Couple of comments:
> * I believe that the locks are acquired in the right order--at least as
> documented in the comments in mm/rmap.c.  
> * The unlocking appears out of order because this function attempts to
> hold the zone lock across a few pages in the pagevec, but must switch to
> a different zone lru lock when it finds a page on a different zone from
> the zone whose lock it is holding--like in the pagevec draining
> functions, altho' they don't need to lock the page.
> 
> > After:
> >       spin_lock(zone->lock)
> >       spin_unlock(zone->lock)
> 
> Right.  With your reworked check_move_unevictable_page() [with retry],
> we don't need to lock the page here, any more.  That means we can revert
> all of the changes to pass the mapping back to sys_shmctl() and move the
> call to scan_mapping_unevictable_pages() back to shmem_lock() after
> clearing the address_space's unevictable flag.  We only did that to
> avoid sleeping while holding the shmem_inode_info lock and the
> shmid_kernel's ipc_perm spinlock.  
> 
> Shall I handle that, after we've tested this patch?

Yeah, I'll do it :)


> > @@ -2438,7 +2437,7 @@ static void show_page_path(struct page *
> >   */
> >  static void check_move_unevictable_page(struct page *page, struct zone *zone)
> >  {
> > -
> > +retry:
> >  	ClearPageUnevictable(page); /* for page_evictable() */
> We can remove this comment            ^^^^^^^^^^^^^^^^^^^^^^^^^^
> page_evictable() no longer asserts !PageUnevictable(), right?

Yes.
I'll remove it.



