Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbZEHQ0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbZEHQ0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZEHQ0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:26:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46334 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbZEHQ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:26:30 -0400
Message-ID: <a369eb83999c47faac2bc894c2f43a9d.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090508113820.GL11596@elte.hu>
References: <20090508140528.c34ae712.kamezawa.hiroyu@jp.fujitsu.com>
    <20090508140910.bb07f5c6.kamezawa.hiroyu@jp.fujitsu.com>
    <20090508113820.GL11596@elte.hu>
Date: Sat, 9 May 2009 01:26:28 +0900 (JST)
Subject: Re: [PATCH 2/2] memcg fix stale swap cache account leak v6
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for review.

Ingo Molnar wrote:
> x
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> +struct swapio_check {
>> +	spinlock_t	lock;
>> +	void		*swap_bio_list;
>> +	struct delayed_work work;
>> +} stale_swap_check;
>
> Small nit. It's nice that you lined up the first two fields, but it
> would be nice to line up the third one too:
>
> struct swapio_check {
> 	spinlock_t		lock;
> 	void			*swap_bio_list;
> 	struct delayed_work	work;
> } stale_swap_check;
>
ok.

>> +	while (nr--) {
>> +		cond_resched();
>> +		spin_lock_irq(&sc->lock);
>> +		bio = sc->swap_bio_list;
>
>> @@ -66,6 +190,7 @@ static void end_swap_bio_write(struct bi
>>  				(unsigned long long)bio->bi_sector);
>>  		ClearPageReclaim(page);
>>  	}
>> +	mem_cgroup_swapio_check_again(bio, page);
>
> Hm, this patch adds quite a bit of scanning overhead to
> end_swap_bio_write(), to work around artifacts of a global LRU not
> working well with a partitioned system's per-partition LRU needs.
>
I'm not sure what is "scanning" overhead. But ok, this is not very light.

> Isnt the right solution to have a better LRU that is aware of this,
> instead of polling around in the hope of cleaning up stale entries?
>
I tried to modify LRU in the last month but I found it's difficult.

Hmm, maybe this patch's method is overkill. I have another option
(used in v1-v2) for fixing writeback. I'll try following again.

== add following codes to vmscan.c ==

   shrink_list()
      add_to_swap().
      memcg_confirm_swapcache_valid()
   -> We have race with zap_pte() here.
      After add_to_swap(), check account information of memcg.
      If memcg doesn't have account on this page, this page may
      be unused and not worth to do I/O. check usage again and
      try to free it.
==

The difficult part is how to fix race in swapin-readahead and we have
several option to fix writeback, I think.

I'll retry.

Thanks,
-Kame


