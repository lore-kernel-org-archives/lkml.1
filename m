Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbZL3MJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbZL3MJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZL3MJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:09:53 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37506 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbZL3MJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:09:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gyV8tpjssAv4HAA3xUQ95qs8Yc+TPjM/XNyAiYeIOLmXTOx24DOKiHWCuU9HPTYXL6
         neyiDG94S/9yhEpwv3BNZWG3LcsUCGVaecsS1P6xd+UCtAgnFAIGuYlLeIBd3OKG4DX5
         xl8+/5fDhy9SGIZ+4ErpPfU7pOdYUf6388PiU=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: [PATCH] cfq-iosched: non-rot devices do not need queue merging
Date: Wed, 30 Dec 2009 13:10:04 +0100
Message-Id: <1262175004-2132-1-git-send-email-czoccolo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non rotational devices' performances are not affected by
distance of requests, so there is no point in having overhead
to merge queues of nearby requests.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 918c7fd..01bb0f3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1268,7 +1268,8 @@ static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		return;
 	if (!cfqq->next_rq)
 		return;
-
+	if (blk_queue_nonrot(cfqd->queue))
+		return;
 	cfqq->p_root = &cfqd->prio_trees[cfqq->org_ioprio];
 	__cfqq = cfq_prio_tree_lookup(cfqd, cfqq->p_root,
 				      blk_rq_pos(cfqq->next_rq), &parent, &p);
@@ -1689,7 +1690,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
 	struct cfq_queue *__cfqq;
 	sector_t sector = cfqd->last_position;
 
-	if (RB_EMPTY_ROOT(root))
+	if (RB_EMPTY_ROOT(root) || blk_queue_nonrot(cfqd->queue))
 		return NULL;
 
 	/*
-- 
1.6.4.4

