Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbZCUPVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbZCUPVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 11:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbZCUPTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 11:19:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:52343 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572AbZCUPTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 11:19:50 -0400
Date: Sat, 21 Mar 2009 15:19:02 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C2F614.2010101@cn.fujitsu.com>
References: <49C2F614.2010101@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: report EBUSY correctly
Message-ID: <tip-15152e448b693fa41de40f1e40ffbe717a3aab88@git.kernel.org>
Git-Commit-ID: 15152e448b693fa41de40f1e40ffbe717a3aab88
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Mar 2009 15:19:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15152e448b693fa41de40f1e40ffbe717a3aab88
Gitweb:     http://git.kernel.org/tip/15152e448b693fa41de40f1e40ffbe717a3aab88
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 20 Mar 2009 09:49:08 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Mar 2009 16:16:54 +0100

blktrace: report EBUSY correctly

blk_trace_remove_queue() returns EINVAL if q->blk_trace == NULL,
but blk_trace_setup_queue() doesn't return EBUSY if
q->blk_trace != NULL.

 # echo 0 > sdaX/trace/enable
 # echo 0 > sdaX/trace/enable
 bash: echo: write error: Invalid argument
 # echo 1 > sdaX/trace/enable
 # echo 1 > sdaX/trace/enable
 (should return EBUSY)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <49C2F614.2010101@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
