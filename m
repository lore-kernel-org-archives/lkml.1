Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbZCTBso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbZCTBso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbZCTBsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:48:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63138 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755800AbZCTBs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:48:29 -0400
Message-ID: <49C2F5FF.80002@cn.fujitsu.com>
Date: Fri, 20 Mar 2009 09:48:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] blktrace: don't increase blk_probes_ref if failed to
 setup blk trace
References: <49C2F599.3060306@cn.fujitsu.com>
In-Reply-To: <49C2F599.3060306@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_blk_trace_setup() may return EBUSY, but the current code doesn't
decrease blk_probes_ref in this case.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 223b92e..11e7c8d 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -468,9 +468,6 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	bt->pid = buts->pid;
 	bt->trace_state = Blktrace_setup;
 
-	if (atomic_add_return(1, &blk_probes_ref) == 1)
-		blk_register_tracepoints();
-
 	ret = -EBUSY;
 	old_bt = xchg(&q->blk_trace, bt);
 	if (old_bt) {
@@ -478,6 +475,9 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 		goto err;
 	}
 
+	if (atomic_add_return(1, &blk_probes_ref) == 1)
+		blk_register_tracepoints();
+
 	return 0;
 err:
 	if (bt) {
-- 
1.5.4.rc3

