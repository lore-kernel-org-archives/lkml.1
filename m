Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbZE0EiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbZE0EiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 00:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbZE0EiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 00:38:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57313 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZE0EiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 00:38:05 -0400
Date: Wed, 27 May 2009 13:36:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/5] add SWAP_HAS_CACHE flag to swap_map
Message-Id: <20090527133629.142aa42f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090527130246.95dadb2c.nishimura@mxp.nes.nec.co.jp>
References: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090526121547.ce866fe4.kamezawa.hiroyu@jp.fujitsu.com>
	<20090527130246.95dadb2c.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 13:02:46 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > @@ -1067,21 +1113,21 @@ static int try_to_unuse(unsigned int typ
> >  		}
> >  
> >  		/*
> > -		 * How could swap count reach 0x7fff when the maximum
> > -		 * pid is 0x7fff, and there's no way to repeat a swap
> > -		 * page within an mm (except in shmem, where it's the
> > -		 * shared object which takes the reference count)?
> > -		 * We believe SWAP_MAP_MAX cannot occur in Linux 2.4.
> > -		 *
> > +		 * How could swap count reach 0x7ffe ?
> > +		 * There's no way to repeat a swap page within an mm
> > +		 * (except in shmem, where it's the shared object which takes
> > +		 * the reference count)?
> > +		 * We believe SWAP_MAP_MAX cannot occur.(if occur, unsigned
> > +		 * short is too small....)
> >  		 * If that's wrong, then we should worry more about
> >  		 * exit_mmap() and do_munmap() cases described above:
> >  		 * we might be resetting SWAP_MAP_MAX too early here.
> >  		 * We know "Undead"s can happen, they're okay, so don't
> >  		 * report them; but do report if we reset SWAP_MAP_MAX.
> >  		 */
> > -		if (*swap_map == SWAP_MAP_MAX) {
> > +		if (swap_count(*swap_map) == SWAP_MAP_MAX) {
> >  			spin_lock(&swap_lock);
> > -			*swap_map = 1;
> > +			*swap_map = make_swap_count(0, 1);
> Can we assume the entry has SWAP_HAS_CACHE here ?
> Shouldn't we check PageSwapCache beforehand ?
> 

IIUC, in this try_to_unuse code, the page is added to swap cache and locked
before reaches here. But....ah,ok, unuse_mm() may release lock_page() before
reach here. Then...

if (PageSwapCache(page) && swap_count(*swap_map) == SWAP_MAP_MAX)

is right ? (maybe original code, set to "1" is also buggy.)

Thanks,
-Kame


> >  			spin_unlock(&swap_lock);
> >  			reset_overflow = 1;
> >  		}
> 
> 
> Thanks,
> Daisuke Nishimura.
> 

