Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbYIIMZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbYIIMZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYIIMZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:25:09 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:34987 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYIIMZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:25:07 -0400
Message-ID: <48C66AF8.5070505@linux.vnet.ibm.com>
Date: Tue, 09 Sep 2008 05:24:24 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
References: <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com> <200809091358.28350.nickpiggin@yahoo.com.au> <20080909135317.cbff4871.kamezawa.hiroyu@jp.fujitsu.com> <200809091500.10619.nickpiggin@yahoo.com.au> <20080909141244.721dfd39.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080909141244.721dfd39.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 9 Sep 2008 15:00:10 +1000
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>>> maybe a routine like SPARSEMEM is a choice.
>>>
>>> Following is pointer pre-allocation. (just pointer, not page_cgroup itself)
>>> ==
>>> #define PCG_SECTION_SHIFT	(10)
>>> #define PCG_SECTION_SIZE	(1 << PCG_SECTION_SHIFT)
>>>
>>> struct pcg_section {
>>> 	struct page_cgroup **map[PCG_SECTION_SHIFT]; //array of pointer.
>>> };
>>>
>>> struct page_cgroup *get_page_cgroup(unsigned long pfn)
>>> {
>>> 	struct pcg_section *sec;
>>> 	sec = pcg_section[(pfn >> PCG_SECTION_SHIFT)];
>>> 	return *sec->page_cgroup[(pfn & ((1 << PCG_SECTTION_SHIFT) - 1];
>>> }
>>> ==
>>> If we go extreme, we can use kmap_atomic() for pointer array.
>>>
>>> Overhead of pointer-walk is not so bad, maybe.
>>>
>>> For 64bit systems, we can find a way like SPARSEMEM_VMEMMAP.
>> Yes I too think that would be the ideal way to go to get the best of
>> performance in the enabled case. However Balbir I believe is interested
>> in memory savings if not all pages have cgroups... I don't know, I don't
>> care so much about the "enabled" case, so I'll leave you two to fight it
>> out :)
>>
> I'll add a new patch on my set.
> 
> Balbir, are you ok to CONFIG_CGROUP_MEM_RES_CTLR depends on CONFIG_SPARSEMEM ?
> I thinks SPARSEMEM(SPARSEMEM_VMEMMAP) is widely used in various archs now.

Can't we make it more generic. I was thinking of allocating memory for each node
for page_cgroups (of the size of spanned_pages) at initialization time. I've not
yet prototyped the idea. BTW, even with your approach I fail to see why we need
to add a dependency on CONFIG_SPARSEMEM (but again it is 4:30 in the morning and
I might be missing the obvious)

-- 
	Balbir
