Return-Path: <linux-kernel-owner+w=401wt.eu-S935622AbZAPB7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935622AbZAPB7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758833AbZAPB7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:59:37 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48288 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832AbZAPB7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:59:36 -0500
Date: Fri, 16 Jan 2009 10:58:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 3/4] memcg: hierarchical reclaim by CSS ID
Message-Id: <20090116105828.392044ce.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <496FE791.9030208@cn.fujitsu.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115192943.7c1df53a.kamezawa.hiroyu@jp.fujitsu.com>
	<496FE30C.1090300@cn.fujitsu.com>
	<20090116103810.5ef55cc3.kamezawa.hiroyu@jp.fujitsu.com>
	<496FE791.9030208@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 09:49:05 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Fri, 16 Jan 2009 09:29:48 +0800
> > Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> >>>  /*
> >>> - * Dance down the hierarchy if needed to reclaim memory. We remember the
> >>> - * last child we reclaimed from, so that we don't end up penalizing
> >>> - * one child extensively based on its position in the children list.
> >>> + * Visit the first child (need not be the first child as per the ordering
> >>> + * of the cgroup list, since we track last_scanned_child) of @mem and use
> >>> + * that to reclaim free pages from.
> >>> + */
> >>> +static struct mem_cgroup *
> >>> +mem_cgroup_select_victim(struct mem_cgroup *root_mem)
> >>> +{
> >>> +	struct mem_cgroup *ret = NULL;
> >>> +	struct cgroup_subsys_state *css;
> >>> +	int nextid, found;
> >>> +
> >>> +	if (!root_mem->use_hierarchy) {
> >>> +		spin_lock(&root_mem->reclaim_param_lock);
> >>> +		root_mem->scan_age++;
> >>> +		spin_unlock(&root_mem->reclaim_param_lock);
> >>> +		css_get(&root_mem->css);
> >>> +		ret = root_mem;
> >>> +	}
> >>> +
> >>> +	while (!ret) {
> >>> +		rcu_read_lock();
> >>> +		nextid = root_mem->last_scanned_child + 1;
> >>> +		css = css_get_next(&mem_cgroup_subsys, nextid, &root_mem->css,
> >>> +				   &found);
> >>> +		if (css && css_is_populated(css) && css_tryget(css))
> >> I don't see why you need to check css_is_populated(css) ?
> >>
> > 
> > Main reason is for sanity. I don't like to hold css->refcnt of not populated css.
> 
> I think this is a rare case. It's just a very short period when a cgroup is
> being created but not yet fully created.
> 
I don't think so. When the cgroup is mounted with several subsystems, it can call
create() and populate() several times. So, memory allocation occurs between
create() and populate(), it can call try_to_free_page() (of global LRU). More than
that, if CONFIG_PREEMPT=y, any "short" race doesn't mean safe.



Thanks,
-Kame


