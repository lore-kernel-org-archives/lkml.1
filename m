Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbZE3LRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbZE3LRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbZE3LQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:16:53 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53909 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbZE3LQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:16:52 -0400
Message-ID: <c22c9214cc3a6fcf2224fa556f5558b1.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090530061008.GE24073@balbir.in.ibm.com>
References: <20090528135455.0c83bedc.kamezawa.hiroyu@jp.fujitsu.com>
    <20090528141900.c93fe1d5.kamezawa.hiroyu@jp.fujitsu.com>
    <20090530061008.GE24073@balbir.in.ibm.com>
Date: Sat, 30 May 2009 20:16:51 +0900 (JST)
Subject: Re: [PATCH 2/4] modify swap_map and add SWAP_HAS_CACHE flag.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
>>  #define SWAP_CLUSTER_MAX 32
>>
>> -#define SWAP_MAP_MAX	0x7fff
>> -#define SWAP_MAP_BAD	0x8000
>> -
>> +#define SWAP_MAP_MAX	0x7ffe
>> +#define SWAP_MAP_BAD	0x7fff
>> +#define SWAP_HAS_CACHE  0x8000		/* There is a swap cache of entry. */
>
> Why count, can't we use swp->flags?
>

Hmm ? swap_map just only a "unsiged short" value per entry..sorry,
I can't catch what you mention to.


>> +#define SWAP_COUNT_MASK (~SWAP_HAS_CACHE)
>>  /*
>>   * The in-memory structure used to track swap areas.
>>   */
>> @@ -300,7 +301,7 @@ extern long total_swap_pages;
>>  extern void si_swapinfo(struct sysinfo *);
>>  extern swp_entry_t get_swap_page(void);
>>  extern swp_entry_t get_swap_page_of_type(int);
>> -extern int swap_duplicate(swp_entry_t);
>> +extern void swap_duplicate(swp_entry_t);
>>  extern int swapcache_prepare(swp_entry_t);
>>  extern int valid_swaphandles(swp_entry_t, unsigned long *);
>>  extern void swap_free(swp_entry_t);
>> @@ -372,9 +373,12 @@ static inline void show_swap_cache_info(
>>  }
>>
>>  #define free_swap_and_cache(swp)	is_migration_entry(swp)
>> -#define swap_duplicate(swp)		is_migration_entry(swp)
>>  #define swapcache_prepare(swp)		is_migration_entry(swp)
>>
>> +static inline void swap_duplicate(swp_entry_t swp)
>> +{
>> +}
>> +
>>  static inline void swap_free(swp_entry_t swp)
>>  {
>>  }
>> Index: new-trial-swapcount2/mm/swapfile.c
>> ===================================================================
>> --- new-trial-swapcount2.orig/mm/swapfile.c
>> +++ new-trial-swapcount2/mm/swapfile.c
>> @@ -53,6 +53,26 @@ static struct swap_info_struct swap_info
>>
>>  static DEFINE_MUTEX(swapon_mutex);
>>
>> +/* For reference count accounting in swap_map */
>> +static inline int swap_count(unsigned short ent)
>> +{
>> +	return ent & SWAP_COUNT_MASK;
>> +}
>> +
>> +static inline int swap_has_cache(unsigned short ent)
>> +{
>> +	return ent & SWAP_HAS_CACHE;
>> +}
>> +
>> +static inline unsigned short make_swap_count(int count, int has_cache)
>> +{
>> +	unsigned short ret = count;
>> +
>> +	if (has_cache)
>> +		return SWAP_HAS_CACHE | ret;
>> +	return ret;
>> +}
>
> make_swap_count() does not make too much sense in terms of the name
> for the function. Should it be called generate_swap_count or
> assign_swap_count_info?

Hmm ? ok, rename this as generate_swap_count(). or
generate_swapmap_info().



>> +
>>  /*
>>   * We need this because the bdev->unplug_fn can sleep and we cannot
>>   * hold swap_lock while calling the unplug_fn. And swap_lock
>> @@ -167,7 +187,8 @@ static int wait_for_discard(void *word)
>>  #define SWAPFILE_CLUSTER	256
>>  #define LATENCY_LIMIT		256
>>
>> -static inline unsigned long scan_swap_map(struct swap_info_struct *si)
>> +static inline unsigned long scan_swap_map(struct swap_info_struct *si,
>> +					  int cache)
>
> Can we please use bool for readability or even better an enum?
>
ok, enum.

> Looks good at first glance otherwise. I think distinguishing between
> the counts is good, but also complex. Overall the patch is useful.
>
Thank you for review.

-Kame

> --
> 	Balbir
>


