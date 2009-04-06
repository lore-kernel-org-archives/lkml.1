Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZDFJIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZDFJIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZDFJIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:08:35 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:42601 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbZDFJIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:08:34 -0400
Date: Mon, 6 Apr 2009 14:38:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/9] memcg soft limit v2 (new design)
Message-ID: <20090406090800.GH7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-03 17:08:35]:

> Hi,
> 
> Memory cgroup's soft limit feature is a feature to tell global LRU 
> "please reclaim from this memcg at memory shortage".
> 
> This is v2. Fixed some troubles under hierarchy. and increase soft limit
> update hooks to proper places.
> 
> This patch is on to
>   mmotom-Mar23 + memcg-cleanup-cache_charge.patch
>   + vmscan-fix-it-to-take-care-of-nodemask.patch
> 
> So, not for wide use ;)
> 
> This patch tries to avoid to use existing memcg's reclaim routine and
> just tell "Hints" to global LRU. This patch is briefly tested and shows
> good result to me. (But may not to you. plz brame me.)
> 
> Major characteristic is.
>  - memcg will be inserted to softlimit-queue at charge() if usage excess
>    soft limit.
>  - softlimit-queue is a queue with priority. priority is detemined by size
>    of excessing usage.

This is critical and good that you have this now. In my patchset, it
helps me achieve a lot of the expected functionality.

>  - memcg's soft limit hooks is called by shrink_xxx_list() to show hints.

I am not too happy with moving pages in global LRU based on soft
limits based on my comments earlier. My objection is not too strong,
since reclaiming from the memcg also exhibits functionally similar
behaviour.

>  - Behavior is affected by vm.swappiness and LRU scan rate is determined by
>    global LRU's status.
> 

I also have concerns about not sorting the list of memcg's. I need to
write some scalabilityt tests and check.

> In this v2.
>  - problems under use_hierarchy=1 case are fixed.
>  - more hooks are added.
>  - codes are cleaned up.
> 
> Shows good results on my private box test under several work loads.
> 
> But in special artificial case, when victim memcg's Active/Inactive ratio of
> ANON is very different from global LRU, the result seems not very good.
> i.e.
>   under vicitm memcg, ACTIVE_ANON=100%, INACTIVE=0% (access memory in busy loop)
>   under global, ACTIVE_ANON=10%, INACTIVE=90% (almost all processes are sleeping.)
> memory can be swapped out from global LRU, not from vicitm.
> (If there are file cache in victims, file cacahes will be out.)
> 
> But, in this case, even if we successfully swap out anon pages under victime memcg,
> they will come back to memory soon and can show heavy slashing.

heavy slashing? Not sure I understand what you mean.

> 
> While using soft limit, I felt this is useful feature :)
> But keep this RFC for a while. I'll prepare Documentation until the next post.
> 

-- 
	Balbir
