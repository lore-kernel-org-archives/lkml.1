Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYFKUF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYFKUF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYFKUFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:05:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:6709 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYFKUFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:05:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=C9/KcoqKoNfTtuXzst0mFxlKX27P5Fcr7h7W7h8A1sr7CEtVvw6oy60iXIenHnS0MV
         3x0gJRJ85eBuOSBJ2m6DhwiV14kMAuAk5tFJBYqYGieo64K/OI8FbxrXZNk1MDT4XO7c
         I5oSwvSSEB/fGOuzKydngMPDFA1V2fSdVJENk=
Message-ID: <6de6b1650806111305m51bf2eccocbe0d0c7afee266d@mail.gmail.com>
Date: Wed, 11 Jun 2008 17:05:10 -0300
From: "Rafael Almeida" <almeidaraf@gmail.com>
To: shemminger@linux-foundation.org
Subject: Re: [PATCH] Fixed NetEm's reorder option
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <48479f6a.e203be0a.73e1.fffff59b@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48479f6a.e203be0a.73e1.fffff59b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed no one said anything about my patch below, did I do
something terrible wrong? Should I just be more patient?

On Thu, Jun 5, 2008 at 1:34 AM, Rafael C. de Almeida
<almeidaraf@gmail.com> wrote:
> The reorder option wasn't working correctly. It would only kick in if
> the gap option was set. In that case it would only lower the
> probability of reordering packets because of how the if conditional
> was stated.
>
> This patch separetes the algorithm for reordering with gap from the
> rest, rendering the code more readable and correct.
>
> Signed-off-by: Rafael C. de Almeida <rafaelc@dcc.ufmg.br>
> ---
>  net/sched/sch_netem.c |   45 ++++++++++++++++++++++++++++++++-------------
>  1 files changed, 32 insertions(+), 13 deletions(-)
>
> diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
> index c9c649b..477ee09 100644
> --- a/net/sched/sch_netem.c
> +++ b/net/sched/sch_netem.c
> @@ -206,27 +206,46 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch)
>        }
>
>        cb = (struct netem_skb_cb *)skb->cb;
> -       if (q->gap == 0                 /* not doing reordering */
> -           || q->counter < q->gap      /* inside last reordering gap */
> -           || q->reorder < get_crandom(&q->reorder_cor)) {
> +       if (q->gap) {
> +               /* The comparison of reorder is here to keep compatibility with
> +                * the old behaviour when one had reorder and gap set, maybe it
> +                * could be removed.
> +                */
> +               if (q->counter < q->gap
> +                   || q->reorder < get_crandom(&q->reorder_cor)) {
> +                       psched_time_t now;
> +                       psched_tdiff_t delay;
> +
> +                       delay = tabledist(q->latency, q->jitter,
> +                                         &q->delay_cor, q->delay_dist);
> +
> +                       now = psched_get_time();
> +                       cb->time_to_send = now + delay;
> +                       ++q->counter;
> +                       ret = q->qdisc->enqueue(skb, q->qdisc);
> +               } else {
> +                       /*
> +                        * Do re-ordering by putting one out of N packets at the front
> +                        * of the queue.
> +                        */
> +                       cb->time_to_send = psched_get_time();
> +                       q->counter = 0;
> +                       ret = q->qdisc->ops->requeue(skb, q->qdisc);
> +               }
> +       } else {
>                psched_time_t now;
>                psched_tdiff_t delay;
>
> -               delay = tabledist(q->latency, q->jitter,
> -                                 &q->delay_cor, q->delay_dist);
> +               if (!q->reorder || q->reorder < get_crandom(&q->reorder_cor))
> +                       delay = tabledist(q->latency, q->jitter,
> +                                         &q->delay_cor, q->delay_dist);
> +               else
> +                       delay = 0;
>
>                now = psched_get_time();
>                cb->time_to_send = now + delay;
>                ++q->counter;
>                ret = q->qdisc->enqueue(skb, q->qdisc);
> -       } else {
> -               /*
> -                * Do re-ordering by putting one out of N packets at the front
> -                * of the queue.
> -                */
> -               cb->time_to_send = psched_get_time();
> -               q->counter = 0;
> -               ret = q->qdisc->ops->requeue(skb, q->qdisc);
>        }
>
>        if (likely(ret == NET_XMIT_SUCCESS)) {
> --
> 1.5.5.GIT
>
>
