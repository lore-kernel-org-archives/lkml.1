Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbZAPBt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbZAPBt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZAPBtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:49:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51080 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZAPBts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:49:48 -0500
Message-ID: <496FE791.9030208@cn.fujitsu.com>
Date: Fri, 16 Jan 2009 09:49:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 3/4] memcg: hierarchical reclaim by CSS ID
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>	<20090115192943.7c1df53a.kamezawa.hiroyu@jp.fujitsu.com>	<496FE30C.1090300@cn.fujitsu.com> <20090116103810.5ef55cc3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090116103810.5ef55cc3.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 16 Jan 2009 09:29:48 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>>>  /*
>>> - * Dance down the hierarchy if needed to reclaim memory. We remember the
>>> - * last child we reclaimed from, so that we don't end up penalizing
>>> - * one child extensively based on its position in the children list.
>>> + * Visit the first child (need not be the first child as per the ordering
>>> + * of the cgroup list, since we track last_scanned_child) of @mem and use
>>> + * that to reclaim free pages from.
>>> + */
>>> +static struct mem_cgroup *
>>> +mem_cgroup_select_victim(struct mem_cgroup *root_mem)
>>> +{
>>> +	struct mem_cgroup *ret = NULL;
>>> +	struct cgroup_subsys_state *css;
>>> +	int nextid, found;
>>> +
>>> +	if (!root_mem->use_hierarchy) {
>>> +		spin_lock(&root_mem->reclaim_param_lock);
>>> +		root_mem->scan_age++;
>>> +		spin_unlock(&root_mem->reclaim_param_lock);
>>> +		css_get(&root_mem->css);
>>> +		ret = root_mem;
>>> +	}
>>> +
>>> +	while (!ret) {
>>> +		rcu_read_lock();
>>> +		nextid = root_mem->last_scanned_child + 1;
>>> +		css = css_get_next(&mem_cgroup_subsys, nextid, &root_mem->css,
>>> +				   &found);
>>> +		if (css && css_is_populated(css) && css_tryget(css))
>> I don't see why you need to check css_is_populated(css) ?
>>
> 
> Main reason is for sanity. I don't like to hold css->refcnt of not populated css.

I think this is a rare case. It's just a very short period when a cgroup is
being created but not yet fully created.

> Second reason is for avoinding unnecessary calls to try_to_free_pages(),
> it's heavy. I should also add mem->res.usage == 0 case for skipping but not yet.
> 

And if mem->res.usage == 0 is checked, css_is_popuated() is just redundant.

> THanks,
> -Kame
> 
>>> +			ret = container_of(css, struct mem_cgroup, css);
>>> +
>>> +		rcu_read_unlock();
>>> +		/* Updates scanning parameter */
>>> +		spin_lock(&root_mem->reclaim_param_lock);
>>> +		if (!css) {
>>> +			/* this means start scan from ID:1 */
>>> +			root_mem->last_scanned_child = 0;
>>> +			root_mem->scan_age++;
>>> +		} else
>>> +			root_mem->last_scanned_child = found;
>>> +		spin_unlock(&root_mem->reclaim_param_lock);
>>> +	}
>>> +
>>> +	return ret;
>>> +}
>>> +
