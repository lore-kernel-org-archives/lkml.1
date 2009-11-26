Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbZKZJId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbZKZJId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZKZJIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:08:32 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:58063 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZKZJIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:08:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kgrt3YEsx+IGYdAK1eAgGEH1h2p/3I3tkDenGhKr5i1J3P71RWwqEfBhq8d5t2XU8H
         sfagkRwbw0RdW9xfVn83q6ishOmK+jbLdRxp8FYwISQQxebrrAE1HZgFywm+EjLHtLKt
         NPf19n+RfHcpjaBGx9nSaxQTJlz1XyfSGvS2s=
MIME-Version: 1.0
In-Reply-To: <4B0E1E2F.9080604@cn.fujitsu.com>
References: <4B0E1E2F.9080604@cn.fujitsu.com>
Date: Thu, 26 Nov 2009 10:08:36 +0100
Message-ID: <4e5e476b0911260108s2fe4cd86lcb32c7be76b4f75c@mail.gmail.com>
Subject: Re: [PATCH] cfq: Make use of service count to estimate the rb_key 
	offset
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gui, Jens
On Thu, Nov 26, 2009 at 7:20 AM, Gui Jianfeng
<guijianfeng@cn.fujitsu.com> wrote:
> Hi Jens, Czoccolo
>
> For the moment, different workload cfq queues are put into different
> service trees. But CFQ still uses "busy_queues" to estimate rb_key
> offset when inserting a cfq queue into a service tree. I think this
> isn't appropriate, and it should make use of service tree count to do
> this estimation. This patch is for for-2.6.33 branch.

In cfq_choose_wl, we rely on consistency of rb_keys across service
trees to compute the next workload to be serviced.
        for (i = 0; i < 3; ++i) {
                /* otherwise, select the one with lowest rb_key */
                queue = cfq_rb_first(service_tree_for(prio, i, cfqd));
                if (queue &&
                    (!key_valid || time_before(queue->rb_key, lowest_key))) {
                        lowest_key = queue->rb_key;
			cur_best = i;
			key_valid = true;
		}
        }

If you change how the rb_key is computed (so it is no longer
consistent across service trees) without changing how it is used can
introduce problems.

Thanks,
Corrado

>
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 1bcbd8c..467981e 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -600,11 +600,15 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
>                                      struct cfq_queue *cfqq)
>  {
> +       struct cfq_rb_root *service_tree;
> +
> +       service_tree = service_tree_for(cfqq_prio(cfqq), cfqq_type(cfqq), cfqd);
> +
>        /*
>         * just an approximation, should be ok.
>         */
> -       return (cfqd->busy_queues - 1) * (cfq_prio_slice(cfqd, 1, 0) -
> -                      cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
> +       return  service_tree->count * (cfq_prio_slice(cfqd, 1, 0) -
> +                  cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
>  }
>
>  /*
> --
> 1.5.4.rc3
>
> --
> Regards
> Gui Jianfeng
>
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
