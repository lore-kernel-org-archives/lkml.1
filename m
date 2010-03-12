Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab0CLKHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:07:33 -0500
Received: from trinity.develer.com ([83.149.158.210]:39224 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab0CLKHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:07:30 -0500
Date: Fri, 12 Mar 2010 11:07:27 +0100
From: Andrea Righi <arighi@develer.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 0/5] memcg: per cgroup dirty limit (v6)
Message-ID: <20100312100727.GC4438@linux>
References: <1268175636-4673-1-git-send-email-arighi@develer.com>
 <20100311093913.07c9ca8a.kamezawa.hiroyu@jp.fujitsu.com>
 <20100311101726.f58d24e9.kamezawa.hiroyu@jp.fujitsu.com>
 <1268298865.5279.997.camel@twins>
 <20100311182500.0f3ba994.kamezawa.hiroyu@jp.fujitsu.com>
 <20100311184244.6735076a.kamezawa.hiroyu@jp.fujitsu.com>
 <20100312101411.b2639128.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312101411.b2639128.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 10:14:11AM +0900, Daisuke Nishimura wrote:
> On Thu, 11 Mar 2010 18:42:44 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Thu, 11 Mar 2010 18:25:00 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > Then, it's not problem that check pc->mem_cgroup is root cgroup or not
> > > without spinlock.
> > > ==
> > > void mem_cgroup_update_stat(struct page *page, int idx, bool charge)
> > > {
> > > 	pc = lookup_page_cgroup(page);
> > > 	if (unlikely(!pc) || mem_cgroup_is_root(pc->mem_cgroup))
> > > 		return;	
> > > 	...
> > > }
> > > ==
> > > This can be handle in the same logic of "lock failure" path.
> > > And we just do ignore accounting.
> > > 
> > > There are will be no spinlocks....to do more than this,
> > > I think we have to use "struct page" rather than "struct page_cgroup".
> > > 
> > Hmm..like this ? The bad point of this patch is that this will corrupt FILE_MAPPED
> > status in root cgroup. This kind of change is not very good.
> > So, one way is to use this kind of function only for new parameters. Hmm.
> IMHO, if we disable accounting file stats in root cgroup, it would be better
> not to show them in memory.stat to avoid confusing users.

Or just show the same values that we show in /proc/meminfo.. (I mean,
not actually the same, but coherent with them).

> But, hmm, I think accounting them in root cgroup isn't so meaningless.
> Isn't making mem_cgroup_has_dirty_limit() return false in case of root cgroup enough?

Agreed. Returning false from mem_cgroup_has_dirty_limit() is enough to
always use global stats for the writeback, so this shouldn't introduce
any overhead for the root cgroup (at least for this part).

-Andrea
