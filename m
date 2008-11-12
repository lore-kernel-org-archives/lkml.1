Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbYKLEy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbYKLEy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 23:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYKLEyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 23:54:17 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:40042 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYKLEyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 23:54:16 -0500
Message-ID: <491A6163.4040100@linux.vnet.ibm.com>
Date: Wed, 12 Nov 2008 10:23:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] [BUGFIX]cgroup: fix potential deadlock in pre_destroy.
References: <20081112133002.15c929c3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081112133002.15c929c3.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Balbir, Paul, Li, How about this ?
> =
> As Balbir pointed out, memcg's pre_destroy handler has potential deadlock.
> 
> It has following lock sequence.
> 
> 	cgroup_mutex (cgroup_rmdir)
> 	    -> pre_destroy
> 		-> mem_cgroup_pre_destroy
> 			-> force_empty
> 			   -> lru_add_drain_all->
> 			      -> schedule_work_on_all_cpus
>                                  -> get_online_cpus -> cpuhotplug.lock.
> 
> But, cpuset has following.
> 	cpu_hotplug.lock (call notifier)
> 		-> cgroup_mutex. (within notifier)
> 
> Then, this lock sequence should be fixed.
> 
> Considering how pre_destroy works, it's not necessary to holding
> cgroup_mutex() while calling it. 
> 
> As side effect, we don't have to wait at this mutex while memcg's force_empty
> works.(it can be long when there are tons of pages.)
> 
> Note: memcg is an only user of pre_destroy, now.
> 

I thought about this and it seems promising. My concern is that with
cgroup_mutex given, the state of cgroup within pre-destroy will be
unpredictable. I suspect, if pre-destory really needs cgroup_mutex, we can hold
it within pre-destroy.

BTW, your last check, does not seem right

+	if (atomic_read(&cgrp->count)
+	    || list_empty(&cgrp->children)

Why should list_empty() result in EBUSY, shouldn't it be !list_empty()?

+	    || cgroup_has_css_refs(cgrp)) {


-- 
	Balbir
