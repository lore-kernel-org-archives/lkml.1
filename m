Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZESI2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZESI2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbZESI2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:28:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38815 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbZESI2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:28:31 -0400
Message-ID: <8c90ea703295420e2fac0a2744d1816a.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090519105028.8ce4f8da.nishimura@mxp.nes.nec.co.jp>
References: <20090515190027.e7d48d7a.kamezawa.hiroyu@jp.fujitsu.com>
    <20090519105028.8ce4f8da.nishimura@mxp.nes.nec.co.jp>
Date: Tue, 19 May 2009 17:28:30 +0900 (JST)
Subject: Re: [PATCH] memcg: handle accounting race in swapin-readahead and
 zap_pte
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>, hannes@cmpxchg.org,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       nishimura@mxp.nes.nec.co.jp
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura wrote:
> On Fri, 15 May 2009 19:00:27 +0900, KAMEZAWA Hiroyuki
>-------------------------------------+-------------------------------------
>                                        |  trylock_page()
>                                        |    try_to_free_swap()
>                                        |      page_swapcount() -> true &
> return
>      swap_info_get()                   |
>        swap_entry_free() == 1          |
>        find_get_page() -> found        |
>        trylock_page() -> fail & return |
>                                        |    unlock_page()
>
> I don't think it happens in practice(unlock_page() would be called soon
> after
> try_to_free_swap() returns), and this patch seems to work well actually.
> I'm not sure whether we should handle this case more strictly or not, but
> I think
> it it would be better to add some comments about it at least.
>
Hmm, ok. maybe trylock in free_swap_and_cache() is the worst thing as
Andrew pointed out...

> And I have a question.
>
> If the size of swap device(or the number of used swap entries not on
> SwapCache)
> is small enough not to hit "if (memcg_swapin_buffer.nr >
> ENOUGH_LARGE_SWAPIN_BUFFER)"
> in mem_cgroup_add_swapin_buffer(), those pages in swapin buffer
> are left and unfreed by swapoff(although swap entries are freed) ?
> Isn't it better to call directly mem_cgroup_drain_swapin_buffer() at the
> end of swapoff ?
>
Hmm, maybe necessary.

> I prefer your v4(remembering only stale swap entries) to be honest,
> but I don't oppose strongly to this direction.
>
I can't believe I can handle complex race with "rememebering only stale".
I'll try to remove trylock in free_swap_and_cache...

Thank you for testing.
-Kmae

