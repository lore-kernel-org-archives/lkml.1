Return-Path: <linux-kernel-owner+w=401wt.eu-S1765315AbZDCOZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765315AbZDCOZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763347AbZDCOZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:25:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:40835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbZDCOZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:25:30 -0400
Date: Fri, 3 Apr 2009 14:24:29 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49D4507E.2060602@cn.fujitsu.com>
References: <49D4507E.2060602@cn.fujitsu.com>
Subject: [tip:tracing/blktrace-v2] blktrace: fix pdu_len when tracing packet command requests
Message-ID: <tip-e2494e1b42ebac402324105d57646489d19e2b01@git.kernel.org>
Git-Commit-ID: e2494e1b42ebac402324105d57646489d19e2b01
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 14:24:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2494e1b42ebac402324105d57646489d19e2b01
Gitweb:     http://git.kernel.org/tip/e2494e1b42ebac402324105d57646489d19e2b01
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 2 Apr 2009 13:43:26 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 15:29:26 +0200

blktrace: fix pdu_len when tracing packet command requests

Impact: output all of packet commands - not just the first 4 / 8 bytes

Since commit d7e3c3249ef23b4617393c69fe464765b4ff1645 ("block: add
large command support"), struct request->cmd has been changed from
unsinged char cmd[BLK_MAX_CDB] to unsigned char *cmd.

v1 -> v2: by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

- make sure rq->cmd_len is always intialized, and then we can use
  rq->cmd_len instead of BLK_MAX_CDB.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
LKML-Reference: <49D4507E.2060602@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index 73d7860..b32ff44 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -643,7 +643,7 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 	if (blk_pc_request(rq)) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
 		__blk_add_trace(bt, 0, rq->data_len, rw, what, rq->errors,
-				sizeof(rq->cmd), rq->cmd);
+				rq->cmd_len, rq->cmd);
 	} else  {
 		what |= BLK_TC_ACT(BLK_TC_FS);
 		__blk_add_trace(bt, rq->hard_sector, rq->hard_nr_sectors << 9,
