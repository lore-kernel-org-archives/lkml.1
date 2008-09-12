Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYILQNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYILQNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 12:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYILQNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 12:13:35 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:58405 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754799AbYILQNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 12:13:34 -0400
Message-ID: <48CA9500.5060309@linux.vnet.ibm.com>
Date: Fri, 12 Sep 2008 09:12:48 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "xemul@openvz.org" <xemul@openvz.org>,
       "hugh@veritas.com" <hugh@veritas.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [RFC] [PATCH 8/9] memcg: remove page_cgroup pointer from memmap
References: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com> <20080911202249.df6026ae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080911202249.df6026ae.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Remove page_cgroup pointer from struct page.
> 
> This patch removes page_cgroup pointer from struct page and make it be able
> to get from pfn. Then, relationship of them is
> 
> Before this:
>   pfn <-> struct page <-> struct page_cgroup.
> After this:
>   struct page <-> pfn -> struct page_cgroup -> struct page.
> 
> Benefit of this approach is we can remove 8(4) bytes from struct page.
> 
> Other changes are:
>   - lock/unlock_page_cgroup() uses its own bit on struct page_cgroup.
>   - all necessary page_cgroups are allocated at boot.
> 
> Characteristics:
>   - page cgroup is allocated as some amount of chunk.
>     This patch uses SECTION_SIZE as size of chunk if 64bit/SPARSEMEM is enabled.
>     If not, appropriate default number is selected.
>   - all page_cgroup struct is maintained by hash. 
>     I think we have 2 ways to handle sparse index in general
>     ...radix-tree and hash. This uses hash because radix-tree's layout is
>     affected by memory map's layout.
>   - page_cgroup.h/page_cgroup.c is added.
> 
> TODO:
>   - memory hotplug support. (not difficult)

Kamezawa,

I feel we can try the following approaches

1. Try per-node per-zone radix tree with dynamic allocation
2. Try the approach you have
3. Integrate with sparsemem (last resort for performance), Dave Hansen suggested
adding a mem_section member and using that.

I am going to try #1 today and see what the performance looks like


-- 
	Balbir
