Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbZE1BGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbZE1BGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbZE1BGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:06:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53780 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbZE1BGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:06:34 -0400
Date: Thu, 28 May 2009 10:05:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/5] add SWAP_HAS_CACHE flag to swap_map
Message-Id: <20090528100501.ab26953f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090528094157.5c39ac57.nishimura@mxp.nes.nec.co.jp>
References: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090526121547.ce866fe4.kamezawa.hiroyu@jp.fujitsu.com>
	<20090528094157.5c39ac57.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 09:41:57 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > @@ -1969,17 +2017,33 @@ int swap_duplicate(swp_entry_t entry)
> >  	offset = swp_offset(entry);
> >  
> >  	spin_lock(&swap_lock);
> > -	if (offset < p->max && p->swap_map[offset]) {
> > -		if (p->swap_map[offset] < SWAP_MAP_MAX - 1) {
> > -			p->swap_map[offset]++;
> > +
> > +	if (unlikely(offset >= p->max))
> > +		goto unlock_out;
> > +
> > +	count = swap_count(p->swap_map[offset]);
> > +	has_cache = swap_has_cache(p->swap_map[offset]);
> > +	if (cache) {
> > +		/* set SWAP_HAS_CACHE if there is no cache and entry is used */
> > +		if (!has_cache && count) {
> Should we check !has_cache here ?
I added !has_cache to return 0 in racy case.

> 
> Concurrent read_swap_cache_async() might have set SWAP_HAS_CACHE, but not have added
> a page to swap cache yet when find_get_page() was called.
yes.

> add_to_swap_cache() would handle the race of concurrent read_swap_cache_async(),
> but considering more, swapcache_free() at the end of the loop might dangerous in this case...

I can't catch what you mean.

I think swapcache_prepare() returns 0 in racy case and no add_to_swap_cache() happens.
wrong ?

> So I think it should be like:
> 
> 	read_swap_cache_async()
> 		:
> 		valid = swapcache_prepare(entry);
> 		if (!valid)
> 			break;
> 		if (valid == -EAGAIN);
> 			continue;
> 
> to let the context that succeeded in swapcache_prepare() do add_to_swap_cache().
> 

What you reccomend is code like this ?

==
	ret = swapcache_prapare(entry);
	if (ret == -ENOENT)
		break;    /* unused swap entry */
	if (ret == -EBUSY)
		continue; /* to call find_get_page() again */
==

-Kame





