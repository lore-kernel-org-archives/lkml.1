Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbZE0CHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbZE0CHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZE0CHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:07:40 -0400
Received: from cmpxchg.org ([85.214.51.133]:41305 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbZE0CHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:07:40 -0400
Date: Wed, 27 May 2009 04:06:37 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 5/5] (experimental) chase and free cache only swap
Message-ID: <20090527020637.GA9863@cmpxchg.org>
References: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com> <20090526121834.dd9a4193.kamezawa.hiroyu@jp.fujitsu.com> <20090526181359.GB2843@cmpxchg.org> <20090527090813.a0e436f8.kamezawa.hiroyu@jp.fujitsu.com> <20090527012658.GA9692@cmpxchg.org> <20090527103107.9c04eb55.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527103107.9c04eb55.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:31:07AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 27 May 2009 03:26:58 +0200
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > On Wed, May 27, 2009 at 09:08:13AM +0900, KAMEZAWA Hiroyuki wrote:
> > > On Tue, 26 May 2009 20:14:00 +0200
> > > Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > 
> > > > On Tue, May 26, 2009 at 12:18:34PM +0900, KAMEZAWA Hiroyuki wrote:
> > > > > 
> > > > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > > > 
> > > > > Just a trial/example patch.
> > > > > I'd like to consider more. Better implementation idea is welcome.
> > > > > 
> > > > > When the system does swap-in/swap-out repeatedly, there are 
> > > > > cache-only swaps in general.
> > > > > Typically,
> > > > >  - swapped out in past but on memory now while vm_swap_full() returns true
> > > > > pages are cache-only swaps. (swap_map has no references.)
> > > > > 
> > > > > This cache-only swaps can be an obstacles for smooth page reclaiming.
> > > > > Current implemantation is very naive, just scan & free.
> > > > 
> > > > I think we can just remove that vm_swap_full() check in do_swap_page()
> > > > and try to remove the page from swap cache unconditionally.
> > > > 
> > > I'm not sure why reclaim swap entry only at write fault.
> > 
> > How do you come to that conclusion?  Do you mean the current code does
> > that? 
> yes.
> 
> 2474         pte = mk_pte(page, vma->vm_page_prot);
> 2475         if (write_access && reuse_swap_page(page)) {
> 2476                 pte = maybe_mkwrite(pte_mkdirty(pte), vma);
> 2477                 write_access = 0;
> 2478         }

Ahh.  But further down after installing the PTE, it does

	swap_free(entry);
	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
	        try_to_free_swap(page);
	unlock_page(page);

You are right, it tries to reuse the page and free the swap slot for
writes, but later it removes the swap reference from the pte and then
tries to free the slot again, also for reads.

My suggestion was to remove these checks in the second attempt and
just try regardless of swap usage or mlock.  I just sent out a patch
that does that.
