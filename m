Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbZC0IdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbZC0IdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 04:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZC0Icp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 04:32:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54634 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbZC0Icn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 04:32:43 -0400
Message-ID: <49CC8EBA.9040804@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 16:30:50 +0800
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
Subject: [PATCH] IO Controller: Don't store the pid in single queue circumstances
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <1236823015-4183-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1236823015-4183-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
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

  Storing a pid in single queue circumstances doesn't make sence.
  So just store the pid when cfq is used.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
 ---
 block/elevator-fq.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index df53418..c72f7e6 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -1988,7 +1988,10 @@ int elv_init_ioq(struct elevator_queue *eq, struct io_queue *ioq,
 	ioq->entity.budget = efqd->elv_slice[is_sync];
 	elv_ioq_set_ioprio_class(ioq, ioprio_class);
 	elv_ioq_set_ioprio(ioq, ioprio);
-	ioq->pid = current->pid;
+	if (elv_iosched_single_ioq(eq))
+		ioq->pid = 0;
+	else
+		ioq->pid = current->pid;
 	ioq->sched_queue = sched_queue;
 
 	/* If generic idle logic is enabled, mark it */
-- 
1.5.4.rc3


