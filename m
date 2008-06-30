Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYF3BpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYF3BpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 21:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYF3BpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 21:45:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33602 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbYF3BpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 21:45:05 -0400
Date: Mon, 30 Jun 2008 10:50:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC 0/5] Memory controller soft limit introduction (v3)
Message-Id: <20080630105006.a7bb6529.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080630102054.ee214765.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080627151808.31664.36047.sendpatchset@balbir-laptop>
	<20080628133615.a5fa16cf.kamezawa.hiroyu@jp.fujitsu.com>
	<4867174B.3090005@linux.vnet.ibm.com>
	<20080630102054.ee214765.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 10:20:54 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > 2. *please* handle NUMA
> > >    There is a fundamental difference between global VMM and memcg.
> > >      global VMM - reclaim memory at memory shortage.
> > >      memcg     - for reclaim memory at memory limit
> > >    Then, memcg wasn't required to handle place-of-memory at hitting limit. 
> > >    *just reducing the usage* was enough.
> > >    In this set, you try to handle memory shortage handling.
> > >    So, please handle NUMA, i.e. "what node do you want to reclaim memory from ?"
> > >    If not, 
> > >     - memory placement of Apps can be terrible.
> > >     - cannot work well with cpuset. (I think)
> > > 
> > 
> > try_to_free_mem_cgroup_pages() handles NUMA right? We start with the
> > node_zonelists of the current node on which we are executing.  I can pass on the
> > zonelist from __alloc_pages_internal() to try_to_free_mem_cgroup_pages(). Is
> > there anything else you had in mind?
> > 
> Assume following case of a host with 2 nodes. and following mount style.
> 
> mount -t cgroup -o memory,cpuset none /opt/cgroup/
> 
>   
>   /Group1: cpu 0-1, mem=0 limit=1G, soft-limit=700M
>   /Group2: cpu 2-3, mem=1 limit=1G  soft-limit=700M
>   ....
>   /Groupxxxx
> 
> Assume a environ after some workload, 
> 
>   /Group1: cpu 0-1, mem=0 limit=1G, soft-limit=700M usage=990M
>   /Group2: cpu 2-3, mem=1 limit=1G  soft-limit=700M usage=400M
> 
> *And* memory of node"1" is in shortage and the kernel has to reclaim
> memory from node "1".
> 
> Your routine tries to relclaim memory from a group, which exceeds soft-limit
> ....Group1. But it's no help because Group1 doesn't contains any memory in Node1.
> And make it worse, your routine doen't tries to call try_to_free_pages() in global
> LRU when your soft-limit reclaim some memory. So, if a task in Group 1 continues
> to allocate memory at some speed, memory shortage in Group2 will not be recovered,
> easily.
> 
> This includes 2 aspects of trouble.
>  - Group1's memory is reclaimed but it's wrong.
>  - Group2's try_to_free_pages() may took very long time.
> 
A bit more inforamtion, to be honest, I don't understand this perfectly.

But I convice there is some difference between limit and shortage.

in 2.6.26-rc5-mm3's shrink_zones() supprots cpuset by this.

==
                if (scan_global_lru(sc)) {
                        if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
                                continue;
                        note_zone_scanning_priority(zone, priority);

                        if (zone_is_all_unreclaimable(zone) &&
                                                priority != DEF_PRIORITY)
                                continue;       /* Let kswapd poll it */
                        sc->all_unreclaimable = 0;
                } else {
                        /*
                         * Ignore cpuset limitation here. We just want to reduce
                         * # of used pages by us regardless of memory shortage.
                         */
                        sc->all_unreclaimable = 0;
                        mem_cgroup_note_reclaim_priority(sc->mem_cgroup,
                                                        priority);
                }
==

First point is (maybe) my mistake. We have to add cpuset hardwall check to memcg
part. (I will write a patch soon.)

Second point is  when memory shortage is caused by some routine which is not in
cpuset. In this case, Group1's memory can be reclaimed w/o benefits.
not big trouble ?


Thanks,
-Kame



























