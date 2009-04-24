Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbZDXGZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbZDXGZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZDXGZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:25:12 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62034 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZDXGZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:25:10 -0400
Date: Fri, 24 Apr 2009 15:21:03 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>
Subject: Re: [RFC][PATCH] fix swap entries is not reclaimed in proper way
 for mem+swap controller
Message-Id: <20090424152103.a5ee8d13.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090424133306.0d9fb2ce.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090421162121.1a1d15fe.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422143833.2e11e10b.nishimura@mxp.nes.nec.co.jp>
	<20090424133306.0d9fb2ce.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 13:33:06 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 22 Apr 2009 14:38:33 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> > >  extern void mem_cgroup_uncharge_swap(swp_entry_t ent);
> > > +extern void mem_cgroup_mark_swapcache_stale(struct page *page);
> > > +extern void mem_cgroup_fixup_swapcache(struct page *page);
> > >  #else
> > >  static inline void mem_cgroup_uncharge_swap(swp_entry_t ent)
> > >  {
> > >  }
> > > +static void mem_cgroup_check_mark_swapcache_stale(struct page *page)
> > > +{
> > > +}
> > > +static void mem_cgroup_fixup_swapcache(struct page *page)
> > > +{
> > > +}
> > >  #endif
> > >  
> > I think they should be defined in MEM_RES_CTLR case.
> > Exhausting swap entries problem is not depend on MEM_RES_CTLR_SWAP.
> > 
> Could you explain this more ? I can't understand.
> 
STALE(!PageCgroupUsed) SwapCache *without owner process* can be created by
the race between exit()..free_swap_and_cache() and read_swap_cache_async()(type-1)
or between exit()..page_remove_rmap() and shrink_page_list()(type-2).
(I don't think STALE SwapCache itself is problematic as long as there is
an actual user of the SwapCache.)

Those NOUSER STALE SwapCache are NOT depend on MEM_RES_CTLR_SWAP.

If total_swap_size is small enough not to trigger global LRU scan,
all swap space can be used up.
I confirmed before that all swap space were used up(and caused oom)
with mem.limit=32M/total_swap_size=50M.


Thanks,
Daisuke Nishimura.
