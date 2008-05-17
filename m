Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbYEQCXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbYEQCXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 22:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYEQCXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 22:23:32 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:45293 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbYEQCXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 22:23:31 -0400
To: "kernel list" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC Patch 5/5] Blktrace - Remove trace_state and associated flags from blktrace.[ch]
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
Organization: IBM
Cc: dwilder@us.ibm.com, axboe@kernel.dk, linux-btrace@vger.kernel.org,
       akpm@linux-foundation.org, prasad@linux.vnet.ibm.com
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080516164644.GA22928@in.ibm.com> <op.ua9a61lw03j166@prasadkr_t60p.in.ibm.com>
Content-Transfer-Encoding: 8BIT
Date: Sat, 17 May 2008 07:53:27 +0530
Message-ID: <op.ua90xdqx03j166@prasadkr_t60p.in.ibm.com>
In-Reply-To: <op.ua9a61lw03j166@prasadkr_t60p.in.ibm.com>
User-Agent: Opera Mail/9.26 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sending the patch due to style issues found in the previous version.

This patch removes the 'trace_state' flag from blk_trace structure, since  
the
state transitions will now be managed using 'trace' infrastructure.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
  block/blktrace.c             |   26 +++++++-------------------
  include/linux/blktrace_api.h |    7 -------
  2 files changed, 7 insertions(+), 26 deletions(-)

Index: linux-blktrace-many/include/linux/blktrace_api.h
===================================================================
--- linux-blktrace-many.orig/include/linux/blktrace_api.h
+++ linux-blktrace-many/include/linux/blktrace_api.h
@@ -110,14 +110,7 @@ struct blk_io_trace_remap {
  	__be64 sector;
  };

-enum {
-	Blktrace_setup = 1,
-	Blktrace_running,
-	Blktrace_stopped,
-};
-
  struct blk_trace {
-	int trace_state;
  	unsigned long *sequence;
  	u16 act_mask;
  	u64 start_lba;
Index: linux-blktrace-many/block/blktrace.c
===================================================================
--- linux-blktrace-many.orig/block/blktrace.c
+++ linux-blktrace-many/block/blktrace.c
@@ -127,9 +127,6 @@ void __blk_add_trace(struct blk_trace *b
  	pid_t pid;
  	int cpu;

-	if (unlikely(bt->trace_state != Blktrace_running))
-		return;
-
  	what |= ddir_act[rw & WRITE];
  	what |= bio_act[trace_barrier_bit(rw)];
  	what |= bio_act[trace_sync_bit(rw)];
@@ -199,8 +196,7 @@ int blk_trace_remove(struct request_queu
  	if (!bt)
  		return -EINVAL;

-	if (bt->trace_state == Blktrace_setup ||
-	    bt->trace_state == Blktrace_stopped)
+	if (!trace_running(bt->tpk->ti))
  		blk_trace_cleanup(bt);

  	return 0;
@@ -262,7 +258,6 @@ int do_blk_trace_setup(struct request_qu
  		bt->end_lba = -1ULL;

  	bt->pid = buts->pid;
-	bt->trace_state = Blktrace_setup;

  	ret = -EBUSY;
  	old_bt = xchg(&q->blk_trace, bt);
@@ -319,20 +314,13 @@ int blk_trace_startstop(struct request_q
  	 */
  	ret = -EINVAL;
  	if (start) {
-		if (bt->trace_state == Blktrace_setup ||
-		    bt->trace_state == Blktrace_stopped) {
-			blktrace_seq++;
-			smp_mb();
-			bt->trace_state = Blktrace_running;
-
-			trace_note_time(bt);
-			ret = 0;
-		}
+		blktrace_seq++;
+		smp_mb();
+		trace_note_time(bt);
+		ret = 0;
  	} else {
-		if (bt->trace_state == Blktrace_running) {
-			bt->trace_state = Blktrace_stopped;
-			ret = 0;
-		}
+		trace_stop(bt->tpk->ti);
+		ret = 0;
  	}

  	return ret;
