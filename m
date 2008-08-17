Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYHQBRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYHQBRa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 21:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYHQBRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 21:17:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61428 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbYHQBRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 21:17:21 -0400
Message-ID: <48A77BBB.7050305@cn.fujitsu.com>
Date: Sun, 17 Aug 2008 09:15:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "IKEDA, Munehiro" <m-ikeda@ds.jp.nec.com>
CC: menage@google.com, balbir@linux.vnet.ibm.com,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: memory.force_empty can make system slowdown
References: <48A63AD1.3010907@ds.jp.nec.com>
In-Reply-To: <48A63AD1.3010907@ds.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IKEDA, Munehiro wrote:
> Cgroup's memory controller has a control file "memory.force_empty"
> to reset usage account charged to a cgroup.  The account shouldn't
> be reset if one or more processes are attached to the cgroup (at
> least for memory controller, IMHO).  So mem_cgroup_force_empty()
> is implemented to return -EBUSY and do nothing if so.
> However, cgroup on hierarchy root faultily might be a exception.
> Even if processes are attached to root cgroup (which is a "default"
> cgroup for processes), forcing-empty can run by writing something to
> memory.force_empty and it'll never end.
> 

I found this bug last week, and I've made patches to fix it, but then
I was on vacation. I'll send the patches out soon.

> Following patch prevents this issue.
> 
> This patch is for cgroup infrastructure code.  The issue can be
> measured by modifying memory controller code also, namely to change
> mem_cgroup_force_empty() to see CSS_ROOT bit of css->flags.
> I believe cgroup->count approach like the patch below is rather
> generic and reasonable, how does that sound?
> 

It's ok for the top_group's count to be 0 due to the top_cgroup hack.
With this patch, the top cgroup's count will be always >0, even if it
has no tasks in it, so writing to top_cgroup's force_empty will always
return -EBUSY.

> Paul, Balbir?
> 
> 
> 
> Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
> 
> diff -uNrp linux-2.6.27-rc3.orig/kernel/cgroup.c linux-2.6.27-rc3/kernel/cgroup.c
> --- linux-2.6.27-rc3.orig/kernel/cgroup.c	2008-08-12 21:55:39.000000000 -0400
> +++ linux-2.6.27-rc3/kernel/cgroup.c	2008-08-15 20:52:52.000000000 -0400
> @@ -2264,8 +2264,10 @@ static void init_cgroup_css(struct cgrou
>  	css->cgroup = cgrp;
>  	atomic_set(&css->refcnt, 0);
>  	css->flags = 0;
> -	if (cgrp == dummytop)
> +	if (cgrp == dummytop) {
>  		set_bit(CSS_ROOT, &css->flags);
> +		atomic_set(&css->cgroup->count, 1);
> +	}
>  	BUG_ON(cgrp->subsys[ss->subsys_id]);
>  	cgrp->subsys[ss->subsys_id] = css;
>  }
> 
> 
> 
