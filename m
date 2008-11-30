Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYK3Muf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYK3Muf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 07:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYK3Mu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 07:50:26 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:51546 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYK3MuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 07:50:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Lq3wooP5R6sOai9an9d8HydlNJp0+CboTAhXU96gsGruFsKSZMwCUTohSZsPzrwS6Z
         tivtuqRuvCCKw53p07tW7cI62MhG15IGfNd54phpWTiuLSFc5CV2PsIDlkjIy4W/SwTs
         0j1lHl6P6ZqyMyvjpkPo2LWOXCXEmlU3QP3MU=
Message-ID: <84144f020811300450m7f450a1eue9ee820db2022ca5@mail.gmail.com>
Date: Sun, 30 Nov 2008 14:50:24 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 02/09] memcg: make inactive_anon_is_low()
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <20081130195508.814B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081130195508.814B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Google-Sender-Auth: 318d46b6b24e7db3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 12:56 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> make inactive_anon_is_low for memcgroup.
> it improve active_anon vs inactive_anon ratio balancing.

The subject line of this patch seems to be truncated and the changelog
seems bit terse. While the change may be obvious to memcg developers,
it's not for the casual reader.

>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  include/linux/memcontrol.h |   10 ++++++++++
>  mm/memcontrol.c            |   38 +++++++++++++++++++++++++++++++++++++-
>  mm/vmscan.c                |   36 +++++++++++++++++++++++-------------
>  3 files changed, 70 insertions(+), 14 deletions(-)
>
> Index: b/include/linux/memcontrol.h
> ===================================================================
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -90,6 +90,8 @@ extern void mem_cgroup_record_reclaim_pr
>
>  extern long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
>                                        int priority, enum lru_list lru);
> +int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
> +                                   struct zone *zone);
>
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
>  extern int do_swap_account;
> @@ -241,6 +243,14 @@ static inline bool mem_cgroup_oom_called
>  {
>        return false;
>  }
> +
> +static inline int
> +mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
> +{
> +       return 1;
> +}
> +
> +

An extra newline here.

>  #endif /* CONFIG_CGROUP_MEM_CONT */
>
>  #endif /* _LINUX_MEMCONTROL_H */
> Index: b/mm/memcontrol.c
> ===================================================================
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -156,6 +156,9 @@ struct mem_cgroup {
>        unsigned long   last_oom_jiffies;
>        int             obsolete;
>        atomic_t        refcnt;
> +
> +       int inactive_ratio;
> +

Is there a reason why this is not unsigned long? A comment here
explaining what ->inactive_ratio is used for would be nice.

> +static void mem_cgroup_set_inactive_ratio(struct mem_cgroup *memcg)
> +{
> +       unsigned int gb, ratio;
> +
> +       gb = res_counter_read_u64(&memcg->res, RES_LIMIT) >> 30;
> +       ratio = int_sqrt(10 * gb);

You might want to consider adding a comment explaining what the above
calculation is supposed to be doing.

> +       if (!ratio)
> +               ratio = 1;
> +
> +       memcg->inactive_ratio = ratio;
> +
> +}
> +
>  static DEFINE_MUTEX(set_limit_mutex);
>
>  static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
> @@ -1381,6 +1411,11 @@ static int mem_cgroup_resize_limit(struc
>                                GFP_HIGHUSER_MOVABLE, false);
>                if (!progress)                  retry_count--;
>        }
> +
> +       if (!ret)
> +               mem_cgroup_set_inactive_ratio(memcg);
> +
> +

An extra newline here.

>        return ret;
>  }
>
> @@ -1423,6 +1458,7 @@ int mem_cgroup_resize_memsw_limit(struct
>                if (curusage >= oldusage)
>                        retry_count--;
>        }
> +
>        return ret;
>  }

There's some diff noise here.
