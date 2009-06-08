Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbZFHGyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbZFHGyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZFHGyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:54:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56677 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZFHGyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:54:00 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH mmotm] vmscan: fix may_swap handling for memcg
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090608153916.3ccaeb9a.nishimura@mxp.nes.nec.co.jp>
References: <20090608121848.4370.A69D9226@jp.fujitsu.com> <20090608153916.3ccaeb9a.nishimura@mxp.nes.nec.co.jp>
Message-Id: <20090608154634.437F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  8 Jun 2009 15:53:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon,  8 Jun 2009 12:20:54 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Hi
> > 
> Hi, thank you for your comment.
> 
> > > From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > > 
> > > Commit 2e2e425989080cc534fc0fca154cae515f971cf5 ("vmscan,memcg: reintroduce
> > > sc->may_swap) add may_swap flag and handle it at get_scan_ratio().
> > > 
> > > But the result of get_scan_ratio() is ignored when priority == 0, and this
> > > means, when memcg hits the mem+swap limit, anon pages can be swapped
> > > just in vain. Especially when memcg causes oom by mem+swap limit,
> > > we can see many and many pages are swapped out.
> > > 
> > > Instead of not scanning anon lru completely when priority == 0, this patch adds
> > > a hook to handle may_swap flag in shrink_page_list() to avoid using useless swaps,
> > > and calls try_to_free_swap() if needed because it can reduce
> > > both mem.usage and memsw.usage if the page(SwapCache) is unused anymore.
> > > 
> > > Such unused-but-managed-under-memcg SwapCache can be made in some paths,
> > > for example trylock_page() failure in free_swap_cache().
> > > 
> > > Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > 
> > I think root cause is following branch, right?
> yes.
> 
> > if so, Why can't we handle this issue on shrink_zone()?
> > 
> Just because priority==0 means oom is about to happen and I don't
> want to see oom if possible.
> So I thought it would be better to reclaim as much pages(memsw.usage) as possible
> in this case.

hmmm..

In general, adding new branch to shrink_page_list() is not good idea.
it can cause performance degression.

Plus, it is not big problem at all. it happen only when priority==0.
Definitely, priority==0 don't occur normally.
and, too many recliaming pages is not only memcg issue. I don't think this
patch provide generic solution.


Why your test environment makes oom so frequently?




