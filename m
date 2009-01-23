Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZAWG45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZAWG45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZAWG4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:56:43 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37331 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZAWG4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:56:41 -0500
Message-ID: <4979692B.3050703@cs.helsinki.fi>
Date: Fri, 23 Jan 2009 08:52:27 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       sfr@canb.auug.org.au, matthew.r.wilcox@intel.com, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       andrew.vasquez@qlogic.com, anirban.chakraborty@qlogic.com,
       mingo@elte.hu
Subject: Re: Mainline kernel OLTP performance update
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>	 <200901161503.13730.nickpiggin@yahoo.com.au>	 <20090115201210.ca1a9542.akpm@linux-foundation.org>	 <200901161746.25205.nickpiggin@yahoo.com.au>	 <20090116065546.GJ31013@parisc-linux.org>	 <1232092430.11429.52.camel@ymzhang>  <87sknjeemn.fsf@basil.nowhere.org>	 <1232428583.11429.83.camel@ymzhang>	 <alpine.DEB.1.10.0901211852060.18367@qirst.com>	 <1232613395.11429.122.camel@ymzhang>	 <1232615707.14549.6.camel@penberg-laptop>	 <1232616517.11429.129.camel@ymzhang>	 <1232617672.14549.25.camel@penberg-laptop> <1232679773.11429.155.camel@ymzhang>
In-Reply-To: <1232679773.11429.155.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:
>>>> If it's the former, with big enough size passed to __alloc_skb(), the
>>>> networking code might be taking a hit from the SLUB page allocator
>>>> pass-through.
>> Do we know what kind of size is being passed to __alloc_skb() in this
>> case?
> In function __alloc_skb, original parameter size=4155,
> SKB_DATA_ALIGN(size)=4224, sizeof(struct skb_shared_info)=472, so
> __kmalloc_track_caller's parameter size=4696.

OK, so all allocations go straight to the page allocator.

> 
>>  Maybe we want to do something like this.
>>
>> SLUB: revert page allocator pass-through
> This patch amost fixes the netperf UDP-U-4k issue.
> 
> #slabinfo -AD
> Name                   Objects    Alloc     Free   %Fast
> :0000256                  1658 70350463 70348946  99  99 
> kmalloc-8192                31 70322309 70322293  99  99 
> :0000168                  2592   143154   140684  93  28 
> :0004096                  1456    91072    89644  99  96 
> :0000192                  3402    63838    60491  89  11 
> :0000064                  6177    49635    43743  98  77 
> 
> So ﻿kmalloc-8192 appears. Without the patch, ﻿kmalloc-8192 hides.
> ﻿kmalloc-8192's default order on my 8-core stoakley is 2.

Christoph, should we merge my patch as-is or do you have an alternative 
fix in mind? We could, of course, increase kmalloc() caches one level up 
to 8192 or higher.

> 
> 1) If I start CPU_NUM clients and servers, SLUB's result is about 2% better than SLQB's;
> 2) If I start 1 clinet and 1 server, and bind them to different physical cpu, SLQB's result
> is about 10% better than SLUB's.
> 
> I don't know why there is still 10% difference with item 2). Maybe cachemiss causes it?

Maybe we can use the perfstat and/or kerneltop utilities of the new perf 
counters patch to diagnose this:

http://lkml.org/lkml/2009/1/21/273

And do oprofile, of course. Thanks!

		Pekka
