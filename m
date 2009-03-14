Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZCNSxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZCNSxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 14:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZCNSxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 14:53:02 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:42920 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbZCNSxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 14:53:00 -0400
Date: Sun, 15 Mar 2009 00:22:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/5] memcg softlimit (Another one) v4
Message-ID: <20090314185246.GT16897@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 09:52:47]:

> Hi, this is a patch for implemnt softlimit to memcg.
> 
> I did some clean up and bug fixes. 
> 
> Anyway I have to look into details of "LRU scan algorithm" after this.
> 
> How this works:
> 
>  (1) Set softlimit threshold to memcg.
>      #echo 400M > /cgroups/my_group/memory.softlimit_in_bytes.
> 
>  (2) Define priority as victim.
>      #echo 3 > /cgroups/my_group/memory.softlimit_priority.
>      0 is the lowest, 8 is the highest.
>      If "8", softlimit feature ignore this group.
>      default value is "8".
> 
>  (3) Add some memory pressure and make kswapd() work.
>      kswapd will reclaim memory from victims paying regard to priority.
> 
> Simple test on my 2cpu 86-64 box with 1.6Gbytes of memory (...vmware)
> 
>   While a process malloc 800MB of memory and touch it and sleep in a group,
>   run kernel make -j 16 under a victim cgroup with softlimit=300M, priority=3.
> 
>   Without softlimit => 400MB of malloc'ed memory are swapped out.
>   With softlimit    =>  80MB of malloc'ed memory are swapped out. 
> 
> I think 80MB of swap is from direct memory reclaim path. And this
> seems not to be terrible result.
> 
> I'll do more test on other hosts. Any comments are welcome.

Hi, Kamezawa-San,

I tried some simple tests with this patch and the results are not
anywhere close to expected.

1. My setup is 4GB RAM with 4 CPUs and I boot with numa=fake=4
2. I setup my cgroups as follows
   a. created /a and /b and set memory.use_hierarchy=1
   b. created /a/x and /b/x, set their memory.softlimit_priority=1
   c. set softlimit_in_bytes for a/x to 1G and b/x to 2G
   d. I assigned tasks to a/x and b/x

I expected the tasks in a/x and b/x to get memory distributed in the
ratio to 1:2. Here is what I found

1. The task in a/x got more memory than the task in b/x even though
   I started the task in b/x first
2. Even changing softlimit_priority (increased for b) did not help much


-- 
	Balbir
