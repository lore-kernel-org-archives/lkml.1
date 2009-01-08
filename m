Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbZAHK7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbZAHK7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZAHK7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:59:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40140 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZAHK7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:59:09 -0500
Message-ID: <36699.10.75.179.62.1231412340.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090108191430.af89e037.nishimura@mxp.nes.nec.co.jp>
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
    <20090108191430.af89e037.nishimura@mxp.nes.nec.co.jp>
Date: Thu, 8 Jan 2009 19:59:00 +0900 (JST)
Subject: Re: [RFC][PATCH 1/4] memcg: fix 
     formem_cgroup_get_reclaim_stat_from_page
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura said:

>     Call Trace:
>      [<ffffffff8028ea17>] ? ____pagevec_lru_add+0xc1/0x13c
>      [<ffffffff8028ec34>] ? drain_cpu_pagevecs+0x36/0x89
>      [<ffffffff802a4f8c>] ? swapin_readahead+0x78/0x98
>      [<ffffffff8029a37a>] ? handle_mm_fault+0x3d9/0x741
>      [<ffffffff804da654>] ? do_page_fault+0x3ce/0x78c
>      [<ffffffff804d7a42>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>      [<ffffffff804d860f>] ? page_fault+0x1f/0x30
>     Code: cc 55 48 8d af b8 0d 00 00 48 89 f7 53 89 d3 e8 39 85 02 00 48
> 63 d3 48 ff 44 d5 10 45 85 e4 74 05 48 ff 44 d5 00 48 85 c0 74 0e <48>
> ff 44 d0 10 45 85 e4 74 04 48 ff 04 d0 5b 5d 41 5c c3 41 54
>     RIP  [<ffffffff8028e710>] update_page_reclaim_stat+0x2f/0x42
>      RSP <ffff8801ee457da8>
>
>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
yes. PageCgroupUsed() should be cheked.
or
list_empty(&pc->lru) should be checked under zone->lock.
Your fix seems reasonable.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  mm/memcontrol.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e2996b8..62e69d8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -559,6 +559,10 @@ mem_cgroup_get_reclaim_stat_from_page(struct page
> *page)
>  		return NULL;
>
>  	pc = lookup_page_cgroup(page);
> +	smp_rmb();
> +	if (!PageCgroupUsed(pc))
> +		return NULL;
> +
>  	mz = page_cgroup_zoneinfo(pc);
>  	if (!mz)
>  		return NULL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


