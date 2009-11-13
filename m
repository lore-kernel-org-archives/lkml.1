Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZKMSkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZKMSkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbZKMSkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:40:47 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:62689 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbZKMSkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:40:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r4+hkWG6MXX4uTfXsqGC5QYhf0vnWMWBtomNv5Cp+kqKpmZ2rcOM+XB5aJLo3SsJLt
         Wf0orFQQtmWAdECO2aV+ea3y5ZGhcHgkiILYYtzlDMXQUQCKnLLipShNzxi6O/n25pTs
         xPSgDaX0M6nYG8YcfNkx//fp450TlRwihGVG8=
MIME-Version: 1.0
In-Reply-To: <20091113161506.GF17076@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
	 <1258068756-10766-6-git-send-email-vgoyal@redhat.com>
	 <4e5e476b0911130246m372eb8e8x7b98f13278515a95@mail.gmail.com>
	 <20091113151815.GC17076@redhat.com>
	 <20091113161506.GF17076@redhat.com>
Date: Fri, 13 Nov 2009 19:40:51 +0100
Message-ID: <4e5e476b0911131040l58dc1e04ncbb4be7ca2ca7227@mail.gmail.com>
Subject: Re: [PATCH 05/16] blkio: Implement per cfq group latency target and 
	busy queue avg
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 5:15 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Nov 13, 2009 at 10:18:15AM -0500, Vivek Goyal wrote:
>> On Fri, Nov 13, 2009 at 11:46:49AM +0100, Corrado Zoccolo wrote:
>> > On Fri, Nov 13, 2009 at 12:32 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > >  static inline void
>> > > @@ -441,10 +445,13 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>> > >        if (cfqd->cfq_latency) {
>> > >                /* interested queues (we consider only the ones with the same
>> > >                 * priority class) */
>> > This comment needs to be updated
>>
>> Sure. Will do. Now the interested queues are the one with same priority
>> class with-in group.
>>
>> > >                 * priority class) */
>> > > -               unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
>> > > +               unsigned iq = cfq_group_get_avg_queues(cfqd, cfqq->cfqg,
>> > > +                                               cfq_class_rt(cfqq));
>> > >                unsigned sync_slice = cfqd->cfq_slice[1];
>> > >                unsigned expect_latency = sync_slice * iq;
>> > > -               if (expect_latency > cfq_target_latency) {
>> > > +               unsigned group_target_lat = cfq_target_latency/cfqd->nr_groups;
>> >
>> > I'm not sure that we should divide the target latency evenly among groups.
>> > Groups with different weights will have different percentage of time
>> > in each 300ms round, so probably we should consider it here.
>> >
>>
>> Taking group weight into account will be more precise thing. So may be
>> I can keep track of total weight on the service tree and determine
>> group target latency as proportion of total weight.
>>
>>  group_target_lat = group_weight * cfq_target_latency/total_weight_of_groups
>>
>
> Here is the patch I generated on top of all the patches in series.
>
> o Determine group target latency in proportion to group weight instead of
>  just number of groups.

Great.
I have only one concern, regarding variable naming:
group_target_lat is a bit misleading. The fact is that it will be
larger for higher weight groups, so people could ask why are you
giving more latency to higher weight group...
Actually, it is the group share of the scheduling round, so you should
name it accordingly.

>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/cfq-iosched.c |   21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
>
> Index: linux7/block/cfq-iosched.c
> ===================================================================
> --- linux7.orig/block/cfq-iosched.c     2009-11-13 09:48:38.000000000 -0500
> +++ linux7/block/cfq-iosched.c  2009-11-13 11:06:22.000000000 -0500
> @@ -81,6 +81,7 @@ struct cfq_rb_root {
>        unsigned count;
>        u64 min_vdisktime;
>        struct rb_node *active;
> +       unsigned total_weight;
>  };
>  #define CFQ_RB_ROOT    (struct cfq_rb_root) { RB_ROOT, NULL, 0, 0, }
>
> @@ -521,18 +522,28 @@ static inline unsigned cfq_group_get_avg
>        return cfqg->busy_queues_avg[rt];
>  }
>
> +static inline unsigned
> +cfq_group_latency(struct cfq_data *cfqd, struct cfq_group *cfqg)
> +{
> +       struct cfq_rb_root *st = &cfqd->grp_service_tree;
> +
> +       return cfq_target_latency * cfqg->weight / st->total_weight;
> +}
> +
>  static inline void
>  cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
>        unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
>        if (cfqd->cfq_latency) {
> -               /* interested queues (we consider only the ones with the same
> -                * priority class) */
> +               /*
> +                * interested queues (we consider only the ones with the same
> +                * priority class in the cfq group)
> +                */
>                unsigned iq = cfq_group_get_avg_queues(cfqd, cfqq->cfqg,
>                                                cfq_class_rt(cfqq));
>                unsigned sync_slice = cfqd->cfq_slice[1];
>                unsigned expect_latency = sync_slice * iq;
> -               unsigned group_target_lat = cfq_target_latency/cfqd->nr_groups;
> +               unsigned group_target_lat = cfq_group_latency(cfqd, cfqq->cfqg);
>
>                if (expect_latency > group_target_lat) {
>                        unsigned base_low_slice = 2 * cfqd->cfq_slice_idle;
> @@ -799,6 +810,7 @@ cfq_group_service_tree_add(struct cfq_da
>        __cfq_group_service_tree_add(st, cfqg);
>        cfqg->on_st = true;
>        cfqd->nr_groups++;
> +       st->total_weight += cfqg->weight;
>  }
>
>  static void
> @@ -819,6 +831,7 @@ cfq_group_service_tree_del(struct cfq_da
>        cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
>        cfqg->on_st = false;
>        cfqd->nr_groups--;
> +       st->total_weight -= cfqg->weight;
>        if (!RB_EMPTY_NODE(&cfqg->rb_node))
>                cfq_rb_erase(&cfqg->rb_node, st);
>        cfqg->saved_workload_slice = 0;
> @@ -2033,7 +2046,7 @@ static void choose_service_tree(struct c
>         * proportional to the number of queues in that workload, over
>         * all the queues in the same priority class
>         */
> -       group_target_latency = cfq_target_latency/cfqd->nr_groups;
> +       group_target_latency = cfq_group_latency(cfqd, cfqg);
>
>        slice = group_target_latency * count /
>                max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
