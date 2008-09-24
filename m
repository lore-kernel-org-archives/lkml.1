Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbYIXIda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbYIXIda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYIXIdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:33:16 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:44994 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYIXIdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:33:14 -0400
Message-ID: <48D9FAFF.8070404@linux.vnet.ibm.com>
Date: Wed, 24 Sep 2008 01:31:59 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/13] memcg: lookup page cgroup (and remove pointer from
 struct page)
References: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com> <20080922201206.e73d9ce6.kamezawa.hiroyu@jp.fujitsu.com> <20080924084839.f5901719.kamezawa.hiroyu@jp.fujitsu.com> <661de9470809231909h24ca4a39k470e322f2c1019dc@mail.gmail.com> <20080924120940.5aea6907.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080924120940.5aea6907.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 24 Sep 2008 07:39:58 +0530
> "Balbir Singh" <balbir@linux.vnet.ibm.com> wrote:
>>> I'll add FLATMEM/DISCONTIGMEM/SPARSEMEM support directly.
>>> I already have wasted a month on this not-interesting work and want to fix
>>> this soon.
>>>
>> Let's look at the basic requirement, make memory resource controller
>> not suck with 32 bit systems. I have been thinking of about removing
>> page_cgroup from struct page only for 32 bit systems (use radix tree),
>> 32 bit systems can have a maximum of 64GB if PAE is enabled, I suspect
>> radix tree should work there and let the 64 bit systems work as is. If
>> performance is an issue, I would recommend the 32 bit folks upgrade to
>> 64 bit :) Can we build consensus around this approach?
>>
> My thinking is below. (assume 64bit)
> 

assume 64 bit for the calculations below?

>   - remove page_cgroup pointer from struct page allows us to reduce
>     static memory usage at boot by 8bytes/4096bytes if memory cgroup is disabled.
>     This reaches 96MB on my 48 GB box. I think this is big.
>   - pre-allocation of page_cgroup gives us following.
>    Pros.
>       - We are not necessary to be afraid of "failure of kmalloc" and
>         "goes down to memory reclaim at kmalloc"
>         This makes memory resource controller much simpler and robust.
>       - We can know what amount of kernel memory will be used for
>         LRU pages management.
>    Cons.
>       - All page_cgroups are allocated at boot.
>         This reaches 480MB on my 48GB box.
> 
>   But I think we can ignore "Cons.". If we use up memory, we'll use tons of
>   page_cgroup. Considering memory fragmentation caused by allocating a lots of
>   very small object, pre-allocation makes memcg better.

This looks like a good patch. I'll review and test it.

-- 
	Balbir
