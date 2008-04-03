Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbYDCHxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbYDCHxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926AbYDCHxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:53:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50772 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758513AbYDCHxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:53:08 -0400
Message-ID: <47F48C69.2080805@cn.fujitsu.com>
Date: Thu, 03 Apr 2008 15:51:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/3] cgroup: use a hash table for css_set finding
References: <47F470AB.2070904@cn.fujitsu.com> <20080403162459.4a90d574.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080403162459.4a90d574.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 03 Apr 2008 13:52:43 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
>> +/* hash table for cgroup groups. This improves the performance to
>> + * find an existing css_set */
>> +#define CSS_SET_HASH_BITS	7
>> +#define CSS_SET_TABLE_SIZE	(1 << CSS_SET_HASH_BITS)
>> +static struct hlist_head css_set_table[CSS_SET_TABLE_SIZE];
> 
> How above number is selected ?
> 

I suppose 100 will be suitable, so i would like to choose from 6 or 7 bits.

>> +static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
>> +{
>> +	int i;
>> +	int index;
>> +	unsigned long tmp = 0UL;
>> +
>> +	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
>> +		tmp += (unsigned long)css[i];
>> +
> 
> maybe css[i]'s lower 2-3 bits will be ignored. because thery are always 0.
> 
> And I don't like "+" for hash. how about
> ==
> 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
> 	unsigned long x;
> 	x = (unsigned long)css[i];
> 	tmp = (x >> 16) ^ (x & 0xffff)
> ==
> or some func, which uses full bits.
> 

I'm using hash_long(), which has been proved to be a good one. And I've tested
css_set_hash(), I run the css_set benchmark with N == 1000, the for loop in
find_existing_css_set() will break out within 10 iterations for most cases, 
which is the expected result.

> 
>> +	index = hash_long(tmp, CSS_SET_HASH_BITS);
>> +
>> +	return &css_set_table[index];
>> +}
>> +
>>  /* We don't maintain the lists running through each css_set to its
>>   * task until after the first call to cgroup_iter_start(). This
>>   * reduces the fork()/exit() overhead for people who have cgroups
>> @@ -219,6 +240,7 @@ static int use_task_css_set_links;
>>  static void unlink_css_set(struct css_set *cg)
>>  {
>>  	write_lock(&css_set_lock);
>> +	hlist_del(&cg->hlist);
>>  	list_del(&cg->list);
>>  	css_set_count--;
> 
> This css_set_lock is worth to be rwlock ?
> how about per hashline spinlock ? (but per-hashline seems overkill..)
> 

I think it's an overkill. And the css_set_lock protects not only the hash
table.

Thanks for looking into this. :)

Regards,
Li Zefan

