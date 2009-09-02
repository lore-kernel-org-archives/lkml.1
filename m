Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbZIBUPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbZIBUPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 16:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZIBUPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 16:15:06 -0400
Received: from mail-px0-f204.google.com ([209.85.216.204]:43148 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZIBUPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 16:15:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=r4HrP2VTNNnrmHzrnctC1YwLDuYmhMzAk8GAQ0cX243snm4iCixMJU23zrKqbDsYjO
         ZBa+6N9//IXJXRVwRGQhabpFIV/qwLvD22gWBObQLVr94zj31gi7ut1cbvhIRy3uqToR
         QECgtr7RKErz7a0PGtPCemsk8ULhGygB/9wbE=
MIME-Version: 1.0
In-Reply-To: <20090902145621.83c8a79c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090902093438.eed47a57.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090902093551.c8b171fb.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090902145621.83c8a79c.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 3 Sep 2009 01:45:06 +0530
X-Google-Sender-Auth: 57f8f0181a6e0c82
Message-ID: <661de9470909021315m3af0de32h29f1ac8fd574249d@mail.gmail.com>
Subject: Re: [mmotm][PATCH 2/2 v2] memcg: reduce calls for soft limit excess
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 2, 2009 at 11:26 AM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> In charge/uncharge/reclaim path, usage_in_excess is calculated repeatedly and
> it takes res_counter's spin_lock every time.
>

I think the changelog needs to mention some refactoring you've done
below as well, like change new_charge_in_excess to excess.



> This patch removes unnecessary calls for res_count_soft_limit_excess.
>
> Changelog:
>  - fixed description.
>  - fixed unsigned long to be unsigned long long (Thanks, Nishimura)
>
> Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |   31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
>
> Index: mmotm-2.6.31-Aug27/mm/memcontrol.c
> ===================================================================
> --- mmotm-2.6.31-Aug27.orig/mm/memcontrol.c
> +++ mmotm-2.6.31-Aug27/mm/memcontrol.c
> @@ -313,7 +313,8 @@ soft_limit_tree_from_page(struct page *p
>  static void
>  __mem_cgroup_insert_exceeded(struct mem_cgroup *mem,
>                                struct mem_cgroup_per_zone *mz,
> -                               struct mem_cgroup_tree_per_zone *mctz)
> +                               struct mem_cgroup_tree_per_zone *mctz,
> +                               unsigned long long new_usage_in_excess)
>  {
>        struct rb_node **p = &mctz->rb_root.rb_node;
>        struct rb_node *parent = NULL;
> @@ -322,7 +323,9 @@ __mem_cgroup_insert_exceeded(struct mem_
>        if (mz->on_tree)
>                return;
>
> -       mz->usage_in_excess = res_counter_soft_limit_excess(&mem->res);
> +       mz->usage_in_excess = new_usage_in_excess;
> +       if (!mz->usage_in_excess)
> +               return;
>        while (*p) {
>                parent = *p;
>                mz_node = rb_entry(parent, struct mem_cgroup_per_zone,
> @@ -382,7 +385,7 @@ static bool mem_cgroup_soft_limit_check(
>
>  static void mem_cgroup_update_tree(struct mem_cgroup *mem, struct page *page)
>  {
> -       unsigned long long new_usage_in_excess;
> +       unsigned long long excess;
>        struct mem_cgroup_per_zone *mz;
>        struct mem_cgroup_tree_per_zone *mctz;
>        int nid = page_to_nid(page);
> @@ -395,25 +398,21 @@ static void mem_cgroup_update_tree(struc
>         */
>        for (; mem; mem = parent_mem_cgroup(mem)) {
>                mz = mem_cgroup_zoneinfo(mem, nid, zid);
> -               new_usage_in_excess =
> -                       res_counter_soft_limit_excess(&mem->res);
> +               excess = res_counter_soft_limit_excess(&mem->res);
>                /*
>                 * We have to update the tree if mz is on RB-tree or
>                 * mem is over its softlimit.
>                 */
> -               if (new_usage_in_excess || mz->on_tree) {
> +               if (excess || mz->on_tree) {
>                        spin_lock(&mctz->lock);
>                        /* if on-tree, remove it */
>                        if (mz->on_tree)
>                                __mem_cgroup_remove_exceeded(mem, mz, mctz);
>                        /*
> -                        * if over soft limit, insert again. mz->usage_in_excess
> -                        * will be updated properly.
> +                        * Insert again. mz->usage_in_excess will be updated.
> +                        * If excess is 0, no tree ops.
>                         */
> -                       if (new_usage_in_excess)
> -                               __mem_cgroup_insert_exceeded(mem, mz, mctz);
> -                       else
> -                               mz->usage_in_excess = 0;
> +                       __mem_cgroup_insert_exceeded(mem, mz, mctz, excess);
>                        spin_unlock(&mctz->lock);
>                }
>        }
> @@ -2216,6 +2215,7 @@ unsigned long mem_cgroup_soft_limit_recl
>        unsigned long reclaimed;
>        int loop = 0;
>        struct mem_cgroup_tree_per_zone *mctz;
> +       unsigned long long excess;
>
>        if (order > 0)
>                return 0;
> @@ -2260,9 +2260,8 @@ unsigned long mem_cgroup_soft_limit_recl
>                                __mem_cgroup_largest_soft_limit_node(mctz);
>                        } while (next_mz == mz);
>                }
> -               mz->usage_in_excess =
> -                       res_counter_soft_limit_excess(&mz->mem->res);
>                __mem_cgroup_remove_exceeded(mz->mem, mz, mctz);
> +               excess = res_counter_soft_limit_excess(&mz->mem->res);
>                /*
>                 * One school of thought says that we should not add
>                 * back the node to the tree if reclaim returns 0.
> @@ -2271,8 +2270,8 @@ unsigned long mem_cgroup_soft_limit_recl
>                 * memory to reclaim from. Consider this as a longer
>                 * term TODO.
>                 */
> -               if (mz->usage_in_excess)
> -                       __mem_cgroup_insert_exceeded(mz->mem, mz, mctz);
> +               /* If excess == 0, no tree ops */
> +               __mem_cgroup_insert_exceeded(mz->mem, mz, mctz, excess);
>                spin_unlock(&mctz->lock);
>                css_put(&mz->mem->css);
>                loop++;

OK.. so everytime we call __mem_cgroup_insert_exceeded we save one
res_counter operation.

Looks good

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Balbir Singh
