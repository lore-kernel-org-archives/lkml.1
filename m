Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbZFLPDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbZFLPDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZFLPCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:02:53 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:40771 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZFLPCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:02:53 -0400
Message-ID: <4A326E16.2000001@linux.vnet.ibm.com>
Date: Fri, 12 Jun 2009 20:32:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hannes@cmpxchg.org, torvalds@linux-foundation.org,
       yinghai@kernel.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: boot panic with memcg enabled (Was [PATCH 3/4] memcg: don't use
 bootmem allocator in setup code)
References: <Pine.LNX.4.64.0906110820170.2258@melkki.cs.Helsinki.FI> <4A31C258.2050404@cn.fujitsu.com>
In-Reply-To: <4A31C258.2050404@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> (This patch should have CCed memcg maitainers)
> 
> My box failed to boot due to initialization failure of page_cgroup, and
> it's caused by this patch:
> 
> +	page = alloc_pages_node(nid, GFP_NOWAIT | __GFP_ZERO, order);
> 
> I added a printk, and found that order == 11 == MAX_ORDER.
> 
> Pekka J Enberg wrote:
>> From: Yinghai Lu <yinghai@kernel.org>
>>
>> The bootmem allocator is no longer available for page_cgroup_init() because we
>> set up the kernel slab allocator much earlier now.
>>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
>> ---
>>  mm/page_cgroup.c |   12 ++++++++----
>>  1 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
>> index 791905c..3dd4a90 100644
>> --- a/mm/page_cgroup.c
>> +++ b/mm/page_cgroup.c
>> @@ -47,6 +47,8 @@ static int __init alloc_node_page_cgroup(int nid)
>>  	struct page_cgroup *base, *pc;
>>  	unsigned long table_size;
>>  	unsigned long start_pfn, nr_pages, index;
>> +	struct page *page;
>> +	unsigned int order;
>>  
>>  	start_pfn = NODE_DATA(nid)->node_start_pfn;
>>  	nr_pages = NODE_DATA(nid)->node_spanned_pages;
>> @@ -55,11 +57,13 @@ static int __init alloc_node_page_cgroup(int nid)
>>  		return 0;
>>  
>>  	table_size = sizeof(struct page_cgroup) * nr_pages;
>> -
>> -	base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
>> -			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
>> -	if (!base)
>> +	order = get_order(table_size);
>> +	page = alloc_pages_node(nid, GFP_NOWAIT | __GFP_ZERO, order);
>> +	if (!page)
>> +		page = alloc_pages_node(-1, GFP_NOWAIT | __GFP_ZERO, order);

This should potentially come with a KERN_WARNING indicating the page_cgroup now
is allocated out of the current node rather than the desired node. It'll help
debug potential issues later.

>> +	if (!page)
>>  		return -ENOMEM;
>> +	base = page_address(page);
>>  	for (index = 0; index < nr_pages; index++) {
>>  		pc = base + index;
>>  		__init_page_cgroup(pc, start_pfn + index);

Looks good to me, does it work for you, Yinghai? Kamezawa-San  could you take a look


-- 
	Balbir
