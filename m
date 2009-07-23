Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbZGWCIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbZGWCIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 22:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZGWCIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 22:08:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36138 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZGWCIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 22:08:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 23 Jul 2009 11:06:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       chrisw@redhat.com, avi@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 06/10] ksm: identify PageKsm pages
Message-Id: <20090723110655.f08cdcdc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0907221346040.529@sister.anvils>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com>
	<1247851850-4298-2-git-send-email-ieidus@redhat.com>
	<1247851850-4298-3-git-send-email-ieidus@redhat.com>
	<1247851850-4298-4-git-send-email-ieidus@redhat.com>
	<1247851850-4298-5-git-send-email-ieidus@redhat.com>
	<1247851850-4298-6-git-send-email-ieidus@redhat.com>
	<1247851850-4298-7-git-send-email-ieidus@redhat.com>
	<20090721175139.GE2239@random.random>
	<4A660101.3000307@redhat.com>
	<Pine.LNX.4.64.0907221346040.529@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 13:54:06 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Tue, 21 Jul 2009, Rik van Riel wrote:
> > Andrea Arcangeli wrote:
> > > > -	if (PageAnon(old_page)) {
> > > > +	if (PageAnon(old_page) && !PageKsm(old_page)) {
> > > >    if (!trylock_page(old_page)) {
> > > >     page_cache_get(old_page);
> > > >     pte_unmap_unlock(page_table, ptl);
> > > 
> > > What exactly does it buy to have PageAnon return 1 on ksm pages,
> > > besides requiring the above additional check (that if we stick to the
> > > above code, I would find safer to move inside reuse_swap_page).
> > 
> > I guess that if they are to remain unswappable, they
> > should go onto the unevictable list.
> 
> The KSM pages are not put on any LRU, so wouldn't be slowing vmscan
> down with futile scans: isn't the unevictable list for pages which
> belong to another LRU once they become evictable again?
> 
> (At this instant I've forgotten why there's an unevictable list at
> all - somewhere in vmscan.c which is accustomed to dealing with
> pages on lists, so easier to have them on a list than not?)
> 
I forget, too. But in short thinking, Unevictable pages should be
on LRU (marked as PG_lru) for isolating page (from LRU) called by
page migration etc.

isolate_lru_page()
	-> put page on private list
	-> do some work
	-> putback_lru_page()

sequence is useful at handling pages in a list.
Because mlock/munclock can be called arbitrarily, unevicatable lru
works enough good for making above kinds of code simpler.

Thanks,
-Kame


