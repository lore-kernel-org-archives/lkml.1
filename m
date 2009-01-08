Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZAHEAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZAHEAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZAHD7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 22:59:35 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:54858 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZAHD7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 22:59:34 -0500
Date: Thu, 8 Jan 2009 09:29:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>, riel@redhat.com,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/4] Memory controller soft limit patches
Message-ID: <20090108035930.GB7294@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain> <20090108093040.22d5f281.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090108093040.22d5f281.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-08 09:30:40]:

> On Thu, 08 Jan 2009 00:11:10 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > 
> > Here is v1 of the new soft limit implementation. Soft limits is a new feature
> > for the memory resource controller, something similar has existed in the
> > group scheduler in the form of shares. We'll compare shares and soft limits
> > below. I've had soft limit implementations earlier, but I've discarded those
> > approaches in favour of this one.
> > 
> > Soft limits are the most useful feature to have for environments where
> > the administrator wants to overcommit the system, such that only on memory
> > contention do the limits become active. The current soft limits implementation
> > provides a soft_limit_in_bytes interface for the memory controller and not
> > for memory+swap controller. The implementation maintains an RB-Tree of groups
> > that exceed their soft limit and starts reclaiming from the group that
> > exceeds this limit by the maximum amount.
> > 
> > This is an RFC implementation and is not meant for inclusion
> > 
> Core implemantation seems simple and the feature sounds good.

Thanks!

> But, before reviewing into details, 3 points.
> 
>   1. please fix current bugs on hierarchy management, before new feature.
>      AFAIK, OOM-Kill under hierarchy is broken. (I have patches but waits for
>      merge window close.)

I've not hit the OOM-kill issue under hierarchy so far, is the OOM
killer selecting a bad task to kill? I'll debug/reproduce the issue.
I am not posting these patches for inclusion, fixing bugs is
definitely the highest priority.

>      I wonder there will be some others. Lockdep error which Nishimura reported
>      are all fixed now ?

I run all my kernels and tests with lockdep enabled, I did not see any
lockdep errors showing up.

> 
>   2. You inserts reclaim-by-soft-limit into alloc_pages(). But, to do this,
>      you have to pass zonelist to try_to_free_mem_cgroup_pages() and have to modify
>      try_to_free_mem_cgroup_pages().
>      2-a) If not, when the memory request is for gfp_mask==GFP_DMA or allocation
>           is under a cpuset, memory reclaim will not work correctlly.

The idea behind adding the code in alloc_pages() is to detect
contention and trim mem cgroups down, if they have grown beyond their
soft limit

>      2-b) try_to_free_mem_cgroup_pages() cannot do good work for order > 1 allocation.
>   
>      Please try fake-numa (or real NUMA machine) and cpuset.

Yes, order > 1 is documented in the patch and you can see the code as
well. Your suggestion is to look at the gfp_mask as well, I'll do
that.

> 
>   3. If you want to insert hooks to "generic" page allocator, it's better to add CC to
>      Rik van Riel, Kosaki Motohiro, at leaset.

Sure, I'll do that in the next patchset.

> 
>      To be honest, I myself don't like to add a hook to alloc_pages() directly.
>      Can we implment call soft-limit like kswapd (or on kswapd()) ?
>      i.e. in moderate way ?
>    

Yes, that might be another point to experiment with, I'll try that in
the next iteration.


> A happy new year,
> 

A very happy new year to you as well.

> -Kame
> 

-- 
	Balbir
