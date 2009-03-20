Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbZCTBtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbZCTBtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760308AbZCTBsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:48:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64461 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758924AbZCTBsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:48:50 -0400
Message-ID: <49C2F614.2010101@cn.fujitsu.com>
Date: Fri, 20 Mar 2009 09:49:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] blktrace: report EBUSY correctly
References: <49C2F599.3060306@cn.fujitsu.com>
In-Reply-To: <49C2F599.3060306@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_trace_remove_queue() returns EINVAL if q->blk_trace == NULL,
but blk_trace_setup_queue() doesn't return EBUSY if q->blk_trace != NULL.

 # echo 0 > sdaX/trace/enable
 # echo 0 > sdaX/trace/enable
 bash: echo: write error: Invalid argument
 # echo 1 > sdaX/trace/enable
 # echo 1 > sdaX/trace/enable
 (should return EBUSY)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 11e7c8d..14986af 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1260,12 +1260,10 @@ static int blk_trace_remove_queue(struct request_queue *q)
 static int blk_trace_setup_queue(struct request_queue *q, dev_t dev)
 {
 	struct blk_trace *old_bt, *bt = NULL;
-	int ret;
 
-	ret = -ENOMEM;
 	bt = kzalloc(sizeof(*bt), GFP_KERNEL);
 	if (!bt)
-		goto err;
+		return -ENOMEM;
 
 	bt->dev = dev;
 	bt->act_mask = (u16)-1;
@@ -1276,11 +1274,10 @@ static int blk_trace_setup_queue(struct request_queue *q, dev_t dev)
 	if (old_bt != NULL) {
 		(void)xchg(&q->blk_trace, old_bt);
 		kfree(bt);
-		ret = -EBUSY;
+		return -EBUSY;
 	}
+
 	return 0;
-err:
-	return ret;
 }
 
 /*
-- 
1.5.4.rc3

