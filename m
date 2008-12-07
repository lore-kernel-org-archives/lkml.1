Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbYLGIb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbYLGIb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 03:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYLGIbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 03:31:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474AbYLGIbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 03:31:50 -0500
Date: Sun, 7 Dec 2008 00:31:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [memcg BUG ?] failed to boot on IA64 with CONFIG_DISCONTIGMEM=y
Message-Id: <20081207003138.2651f14b.akpm@linux-foundation.org>
In-Reply-To: <20081205122458.a37ae8e0.kamezawa.hiroyu@jp.fujitsu.com>
References: <49389B69.9010902@cn.fujitsu.com>
	<20081205122024.3fcc1d0e.kamezawa.hiroyu@jp.fujitsu.com>
	<20081205122458.a37ae8e0.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008 12:24:58 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 5 Dec 2008 12:20:24 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Fri, 05 Dec 2008 11:09:29 +0800
> > Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> > > Kernel version: 2.6.28-rc7
> > > Arch: IA64
> > > Memory model: DISCONTIGMEM
> > > 
> > > ELILO boot: Uncompressing Linux... done
> > > Loading file initrd-2.6.28-rc7-lizf.img...done
> > > (frozen)
> > > 
> > > 
> > > Booted successfully with cgroup_disable=memory, here is the dmesg:
> > > 
> > 
> > thx, will dig into...Maybe you're the first person using DISCONTIGMEM with
> > empty_node after page_cgroup-alloc-at-boot.
> > 
> > How about this ?
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

Why did the kernel fail?

Either __alloc_bootmem_node_nopanic() succeeds, in which case the code
looks like it handles that OK.

Or __alloc_bootmem_node_nopanic() fails this zero-sized allocation, and
the code attempts to handle that, but fails to do so, which might be a
bug, and the above patch just papers over it.

Of course, a full description of the problem will clear all this up.
Better changelogs, please.
