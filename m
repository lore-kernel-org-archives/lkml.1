Return-Path: <linux-kernel-owner+w=401wt.eu-S1765515AbZDBFnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765515AbZDBFnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZDBFnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:43:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59185 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbZDBFnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:43:00 -0400
Message-ID: <49D4507E.2060602@cn.fujitsu.com>
Date: Thu, 02 Apr 2009 13:43:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] blktrace: fix pdu_len when tracing packet command requests
References: <49D42036.5010102@cn.fujitsu.com>
In-Reply-To: <49D42036.5010102@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit d7e3c3249ef23b4617393c69fe464765b4ff1645 ("block: add
large command support"), struct request->cmd has been changed from
unsinged char cmd[BLK_MAX_CDB] to unsigned char *cmd.

v1 -> v2:
- make sure rq->cmd_len is always intialized, and then we can use
  rq->cmd_len instead of BLK_MAX_CDB.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 block/blk-core.c        |    1 +
 kernel/trace/blktrace.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 29bcfac..859879d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -132,6 +132,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->cmd = rq->__cmd;
+	rq->cmd_len = BLK_MAX_CDB;
 	rq->tag = -1;
 	rq->ref_count = 1;
 }
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 947c5b3..cc6a9c2 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -642,7 +642,7 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 	if (blk_pc_request(rq)) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
 		__blk_add_trace(bt, 0, rq->data_len, rw, what, rq->errors,
-				sizeof(rq->cmd), rq->cmd);
+				rq->cmd_len, rq->cmd);
 	} else  {
 		what |= BLK_TC_ACT(BLK_TC_FS);
 		__blk_add_trace(bt, rq->hard_sector, rq->hard_nr_sectors << 9,
-- 
1.5.4.rc3


