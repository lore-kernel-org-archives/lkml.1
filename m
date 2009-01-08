Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbZAHAb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbZAHAb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 19:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZAHAbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 19:31:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38354 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZAHAbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 19:31:46 -0500
Date: Thu, 8 Jan 2009 09:30:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>, riel@redhat.com,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/4] Memory controller soft limit patches
Message-Id: <20090108093040.22d5f281.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jan 2009 00:11:10 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> Here is v1 of the new soft limit implementation. Soft limits is a new feature
> for the memory resource controller, something similar has existed in the
> group scheduler in the form of shares. We'll compare shares and soft limits
> below. I've had soft limit implementations earlier, but I've discarded those
> approaches in favour of this one.
> 
> Soft limits are the most useful feature to have for environments where
> the administrator wants to overcommit the system, such that only on memory
> contention do the limits become active. The current soft limits implementation
> provides a soft_limit_in_bytes interface for the memory controller and not
> for memory+swap controller. The implementation maintains an RB-Tree of groups
> that exceed their soft limit and starts reclaiming from the group that
> exceeds this limit by the maximum amount.
> 
> This is an RFC implementation and is not meant for inclusion
> 
Core implemantation seems simple and the feature sounds good.
But, before reviewing into details, 3 points.

  1. please fix current bugs on hierarchy management, before new feature.
     AFAIK, OOM-Kill under hierarchy is broken. (I have patches but waits for
     merge window close.)
     I wonder there will be some others. Lockdep error which Nishimura reported
     are all fixed now ?

  2. You inserts reclaim-by-soft-limit into alloc_pages(). But, to do this,
     you have to pass zonelist to try_to_free_mem_cgroup_pages() and have to modify
     try_to_free_mem_cgroup_pages().
     2-a) If not, when the memory request is for gfp_mask==GFP_DMA or allocation
          is under a cpuset, memory reclaim will not work correctlly.
     2-b) try_to_free_mem_cgroup_pages() cannot do good work for order > 1 allocation.
  
     Please try fake-numa (or real NUMA machine) and cpuset.

  3. If you want to insert hooks to "generic" page allocator, it's better to add CC to
     Rik van Riel, Kosaki Motohiro, at leaset.

     To be honest, I myself don't like to add a hook to alloc_pages() directly.
     Can we implment call soft-limit like kswapd (or on kswapd()) ?
     i.e. in moderate way ?
   
A happy new year,

-Kame



> TODOs
> 
> 1. The shares interface is not yet implemented, the current soft limit
>    implementation is not yet hierarchy aware. The end goal is to add
>    a shares interface on top of soft limits and to maintain shares in
>    a manner similar to the group scheduler
> 2. The current implementation maintains the delta from the soft limit
>    and pushes back groups to their soft limits, a ratio of delta/soft_limit
>    is more useful
> 3. It would be nice to have more targetted reclaim (in terms of pages to
>    recalim) interface. So that groups are pushed back, close to their soft
>    limits.
> 
> Tests
> -----
> 
> I've run two memory intensive workloads with differing soft limits and
> seen that they are pushed back to their soft limit on contention. Their usage
> was their soft limit plus additional memory that they were able to grab
> on the system.
> 
> Please review, comment.
> 
> Series
> ------
> 
> memcg-soft-limit-documentation.patch
> memcg-add-soft-limit-interface.patch
> memcg-organize-over-soft-limit-groups.patch
> memcg-soft-limit-reclaim-on-contention.patch
> 
> -- 
> 	Balbir
> 

