Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYHUI2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYHUI2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYHUI22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:28:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52409 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbYHUI2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:28:25 -0400
Date: Thu, 21 Aug 2008 17:34:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH -mm 0/7] memcg: lockless page_cgroup v1
Message-Id: <20080821173442.b9234f26.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080820200006.a152c14c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
	<20080820185306.e897c512.kamezawa.hiroyu@jp.fujitsu.com>
	<20080820194108.e76b20b3.kamezawa.hiroyu@jp.fujitsu.com>
	<20080820200006.a152c14c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 20:00:06 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Known problem: force_emtpy is broken...so rmdir will struck into nightmare.
> > It's because of patch 2/7.
> > will be fixed in the next version.
> > 
> 
This is a new routine for force_empty. Assumes init_mem_cgroup has no limit.
(lockless page_cgroup is also applied.)

I think this routine is enough generic to be enhanced for hierarchy in future.
I think move_account() routine can be used for other purpose.
(for example, move_task.)


==
int mem_cgroup_move_account(struct page *page, struct page_cgroup *pc,
        struct mem_cgroup *from, struct mem_cgroup *to)
{
        struct mem_cgroup_per_zone *from_mz, *to_mz;
        int nid, zid;
        int ret = 1;

        VM_BUG_ON(to->no_limit == 0);
        VM_BUG_ON(!irqs_disabled());

        nid = page_to_nid(page);
        zid = page_zonenum(page);
        from_mz =  mem_cgroup_zoneinfo(from, nid, zid);
        to_mz =  mem_cgroup_zoneinfo(to, nid, zid);

        if (res_counter_charge(&to->res, PAGE_SIZE)) {
                /* Now, we assume no_limit...no failure here. */
                return ret;
        }

        if (spin_trylock(&to_mz->lru_lock)) {
                __mem_cgroup_remove_list(from_mz, pc);
                css_put(&from->css);
                res_counter_uncharge(&from->res, PAGE_SIZE);
                pc->mem_cgroup = to;
                css_get(&to->css);
                __mem_cgroup_add_list(to_mz, pc);
                ret = 0;
                spin_unlock(&to_mz->lru_lock);
        } else {
                res_counter_uncharge(&to->res, PAGE_SIZE);
        }

        return ret;
}
/*
 * This routine moves all account to root cgroup.
 */
static void mem_cgroup_force_empty_list(struct mem_cgroup *mem,
                            struct mem_cgroup_per_zone *mz,
                            enum lru_list lru)
{
        struct page_cgroup *pc;
        unsigned long flags;
        struct list_head *list;
        int drain = 0;

        list = &mz->lists[lru];

        spin_lock_irqsave(&mz->lru_lock, flags);
        while (!list_empty(list)) {
                pc = list_entry(list->prev, struct page_cgroup, lru);
                if (PcgObsolete(pc)) {
                        list_move(&pc->lru, list);
                        /* This page_cgroup may remain on this list until
                           we drain it. */
                        if (drain++ > MEMCG_LRU_THRESH/2) {
                                spin_unlock_irqrestore(&mz->lru_lock, flags);
                                mem_cgroup_all_force_drain();
                                yield();
                                drain = 0;
                                spin_lock_irqsave(&mz->lru_lock, flags);
                        }
                        continue;
                }
                if (mem_cgroup_move_account(page, pc->page,
                                                mem, &init_mem_cgroup)) {
                        /* some confliction */
                        list_move(&pc->lru, list);
                        spin_unlock_irqrestore(&mz->lru_lock, flags);
                        yield();
                        spin_lock_irqsave(&mz->lru_lock, flags);
                }
                if (atomic_read(&mem->css.cgroup->count) > 0)
                        break;
        }
        spin_unlock_irqrestore(&mz->lru_lock, flags);
}
==

