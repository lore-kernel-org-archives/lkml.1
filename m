Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393AbZDYQH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbZDYQH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 12:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZDYQHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 12:07:11 -0400
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.67]:41858 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZDYQHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 12:07:10 -0400
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Sun, 26 Apr 2009 01:06:58 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>, d-nishimura@mtf.biglobe.ne.jp,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH] fix swap entries is not reclaimed in proper way
 for memg v3.
Message-Id: <20090426010658.c0fa3258.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20090425215459.5cab7285.d-nishimura@mtf.biglobe.ne.jp>
References: <20090421162121.1a1d15fe.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422143833.2e11e10b.nishimura@mxp.nes.nec.co.jp>
	<20090424133306.0d9fb2ce.kamezawa.hiroyu@jp.fujitsu.com>
	<20090424152103.a5ee8d13.nishimura@mxp.nes.nec.co.jp>
	<20090424162840.2ad06d8a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090425215459.5cab7285.d-nishimura@mtf.biglobe.ne.jp>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few minor nitpicks :)

> > +static void memcg_fixup_stale_swapcache(struct work_struct *work)
> > +{
> > +	int pos = 0;
> > +	swp_entry_t entry;
> > +	struct page *page;
> > +	int forget, ret;
> > +
> > +	while (ssc.num) {
> > +		spin_lock(&ssc.lock);
> > +		pos = find_next_bit(ssc.usemap, STALE_ENTS, pos);
> > +		spin_unlock(&ssc.lock);
> > +
> > +		if (pos >= STALE_ENTS)
> > +			break;
> > +
> > +		entry = ssc.ents[pos];
> > +
> > +		forget = 1;
> > +		page = lookup_swap_cache(entry);
I think using find_get_page() would be better.
lookup_swap_cache() update swapcache_info.

> > +		if (page) {
> > +			lock_page(page);
> > +			ret = try_to_free_swap(page);
> > +			/* If it's still under I/O, don't forget it */
> > +			if (!ret && PageWriteback(page))
> > +				forget = 0;
> > +			unlock_page(page);
> I think we need page_cache_release().
> lookup_swap_cache() gets the page.
> 
> > +		}
> > +		if (forget) {
> > +			spin_lock(&ssc.lock);
> > +			clear_bit(pos, ssc.usemap);
> > +			ssc.num--;
> > +			if (ssc.num < STALE_ENTS/2)
> > +				ssc.congestion = 0;
> > +			spin_unlock(&ssc.lock);
> > +		}
> > +		pos++;
> > +	}
> > +	if (ssc.num) /* schedule me again */
> > +		schedule_delayed_work(&ssc.gc_work, HZ/10);
We can use schedule_ssc_gc() here.
(It should be defined before this, of course. And can be inlined.)

> "if (ssc.congestion)" would be better ?
> 
> > +	return;
> > +}
> > +
> 

Thanks,
Daisuke Nishimura.
