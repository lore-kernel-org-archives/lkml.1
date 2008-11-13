Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbYKMES7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbYKMES7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 23:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYKMESu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 23:18:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50821 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYKMESt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 23:18:49 -0500
Date: Thu, 13 Nov 2008 13:18:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][mm] [PATCH 3/4] Memory cgroup hierarchical reclaim (v3)
Message-Id: <20081113131807.b2f22261.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081112112141.GA25386@balbir.in.ibm.com>
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop>
	<20081111123417.6566.52629.sendpatchset@balbir-laptop>
	<20081112140236.46448b47.kamezawa.hiroyu@jp.fujitsu.com>
	<491A6E71.5010307@linux.vnet.ibm.com>
	<20081112150126.46ac6042.kamezawa.hiroyu@jp.fujitsu.com>
	<491A7345.4090500@linux.vnet.ibm.com>
	<20081112151233.0ec8dc44.kamezawa.hiroyu@jp.fujitsu.com>
	<491A7637.3050402@linux.vnet.ibm.com>
	<20081112153314.a7162192.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112112141.GA25386@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 16:51:41 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:


> Here is the iterative version of this patch. I tested it in my
> test environment. NOTE: The cgroup_locked check is still present, I'll
> remove that shortly after your patch is accepted.
> 
> This patch introduces hierarchical reclaim. When an ancestor goes over its
> limit, the charging routine points to the parent that is above its limit.
> The reclaim process then starts from the last scanned child of the ancestor
> and reclaims until the ancestor goes below its limit.
> 

complicated as you said but it seems it's from style.

I expected following kind of one.
==

struct mem_cgroup *memcg_select_next_token(struct mem_cgroup *itr,
					struct mem_cgroup *cur,
					struct mem_cgroup *root)
{
	struct cgroup *pos, *tmp, *parent, *rootpos;

	cgroup_lock();
	if (!itr || itr->obsolete)
		itr = cur;

	rootpos = root->css.cgroup;
	pos = itr->css.cgroup;
	parent = pos->parent;
	/* start from children */
	if (!list_empty(&pos->children)) {
		pos = list_entry(pos->children.next, struct cgroup, sibling);
		mem_cgroup_put(itr);
		itr = mem_cgroup_from_cont(pos);
		mem_cgroup_get(itr);
		goto unlock;
	}
next_parent:
	if (pos == rootpos) {
		/* I'm root and no available children */
		mem_cgroup_put(itr);
		itr = mem_cgroup_from_cont(pos);
		mem_cgroup_get(itr);
		goto unlock;
	}
	/* Do I have next siblings ? */
	if (pos->sibling.next != &parent->children) {
		pos = list_entry(pos->sibling.next, struct cgroup, sibling);
		mem_cgroup_put(itr);
		itr = mem_cgroup_from_cont(pos);
		mem_cgroup_get(itr);
		goto unlock;
	}
	/* Ok, go back to parent */
	pos = pos->parent;
	goto next_parent;
	
unlock:
	root->reclaim_token = token;
	cgroup_unlock();
	return itr;
}

struct mem_cgroup *memcg_select_start_token(struct mem_cgroup *cur,
					    struct mem_cgroup *root)
{
	struct mem_cgroup *token;

	if (cur == root)
		return cur;

	cgroup_lock();

	token = root->reclaim_token;
	if (token->obsolete) {
		mem_cgroup_put(token);  /* decrease refcnt */
		root->reclaim_token = cur;
		token = cur;
		mem_cgroup_get(cur);	/* increase refcnt */
		cgroup_unlock();
		return token;
	}
	cgroup_unlock();
	
	return memcg_select_next_token(token, cur, root);
}


int mem_cgroup_do_reclaim(struct mem_cgroup *mem,
			  struct mem_cgroup *root_mem,
			  gfp_t mask)
{
	struct cgroup *cgroup;
	struct mem_cgroup *tmp, *token, *start;
	/*
	 * We do memory reclaim under "root_mem".
	 * We have to be careful not to reclaim memory only from
	 * unlucky one. For avoiding that, we use "token".
	 */

	token = memcg_select_start_token(mem, root_mem);

	start = NULL;

	while (start != token) {
		if (!token->obsolete) {
			ret = try_to_free_mem_cgroup_pages(token,
						GFP_HIGHUSER_MOVABLE);
			if (!res_counter_check_under_limit(&root_mem->res))
				return 0;
			if (ret == 0)
				retry--;
			start = token;
			token = memcg_select_next_token(token, mem, root_mem);
		} else {
			/* This mem_cgroup is destroyed. */
			mem_cgroup_put(token);
			token = memcg_select_next_token(NULL, mem, root_mem);
		}
	}
	
}

