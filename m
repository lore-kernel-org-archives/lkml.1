Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZKZGYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZKZGYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 01:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZKZGYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 01:24:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52022 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbZKZGYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 01:24:32 -0500
Message-ID: <4B0E1E2F.9080604@cn.fujitsu.com>
Date: Thu, 26 Nov 2009 14:20:31 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, czoccolo@gmail.com
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] cfq: Make use of service count to estimate the rb_key offset
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens, Czoccolo

For the moment, different workload cfq queues are put into different
service trees. But CFQ still uses "busy_queues" to estimate rb_key 
offset when inserting a cfq queue into a service tree. I think this 
isn't appropriate, and it should make use of service tree count to do 
this estimation. This patch is for for-2.6.33 branch.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1bcbd8c..467981e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -600,11 +600,15 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
 				      struct cfq_queue *cfqq)
 {
+	struct cfq_rb_root *service_tree;
+
+	service_tree = service_tree_for(cfqq_prio(cfqq), cfqq_type(cfqq), cfqd);
+
 	/*
 	 * just an approximation, should be ok.
 	 */
-	return (cfqd->busy_queues - 1) * (cfq_prio_slice(cfqd, 1, 0) -
-		       cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
+	return  service_tree->count * (cfq_prio_slice(cfqd, 1, 0) -
+		   cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
 }
 
 /*
-- 
1.5.4.rc3

-- 
Regards
Gui Jianfeng

