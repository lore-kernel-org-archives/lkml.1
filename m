Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYHEKjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYHEKjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 06:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbYHEKf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 06:35:56 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:47577 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757655AbYHEKfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 06:35:55 -0400
Date: Tue, 05 Aug 2008 19:35:51 +0900 (JST)
Message-Id: <20080805.193551.14286210.taka@valinux.co.jp>
To: righi.andrea@gmail.com
Cc: ryov@valinux.co.jp, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       agk@sourceware.org
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory subsystem into
 two parts
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <48982A9D.2000803@gmail.com>
References: <20080804.175707.104036289.ryov@valinux.co.jp>
	<20080804.175748.189722512.ryov@valinux.co.jp>
	<48982A9D.2000803@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrea,

> you can remove some ifdefs doing:

I think you don't have to care about this much, since one of the following
patches removes most of these ifdefs.

> #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> 	if (likely(!memcg)) {
> 		rcu_read_lock();
> 		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
> 		/*
> 		 * For every charge from the cgroup, increment reference count
> 		 */
> 		css_get(&mem->css);
> 		rcu_read_unlock();
> 	} else {
> 		mem = memcg;
> 		css_get(&memcg->css);
> 	}
> 	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
> 		if (!(gfp_mask & __GFP_WAIT))
> 			goto out;
> 
> 		if (try_to_free_mem_cgroup_pages(mem, gfp_mask))
> 			continue;
> 
> 		/*
> 		 * try_to_free_mem_cgroup_pages() might not give us a full
> 		 * picture of reclaim. Some pages are reclaimed and might be
> 		 * moved to swap cache or just unmapped from the cgroup.
> 		 * Check the limit again to see if the reclaim reduced the
> 		 * current usage of the cgroup before giving up
> 		 */
> 		if (res_counter_check_under_limit(&mem->res))
> 			continue;
> 
> 		if (!nr_retries--) {
> 			mem_cgroup_out_of_memory(mem, gfp_mask);
> 			goto out;
> 		}
> 	}
> 	pc->mem_cgroup = mem;
> #endif /* CONFIG_CGROUP_MEM_RES_CTLR */
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
