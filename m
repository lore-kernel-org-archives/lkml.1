Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZDXBK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZDXBK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 21:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZDXBKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 21:10:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49171 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZDXBKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 21:10:47 -0400
Message-ID: <49F11177.6000709@cn.fujitsu.com>
Date: Fri, 24 Apr 2009 09:10:15 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>
CC: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] cgroup: io-throttle controller (v14)
References: <1240090636-898-1-git-send-email-righi.andrea@gmail.com> <49EC34C1.6010709@cn.fujitsu.com> <20090420144816.GA13307@linux> <49ED1E66.6030604@cn.fujitsu.com> <20090421095848.GB13699@linux> <49EE6E3C.8050409@cn.fujitsu.com> <20090422124328.GA32007@linux> <49EFD948.7050803@cn.fujitsu.com> <20090423101400.GA16768@linux>
In-Reply-To: <20090423101400.GA16768@linux>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> page_cgroup_*_onwer are defined in mm/page_cgroup.c, that is built if
> CONFIG_PAGE_TRACKING=y. But from init/Kconfig:

  page_cgroup_*_onwer also depend on CONFIG_SPARSEMEM, if !defined(CONFIG_SPARSEMEM), 
  they won't be built. So just move them out of CONFIG_SPARSEMEM block.

> 
>   config CGROUP_IO_THROTTLE
>   	bool "Enable cgroup I/O throttling"
>   	depends on CGROUPS && RESOURCE_COUNTERS && EXPERIMENTAL
>   	select MM_OWNER
>   	select PAGE_TRACKING
> 	       ^^^^^^^^^^^^^
> mmmh??? it should be correct.
> 
> And I don't understand how the following patch can fix this problem...
> 
> Could you post your .config?
> 
> Thanks,
> -Andrea
> 
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  mm/page_cgroup.c |   65 ++++++++++++++++++++++++++---------------------------
>>  1 files changed, 32 insertions(+), 33 deletions(-)
>>
>> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
>> index b3b394c..9c392f1 100644
>> --- a/mm/page_cgroup.c
>> +++ b/mm/page_cgroup.c
>> @@ -244,6 +244,38 @@ static int __meminit page_cgroup_callback(struct notifier_block *self,
>>  
>>  #endif
>>  
>> +void __init page_cgroup_init(void)
>> +{
>> +	unsigned long pfn;
>> +	int fail = 0;
>> +
>> +	if (mem_cgroup_disabled() && iothrottle_disabled())
>> +		return;
>> +
>> +	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
>> +		if (!pfn_present(pfn))
>> +			continue;
>> +		fail = init_section_page_cgroup(pfn);
>> +	}
>> +	if (fail) {
>> +		printk(KERN_CRIT
>> +			"try cgroup_disable=memory,blockio boot option\n");
>> +		panic("Out of memory");
>> +	} else {
>> +		hotplug_memory_notifier(page_cgroup_callback, 0);
>> +	}
>> +	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
>> +	printk(KERN_INFO
>> +		"try cgroup_disable=memory,blockio option if you don't want\n");
>> +}
>> +
>> +void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
>> +{
>> +	return;
>> +}
>> +
>> +#endif
>> +
>>  /**
>>   * page_cgroup_get_owner() - get the owner ID of a page
>>   * @page:	the page we want to find the owner
>> @@ -317,39 +349,6 @@ int page_cgroup_copy_owner(struct page *npage, struct page *opage)
>>  	return 0;
>>  }
>>  
>> -void __init page_cgroup_init(void)
>> -{
>> -	unsigned long pfn;
>> -	int fail = 0;
>> -
>> -	if (mem_cgroup_disabled() && iothrottle_disabled())
>> -		return;
>> -
>> -	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
>> -		if (!pfn_present(pfn))
>> -			continue;
>> -		fail = init_section_page_cgroup(pfn);
>> -	}
>> -	if (fail) {
>> -		printk(KERN_CRIT
>> -			"try cgroup_disable=memory,blockio boot option\n");
>> -		panic("Out of memory");
>> -	} else {
>> -		hotplug_memory_notifier(page_cgroup_callback, 0);
>> -	}
>> -	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
>> -	printk(KERN_INFO
>> -		"try cgroup_disable=memory,blockio option if you don't want\n");
>> -}
>> -
>> -void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
>> -{
>> -	return;
>> -}
>> -
>> -#endif
>> -
>> -
>>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
>>  
>>  static DEFINE_MUTEX(swap_cgroup_mutex);
>> -- 
>> 1.5.4.rc3
> 
> 
> 

-- 
Regards
Gui Jianfeng

