Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbZCSG3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbZCSG3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbZCSG3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:29:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60569 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbZCSG27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:28:59 -0400
Message-ID: <49C1E5C2.5000107@cn.fujitsu.com>
Date: Thu, 19 Mar 2009 14:27:14 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Subject: Re: [PATCH 02/10] Common flat fair queuing code in elevaotor layer
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <1236823015-4183-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1236823015-4183-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> +
> +int elv_init_ioq(struct elevator_queue *eq, struct io_queue *ioq,
> +			void *sched_queue, int ioprio_class, int ioprio,
> +			int is_sync)
> +{
> +	struct elv_fq_data *efqd = &eq->efqd;
> +	struct io_group *iog = io_lookup_io_group_current(efqd->queue);
> +
> +	RB_CLEAR_NODE(&ioq->entity.rb_node);
> +	atomic_set(&ioq->ref, 0);
> +	ioq->efqd = efqd;
> +	ioq->entity.budget = efqd->elv_slice[is_sync];
> +	elv_ioq_set_ioprio_class(ioq, ioprio_class);
> +	elv_ioq_set_ioprio(ioq, ioprio);
> +	ioq->pid = current->pid;

  Hi Vivek,

  If we are using a scheduler other than cfq, IOW single ioq is used.
  that storing a pid to the ioq makes no sense, it just stores the first 
  serviced task.

> +	ioq->sched_queue = sched_queue;
> +	elv_mark_ioq_idle_window(ioq);
> +	bfq_init_entity(&ioq->entity, iog);
> +	return 0;
> +}
> +EXPORT_SYMBOL(elv_init_ioq);
...
> +
> +extern int elv_slice_idle;
> +extern int elv_slice_async;
> +
> +/* Logging facilities. */
> +#define elv_log_ioq(efqd, ioq, fmt, args...) \
> +	blk_add_trace_msg((efqd)->queue, "%d" fmt, (ioq)->pid, ##args)

   Maybe we need to use current->pid instead, for ioq->pid is not valid
   sometimes.

> +
> +#define elv_log(efqd, fmt, args...) \
> +	blk_add_trace_msg((efqd)->queue, "" fmt, ##args)
> +
> +#define ioq_sample_valid(samples)   ((samples) > 80)
> +


-- 
Regards
Gui Jianfeng

