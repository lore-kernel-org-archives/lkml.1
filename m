Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZICAe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZICAe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 20:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZICAeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 20:34:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50517 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbZICAeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 20:34:24 -0400
Message-ID: <ff8069241ae388c64cbb2d7d8d51fe4e.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <661de9470909021315m3af0de32h29f1ac8fd574249d@mail.gmail.com>
References: <20090902093438.eed47a57.kamezawa.hiroyu@jp.fujitsu.com>
    <20090902093551.c8b171fb.kamezawa.hiroyu@jp.fujitsu.com>
    <20090902145621.83c8a79c.kamezawa.hiroyu@jp.fujitsu.com>
    <661de9470909021315m3af0de32h29f1ac8fd574249d@mail.gmail.com>
Date: Thu, 3 Sep 2009 09:34:23 +0900 (JST)
Subject: Re: [mmotm][PATCH 2/2 v2] memcg: reduce calls for soft limit excess
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh さんは書きました：
> On Wed, Sep 2, 2009 at 11:26 AM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> In charge/uncharge/reclaim path, usage_in_excess is calculated
>> repeatedly and
>> it takes res_counter's spin_lock every time.
>>
>
> I think the changelog needs to mention some refactoring you've done
> below as well, like change new_charge_in_excess to excess.
>
will do when I sent out v3. (and I'll have to do, anyway.)

Bye,
-Kame
>
>
>> This patch removes unnecessary calls for res_count_soft_limit_excess.
>>
>> Changelog:
>> &#160;- fixed description.
>> &#160;- fixed unsigned long to be unsigned long long (Thanks, Nishimura)
>>
>> Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>> &#160;mm/memcontrol.c | &#160; 31 +++++++++++++++----------------
>> &#160;1 file changed, 15 insertions(+), 16 deletions(-)
>>
>> Index: mmotm-2.6.31-Aug27/mm/memcontrol.c
>> ===================================================================
>> --- mmotm-2.6.31-Aug27.orig/mm/memcontrol.c
>> +++ mmotm-2.6.31-Aug27/mm/memcontrol.c
>> @@ -313,7 +313,8 @@ soft_limit_tree_from_page(struct page *p
>> &#160;static void
>> &#160;__mem_cgroup_insert_exceeded(struct mem_cgroup *mem,
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160; &#160; &#160; &#160; &#160;struct mem_cgroup_per_zone
*mz,
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160; &#160; &#160; &#160; struct mem_cgroup_tree_per_zone
*mctz)
>> + &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160; &#160; &#160; &#160; struct mem_cgroup_tree_per_zone
*mctz,
>> + &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160; &#160; &#160; &#160; unsigned long long
new_usage_in_excess)
>> &#160;{
>> &#160; &#160; &#160; &#160;struct rb_node **p = &mctz->rb_root.rb_node;
>> &#160; &#160; &#160; &#160;struct rb_node *parent = NULL;
>> @@ -322,7 +323,9 @@ __mem_cgroup_insert_exceeded(struct mem_
>> &#160; &#160; &#160; &#160;if (mz->on_tree)
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;return;
>>
>> - &#160; &#160; &#160; mz->usage_in_excess =
res_counter_soft_limit_excess(&mem->res);
>> + &#160; &#160; &#160; mz->usage_in_excess = new_usage_in_excess;
>> + &#160; &#160; &#160; if (!mz->usage_in_excess)
>> + &#160; &#160; &#160; &#160; &#160; &#160; &#160; return;
>> &#160; &#160; &#160; &#160;while (*p) {
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;parent = *p;
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;mz_node =
rb_entry(parent, struct mem_cgroup_per_zone,
>> @@ -382,7 +385,7 @@ static bool mem_cgroup_soft_limit_check(
>>
>> &#160;static void mem_cgroup_update_tree(struct mem_cgroup *mem, struct
page *page)
>> &#160;{
>> - &#160; &#160; &#160; unsigned long long new_usage_in_excess;
>> + &#160; &#160; &#160; unsigned long long excess;
>> &#160; &#160; &#160; &#160;struct mem_cgroup_per_zone *mz;
>> &#160; &#160; &#160; &#160;struct mem_cgroup_tree_per_zone *mctz;
>> &#160; &#160; &#160; &#160;int nid = page_to_nid(page);
>> @@ -395,25 +398,21 @@ static void mem_cgroup_update_tree(struc
>> &#160; &#160; &#160; &#160; */
>> &#160; &#160; &#160; &#160;for (; mem; mem = parent_mem_cgroup(mem)) {
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;mz =
mem_cgroup_zoneinfo(mem, nid, zid);
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; new_usage_in_excess =
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; res_counter_soft_limit_excess(&mem->res);
>> + &#160; &#160; &#160; &#160; &#160; &#160; &#160; excess =
res_counter_soft_limit_excess(&mem->res);
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;/*
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; * We have to
update the tree if mz is on RB-tree or
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; * mem is over
its softlimit.
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; */
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; if
(new_usage_in_excess || mz->on_tree) {
>> + &#160; &#160; &#160; &#160; &#160; &#160; &#160; if (excess ||
mz->on_tree) {
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160;spin_lock(&mctz->lock);
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160;/* if on-tree, remove it */
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160;if (mz->on_tree)
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160; &#160; &#160; &#160;
&#160;__mem_cgroup_remove_exceeded(mem, mz, mctz);
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160;/*
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160;* if over soft limit, insert again. mz->usage_in_excess
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160;* will be updated properly.
>> + &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160;* Insert again. mz->usage_in_excess will be updated.
>> + &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160;* If excess is 0, no tree ops.
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160; */
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; if (new_usage_in_excess)
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160; &#160; &#160; &#160; __mem_cgroup_insert_exceeded(mem,
mz, mctz);
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; else
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160; &#160; &#160; &#160; mz->usage_in_excess = 0;
>> + &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; __mem_cgroup_insert_exceeded(mem, mz, mctz, excess);
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160;spin_unlock(&mctz->lock);
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;}
>> &#160; &#160; &#160; &#160;}
>> @@ -2216,6 +2215,7 @@ unsigned long mem_cgroup_soft_limit_recl
>> &#160; &#160; &#160; &#160;unsigned long reclaimed;
>> &#160; &#160; &#160; &#160;int loop = 0;
>> &#160; &#160; &#160; &#160;struct mem_cgroup_tree_per_zone *mctz;
>> + &#160; &#160; &#160; unsigned long long excess;
>>
>> &#160; &#160; &#160; &#160;if (order > 0)
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;return 0;
>> @@ -2260,9 +2260,8 @@ unsigned long mem_cgroup_soft_limit_recl
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160; &#160; &#160; &#160;
&#160;__mem_cgroup_largest_soft_limit_node(mctz);
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; &#160;} while (next_mz == mz);
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;}
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; mz->usage_in_excess =
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; res_counter_soft_limit_excess(&mz->mem->res);
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160;__mem_cgroup_remove_exceeded(mz->mem, mz, mctz);
>> + &#160; &#160; &#160; &#160; &#160; &#160; &#160; excess =
res_counter_soft_limit_excess(&mz->mem->res);
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;/*
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; * One school of
thought says that we should not add
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; * back the node
to the tree if reclaim returns 0.
>> @@ -2271,8 +2270,8 @@ unsigned long mem_cgroup_soft_limit_recl
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; * memory to
reclaim from. Consider this as a longer
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; * term TODO.
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; */
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; if
(mz->usage_in_excess)
>> - &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160; __mem_cgroup_insert_exceeded(mz->mem, mz, mctz);
>> + &#160; &#160; &#160; &#160; &#160; &#160; &#160; /* If excess == 0,
no tree ops */
>> + &#160; &#160; &#160; &#160; &#160; &#160; &#160;
__mem_cgroup_insert_exceeded(mz->mem, mz, mctz, excess);
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160;spin_unlock(&mctz->lock);
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160;
&#160;css_put(&mz->mem->css);
>> &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;loop++;
>
> OK.. so everytime we call __mem_cgroup_insert_exceeded we save one
> res_counter operation.
>
> Looks good
>
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>
> Balbir Singh
>


