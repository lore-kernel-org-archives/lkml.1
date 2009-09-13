Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbZIMPCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbZIMPCX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 11:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbZIMPCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 11:02:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:32807 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbZIMPCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 11:02:18 -0400
Date: Sun, 13 Sep 2009 15:01:44 GMT
From: tip-bot for Carsten Emde <Carsten.Emde@osadl.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, Carsten.Emde@osadl.org, tglx@linutronix.de,
       C.Emde@osadl.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Carsten.Emde@osadl.org, tglx@linutronix.de,
       C.Emde@osadl.org
In-Reply-To: <4AAAC9B1.9060505@osadl.org>
References: <4AAAC9B1.9060505@osadl.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: prevent NULL pointer dereference in ftrace_raw_event_block_bio_bounce
Message-ID: <tip-fe63b94a430c0c8058de317f0a8ce921c69dbee4@git.kernel.org>
Git-Commit-ID: fe63b94a430c0c8058de317f0a8ce921c69dbee4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 13 Sep 2009 15:01:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe63b94a430c0c8058de317f0a8ce921c69dbee4
Gitweb:     http://git.kernel.org/tip/fe63b94a430c0c8058de317f0a8ce921c69dbee4
Author:     Carsten Emde <Carsten.Emde@osadl.org>
AuthorDate: Sat, 12 Sep 2009 00:05:37 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Sat, 12 Sep 2009 21:31:19 -0400

tracing: prevent NULL pointer dereference in ftrace_raw_event_block_bio_bounce

Booting 2.6.31 and executing
   echo 1 >/sys/kernel/debug/tracing/events/enable
leads to
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c032a583>] ftrace_raw_event_block_bio_bounce+0x4b/0xb9

Apparently,
   bio = bio_map_user(q, NULL, uaddr, len, reading, gfp_mask);
is called in block/blk-map.c:58 where bio->bi_bdev in set to NULL and
still is NULL when an attempt is made to evaluate bio->bi_bdev->bd_dev
in include/trace/events/block.h:189.

The tracepoint should ensure bio->bi_bdev is not dereferenced, if NULL.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
LKML-Reference: <4AAAC9B1.9060505@osadl.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 include/trace/events/block.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 9a74b46..d86af94 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -171,6 +171,7 @@ TRACE_EVENT(block_rq_complete,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->errors)
 );
+
 TRACE_EVENT(block_bio_bounce,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
@@ -186,7 +187,8 @@ TRACE_EVENT(block_bio_bounce,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->dev		= bio->bi_bdev ?
+					  bio->bi_bdev->bd_dev : 0;
 		__entry->sector		= bio->bi_sector;
 		__entry->nr_sector	= bio->bi_size >> 9;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
