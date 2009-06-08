Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbZFHDVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbZFHDVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 23:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZFHDUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 23:20:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46002 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZFHDUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 23:20:55 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH mmotm] vmscan: fix may_swap handling for memcg
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090608120228.cb70e569.nishimura@mxp.nes.nec.co.jp>
References: <20090608120228.cb70e569.nishimura@mxp.nes.nec.co.jp>
Message-Id: <20090608121848.4370.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  8 Jun 2009 12:20:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> Commit 2e2e425989080cc534fc0fca154cae515f971cf5 ("vmscan,memcg: reintroduce
> sc->may_swap) add may_swap flag and handle it at get_scan_ratio().
> 
> But the result of get_scan_ratio() is ignored when priority == 0, and this
> means, when memcg hits the mem+swap limit, anon pages can be swapped
> just in vain. Especially when memcg causes oom by mem+swap limit,
> we can see many and many pages are swapped out.
> 
> Instead of not scanning anon lru completely when priority == 0, this patch adds
> a hook to handle may_swap flag in shrink_page_list() to avoid using useless swaps,
> and calls try_to_free_swap() if needed because it can reduce
> both mem.usage and memsw.usage if the page(SwapCache) is unused anymore.
> 
> Such unused-but-managed-under-memcg SwapCache can be made in some paths,
> for example trylock_page() failure in free_swap_cache().
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

I think root cause is following branch, right?
if so, Why can't we handle this issue on shrink_zone()?


---------------------------------------------------------------
static void shrink_zone(int priority, struct zone *zone,
                                struct scan_control *sc)
{
        get_scan_ratio(zone, sc, percent);

        for_each_evictable_lru(l) {
                int file = is_file_lru(l);
                unsigned long scan;

                scan = zone_nr_pages(zone, sc, l);
                if (priority) {				// !!here!!
                        scan >>= priority;
                        scan = (scan * percent[file]) / 100;
                }




