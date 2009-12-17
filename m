Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbZLQLtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbZLQLtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 06:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZLQLtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 06:49:21 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:47093 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbZLQLtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 06:49:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PNgOda70Fa9UEvQ0tnEuvG7zpUsvH1lcDzyWzE8Q9J2FTqeYGQ+9nVn4sfk31G6AWh
         SMDA/Tad5+bSPSfRdhvwQP0zb/uxjCVh+aDgApNe3BGkSecjLfI2HabDK2pCr8O/W8Z5
         MfHZXbGieu+baKjCHlR5CX/5SCZ7lSL5kFYvo=
MIME-Version: 1.0
In-Reply-To: <1261003980-10115-4-git-send-email-vgoyal@redhat.com>
References: <1261003980-10115-1-git-send-email-vgoyal@redhat.com>
	 <1261003980-10115-4-git-send-email-vgoyal@redhat.com>
Date: Thu, 17 Dec 2009 12:49:18 +0100
Message-ID: <4e5e476b0912170349l3900867bj547059fc7e487d77@mail.gmail.com>
Subject: Re: [PATCH 3/4] cfq-iosched: Remove prio_change logic for workload 
	selection
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       m-ikeda@ds.jp.nec.com, Alan.Brunelle@hp.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 11:52 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> o CFQ now internally divides cfq queues in therr workload categories. sync-idle,
>  sync-noidle and async. Which workload to run depends primarily on rb_key
>  offset across three service trees. Which is a combination of mulitiple things
>  including what time queue got queued on the service tree.
>
>  There is one exception though. That is if we switched the prio class, say
>  we served some RT tasks and again started serving BE class, then with-in
>  BE class we always started with sync-noidle workload irrespective of rb_key
>  offset in service trees.
>
>  This can provide better latencies for sync-noidle workload in the presence
>  of RT tasks.
>
> o This patch gets rid of that exception and which workload to run with-in
>  class always depends on lowest rb_key across service trees. The reason
>  being that now we have multiple BE class groups and if we always switch
>  to sync-noidle workload with-in group, we can potentially starve a sync-idle
>  workload with-in group. Same is true for async workload which will be in
>  root group. Also the workload-switching with-in group will become very
>  unpredictable as it now depends whether some RT workload was running in
>  the system or not.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/cfq-iosched.c |   48 ++++++++++++------------------------------------
>  1 files changed, 12 insertions(+), 36 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index d9bfa09..8df4fe5 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -292,8 +292,7 @@ static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
>
>  static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
>                                            enum wl_prio_t prio,
> -                                           enum wl_type_t type,
> -                                           struct cfq_data *cfqd)
> +                                           enum wl_type_t type)
>  {
>        if (!cfqg)
>                return NULL;
> @@ -1146,7 +1145,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  #endif
>
>        service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
> -                                               cfqq_type(cfqq), cfqd);
> +                                               cfqq_type(cfqq));
>        if (cfq_class_idle(cfqq)) {
>                rb_key = CFQ_IDLE_DELAY;
>                parent = rb_last(&service_tree->rb);
> @@ -1609,7 +1608,7 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
>  {
>        struct cfq_rb_root *service_tree =
>                service_tree_for(cfqd->serving_group, cfqd->serving_prio,
> -                                       cfqd->serving_type, cfqd);
> +                                       cfqd->serving_type);
>
>        if (!cfqd->rq_queued)
>                return NULL;
> @@ -1956,8 +1955,7 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
>  }
>
>  static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
> -                               struct cfq_group *cfqg, enum wl_prio_t prio,
> -                               bool prio_changed)
> +                               struct cfq_group *cfqg, enum wl_prio_t prio)
>  {
>        struct cfq_queue *queue;
>        int i;
> @@ -1965,24 +1963,9 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>        unsigned long lowest_key = 0;
>        enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
>
> -       if (prio_changed) {
> -               /*
> -                * When priorities switched, we prefer starting
> -                * from SYNC_NOIDLE (first choice), or just SYNC
> -                * over ASYNC
> -                */
> -               if (service_tree_for(cfqg, prio, cur_best, cfqd)->count)
> -                       return cur_best;
> -               cur_best = SYNC_WORKLOAD;
> -               if (service_tree_for(cfqg, prio, cur_best, cfqd)->count)
> -                       return cur_best;
> -
> -               return ASYNC_WORKLOAD;
> -       }
> -
> -       for (i = 0; i < 3; ++i) {
> -               /* otherwise, select the one with lowest rb_key */
> -               queue = cfq_rb_first(service_tree_for(cfqg, prio, i, cfqd));
> +       for (i = 0; i <= SYNC_WORKLOAD; ++i) {
> +               /* select the one with lowest rb_key */
> +               queue = cfq_rb_first(service_tree_for(cfqg, prio, i));
>                if (queue &&
>                    (!key_valid || time_before(queue->rb_key, lowest_key))) {
>                        lowest_key = queue->rb_key;
> @@ -1996,8 +1979,6 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>
>  static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  {
> -       enum wl_prio_t previous_prio = cfqd->serving_prio;
> -       bool prio_changed;
>        unsigned slice;
>        unsigned count;
>        struct cfq_rb_root *st;
> @@ -2025,24 +2006,19 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
>         * (SYNC, SYNC_NOIDLE, ASYNC), and to compute a workload
>         * expiration time
>         */
> -       prio_changed = (cfqd->serving_prio != previous_prio);
> -       st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
> -                               cfqd);
> +       st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
>        count = st->count;
>
>        /*
> -        * If priority didn't change, check workload expiration,
> -        * and that we still have other queues ready
> +        * check workload expiration, and that we still have other queues ready
>         */
> -       if (!prio_changed && count &&
> -           !time_after(jiffies, cfqd->workload_expires))
> +       if (count && !time_after(jiffies, cfqd->workload_expires))
>                return;
>
>        /* otherwise select new workload type */
>        cfqd->serving_type =
> -               cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio, prio_changed);
> -       st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
> -                               cfqd);
> +               cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio);
> +       st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
>        count = st->count;
>
>        /*
> --
> 1.6.2.5
>
>

Acked-by: Corrado Zoccolo <czoccolo@gmail.com>
