Return-Path: <linux-kernel-owner+w=401wt.eu-S934722AbZDBCR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934722AbZDBCR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 22:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934534AbZDBCRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 22:17:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762811AbZDBCRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 22:17:03 -0400
Message-ID: <49D42036.5010102@cn.fujitsu.com>
Date: Thu, 02 Apr 2009 10:17:26 +0800
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug has been here since 2.6.26.

=======

Since commit d7e3c3249ef23b4617393c69fe464765b4ff1645 ("block: add
large command support"), struct request->cmd has been changed from
unsinged char cmd[BLK_MAX_CDB] to unsigned char *cmd.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index fd1ff49..bafb8d3 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -642,7 +642,7 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 	if (blk_pc_request(rq)) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
 		__blk_add_trace(bt, 0, rq->data_len, rw, what, rq->errors,
-				sizeof(rq->cmd), rq->cmd);
+				max_t(int, rq->cmd_len, BLK_MAX_CDB), rq->cmd);
 	} else  {
 		what |= BLK_TC_ACT(BLK_TC_FS);
 		__blk_add_trace(bt, rq->hard_sector, rq->hard_nr_sectors << 9,
-- 
1.5.4.rc3

