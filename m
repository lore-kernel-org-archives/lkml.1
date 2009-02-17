Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZBQDF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZBQDF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 22:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbZBQDFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 22:05:49 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:57842 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZBQDFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 22:05:49 -0500
Date: Tue, 17 Feb 2009 08:35:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/4] Memory controller soft limit patches (v2)
Message-ID: <20090217030526.GA20958@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090216110844.29795.17804.sendpatchset@localhost.localdomain> <20090217090523.975bbec2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090217090523.975bbec2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-17 09:05:23]:

> On Mon, 16 Feb 2009 16:38:44 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > Changelog v2...v1
> > 1. Soft limits now support hierarchies
> > 2. Use spinlocks instead of mutexes for synchronization of the RB tree
> > 
> > Here is v2 of the new soft limit implementation. Soft limits is a new feature
> > for the memory resource controller, something similar has existed in the
> > group scheduler in the form of shares. The CPU controllers interpretation
> > of shares is very different though. We'll compare shares and soft limits
> > below.
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
> 
> some thoughts after reading patch.
> 
> 1. As I pointed out, cpuset/mempolicy case is not handled yet.

That should be esy to do with zonelists passed from reclaim path

> 2. I don't like to change usual direct-memory-reclaim path. It will be obstacles
>    for VM-maintaners to improve memory reclaim. memcg's LRU is designed for
>    shrinking memory usage and not for avoiding memory shortage. IOW, it's slow routine
>    for reclaiming memory for memory shortage.

I don't think I agree here. Direct reclaim is the first indication of
shortage and if order 0 pages are short, memcg's above their soft
limit can be targetted first.

> 3. After this patch, res_counter is no longer for general purpose res_counter...
>    It seems to have too many unnecessary accessories for general purpose.  

Why not? Soft limits are a feature of any controller. The return of
highest ancestor might be the only policy we impose right now. But as
new controllers start using res_counter, we can clearly add a policy
callback.

> 4. please use css_tryget() rather than mem_cgroup_get().

OK, will do

> 5. please remove mem_cgroup from tree at force_empty or rmdir.
>    Just making  memcg->on_tree=false is enough ? I'm in doubt.

force_empty will cause uncharge and we handle it there, but I can add
an explicit call there as well.

> 6. What happens when the-largest-soft-limit-memcg has tons on Anon on swapless
>    system and memory reclaim cannot make enough progress ?

The samething that would happen on regular reclaim, one needs to
decide whether to oom or not from this context for memcg's.

-- 
	Balbir
