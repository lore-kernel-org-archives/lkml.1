Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbYLEI2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbYLEI2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYLEI1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:27:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38969 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbYLEI1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:27:40 -0500
Date: Fri, 5 Dec 2008 17:26:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>
Subject: [RFC][PATCH 0/4] cgroup ID and css refcnt change and memcg
 hierarchy (2008/12/05)
Message-Id: <20081205172642.565661b1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch set onto mmotm-2.6.28-Dec30.

Still RFC. I'm considering whether I can make this simpler....

Major changes from previous one
	- css->refcnt is unified.
	  I think distributed refcnt is a crazy idea...
	- applied comments to previous version.
	- OOM Kill handler is fixed. (this was broken by hierarchy) 

I may not be able to reply quickly in weekend, sorry.

After this, memcg's hierarchical reclaim will be
==
static struct mem_cgroup *
mem_cgroup_select_victim(struct mem_cgroup *root_mem)
{
        struct cgroup *cgroup, *root_cgroup;
        struct mem_cgroup *ret;
        int nextid, rootid, depth, found;

        root_cgroup = root_mem->css.cgroup;
        rootid = cgroup_id(root_cgroup);
        depth = cgroup_depth(root_cgroup);
        found = 0;

        rcu_read_lock();
        if (!root_mem->use_hierarchy) {
                spin_lock(&root_mem->reclaim_param_lock);
                root_mem->scan_age++;
                spin_unlock(&root_mem->reclaim_param_lock);
                css_get(&root_mem->css);
                ret = root_mem;
        }

        while (!ret) {
                /* ID:0 is not used by cgroup-id */
                nextid = root_mem->last_scanned_child + 1;
                cgroup = cgroup_get_next(nextid, rootid, depth, &found);
                if (cgroup) {
                        spin_lock(&root_mem->reclaim_param_lock);
                        root_mem->last_scanned_child = found;
                        spin_unlock(&root_mem->reclaim_param_lock);
                        ret = mem_cgroup_from_cont(cgroup);
                        if (!css_tryget(&ret->css))
                                ret = NULL;
                } else {
                        spin_lock(&root_mem->reclaim_param_lock);
                        root_mem->scan_age++;
                        root_mem->last_scanned_child = 0;
                        spin_unlock(&root_mem->reclaim_param_lock);
                }
        }
        rcu_read_unlock();
        return ret;
}

/*
 * root_mem is the original ancestor that we've been reclaim from.
 * root_mem cannot be freed while walking because there are children.
 */
static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
                                                gfp_t gfp_mask, bool noswap)
{
        struct mem_cgroup *victim;
        unsigned long start_age;
        int ret = 0;
        int total = 0;

        start_age = root_mem->scan_age;
        /* allows visit twice (under this memcg, ->scan_age is shared.) */
        while (time_after((start_age + 2UL), root_mem->scan_age)) {
                victim = mem_cgroup_select_victim(root_mem);
                ret = try_to_free_mem_cgroup_pages(victim,
                                gfp_mask, noswap, get_swappiness(victim));
                css_put(&victim->css);
                if (mem_cgroup_check_under_limit(root_mem))
                        return 1;
                total += ret;
        }

        ret = total;
        if (mem_cgroup_check_under_limit(root_mem))
                ret = 1;

        return ret;
}
==
This can be reused for soft-limit or something fancy featrues.


Regards,
-Kame

