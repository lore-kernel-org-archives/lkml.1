Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbYLEDdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbYLEDdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbYLEDc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:32:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51540 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYLEDc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:32:57 -0500
Message-ID: <4938A088.1090205@cn.fujitsu.com>
Date: Fri, 05 Dec 2008 11:31:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [memcg BUG ?] failed to boot on IA64 with CONFIG_DISCONTIGMEM=y
References: <49389B69.9010902@cn.fujitsu.com>	<20081205122024.3fcc1d0e.kamezawa.hiroyu@jp.fujitsu.com> <20081205122458.a37ae8e0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081205122458.a37ae8e0.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 5 Dec 2008 12:20:24 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
>> On Fri, 05 Dec 2008 11:09:29 +0800
>> Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>>> Kernel version: 2.6.28-rc7
>>> Arch: IA64
>>> Memory model: DISCONTIGMEM
>>>
>>> ELILO boot: Uncompressing Linux... done
>>> Loading file initrd-2.6.28-rc7-lizf.img...done
>>> (frozen)
>>>
>>>
>>> Booted successfully with cgroup_disable=memory, here is the dmesg:
>>>
>> thx, will dig into...Maybe you're the first person using DISCONTIGMEM with
>> empty_node after page_cgroup-alloc-at-boot.
>>

I was reading the code in page_cgroup.c, and It came to my mind that maybe
no one ever tried DISCONTIGMEM+memcg, so I had it a try..

>> How about this ?
> 
> Ahhh..sorry.
> 
> this one please.
> ==
> 
> From: kamezawa.hiroyu@jp.fujitsu.com
> 
> page_cgroup should ignore empty-nodes.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

Now it booted successfully. :)

Tested-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
>  mm/page_cgroup.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: mmotm-2.6.28-Dec03/mm/page_cgroup.c
> ===================================================================
> --- mmotm-2.6.28-Dec03.orig/mm/page_cgroup.c
> +++ mmotm-2.6.28-Dec03/mm/page_cgroup.c
> @@ -51,6 +51,9 @@ static int __init alloc_node_page_cgroup
>  	start_pfn = NODE_DATA(nid)->node_start_pfn;
>  	nr_pages = NODE_DATA(nid)->node_spanned_pages;
>  
> +	if (!nr_pages)
> +		return 0;
> +
>  	table_size = sizeof(struct page_cgroup) * nr_pages;
>  
>  	base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
> 
> 
