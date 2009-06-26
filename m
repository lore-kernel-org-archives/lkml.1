Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbZFZIOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbZFZIOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZFZINq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:13:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64826 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbZFZINp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:13:45 -0400
Message-ID: <4A44832B.1020108@cn.fujitsu.com>
Date: Fri, 26 Jun 2009 16:13:31 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: [PATCH 1/2] io-controller: Prepare a rt ioq list in efqd to keep
 track of busy rt ioqs
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-21-git-send-email-vgoyal@redhat.com> <4A3F3648.7080007@cn.fujitsu.com> <20090622172123.GE15600@redhat.com> <4A4079B8.4020402@cn.fujitsu.com> <20090623140250.GA4262@redhat.com> <4A41EFE1.5050101@cn.fujitsu.com>
In-Reply-To: <4A41EFE1.5050101@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintain a busy rt ioq list in efqd so that we can easily
keep track of all busy rt ioqs in system.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    8 ++++++++
 block/elevator-fq.h |    6 ++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index d779282..1d4ec1f 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -3247,6 +3247,10 @@ void elv_add_ioq_busy(struct elv_fq_data *efqd, struct io_queue *ioq)
 	if (elv_ioq_class_rt(ioq)) {
 		struct io_group *iog = ioq_to_io_group(ioq);
 		iog->busy_rt_queues++;
+
+		/* queue lock has been already held by caller */
+		hlist_add_head_rcu(&ioq->rt_node,
+				   &ioq->efqd->rt_ioq_list);
 	}
 
 #ifdef CONFIG_DEBUG_GROUP_IOSCHED
@@ -3293,6 +3297,9 @@ void elv_del_ioq_busy(struct elevator_queue *e, struct io_queue *ioq,
 	if (elv_ioq_class_rt(ioq)) {
 		struct io_group *iog = ioq_to_io_group(ioq);
 		iog->busy_rt_queues--;
+
+		/* queue lock has been already held by caller */
+		hlist_del_rcu(&ioq->rt_node);
 	}
 
 	elv_deactivate_ioq(efqd, ioq, requeue);
@@ -4196,6 +4203,7 @@ int elv_init_fq_data(struct request_queue *q, struct elevator_queue *e)
 
 	INIT_WORK(&efqd->unplug_work, elv_kick_queue);
 	INIT_HLIST_HEAD(&efqd->group_list);
+	INIT_HLIST_HEAD(&efqd->rt_ioq_list);
 
 	efqd->elv_slice[0] = elv_slice_async;
 	efqd->elv_slice[1] = elv_slice_sync;
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index b3193f8..53a64b6 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -169,6 +169,9 @@ struct io_queue {
 	atomic_t ref;
 	unsigned int flags;
 
+	/* node to insert into efqd->rt_ioq_list */
+	struct hlist_node rt_node;
+
 	/* Pointer to generic elevator data structure */
 	struct elv_fq_data *efqd;
 	pid_t pid;
@@ -336,6 +339,9 @@ struct elv_fq_data {
 	/* List of io groups hanging on this elevator */
 	struct hlist_head group_list;
 
+	/* List of rt ioqs in hierarchy*/
+	struct hlist_head rt_ioq_list;
+
 	struct request_queue *queue;
 	unsigned int busy_queues;
 
-- 
1.5.4.rc3


