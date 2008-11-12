Return-Path: <linux-kernel-owner+w=401wt.eu-S1752265AbYKLE4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbYKLE4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 23:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYKLE4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 23:56:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49385 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYKLE4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 23:56:32 -0500
Date: Wed, 12 Nov 2008 13:55:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] [BUGFIX]cgroup: fix potential deadlock in pre_destroy.
Message-Id: <20081112135548.74503b7b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <491A6163.4040100@linux.vnet.ibm.com>
References: <20081112133002.15c929c3.kamezawa.hiroyu@jp.fujitsu.com>
	<491A6163.4040100@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 10:23:55 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > Balbir, Paul, Li, How about this ?
> > =
> > As Balbir pointed out, memcg's pre_destroy handler has potential deadlock.
> > 
> > It has following lock sequence.
> > 
> > 	cgroup_mutex (cgroup_rmdir)
> > 	    -> pre_destroy
> > 		-> mem_cgroup_pre_destroy
> > 			-> force_empty
> > 			   -> lru_add_drain_all->
> > 			      -> schedule_work_on_all_cpus
> >                                  -> get_online_cpus -> cpuhotplug.lock.
> > 
> > But, cpuset has following.
> > 	cpu_hotplug.lock (call notifier)
> > 		-> cgroup_mutex. (within notifier)
> > 
> > Then, this lock sequence should be fixed.
> > 
> > Considering how pre_destroy works, it's not necessary to holding
> > cgroup_mutex() while calling it. 
> > 
> > As side effect, we don't have to wait at this mutex while memcg's force_empty
> > works.(it can be long when there are tons of pages.)
> > 
> > Note: memcg is an only user of pre_destroy, now.
> > 
> 
> I thought about this and it seems promising. My concern is that with
> cgroup_mutex given, the state of cgroup within pre-destroy will be
> unpredictable. I suspect, if pre-destory really needs cgroup_mutex, we can hold
> it within pre-destroy.
> 
I agree.

> BTW, your last check, does not seem right
> 
> +	if (atomic_read(&cgrp->count)
> +	    || list_empty(&cgrp->children)
> 
> Why should list_empty() result in EBUSY, shouldn't it be !list_empty()?
> 
> +	    || cgroup_has_css_refs(cgrp)) {
>
Oh, my bad...

will fix soon.

Thanks,
-Kame




