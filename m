Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbZAMJ1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbZAMJ1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZAMJ0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:26:51 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33744 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZAMJ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:26:50 -0500
Date: Tue, 13 Jan 2009 18:25:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH 3/4] memcg: fix OOM KILL under hierarchy
Message-Id: <20090113182542.004556aa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <496C51C8.5040900@cn.fujitsu.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090108183207.26d88794.kamezawa.hiroyu@jp.fujitsu.com>
	<496C51C8.5040900@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 16:33:12 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> > -int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
> > +static int
> > +mm_match_cgroup_hierarchy(struct mm_struct *mm, struct mem_cgroup *mem)
> > +{
> > +	struct mem_cgroup *curr;
> > +	int ret;
> > +
> > +	if (!mm)
> > +		return 0;
> > +	rcu_read_lock();
> > +	curr = mem_cgroup_from_task(mm->owner);
> 
> curr can be NULL ?
> 
Good Catch! You're right.

> > +	if (mem->use_hierarchy)
> > +		ret = css_is_ancestor(&curr->css, &mem->css);
> > +	else
> > +		ret = (curr == mem);
> > +	rcu_read_unlock();
> > +	return ret;
> > +}
> > +
> 
> ...
> 
> > +void mem_cgroup_update_oom_jiffies(struct mem_cgroup *mem)
> > +{
> > +	struct mem_cgroup *cur;
> > +	struct cgroup_subsys_state *css;
> > +	int id, found;
> > +
> > +	if (!mem->use_hierarchy) {
> > +		mem->last_oom_jiffies = jiffies;
> > +		return;
> > +	}
> > +
> > +	id = 0;
> > +	rcu_read_lock();
> > +	while (1) {
> > +		css = css_get_next(&mem_cgroup_subsys, id, &mem->css, &found);
> > +		if (!css)
> > +			break;
> > +		if (css_tryget(css)) {
> > +			cur = container_of(css, struct mem_cgroup, css);
> > +			cur->last_oom_jiffies = jiffies;
> > +			css_put(css);
> > +		}
> > +		id = found + 1;
> > +	}
> > +	rcu_read_unlock();
> > +	return;
> 
> redundant "return"
> 
ok, will remove it.

Thank you.
-Kame

