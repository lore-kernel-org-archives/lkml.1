Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbXGMMh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbXGMMh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbXGMMhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:37:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28967 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbXGMMhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:37:19 -0400
Message-ID: <469771F2.6000901@oracle.com>
Date: Fri, 13 Jul 2007 18:07:06 +0530
From: gurudas pai <gurudas.pai@oracle.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joe Jin <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>	<20070712221842.f5e47065.akpm@linux-foundation.org>	<20070713064004.GA21833@joejin-pc.cn.oracle.com>	<20070712234938.c77f3a48.akpm@linux-foundation.org>	<4697320D.1060703@oracle.com> <20070713011924.75e6afd4.akpm@linux-foundation.org>
In-Reply-To: <20070713011924.75e6afd4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>>>>> On Fri, 13 Jul 2007 10:45:07 +0800 Joe Jin <joe.jin@oracle.com> wrote:
>>>>>
>>>>> Something like this?
>>>>>
>>>>> --- a/mm/hugetlb.c~a
>>>>> +++ a/mm/hugetlb.c
>>>>> @@ -105,13 +105,20 @@ static void free_huge_page(struct page *
>>>>>  
>>>>>  static int alloc_fresh_huge_page(void)
>>>>>  {
>>>>> -	static int nid = 0;
>>>>> +	static int prev_nid;
>>>>> +	static DEFINE_SPINLOCK(nid_lock);
>>>>>  	struct page *page;
>>>>> -	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
>>>>> -					HUGETLB_PAGE_ORDER);
>>>>> -	nid = next_node(nid, node_online_map);
>>>>> +	int nid;
>>>>> +
>>>>> +	spin_lock(&nid_lock);
>>>>> +	nid = next_node(prev_nid, node_online_map);
>>>>>  	if (nid == MAX_NUMNODES)
>>>>>  		nid = first_node(node_online_map);
>>>>> +	prev_nid = nid;
>>>>> +	spin_unlock(&nid_lock);
>>>>> +
>>>>> +	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
>>>>> +					HUGETLB_PAGE_ORDER);
>>>>>  	if (page) {
>>>>>  		set_compound_page_dtor(page, free_huge_page);
>>>>>  		spin_lock(&hugetlb_lock);
>>>>> _
>>>>>
>> I think this will never get pages from node 0 ? Because nid = 
>> next_node(prev_node,node_online_map) and even if prev_node = 0, nid will 
>> become 1.
>
> It'll start out at node 1.  But it will visit the final node (which is less
> than MAX_NUMNODES) and will then advance onto the fist node (which can be
>> = 0).
>
> This code needs a bit of thought and testing for the non-numa case too
> please.  At the least, there might be optimisation opportunities.
I tested on non-numa machine. Your patch works fine.

Thanks,
-Guru


