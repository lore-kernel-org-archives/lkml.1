Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbZE0FI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbZE0FI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbZE0FIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:08:50 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37076 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbZE0FIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:08:50 -0400
Date: Wed, 27 May 2009 14:00:01 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 2/5] add SWAP_HAS_CACHE flag to swap_map
Message-Id: <20090527140001.80360afb.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090527133629.142aa42f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090526121547.ce866fe4.kamezawa.hiroyu@jp.fujitsu.com>
	<20090527130246.95dadb2c.nishimura@mxp.nes.nec.co.jp>
	<20090527133629.142aa42f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 13:36:29 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 27 May 2009 13:02:46 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > > @@ -1067,21 +1113,21 @@ static int try_to_unuse(unsigned int typ
> > >  		}
> > >  
> > >  		/*
> > > -		 * How could swap count reach 0x7fff when the maximum
> > > -		 * pid is 0x7fff, and there's no way to repeat a swap
> > > -		 * page within an mm (except in shmem, where it's the
> > > -		 * shared object which takes the reference count)?
> > > -		 * We believe SWAP_MAP_MAX cannot occur in Linux 2.4.
> > > -		 *
> > > +		 * How could swap count reach 0x7ffe ?
> > > +		 * There's no way to repeat a swap page within an mm
> > > +		 * (except in shmem, where it's the shared object which takes
> > > +		 * the reference count)?
> > > +		 * We believe SWAP_MAP_MAX cannot occur.(if occur, unsigned
> > > +		 * short is too small....)
> > >  		 * If that's wrong, then we should worry more about
> > >  		 * exit_mmap() and do_munmap() cases described above:
> > >  		 * we might be resetting SWAP_MAP_MAX too early here.
> > >  		 * We know "Undead"s can happen, they're okay, so don't
> > >  		 * report them; but do report if we reset SWAP_MAP_MAX.
> > >  		 */
> > > -		if (*swap_map == SWAP_MAP_MAX) {
> > > +		if (swap_count(*swap_map) == SWAP_MAP_MAX) {
> > >  			spin_lock(&swap_lock);
> > > -			*swap_map = 1;
> > > +			*swap_map = make_swap_count(0, 1);
> > Can we assume the entry has SWAP_HAS_CACHE here ?
> > Shouldn't we check PageSwapCache beforehand ?
> > 
> 
> IIUC, in this try_to_unuse code, the page is added to swap cache and locked
> before reaches here. But....ah,ok, unuse_mm() may release lock_page() before
> reach here. Then...
> 
And the owner process might have removed the swap cache before we take the lock,
as the following comments in try_to_unuse() says.

> if (PageSwapCache(page) && swap_count(*swap_map) == SWAP_MAP_MAX)
> 
> is right ? (maybe original code, set to "1" is also buggy.)
> 
Reading the following code in try_to_unuse(), I think

	int valid_swap_cache = !!(PageSwapCache(page) &&
					page_private(page) == entry.val)
	  :
	*swap_map = make_swap_count(0(or 1?), valid_swap_cache);

might be better.

But I can't confirm it anyway. I've never hit SWAP_MAP_MAX.


Thanks,
Daisuke Nishimura.
