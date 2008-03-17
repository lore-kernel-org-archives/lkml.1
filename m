Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYCQLyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYCQLyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 07:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYCQLym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 07:54:42 -0400
Received: from sacred.ru ([62.205.161.221]:50011 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYCQLym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 07:54:42 -0400
Message-ID: <47DE57C2.5060206@openvz.org>
Date: Mon, 17 Mar 2008 14:36:34 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][2/3] Account and control virtual address space allocations
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain> <20080316173005.8812.88290.sendpatchset@localhost.localdomain>
In-Reply-To: <20080316173005.8812.88290.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Mar 2008 14:36:31 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

> +int mem_cgroup_update_as(struct mm_struct *mm, long nr_pages)
> +{
> +	int ret = 0;
> +	struct mem_cgroup *mem;
> +	if (mem_cgroup_subsys.disabled)
> +		return ret;
> +
> +	rcu_read_lock();
> +	mem = rcu_dereference(mm->mem_cgroup);
> +	css_get(&mem->css);
> +	rcu_read_unlock();
> +
> +	if (nr_pages > 0) {
> +		if (res_counter_charge(&mem->as_res, (nr_pages * PAGE_SIZE)))
> +			ret = 1;
> +	} else
> +		res_counter_uncharge(&mem->as_res, (-nr_pages * PAGE_SIZE));

No, please, no. Let's make two calls - mem_cgroup_charge_as and mem_cgroup_uncharge_as.

[snip]

> @@ -1117,6 +1117,9 @@ munmap_back:
>  		}
>  	}
>  
> +	if (mem_cgroup_update_as(mm, len >> PAGE_SHIFT))
> +		return -ENOMEM;
> +

Why not use existintg cap_vm_enough_memory and co?

[snip]
