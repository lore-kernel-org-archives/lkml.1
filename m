Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbZBFCIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbZBFCIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZBFCIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:08:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60220 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbZBFCIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:08:22 -0500
Message-ID: <498B9B6C.3000808@cn.fujitsu.com>
Date: Fri, 06 Feb 2009 10:07:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Reduce size of swap_cgroup by CSS ID
References: <20090205185959.7971dee4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090205185959.7971dee4.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * A helper function to get mem_cgroup from ID. must be called under
> + * rcu_read_lock(). Because css_tryget() is called under this, css_put
> + * should be called later.
> + */
> +static struct mem_cgroup *mem_cgroup_lookup_get(unsigned short id)
> +{
> +	struct cgroup_subsys_state *css;
> +
> +	/* ID 0 is unused ID */
> +	if (!id)
> +		return NULL;
> +	css = css_lookup(&mem_cgroup_subsys, id);
> +	if (css && css_tryget(css))
> +		return container_of(css, struct mem_cgroup, css);
> +	return NULL;
> +}

the returned mem_cgroup needn't be protected by rcu_read_lock(), so I
think this is better:
	rcu_read_lock();
	css = css_lookup(&mem_cgroup_subsys, id);
	rcu_read_unlock();
and no lock is needed when calling mem_cgroup_lookup_get().

>   * Returns old value at success, NULL at failure.
>   * (Of course, old value can be NULL.)
>   */
> -struct mem_cgroup *swap_cgroup_record(swp_entry_t ent, struct mem_cgroup *mem)
> +unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)

kernel-doc needs to be updated

>   * lookup_swap_cgroup - lookup mem_cgroup tied to swap entry
>   * @ent: swap entry to be looked up.
>   *
> - * Returns pointer to mem_cgroup at success. NULL at failure.
> + * Returns CSS ID of mem_cgroup at success. NULL at failure.

s/NULL/0/

>   */
> -struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent)
> +unsigned short lookup_swap_cgroup(swp_entry_t ent)



