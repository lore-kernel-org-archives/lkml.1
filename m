Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbZFHII1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbZFHII1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZFHIIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:08:15 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36688 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZFHIIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:08:14 -0400
Date: Mon, 8 Jun 2009 16:54:57 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH mmotm] vmscan: fix may_swap handling for memcg
Message-Id: <20090608165457.fa8d17e6.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090608154634.437F.A69D9226@jp.fujitsu.com>
References: <20090608121848.4370.A69D9226@jp.fujitsu.com>
	<20090608153916.3ccaeb9a.nishimura@mxp.nes.nec.co.jp>
	<20090608154634.437F.A69D9226@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  8 Jun 2009 15:53:50 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > On Mon,  8 Jun 2009 12:20:54 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > Hi
> > > 
> > Hi, thank you for your comment.
> > 
> > > > From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > > > 
> > > > Commit 2e2e425989080cc534fc0fca154cae515f971cf5 ("vmscan,memcg: reintroduce
> > > > sc->may_swap) add may_swap flag and handle it at get_scan_ratio().
> > > > 
> > > > But the result of get_scan_ratio() is ignored when priority == 0, and this
> > > > means, when memcg hits the mem+swap limit, anon pages can be swapped
> > > > just in vain. Especially when memcg causes oom by mem+swap limit,
> > > > we can see many and many pages are swapped out.
> > > > 
> > > > Instead of not scanning anon lru completely when priority == 0, this patch adds
> > > > a hook to handle may_swap flag in shrink_page_list() to avoid using useless swaps,
> > > > and calls try_to_free_swap() if needed because it can reduce
> > > > both mem.usage and memsw.usage if the page(SwapCache) is unused anymore.
> > > > 
> > > > Such unused-but-managed-under-memcg SwapCache can be made in some paths,
> > > > for example trylock_page() failure in free_swap_cache().
> > > > 
> > > > Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > > 
> > > I think root cause is following branch, right?
> > yes.
> > 
> > > if so, Why can't we handle this issue on shrink_zone()?
> > > 
> > Just because priority==0 means oom is about to happen and I don't
> > want to see oom if possible.
> > So I thought it would be better to reclaim as much pages(memsw.usage) as possible
> > in this case.
> 
> hmmm..
> 
> In general, adding new branch to shrink_page_list() is not good idea.
> it can cause performance degression.
> 
> Plus, it is not big problem at all. it happen only when priority==0.
> Definitely, priority==0 don't occur normally.
But it happens under high memory pressure...

> and, too many recliaming pages is not only memcg issue. I don't think this
> patch provide generic solution.
> 
Ah, you're right. It's not only memcg issue.

> 
> Why your test environment makes oom so frequently?
> 
Not so frequently :)
But I can see almost all of pages are swapped-out when memcg causes oom
by memsw.limit(it's a waste of cpu time).
And even after Kamezawa-san's memcg-fix-behavior-under-memorylimit-equals-to-memswlimit.patch,
I can sometimes see swap usage when mem.limit==memsw.limit(it's a waste of cpu time too).


Thanks,
Daisuke Nishimura.
